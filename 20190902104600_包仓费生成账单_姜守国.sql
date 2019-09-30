/*
每日凌晨00:00:00执行包仓费账单生成,生成当天的账单记录，金额都为0
*/
IF OBJECT_ID('P_GenerateWarehouseFeeBill', 'P') IS NOT NULL   
    DROP PROCEDURE P_GenerateWarehouseFeeBill
GO 
CREATE PROCEDURE P_GenerateWarehouseFeeBill
AS

DECLARE @today varchar(10) = CONVERT(varchar(10), GETDATE(), 120)
DECLARE @tomorrow varchar(10) = CONVERT(varchar(10), DATEADD(d, 1, @today), 120)

/*
TRUNCATE TABLE FN_WarehousePositionFeeBillDetails
TRUNCATE TABLE FN_WarehousePositionFeeBill

SELECT * FROM FN_WarehousePositionFeeBill
SELECT * FROM FN_WarehousePositionFeeBillDetails
--*/

/*测试
SET @today = '2019-9-18'
DELETE FROM FN_WarehousePositionFeeBillDetails WHERE BillId IN (SELECT Id FROM FN_WarehousePositionFeeBill WHERE BillTime = @today)
DELETE FROM FN_WarehousePositionFeeBill WHERE BillTime = @today
--*/

--当天账单已经生成后不再重复生成
IF EXISTS (SELECT * FROM FN_WarehousePositionFeeBill WHERE BillTime = @today)
BEGIN
	PRINT '已经生成过'
	RETURN
END

BEGIN TRANSACTION t1
BEGIN TRY
	--统计线路数据到表变量中
	DECLARE @LineTable TABLE (WarehouseId int, LineCode nvarchar(100), LineName nvarchar(100), DetailsCount int, LineCityName nvarchar(100))
	INSERT INTO @LineTable 
	SELECT WarehouseId, LineCode, LineName, COUNT(*),
		STUFF((SELECT ',' + LineCityName FROM Bas_WPF_Line WHERE a.WarehouseId = WarehouseId AND a.LineCode = LineCode AND a.LineName = LineName FOR XML PATH('')),1,1,'') AS LineCityName 
	FROM Bas_WPF_Line a
	GROUP BY WarehouseId, LineCode, LineName

	--插入包仓费账单主表数据
	INSERT INTO FN_WarehousePositionFeeBill (WarehouseId,IsAbnormal,IsDeduct,BillTime,StationID,StationName,WarehouseStationID,WarehouseStationName,LineCode,LineName,LineCityName,
		FeeCycle, FeeType, SubGoodsQuantity, SettlementWeightUpLimit,ActualWeightUpLimit,VolumeUpLimit, DetailsCount, WarehouseFee,
		Remark,CreateStationID,CreateStationName,CreateUserID,CreateUserName,UpdateUserID,UpdateUserName) 
	SELECT a.Id, 0, 0, @today AS BillTime, a.StationID, a.StationName, b.StationID, b.StationName, c.LineCode, c.LineName, c.LineCityName,
		a.FeeCycle, a.FeeType, d.SubGoodsQuantity,
		CASE a.SettlementSelect WHEN 1 THEN ISNULL(a.SettlementUpLimit, 0) ELSE 0 END, 
		CASE a.ActualSelect WHEN 1 THEN ISNULL(a.ActualUpLimit, 0) ELSE 0 END,
		CASE a.VolumeSelect WHEN 1 THEN ISNULL(a.VolumeUpLimit, 0) ELSE 0 END,
		c.DetailsCount, a.WarehouseFee, '', '000000', '总部', '', '系统', '', '系统'
	FROM Bas_WPF_WarehousePositionFee a
	JOIN Bas_WPF_Station b ON a.Id = b.WarehouseId AND b.StationType = 1
	JOIN (
		SELECT WarehouseId, SUM(DetailsCount) AS DetailsCount, 
			STUFF((SELECT ',' + LineCode FROM @LineTable WHERE a.WarehouseId = WarehouseId FOR XML PATH('')),1,1,'') AS LineCode,
			STUFF((SELECT ',' + LineName FROM @LineTable WHERE a.WarehouseId = WarehouseId FOR XML PATH('')),1,1,'') AS LineName,
			STUFF((SELECT ',' + LineCityName FROM Bas_WPF_Line WHERE a.WarehouseId = WarehouseId FOR XML PATH('')),1,1,'') AS LineCityName
		FROM @LineTable a GROUP BY WarehouseId
	) c ON a.id = c.WarehouseId
	LEFT JOIN (
		SELECT WarehouseId, STUFF((SELECT ',' + StationName FROM Bas_WPF_Station WHERE a.WarehouseId = WarehouseId FOR XML PATH('')),1,1,'') AS SubGoodsQuantity 
		FROM Bas_WPF_Station a WHERE StationType = 2 GROUP BY WarehouseId
	) d ON a.id = d.WarehouseId 
	WHERE IfDel = 0 AND AuditState = 1
	AND StartTime <= @today AND EndTime > @today

	--插入包仓费子表数据
	INSERT INTO FN_WarehousePositionFeeBillDetails (BillId, LineID, LineCityName, LineCode)
	SELECT a.Id, b.LineID, b.LineCityName, b.LineCode
	FROM FN_WarehousePositionFeeBill a
	JOIN Bas_WPF_Line b ON a.WarehouseId = b.WarehouseId
	WHERE a.BillTime >= @today AND a.BillTime <= @tomorrow
	ORDER BY a.Id

	COMMIT TRANSACTION t1
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION t1
END CATCH

GO

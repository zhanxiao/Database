/*
每日凌晨01:00:00执行包仓费扣费
*/
IF OBJECT_ID('P_DeductWarehouseFeeBill', 'P') IS NOT NULL   
    DROP PROCEDURE P_DeductWarehouseFeeBill
GO 
CREATE PROCEDURE P_DeductWarehouseFeeBill
AS
/*
IF object_id(N'tempdb..#temp', N'U') IS NOT NULL
	DROP TABLE #temp
*/
DECLARE @today varchar(10) = CONVERT(varchar(10), GETDATE(), 120)
DECLARE @yestoday varchar(10) = DATEADD(d, -1, @today)

DECLARE @startTime datetime, 
		@endTime datetime, 
		@isCompute bit = 0

DECLARE @id int,
		@WarehouseId int,							--包仓费设置ID
		@StationId nvarchar(100),					--收款单位ID
		@StationName nvarchar(100),					--收款单位
		@WarehouseStationId nvarchar(100),			--包仓网点ID
		@WarehouseStationName nvarchar(100),		--包仓网点
		@LineCode nvarchar(100),					--包仓线路Code
		@LineName nvarchar(100),					--包仓线路
		@LineCityName nvarchar(100),				--货物流向
		@FeeCycle int,								--包仓扣费周期
		@FeeType int,								--包仓类型
		@SubGoodsQuantity numeric(18,2) = 0,		--累加下属网点货量
		@TotalBillNum int = 0,						--总票数
		@TotalGoodsNum int = 0,						--总件数
		@TotalActualWeight numeric(18,2) = 0,		--总实际重量
		@TotalVolumn numeric(18, 2) = 0,			--总体积
		@TotalSettlementWeight numeric(18,2) = 0,	--总结算重量
		@WarehouseFee decimal(18,2) = 0,			--包仓费
		--@SettlementSelect bit, 
		@SettlementUpLimit decimal(18, 2) = 0,		--结算重量上限
		--@VolumeSelect bit, 
		@VolumeUpLimit decimal(18, 2) = 0,			--体积上限
		--@ActualSelect bit, 
		@ActualUpLimit decimal(18, 2) = 0,			--实际重量上限
		@ExcessSettlementWeight decimal(18,2) = 0,	--超出部分结算重量
		@ExcessActualWeight decimal(18,2) = 0,		--超出部分实际重量
		@ExcessVolumn decimal(18,2) = 0,			--超出部分体积
		@ExcessFee decimal(18,2) = 0,				--超额加收费
		@TotalFee decimal(18,2) = 0					--总费用

DECLARE @StationYE decimal(18,2) , @WarehouseStationYE decimal(18,2)
/*
select * from FN_WarehousePositionFeeBill
*/

BEGIN TRANSACTION t1
BEGIN TRY
	--1、按自然日：针对一条包仓数据，在包仓设置有效期内，每日凌晨1:00:00，查询前一日发站是否有包仓线路+货物流向的数据，有1条以上（含1条）数据时，从包仓网点扣包仓费，付给收款单位；无数据时，不扣款；
	SET @startTime = DATEADD(d, -1, @today)
	SET @endTime = @today
	--SELECT * INTO #temp1 FROM FN_WarehousePositionFeeBill WHERE IsAbnormal = 0 AND IsDeduct = 0 AND FeeCycle = 1 AND BillTime >= @startTime AND BillTime < @endTime

	DECLARE cur CURSOR FOR 
	SELECT id, WarehouseId, WarehouseFee, StationID, StationName, FeeCycle, FeeType, SettlementWeightUpLimit, VolumnUpLimit, ActualWeightUpLimit,
		WarehouseStationID, WarehouseStationName, LineCode, LineName, LinecityName, TotalFee
	FROM FN_WarehousePositionFeeBill WHERE IsAbnormal = 0 AND IsDeduct = 0 AND FeeCycle = 1 AND BillTime >= @startTime AND BillTime < @endTime
	--FROM #temp1
	OPEN cur
	FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
		@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName, @TotalFee
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--PRINT '扣款'	
		UPDATE FN_Recharge SET @StationYE = YE, YE = YE - @TotalFee WHERE StationID = @WarehouseStationId
		UPDATE FN_Recharge SET @WarehouseStationYE = YE, YE = YE + @TotalFee WHERE StationID = @StationId
		INSERT INTO FN_WarehousePositionFeeBillLog (BillId, FeeCycle, StationID, StationName, WarehouseStationID, WarehouseStationName, TotalFee, StationYE, WarehouseStationYE, Remark, CreateUserID, CreateUserName)
		VALUES (@id, 1, @StationId, @StationName, @WarehouseStationId, @WarehouseStationName, @TotalFee, @StationYE, @WarehouseStationYE, '', '', '系统')

		FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
			@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName, @TotalFee
	END
	CLOSE cur
	DEALLOCATE cur

	--按自然周：针对一条包仓数据，在包仓设置有效期内，每周二凌晨1:00:00，查询上周一00:00:00到上周日23:59:59内，发站是否有包仓线路+货物流向的数据，有1条以上（含1条）数据时，从包仓网点扣包仓费，付给收款单位；无数据时，不扣款；
	IF(DATEPART(WEEKDAY, @today) = 3) --周二
	BEGIN
		SET @isCompute = 1
		SET @startTime = DATEADD(d, -8, @today)
		SET @endTime = DATEADD(d, -1, @today)

		--SELECT id, WarehouseId, WarehouseFee, StationID, StationName, FeeCycle, FeeType, SettlementWeightUpLimit, VolumnUpLimit, ActualWeightUpLimit,
		--	WarehouseStationID, WarehouseStationName, LineCode, LineName, LinecityName
		--INTO #temp2 
		--FROM FN_WarehousePositionFeeBill WHERE IsAbnormal = 0 AND IsDeduct = 0 AND FeeCycle = 2 AND BillTime >= @startTime AND BillTime < @endTime
		--GROUP BY 

		DECLARE cur CURSOR FOR 
		SELECT id, WarehouseId, WarehouseFee, StationID, StationName, FeeCycle, FeeType, SettlementWeightUpLimit, VolumnUpLimit, ActualWeightUpLimit,
			WarehouseStationID, WarehouseStationName, LineCode, LineName, LinecityName 
		FROM FN_WarehousePositionFeeBill WHERE IsAbnormal = 0 AND IsDeduct = 0 AND FeeCycle = 2 AND BillTime >= @startTime AND BillTime < @endTime
		--FROM #temp2
		OPEN cur
		FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
			@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName 
		WHILE @@FETCH_STATUS = 0
		BEGIN
			--PRINT '扣款'
			UPDATE FN_Recharge SET @StationYE = YE, YE = YE - @TotalFee WHERE StationID = @WarehouseStationId
			UPDATE FN_Recharge SET @WarehouseStationYE = YE, YE = YE + @TotalFee WHERE StationID = @StationId
			INSERT INTO FN_WarehousePositionFeeBillLog (BillId, FeeCycle, StationID, StationName, WarehouseStationID, WarehouseStationName, TotalFee, StationYE, WarehouseStationYE, Remark, CreateUserID, CreateUserName)
			VALUES (@id, 2, @StationId, @StationName, @WarehouseStationId, @WarehouseStationName, @TotalFee, @StationYE, @WarehouseStationYE, '', '', '系统')

			FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
				@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName 
		END
		CLOSE cur
		DEALLOCATE cur
	END


	--3、按自然月：针对一条包仓数据，在包仓设置有效期内，每月5号凌晨1:00:00，查询上月1号00:00:00到上月最后一天23:59:59内，发站是否有包仓线路+货物流向的数据，有1条以上（含1条）数据时，从包仓网点扣包仓费，付给收款单位；无数据时，不扣款；
	IF(@FeeCycle = 3 AND DATEPART(DAY, GETDATE()) = 5) --5号
	BEGIN
		SET @isCompute = 1
		SET @startTime = CONVERT(varchar(8), DATEADD(m, -1, @today), 120) + '01'
		SET @endTime = left(@today, 8) + '01'

		--SELECT * INTO #temp3 FROM FN_WarehousePositionFeeBill WHERE IsAbnormal = 0 AND IsDeduct = 0 AND FeeCycle = 3 AND BillTime >= @startTime AND BillTime < @endTime 

		DECLARE cur CURSOR FOR 
		SELECT id, WarehouseId, WarehouseFee, StationID, StationName, FeeCycle, FeeType, SettlementWeightUpLimit, VolumnUpLimit, ActualWeightUpLimit,
			WarehouseStationID, WarehouseStationName, LineCode, LineName, LinecityName 
		FROM FN_WarehousePositionFeeBill WHERE IsAbnormal = 0 AND IsDeduct = 0 AND FeeCycle = 3 AND BillTime >= @startTime AND BillTime < @endTime 
		--FROM #temp3
		OPEN cur
		FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
			@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName 
		WHILE @@FETCH_STATUS = 0
		BEGIN
			--PRINT '扣款'
			UPDATE FN_Recharge SET @StationYE = YE, YE = YE - @TotalFee WHERE StationID = @WarehouseStationId
			UPDATE FN_Recharge SET @WarehouseStationYE = YE, YE = YE + @TotalFee WHERE StationID = @StationId
			INSERT INTO FN_WarehousePositionFeeBillLog (BillId, FeeCycle, StationID, StationName, WarehouseStationID, WarehouseStationName, TotalFee, StationYE, WarehouseStationYE, Remark, CreateUserID, CreateUserName)
			VALUES (@id, 3, @StationId, @StationName, @WarehouseStationId, @WarehouseStationName, @TotalFee, @StationYE, @WarehouseStationYE, '', '', '系统')

			FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
				@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName 
		END
		CLOSE cur
		DEALLOCATE cur
	END

	COMMIT TRANSACTION t1
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION t1
END CATCH

GO

--SELECT * FROM FN_WarehousePositionFeeBill

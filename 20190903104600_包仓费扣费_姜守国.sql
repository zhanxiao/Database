/*
每日凌晨01:00:00执行包仓费扣费
*/
IF OBJECT_ID('P_DeductWarehouseFeeBill', 'P') IS NOT NULL   
    DROP PROCEDURE P_DeductWarehouseFeeBill
GO 
CREATE PROCEDURE P_DeductWarehouseFeeBill
AS

DECLARE @today varchar(10) = CONVERT(varchar(10), GETDATE(), 120)
DECLARE @yestoday varchar(10) = DATEADD(d, -1, @today)
DECLARE @tomorrow varchar(10) = DATEADD(d, 1, @today)

/*测试
SET @today = '2019-9-19'
SET @yestoday = DATEADD(d, -1, @today)
SET @tomorrow = DATEADD(d, 1, @today)
DELETE FROM FN_WarehousePositionFeeBillLog WHERE CreateTime >= @today AND CreateTime < @tomorrow)
--*/

DECLARE @startTime datetime, 
		@endTime datetime

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
		@WarehouseFee decimal(18,2) = 0,			--包仓费
		@SettlementUpLimit decimal(18, 2) = 0,		--结算重量上限
		@VolumeUpLimit decimal(18, 2) = 0,			--体积上限
		@ActualUpLimit decimal(18, 2) = 0,			--实际重量上限
		@TotalFee decimal(18,2) = 0					--总费用

DECLARE @StationYE decimal(18,2) , @WarehouseStationYE decimal(18,2)

--今天计算过不再重新计算
IF EXISTS (SELECT * FROM FN_WarehousePositionFeeBillLog WHERE CreateTime >= @today AND CreateTime < @tomorrow)
BEGIN
	PRINT '已经扣过费'
	RETURN
END

BEGIN TRANSACTION t1
BEGIN TRY
	--1、按自然日：针对一条包仓数据，在包仓设置有效期内，每日凌晨1:00:00，查询前一日发站是否有包仓线路+货物流向的数据，有1条以上（含1条）数据时，从包仓网点扣包仓费，付给收款单位；无数据时，不扣款；
	SET @startTime = @yestoday
	SET @endTime = @today

	DECLARE cur CURSOR FOR 
	SELECT id, WarehouseId, WarehouseFee, StationID, StationName, FeeCycle, FeeType, SettlementWeightUpLimit, VolumeUpLimit, ActualWeightUpLimit,
		WarehouseStationID, WarehouseStationName, LineCode, LineName, LinecityName, TotalFee
	FROM FN_WarehousePositionFeeBill 
	WHERE IsAbnormal = 0 AND IsDeduct = 0 AND FeeCycle = 1 AND BillTime >= @startTime AND BillTime < @endTime AND TotalFee > 0
	OPEN cur
	FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
		@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName, @TotalFee
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--PRINT '扣款'
		SELECT @WarehouseStationYE = YE FROM FN_Recharge WHERE StationID = @WarehouseStationId
		IF @WarehouseStationYE < @TotalFee
		BEGIN
			--不够扣
			UPDATE FN_WarehousePositionFeeBill SET IsDeduct = 2 WHERE Id = @id
		END
		ELSE
		BEGIN			
			--够扣
			UPDATE FN_Recharge SET @WarehouseStationYE = YE, YE = YE - @TotalFee, OperTime = GETDATE() WHERE StationID = @WarehouseStationId
			UPDATE FN_Recharge SET @StationYE = YE, YE = YE + @TotalFee, OperTime = GETDATE() WHERE StationID = @StationId

			SELECT @WarehouseStationYE -= @TotalFee, @StationYE += @TotalFee

			INSERT INTO Fn_RechargeList (CurStation, CurStationID, OccurStation, OccurStationID, ConsignID, ExpenseType, ExpenseTypeID, GetMoney, PayMoney, YE, OperTime, OperMan, OperStatus, ifBack, Remark, OperStationID, OperStationName, IsPDA)
			VALUES (@StationName, @StationId, @WarehouseStationName, @WarehouseStationId, '', '包仓费', '包仓费', @TotalFee, 0, @StationYE, getdate(), '系统', 1, 0, '按日收包仓费', '000000', '总部', 0)

			INSERT INTO Fn_RechargeList (CurStation, CurStationID, OccurStation, OccurStationID, ConsignID, ExpenseType, ExpenseTypeID, GetMoney, PayMoney, YE, OperTime, OperMan, OperStatus, ifBack, Remark, OperStationID, OperStationName, IsPDA)
			VALUES (@WarehouseStationName, @WarehouseStationId, @StationName, @StationId, '', '包仓费', '包仓费', 0, @TotalFee, @WarehouseStationYE, getdate(), '系统', 1, 0, '按日付包仓费', '000000', '总部', 0)

			INSERT INTO FN_WarehousePositionFeeBillLog (BillId, FeeCycle, StationID, StationName, WarehouseStationID, WarehouseStationName, TotalFee, StationYE, WarehouseStationYE, Remark, CreateUserID, CreateUserName)
			VALUES (@id, 1, @StationId, @StationName, @WarehouseStationId, @WarehouseStationName, @TotalFee, @StationYE, @WarehouseStationYE, '按日扣费', '', '系统')

			--修改账单状态
			UPDATE FN_WarehousePositionFeeBill SET IsDeduct = 1 WHERE Id = @id
		END

		FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
			@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName, @TotalFee
	END
	CLOSE cur
	DEALLOCATE cur

	--按自然周：针对一条包仓数据，在包仓设置有效期内，每周二凌晨1:00:00，查询上周一00:00:00到上周日23:59:59内，发站是否有包仓线路+货物流向的数据，有1条以上（含1条）数据时，从包仓网点扣包仓费，付给收款单位；无数据时，不扣款；
	IF(DATEPART(WEEKDAY, @today) = 3) --周二
	BEGIN
		SET @startTime = DATEADD(d, -8, @today)
		SET @endTime = DATEADD(d, -1, @today)

		DECLARE cur CURSOR FOR 
		SELECT id, WarehouseId, WarehouseFee, StationID, StationName, FeeCycle, FeeType, SettlementWeightUpLimit, VolumeUpLimit, ActualWeightUpLimit,
			WarehouseStationID, WarehouseStationName, LineCode, LineName, LinecityName, TotalFee
		FROM FN_WarehousePositionFeeBill WHERE IsAbnormal = 0 AND IsDeduct = 0 AND FeeCycle = 2 AND BillTime >= @startTime AND BillTime < @endTime AND TotalFee > 0
		OPEN cur
		FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
			@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName, @TotalFee
		WHILE @@FETCH_STATUS = 0
		BEGIN
			--PRINT '扣款'
			SELECT @WarehouseStationYE = YE FROM FN_Recharge WHERE StationID = @WarehouseStationId
			IF @WarehouseStationYE < @TotalFee
			BEGIN
				--不够扣
				UPDATE FN_WarehousePositionFeeBill SET IsDeduct = 2 WHERE Id = @id
			END
			ELSE
			BEGIN			
				--够扣
				UPDATE FN_Recharge SET @WarehouseStationYE = YE, YE = YE - @TotalFee, OperTime = GETDATE() WHERE StationID = @WarehouseStationId
				UPDATE FN_Recharge SET @StationYE = YE, YE = YE + @TotalFee, OperTime = GETDATE() WHERE StationID = @StationId

				SELECT @WarehouseStationYE -= @TotalFee, @StationYE += @TotalFee

				INSERT INTO Fn_RechargeList (CurStation, CurStationID, OccurStation, OccurStationID, ConsignID, ExpenseType, ExpenseTypeID, GetMoney, PayMoney, YE, OperTime, OperMan, OperStatus, ifBack, Remark, OperStationID, OperStationName, IsPDA)
				VALUES (@StationName, @StationId, @WarehouseStationName, @WarehouseStationId, '', '包仓费', '包仓费', @TotalFee, 0, @StationYE, getdate(), '系统', 1, 0, '按周收包仓费', '000000', '总部', 0)

				INSERT INTO Fn_RechargeList (CurStation, CurStationID, OccurStation, OccurStationID, ConsignID, ExpenseType, ExpenseTypeID, GetMoney, PayMoney, YE, OperTime, OperMan, OperStatus, ifBack, Remark, OperStationID, OperStationName, IsPDA)
				VALUES (@WarehouseStationName, @WarehouseStationId, @StationName, @StationId, '', '包仓费', '包仓费', 0, @TotalFee, @WarehouseStationYE, getdate(), '系统', 1, 0, '按周付包仓费', '000000', '总部', 0)

				INSERT INTO FN_WarehousePositionFeeBillLog (BillId, FeeCycle, StationID, StationName, WarehouseStationID, WarehouseStationName, TotalFee, StationYE, WarehouseStationYE, Remark, CreateUserID, CreateUserName)
				VALUES (@id, 1, @StationId, @StationName, @WarehouseStationId, @WarehouseStationName, @TotalFee, @StationYE, @WarehouseStationYE, '按周扣费', '', '系统')

				--修改账单状态
				UPDATE FN_WarehousePositionFeeBill SET IsDeduct = 1 WHERE Id = @id
			END

			FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
				@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName, @TotalFee
		END
		CLOSE cur
		DEALLOCATE cur
	END

	--3、按自然月：针对一条包仓数据，在包仓设置有效期内，每月5号凌晨1:00:00，查询上月1号00:00:00到上月最后一天23:59:59内，发站是否有包仓线路+货物流向的数据，有1条以上（含1条）数据时，从包仓网点扣包仓费，付给收款单位；无数据时，不扣款；
	IF(DATEPART(DAY, @today) = 5) --5号
	BEGIN
		SET @startTime = CONVERT(varchar(8), DATEADD(m, -1, @today), 120) + '01'
		SET @endTime = left(@today, 8) + '01'
		
		DECLARE cur CURSOR FOR 
		SELECT id, WarehouseId, WarehouseFee, StationID, StationName, FeeCycle, FeeType, SettlementWeightUpLimit, VolumeUpLimit, ActualWeightUpLimit,
			WarehouseStationID, WarehouseStationName, LineCode, LineName, LinecityName, TotalFee
		FROM FN_WarehousePositionFeeBill WHERE IsAbnormal = 0 AND IsDeduct = 0 AND FeeCycle = 3 AND BillTime >= @startTime AND BillTime < @endTime AND TotalFee > 0
		OPEN cur
		FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
			@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName, @TotalFee
		WHILE @@FETCH_STATUS = 0
		BEGIN
			--PRINT '扣款'
			SELECT @WarehouseStationYE = YE FROM FN_Recharge WHERE StationID = @WarehouseStationId
			IF @WarehouseStationYE < @TotalFee
			BEGIN
				--不够扣
				UPDATE FN_WarehousePositionFeeBill SET IsDeduct = 2 WHERE Id = @id
			END
			ELSE
			BEGIN			
				--够扣
				UPDATE FN_Recharge SET @WarehouseStationYE = YE, YE = YE - @TotalFee, OperTime = GETDATE() WHERE StationID = @WarehouseStationId
				UPDATE FN_Recharge SET @StationYE = YE, YE = YE + @TotalFee, OperTime = GETDATE() WHERE StationID = @StationId

				SELECT @WarehouseStationYE -= @TotalFee, @StationYE += @TotalFee

				INSERT INTO Fn_RechargeList (CurStation, CurStationID, OccurStation, OccurStationID, ConsignID, ExpenseType, ExpenseTypeID, GetMoney, PayMoney, YE, OperTime, OperMan, OperStatus, ifBack, Remark, OperStationID, OperStationName, IsPDA)
				VALUES (@StationName, @StationId, @WarehouseStationName, @WarehouseStationId, '', '包仓费', '包仓费', @TotalFee, 0, @StationYE, getdate(), '系统', 1, 0, '按月收包仓费', '000000', '总部', 0)

				INSERT INTO Fn_RechargeList (CurStation, CurStationID, OccurStation, OccurStationID, ConsignID, ExpenseType, ExpenseTypeID, GetMoney, PayMoney, YE, OperTime, OperMan, OperStatus, ifBack, Remark, OperStationID, OperStationName, IsPDA)
				VALUES (@WarehouseStationName, @WarehouseStationId, @StationName, @StationId, '', '包仓费', '包仓费', 0, @TotalFee, @WarehouseStationYE, getdate(), '系统', 1, 0, '按月付包仓费', '000000', '总部', 0)

				INSERT INTO FN_WarehousePositionFeeBillLog (BillId, FeeCycle, StationID, StationName, WarehouseStationID, WarehouseStationName, TotalFee, StationYE, WarehouseStationYE, Remark, CreateUserID, CreateUserName)
				VALUES (@id, 1, @StationId, @StationName, @WarehouseStationId, @WarehouseStationName, @TotalFee, @StationYE, @WarehouseStationYE, '按月扣费', '', '系统')

				--修改账单状态
				UPDATE FN_WarehousePositionFeeBill SET IsDeduct = 1 WHERE Id = @id
			END

			FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
				@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName, @TotalFee
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

/*
每日凌晨01:00:00执行包仓费计算，计算前一日的账单数据
*/
IF OBJECT_ID('P_ComputeWarehouseFeeBill', 'P') IS NOT NULL   
    DROP PROCEDURE P_ComputeWarehouseFeeBill
GO 
CREATE PROCEDURE P_ComputeWarehouseFeeBill
AS

DECLARE @today varchar(10) = CONVERT(varchar(10), GETDATE(), 120)
DECLARE @yestoday varchar(10) = CONVERT(varchar(10), DATEADD(d, -1, @today), 120)

/*
SELECT * FROM FN_WarehousePositionFeeBill
SELECT * FROM FN_WarehousePositionFeeBillDetails
*/

/*测试
SET @today = '2019-9-18'
SET @yestoday = CONVERT(varchar(10), DATEADD(d, -1, @today), 120)
--*/

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
		@TotalBillNum int = 0,						--总票数
		@TotalGoodsNum int = 0,						--总件数
		@TotalActualWeight numeric(18,2) = 0,		--总实际重量
		@TotalVolume numeric(18, 2) = 0,			--总体积
		@TotalSettlementWeight numeric(18,2) = 0,	--总结算重量
		@WarehouseFee decimal(18,2) = 0,			--包仓费		
		@SettlementUpLimit decimal(18, 2) = 0,		--结算重量上限		
		@VolumeUpLimit decimal(18, 2) = 0,			--体积上限		
		@ActualUpLimit decimal(18, 2) = 0,			--实际重量上限
		@ExcessSettlementWeight decimal(18,2) = 0,	--超出部分结算重量
		@ExcessActualWeight decimal(18,2) = 0,		--超出部分实际重量
		@ExcessVolume decimal(18,2) = 0,			--超出部分体积
		@ExcessFee decimal(18,2) = 0,				--超额加收费
		@TotalFee decimal(18,2) = 0,				--总费用

		@ExcessSettlementFee decimal(18,2) = 0,		--超出部分结算重量加收费
		@ExcessActualFee decimal(18,2) = 0,			--超出部分实际重量加收费
		@ExcessVolumeFee decimal(18,2) = 0,			--超出部分体积加收费
		@LadderWarehouseFee decimal(18, 2),			--阶梯包仓费
		@Rate decimal(18, 2)						--费率

BEGIN TRANSACTION t1
BEGIN TRY
	--查询前一天的账单数据
	DECLARE cur CURSOR FOR 
	SELECT id, WarehouseId, WarehouseFee, StationID, StationName, FeeCycle, FeeType, SettlementWeightUpLimit, VolumeUpLimit, ActualWeightUpLimit,
		WarehouseStationID, WarehouseStationName, LineCode, LineName, LinecityName 
	FROM FN_WarehousePositionFeeBill WHERE BillTime >= @yestoday AND BillTime < @today
	OPEN cur
	FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
		@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LineCityName 
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--下属网点
		DECLARE @stationTable table (StationID varchar(100))
		DELETE FROM @stationTable
		INSERT INTO @stationTable (StationID) VALUES (@WarehouseStationId)
		INSERT INTO @stationTable (StationID) SELECT StationID FROM Bas_WPF_Station WHERE StationType = 2 AND WarehouseId = @WarehouseId 

		IF EXISTS (
			SELECT 1 FROM Op_Forecast a 
			JOIN Op_Out_ConfigToCompanyDetail b ON b.ConfigToCompID = a.ForecastID
			JOIN OP_In_Consign c ON c.ConsignID = b.ConsignID
			JOIN @stationTable d ON c.StartStationID = d.StationID
			JOIN FN_WarehousePositionFeeBillDetails e ON a.LineCode = e.LineCode AND e.BillId = @id
			WHERE b.IfDel = 0 AND b.BillType = 0 AND a.StartTime >= @yestoday AND a.StartTime < @today
		)
		BEGIN
			--更新子表数据			
			DECLARE @detailsId int, 
					@detailsLineID varchar(100), 
					@detailsLineCityName varchar(100), 
					@detailsWarehouseStationID varchar(100), 
					@detailsStartStationID varchar(100), 
					@detailsEndStationID varchar(100)

			DECLARE cur_details CURSOR FOR			
			SELECT a.Id, a.LineID, a.LineCityName, b.WarehouseStationID, c.StartStationID, c.EndStationID
			FROM FN_WarehousePositionFeeBillDetails a 
			JOIN FN_WarehousePositionFeeBill b ON a.BillId = b.Id 
			JOIN Bas_Line c on a.lineid = c.LineID
			WHERE B.IfDel = 0 AND c.ifDel = 0 AND BillId = @id

			OPEN cur_details
			FETCH NEXT FROM cur_details INTO @detailsId, @detailsLineID, @detailsLineCityName, @detailsWarehouseStationID, @detailsStartStationID, @detailsEndStationID
			WHILE @@FETCH_STATUS = 0
			BEGIN
				SELECT @TotalSettlementWeight = ISNULL(SUM(c.GoodsJSWeight),0), @TotalVolume = ISNULL(SUM(c.GoodsBulk),0), @TotalActualWeight = ISNULL(SUM(c.GoodsWeight),0),
					@TotalBillNum = count(*), @TotalGoodsNum = ISNULL(SUM(c.GoodsCount),0)
				FROM Op_Forecast a 
				JOIN Op_Out_ConfigToCompanyDetail b ON b.ConfigToCompID = a.ForecastID
				JOIN OP_In_Consign c ON c.ConsignID = b.ConsignID
				JOIN @stationTable d ON c.StartStationID = d.StationID
				JOIN Bas_Line e on a.StartStationID = e.StartStationID and a.NextStationID = e.EndStationID and a.LineCode = e.LineCode				
				WHERE b.BillType = 0 AND e.LineID = @detailsLineID AND a.StartStationID = @detailsStartStationID AND c.StartStationID = @detailsWarehouseStationID
				AND a.StartTime >= @yestoday AND a.StartTime < @today

				UPDATE FN_WarehousePositionFeeBillDetails SET TotalBillNum = @TotalBillNum, TotalGoodsNum = @TotalGoodsNum, 
					TotalActualWeight = @TotalActualWeight, TotalVolume = @TotalVolume, TotalSettlementWeight = @TotalSettlementWeight
				WHERE id = @detailsId

				FETCH NEXT FROM cur_details INTO @detailsId, @detailsLineID, @detailsLineCityName, @detailsWarehouseStationID, @detailsStartStationID, @detailsEndStationID
			END
			CLOSE cur_details
			DEALLOCATE cur_details

			--总网点货量,从明细统计总网点货量
			SELECT @TotalBillNum = SUM(ISNULL(TotalBillNum, 0)), @TotalGoodsNum = SUM(ISNULL(TotalGoodsNum, 0)), @TotalActualWeight = SUM(ISNULL(TotalActualWeight, 0)), 
				@TotalVolume = SUM(ISNULL(TotalVolume, 0)), @TotalSettlementWeight = SUM(ISNULL(TotalSettlementWeight, 0))  
			FROM FN_WarehousePositionFeeBillDetails WHERE BillId = @id

			--初始化变量
			SELECT @ExcessSettlementWeight = 0, @ExcessActualWeight = 0, @ExcessVolume = 0, @ExcessFee = 0, @TotalFee = @WarehouseFee
					
			IF @FeeType = 2 --阶梯包仓费
			BEGIN				
				SELECT @LadderWarehouseFee = ISNULL(WarehouseFee, 0) FROM Bas_WPF_Weight 
				WHERE WarehouseId = @WarehouseId AND @TotalSettlementWeight > StartWeight AND @TotalSettlementWeight <= EndWeight

				IF @TotalFee < @LadderWarehouseFee
				BEGIN
					SET @TotalFee = @LadderWarehouseFee
				END
			END
			IF @FeeType = 3 --超额加收
			BEGIN
				--判断结算重量是否大于上限, 上限大于零说明已经选择了此项
				IF @SettlementUpLimit > 0 AND @TotalSettlementWeight > @SettlementUpLimit
				BEGIN
					SET @ExcessSettlementWeight = @TotalSettlementWeight - @SettlementUpLimit

					SELECT @Rate = ISNULL(Rate, 0) FROM Bas_WPF_Excess
					WHERE WarehouseId = @WarehouseId AND ExcessType = 1 AND @ExcessSettlementWeight > StartValue AND @ExcessSettlementWeight <= EndValue

					IF @Rate > 0 
					BEGIN
						SET @ExcessSettlementFee = @ExcessSettlementWeight * @Rate						
						IF @ExcessFee < @ExcessSettlementFee
						BEGIN
							SET @ExcessFee = @ExcessSettlementFee
						END
					END
				END				
				--判断体积是否大于上限
				IF @VolumeUpLimit > 0 AND @TotalVolume > @VolumeUpLimit
				BEGIN
					SET @ExcessVolume = @TotalVolume - @VolumeUpLimit

					SELECT @Rate = ISNULL(Rate, 0) FROM Bas_WPF_Excess
					WHERE WarehouseId = @WarehouseId AND ExcessType = 2 AND @ExcessVolume > StartValue AND @ExcessVolume <= EndValue

					IF @Rate > 0 
					BEGIN
						SET @ExcessVolumeFee = @ExcessVolume * @Rate						
						IF @ExcessFee < @ExcessVolumeFee
						BEGIN
							SET @ExcessFee = @ExcessVolumeFee
						END
					END
				END
				--判断实际重量是否大于上限
				IF @ActualUpLimit > 0 AND @TotalActualWeight > @ActualUpLimit
				BEGIN
					SET @ExcessActualWeight = @TotalActualWeight - @ActualUpLimit

					SELECT @Rate = ISNULL(Rate, 0) FROM Bas_WPF_Excess
					WHERE WarehouseId = @WarehouseId AND ExcessType = 3 AND @ExcessActualWeight > StartValue AND @ExcessActualWeight <= EndValue

					IF @Rate > 0 
					BEGIN
						SET @ExcessActualFee = @ExcessActualWeight * @Rate
						IF @ExcessFee < @ExcessActualFee
						BEGIN
							SET @ExcessFee = @ExcessActualFee
						END
					END
				END

				SET @TotalFee = @WarehouseFee + @ExcessFee
				
			END

			--更新主表数据
			UPDATE FN_WarehousePositionFeeBill SET TotalBillNum = @TotalBillNum, TotalGoodsNum = @TotalGoodsNum,
				TotalActualWeight = @TotalActualWeight, TotalVolume = @TotalVolume, TotalSettlementWeight = @TotalSettlementWeight, WarehouseFee = @WarehouseFee,
				ExcessSettlementWeight = @ExcessSettlementWeight, ExcessActualWeight = @ExcessActualWeight, ExcessVolume = @ExcessVolume, ExcessFee = @ExcessFee, TotalFee = @TotalFee,
				UpdateTime = GETDATE()
			WHERE Id = @id	
		END

		FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
			@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName 
	END
	CLOSE cur
	DEALLOCATE cur

	COMMIT TRANSACTION t1	
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION t1	
END CATCH
GO

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

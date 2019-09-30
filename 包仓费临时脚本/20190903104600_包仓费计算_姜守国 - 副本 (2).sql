/*
每日凌晨01:00:00执行包仓费计算，计算前一日的账单数据
*/
IF OBJECT_ID('P_ComputeWarehouseFeeBill', 'P') IS NOT NULL   
    DROP PROCEDURE P_ComputeWarehouseFeeBill
GO 
CREATE PROCEDURE P_ComputeWarehouseFeeBill
AS

/*
IF object_id(N'tempdb..#temp', N'U') IS NOT NULL
	DROP TABLE #temp
*/
DECLARE @today varchar(10) = CONVERT(varchar(10), GETDATE(), 120)
DECLARE @yestoday varchar(10) = CONVERT(varchar(10), DATEADD(d, -1, @today), 120)

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

--查询前一天的账单数据
--SELECT * INTO #temp FROM FN_WarehousePositionFeeBill WHERE BillTime >= @yestoday AND BillTime < @today

BEGIN TRANSACTION t1
BEGIN TRY
	--查询前一天的账单数据
	DECLARE cur CURSOR FOR 
	SELECT id, WarehouseId, WarehouseFee, StationID, StationName, FeeCycle, FeeType, SettlementWeightUpLimit, VolumeUpLimit, ActualWeightUpLimit,
		WarehouseStationID, WarehouseStationName, LineCode, LineName, LinecityName 
	FROM FN_WarehousePositionFeeBill WHERE BillTime >= @yestoday AND BillTime < @today
	OPEN cur
	FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
		@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName 
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
			WHERE b.IfDel = 0 AND b.BillType = 0 AND a.StartTime >= @yestoday AND a.StartTime < @today AND a.LineCode = @LineCode
		)
		BEGIN
			--总网点货量
			SELECT @TotalSettlementWeight = ISNULL(SUM(c.GoodsJSWeight),0), @TotalVolume = ISNULL(SUM(c.GoodsBulk),0), @TotalActualWeight = ISNULL(SUM(c.GoodsWeight),0),
				@TotalBillNum = COUNT(*), @TotalGoodsNum = ISNULL(SUM(c.GoodsCount),0)
			FROM Op_Forecast a 
			JOIN Op_Out_ConfigToCompanyDetail b ON b.ConfigToCompID = a.ForecastID
			JOIN OP_In_Consign c ON c.ConsignID = b.ConsignID
			JOIN @stationTable d ON c.StartStationID = d.StationID
			WHERE b.IfDel = 0 AND b.BillType = 0 AND a.StartTime >= @yestoday AND a.StartTime < @today AND a.LineCode = @LineCode

			--初始化变量
			SELECT @ExcessSettlementWeight = 0, @ExcessActualWeight = 0, @ExcessVolume = 0, @ExcessFee = 0, @TotalFee = @WarehouseFee
					
			IF @FeeType = 2 --阶梯包仓费
			BEGIN				
				SELECT @LadderWarehouseFee = ISNULL(WarehouseFee, 0) FROM Bas_WPF_Weight 
				WHERE WarehouseId = @WarehouseId AND @TotalSettlementWeight >= StartWeight AND @TotalSettlementWeight < EndWeight

				IF @WarehouseFee < @LadderWarehouseFee
				BEGIN
					SET @WarehouseFee = @LadderWarehouseFee
				END
			END
			IF @FeeType = 3 --超额加收
			BEGIN
				--判断结算重量是否大于上限, 上限大于零说明已经选择了此项
				IF @SettlementUpLimit > 0 AND @TotalSettlementWeight > @SettlementUpLimit
				BEGIN
					SET @ExcessSettlementWeight = @TotalSettlementWeight - @SettlementUpLimit

					SELECT @Rate = ISNULL(Rate, 0) FROM Bas_WPF_Excess
					WHERE WarehouseId = @WarehouseId AND ExcessType = 1 AND @ExcessActualWeight >= StartValue AND @ExcessActualWeight < EndValue

					IF @Rate > 0 
					BEGIN
						SET @ExcessSettlementFee = @ExcessSettlementWeight * @Rate
						SET @ExcessFee = IIF(@ExcessFee > @ExcessSettlementFee, @ExcessFee, @ExcessSettlementFee)
					END
				END				
				--判断体积是否大于上限
				IF @VolumeUpLimit > 0 AND @TotalVolume > @VolumeUpLimit
				BEGIN
					SET @ExcessVolume = @TotalVolume - @VolumeUpLimit

					SELECT @Rate = ISNULL(Rate, 0) FROM Bas_WPF_Excess
					WHERE WarehouseId = @WarehouseId AND ExcessType = 2 AND @ExcessActualWeight >= StartValue AND @ExcessActualWeight < EndValue

					IF @Rate > 0 
					BEGIN
						SET @ExcessVolumeFee = @ExcessVolume * @Rate
						SET @ExcessFee = IIF(@ExcessFee > @ExcessVolumeFee, @ExcessFee, @ExcessVolumeFee)
					END
				END
				--判断实际重量是否大于上限
				IF @ActualUpLimit > 0 AND @TotalActualWeight > @ActualUpLimit
				BEGIN
					SET @ExcessActualWeight = @TotalActualWeight - @ActualUpLimit

					SELECT @Rate = ISNULL(Rate, 0) FROM Bas_WPF_Excess
					WHERE WarehouseId = @WarehouseId AND ExcessType = 3 AND @ExcessActualWeight >= StartValue AND @ExcessActualWeight < EndValue

					IF @Rate > 0 
					BEGIN
						SET @ExcessActualFee = @ExcessActualWeight * @Rate
						SET @ExcessFee = IIF(@ExcessFee > @ExcessActualFee, @ExcessFee, @ExcessActualFee)
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
			JOIN Bas_Line c on a.LineID = c.LineID
			WHERE B.IfDel = 0 AND c.ifDel = 0 AND BillId = @id

			OPEN cur_details
			FETCH NEXT FROM cur_details INTO @detailsId, @detailsLineID, @detailsLineCityName, @detailsWarehouseStationID, @detailsStartStationID, @detailsEndStationID
			WHILE @@FETCH_STATUS = 0
			BEGIN
				SELECT @TotalSettlementWeight = ISNULL(SUM(TotalJSWeight),0), @TotalVolume = ISNULL(SUM(TotalBulk),0), @TotalActualWeight = ISNULL(SUM(TotalWeight),0),
					@TotalBillNum = ISNULL(SUM(TotalBillNum),0), @TotalGoodsNum = ISNULL(SUM(TotalGoodsNum),0)
				FROM Op_Forecast a 
				JOIN Op_Out_ConfigToCompanyDetail b ON b.ConfigToCompID = a.ForecastID
				JOIN OP_In_Consign c ON c.ConsignID = b.ConsignID
				JOIN @stationTable d ON c.StartStationID = d.StationID
				JOIN Bas_Line e on a.StartStationID = e.StartStationID and a.NextStationID = e.EndStationID and a.LineCode = e.LineCode
				WHERE b.BillType = 0 AND e.LineID = @detailsLineID AND a.StartStationID = @WarehouseStationId AND a.StartTime >= @yestoday AND a.StartTime < @today
		
				UPDATE FN_WarehousePositionFeeBillDetails SET TotalBillNum = @TotalBillNum, TotalGoodsNum = @TotalGoodsNum, 
					TotalActualWeight = @TotalActualWeight, TotalVolume = @TotalVolume, TotalSettlementWeight = @TotalSettlementWeight
				WHERE id = @detailsId

				FETCH NEXT FROM cur_details INTO @detailsId, @detailsLineID, @detailsLineCityName, @detailsWarehouseStationID, @detailsStartStationID, @detailsEndStationID
			END
			CLOSE cur_details
			DEALLOCATE cur_details

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

--SELECT * FROM FN_WarehousePositionFeeBillDetails



--/*
DELETE FROM FN_WarehousePositionFeeBillLog
DELETE FROM FN_WarehousePositionFeeBillDetails
DELETE FROM FN_WarehousePositionFeeBill
GO
--*/
DECLARE @today varchar(10) = '2019-9-24'
DECLARE @tomorrow varchar(10) = CONVERT(varchar(10), DATEADD(d, 1, @today), 120)
DECLARE @yestoday varchar(10) = CONVERT(varchar(10), DATEADD(d, -1, @today), 120)

DECLARE @days int = 6, @i int = 0
WHILE @i < @days
BEGIN
	SET @today = CONVERT(varchar(10), DATEADD(D, 1, @today), 120)
	SET @tomorrow = CONVERT(varchar(10), DATEADD(d, 1, @today), 120)
	SET @yestoday = CONVERT(varchar(10), DATEADD(d, -1, @today), 120)
		
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
		DELETE FROM @LineTable
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

	SET @i += 1
END


GO

--select * from [FN_WarehousePositionFeeBillLog] 
--select * from [FN_WarehousePositionFeeBillDetails] 
--select * from [FN_WarehousePositionFeeBill] 

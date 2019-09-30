
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
		
	--�����˵��Ѿ����ɺ����ظ�����
	IF EXISTS (SELECT * FROM FN_WarehousePositionFeeBill WHERE BillTime = @today)
	BEGIN
		PRINT '�Ѿ����ɹ�'
		RETURN
	END

	BEGIN TRANSACTION t1
	BEGIN TRY
		--ͳ����·���ݵ��������
		DECLARE @LineTable TABLE (WarehouseId int, LineCode nvarchar(100), LineName nvarchar(100), DetailsCount int, LineCityName nvarchar(100))
		DELETE FROM @LineTable
		INSERT INTO @LineTable 
		SELECT WarehouseId, LineCode, LineName, COUNT(*),
			STUFF((SELECT ',' + LineCityName FROM Bas_WPF_Line WHERE a.WarehouseId = WarehouseId AND a.LineCode = LineCode AND a.LineName = LineName FOR XML PATH('')),1,1,'') AS LineCityName 
		FROM Bas_WPF_Line a
		GROUP BY WarehouseId, LineCode, LineName

		--������ַ��˵���������
		INSERT INTO FN_WarehousePositionFeeBill (WarehouseId,IsAbnormal,IsDeduct,BillTime,StationID,StationName,WarehouseStationID,WarehouseStationName,LineCode,LineName,LineCityName,
			FeeCycle, FeeType, SubGoodsQuantity, SettlementWeightUpLimit,ActualWeightUpLimit,VolumeUpLimit, DetailsCount, WarehouseFee,
			Remark,CreateStationID,CreateStationName,CreateUserID,CreateUserName,UpdateUserID,UpdateUserName) 
		SELECT a.Id, 0, 0, @today AS BillTime, a.StationID, a.StationName, b.StationID, b.StationName, c.LineCode, c.LineName, c.LineCityName,
			a.FeeCycle, a.FeeType, d.SubGoodsQuantity,
			CASE a.SettlementSelect WHEN 1 THEN ISNULL(a.SettlementUpLimit, 0) ELSE 0 END, 
			CASE a.ActualSelect WHEN 1 THEN ISNULL(a.ActualUpLimit, 0) ELSE 0 END,
			CASE a.VolumeSelect WHEN 1 THEN ISNULL(a.VolumeUpLimit, 0) ELSE 0 END,
			c.DetailsCount, a.WarehouseFee, '', '000000', '�ܲ�', '', 'ϵͳ', '', 'ϵͳ'
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

		--������ַ��ӱ�����
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
			@WarehouseId int,							--���ַ�����ID
			@StationId nvarchar(100),					--�տλID
			@StationName nvarchar(100),					--�տλ
			@WarehouseStationId nvarchar(100),			--��������ID
			@WarehouseStationName nvarchar(100),		--��������
			@LineCode nvarchar(100),					--������·Code
			@LineName nvarchar(100),					--������·
			@LineCityName nvarchar(100),				--��������
			@FeeCycle int,								--���ֿ۷�����
			@FeeType int,								--��������
			@TotalBillNum int = 0,						--��Ʊ��
			@TotalGoodsNum int = 0,						--�ܼ���
			@TotalActualWeight numeric(18,2) = 0,		--��ʵ������
			@TotalVolume numeric(18, 2) = 0,			--�����
			@TotalSettlementWeight numeric(18,2) = 0,	--�ܽ�������
			@WarehouseFee decimal(18,2) = 0,			--���ַ�		
			@SettlementUpLimit decimal(18, 2) = 0,		--������������		
			@VolumeUpLimit decimal(18, 2) = 0,			--�������		
			@ActualUpLimit decimal(18, 2) = 0,			--ʵ����������
			@ExcessSettlementWeight decimal(18,2) = 0,	--�������ֽ�������
			@ExcessActualWeight decimal(18,2) = 0,		--��������ʵ������
			@ExcessVolume decimal(18,2) = 0,			--�����������
			@ExcessFee decimal(18,2) = 0,				--������շ�
			@TotalFee decimal(18,2) = 0,				--�ܷ���

			@ExcessSettlementFee decimal(18,2) = 0,		--�������ֽ����������շ�
			@ExcessActualFee decimal(18,2) = 0,			--��������ʵ���������շ�
			@ExcessVolumeFee decimal(18,2) = 0,			--��������������շ�
			@LadderWarehouseFee decimal(18, 2),			--���ݰ��ַ�
			@Rate decimal(18, 2)						--����

	BEGIN TRANSACTION t1
	BEGIN TRY
		--��ѯǰһ����˵�����
		DECLARE cur CURSOR FOR 
		SELECT id, WarehouseId, WarehouseFee, StationID, StationName, FeeCycle, FeeType, SettlementWeightUpLimit, VolumeUpLimit, ActualWeightUpLimit,
			WarehouseStationID, WarehouseStationName, LineCode, LineName, LinecityName 
		FROM FN_WarehousePositionFeeBill WHERE BillTime >= @yestoday AND BillTime < @today
		OPEN cur
		FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
			@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LineCityName 
		WHILE @@FETCH_STATUS = 0
		BEGIN
			--��������
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
				--�����ӱ�����			
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

				--���������,����ϸͳ�����������
				SELECT @TotalBillNum = SUM(ISNULL(TotalBillNum, 0)), @TotalGoodsNum = SUM(ISNULL(TotalGoodsNum, 0)), @TotalActualWeight = SUM(ISNULL(TotalActualWeight, 0)), 
					@TotalVolume = SUM(ISNULL(TotalVolume, 0)), @TotalSettlementWeight = SUM(ISNULL(TotalSettlementWeight, 0))  
				FROM FN_WarehousePositionFeeBillDetails WHERE BillId = @id

				--��ʼ������
				SELECT @ExcessSettlementWeight = 0, @ExcessActualWeight = 0, @ExcessVolume = 0, @ExcessFee = 0, @TotalFee = @WarehouseFee
					
				IF @FeeType = 2 --���ݰ��ַ�
				BEGIN				
					SELECT @LadderWarehouseFee = ISNULL(WarehouseFee, 0) FROM Bas_WPF_Weight 
					WHERE WarehouseId = @WarehouseId AND @TotalSettlementWeight > StartWeight AND @TotalSettlementWeight <= EndWeight

					IF @TotalFee < @LadderWarehouseFee
					BEGIN
						SET @TotalFee = @LadderWarehouseFee
					END
				END
				IF @FeeType = 3 --�������
				BEGIN
					--�жϽ��������Ƿ��������, ���޴�����˵���Ѿ�ѡ���˴���
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
					--�ж�����Ƿ��������
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
					--�ж�ʵ�������Ƿ��������
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

				--������������
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

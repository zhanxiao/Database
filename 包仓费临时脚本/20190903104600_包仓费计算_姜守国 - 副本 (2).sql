/*
ÿ���賿01:00:00ִ�а��ַѼ��㣬����ǰһ�յ��˵�����
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

--��ѯǰһ����˵�����
--SELECT * INTO #temp FROM FN_WarehousePositionFeeBill WHERE BillTime >= @yestoday AND BillTime < @today

BEGIN TRANSACTION t1
BEGIN TRY
	--��ѯǰһ����˵�����
	DECLARE cur CURSOR FOR 
	SELECT id, WarehouseId, WarehouseFee, StationID, StationName, FeeCycle, FeeType, SettlementWeightUpLimit, VolumeUpLimit, ActualWeightUpLimit,
		WarehouseStationID, WarehouseStationName, LineCode, LineName, LinecityName 
	FROM FN_WarehousePositionFeeBill WHERE BillTime >= @yestoday AND BillTime < @today
	OPEN cur
	FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
		@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName 
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
			WHERE b.IfDel = 0 AND b.BillType = 0 AND a.StartTime >= @yestoday AND a.StartTime < @today AND a.LineCode = @LineCode
		)
		BEGIN
			--���������
			SELECT @TotalSettlementWeight = ISNULL(SUM(c.GoodsJSWeight),0), @TotalVolume = ISNULL(SUM(c.GoodsBulk),0), @TotalActualWeight = ISNULL(SUM(c.GoodsWeight),0),
				@TotalBillNum = COUNT(*), @TotalGoodsNum = ISNULL(SUM(c.GoodsCount),0)
			FROM Op_Forecast a 
			JOIN Op_Out_ConfigToCompanyDetail b ON b.ConfigToCompID = a.ForecastID
			JOIN OP_In_Consign c ON c.ConsignID = b.ConsignID
			JOIN @stationTable d ON c.StartStationID = d.StationID
			WHERE b.IfDel = 0 AND b.BillType = 0 AND a.StartTime >= @yestoday AND a.StartTime < @today AND a.LineCode = @LineCode

			--��ʼ������
			SELECT @ExcessSettlementWeight = 0, @ExcessActualWeight = 0, @ExcessVolume = 0, @ExcessFee = 0, @TotalFee = @WarehouseFee
					
			IF @FeeType = 2 --���ݰ��ַ�
			BEGIN				
				SELECT @LadderWarehouseFee = ISNULL(WarehouseFee, 0) FROM Bas_WPF_Weight 
				WHERE WarehouseId = @WarehouseId AND @TotalSettlementWeight >= StartWeight AND @TotalSettlementWeight < EndWeight

				IF @WarehouseFee < @LadderWarehouseFee
				BEGIN
					SET @WarehouseFee = @LadderWarehouseFee
				END
			END
			IF @FeeType = 3 --�������
			BEGIN
				--�жϽ��������Ƿ��������, ���޴�����˵���Ѿ�ѡ���˴���
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
				--�ж�����Ƿ��������
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
				--�ж�ʵ�������Ƿ��������
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

			--������������
			UPDATE FN_WarehousePositionFeeBill SET TotalBillNum = @TotalBillNum, TotalGoodsNum = @TotalGoodsNum,
				TotalActualWeight = @TotalActualWeight, TotalVolume = @TotalVolume, TotalSettlementWeight = @TotalSettlementWeight, WarehouseFee = @WarehouseFee,
				ExcessSettlementWeight = @ExcessSettlementWeight, ExcessActualWeight = @ExcessActualWeight, ExcessVolume = @ExcessVolume, ExcessFee = @ExcessFee, TotalFee = @TotalFee,
				UpdateTime = GETDATE()
			WHERE Id = @id

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


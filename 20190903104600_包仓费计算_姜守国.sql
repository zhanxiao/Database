/*
ÿ���賿01:00:00ִ�а��ַѼ��㣬����ǰһ�յ��˵�����
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

/*����
SET @today = '2019-9-18'
SET @yestoday = CONVERT(varchar(10), DATEADD(d, -1, @today), 120)
--*/

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
GO

/*
ÿ���賿01:00:00ִ�а��ַѿ۷�
*/
IF OBJECT_ID('P_DeductWarehouseFeeBill', 'P') IS NOT NULL   
    DROP PROCEDURE P_DeductWarehouseFeeBill
GO 
CREATE PROCEDURE P_DeductWarehouseFeeBill
AS

DECLARE @today varchar(10) = CONVERT(varchar(10), GETDATE(), 120)
DECLARE @yestoday varchar(10) = DATEADD(d, -1, @today)
DECLARE @tomorrow varchar(10) = DATEADD(d, 1, @today)

/*����
SET @today = '2019-9-19'
SET @yestoday = DATEADD(d, -1, @today)
SET @tomorrow = DATEADD(d, 1, @today)
DELETE FROM FN_WarehousePositionFeeBillLog WHERE CreateTime >= @today AND CreateTime < @tomorrow)
--*/

DECLARE @startTime datetime, 
		@endTime datetime

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
		@WarehouseFee decimal(18,2) = 0,			--���ַ�
		@SettlementUpLimit decimal(18, 2) = 0,		--������������
		@VolumeUpLimit decimal(18, 2) = 0,			--�������
		@ActualUpLimit decimal(18, 2) = 0,			--ʵ����������
		@TotalFee decimal(18,2) = 0					--�ܷ���

DECLARE @StationYE decimal(18,2) , @WarehouseStationYE decimal(18,2)

--���������������¼���
IF EXISTS (SELECT * FROM FN_WarehousePositionFeeBillLog WHERE CreateTime >= @today AND CreateTime < @tomorrow)
BEGIN
	PRINT '�Ѿ��۹���'
	RETURN
END

BEGIN TRANSACTION t1
BEGIN TRY
	--1������Ȼ�գ����һ���������ݣ��ڰ���������Ч���ڣ�ÿ���賿1:00:00����ѯǰһ�շ�վ�Ƿ��а�����·+������������ݣ���1�����ϣ���1��������ʱ���Ӱ�������۰��ַѣ������տλ��������ʱ�����ۿ
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
		--PRINT '�ۿ�'
		SELECT @WarehouseStationYE = YE FROM FN_Recharge WHERE StationID = @WarehouseStationId
		IF @WarehouseStationYE < @TotalFee
		BEGIN
			--������
			UPDATE FN_WarehousePositionFeeBill SET IsDeduct = 2 WHERE Id = @id
		END
		ELSE
		BEGIN			
			--����
			UPDATE FN_Recharge SET @WarehouseStationYE = YE, YE = YE - @TotalFee, OperTime = GETDATE() WHERE StationID = @WarehouseStationId
			UPDATE FN_Recharge SET @StationYE = YE, YE = YE + @TotalFee, OperTime = GETDATE() WHERE StationID = @StationId

			SELECT @WarehouseStationYE -= @TotalFee, @StationYE += @TotalFee

			INSERT INTO Fn_RechargeList (CurStation, CurStationID, OccurStation, OccurStationID, ConsignID, ExpenseType, ExpenseTypeID, GetMoney, PayMoney, YE, OperTime, OperMan, OperStatus, ifBack, Remark, OperStationID, OperStationName, IsPDA)
			VALUES (@StationName, @StationId, @WarehouseStationName, @WarehouseStationId, '', '���ַ�', '���ַ�', @TotalFee, 0, @StationYE, getdate(), 'ϵͳ', 1, 0, '�����հ��ַ�', '000000', '�ܲ�', 0)

			INSERT INTO Fn_RechargeList (CurStation, CurStationID, OccurStation, OccurStationID, ConsignID, ExpenseType, ExpenseTypeID, GetMoney, PayMoney, YE, OperTime, OperMan, OperStatus, ifBack, Remark, OperStationID, OperStationName, IsPDA)
			VALUES (@WarehouseStationName, @WarehouseStationId, @StationName, @StationId, '', '���ַ�', '���ַ�', 0, @TotalFee, @WarehouseStationYE, getdate(), 'ϵͳ', 1, 0, '���ո����ַ�', '000000', '�ܲ�', 0)

			INSERT INTO FN_WarehousePositionFeeBillLog (BillId, FeeCycle, StationID, StationName, WarehouseStationID, WarehouseStationName, TotalFee, StationYE, WarehouseStationYE, Remark, CreateUserID, CreateUserName)
			VALUES (@id, 1, @StationId, @StationName, @WarehouseStationId, @WarehouseStationName, @TotalFee, @StationYE, @WarehouseStationYE, '���տ۷�', '', 'ϵͳ')

			--�޸��˵�״̬
			UPDATE FN_WarehousePositionFeeBill SET IsDeduct = 1 WHERE Id = @id
		END

		FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
			@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName, @TotalFee
	END
	CLOSE cur
	DEALLOCATE cur

	--����Ȼ�ܣ����һ���������ݣ��ڰ���������Ч���ڣ�ÿ�ܶ��賿1:00:00����ѯ����һ00:00:00��������23:59:59�ڣ���վ�Ƿ��а�����·+������������ݣ���1�����ϣ���1��������ʱ���Ӱ�������۰��ַѣ������տλ��������ʱ�����ۿ
	IF(DATEPART(WEEKDAY, @today) = 3) --�ܶ�
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
			--PRINT '�ۿ�'
			SELECT @WarehouseStationYE = YE FROM FN_Recharge WHERE StationID = @WarehouseStationId
			IF @WarehouseStationYE < @TotalFee
			BEGIN
				--������
				UPDATE FN_WarehousePositionFeeBill SET IsDeduct = 2 WHERE Id = @id
			END
			ELSE
			BEGIN			
				--����
				UPDATE FN_Recharge SET @WarehouseStationYE = YE, YE = YE - @TotalFee, OperTime = GETDATE() WHERE StationID = @WarehouseStationId
				UPDATE FN_Recharge SET @StationYE = YE, YE = YE + @TotalFee, OperTime = GETDATE() WHERE StationID = @StationId

				SELECT @WarehouseStationYE -= @TotalFee, @StationYE += @TotalFee

				INSERT INTO Fn_RechargeList (CurStation, CurStationID, OccurStation, OccurStationID, ConsignID, ExpenseType, ExpenseTypeID, GetMoney, PayMoney, YE, OperTime, OperMan, OperStatus, ifBack, Remark, OperStationID, OperStationName, IsPDA)
				VALUES (@StationName, @StationId, @WarehouseStationName, @WarehouseStationId, '', '���ַ�', '���ַ�', @TotalFee, 0, @StationYE, getdate(), 'ϵͳ', 1, 0, '�����հ��ַ�', '000000', '�ܲ�', 0)

				INSERT INTO Fn_RechargeList (CurStation, CurStationID, OccurStation, OccurStationID, ConsignID, ExpenseType, ExpenseTypeID, GetMoney, PayMoney, YE, OperTime, OperMan, OperStatus, ifBack, Remark, OperStationID, OperStationName, IsPDA)
				VALUES (@WarehouseStationName, @WarehouseStationId, @StationName, @StationId, '', '���ַ�', '���ַ�', 0, @TotalFee, @WarehouseStationYE, getdate(), 'ϵͳ', 1, 0, '���ܸ����ַ�', '000000', '�ܲ�', 0)

				INSERT INTO FN_WarehousePositionFeeBillLog (BillId, FeeCycle, StationID, StationName, WarehouseStationID, WarehouseStationName, TotalFee, StationYE, WarehouseStationYE, Remark, CreateUserID, CreateUserName)
				VALUES (@id, 1, @StationId, @StationName, @WarehouseStationId, @WarehouseStationName, @TotalFee, @StationYE, @WarehouseStationYE, '���ܿ۷�', '', 'ϵͳ')

				--�޸��˵�״̬
				UPDATE FN_WarehousePositionFeeBill SET IsDeduct = 1 WHERE Id = @id
			END

			FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
				@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName, @TotalFee
		END
		CLOSE cur
		DEALLOCATE cur
	END

	--3������Ȼ�£����һ���������ݣ��ڰ���������Ч���ڣ�ÿ��5���賿1:00:00����ѯ����1��00:00:00���������һ��23:59:59�ڣ���վ�Ƿ��а�����·+������������ݣ���1�����ϣ���1��������ʱ���Ӱ�������۰��ַѣ������տλ��������ʱ�����ۿ
	IF(DATEPART(DAY, @today) = 5) --5��
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
			--PRINT '�ۿ�'
			SELECT @WarehouseStationYE = YE FROM FN_Recharge WHERE StationID = @WarehouseStationId
			IF @WarehouseStationYE < @TotalFee
			BEGIN
				--������
				UPDATE FN_WarehousePositionFeeBill SET IsDeduct = 2 WHERE Id = @id
			END
			ELSE
			BEGIN			
				--����
				UPDATE FN_Recharge SET @WarehouseStationYE = YE, YE = YE - @TotalFee, OperTime = GETDATE() WHERE StationID = @WarehouseStationId
				UPDATE FN_Recharge SET @StationYE = YE, YE = YE + @TotalFee, OperTime = GETDATE() WHERE StationID = @StationId

				SELECT @WarehouseStationYE -= @TotalFee, @StationYE += @TotalFee

				INSERT INTO Fn_RechargeList (CurStation, CurStationID, OccurStation, OccurStationID, ConsignID, ExpenseType, ExpenseTypeID, GetMoney, PayMoney, YE, OperTime, OperMan, OperStatus, ifBack, Remark, OperStationID, OperStationName, IsPDA)
				VALUES (@StationName, @StationId, @WarehouseStationName, @WarehouseStationId, '', '���ַ�', '���ַ�', @TotalFee, 0, @StationYE, getdate(), 'ϵͳ', 1, 0, '�����հ��ַ�', '000000', '�ܲ�', 0)

				INSERT INTO Fn_RechargeList (CurStation, CurStationID, OccurStation, OccurStationID, ConsignID, ExpenseType, ExpenseTypeID, GetMoney, PayMoney, YE, OperTime, OperMan, OperStatus, ifBack, Remark, OperStationID, OperStationName, IsPDA)
				VALUES (@WarehouseStationName, @WarehouseStationId, @StationName, @StationId, '', '���ַ�', '���ַ�', 0, @TotalFee, @WarehouseStationYE, getdate(), 'ϵͳ', 1, 0, '���¸����ַ�', '000000', '�ܲ�', 0)

				INSERT INTO FN_WarehousePositionFeeBillLog (BillId, FeeCycle, StationID, StationName, WarehouseStationID, WarehouseStationName, TotalFee, StationYE, WarehouseStationYE, Remark, CreateUserID, CreateUserName)
				VALUES (@id, 1, @StationId, @StationName, @WarehouseStationId, @WarehouseStationName, @TotalFee, @StationYE, @WarehouseStationYE, '���¿۷�', '', 'ϵͳ')

				--�޸��˵�״̬
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

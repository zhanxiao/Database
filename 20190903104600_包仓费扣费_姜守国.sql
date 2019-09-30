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

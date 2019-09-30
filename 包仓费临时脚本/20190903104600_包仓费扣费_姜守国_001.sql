/*
ÿ���賿01:00:00ִ�а��ַѿ۷�
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
		@SubGoodsQuantity numeric(18,2) = 0,		--�ۼ������������
		@TotalBillNum int = 0,						--��Ʊ��
		@TotalGoodsNum int = 0,						--�ܼ���
		@TotalActualWeight numeric(18,2) = 0,		--��ʵ������
		@TotalVolumn numeric(18, 2) = 0,			--�����
		@TotalSettlementWeight numeric(18,2) = 0,	--�ܽ�������
		@WarehouseFee decimal(18,2) = 0,			--���ַ�
		--@SettlementSelect bit, 
		@SettlementUpLimit decimal(18, 2) = 0,		--������������
		--@VolumeSelect bit, 
		@VolumeUpLimit decimal(18, 2) = 0,			--�������
		--@ActualSelect bit, 
		@ActualUpLimit decimal(18, 2) = 0,			--ʵ����������
		@ExcessSettlementWeight decimal(18,2) = 0,	--�������ֽ�������
		@ExcessActualWeight decimal(18,2) = 0,		--��������ʵ������
		@ExcessVolumn decimal(18,2) = 0,			--�����������
		@ExcessFee decimal(18,2) = 0,				--������շ�
		@TotalFee decimal(18,2) = 0					--�ܷ���

DECLARE @StationYE decimal(18,2) , @WarehouseStationYE decimal(18,2)
/*
select * from FN_WarehousePositionFeeBill
*/

BEGIN TRANSACTION t1
BEGIN TRY
	--1������Ȼ�գ����һ���������ݣ��ڰ���������Ч���ڣ�ÿ���賿1:00:00����ѯǰһ�շ�վ�Ƿ��а�����·+������������ݣ���1�����ϣ���1��������ʱ���Ӱ�������۰��ַѣ������տλ��������ʱ�����ۿ
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
		--PRINT '�ۿ�'	
		UPDATE FN_Recharge SET @StationYE = YE, YE = YE - @TotalFee WHERE StationID = @WarehouseStationId
		UPDATE FN_Recharge SET @WarehouseStationYE = YE, YE = YE + @TotalFee WHERE StationID = @StationId
		INSERT INTO FN_WarehousePositionFeeBillLog (BillId, FeeCycle, StationID, StationName, WarehouseStationID, WarehouseStationName, TotalFee, StationYE, WarehouseStationYE, Remark, CreateUserID, CreateUserName)
		VALUES (@id, 1, @StationId, @StationName, @WarehouseStationId, @WarehouseStationName, @TotalFee, @StationYE, @WarehouseStationYE, '', '', 'ϵͳ')

		FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
			@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName, @TotalFee
	END
	CLOSE cur
	DEALLOCATE cur

	--����Ȼ�ܣ����һ���������ݣ��ڰ���������Ч���ڣ�ÿ�ܶ��賿1:00:00����ѯ����һ00:00:00��������23:59:59�ڣ���վ�Ƿ��а�����·+������������ݣ���1�����ϣ���1��������ʱ���Ӱ�������۰��ַѣ������տλ��������ʱ�����ۿ
	IF(DATEPART(WEEKDAY, @today) = 3) --�ܶ�
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
			--PRINT '�ۿ�'
			UPDATE FN_Recharge SET @StationYE = YE, YE = YE - @TotalFee WHERE StationID = @WarehouseStationId
			UPDATE FN_Recharge SET @WarehouseStationYE = YE, YE = YE + @TotalFee WHERE StationID = @StationId
			INSERT INTO FN_WarehousePositionFeeBillLog (BillId, FeeCycle, StationID, StationName, WarehouseStationID, WarehouseStationName, TotalFee, StationYE, WarehouseStationYE, Remark, CreateUserID, CreateUserName)
			VALUES (@id, 2, @StationId, @StationName, @WarehouseStationId, @WarehouseStationName, @TotalFee, @StationYE, @WarehouseStationYE, '', '', 'ϵͳ')

			FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
				@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName 
		END
		CLOSE cur
		DEALLOCATE cur
	END


	--3������Ȼ�£����һ���������ݣ��ڰ���������Ч���ڣ�ÿ��5���賿1:00:00����ѯ����1��00:00:00���������һ��23:59:59�ڣ���վ�Ƿ��а�����·+������������ݣ���1�����ϣ���1��������ʱ���Ӱ�������۰��ַѣ������տλ��������ʱ�����ۿ
	IF(@FeeCycle = 3 AND DATEPART(DAY, GETDATE()) = 5) --5��
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
			--PRINT '�ۿ�'
			UPDATE FN_Recharge SET @StationYE = YE, YE = YE - @TotalFee WHERE StationID = @WarehouseStationId
			UPDATE FN_Recharge SET @WarehouseStationYE = YE, YE = YE + @TotalFee WHERE StationID = @StationId
			INSERT INTO FN_WarehousePositionFeeBillLog (BillId, FeeCycle, StationID, StationName, WarehouseStationID, WarehouseStationName, TotalFee, StationYE, WarehouseStationYE, Remark, CreateUserID, CreateUserName)
			VALUES (@id, 3, @StationId, @StationName, @WarehouseStationId, @WarehouseStationName, @TotalFee, @StationYE, @WarehouseStationYE, '', '', 'ϵͳ')

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

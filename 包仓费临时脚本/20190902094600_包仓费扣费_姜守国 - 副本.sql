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

DECLARE @startTime datetime, 
		@endTime datetime, 
		@isCompute bit = 0

DECLARE @id int,
		@WarehouseId int,									--���ַ�����ID
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

--SELECT a.Id, a.WarehouseFee, a.StationID, a.StationName, a.FeeCycle, a.FeeType, 
--	a.SettlementSelect, ISNULL(a.SettlementUpLimit, 0) AS SettlementUpLimit, 
--	a.VolumeSelect, ISNULL(a.VolumeUpLimit, 0) AS VolumeUpLimit, 
--	a.ActualSelect, ISNULL(a.ActualUpLimit, 0) AS ActualUpLimit,
--	b.StationID AS WarehouseStationID, b.StationName AS WarehouseStationName, 
--	c.LineCode, c.LineName, c.LineCityName
--INTO #temp
--FROM Bas_WPF_WarehousePositionFee a
--JOIN Bas_WPF_Station b on a.Id = b.WarehouseId AND b.StationType = 1
--JOIN Bas_WPF_Line c on a.id = c.WarehouseId
--WHERE IfDel = 0
--AND StartTime < @today AND EndTime > @today
--AND FeeType = 1 
--AND a.StationID = 010002
--AND b.StationID = '010170'

--SELECT * FROM #temp

SELECT * INTO #temp FROM Bas_WPF_WarehousePositionFeeBill WHERE CONVERT(varchar(10), BillTime, 120) = @today

DECLARE cur CURSOR FOR 
SELECT id, WarehouseId, WarehouseFee, StationID, StationName, FeeCycle, FeeType, SettlementWeightUpLimit, VolumnUpLimit, ActualWeightUpLimit,
	WarehouseStationID, WarehouseStationName, LineCode, LineName, LinecityName 
FROM #temp
OPEN cur
FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
	@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName 
WHILE @@FETCH_STATUS = 0
BEGIN
	--1������Ȼ�գ����һ���������ݣ��ڰ���������Ч���ڣ�ÿ���賿1:00:00����ѯǰһ�շ�վ�Ƿ��а�����·+������������ݣ���1�����ϣ���1��������ʱ���Ӱ�������۰��ַѣ������տλ��������ʱ�����ۿ
	IF(@FeeCycle = 1)
	BEGIN
		SET @isCompute = 1
		SET @startTime = DATEADD(d, -1, @today)
		SET @endTime = @today	
	END
	--����Ȼ�ܣ����һ���������ݣ��ڰ���������Ч���ڣ�ÿ�ܶ��賿1:00:00����ѯ����һ00:00:00��������23:59:59�ڣ���վ�Ƿ��а�����·+������������ݣ���1�����ϣ���1��������ʱ���Ӱ�������۰��ַѣ������տλ��������ʱ�����ۿ
	IF(@FeeCycle = 2 AND DATEPART(WEEKDAY, GETDATE()) = 3)
	BEGIN
		SET @isCompute = 1
		SET @startTime = DATEADD(d, -8, @today)
		SET @endTime = DATEADD(d, -1, @today)
	END
	--3������Ȼ�£����һ���������ݣ��ڰ���������Ч���ڣ�ÿ��5���賿1:00:00����ѯ����1��00:00:00���������һ��23:59:59�ڣ���վ�Ƿ��а�����·+������������ݣ���1�����ϣ���1��������ʱ���Ӱ�������۰��ַѣ������տλ��������ʱ�����ۿ
	IF(@FeeCycle = 3 AND DATEPART(DAY, GETDATE()) = 5)
	BEGIN
		SET @isCompute = 1
		SET @startTime = CONVERT(varchar(8), DATEADD(m, -1, @today), 120) + '01'
		SET @endTime = left(@today, 8) + '01'
	END

	IF @isCompute = 1 AND exists (SELECT 1 FROM Op_Forecast WHERE StartStationID = @StationID AND OperateTime >= @startTime AND OperateTime < @endTime /*AND LineCode = @lineCode*/ )
	BEGIN
		DECLARE @stationTable table (StationID varchar(100))
		--INSERT INTO @stationTable (StationID) VALUES (@stationId)
		INSERT INTO @stationTable (StationID) SELECT StationID FROM Bas_WPF_Station WHERE StationType = 2 AND WarehouseId = @WarehouseId 

		IF(@FeeType = 1)--��ϲ�λ��
		BEGIN
			--print '�۷�' + CAST(@warehouseFee AS varchar(100))
			GOTO ADDBILL
		END
		IF(@FeeType = 2) --���ݰ��ַ�
		BEGIN
			--�ۼ������������
			SELECT @SubGoodsQuantity = ISNULL(SUM(TotalJSWeight),0), @TotalBillNum = ISNULL(SUM(TotalBillNum),0), @TotalGoodsNum = ISNULL(SUM(TotalGoodsNum),0)
			FROM Op_Forecast 
			WHERE StartStationID in (SELECT StationID FROM @stationTable) AND OperateTime >= @startTime AND OperateTime < @endTime AND LineCode = @LineCode	

			--���������
			SELECT @TotalSettlementWeight = @SubGoodsQuantity + ISNULL(SUM(TotalJSWeight),0),	@TotalBillNum += ISNULL(SUM(TotalBillNum),0), @TotalGoodsNum += ISNULL(SUM(TotalGoodsNum),0)
			FROM Op_Forecast 
			WHERE StartStationID = @WarehouseStationId AND OperateTime >= @startTime AND OperateTime < @endTime AND LineCode = @LineCode						

			SELECT @WarehouseFee = WarehouseFee FROM Bas_WPF_Weight WHERE WarehouseId = @id AND @TotalSettlementWeight >= StartWeight AND @TotalSettlementWeight < EndWeight
			IF(@WarehouseFee > 0)
			BEGIN
				--print '�۷�' + CAST(@warehouseFee AS varchar(100))
				GOTO ADDBILL
			END
		END
		IF(@FeeType = 3) --�������
		BEGIN
			--�ۼ������������
			SELECT @SubGoodsQuantity = ISNULL(SUM(TotalJSWeight),0), @TotalVolumn = ISNULL(SUM(TotalBulk),0), @TotalActualWeight = ISNULL(SUM(TotalWeight),0),
				@TotalBillNum = ISNULL(SUM(TotalBillNum),0), @TotalGoodsNum = ISNULL(SUM(TotalGoodsNum),0)
			FROM Op_Forecast 
			WHERE StartStationID in (SELECT StationID FROM @stationTable) AND OperateTime >= @startTime AND OperateTime < @endTime AND LineCode = @lineCode
			
			--��ǰ�������			
			SELECT @TotalSettlementWeight = @SubGoodsQuantity + ISNULL(SUM(TotalJSWeight),0), @TotalVolumn += ISNULL(SUM(TotalBulk),0), @TotalActualWeight += ISNULL(SUM(TotalWeight),0),
				@TotalBillNum += ISNULL(SUM(TotalBillNum),0), @TotalGoodsNum += ISNULL(SUM(TotalGoodsNum),0)
			FROM Op_Forecast 
			WHERE StartStationID = @WarehouseStationId AND OperateTime >= @startTime AND OperateTime < @endTime AND LineCode = @lineCode			

			DECLARE @Rate decimal(18,2), 
					@value1 decimal(18,2) = 0, 
					@value2 decimal(18,2) = 0,
					@value3 decimal(18,2) = 0
			IF(@SettlementUpLimit > 0 AND @TotalSettlementWeight > @SettlementUpLimit) 
			BEGIN
				SET @ExcessSettlementWeight = @TotalSettlementWeight - @SettlementUpLimit
				SELECT @Rate = ISNULL(Rate,0) FROM Bas_WPF_Excess WHERE WarehouseId = @id AND ExcessType = 1 AND @ExcessSettlementWeight >= StartValue AND @ExcessSettlementWeight < EndValue				
				SET @value1 = @WarehouseFee * @Rate
			END
			IF(@VolumeUpLimit > 0 AND @TotalVolumn > @VolumeUpLimit) 
			BEGIN	
				SET @ExcessVolumn = @TotalVolumn - @VolumeUpLimit
				SELECT @Rate = ISNULL(Rate,0) FROM Bas_WPF_Excess WHERE WarehouseId = @id AND ExcessType = 2 AND @ExcessVolumn >= StartValue AND @ExcessVolumn < EndValue
				SET @value2 = @WarehouseFee * @Rate
			END
			IF(@VolumeUpLimit > 0 AND @TotalVolumn > @VolumeUpLimit) 
			BEGIN
				SET @ExcessActualWeight = @TotalSettlementWeight - @SettlementUpLimit
				SELECT @Rate = ISNULL(Rate,0) FROM Bas_WPF_Excess WHERE WarehouseId = @id AND ExcessType = 3 AND @ExcessActualWeight >= StartValue AND @ExcessActualWeight < EndValue
				SET @value3 = @WarehouseFee * @Rate
			END
			IF(@ExcessFee < @value1) SET @ExcessFee = @value1
			IF(@ExcessFee < @value2) SET @ExcessFee = @value2
			IF(@ExcessFee < @value3) SET @ExcessFee = @value3
			SET @TotalFee = @WarehouseFee + @ExcessFee
			IF(@TotalFee > 0)
			BEGIN
				--print '�۷�' + CAST(@warehouseFee AS varchar(100))
				GOTO ADDBILL
			END
		END
	END
	GOTO NEXTLOOP --����ADDBILL:
ADDBILL:
	INSERT INTO Bas_WPF_WarehousePositionFeeBill (WarehouseId,BillTime,StationID,StationName,WarehouseStationID,WarehouseStationName,LineCode,LineName,LineCityName,
		FeeCycle,FeeType,SubGoodsQuantity,TotalBillNum,TotalGoodsNum,TotalActualWeight,TotalVolumn,TotalSettlementWeight,WarehouseFee,
		SettlementWeightUpLimit,ActualWeightUpLimit,VolumnUpLimit,ExcessSettlementWeight,ExcessActualWeight,ExcessVolumn,ExcessFee,	TotalFee,
		Remark,CreateStationID,CreateStationName,CreateUserID,CreateUserName,UpdateUserID,UpdateUserName) 
	VALUES (@id, getdate(), @StationId, @StationName, @WarehouseStationId, @WarehouseStationName, @LineCode, @LineName, @LineCityName, 
		@FeeCycle, @FeeType, @SubGoodsQuantity, @TotalBillNum, @TotalGoodsNum, @TotalActualWeight, @TotalVolumn, @TotalSettlementWeight, @WarehouseFee, 
		@SettlementUpLimit, @ActualUpLimit, @VolumeUpLimit, @ExcessSettlementWeight, @ExcessActualWeight, @ExcessVolumn, @ExcessFee, @TotalFee, 
		'', '000000', '�ܲ�', '', 'ϵͳ', '', 'ϵͳ')
NEXTLOOP: 
	FETCH NEXT FROM cur INTO @id, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementSelect, @SettlementUpLimit, @VolumeSelect, @VolumeUpLimit, @ActualSelect, @ActualUpLimit,
		@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName 
END
CLOSE cur
DEALLOCATE cur

GO

SELECT * FROM Bas_WPF_WarehousePositionFeeBill

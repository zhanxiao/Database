/***************************************************
˵����
1. ��������ʷ������OrdernuberΪnull������ͳһ����ΪIDֵ
2. �������Խ�����ˮ��+������ȷ��Ψһ���޸ı�����Ϊ������ˮ��+������
3. �ظ������к�����һ�µ����ݾ����ֶ������ı�������Ӧδ�ֶ��������ظ�����ɾ��
4. �ظ������к���һ�µ����ݣ�ѡȡIDֵ���һ��ɾ��
5. �����߼�������ɾ�������ݲ�ѯ�������±�PDA_BankDetails_DelBak�У�������ȷ���������Ҫ�ֶ�����PDA_BankDetails_DelBakɾ��
****************************************************/

--��������Ϊ�յĶ����Ÿ�ֵΪID
/*
SELECT * FROM [PDA_BankDetails] WHERE Ordernumber IS NULL
SELECT count(*) FROM [PDA_BankDetails] WHERE Ordernumber IS NULL  --404287��
SELECT count(*) FROM [PDA_BankDetails] WHERE BusNumber IS NULL    --0��
*/
UPDATE [PDA_BankDetails] SET Ordernumber = ID WHERE Ordernumber IS NULL
GO



--Ordernumber�ظ������б��ֶ�����������һ������
/*
--��Ordernumber��BusNumberȷ��Ψһ�ܲ鵽��3������
SELECT [Ordernumber],[BusNumber] FROM [PDA_BankDetails] WHERE [Ordernumber] IS NOT NULL AND CancellationStatus <> 1 AND [Ordernumber] IS NOT NULL GROUP BY [Ordernumber],[BusNumber] HAVING COUNT(*) > 1

--��3�����ݣ������ֶ�������
SELECT * FROM [PDA_BankDetails] a
JOIN (
    SELECT [Ordernumber],[BusNumber] FROM [PDA_BankDetails] WHERE [Ordernumber] IS NOT NULL AND CancellationStatus <> 1 AND [Ordernumber] IS NOT NULL GROUP BY [Ordernumber],[BusNumber] HAVING COUNT(*) > 1
) b ON a.Ordernumber = b.Ordernumber AND a.BusNumber = b.BusNumber
WHERE a.CancellationStatus = 2
*/
SELECT * INTO PDA_BankDetails_DelBak FROM PDA_BankDetails WHERE ID IN (
    SELECT ID FROM [PDA_BankDetails] a
	JOIN (
		SELECT [Ordernumber],[BusNumber] FROM [PDA_BankDetails] WHERE [Ordernumber] IS NOT NULL AND CancellationStatus <> 1 AND [Ordernumber] IS NOT NULL GROUP BY [Ordernumber],[BusNumber] HAVING COUNT(*) > 1
	) b ON a.Ordernumber = b.Ordernumber AND a.BusNumber = b.BusNumber
	WHERE a.CancellationStatus = 2
)
--Ordernumber�ظ�����
/*
--��1256��
SELECT count(*) FROM [PDA_BankDetails] WHERE [ID] IN (
	SELECT MAX(cast([ID] AS varchar(100))) AS ID FROM [PDA_BankDetails] WHERE [Ordernumber] IS NOT NULL AND CancellationStatus = 1 GROUP BY [Ordernumber],[BusNumber] HAVING COUNT(*) > 1
)
*/
INSERT INTO PDA_BankDetails_DelBak
SELECT * FROM [PDA_BankDetails] WHERE [ID] IN (
    SELECT MAX(cast([ID] AS varchar(100))) AS ID FROM [PDA_BankDetails] WHERE [Ordernumber] IS NOT NULL AND CancellationStatus = 1 GROUP BY [Ordernumber],[BusNumber] HAVING COUNT(*) > 1
)
/* ��ɾ������,��1259��
SELECT * FROM [PDA_BankDetails] WHERE ID IN (SELECT ID FROM PDA_BankDetails_DelBak)
--��ѯ���ݹ�2518��
SELECT count(*) FROM [PDA_BankDetails] a JOIN #temp b ON a.Ordernumber = b.Ordernumber AND a.BusNumber = b.BusNumber
*/
--ɾ���ظ�����
DELETE FROM [PDA_BankDetails] WHERE ID IN (SELECT ID FROM PDA_BankDetails_DelBak)
GO



/* ��ѯ�Ƿ����ظ����ݣ�ɾ��ǰ��ѯ��1259��
SELECT COUNT(*) FROM (SELECT Ordernumber, BusNumber FROM PDA_BankDetails GROUP BY Ordernumber, BusNumber HAVING COUNT(*) > 1) a
*/



--�ؽ�����ΪOrdernumber + BusNumber
DECLARE @pk varchar(100), @sql nvarchar(4000)
--ɾ��ԭ����
SELECT @pk = name FROM sysobjects WHERE parent_obj = object_id(N'PDA_BankDetails') AND xtype = 'PK'
SET @sql = 'ALTER TABLE PDA_BankDetails DROP CONSTRAINT ' + @pk
PRINT @sql
EXECUTE sp_executesql @sql
GO


--�ؽ��µ�����
ALTER TABLE PDA_BankDetails ALTER COLUMN Ordernumber nvarchar(100) not null 
ALTER TABLE PDA_BankDetails ALTER COLUMN BusNumber nvarchar(100) not null
ALTER TABLE PDA_BankDetails ADD CONSTRAINT PK_PDA_BankDetails_Ordernumber PRIMARY KEY (BusNumber, Ordernumber)
--ALTER TABLE PDA_BankDetails ADD CONSTRAINT DF_PDA_BankDetails_Ordernumber DEFAULT('') FOR Ordernumber
GO


/*
SELECT * FROM PDA_BankDetails_DelBak
DROP TABLE PDA_BankDetails_DelBak
ALTER TABLE PDA_BankDetails DROP CONSTRAINT DF_PDA_BankDetails_Ordernumber
*/
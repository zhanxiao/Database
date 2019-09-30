/***************************************************
说明：
1. 核销表历史数据中Ordernuber为null的数据统一更新为ID值
2. 核销表以交易流水号+订单号确定唯一，修改表主键为交易流水号+订单号
3. 重复数据中核销不一致的数据经过手动核销的保留，对应未手动核销的重复数据删除
4. 重复数据中核销一致的数据，选取ID值大的一条删除
5. 处理逻辑：将待删除的数据查询并插入新表PDA_BankDetails_DelBak中，处理完确认无误后需要手动将表PDA_BankDetails_DelBak删除
****************************************************/

--将订单号为空的订单号赋值为ID
/*
SELECT * FROM [PDA_BankDetails] WHERE Ordernumber IS NULL
SELECT count(*) FROM [PDA_BankDetails] WHERE Ordernumber IS NULL  --404287条
SELECT count(*) FROM [PDA_BankDetails] WHERE BusNumber IS NULL    --0条
*/
UPDATE [PDA_BankDetails] SET Ordernumber = ID WHERE Ordernumber IS NULL
GO



--Ordernumber重复数据中被手动核销的另外一条数据
/*
--以Ordernumber和BusNumber确定唯一能查到共3条数据
SELECT [Ordernumber],[BusNumber] FROM [PDA_BankDetails] WHERE [Ordernumber] IS NOT NULL AND CancellationStatus <> 1 AND [Ordernumber] IS NOT NULL GROUP BY [Ordernumber],[BusNumber] HAVING COUNT(*) > 1

--共3条数据，留下手动核销的
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
--Ordernumber重复数据
/*
--共1256条
SELECT count(*) FROM [PDA_BankDetails] WHERE [ID] IN (
	SELECT MAX(cast([ID] AS varchar(100))) AS ID FROM [PDA_BankDetails] WHERE [Ordernumber] IS NOT NULL AND CancellationStatus = 1 GROUP BY [Ordernumber],[BusNumber] HAVING COUNT(*) > 1
)
*/
INSERT INTO PDA_BankDetails_DelBak
SELECT * FROM [PDA_BankDetails] WHERE [ID] IN (
    SELECT MAX(cast([ID] AS varchar(100))) AS ID FROM [PDA_BankDetails] WHERE [Ordernumber] IS NOT NULL AND CancellationStatus = 1 GROUP BY [Ordernumber],[BusNumber] HAVING COUNT(*) > 1
)
/* 待删除数据,共1259条
SELECT * FROM [PDA_BankDetails] WHERE ID IN (SELECT ID FROM PDA_BankDetails_DelBak)
--查询数据共2518条
SELECT count(*) FROM [PDA_BankDetails] a JOIN #temp b ON a.Ordernumber = b.Ordernumber AND a.BusNumber = b.BusNumber
*/
--删除重复数据
DELETE FROM [PDA_BankDetails] WHERE ID IN (SELECT ID FROM PDA_BankDetails_DelBak)
GO



/* 查询是否还有重复数据，删除前查询共1259条
SELECT COUNT(*) FROM (SELECT Ordernumber, BusNumber FROM PDA_BankDetails GROUP BY Ordernumber, BusNumber HAVING COUNT(*) > 1) a
*/



--重建主键为Ordernumber + BusNumber
DECLARE @pk varchar(100), @sql nvarchar(4000)
--删除原主键
SELECT @pk = name FROM sysobjects WHERE parent_obj = object_id(N'PDA_BankDetails') AND xtype = 'PK'
SET @sql = 'ALTER TABLE PDA_BankDetails DROP CONSTRAINT ' + @pk
PRINT @sql
EXECUTE sp_executesql @sql
GO


--重建新的主键
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
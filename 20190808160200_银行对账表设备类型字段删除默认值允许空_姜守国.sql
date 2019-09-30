--王龙要求删除交易明细表中设备类型字段的默认值

DECLARE @default_name varchar(100),
		@sql nvarchar(1000)

--查询表PDA_BankDetails字段SourceType的默认值约束
SELECT @default_name = a.name 
FROM sys.default_constraints a
JOIN sys.columns b ON a.object_id = b.default_object_id
WHERE b.name = 'SourceType' AND b.object_id = OBJECT_ID(N'PDA_BankDetails')

--删除表PDA_BankDetails字段SourceType的默认值约束
SET @sql = 'ALTER TABLE PDA_BankDetails DROP CONSTRAINT ' + @default_name
EXECUTE sp_executesql @sql

--修改表PDA_BankDetails字段SourceType可为空
ALTER TABLE PDA_BankDetails ALTER COLUMN SourceType int NULL


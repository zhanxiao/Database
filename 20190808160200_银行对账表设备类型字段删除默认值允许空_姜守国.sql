--����Ҫ��ɾ��������ϸ�����豸�����ֶε�Ĭ��ֵ

DECLARE @default_name varchar(100),
		@sql nvarchar(1000)

--��ѯ��PDA_BankDetails�ֶ�SourceType��Ĭ��ֵԼ��
SELECT @default_name = a.name 
FROM sys.default_constraints a
JOIN sys.columns b ON a.object_id = b.default_object_id
WHERE b.name = 'SourceType' AND b.object_id = OBJECT_ID(N'PDA_BankDetails')

--ɾ����PDA_BankDetails�ֶ�SourceType��Ĭ��ֵԼ��
SET @sql = 'ALTER TABLE PDA_BankDetails DROP CONSTRAINT ' + @default_name
EXECUTE sp_executesql @sql

--�޸ı�PDA_BankDetails�ֶ�SourceType��Ϊ��
ALTER TABLE PDA_BankDetails ALTER COLUMN SourceType int NULL


USE ztwl
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'PDA_BankDetails') AND name = N'Ordernumber')
BEGIN
	ALTER TABLE PDA_BankDetails ADD Ordernumber nvarchar(100)
	EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'������', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'PDA_BankDetails', @level2type=N'COLUMN', @level2name=N'Ordernumber'
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'PDA_BankDetails') AND name = N'SourceType')
BEGIN
	ALTER TABLE PDA_BankDetails ADD SourceType int default(1)
	EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'�豸���ͣ�1��POS����2����׿�豸��3��IOS�豸��4��PC����Ĭ��POS����', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'PDA_BankDetails', @level2type=N'COLUMN', @level2name=N'SourceType'
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'PDA_BankDetails') AND name = N'PayType')
BEGIN
	ALTER TABLE PDA_BankDetails ADD PayType int not null default(2)
	EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'���ʽ��1��MPosˢ�� 2��Posˢ�� 3��΢�����˴��� 4��֧�������˴��� 5������ 6�����֧�� 7�����ֱ�� 8��֧���� 9��΢�� 10��ϵͳ�ۿ', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'PDA_BankDetails', @level2type=N'COLUMN', @level2name=N'PayType'	
END
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'PDA_BankDetails') AND name = N'IsAgreement')
BEGIN
	ALTER TABLE PDA_BankDetails ADD IsAgreement bit
	EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'�����Ƿ�һ�±�ʶ��0��һ�£�1һ�£�', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'PDA_BankDetails', @level2type=N'COLUMN', @level2name=N'IsAgreement'
END
GO

/*
SELECT * FROM PDA_BankDetails
--ɾ��Լ��
DECLARE @name varchar(100), @sql nvarchar(4000)
SELECT @name = b.name FROM syscolumns a,sysobjects b WHERE a.id=object_id('PDA_BankDetails') AND b.id=a.cdefault AND a.name='PayType' AND b.name LIKE 'DF%'
SET @sql = N'ALTER TABLE PDA_BankDetails DROP CONSTRAINT ' + @name
EXECUTE sp_executesql @sql
SELECT @name = b.name FROM syscolumns a,sysobjects b WHERE a.id=object_id('PDA_BankDetails') AND b.id=a.cdefault AND a.name='SourceType' AND b.name LIKE 'DF%'
SET @sql = N'ALTER TABLE PDA_BankDetails DROP CONSTRAINT ' + @name
EXECUTE sp_executesql @sql
--ɾ����
ALTER TABLE PDA_BankDetails DROP COLUMN Ordernumber, SourceType, PayType, IsAgreement

*/



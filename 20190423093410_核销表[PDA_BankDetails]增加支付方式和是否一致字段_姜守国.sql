USE ztwl
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'PDA_BankDetails') AND name = N'Ordernumber')
BEGIN
	ALTER TABLE PDA_BankDetails ADD Ordernumber nvarchar(100)
	EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'订单号', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'PDA_BankDetails', @level2type=N'COLUMN', @level2name=N'Ordernumber'
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'PDA_BankDetails') AND name = N'SourceType')
BEGIN
	ALTER TABLE PDA_BankDetails ADD SourceType int default(1)
	EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'设备类型（1：POS机；2：安卓设备；3：IOS设备；4：PC）（默认POS机）', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'PDA_BankDetails', @level2type=N'COLUMN', @level2name=N'SourceType'
END
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'PDA_BankDetails') AND name = N'PayType')
BEGIN
	ALTER TABLE PDA_BankDetails ADD PayType int not null default(2)
	EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'付款方式（1：MPos刷卡 2：Pos刷卡 3：微信他人代付 4：支付宝他人代付 5：网银 6：快捷支付 7：余额直充 8：支付宝 9：微信 10：系统扣款）', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'PDA_BankDetails', @level2type=N'COLUMN', @level2name=N'PayType'	
END
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'PDA_BankDetails') AND name = N'IsAgreement')
BEGIN
	ALTER TABLE PDA_BankDetails ADD IsAgreement bit
	EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'核销是否一致标识（0不一致，1一致）', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'PDA_BankDetails', @level2type=N'COLUMN', @level2name=N'IsAgreement'
END
GO

/*
SELECT * FROM PDA_BankDetails
--删除约束
DECLARE @name varchar(100), @sql nvarchar(4000)
SELECT @name = b.name FROM syscolumns a,sysobjects b WHERE a.id=object_id('PDA_BankDetails') AND b.id=a.cdefault AND a.name='PayType' AND b.name LIKE 'DF%'
SET @sql = N'ALTER TABLE PDA_BankDetails DROP CONSTRAINT ' + @name
EXECUTE sp_executesql @sql
SELECT @name = b.name FROM syscolumns a,sysobjects b WHERE a.id=object_id('PDA_BankDetails') AND b.id=a.cdefault AND a.name='SourceType' AND b.name LIKE 'DF%'
SET @sql = N'ALTER TABLE PDA_BankDetails DROP CONSTRAINT ' + @name
EXECUTE sp_executesql @sql
--删除列
ALTER TABLE PDA_BankDetails DROP COLUMN Ordernumber, SourceType, PayType, IsAgreement

*/



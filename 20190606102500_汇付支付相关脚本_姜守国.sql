/*
创建汇付结算文件路径表
*/
USE OPENAPI
GO

IF EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Huifu_SettlementBillUrl') AND type in (N'U'))
	DROP TABLE Huifu_SettlementBillUrl
GO

CREATE TABLE Huifu_SettlementBillUrl
(
	Id int identity(1,1) primary key,
	QueryDate datetime not null default(getdate()),
	SettlementDate datetime,
	FileUrl varchar(500),
	FileType varchar(50),
	FileSeq varchar(50),
	FileSuff varchar(50),
	FileName varchar(100),
	State tinyint not null default(0)
)
GO

execute sp_addextendedproperty @name=N'MS_Description', @value=N'获取日期', @level0type=N'SCHEMA', @level0name='dbo', @level1type=N'TABLE', @level1name=N'Huifu_SettlementBillUrl', @level2type=N'COLUMN', @level2name='QueryDate'
execute sp_addextendedproperty @name=N'MS_Description', @value=N'账单核销日期', @level0type=N'SCHEMA', @level0name='dbo', @level1type=N'TABLE', @level1name=N'Huifu_SettlementBillUrl', @level2type=N'COLUMN', @level2name='SettlementDate'
execute sp_addextendedproperty @name=N'MS_Description', @value=N'文件地址', @level0type=N'SCHEMA', @level0name='dbo', @level1type=N'TABLE', @level1name=N'Huifu_SettlementBillUrl', @level2type=N'COLUMN', @level2name='FileUrl'
execute sp_addextendedproperty @name=N'MS_Description', @value=N'文件类型', @level0type=N'SCHEMA', @level0name='dbo', @level1type=N'TABLE', @level1name=N'Huifu_SettlementBillUrl', @level2type=N'COLUMN', @level2name='FileType'
execute sp_addextendedproperty @name=N'MS_Description', @value=N'文件序号', @level0type=N'SCHEMA', @level0name='dbo', @level1type=N'TABLE', @level1name=N'Huifu_SettlementBillUrl', @level2type=N'COLUMN', @level2name='FileSeq'
execute sp_addextendedproperty @name=N'MS_Description', @value=N'文件后缀', @level0type=N'SCHEMA', @level0name='dbo', @level1type=N'TABLE', @level1name=N'Huifu_SettlementBillUrl', @level2type=N'COLUMN', @level2name='FileSuff'
execute sp_addextendedproperty @name=N'MS_Description', @value=N'文件名称', @level0type=N'SCHEMA', @level0name='dbo', @level1type=N'TABLE', @level1name=N'Huifu_SettlementBillUrl', @level2type=N'COLUMN', @level2name='FileName'
execute sp_addextendedproperty @name=N'MS_Description', @value=N'账单处理状态（0未处理、1已处理、2处理失败）', @level0type=N'SCHEMA', @level0name='dbo', @level1type=N'TABLE', @level1name=N'Huifu_SettlementBillUrl', @level2type=N'COLUMN', @level2name='State'
GO


/*
配置表增加融合支付报告相关配置
*/

IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '汇付天下通用接口地址')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('汇付天下通用接口地址', 'https://apptrade.testpnr.com/api/merchantRequest')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '汇付天下上传下载接口地址')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('汇付天下上传下载接口地址', 'https://apptrade.testpnr.com/api/fileMerchantRequest')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '汇付天下回调地址')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('汇付天下回调地址', 'http://wxtest.ztky.com:5322/CustomerOpen_API/HuifuCallback')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '汇付天下版本号')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('汇付天下版本号', '10')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '汇付天下回商户客户号')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('汇付天下商户客户号', '6666000000063820')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '汇付天下账户号')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('汇付天下账户号', '81520')
END
GO

/*
创建MPOS刷卡账单路径表
*/
USE OPENAPI
GO

IF EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MPOS_SettlementBillUrl') AND type in (N'U'))
	DROP TABLE MPOS_SettlementBillUrl
GO

CREATE TABLE MPOS_SettlementBillUrl
(
	Id int identity(1,1) primary key,
	QueryDate datetime not null default(getdate()),
	SettlementDate datetime,
	DownloadUrl varchar(500),
	State tinyint not null default(0)
)
GO

execute sp_addextendedproperty @name=N'MS_Description', @value=N'获取日期', @level0type=N'SCHEMA', @level0name='dbo', @level1type=N'TABLE', @level1name=N'MPOS_SettlementBillUrl', @level2type=N'COLUMN', @level2name='QueryDate'
execute sp_addextendedproperty @name=N'MS_Description', @value=N'账单核销日期', @level0type=N'SCHEMA', @level0name='dbo', @level1type=N'TABLE', @level1name=N'MPOS_SettlementBillUrl', @level2type=N'COLUMN', @level2name='SettlementDate'
execute sp_addextendedproperty @name=N'MS_Description', @value=N'账单下载路径', @level0type=N'SCHEMA', @level0name='dbo', @level1type=N'TABLE', @level1name=N'MPOS_SettlementBillUrl', @level2type=N'COLUMN', @level2name='DownloadUrl'
execute sp_addextendedproperty @name=N'MS_Description', @value=N'账单处理状态（0未处理、1已处理、2处理失败）', @level0type=N'SCHEMA', @level0name='dbo', @level1type=N'TABLE', @level1name=N'MPOS_SettlementBillUrl', @level2type=N'COLUMN', @level2name='State'
GO

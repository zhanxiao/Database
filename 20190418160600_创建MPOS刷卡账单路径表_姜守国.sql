/*
����MPOSˢ���˵�·����
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

execute sp_addextendedproperty @name=N'MS_Description', @value=N'��ȡ����', @level0type=N'SCHEMA', @level0name='dbo', @level1type=N'TABLE', @level1name=N'MPOS_SettlementBillUrl', @level2type=N'COLUMN', @level2name='QueryDate'
execute sp_addextendedproperty @name=N'MS_Description', @value=N'�˵���������', @level0type=N'SCHEMA', @level0name='dbo', @level1type=N'TABLE', @level1name=N'MPOS_SettlementBillUrl', @level2type=N'COLUMN', @level2name='SettlementDate'
execute sp_addextendedproperty @name=N'MS_Description', @value=N'�˵�����·��', @level0type=N'SCHEMA', @level0name='dbo', @level1type=N'TABLE', @level1name=N'MPOS_SettlementBillUrl', @level2type=N'COLUMN', @level2name='DownloadUrl'
execute sp_addextendedproperty @name=N'MS_Description', @value=N'�˵�����״̬��0δ����1�Ѵ���2����ʧ�ܣ�', @level0type=N'SCHEMA', @level0name='dbo', @level1type=N'TABLE', @level1name=N'MPOS_SettlementBillUrl', @level2type=N'COLUMN', @level2name='State'
GO

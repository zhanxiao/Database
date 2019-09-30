/*
�����㸶�����ļ�·����
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

execute sp_addextendedproperty @name=N'MS_Description', @value=N'��ȡ����', @level0type=N'SCHEMA', @level0name='dbo', @level1type=N'TABLE', @level1name=N'Huifu_SettlementBillUrl', @level2type=N'COLUMN', @level2name='QueryDate'
execute sp_addextendedproperty @name=N'MS_Description', @value=N'�˵���������', @level0type=N'SCHEMA', @level0name='dbo', @level1type=N'TABLE', @level1name=N'Huifu_SettlementBillUrl', @level2type=N'COLUMN', @level2name='SettlementDate'
execute sp_addextendedproperty @name=N'MS_Description', @value=N'�ļ���ַ', @level0type=N'SCHEMA', @level0name='dbo', @level1type=N'TABLE', @level1name=N'Huifu_SettlementBillUrl', @level2type=N'COLUMN', @level2name='FileUrl'
execute sp_addextendedproperty @name=N'MS_Description', @value=N'�ļ�����', @level0type=N'SCHEMA', @level0name='dbo', @level1type=N'TABLE', @level1name=N'Huifu_SettlementBillUrl', @level2type=N'COLUMN', @level2name='FileType'
execute sp_addextendedproperty @name=N'MS_Description', @value=N'�ļ����', @level0type=N'SCHEMA', @level0name='dbo', @level1type=N'TABLE', @level1name=N'Huifu_SettlementBillUrl', @level2type=N'COLUMN', @level2name='FileSeq'
execute sp_addextendedproperty @name=N'MS_Description', @value=N'�ļ���׺', @level0type=N'SCHEMA', @level0name='dbo', @level1type=N'TABLE', @level1name=N'Huifu_SettlementBillUrl', @level2type=N'COLUMN', @level2name='FileSuff'
execute sp_addextendedproperty @name=N'MS_Description', @value=N'�ļ�����', @level0type=N'SCHEMA', @level0name='dbo', @level1type=N'TABLE', @level1name=N'Huifu_SettlementBillUrl', @level2type=N'COLUMN', @level2name='FileName'
execute sp_addextendedproperty @name=N'MS_Description', @value=N'�˵�����״̬��0δ����1�Ѵ���2����ʧ�ܣ�', @level0type=N'SCHEMA', @level0name='dbo', @level1type=N'TABLE', @level1name=N'Huifu_SettlementBillUrl', @level2type=N'COLUMN', @level2name='State'
GO


/*
���ñ������ں�֧�������������
*/

IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '�㸶����ͨ�ýӿڵ�ַ')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('�㸶����ͨ�ýӿڵ�ַ', 'https://apptrade.testpnr.com/api/merchantRequest')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '�㸶�����ϴ����ؽӿڵ�ַ')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('�㸶�����ϴ����ؽӿڵ�ַ', 'https://apptrade.testpnr.com/api/fileMerchantRequest')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '�㸶���»ص���ַ')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('�㸶���»ص���ַ', 'http://wxtest.ztky.com:5322/CustomerOpen_API/HuifuCallback')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '�㸶���°汾��')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('�㸶���°汾��', '10')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '�㸶���»��̻��ͻ���')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('�㸶�����̻��ͻ���', '6666000000063820')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '�㸶�����˻���')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('�㸶�����˻���', '81520')
END
GO

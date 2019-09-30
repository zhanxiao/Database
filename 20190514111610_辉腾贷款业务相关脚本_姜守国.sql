/*
���ڴ���ҵ����ؽ���ű�
*/
USE ztwl
GO

--�����¼��
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'HT_LoanRecord') AND type IN (N'U'))
	DROP TABLE HT_LoanRecord
GO
CREATE TABLE HT_LoanRecord
(
	ID int identity(1,1) primary key,
	StationId nvarchar(100),				--�������
	StationName nvarchar(100),				--��������
	LoanId nvarchar(100),					--����ID
	LoanType int,							--�������ͣ�1������滹��2�����ڣ�
	LoanTotalMoney decimal(18,0),			--�ſ��ܽ��ſ��ܽ��Ӧ���ڷſ��ֵ���+�ſ����ֽ�����λ�֣�
	LoanRechargeMoney decimal(18,0),		--�ſ��ֵ����λ�֣�
	LoanCashMoney decimal(18,0),			--�ſ����ֽ���λ�֣�
	LoanStartDate datetime,					--��������
	NowinstallmentNum int,					--��ǰ�����ڴκ�
	NowinstallmentDate datetime,			--��ǰ��������
	NowPrincipalMoney decimal(18,0),		--����Ӧ���������λ�֣�
	TotalinstallmentCount int,				--������
	CreateTime datetime default(getdate())	--����ʱ��
)
GO

EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'�������', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_LoanRecord', @level2type=N'COLUMN', @level2name=N'StationId'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'��������', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_LoanRecord', @level2type=N'COLUMN', @level2name=N'StationName'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'����ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_LoanRecord', @level2type=N'COLUMN', @level2name=N'LoanId'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'�������ͣ�1������滹��2�����ڣ�', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_LoanRecord', @level2type=N'COLUMN', @level2name=N'LoanType'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'�ſ��ܽ��ſ��ܽ��Ӧ���ڷſ��ֵ���+�ſ����ֽ�����λ�֣�', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_LoanRecord', @level2type=N'COLUMN', @level2name=N'LoanTotalMoney'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'�ſ��ֵ����λ�֣�', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_LoanRecord', @level2type=N'COLUMN', @level2name=N'LoanRechargeMoney'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'�ſ����ֽ���λ�֣�', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_LoanRecord', @level2type=N'COLUMN', @level2name=N'LoanCashMoney'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'��������', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_LoanRecord', @level2type=N'COLUMN', @level2name=N'LoanStartDate'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'��ǰ�����ڴκ�', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_LoanRecord', @level2type=N'COLUMN', @level2name=N'NowinstallmentNum'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'��ǰ��������', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_LoanRecord', @level2type=N'COLUMN', @level2name=N'NowinstallmentDate'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'����Ӧ���������λ�֣�', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_LoanRecord', @level2type=N'COLUMN', @level2name=N'NowPrincipalMoney'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'������', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_LoanRecord', @level2type=N'COLUMN', @level2name=N'TotalinstallmentCount'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'����ʱ��', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_LoanRecord', @level2type=N'COLUMN', @level2name=N'CreateTime'
GO

--�����������¼��
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'HT_SetWarnMoneyRecord') AND type IN (N'U'))
	DROP TABLE HT_SetWarnMoneyRecord
GO
CREATE TABLE HT_SetWarnMoneyRecord
(
	ID int identity(1,1) primary key,
	StationId nvarchar(100),				--�������
	StationName nvarchar(100),				--��������
	LoanId nvarchar(100),					--����ID
	LoanMsgId nvarchar(100),				--������ϢID
	SetType int,							--�������ͣ�1�ſ2�������ƣ�3���
	Fee decimal(18,0),						--��������λ�֣�
	AdjustedWarnMoney decimal(18,0),		--�����󾯽����λ�֣�	
	OperTime datetime,						--��������
	CreateTime datetime default(getdate())	--����ʱ��
)
GO

EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'�������', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_SetWarnMoneyRecord', @level2type=N'COLUMN', @level2name=N'StationId'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'��������', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_SetWarnMoneyRecord', @level2type=N'COLUMN', @level2name=N'StationName'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'����ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_SetWarnMoneyRecord', @level2type=N'COLUMN', @level2name=N'LoanId'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'������ϢID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_SetWarnMoneyRecord', @level2type=N'COLUMN', @level2name=N'LoanMsgId'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'�������ͣ�1�ſ2�������ƣ�3���', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_SetWarnMoneyRecord', @level2type=N'COLUMN', @level2name=N'SetType'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'��������λ�֣�', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_SetWarnMoneyRecord', @level2type=N'COLUMN', @level2name=N'Fee'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'�����󾯽����λ�֣�', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_SetWarnMoneyRecord', @level2type=N'COLUMN', @level2name=N'AdjustedWarnMoney'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'��������', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_SetWarnMoneyRecord', @level2type=N'COLUMN', @level2name=N'OperTime'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'����ʱ��', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_SetWarnMoneyRecord', @level2type=N'COLUMN', @level2name=N'CreateTime'
GO

USE OPENAPI
GO

--�ӿ�Ȩ��
INSERT INTO OPENAPI.dbo.Bas_InterfaceList (Interface,Ichinese,Idesc,Istate,IsPost,TestUrl,RealUrl,WordUrl,ParsList,Sort,Isshow,InterfaceType)
VALUES ('StationMoneySetUp', '����������ӿ�', '����������ӿ�', 0, 0, 'StandardApi/ZHsystem', '', '', 'param_json', 0, 0, 0)
,('GetStationLoanInfo', '�ſ���Ϣ���սӿ�', '�ſ���Ϣ���սӿ�', 0, 0, 'StandardApi/ZHsystem', '', '', 'param_json', 0, 0, 0)
,('StationOperation', '��������ӿڣ�����/�رգ�', '��������ӿڣ�����/�رգ�', 0, 0, 'StandardApi/ZHsystem', '', '', 'param_json', 0, 0, 0)
,('SelectStationFee', '�������ѯ�ӿ�', '�������ѯ�ӿ�', 0, 0, 'StandardApi/ZHsystem', '', '', 'param_json', 0, 0, 0)


INSERT INTO OPENAPI.dbo.WebPermission (PartnerID,Interface,Ichinese,DebugSuccess,DebugTime,IsOnline,IfDel,MaximumOfSixtySeconds,MaximumOfToday,InterfaceType,RequestUrl,RequestMethod)
VALUES ('190423095904556471', 'StationMoneySetUp', '����������ӿ�', 1, GETDATE(), 1, 0, -1, -1, 0, '', '')
,('190423095904556471', 'GetStationLoanInfo', '�ſ���Ϣ���սӿ�', 1, GETDATE(), 1, 0, -1, -1, 0, '', '')
,('190423095904556471', 'StationOperation', '��������ӿڣ�����/�رգ�', 1, GETDATE(), 1, 0, -1, -1, 0, '', '')
,('190423095904556471', 'SelectStationFee', '�������ѯ�ӿ�', 1, GETDATE(), 1, 0, -1, -1, 0, '', '')
GO

--�����ڽӿ�ʹ�õĲ���
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '����appSecret')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('����appSecret', 'www.crlg.com')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '����pid')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('����pid', '190423095904556471')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '����url')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('����url', 'http://localhost:8003')
END
GO
/*
SELECT * FROM DBO.Bas_appSettings WHERE StringKey LIKE '����%'

DELETE FROM Bas_appSettings WHERE StringKey IN ('����appSecret', '����pid', '����url')

update bas_appSettings set stringvalue= '' where stringkey = '����url'
*/
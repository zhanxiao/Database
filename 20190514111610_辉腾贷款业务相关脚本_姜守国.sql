/*
辉腾贷款业务相关建表脚本
*/
USE ztwl
GO

--贷款记录表
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'HT_LoanRecord') AND type IN (N'U'))
	DROP TABLE HT_LoanRecord
GO
CREATE TABLE HT_LoanRecord
(
	ID int identity(1,1) primary key,
	StationId nvarchar(100),				--网点代码
	StationName nvarchar(100),				--网点名称
	LoanId nvarchar(100),					--贷款ID
	LoanType int,							--融资类型（1：随借随还，2：分期）
	LoanTotalMoney decimal(18,0),			--放款总金额（放款总金额应等于放款充值金额+放款提现金额）（单位分）
	LoanRechargeMoney decimal(18,0),		--放款充值金额（单位分）
	LoanCashMoney decimal(18,0),			--放款提现金额（单位分）
	LoanStartDate datetime,					--贷款日期
	NowinstallmentNum int,					--当前到期期次号
	NowinstallmentDate datetime,			--当前到期日期
	NowPrincipalMoney decimal(18,0),		--本期应还本金金额（单位分）
	TotalinstallmentCount int,				--分期数
	CreateTime datetime default(getdate())	--推送时间
)
GO

EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'网点代码', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_LoanRecord', @level2type=N'COLUMN', @level2name=N'StationId'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'网点名称', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_LoanRecord', @level2type=N'COLUMN', @level2name=N'StationName'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'贷款ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_LoanRecord', @level2type=N'COLUMN', @level2name=N'LoanId'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'融资类型（1：随借随还，2：分期）', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_LoanRecord', @level2type=N'COLUMN', @level2name=N'LoanType'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'放款总金额（放款总金额应等于放款充值金额+放款提现金额）（单位分）', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_LoanRecord', @level2type=N'COLUMN', @level2name=N'LoanTotalMoney'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'放款充值金额（单位分）', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_LoanRecord', @level2type=N'COLUMN', @level2name=N'LoanRechargeMoney'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'放款提现金额（单位分）', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_LoanRecord', @level2type=N'COLUMN', @level2name=N'LoanCashMoney'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'贷款日期', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_LoanRecord', @level2type=N'COLUMN', @level2name=N'LoanStartDate'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'当前到期期次号', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_LoanRecord', @level2type=N'COLUMN', @level2name=N'NowinstallmentNum'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'当前到期日期', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_LoanRecord', @level2type=N'COLUMN', @level2name=N'NowinstallmentDate'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'本期应还本金金额（单位分）', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_LoanRecord', @level2type=N'COLUMN', @level2name=N'NowPrincipalMoney'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'分期数', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_LoanRecord', @level2type=N'COLUMN', @level2name=N'TotalinstallmentCount'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'推送时间', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_LoanRecord', @level2type=N'COLUMN', @level2name=N'CreateTime'
GO

--警戒金额调整记录表
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'HT_SetWarnMoneyRecord') AND type IN (N'U'))
	DROP TABLE HT_SetWarnMoneyRecord
GO
CREATE TABLE HT_SetWarnMoneyRecord
(
	ID int identity(1,1) primary key,
	StationId nvarchar(100),				--网点代码
	StationName nvarchar(100),				--网点名称
	LoanId nvarchar(100),					--贷款ID
	LoanMsgId nvarchar(100),				--调整消息ID
	SetType int,							--调整类型（1放款，2提现限制，3还款）
	Fee decimal(18,0),						--调整金额（单位分）
	AdjustedWarnMoney decimal(18,0),		--调整后警戒金额（单位分）	
	OperTime datetime,						--操作日期
	CreateTime datetime default(getdate())	--推送时间
)
GO

EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'网点代码', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_SetWarnMoneyRecord', @level2type=N'COLUMN', @level2name=N'StationId'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'网点名称', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_SetWarnMoneyRecord', @level2type=N'COLUMN', @level2name=N'StationName'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'贷款ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_SetWarnMoneyRecord', @level2type=N'COLUMN', @level2name=N'LoanId'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'调整消息ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_SetWarnMoneyRecord', @level2type=N'COLUMN', @level2name=N'LoanMsgId'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'调整类型（1放款，2提现限制，3还款）', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_SetWarnMoneyRecord', @level2type=N'COLUMN', @level2name=N'SetType'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'调整金额（单位分）', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_SetWarnMoneyRecord', @level2type=N'COLUMN', @level2name=N'Fee'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'调整后警戒金额（单位分）', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_SetWarnMoneyRecord', @level2type=N'COLUMN', @level2name=N'AdjustedWarnMoney'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'贷款日期', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_SetWarnMoneyRecord', @level2type=N'COLUMN', @level2name=N'OperTime'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'推送时间', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'HT_SetWarnMoneyRecord', @level2type=N'COLUMN', @level2name=N'CreateTime'
GO

USE OPENAPI
GO

--接口权限
INSERT INTO OPENAPI.dbo.Bas_InterfaceList (Interface,Ichinese,Idesc,Istate,IsPost,TestUrl,RealUrl,WordUrl,ParsList,Sort,Isshow,InterfaceType)
VALUES ('StationMoneySetUp', '网点金额调整接口', '网点金额调整接口', 0, 0, 'StandardApi/ZHsystem', '', '', 'param_json', 0, 0, 0)
,('GetStationLoanInfo', '放款信息接收接口', '放款信息接收接口', 0, 0, 'StandardApi/ZHsystem', '', '', 'param_json', 0, 0, 0)
,('StationOperation', '网点操作接口（开启/关闭）', '网点操作接口（开启/关闭）', 0, 0, 'StandardApi/ZHsystem', '', '', 'param_json', 0, 0, 0)
,('SelectStationFee', '网点金额查询接口', '网点金额查询接口', 0, 0, 'StandardApi/ZHsystem', '', '', 'param_json', 0, 0, 0)


INSERT INTO OPENAPI.dbo.WebPermission (PartnerID,Interface,Ichinese,DebugSuccess,DebugTime,IsOnline,IfDel,MaximumOfSixtySeconds,MaximumOfToday,InterfaceType,RequestUrl,RequestMethod)
VALUES ('190423095904556471', 'StationMoneySetUp', '网点金额调整接口', 1, GETDATE(), 1, 0, -1, -1, 0, '', '')
,('190423095904556471', 'GetStationLoanInfo', '放款信息接收接口', 1, GETDATE(), 1, 0, -1, -1, 0, '', '')
,('190423095904556471', 'StationOperation', '网点操作接口（开启/关闭）', 1, GETDATE(), 1, 0, -1, -1, 0, '', '')
,('190423095904556471', 'SelectStationFee', '网点金额查询接口', 1, GETDATE(), 1, 0, -1, -1, 0, '', '')
GO

--调辉腾接口使用的参数
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '辉腾appSecret')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('辉腾appSecret', 'www.crlg.com')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '辉腾pid')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('辉腾pid', '190423095904556471')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '辉腾url')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('辉腾url', 'http://localhost:8003')
END
GO
/*
SELECT * FROM DBO.Bas_appSettings WHERE StringKey LIKE '辉腾%'

DELETE FROM Bas_appSettings WHERE StringKey IN ('辉腾appSecret', '辉腾pid', '辉腾url')

update bas_appSettings set stringvalue= '' where stringkey = '辉腾url'
*/
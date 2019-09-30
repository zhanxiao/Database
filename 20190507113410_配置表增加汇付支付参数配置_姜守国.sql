/*
配置表增加融合支付报告相关配置
*/
USE OPENAPI
GO

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

/*
SELECT * FROM DBO.Bas_appSettings

DELETE FROM Bas_appSettings WHERE StringKey IN ('汇付天下通用接口地址', '汇付天下上传下载接口地址', '汇付天下回调地址', '汇付天下版本号', '汇付天下回商户客户号', '汇付天下账户号')

update bas_appSettings set stringvalue= 'http://wxtest.ztky.com:5322/CustomerOpen_API/HuifuCallback' where stringkey = '汇付天下回调地址'
*/



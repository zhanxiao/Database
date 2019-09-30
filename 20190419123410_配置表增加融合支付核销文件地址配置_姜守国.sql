/*
配置表增加融合支付报告相关配置
*/
USE OPENAPI
GO

IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '融合支付结算文件接口地址')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('融合支付结算文件接口地址', 'https://test.masget.com:7373/openapi/rest')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '融合支付Session')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('融合支付Session', 'c6tz08kuxlki65bbbg96gtl6ycabrow8')
END
GO

/*
SELECT * FROM DBO.Bas_appSettings

DELETE FROM Bas_appSettings WHERE StringKey IN ('融合支付结算文件接口地址', '融合支付Session')

update bas_appSettings set stringvalue= 'https://gw.masget.com:7373/openapi/rest' where stringkey = '融合支付结算文件接口地址'
*/



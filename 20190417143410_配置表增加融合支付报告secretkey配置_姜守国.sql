/*
配置表增加融合支付报告相关配置
*/
USE OPENAPI
GO

IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '融合支付报告secretkey')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('融合支付报告secretkey', '1234567890123456')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '融合支付公司id')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('融合支付公司id', '600936755')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '融合支付公司名称')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('融合支付公司名称', '荣邦科技有限公司')
END
GO

/*
SELECT * FROM DBO.Bas_appSettings

DELETE FROM Bas_appSettings WHERE StringKey IN ('融合支付报告secretkey', '融合支付公司id', '融合支付公司名称')
*/



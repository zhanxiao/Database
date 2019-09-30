/*
配置表增加阿里推送超期天数配置
*/
USE OPENAPI
GO

IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '阿里推送超期最短天数')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('阿里推送超期最短天数', '1')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '阿里推送超期最长天数')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('阿里推送超期最长天数', '7')
END
GO

/*
SELECT * FROM DBO.Bas_appSettings

DELETE FROM Bas_appSettings WHERE StringKey IN ('阿里推送超期最短天数', '阿里推送超期最长天数')
*/



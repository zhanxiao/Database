/*
配置表增加汇付天下转账接口新增的设备信息相关参数
*/

IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '汇付天下交易设备ip地址')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('汇付天下交易设备ip地址', '192.9.100.36')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '汇付天下ip省')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('汇付天下ip省', '北京市')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '汇付天下ip市')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('汇付天下ip市', '北京市')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '汇付天下ip地区')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('汇付天下ip地区', '朝阳区')
END
GO
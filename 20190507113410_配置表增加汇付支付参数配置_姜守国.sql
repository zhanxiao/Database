/*
���ñ������ں�֧�������������
*/
USE OPENAPI
GO

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

/*
SELECT * FROM DBO.Bas_appSettings

DELETE FROM Bas_appSettings WHERE StringKey IN ('�㸶����ͨ�ýӿڵ�ַ', '�㸶�����ϴ����ؽӿڵ�ַ', '�㸶���»ص���ַ', '�㸶���°汾��', '�㸶���»��̻��ͻ���', '�㸶�����˻���')

update bas_appSettings set stringvalue= 'http://wxtest.ztky.com:5322/CustomerOpen_API/HuifuCallback' where stringkey = '�㸶���»ص���ַ'
*/



/*
���ñ������ں�֧�������������
*/
USE OPENAPI
GO

IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '�ں�֧�������ļ��ӿڵ�ַ')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('�ں�֧�������ļ��ӿڵ�ַ', 'https://test.masget.com:7373/openapi/rest')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '�ں�֧��Session')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('�ں�֧��Session', 'c6tz08kuxlki65bbbg96gtl6ycabrow8')
END
GO

/*
SELECT * FROM DBO.Bas_appSettings

DELETE FROM Bas_appSettings WHERE StringKey IN ('�ں�֧�������ļ��ӿڵ�ַ', '�ں�֧��Session')

update bas_appSettings set stringvalue= 'https://gw.masget.com:7373/openapi/rest' where stringkey = '�ں�֧�������ļ��ӿڵ�ַ'
*/



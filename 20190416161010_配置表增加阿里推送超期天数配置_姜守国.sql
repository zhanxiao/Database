/*
���ñ����Ӱ������ͳ�����������
*/
USE OPENAPI
GO

IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '�������ͳ����������')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('�������ͳ����������', '1')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '�������ͳ��������')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('�������ͳ��������', '7')
END
GO

/*
SELECT * FROM DBO.Bas_appSettings

DELETE FROM Bas_appSettings WHERE StringKey IN ('�������ͳ����������', '�������ͳ��������')
*/



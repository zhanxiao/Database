/*
���ñ������ں�֧�������������
*/
USE OPENAPI
GO

IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '�ں�֧������secretkey')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('�ں�֧������secretkey', '1234567890123456')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '�ں�֧����˾id')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('�ں�֧����˾id', '600936755')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '�ں�֧����˾����')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('�ں�֧����˾����', '�ٰ�Ƽ����޹�˾')
END
GO

/*
SELECT * FROM DBO.Bas_appSettings

DELETE FROM Bas_appSettings WHERE StringKey IN ('�ں�֧������secretkey', '�ں�֧����˾id', '�ں�֧����˾����')
*/



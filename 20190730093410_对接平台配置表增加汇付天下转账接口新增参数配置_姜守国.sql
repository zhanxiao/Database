/*
���ñ����ӻ㸶����ת�˽ӿ��������豸��Ϣ��ز���
*/

IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '�㸶���½����豸ip��ַ')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('�㸶���½����豸ip��ַ', '192.9.100.36')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '�㸶����ipʡ')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('�㸶����ipʡ', '������')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '�㸶����ip��')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('�㸶����ip��', '������')
END
IF NOT EXISTS (SELECT * FROM Bas_appSettings WHERE StringKey = '�㸶����ip����')
BEGIN
	INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES ('�㸶����ip����', '������')
END
GO
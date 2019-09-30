/*
�ͻ���������Ʊ����ʱ�䡢�Ƿ�����ά�����޸��������ֶ�
*/
--SELECT * FROM Bas_Consigner
ALTER TABLE Bas_Consigner ADD IsStationMaintain bit not null default(1), LastUpdateMan varchar(20), MemoryTime datetime not null default(getdate())
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'�Ƿ�����ά��', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'Bas_Consigner', @level2type=N'COLUMN', @level2name=N'IsStationMaintain'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'�޸���', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'Bas_Consigner', @level2type=N'COLUMN', @level2name=N'LastUpdateMan'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'��Ʊ����ʱ��', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'Bas_Consigner', @level2type=N'COLUMN', @level2name=N'MemoryTime'
GO

/*
�ջ��˱������ͻ����ʡ�����ʱ�䡢�޸��������ֶ�
*/
--SELECT * FROM Bas_Consignee WHERE ifdel=0
ALTER TABLE Bas_Consignee ADD CustomerType int, LastUpdateMan varchar(20), MemoryTime datetime not null default(getdate())
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'�ͻ�����', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'Bas_Consignee', @level2type=N'COLUMN', @level2name=N'CustomerType'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'�޸���', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'Bas_Consignee', @level2type=N'COLUMN', @level2name=N'LastUpdateMan'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'��Ʊ����ʱ��', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'Bas_Consignee', @level2type=N'COLUMN', @level2name=N'MemoryTime'
GO

/*
�˵��������ͻ������ֶμ��޸����ֶ�    
*/
--SELECT * FROM OP_In_Consign
ALTER TABLE OP_In_Consign ADD CustomerType int, LastUpdateMan varchar(20)
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'�ͻ�����', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'OP_In_Consign', @level2type=N'COLUMN', @level2name=N'CustomerType'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'�޸���', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'OP_In_Consign', @level2type=N'COLUMN', @level2name=N'LastUpdateMan'
GO
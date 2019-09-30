/*
客户表新增制票记忆时间、是否网点维护、修改人三个字段
*/
--SELECT * FROM Bas_Consigner
ALTER TABLE Bas_Consigner ADD IsStationMaintain bit not null default(1), LastUpdateMan varchar(20), MemoryTime datetime not null default(getdate())
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'是否网点维护', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'Bas_Consigner', @level2type=N'COLUMN', @level2name=N'IsStationMaintain'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'修改人', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'Bas_Consigner', @level2type=N'COLUMN', @level2name=N'LastUpdateMan'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'制票记忆时间', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'Bas_Consigner', @level2type=N'COLUMN', @level2name=N'MemoryTime'
GO

/*
收货人表新增客户性质、记忆时间、修改人三个字段
*/
--SELECT * FROM Bas_Consignee WHERE ifdel=0
ALTER TABLE Bas_Consignee ADD CustomerType int, LastUpdateMan varchar(20), MemoryTime datetime not null default(getdate())
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'客户性质', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'Bas_Consignee', @level2type=N'COLUMN', @level2name=N'CustomerType'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'修改人', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'Bas_Consignee', @level2type=N'COLUMN', @level2name=N'LastUpdateMan'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'制票记忆时间', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'Bas_Consignee', @level2type=N'COLUMN', @level2name=N'MemoryTime'
GO

/*
运单表新增客户性质字段及修改人字段    
*/
--SELECT * FROM OP_In_Consign
ALTER TABLE OP_In_Consign ADD CustomerType int, LastUpdateMan varchar(20)
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'客户性质', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'OP_In_Consign', @level2type=N'COLUMN', @level2name=N'CustomerType'
EXECUTE sp_addextendedproperty @name=N'MS_Description', @value=N'修改人', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'OP_In_Consign', @level2type=N'COLUMN', @level2name=N'LastUpdateMan'
GO
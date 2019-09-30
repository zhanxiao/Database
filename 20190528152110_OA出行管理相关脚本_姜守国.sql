/*
OA���й���ű�
*/
--USE crlg_oa
--GO

--���ӽӿ�
INSERT INTO Mob_InterfaceTab (InterfaceID,InterfaceName,CalssName,MethodName)
VALUES ('SelectTripInfo', '��ѯδ��ɵĳ��м�¼', 'MobileApiBusinessLogic.TripHandler', 'SelectTripInfo')
,('StartTrip', '��ʼ����', 'MobileApiBusinessLogic.TripHandler', 'StartTrip')
,('EndTrip', '��������', 'MobileApiBusinessLogic.TripHandler', 'EndTrip')
,('CancelTrip', 'ȡ������', 'MobileApiBusinessLogic.TripHandler', 'CancelTrip')
,('SelectClient', 'ģ����ѯ�ͻ���Ϣ�б�', 'MobileApiBusinessLogic.TripHandler', 'SelectClient')
,('SelectCarrier', 'ģ����ѯ��������Ϣ', 'MobileApiBusinessLogic.TripHandler', 'SelectCarrier')

/*

SELECT * FROM crlg_oa.dbo.Mob_InterfaceTab

*/


/*
�������ñ�
*/
/*
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Bas_appSettings]') AND type in (N'U'))
DROP TABLE [dbo].[Bas_appSettings]
GO
*/

CREATE TABLE [dbo].[Bas_appSettings](
	[StringKey] [nvarchar](100) NOT NULL,
	[StringValue] [nvarchar](500) NULL,
 CONSTRAINT [PK_Bas_appSettings] PRIMARY KEY CLUSTERED 
(
	[StringKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'˵��', @value=N'ϵͳ������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Bas_appSettings'
GO

INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES 
('�ߵ�AmapKey', 'c5b3c3f7c27744da3a369232b868d14f'),
('�ͼ�', '7.20'),
('�ͺ�', '10')
GO

--�ֻ������Ӳ˵���
 INSERT INTO Mob_MenuList (BusinessID, Name, OrderID, CancelState, CalssId, SafeMode, father) VALUES (107, '���еǼ�', 107, 0, 0, 0, -1)
 
 
--��ӳ��й���˵�
DECLARE @id int,
		@parentId int,
		@orderId int
SELECT @id = MAX(ID) + 1 FROM Bas_SysPermission		 
SELECT @parentId = ID FROM Bas_SysPermission WHERE Name = '���ڹ���'
SELECT @orderId = Max(OrderID) + 1 FROM Bas_SysPermission WHERE ParentID = @parentId
--SELECT @id, @parentId, @orderId

/*

SELECT * FROM Bas_SysPermission

SELECT * FROM Bas_SysPermission WHERE ID > 383
DELETE FROM Bas_SysPermission WHERE ID > 383

*/

INSERT INTO [crlg_oa].[dbo].[Bas_SysPermission]
           ([ID]
           ,[ParentID]
           ,[Name]
           ,[OrderID]
           ,[Url]
           ,[Type]
           ,[CancelState]
           ,[ControllerName]
           ,[ActionName]
           ,[Icon]
           ,[Description])
     VALUES
           (@id --Bas_SysPermission �����ID+1 ���޸�
           ,@parentId --�˵����������� ��Id ���޸�
           ,'���й���'
           ,@orderId --�������ò˵��²˵�˳��
           ,'/Kq/TripIndex' --���й���url
           ,0 --Ȩ������ 0���˵� 1����ť
           ,0
           ,''
           ,''
           ,'icon icon-querword'
           ,'���й���')

--��ӳ��й��� ��ѯ��ť
INSERT INTO [crlg_oa].[dbo].[Bas_SysPermission]
           ([ID]
           ,[ParentID]
           ,[Name]
           ,[OrderID]
           ,[Url]
           ,[Type]
           ,[CancelState]
           ,[ControllerName]
           ,[ActionName]
           ,[Icon]
           ,[Description])
     VALUES
           (@id + 1 --Bas_SysPermission �����ID+1 ���޸�
           ,@id --�˵������й��� ��Id ���޸�
           ,'��ѯ'
           ,1 --���й���˵��� ��ť˳��
           ,''
           ,1
           ,0
           ,''
           ,''
           ,'icon-search'
           ,'btnsel')

--��ӳ��й��� ������ť
INSERT INTO [crlg_oa].[dbo].[Bas_SysPermission]
           ([ID]
           ,[ParentID]
           ,[Name]
           ,[OrderID]
           ,[Url]
           ,[Type]
           ,[CancelState]
           ,[ControllerName]
           ,[ActionName]
           ,[Icon]
           ,[Description])
     VALUES
           (@id + 2 --Bas_SysPermission �����ID+1 ���޸�
           ,@id --�˵������й��� ��Id ���޸�
           ,'����'
           ,2 --���й���˵��� ��ť˳��
           ,''
           ,1
           ,0
           ,''
           ,''
           ,'icon-redo'
           ,'btnexport')

--��ӳ��й��� ������ť
INSERT INTO [crlg_oa].[dbo].[Bas_SysPermission]
           ([ID]
           ,[ParentID]
           ,[Name]
           ,[OrderID]
           ,[Url]
           ,[Type]
           ,[CancelState]
           ,[ControllerName]
           ,[ActionName]
           ,[Icon]
           ,[Description])
     VALUES
           (@id + 3 --Bas_SysPermission �����ID+1 ���޸�
           ,@id --�˵������й��� ��Id ���޸�
           ,'����'
           ,3 --���й���˵��� ��ť˳��
           ,''
           ,1
           ,0
           ,''
           ,''
           ,'icon-edit'
           ,'btnaudit')

--��ӳ��й��� ������ť
INSERT INTO [crlg_oa].[dbo].[Bas_SysPermission]
           ([ID]
           ,[ParentID]
           ,[Name]
           ,[OrderID]
           ,[Url]
           ,[Type]
           ,[CancelState]
           ,[ControllerName]
           ,[ActionName]
           ,[Icon]
           ,[Description])
     VALUES
           (@id + 4 --Bas_SysPermission �����ID+1 ���޸�
           ,@id --�˵������й��� ��Id ���޸�
           ,'����'
           ,4 --���й���˵��� ��ť˳��
           ,''
           ,1
           ,0
           ,''
           ,''
           ,'icon-edit'
           ,'btncancellation')

--��ӳ��й��� ��ѯ����
INSERT INTO [crlg_oa].[dbo].[Bas_SysPermission]
           ([ID]
           ,[ParentID]
           ,[Name]
           ,[OrderID]
           ,[Url]
           ,[Type]
           ,[CancelState]
           ,[ControllerName]
           ,[ActionName]
           ,[Icon]
           ,[Description])
     VALUES
           (@id + 5 --Bas_SysPermission �����ID+1 ���޸�
           ,@id --�˵������й��� ��Id ���޸�
           ,'��ѯȫ��'
           ,5 --���й���˵��� ��ť˳��
           ,''
           ,1
           ,0
           ,''
           ,''
           ,'icon-search'
           ,'btnselall')
GO


/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2008                    */
/* Created on:     2019/6/4 9:42:48                             */
/*==============================================================*/


if exists (select 1
            from  sysobjects
           where  id = object_id('Bas_ClientInfo')
            and   type = 'U')
   drop table Bas_ClientInfo
go

if exists (select 1
            from  sysobjects
           where  id = object_id('OA_TripInfo')
            and   type = 'U')
   drop table OA_TripInfo
go

/*==============================================================*/
/* Table: Bas_ClientInfo                                        */
/*==============================================================*/
create table Bas_ClientInfo (
   Id                   int                  identity,
   ClientName           nvarchar(64)         not null,
   LinkName             nvarchar(32)         null,
   LinkPhone            nvarchar(32)         null,
   Address              nvarchar(128)        null,
   State                int                  not null default 0,
   Type					int					 not null default 1,
   CreateMan            nvarchar(50)         null,
   CreateTime           datetime             not null default getdate(),
   constraint PK_BAS_CLIENTINFO primary key (Id)
)
go

if exists (select 1 from  sys.extended_properties
           where major_id = object_id('Bas_ClientInfo') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'Bas_ClientInfo' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   '�ͻ���', 
   'user', @CurrentUser, 'table', 'Bas_ClientInfo'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('Bas_ClientInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Id')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'Bas_ClientInfo', 'column', 'Id'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Id',
   'user', @CurrentUser, 'table', 'Bas_ClientInfo', 'column', 'Id'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('Bas_ClientInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ClientName')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'Bas_ClientInfo', 'column', 'ClientName'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�ͻ�����',
   'user', @CurrentUser, 'table', 'Bas_ClientInfo', 'column', 'ClientName'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('Bas_ClientInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'LinkName')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'Bas_ClientInfo', 'column', 'LinkName'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��ϵ������',
   'user', @CurrentUser, 'table', 'Bas_ClientInfo', 'column', 'LinkName'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('Bas_ClientInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'LinkPhone')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'Bas_ClientInfo', 'column', 'LinkPhone'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��ϵ�˵绰',
   'user', @CurrentUser, 'table', 'Bas_ClientInfo', 'column', 'LinkPhone'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('Bas_ClientInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Address')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'Bas_ClientInfo', 'column', 'Address'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��ַ',
   'user', @CurrentUser, 'table', 'Bas_ClientInfo', 'column', 'Address'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('Bas_ClientInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'State')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'Bas_ClientInfo', 'column', 'State'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '״̬(0:����)',
   'user', @CurrentUser, 'table', 'Bas_ClientInfo', 'column', 'State'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('Bas_ClientInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateMan')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'Bas_ClientInfo', 'column', 'CreateMan'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '����(1:�����̣�2:�ͻ�)',
   'user', @CurrentUser, 'table', 'Bas_ClientInfo', 'column', 'Type'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('Bas_ClientInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Type')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'Bas_ClientInfo', 'column', 'Type'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������',
   'user', @CurrentUser, 'table', 'Bas_ClientInfo', 'column', 'CreateMan'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('Bas_ClientInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateTime')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'Bas_ClientInfo', 'column', 'CreateTime'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '����ʱ��',
   'user', @CurrentUser, 'table', 'Bas_ClientInfo', 'column', 'CreateTime'
go

/*==============================================================*/
/* Table: OA_TripInfo                                           */
/*==============================================================*/
create table OA_TripInfo (
   Id                   int                  identity,
   EmployeeCode         int                  not null,
   EmployeeName         nvarchar(50)         not null,
   CompanyId            int                  not null,
   CompanyName          nvarchar(100)        not null,
   TotalMoney           decimal(18,2)        not null default 0,
   PlanHighSpeedFee     decimal(18,2)        not null default 0,
   ActualHighSpeedFee   decimal(18,2)        not null default 0,
   OilFee               decimal(18,6)        not null default 0,
   PlanMileage          decimal(18,6)        not null default 0,
   TripReason           int                  null,
   TripExplain          nvarchar(512)        null,
   StartPosition        nvarchar(128)         null,
   EndPosition          nvarchar(128)         null,
   StartAddress         nvarchar(128)        null,
   EndAddress           nvarchar(128)        null,
   StartTime            datetime             null,
   EndTime              datetime             null,
   ClientId             varchar(36)          null,
   ClientName           nvarchar(64)         null,
   LinkName             nvarchar(50)         null,
   LinkPhone            nvarchar(32)         null,
   Address              nvarchar(128)        null,
   imgUrlList           nvarchar(512)        null,
   AuditEmployeeCode    int                  null,
   AuditEmployeeName    nvarchar(50)         null,
   AuditOpinion         nvarchar(512)        null,
   AuditExplain         nvarchar(512)        null,
   AuditTime            datetime             null,
   CancellationEmployeeCode int                  null,
   CancellationEmployeeName nvarchar(50)         null,
   CancellationTime     datetime             null,
   State                int                  not null default 1,
   CreateTime           datetime             not null default getdate(),
   constraint PK_OA_TRIPINFO primary key (Id)
)
go

if exists (select 1 from  sys.extended_properties
           where major_id = object_id('OA_TripInfo') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'OA_TripInfo' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   '���м�¼', 
   'user', @CurrentUser, 'table', 'OA_TripInfo'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Id')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'Id'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Id',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'Id'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'EmployeeCode')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'EmployeeCode'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ա�����',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'EmployeeCode'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'EmployeeName')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'EmployeeName'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '����',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'EmployeeName'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CompanyId')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'CompanyId'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������λ���',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'CompanyId'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CompanyName')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'CompanyName'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������λ����',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'CompanyName'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'TotalMoney')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'TotalMoney'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�ܽ��',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'TotalMoney'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'PlanHighSpeedFee')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'PlanHighSpeedFee'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�滮���ٷѣ�Ԫ��',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'PlanHighSpeedFee'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ActualHighSpeedFee')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'ActualHighSpeedFee'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'ʵ�ʸ��ٷѣ�Ԫ��',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'ActualHighSpeedFee'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'OilFee')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'OilFee'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�ͷѣ�Ԫ��',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'OilFee'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'PlanMileage')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'PlanMileage'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�滮��̣�km��',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'PlanMileage'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'TripReason')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'TripReason'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '����ԭ��1:Ǣ̸������,2:�ͻ��ݷ�,3:������',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'TripReason'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'TripExplain')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'TripExplain'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '����˵��',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'TripExplain'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'StartPosition')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'StartPosition'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��ʼ��λ��γ��',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'StartPosition'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'EndPosition')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'EndPosition'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������λ��γ��',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'EndPosition'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'StartAddress')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'StartAddress'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��ʼλ��',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'StartAddress'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'EndAddress')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'EndAddress'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '����λ��',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'EndAddress'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'StartTime')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'StartTime'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��ʼʱ��',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'StartTime'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'EndTime')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'EndTime'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '����ʱ��',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'EndTime'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ClientId')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'ClientId'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�ͻ�ID/������ID',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'ClientId'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ClientName')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'ClientName'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�ͻ�����/����������',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'ClientName'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'LinkName')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'LinkName'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��ϵ������',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'LinkName'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'LinkPhone')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'LinkPhone'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��ϵ�˵绰',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'LinkPhone'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Address')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'Address'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�칫��ַ',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'Address'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'imgUrlList')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'imgUrlList'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'ͼƬ������ַ�б����ŷָ�',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'imgUrlList'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'AuditEmployeeCode')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'AuditEmployeeCode'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�����˱��',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'AuditEmployeeCode'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'AuditEmployeeName')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'AuditEmployeeName'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'AuditEmployeeName'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'AuditOpinion')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'AuditOpinion'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�������',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'AuditOpinion'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'AuditExplain')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'AuditExplain'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '����˵��',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'AuditExplain'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'AuditTime')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'AuditTime'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '����ʱ��',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'AuditTime'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CancellationEmployeeCode')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'CancellationEmployeeCode'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�����˱��',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'CancellationEmployeeCode'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CancellationEmployeeName')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'CancellationEmployeeName'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'CancellationEmployeeName'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CancellationTime')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'CancellationTime'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '����ʱ��',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'CancellationTime'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'State')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'State'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '״̬��1:���п�ʼ,2:���н���,3:���ͨ��,4,���δͨ��,5:�Ѻ���,6:��ȡ��,7:��Ч��',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'State'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('OA_TripInfo')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateTime')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'CreateTime'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '����ʱ��',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'CreateTime'
go


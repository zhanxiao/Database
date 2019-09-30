/*
OA出行管理脚本
*/
--USE crlg_oa
--GO

--增加接口
INSERT INTO Mob_InterfaceTab (InterfaceID,InterfaceName,CalssName,MethodName)
VALUES ('SelectTripInfo', '查询未完成的出行记录', 'MobileApiBusinessLogic.TripHandler', 'SelectTripInfo')
,('StartTrip', '开始出行', 'MobileApiBusinessLogic.TripHandler', 'StartTrip')
,('EndTrip', '结束出行', 'MobileApiBusinessLogic.TripHandler', 'EndTrip')
,('CancelTrip', '取消出行', 'MobileApiBusinessLogic.TripHandler', 'CancelTrip')
,('SelectClient', '模糊查询客户信息列表', 'MobileApiBusinessLogic.TripHandler', 'SelectClient')
,('SelectCarrier', '模糊查询承运商信息', 'MobileApiBusinessLogic.TripHandler', 'SelectCarrier')

/*

SELECT * FROM crlg_oa.dbo.Mob_InterfaceTab

*/


/*
创建配置表
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

EXEC sys.sp_addextendedproperty @name=N'说明', @value=N'系统配置项' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Bas_appSettings'
GO

INSERT INTO Bas_appSettings (StringKey, StringValue) VALUES 
('高德AmapKey', 'c5b3c3f7c27744da3a369232b868d14f'),
('油价', '7.20'),
('油耗', '10')
GO

--手机端增加菜单项
 INSERT INTO Mob_MenuList (BusinessID, Name, OrderID, CancelState, CalssId, SafeMode, father) VALUES (107, '出行登记', 107, 0, 0, 0, -1)
 
 
--添加出行管理菜单
DECLARE @id int,
		@parentId int,
		@orderId int
SELECT @id = MAX(ID) + 1 FROM Bas_SysPermission		 
SELECT @parentId = ID FROM Bas_SysPermission WHERE Name = '考勤管理'
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
           (@id --Bas_SysPermission 表最大ID+1 需修改
           ,@parentId --菜单：其他设置 的Id 需修改
           ,'出行管理'
           ,@orderId --其他设置菜单下菜单顺序
           ,'/Kq/TripIndex' --出行管理url
           ,0 --权限类型 0：菜单 1：按钮
           ,0
           ,''
           ,''
           ,'icon icon-querword'
           ,'出行管理')

--添加出行管理 查询按钮
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
           (@id + 1 --Bas_SysPermission 表最大ID+1 需修改
           ,@id --菜单：出行管理 的Id 需修改
           ,'查询'
           ,1 --出行管理菜单下 按钮顺序
           ,''
           ,1
           ,0
           ,''
           ,''
           ,'icon-search'
           ,'btnsel')

--添加出行管理 导出按钮
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
           (@id + 2 --Bas_SysPermission 表最大ID+1 需修改
           ,@id --菜单：出行管理 的Id 需修改
           ,'导出'
           ,2 --出行管理菜单下 按钮顺序
           ,''
           ,1
           ,0
           ,''
           ,''
           ,'icon-redo'
           ,'btnexport')

--添加出行管理 审批按钮
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
           (@id + 3 --Bas_SysPermission 表最大ID+1 需修改
           ,@id --菜单：出行管理 的Id 需修改
           ,'审批'
           ,3 --出行管理菜单下 按钮顺序
           ,''
           ,1
           ,0
           ,''
           ,''
           ,'icon-edit'
           ,'btnaudit')

--添加出行管理 核销按钮
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
           (@id + 4 --Bas_SysPermission 表最大ID+1 需修改
           ,@id --菜单：出行管理 的Id 需修改
           ,'核销'
           ,4 --出行管理菜单下 按钮顺序
           ,''
           ,1
           ,0
           ,''
           ,''
           ,'icon-edit'
           ,'btncancellation')

--添加出行管理 查询所有
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
           (@id + 5 --Bas_SysPermission 表最大ID+1 需修改
           ,@id --菜单：出行管理 的Id 需修改
           ,'查询全部'
           ,5 --出行管理菜单下 按钮顺序
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
   '客户表', 
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
   '客户名称',
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
   '联系人姓名',
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
   '联系人电话',
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
   '地址',
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
   '状态(0:正常)',
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
   '类型(1:承运商，2:客户)',
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
   '创建人',
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
   '创建时间',
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
   '出行记录', 
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
   '员工编号',
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
   '姓名',
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
   '所属单位编号',
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
   '所属单位名称',
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
   '总金额',
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
   '规划高速费（元）',
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
   '实际高速费（元）',
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
   '油费（元）',
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
   '规划里程（km）',
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
   '出行原因（1:洽谈承运商,2:客户拜访,3:其他）',
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
   '出行说明',
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
   '起始定位经纬度',
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
   '结束定位经纬度',
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
   '起始位置',
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
   '结束位置',
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
   '起始时间',
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
   '结束时间',
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
   '客户ID/承运商ID',
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
   '客户名称/承运商名称',
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
   '联系人姓名',
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
   '联系人电话',
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
   '办公地址',
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
   '图片附件地址列表，逗号分隔',
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
   '审批人编号',
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
   '审批人',
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
   '审批意见',
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
   '审批说明',
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
   '审批时间',
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
   '核销人编号',
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
   '核销人',
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
   '核销时间',
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
   '状态（1:出行开始,2:出行结束,3:审核通过,4,审核未通过,5:已核销,6:已取消,7:无效）',
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
   '创建时间',
   'user', @CurrentUser, 'table', 'OA_TripInfo', 'column', 'CreateTime'
go


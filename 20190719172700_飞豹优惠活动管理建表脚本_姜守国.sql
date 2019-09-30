/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2008                    */
/* Created on:     2019/8/28 10:46:34                           */
/*==============================================================*/


if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Activity_Audit') and o.name = 'FK_ACTIVITY_AUDIT_ACTIVITY')
alter table Activity_Audit
   drop constraint FK_ACTIVITY_AUDIT_ACTIVITY
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Activity_Audit') and o.name = 'FK_ACTIVITY_AUDITCONF_ACTIVITY')
alter table Activity_Audit
   drop constraint FK_ACTIVITY_AUDITCONF_ACTIVITY
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Activity_DiscountRange') and o.name = 'FK_ACTIVITY_RANGE_ACTIVITY')
alter table Activity_DiscountRange
   drop constraint FK_ACTIVITY_RANGE_ACTIVITY
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Activity_PartakeRange') and o.name = 'FK_ACTIVITY_PARTAKERA_ACTIVITY')
alter table Activity_PartakeRange
   drop constraint FK_ACTIVITY_PARTAKERA_ACTIVITY
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Activity_PartakeRangeStation') and o.name = 'FK_ACTIVITY_RANGESTAT_ACTIVITY')
alter table Activity_PartakeRangeStation
   drop constraint FK_ACTIVITY_RANGESTAT_ACTIVITY
go

if exists (select 1 from sysobjects where id = object_id('Activity_Audit') and type = 'U')
   drop table Activity_Audit
go

if exists (select 1 from sysobjects where id = object_id('Activity_AuditConfig') and type = 'U')
   drop table Activity_AuditConfig
go

if exists (select 1 from sysobjects where id = object_id('Activity_DiscountRange') and type = 'U')
   drop table Activity_DiscountRange
go

if exists (select 1 from sysobjects where id = object_id('Activity_Info') and type = 'U')
   drop table Activity_Info
go

if exists (select 1 from sysobjects where id = object_id('Activity_PartakeRange') and type = 'U')
   drop table Activity_PartakeRange
go

if exists (select 1 from sysobjects where id = object_id('Activity_PartakeRangeStation') and type = 'U')
   drop table Activity_PartakeRangeStation
go

/*==============================================================*/
/* Table: Activity_Audit                                        */
/*==============================================================*/
create table Activity_Audit (
   Id                   int                  identity,
   ActivityId           int                  not null,
   AuditConfigId        int                  not null,
   AuditOpinion         nvarchar(500)        null,
   AuditState           int                  not null,
   IfDel                bit                  not null default 0,
   DeleteTime           datetime             null,
   AuditUserID          nvarchar(100)        null,
   AuditUserName        nvarchar(100)        null,
   AuditTime            datetime             not null default getdate(),
   CreateStationID      nvarchar(100)        null,
   CreateStationName    nvarchar(100)        null,
   constraint PK_ACTIVITY_AUDIT primary key (Id)
)
go

if exists (select 1 from  sys.extended_properties where major_id = object_id('Activity_Audit') and minor_id = 0)
begin 
    execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Audit' 
end 
execute sp_addextendedproperty 'MS_Description', '活动审核', 'user', 'dbo', 'table', 'Activity_Audit'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Audit')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Id')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Audit', 'column', 'Id'
end
execute sp_addextendedproperty 'MS_Description', '序号','user', 'dbo', 'table', 'Activity_Audit', 'column', 'Id'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Audit')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ActivityId')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Audit', 'column', 'ActivityId'
end
execute sp_addextendedproperty 'MS_Description', '活动ID','user', 'dbo', 'table', 'Activity_Audit', 'column', 'ActivityId'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Audit')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'AuditConfigId')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Audit', 'column', 'AuditConfigId'
end
execute sp_addextendedproperty 'MS_Description', '审核ID','user', 'dbo', 'table', 'Activity_Audit', 'column', 'AuditConfigId'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Audit')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'AuditOpinion')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Audit', 'column', 'AuditOpinion'
end
execute sp_addextendedproperty 'MS_Description', '审批意见','user', 'dbo', 'table', 'Activity_Audit', 'column', 'AuditOpinion'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Audit')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'AuditState')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Audit', 'column', 'AuditState'
end
execute sp_addextendedproperty 'MS_Description', '审核结果，1：同意，2：拒绝，3：自动审核同意','user', 'dbo', 'table', 'Activity_Audit', 'column', 'AuditState'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Audit')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'IfDel')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Audit', 'column', 'IfDel'
end
execute sp_addextendedproperty 'MS_Description', '删除状态','user', 'dbo', 'table', 'Activity_Audit', 'column', 'IfDel'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Audit')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'DeleteTime')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Audit', 'column', 'DeleteTime'
end
execute sp_addextendedproperty 'MS_Description', '删除时间','user', 'dbo', 'table', 'Activity_Audit', 'column', 'DeleteTime'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Audit')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'AuditUserID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Audit', 'column', 'AuditUserID'
end
execute sp_addextendedproperty 'MS_Description', '审核人ID','user', 'dbo', 'table', 'Activity_Audit', 'column', 'AuditUserID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Audit')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'AuditUserName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Audit', 'column', 'AuditUserName'
end
execute sp_addextendedproperty 'MS_Description', '审核人姓名','user', 'dbo', 'table', 'Activity_Audit', 'column', 'AuditUserName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Audit')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'AuditTime')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Audit', 'column', 'AuditTime'
end
execute sp_addextendedproperty 'MS_Description', '审核时间','user', 'dbo', 'table', 'Activity_Audit', 'column', 'AuditTime'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Audit')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateStationID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Audit', 'column', 'CreateStationID'
end
execute sp_addextendedproperty 'MS_Description', '登记网点ID','user', 'dbo', 'table', 'Activity_Audit', 'column', 'CreateStationID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Audit')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateStationName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Audit', 'column', 'CreateStationName'
end
execute sp_addextendedproperty 'MS_Description', '登录网点名称','user', 'dbo', 'table', 'Activity_Audit', 'column', 'CreateStationName'
go

/*==============================================================*/
/* Table: Activity_AuditConfig                                  */
/*==============================================================*/
create table Activity_AuditConfig (
   Id                   int                  identity,
   ActivityType         int                  null,
   "Order"              int                  null,
   Name                 nvarchar(100)        null,
   AuditUserID          nvarchar(100)        null,
   AuditUserName        nvarchar(100)        null,
   IfDel                bit                  not null default 0,
   CreateStationID      nvarchar(100)        null,
   CreateStationName    nvarchar(100)        null,
   CreateUserID         nvarchar(100)        null,
   CreateUserName       nvarchar(100)        null,
   CreateTime           datetime             not null default getdate(),
   UpdateUserID         nvarchar(100)        null,
   UpdateUserName       nvarchar(100)        null,
   UpdateTime           datetime             not null default getdate(),
   constraint PK_ACTIVITY_AUDITCONFIG primary key (Id)
)
go

if exists (select 1 from  sys.extended_properties where major_id = object_id('Activity_AuditConfig') and minor_id = 0)
begin 
    execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_AuditConfig' 
end 
execute sp_addextendedproperty 'MS_Description', '审核设置', 'user', 'dbo', 'table', 'Activity_AuditConfig'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_AuditConfig')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Id')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'Id'
end
execute sp_addextendedproperty 'MS_Description', '序号','user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'Id'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_AuditConfig')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ActivityType')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'ActivityType'
end
execute sp_addextendedproperty 'MS_Description', '活动类型，1：网点活动，2：分拨活动','user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'ActivityType'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_AuditConfig')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Order')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'Order'
end
execute sp_addextendedproperty 'MS_Description', '流转状态顺序','user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'Order'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_AuditConfig')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Name')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'Name'
end
execute sp_addextendedproperty 'MS_Description', '流转状态名称','user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'Name'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_AuditConfig')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'AuditUserID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'AuditUserID'
end
execute sp_addextendedproperty 'MS_Description', '审核人ID','user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'AuditUserID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_AuditConfig')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'AuditUserName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'AuditUserName'
end
execute sp_addextendedproperty 'MS_Description', '审核人姓名','user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'AuditUserName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_AuditConfig')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'IfDel')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'IfDel'
end
execute sp_addextendedproperty 'MS_Description', '删除状态','user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'IfDel'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_AuditConfig')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateStationID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'CreateStationID'
end
execute sp_addextendedproperty 'MS_Description', '登记网点ID','user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'CreateStationID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_AuditConfig')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateStationName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'CreateStationName'
end
execute sp_addextendedproperty 'MS_Description', '登录网点名称','user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'CreateStationName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_AuditConfig')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateUserID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'CreateUserID'
end
execute sp_addextendedproperty 'MS_Description', '创建人ID','user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'CreateUserID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_AuditConfig')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateUserName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'CreateUserName'
end
execute sp_addextendedproperty 'MS_Description', '创建人姓名','user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'CreateUserName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_AuditConfig')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateTime')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'CreateTime'
end
execute sp_addextendedproperty 'MS_Description', '创建时间','user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'CreateTime'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_AuditConfig')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'UpdateUserID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'UpdateUserID'
end
execute sp_addextendedproperty 'MS_Description', '修改人ID','user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'UpdateUserID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_AuditConfig')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'UpdateUserName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'UpdateUserName'
end
execute sp_addextendedproperty 'MS_Description', '修改人姓名','user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'UpdateUserName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_AuditConfig')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'UpdateTime')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'UpdateTime'
end
execute sp_addextendedproperty 'MS_Description', '修改时间','user', 'dbo', 'table', 'Activity_AuditConfig', 'column', 'UpdateTime'
go

/*==============================================================*/
/* Table: Activity_DiscountRange                                */
/*==============================================================*/
create table Activity_DiscountRange (
   Id                   int                  identity,
   ActivityId           int                  not null,
   ProvinceID           nvarchar(100)        null,
   Province             nvarchar(100)        null,
   CityID               nvarchar(100)        null,
   City                 nvarchar(100)        null,
   CountyID             nvarchar(100)        null,
   County               nvarchar(100)        null,
   StreetID             nvarchar(100)        null,
   Street               nvarchar(100)        null,
   constraint PK_ACTIVITY_DISCOUNTRANGE primary key (Id)
)
go

if exists (select 1 from  sys.extended_properties where major_id = object_id('Activity_DiscountRange') and minor_id = 0)
begin 
    execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_DiscountRange' 
end 
execute sp_addextendedproperty 'MS_Description', '优惠范围', 'user', 'dbo', 'table', 'Activity_DiscountRange'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_DiscountRange')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Id')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_DiscountRange', 'column', 'Id'
end
execute sp_addextendedproperty 'MS_Description', '序号','user', 'dbo', 'table', 'Activity_DiscountRange', 'column', 'Id'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_DiscountRange')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ActivityId')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_DiscountRange', 'column', 'ActivityId'
end
execute sp_addextendedproperty 'MS_Description', '活动ID','user', 'dbo', 'table', 'Activity_DiscountRange', 'column', 'ActivityId'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_DiscountRange')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ProvinceID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_DiscountRange', 'column', 'ProvinceID'
end
execute sp_addextendedproperty 'MS_Description', '省ID','user', 'dbo', 'table', 'Activity_DiscountRange', 'column', 'ProvinceID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_DiscountRange')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Province')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_DiscountRange', 'column', 'Province'
end
execute sp_addextendedproperty 'MS_Description', '省名称','user', 'dbo', 'table', 'Activity_DiscountRange', 'column', 'Province'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_DiscountRange')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CityID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_DiscountRange', 'column', 'CityID'
end
execute sp_addextendedproperty 'MS_Description', '市ID','user', 'dbo', 'table', 'Activity_DiscountRange', 'column', 'CityID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_DiscountRange')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'City')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_DiscountRange', 'column', 'City'
end
execute sp_addextendedproperty 'MS_Description', '市名称','user', 'dbo', 'table', 'Activity_DiscountRange', 'column', 'City'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_DiscountRange')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CountyID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_DiscountRange', 'column', 'CountyID'
end
execute sp_addextendedproperty 'MS_Description', '县区ID','user', 'dbo', 'table', 'Activity_DiscountRange', 'column', 'CountyID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_DiscountRange')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'County')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_DiscountRange', 'column', 'County'
end
execute sp_addextendedproperty 'MS_Description', '县区名称','user', 'dbo', 'table', 'Activity_DiscountRange', 'column', 'County'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_DiscountRange')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'StreetID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_DiscountRange', 'column', 'StreetID'
end
execute sp_addextendedproperty 'MS_Description', '乡镇街道ID','user', 'dbo', 'table', 'Activity_DiscountRange', 'column', 'StreetID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_DiscountRange')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Street')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_DiscountRange', 'column', 'Street'
end
execute sp_addextendedproperty 'MS_Description', '乡镇街道名称','user', 'dbo', 'table', 'Activity_DiscountRange', 'column', 'Street'
go

/*==============================================================*/
/* Table: Activity_Info                                         */
/*==============================================================*/
create table Activity_Info (
   Id                   int                  identity,
   ActivityType         int                  not null default 1,
   ActivityName         nvarchar(100)        not null,
   TemplateId           int                  null,
   StartTime            datetime             null,
   EndTime              datetime             null,
   StationID            nvarchar(100)        null,
   StationName          nvarchar(100)        null,
   DiscountTypeId       int                  null,
   DiscountTypeName     nvarchar(100)        null,
   DailyCycle           datetime             null,
   TransferFee          numeric(18,2)        null,
   SettlementWeightStart numeric(18,2)        null,
   SettlementWeightEnd  numeric(18,2)        null,
   ActualVolumeStart    numeric(18,2)        null,
   ActualVolumeEnd      numeric(18,2)        null,
   ProductTypeId        int                  null,
   ProductTypeName      nvarchar(100)        null,
   ActualWeightStart    numeric(18,2)        null,
   ActualWeightEnd      numeric(18,2)        null,
   ActualPieceStart     numeric(18,2)        null,
   ActualPieceEnd       numeric(18,2)        null,
   RangeStart1          numeric(18,2)        null,
   RangeEnd1            numeric(18,2)        null,
   RangeUnit1           int                  null,
   RangeDiscountValue1  numeric(18,2)        null,
   RangeUpperLimit1     numeric(18,2)        null,
   RangeStart2          numeric(18,2)        null,
   RangeEnd2            numeric(18,2)        null,
   RangeUnit2           int                  null,
   RangeDiscountValue2  numeric(18,2)        null,
   RangeUpperLimit2     numeric(18,2)        null,
   RangeStart3          numeric(18,2)        null,
   RangeEnd3            numeric(18,2)        null,
   RangeUnit3           int                  null,
   RangeDiscountValue3  numeric(18,2)        null,
   RangeUpperLimit3     numeric(18,2)        null,
   WeightPeak           numeric(18,2)        null,
   VolumePeak           numeric(18,2)        null,
   SettlementWeightPeak numeric(18,2)        null,
   IsRemind             bit                  not null default 0,
   Remark               nvarchar(500)        null,
   State                int                  not null default 1,
   IfDel                bit                  not null default 0,
   CreateStationID      nvarchar(100)        null,
   CreateStationName    nvarchar(100)        null,
   CreateUserID         nvarchar(100)        null,
   CreateUserName       nvarchar(100)        null,
   CreateTime           datetime             not null default getdate(),
   UpdateUserID         nvarchar(100)        null,
   UpdateUserName       nvarchar(100)        null,
   UpdateTime           datetime             not null default getdate(),
   constraint PK_ACTIVITY_INFO primary key (Id)
)
go

if exists (select 1 from  sys.extended_properties where major_id = object_id('Activity_Info') and minor_id = 0)
begin 
    execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info' 
end 
execute sp_addextendedproperty 'MS_Description', '活动信息', 'user', 'dbo', 'table', 'Activity_Info'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Id')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'Id'
end
execute sp_addextendedproperty 'MS_Description', '活动ID','user', 'dbo', 'table', 'Activity_Info', 'column', 'Id'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ActivityType')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'ActivityType'
end
execute sp_addextendedproperty 'MS_Description', '活动类型，1：网点活动，2：分拨活动','user', 'dbo', 'table', 'Activity_Info', 'column', 'ActivityType'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ActivityName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'ActivityName'
end
execute sp_addextendedproperty 'MS_Description', '活动名称','user', 'dbo', 'table', 'Activity_Info', 'column', 'ActivityName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'TemplateId')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'TemplateId'
end
execute sp_addextendedproperty 'MS_Description', '海报模板，1，2，3，对应三个模板','user', 'dbo', 'table', 'Activity_Info', 'column', 'TemplateId'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'StartTime')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'StartTime'
end
execute sp_addextendedproperty 'MS_Description', '活动开始时间','user', 'dbo', 'table', 'Activity_Info', 'column', 'StartTime'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'EndTime')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'EndTime'
end
execute sp_addextendedproperty 'MS_Description', '活动结束时间','user', 'dbo', 'table', 'Activity_Info', 'column', 'EndTime'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'StationID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'StationID'
end
execute sp_addextendedproperty 'MS_Description', '活动发起分拨代码','user', 'dbo', 'table', 'Activity_Info', 'column', 'StationID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'StationName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'StationName'
end
execute sp_addextendedproperty 'MS_Description', '活动发起分拨名称','user', 'dbo', 'table', 'Activity_Info', 'column', 'StationName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'DiscountTypeId')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'DiscountTypeId'
end
execute sp_addextendedproperty 'MS_Description', '优惠方式代码','user', 'dbo', 'table', 'Activity_Info', 'column', 'DiscountTypeId'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'DiscountTypeName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'DiscountTypeName'
end
execute sp_addextendedproperty 'MS_Description', '优惠方式名称','user', 'dbo', 'table', 'Activity_Info', 'column', 'DiscountTypeName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'DailyCycle')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'DailyCycle'
end
execute sp_addextendedproperty 'MS_Description', '日周期','user', 'dbo', 'table', 'Activity_Info', 'column', 'DailyCycle'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'TransferFee')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'TransferFee'
end
execute sp_addextendedproperty 'MS_Description', '中转费满','user', 'dbo', 'table', 'Activity_Info', 'column', 'TransferFee'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'SettlementWeightStart')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'SettlementWeightStart'
end
execute sp_addextendedproperty 'MS_Description', '结算重量起始值','user', 'dbo', 'table', 'Activity_Info', 'column', 'SettlementWeightStart'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'SettlementWeightEnd')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'SettlementWeightEnd'
end
execute sp_addextendedproperty 'MS_Description', '结算重量终止值','user', 'dbo', 'table', 'Activity_Info', 'column', 'SettlementWeightEnd'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ActualVolumeStart')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'ActualVolumeStart'
end
execute sp_addextendedproperty 'MS_Description', '实际体积起始值','user', 'dbo', 'table', 'Activity_Info', 'column', 'ActualVolumeStart'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ActualVolumeEnd')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'ActualVolumeEnd'
end
execute sp_addextendedproperty 'MS_Description', '实际体积终止值','user', 'dbo', 'table', 'Activity_Info', 'column', 'ActualVolumeEnd'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ProductTypeId')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'ProductTypeId'
end
execute sp_addextendedproperty 'MS_Description', '产品类型代码','user', 'dbo', 'table', 'Activity_Info', 'column', 'ProductTypeId'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ProductTypeName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'ProductTypeName'
end
execute sp_addextendedproperty 'MS_Description', '产品类型名称','user', 'dbo', 'table', 'Activity_Info', 'column', 'ProductTypeName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ActualWeightStart')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'ActualWeightStart'
end
execute sp_addextendedproperty 'MS_Description', '实际重量起始值','user', 'dbo', 'table', 'Activity_Info', 'column', 'ActualWeightStart'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ActualWeightEnd')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'ActualWeightEnd'
end
execute sp_addextendedproperty 'MS_Description', '实际重量终止值','user', 'dbo', 'table', 'Activity_Info', 'column', 'ActualWeightEnd'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ActualPieceStart')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'ActualPieceStart'
end
execute sp_addextendedproperty 'MS_Description', '实际件数起始值','user', 'dbo', 'table', 'Activity_Info', 'column', 'ActualPieceStart'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ActualPieceEnd')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'ActualPieceEnd'
end
execute sp_addextendedproperty 'MS_Description', '实际件数终止值','user', 'dbo', 'table', 'Activity_Info', 'column', 'ActualPieceEnd'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'RangeStart1')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeStart1'
end
execute sp_addextendedproperty 'MS_Description', '优惠范围1起始值','user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeStart1'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'RangeEnd1')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeEnd1'
end
execute sp_addextendedproperty 'MS_Description', '优惠范围1终止值','user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeEnd1'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'RangeUnit1')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeUnit1'
end
execute sp_addextendedproperty 'MS_Description', '优惠范围1单位','user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeUnit1'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'RangeDiscountValue1')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeDiscountValue1'
end
execute sp_addextendedproperty 'MS_Description', '优惠范围1优惠值','user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeDiscountValue1'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'RangeUpperLimit1')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeUpperLimit1'
end
execute sp_addextendedproperty 'MS_Description', '优惠范围1上限','user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeUpperLimit1'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'RangeStart2')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeStart2'
end
execute sp_addextendedproperty 'MS_Description', '优惠范围2起始值','user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeStart2'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'RangeEnd2')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeEnd2'
end
execute sp_addextendedproperty 'MS_Description', '优惠范围2终止值','user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeEnd2'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'RangeUnit2')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeUnit2'
end
execute sp_addextendedproperty 'MS_Description', '优惠范围2单位','user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeUnit2'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'RangeDiscountValue2')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeDiscountValue2'
end
execute sp_addextendedproperty 'MS_Description', '优惠范围2优惠值','user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeDiscountValue2'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'RangeUpperLimit2')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeUpperLimit2'
end
execute sp_addextendedproperty 'MS_Description', '优惠范围2上限','user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeUpperLimit2'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'RangeStart3')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeStart3'
end
execute sp_addextendedproperty 'MS_Description', '优惠范围3起始值','user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeStart3'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'RangeEnd3')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeEnd3'
end
execute sp_addextendedproperty 'MS_Description', '优惠范围3终止值','user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeEnd3'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'RangeUnit3')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeUnit3'
end
execute sp_addextendedproperty 'MS_Description', '优惠范围3单位','user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeUnit3'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'RangeDiscountValue3')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeDiscountValue3'
end
execute sp_addextendedproperty 'MS_Description', '优惠范围3优惠值','user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeDiscountValue3'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'RangeUpperLimit3')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeUpperLimit3'
end
execute sp_addextendedproperty 'MS_Description', '优惠范围3上限','user', 'dbo', 'table', 'Activity_Info', 'column', 'RangeUpperLimit3'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'WeightPeak')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'WeightPeak'
end
execute sp_addextendedproperty 'MS_Description', '重量峰值','user', 'dbo', 'table', 'Activity_Info', 'column', 'WeightPeak'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'VolumePeak')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'VolumePeak'
end
execute sp_addextendedproperty 'MS_Description', '体积峰值','user', 'dbo', 'table', 'Activity_Info', 'column', 'VolumePeak'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'SettlementWeightPeak')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'SettlementWeightPeak'
end
execute sp_addextendedproperty 'MS_Description', '结算重量峰值','user', 'dbo', 'table', 'Activity_Info', 'column', 'SettlementWeightPeak'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'IsRemind')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'IsRemind'
end
execute sp_addextendedproperty 'MS_Description', '是否前置提醒','user', 'dbo', 'table', 'Activity_Info', 'column', 'IsRemind'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Remark')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'Remark'
end
execute sp_addextendedproperty 'MS_Description', '活动说明','user', 'dbo', 'table', 'Activity_Info', 'column', 'Remark'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'State')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'State'
end
execute sp_addextendedproperty 'MS_Description', '是否前置提醒，1：待审核，2：拒绝审核，3：进行中，4：活动中止，5：结束','user', 'dbo', 'table', 'Activity_Info', 'column', 'State'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'IfDel')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'IfDel'
end
execute sp_addextendedproperty 'MS_Description', '删除状态','user', 'dbo', 'table', 'Activity_Info', 'column', 'IfDel'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateStationID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'CreateStationID'
end
execute sp_addextendedproperty 'MS_Description', '登记网点ID','user', 'dbo', 'table', 'Activity_Info', 'column', 'CreateStationID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateStationName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'CreateStationName'
end
execute sp_addextendedproperty 'MS_Description', '登录网点名称','user', 'dbo', 'table', 'Activity_Info', 'column', 'CreateStationName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateUserID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'CreateUserID'
end
execute sp_addextendedproperty 'MS_Description', '创建人ID','user', 'dbo', 'table', 'Activity_Info', 'column', 'CreateUserID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateUserName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'CreateUserName'
end
execute sp_addextendedproperty 'MS_Description', '创建人姓名','user', 'dbo', 'table', 'Activity_Info', 'column', 'CreateUserName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateTime')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'CreateTime'
end
execute sp_addextendedproperty 'MS_Description', '创建时间','user', 'dbo', 'table', 'Activity_Info', 'column', 'CreateTime'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'UpdateUserID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'UpdateUserID'
end
execute sp_addextendedproperty 'MS_Description', '修改人ID','user', 'dbo', 'table', 'Activity_Info', 'column', 'UpdateUserID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'UpdateUserName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'UpdateUserName'
end
execute sp_addextendedproperty 'MS_Description', '修改人姓名','user', 'dbo', 'table', 'Activity_Info', 'column', 'UpdateUserName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_Info')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'UpdateTime')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_Info', 'column', 'UpdateTime'
end
execute sp_addextendedproperty 'MS_Description', '修改时间','user', 'dbo', 'table', 'Activity_Info', 'column', 'UpdateTime'
go

/*==============================================================*/
/* Table: Activity_PartakeRange                                 */
/*==============================================================*/
create table Activity_PartakeRange (
   Id                   int                  identity,
   ActivityId           int                  not null,
   DiscountStartLimit   numeric(18,2)        null,
   UnitId               int                  null,
   UnitName             nvarchar(100)        null,
   IsDiscountStatistics bit                  not null default 0,
   constraint PK_ACTIVITY_PARTAKERANGE primary key (Id)
)
go

if exists (select 1 from  sys.extended_properties where major_id = object_id('Activity_PartakeRange') and minor_id = 0)
begin 
    execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_PartakeRange' 
end 
execute sp_addextendedproperty 'MS_Description', '参与范围主表', 'user', 'dbo', 'table', 'Activity_PartakeRange'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_PartakeRange')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Id')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_PartakeRange', 'column', 'Id'
end
execute sp_addextendedproperty 'MS_Description', '序号','user', 'dbo', 'table', 'Activity_PartakeRange', 'column', 'Id'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_PartakeRange')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ActivityId')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_PartakeRange', 'column', 'ActivityId'
end
execute sp_addextendedproperty 'MS_Description', '活动ID','user', 'dbo', 'table', 'Activity_PartakeRange', 'column', 'ActivityId'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_PartakeRange')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'DiscountStartLimit')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_PartakeRange', 'column', 'DiscountStartLimit'
end
execute sp_addextendedproperty 'MS_Description', '优惠起步货量','user', 'dbo', 'table', 'Activity_PartakeRange', 'column', 'DiscountStartLimit'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_PartakeRange')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'UnitId')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_PartakeRange', 'column', 'UnitId'
end
execute sp_addextendedproperty 'MS_Description', '单位ID','user', 'dbo', 'table', 'Activity_PartakeRange', 'column', 'UnitId'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_PartakeRange')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'UnitName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_PartakeRange', 'column', 'UnitName'
end
execute sp_addextendedproperty 'MS_Description', '单位名称','user', 'dbo', 'table', 'Activity_PartakeRange', 'column', 'UnitName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_PartakeRange')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'IsDiscountStatistics')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_PartakeRange', 'column', 'IsDiscountStatistics'
end
execute sp_addextendedproperty 'MS_Description', '是否按优惠范围统计','user', 'dbo', 'table', 'Activity_PartakeRange', 'column', 'IsDiscountStatistics'
go

/*==============================================================*/
/* Table: Activity_PartakeRangeStation                          */
/*==============================================================*/
create table Activity_PartakeRangeStation (
   Id                   int                  identity,
   PartakeRangeId       int                  not null,
   StationID            nvarchar(100)        null,
   StationName          nvarchar(100)        null,
   constraint PK_ACTIVITY_PARTAKERANGESTATIO primary key (Id)
)
go

if exists (select 1 from  sys.extended_properties where major_id = object_id('Activity_PartakeRangeStation') and minor_id = 0)
begin 
    execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_PartakeRangeStation' 
end 
execute sp_addextendedproperty 'MS_Description', '参与范围子表，参与的网点', 'user', 'dbo', 'table', 'Activity_PartakeRangeStation'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_PartakeRangeStation')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Id')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_PartakeRangeStation', 'column', 'Id'
end
execute sp_addextendedproperty 'MS_Description', '序号','user', 'dbo', 'table', 'Activity_PartakeRangeStation', 'column', 'Id'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_PartakeRangeStation')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'PartakeRangeId')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_PartakeRangeStation', 'column', 'PartakeRangeId'
end
execute sp_addextendedproperty 'MS_Description', '参与范围ID','user', 'dbo', 'table', 'Activity_PartakeRangeStation', 'column', 'PartakeRangeId'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_PartakeRangeStation')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'StationID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_PartakeRangeStation', 'column', 'StationID'
end
execute sp_addextendedproperty 'MS_Description', '网点ID','user', 'dbo', 'table', 'Activity_PartakeRangeStation', 'column', 'StationID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Activity_PartakeRangeStation')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'StationName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Activity_PartakeRangeStation', 'column', 'StationName'
end
execute sp_addextendedproperty 'MS_Description', '网点名称','user', 'dbo', 'table', 'Activity_PartakeRangeStation', 'column', 'StationName'
go

alter table Activity_Audit
   add constraint FK_ACTIVITY_AUDIT_ACTIVITY foreign key (ActivityId)
      references Activity_Info (Id)
go

alter table Activity_Audit
   add constraint FK_ACTIVITY_AUDITCONF_ACTIVITY foreign key (AuditConfigId)
      references Activity_AuditConfig (Id)
go

alter table Activity_DiscountRange
   add constraint FK_ACTIVITY_RANGE_ACTIVITY foreign key (ActivityId)
      references Activity_Info (Id)
go

alter table Activity_PartakeRange
   add constraint FK_ACTIVITY_PARTAKERA_ACTIVITY foreign key (ActivityId)
      references Activity_Info (Id)
go

alter table Activity_PartakeRangeStation
   add constraint FK_ACTIVITY_RANGESTAT_ACTIVITY foreign key (PartakeRangeId)
      references Activity_PartakeRange (Id)
go


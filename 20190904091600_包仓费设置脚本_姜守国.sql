/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2008                    */
/* Created on:     2019/9/9 8:53:16                             */
/*==============================================================*/


if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Bas_WPF_Excess') and o.name = 'fk_excess_ref_warehousepositionfee')
alter table Bas_WPF_Excess
   drop constraint fk_excess_ref_warehousepositionfee
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Bas_WPF_Line') and o.name = 'fk_line_ref_warehousepositionfee')
alter table Bas_WPF_Line
   drop constraint fk_line_ref_warehousepositionfee
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Bas_WPF_Station') and o.name = 'fk_station_ref_warehousepositionfee')
alter table Bas_WPF_Station
   drop constraint fk_station_ref_warehousepositionfee
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Bas_WPF_Weight') and o.name = 'fk_weight_ref_warehousepositionfee')
alter table Bas_WPF_Weight
   drop constraint fk_weight_ref_warehousepositionfee
go

if exists (select 1 from sysobjects where id = object_id('Bas_WPF_Excess') and type = 'U')
   drop table Bas_WPF_Excess
go

if exists (select 1 from sysobjects where id = object_id('Bas_WPF_Line') and type = 'U')
   drop table Bas_WPF_Line
go

if exists (select 1 from sysobjects where id = object_id('Bas_WPF_Station') and type = 'U')
   drop table Bas_WPF_Station
go

if exists (select 1 from sysobjects where id = object_id('Bas_WPF_WarehousePositionFee') and type = 'U')
   drop table Bas_WPF_WarehousePositionFee
go

if exists (select 1 from sysobjects where id = object_id('Bas_WPF_Weight') and type = 'U')
   drop table Bas_WPF_Weight
go

/*==============================================================*/
/* Table: Bas_WPF_Excess                                        */
/*==============================================================*/
create table Bas_WPF_Excess (
   Id                   int                  identity,
   WarehouseId          int                  null,
   ExcessType           int                  null,
   StartValue           numeric(18,2)        null,
   EndValue             numeric(18,2)        null,
   Rate                 numeric(18,2)        null,
   constraint PK_BAS_WPF_EXCESS primary key (Id)
)
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_Excess')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Id')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_Excess', 'column', 'Id'
end
execute sp_addextendedproperty 'MS_Description', '序号','user', 'dbo', 'table', 'Bas_WPF_Excess', 'column', 'Id'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_Excess')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'WarehouseId')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_Excess', 'column', 'WarehouseId'
end
execute sp_addextendedproperty 'MS_Description', '仓位序号','user', 'dbo', 'table', 'Bas_WPF_Excess', 'column', 'WarehouseId'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_Excess')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ExcessType')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_Excess', 'column', 'ExcessType'
end
execute sp_addextendedproperty 'MS_Description', '超额加收类型：1：按结算重量设置，2：按体积设置，3：按实际重量设置','user', 'dbo', 'table', 'Bas_WPF_Excess', 'column', 'ExcessType'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_Excess')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'StartValue')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_Excess', 'column', 'StartValue'
end
execute sp_addextendedproperty 'MS_Description', '起始值','user', 'dbo', 'table', 'Bas_WPF_Excess', 'column', 'StartValue'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_Excess')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'EndValue')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_Excess', 'column', 'EndValue'
end
execute sp_addextendedproperty 'MS_Description', '结束值','user', 'dbo', 'table', 'Bas_WPF_Excess', 'column', 'EndValue'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_Excess')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Rate')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_Excess', 'column', 'Rate'
end
execute sp_addextendedproperty 'MS_Description', '费率','user', 'dbo', 'table', 'Bas_WPF_Excess', 'column', 'Rate'
go

/*==============================================================*/
/* Table: Bas_WPF_Line                                          */
/*==============================================================*/
create table Bas_WPF_Line (
   Id                   int                  identity,
   WarehouseId          int                  null,
   LineCode             nvarchar(100)        null,
   LineName             nvarchar(100)        null,
   LineID               uniqueidentifier     null,
   LineCityName         nvarchar(100)        null,
   constraint PK_BAS_WPF_LINE primary key (Id)
)
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_Line')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Id')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_Line', 'column', 'Id'
end
execute sp_addextendedproperty 'MS_Description', '序号','user', 'dbo', 'table', 'Bas_WPF_Line', 'column', 'Id'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_Line')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'WarehouseId')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_Line', 'column', 'WarehouseId'
end
execute sp_addextendedproperty 'MS_Description', '仓位序号','user', 'dbo', 'table', 'Bas_WPF_Line', 'column', 'WarehouseId'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_Line')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'LineCode')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_Line', 'column', 'LineCode'
end
execute sp_addextendedproperty 'MS_Description', '包仓线路Code','user', 'dbo', 'table', 'Bas_WPF_Line', 'column', 'LineCode'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_Line')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'LineName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_Line', 'column', 'LineName'
end
execute sp_addextendedproperty 'MS_Description', '包仓线路Name','user', 'dbo', 'table', 'Bas_WPF_Line', 'column', 'LineName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_Line')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'LineID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_Line', 'column', 'LineID'
end
execute sp_addextendedproperty 'MS_Description', '线路ID','user', 'dbo', 'table', 'Bas_WPF_Line', 'column', 'LineID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_Line')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'LineCityName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_Line', 'column', 'LineCityName'
end
execute sp_addextendedproperty 'MS_Description', '货物流向','user', 'dbo', 'table', 'Bas_WPF_Line', 'column', 'LineCityName'
go

/*==============================================================*/
/* Table: Bas_WPF_Station                                       */
/*==============================================================*/
create table Bas_WPF_Station (
   Id                   int                  identity,
   WarehouseId          int                  null,
   StationType          int                  null,
   StationID            nvarchar(100)        null,
   StationName          nvarchar(100)        null,
   constraint PK_BAS_WPF_STATION primary key (Id)
)
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_Station')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Id')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_Station', 'column', 'Id'
end
execute sp_addextendedproperty 'MS_Description', '序号','user', 'dbo', 'table', 'Bas_WPF_Station', 'column', 'Id'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_Station')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'WarehouseId')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_Station', 'column', 'WarehouseId'
end
execute sp_addextendedproperty 'MS_Description', '仓位序号','user', 'dbo', 'table', 'Bas_WPF_Station', 'column', 'WarehouseId'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_Station')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'StationType')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_Station', 'column', 'StationType'
end
execute sp_addextendedproperty 'MS_Description', '网点类型，1：包仓网点，2：累加下属网点','user', 'dbo', 'table', 'Bas_WPF_Station', 'column', 'StationType'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_Station')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'StationID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_Station', 'column', 'StationID'
end
execute sp_addextendedproperty 'MS_Description', '网点ID','user', 'dbo', 'table', 'Bas_WPF_Station', 'column', 'StationID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_Station')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'StationName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_Station', 'column', 'StationName'
end
execute sp_addextendedproperty 'MS_Description', '网点名称','user', 'dbo', 'table', 'Bas_WPF_Station', 'column', 'StationName'
go

/*==============================================================*/
/* Table: Bas_WPF_WarehousePositionFee                          */
/*==============================================================*/
create table Bas_WPF_WarehousePositionFee (
   Id                   int                  identity,
   FeeType              int                  null,
   StationID            nvarchar(100)        null,
   StationName          nvarchar(100)        null,
   FeeCycle             int                  null,
   WarehouseFee         numeric(18,2)        null,
   StartTime            datetime             null,
   EndTime              datetime             null,
   SubStationID         nvarchar(100)        null,
   SubStationName       nvarchar(100)        null,
   Remark               nvarchar(500)        null,
   SettlementSelect     bit                  null,
   SettlementUpLimit    numeric(18,2)        null,
   VolumeSelect         bit                  null,
   VolumeUpLimit        numeric(18,2)        null,
   ActualSelect         bit                  null,
   ActualUpLimit        numeric(18,2)        null,
   AuditState           int                  not null default 0,
   AuditOpinion         nvarchar(500)        null,
   AuditUserID          nvarchar(100)        null,
   AuditUserName        nvarchar(100)        null,
   AuditTime            datetime             null,
   IfDel                bit                  not null default 0,
   CreateStationID      nvarchar(100)        null,
   CreateStationName    nvarchar(100)        null,
   CreateUserID         nvarchar(100)        null,
   CreateUserName       nvarchar(100)        null,
   CreateTime           datetime             not null default getdate(),
   UpdateUserID         nvarchar(100)        null,
   UpdateUserName       nvarchar(100)        null,
   UpdateTime           datetime             not null default getdate(),
   constraint PK_BAS_WPF_WAREHOUSEPOSITIONFE primary key (Id)
)
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Id')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'Id'
end
execute sp_addextendedproperty 'MS_Description', '序号','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'Id'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'FeeType')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'FeeType'
end
execute sp_addextendedproperty 'MS_Description', '仓位费类型，1：买断仓位费、2：阶梯包仓费、3：超额加收','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'FeeType'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'StationID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'StationID'
end
execute sp_addextendedproperty 'MS_Description', '收款单位ID','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'StationID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'StationName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'StationName'
end
execute sp_addextendedproperty 'MS_Description', '本网点及下属网点','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'StationName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'FeeCycle')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'FeeCycle'
end
execute sp_addextendedproperty 'MS_Description', '包仓扣费周期，1：自然日、2：自然周、3：自然月','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'FeeCycle'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'WarehouseFee')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'WarehouseFee'
end
execute sp_addextendedproperty 'MS_Description', '包仓费','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'WarehouseFee'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'StartTime')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'StartTime'
end
execute sp_addextendedproperty 'MS_Description', '包仓有效期开始','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'StartTime'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'EndTime')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'EndTime'
end
execute sp_addextendedproperty 'MS_Description', '包仓有效期结束','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'EndTime'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'SubStationID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'SubStationID'
end
execute sp_addextendedproperty 'MS_Description', '是否累加下属网点货量ID','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'SubStationID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'SubStationName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'SubStationName'
end
execute sp_addextendedproperty 'MS_Description', '是否累加下属网点货量Name','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'SubStationName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Remark')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'Remark'
end
execute sp_addextendedproperty 'MS_Description', '备注','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'Remark'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'SettlementSelect')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'SettlementSelect'
end
execute sp_addextendedproperty 'MS_Description', '超额结算重量是否选择','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'SettlementSelect'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'SettlementUpLimit')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'SettlementUpLimit'
end
execute sp_addextendedproperty 'MS_Description', '超额结算重量上限','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'SettlementUpLimit'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'VolumeSelect')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'VolumeSelect'
end
execute sp_addextendedproperty 'MS_Description', '超额体积是否选择','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'VolumeSelect'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'VolumeUpLimit')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'VolumeUpLimit'
end
execute sp_addextendedproperty 'MS_Description', '超额体积上限','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'VolumeUpLimit'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ActualSelect')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'ActualSelect'
end
execute sp_addextendedproperty 'MS_Description', '超额实际重量是否选择','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'ActualSelect'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ActualUpLimit')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'ActualUpLimit'
end
execute sp_addextendedproperty 'MS_Description', '超额实际重量上限','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'ActualUpLimit'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'AuditState')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'AuditState'
end
execute sp_addextendedproperty 'MS_Description', '审核状态，0：未审核，1：审核通过，2：审核不通过','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'AuditState'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'AuditOpinion')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'AuditOpinion'
end
execute sp_addextendedproperty 'MS_Description', '审批意见','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'AuditOpinion'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'AuditUserID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'AuditUserID'
end
execute sp_addextendedproperty 'MS_Description', '审核人ID','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'AuditUserID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'AuditUserName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'AuditUserName'
end
execute sp_addextendedproperty 'MS_Description', '审核人姓名','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'AuditUserName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'AuditTime')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'AuditTime'
end
execute sp_addextendedproperty 'MS_Description', '审核时间','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'AuditTime'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'IfDel')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'IfDel'
end
execute sp_addextendedproperty 'MS_Description', '删除状态','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'IfDel'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateStationID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'CreateStationID'
end
execute sp_addextendedproperty 'MS_Description', '登记网点ID','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'CreateStationID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateStationName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'CreateStationName'
end
execute sp_addextendedproperty 'MS_Description', '登录网点名称','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'CreateStationName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateUserID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'CreateUserID'
end
execute sp_addextendedproperty 'MS_Description', '创建人ID','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'CreateUserID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateUserName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'CreateUserName'
end
execute sp_addextendedproperty 'MS_Description', '创建人姓名','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'CreateUserName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateTime')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'CreateTime'
end
execute sp_addextendedproperty 'MS_Description', '创建时间','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'CreateTime'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'UpdateUserID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'UpdateUserID'
end
execute sp_addextendedproperty 'MS_Description', '修改人ID','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'UpdateUserID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'UpdateUserName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'UpdateUserName'
end
execute sp_addextendedproperty 'MS_Description', '修改人姓名','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'UpdateUserName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_WarehousePositionFee')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'UpdateTime')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'UpdateTime'
end
execute sp_addextendedproperty 'MS_Description', '修改时间','user', 'dbo', 'table', 'Bas_WPF_WarehousePositionFee', 'column', 'UpdateTime'
go

/*==============================================================*/
/* Table: Bas_WPF_Weight                                        */
/*==============================================================*/
create table Bas_WPF_Weight (
   Id                   int                  identity,
   WarehouseId          int                  null,
   StartWeight          numeric(18,2)        null,
   EndWeight            numeric(18,2)        null,
   WarehouseFee         numeric(18,2)        null,
   constraint PK_BAS_WPF_WEIGHT primary key (Id)
)
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_Weight')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Id')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_Weight', 'column', 'Id'
end
execute sp_addextendedproperty 'MS_Description', '序号','user', 'dbo', 'table', 'Bas_WPF_Weight', 'column', 'Id'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_Weight')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'WarehouseId')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_Weight', 'column', 'WarehouseId'
end
execute sp_addextendedproperty 'MS_Description', '仓位序号','user', 'dbo', 'table', 'Bas_WPF_Weight', 'column', 'WarehouseId'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_Weight')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'StartWeight')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_Weight', 'column', 'StartWeight'
end
execute sp_addextendedproperty 'MS_Description', '起始结算重量','user', 'dbo', 'table', 'Bas_WPF_Weight', 'column', 'StartWeight'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_Weight')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'EndWeight')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_Weight', 'column', 'EndWeight'
end
execute sp_addextendedproperty 'MS_Description', '结束结算重量','user', 'dbo', 'table', 'Bas_WPF_Weight', 'column', 'EndWeight'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('Bas_WPF_Weight')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'WarehouseFee')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'Bas_WPF_Weight', 'column', 'WarehouseFee'
end
execute sp_addextendedproperty 'MS_Description', '包仓费','user', 'dbo', 'table', 'Bas_WPF_Weight', 'column', 'WarehouseFee'
go

alter table Bas_WPF_Excess
   add constraint fk_excess_ref_warehousepositionfee foreign key (WarehouseId)
      references Bas_WPF_WarehousePositionFee (Id)
go

alter table Bas_WPF_Line
   add constraint fk_line_ref_warehousepositionfee foreign key (WarehouseId)
      references Bas_WPF_WarehousePositionFee (Id)
go

alter table Bas_WPF_Station
   add constraint fk_station_ref_warehousepositionfee foreign key (WarehouseId)
      references Bas_WPF_WarehousePositionFee (Id)
go

alter table Bas_WPF_Weight
   add constraint fk_weight_ref_warehousepositionfee foreign key (WarehouseId)
      references Bas_WPF_WarehousePositionFee (Id)
go


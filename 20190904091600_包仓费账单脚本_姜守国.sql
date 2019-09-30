/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2008                    */
/* Created on:     2019/9/23 17:21:37                           */
/*==============================================================*/


if exists (select 1 from sysobjects where id = object_id('FN_WarehousePositionFeeBill') and type = 'U')
   drop table FN_WarehousePositionFeeBill
go

if exists (select 1 from sysobjects where id = object_id('FN_WarehousePositionFeeBillDetails') and type = 'U')
   drop table FN_WarehousePositionFeeBillDetails
go

if exists (select 1 from sysobjects where id = object_id('FN_WarehousePositionFeeBillLog') and type = 'U')
   drop table FN_WarehousePositionFeeBillLog
go

/*==============================================================*/
/* Table: FN_WarehousePositionFeeBill                           */
/*==============================================================*/
create table FN_WarehousePositionFeeBill (
   Id                   int                  identity,
   WarehouseId          int                  not null,
   IsAbnormal           bit                  not null default 0,
   IsDeduct             int                  not null default 0,
   BillTime             datetime             not null default getdate(),
   StationID            nvarchar(100)        null,
   StationName          nvarchar(100)        null,
   WarehouseStationID   nvarchar(100)        null,
   WarehouseStationName nvarchar(100)        null,
   LineCode             nvarchar(100)        null,
   LineName             nvarchar(100)        null,
   LineID               nvarchar(100)        null,
   LineCityName         nvarchar(100)        null,
   FeeCycle             int                  null,
   FeeType              int                  null,
   SubGoodsQuantity     nvarchar(500)        null,
   TotalBillNum         int                  not null default 0,
   TotalGoodsNum        int                  not null default 0,
   TotalActualWeight    numeric(18,2)        not null default 0,
   TotalVolume          numeric(18,2)        not null default 0,
   TotalSettlementWeight numeric(18,2)        not null default 0,
   WarehouseFee         numeric(18,2)        not null default 0,
   SettlementWeightUpLimit numeric(18,2)        not null default 0,
   ActualWeightUpLimit  numeric(18,2)        not null default 0,
   VolumeUpLimit        numeric(18,2)        not null default 0,
   ExcessSettlementWeight numeric(18,2)        not null default 0,
   ExcessActualWeight   numeric(18,2)        not null default 0,
   ExcessVolume         numeric(18,2)        not null default 0,
   ExcessFee            numeric(18,2)        not null default 0,
   TotalFee             numeric(18,2)        not null default 0,
   Remark               nvarchar(500)        null,
   DetailsCount         int                  not null default 0,
   IfDel                bit                  not null default 0,
   CreateStationID      nvarchar(100)        null,
   CreateStationName    nvarchar(100)        null,
   CreateUserID         nvarchar(100)        null,
   CreateUserName       nvarchar(100)        null,
   CreateTime           datetime             not null default getdate(),
   UpdateUserID         nvarchar(100)        null,
   UpdateUserName       nvarchar(100)        null,
   UpdateTime           datetime             not null default getdate(),
   constraint PK_FN_WAREHOUSEPOSITIONFEEBILL primary key (Id)
)
go

if exists (select 1 from  sys.extended_properties where major_id = object_id('FN_WarehousePositionFeeBill') and minor_id = 0)
begin 
    execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill' 
end 
execute sp_addextendedproperty 'MS_Description', '包仓费账单', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Id')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'Id'
end
execute sp_addextendedproperty 'MS_Description', '序号','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'Id'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'WarehouseId')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'WarehouseId'
end
execute sp_addextendedproperty 'MS_Description', '包仓费设置ID','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'WarehouseId'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'IsAbnormal')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'IsAbnormal'
end
execute sp_addextendedproperty 'MS_Description', '是否发货异常','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'IsAbnormal'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'IsDeduct')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'IsDeduct'
end
execute sp_addextendedproperty 'MS_Description', '是否已扣款(0:否,1:是,2该扣不够扣)','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'IsDeduct'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'BillTime')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'BillTime'
end
execute sp_addextendedproperty 'MS_Description', '账单时间','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'BillTime'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'StationID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'StationID'
end
execute sp_addextendedproperty 'MS_Description', '收款单位ID','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'StationID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'StationName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'StationName'
end
execute sp_addextendedproperty 'MS_Description', '收款单位名称','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'StationName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'WarehouseStationID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'WarehouseStationID'
end
execute sp_addextendedproperty 'MS_Description', '包仓网点ID','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'WarehouseStationID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'WarehouseStationName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'WarehouseStationName'
end
execute sp_addextendedproperty 'MS_Description', '包仓网点名称','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'WarehouseStationName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'LineCode')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'LineCode'
end
execute sp_addextendedproperty 'MS_Description', '包仓线路Code','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'LineCode'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'LineName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'LineName'
end
execute sp_addextendedproperty 'MS_Description', '包仓线路名称','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'LineName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'LineID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'LineID'
end
execute sp_addextendedproperty 'MS_Description', '包仓线路ID','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'LineID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'LineCityName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'LineCityName'
end
execute sp_addextendedproperty 'MS_Description', '货物流向','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'LineCityName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'FeeCycle')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'FeeCycle'
end
execute sp_addextendedproperty 'MS_Description', '包仓扣费周期','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'FeeCycle'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'FeeType')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'FeeType'
end
execute sp_addextendedproperty 'MS_Description', '包仓类型','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'FeeType'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'SubGoodsQuantity')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'SubGoodsQuantity'
end
execute sp_addextendedproperty 'MS_Description', '累加下属网点货量','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'SubGoodsQuantity'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'TotalBillNum')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'TotalBillNum'
end
execute sp_addextendedproperty 'MS_Description', '总票数','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'TotalBillNum'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'TotalGoodsNum')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'TotalGoodsNum'
end
execute sp_addextendedproperty 'MS_Description', '总件数','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'TotalGoodsNum'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'TotalActualWeight')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'TotalActualWeight'
end
execute sp_addextendedproperty 'MS_Description', '总实际重量','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'TotalActualWeight'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'TotalVolume')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'TotalVolume'
end
execute sp_addextendedproperty 'MS_Description', '总体积','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'TotalVolume'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'TotalSettlementWeight')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'TotalSettlementWeight'
end
execute sp_addextendedproperty 'MS_Description', '总结算重量','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'TotalSettlementWeight'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'WarehouseFee')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'WarehouseFee'
end
execute sp_addextendedproperty 'MS_Description', '包仓费','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'WarehouseFee'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'SettlementWeightUpLimit')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'SettlementWeightUpLimit'
end
execute sp_addextendedproperty 'MS_Description', '结算重量上限','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'SettlementWeightUpLimit'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ActualWeightUpLimit')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'ActualWeightUpLimit'
end
execute sp_addextendedproperty 'MS_Description', '实际重量上限','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'ActualWeightUpLimit'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'VolumeUpLimit')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'VolumeUpLimit'
end
execute sp_addextendedproperty 'MS_Description', '体积上限','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'VolumeUpLimit'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ExcessSettlementWeight')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'ExcessSettlementWeight'
end
execute sp_addextendedproperty 'MS_Description', '超出部分结算重量','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'ExcessSettlementWeight'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ExcessActualWeight')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'ExcessActualWeight'
end
execute sp_addextendedproperty 'MS_Description', '超出部分实际重量','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'ExcessActualWeight'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ExcessVolume')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'ExcessVolume'
end
execute sp_addextendedproperty 'MS_Description', '超出部分体积','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'ExcessVolume'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ExcessFee')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'ExcessFee'
end
execute sp_addextendedproperty 'MS_Description', '超额加收费','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'ExcessFee'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'TotalFee')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'TotalFee'
end
execute sp_addextendedproperty 'MS_Description', '总费用','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'TotalFee'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Remark')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'Remark'
end
execute sp_addextendedproperty 'MS_Description', '备注','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'Remark'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'DetailsCount')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'DetailsCount'
end
execute sp_addextendedproperty 'MS_Description', '明细数量','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'DetailsCount'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'IfDel')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'IfDel'
end
execute sp_addextendedproperty 'MS_Description', '删除状态','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'IfDel'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateStationID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'CreateStationID'
end
execute sp_addextendedproperty 'MS_Description', '登记网点ID','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'CreateStationID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateStationName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'CreateStationName'
end
execute sp_addextendedproperty 'MS_Description', '登录网点名称','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'CreateStationName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateUserID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'CreateUserID'
end
execute sp_addextendedproperty 'MS_Description', '创建人ID','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'CreateUserID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateUserName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'CreateUserName'
end
execute sp_addextendedproperty 'MS_Description', '创建人姓名','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'CreateUserName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateTime')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'CreateTime'
end
execute sp_addextendedproperty 'MS_Description', '创建时间','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'CreateTime'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'UpdateUserID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'UpdateUserID'
end
execute sp_addextendedproperty 'MS_Description', '修改人ID','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'UpdateUserID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'UpdateUserName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'UpdateUserName'
end
execute sp_addextendedproperty 'MS_Description', '修改人姓名','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'UpdateUserName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBill')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'UpdateTime')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'UpdateTime'
end
execute sp_addextendedproperty 'MS_Description', '修改时间','user', 'dbo', 'table', 'FN_WarehousePositionFeeBill', 'column', 'UpdateTime'
go

/*==============================================================*/
/* Table: FN_WarehousePositionFeeBillDetails                    */
/*==============================================================*/
create table FN_WarehousePositionFeeBillDetails (
   Id                   int                  identity,
   BillId               int                  not null,
   LineID               nvarchar(100)        null,
   LineCityName         nvarchar(100)        null,
   LineCode             nvarchar(100)        null,
   TotalBillNum         int                  not null default 0,
   TotalGoodsNum        int                  not null default 0,
   TotalActualWeight    numeric(18,2)        not null default 0,
   TotalVolume          numeric(18,2)        not null default 0,
   TotalSettlementWeight numeric(18,2)        not null default 0,
   constraint PK_FN_WAREHOUSEPOSITIONFEEBILLDetails primary key (Id)
)
go

if exists (select 1 from  sys.extended_properties where major_id = object_id('FN_WarehousePositionFeeBillDetails') and minor_id = 0)
begin 
    execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillDetails' 
end 
execute sp_addextendedproperty 'MS_Description', '包仓费账单货物流向子表', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillDetails'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBillDetails')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Id')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillDetails', 'column', 'Id'
end
execute sp_addextendedproperty 'MS_Description', '序号','user', 'dbo', 'table', 'FN_WarehousePositionFeeBillDetails', 'column', 'Id'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBillDetails')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'BillId')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillDetails', 'column', 'BillId'
end
execute sp_addextendedproperty 'MS_Description', '账单主表序号','user', 'dbo', 'table', 'FN_WarehousePositionFeeBillDetails', 'column', 'BillId'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBillDetails')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'LineID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillDetails', 'column', 'LineID'
end
execute sp_addextendedproperty 'MS_Description', '线路ID','user', 'dbo', 'table', 'FN_WarehousePositionFeeBillDetails', 'column', 'LineID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBillDetails')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'LineCityName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillDetails', 'column', 'LineCityName'
end
execute sp_addextendedproperty 'MS_Description', '货物流向','user', 'dbo', 'table', 'FN_WarehousePositionFeeBillDetails', 'column', 'LineCityName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBillDetails')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'LineCode')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillDetails', 'column', 'LineCode'
end
execute sp_addextendedproperty 'MS_Description', '线路Code','user', 'dbo', 'table', 'FN_WarehousePositionFeeBillDetails', 'column', 'LineCode'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBillDetails')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'TotalBillNum')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillDetails', 'column', 'TotalBillNum'
end
execute sp_addextendedproperty 'MS_Description', '总票数','user', 'dbo', 'table', 'FN_WarehousePositionFeeBillDetails', 'column', 'TotalBillNum'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBillDetails')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'TotalGoodsNum')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillDetails', 'column', 'TotalGoodsNum'
end
execute sp_addextendedproperty 'MS_Description', '总件数','user', 'dbo', 'table', 'FN_WarehousePositionFeeBillDetails', 'column', 'TotalGoodsNum'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBillDetails')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'TotalActualWeight')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillDetails', 'column', 'TotalActualWeight'
end
execute sp_addextendedproperty 'MS_Description', '总实际重量','user', 'dbo', 'table', 'FN_WarehousePositionFeeBillDetails', 'column', 'TotalActualWeight'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBillDetails')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'TotalVolume')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillDetails', 'column', 'TotalVolume'
end
execute sp_addextendedproperty 'MS_Description', '总体积','user', 'dbo', 'table', 'FN_WarehousePositionFeeBillDetails', 'column', 'TotalVolume'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBillDetails')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'TotalSettlementWeight')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillDetails', 'column', 'TotalSettlementWeight'
end
execute sp_addextendedproperty 'MS_Description', '总结算重量','user', 'dbo', 'table', 'FN_WarehousePositionFeeBillDetails', 'column', 'TotalSettlementWeight'
go

/*==============================================================*/
/* Table: FN_WarehousePositionFeeBillLog                        */
/*==============================================================*/
create table FN_WarehousePositionFeeBillLog (
   Id                   int                  identity,
   BillId               int                  not null,
   FeeCycle             int                  null,
   StationID            nvarchar(100)        null,
   StationName          nvarchar(100)        null,
   WarehouseStationID   nvarchar(100)        null,
   WarehouseStationName nvarchar(100)        null,
   TotalFee             numeric(18,2)        not null default 0,
   StationYE            numeric(18,2)        not null default 0,
   WarehouseStationYE   numeric(18,2)        not null default 0,
   Remark               nvarchar(500)        null,
   CreateUserID         nvarchar(100)        null,
   CreateUserName       nvarchar(100)        null,
   CreateTime           datetime             not null default getdate(),
   constraint PK_FN_WAREHOUSEPOSITIONFEEBILLLog primary key (Id)
)
go

if exists (select 1 from  sys.extended_properties where major_id = object_id('FN_WarehousePositionFeeBillLog') and minor_id = 0)
begin 
    execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog' 
end 
execute sp_addextendedproperty 'MS_Description', '包仓费账单扣费记录', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBillLog')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Id')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'Id'
end
execute sp_addextendedproperty 'MS_Description', '序号','user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'Id'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBillLog')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'BillId')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'BillId'
end
execute sp_addextendedproperty 'MS_Description', '账单序号','user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'BillId'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBillLog')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'FeeCycle')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'FeeCycle'
end
execute sp_addextendedproperty 'MS_Description', '包仓周期','user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'FeeCycle'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBillLog')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'StationID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'StationID'
end
execute sp_addextendedproperty 'MS_Description', '收款单位ID','user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'StationID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBillLog')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'StationName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'StationName'
end
execute sp_addextendedproperty 'MS_Description', '收款单位名称','user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'StationName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBillLog')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'WarehouseStationID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'WarehouseStationID'
end
execute sp_addextendedproperty 'MS_Description', '包仓网点ID','user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'WarehouseStationID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBillLog')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'WarehouseStationName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'WarehouseStationName'
end
execute sp_addextendedproperty 'MS_Description', '包仓网点名称','user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'WarehouseStationName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBillLog')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'TotalFee')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'TotalFee'
end
execute sp_addextendedproperty 'MS_Description', '总费用','user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'TotalFee'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBillLog')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'StationYE')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'StationYE'
end
execute sp_addextendedproperty 'MS_Description', '收款单位余额','user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'StationYE'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBillLog')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'WarehouseStationYE')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'WarehouseStationYE'
end
execute sp_addextendedproperty 'MS_Description', '包仓网点余额','user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'WarehouseStationYE'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBillLog')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Remark')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'Remark'
end
execute sp_addextendedproperty 'MS_Description', '备注','user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'Remark'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBillLog')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateUserID')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'CreateUserID'
end
execute sp_addextendedproperty 'MS_Description', '创建人ID','user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'CreateUserID'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBillLog')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateUserName')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'CreateUserName'
end
execute sp_addextendedproperty 'MS_Description', '创建人姓名','user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'CreateUserName'
go

if exists(select 1 from sys.extended_properties p where p.major_id = object_id('FN_WarehousePositionFeeBillLog')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'CreateTime')
)
begin
   execute sp_dropextendedproperty 'MS_Description', 'user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'CreateTime'
end
execute sp_addextendedproperty 'MS_Description', '创建时间','user', 'dbo', 'table', 'FN_WarehousePositionFeeBillLog', 'column', 'CreateTime'
go


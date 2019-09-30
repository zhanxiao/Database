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

/*
每日凌晨00:00:00执行包仓费账单生成,生成当天的账单记录，金额都为0
*/
IF OBJECT_ID('P_GenerateWarehouseFeeBill', 'P') IS NOT NULL   
    DROP PROCEDURE P_GenerateWarehouseFeeBill
GO 
CREATE PROCEDURE P_GenerateWarehouseFeeBill
AS

DECLARE @today varchar(10) = CONVERT(varchar(10), GETDATE(), 120)
DECLARE @tomorrow varchar(10) = CONVERT(varchar(10), DATEADD(d, 1, @today), 120)

/*
TRUNCATE TABLE FN_WarehousePositionFeeBillDetails
TRUNCATE TABLE FN_WarehousePositionFeeBill

SELECT * FROM FN_WarehousePositionFeeBill
SELECT * FROM FN_WarehousePositionFeeBillDetails
--*/

/*测试
SET @today = '2019-9-18'
DELETE FROM FN_WarehousePositionFeeBillDetails WHERE BillId IN (SELECT Id FROM FN_WarehousePositionFeeBill WHERE BillTime = @today)
DELETE FROM FN_WarehousePositionFeeBill WHERE BillTime = @today
--*/

--当天账单已经生成后不再重复生成
IF EXISTS (SELECT * FROM FN_WarehousePositionFeeBill WHERE BillTime = @today)
BEGIN
	PRINT '已经生成过'
	RETURN
END

BEGIN TRANSACTION t1
BEGIN TRY
	--统计线路数据到表变量中
	DECLARE @LineTable TABLE (WarehouseId int, LineCode nvarchar(100), LineName nvarchar(100), DetailsCount int, LineCityName nvarchar(100))
	INSERT INTO @LineTable 
	SELECT WarehouseId, LineCode, LineName, COUNT(*),
		STUFF((SELECT ',' + LineCityName FROM Bas_WPF_Line WHERE a.WarehouseId = WarehouseId AND a.LineCode = LineCode AND a.LineName = LineName FOR XML PATH('')),1,1,'') AS LineCityName 
	FROM Bas_WPF_Line a
	GROUP BY WarehouseId, LineCode, LineName

	--插入包仓费账单主表数据
	INSERT INTO FN_WarehousePositionFeeBill (WarehouseId,IsAbnormal,IsDeduct,BillTime,StationID,StationName,WarehouseStationID,WarehouseStationName,LineCode,LineName,LineCityName,
		FeeCycle, FeeType, SubGoodsQuantity, SettlementWeightUpLimit,ActualWeightUpLimit,VolumeUpLimit, DetailsCount, WarehouseFee,
		Remark,CreateStationID,CreateStationName,CreateUserID,CreateUserName,UpdateUserID,UpdateUserName) 
	SELECT a.Id, 0, 0, @today AS BillTime, a.StationID, a.StationName, b.StationID, b.StationName, c.LineCode, c.LineName, c.LineCityName,
		a.FeeCycle, a.FeeType, d.SubGoodsQuantity,
		CASE a.SettlementSelect WHEN 1 THEN ISNULL(a.SettlementUpLimit, 0) ELSE 0 END, 
		CASE a.ActualSelect WHEN 1 THEN ISNULL(a.ActualUpLimit, 0) ELSE 0 END,
		CASE a.VolumeSelect WHEN 1 THEN ISNULL(a.VolumeUpLimit, 0) ELSE 0 END,
		c.DetailsCount, a.WarehouseFee, '', '000000', '总部', '', '系统', '', '系统'
	FROM Bas_WPF_WarehousePositionFee a
	JOIN Bas_WPF_Station b ON a.Id = b.WarehouseId AND b.StationType = 1
	JOIN (
		SELECT WarehouseId, SUM(DetailsCount) AS DetailsCount, 
			STUFF((SELECT ',' + LineCode FROM @LineTable WHERE a.WarehouseId = WarehouseId FOR XML PATH('')),1,1,'') AS LineCode,
			STUFF((SELECT ',' + LineName FROM @LineTable WHERE a.WarehouseId = WarehouseId FOR XML PATH('')),1,1,'') AS LineName,
			STUFF((SELECT ',' + LineCityName FROM Bas_WPF_Line WHERE a.WarehouseId = WarehouseId FOR XML PATH('')),1,1,'') AS LineCityName
		FROM @LineTable a GROUP BY WarehouseId
	) c ON a.id = c.WarehouseId
	LEFT JOIN (
		SELECT WarehouseId, STUFF((SELECT ',' + StationName FROM Bas_WPF_Station WHERE a.WarehouseId = WarehouseId FOR XML PATH('')),1,1,'') AS SubGoodsQuantity 
		FROM Bas_WPF_Station a WHERE StationType = 2 GROUP BY WarehouseId
	) d ON a.id = d.WarehouseId 
	WHERE IfDel = 0 AND AuditState = 1
	AND StartTime <= @today AND EndTime > @today

	--插入包仓费子表数据
	INSERT INTO FN_WarehousePositionFeeBillDetails (BillId, LineID, LineCityName, LineCode)
	SELECT a.Id, b.LineID, b.LineCityName, b.LineCode
	FROM FN_WarehousePositionFeeBill a
	JOIN Bas_WPF_Line b ON a.WarehouseId = b.WarehouseId
	WHERE a.BillTime >= @today AND a.BillTime <= @tomorrow
	ORDER BY a.Id

	COMMIT TRANSACTION t1
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION t1
END CATCH

GO

/*
每日凌晨01:00:00执行包仓费计算，计算前一日的账单数据
*/
IF OBJECT_ID('P_ComputeWarehouseFeeBill', 'P') IS NOT NULL   
    DROP PROCEDURE P_ComputeWarehouseFeeBill
GO 
CREATE PROCEDURE P_ComputeWarehouseFeeBill
AS

DECLARE @today varchar(10) = CONVERT(varchar(10), GETDATE(), 120)
DECLARE @yestoday varchar(10) = CONVERT(varchar(10), DATEADD(d, -1, @today), 120)

/*
SELECT * FROM FN_WarehousePositionFeeBill
SELECT * FROM FN_WarehousePositionFeeBillDetails
*/

/*测试
SET @today = '2019-9-18'
SET @yestoday = CONVERT(varchar(10), DATEADD(d, -1, @today), 120)
--*/

DECLARE @id int,
		@WarehouseId int,							--包仓费设置ID
		@StationId nvarchar(100),					--收款单位ID
		@StationName nvarchar(100),					--收款单位
		@WarehouseStationId nvarchar(100),			--包仓网点ID
		@WarehouseStationName nvarchar(100),		--包仓网点
		@LineCode nvarchar(100),					--包仓线路Code
		@LineName nvarchar(100),					--包仓线路
		@LineCityName nvarchar(100),				--货物流向
		@FeeCycle int,								--包仓扣费周期
		@FeeType int,								--包仓类型
		@TotalBillNum int = 0,						--总票数
		@TotalGoodsNum int = 0,						--总件数
		@TotalActualWeight numeric(18,2) = 0,		--总实际重量
		@TotalVolume numeric(18, 2) = 0,			--总体积
		@TotalSettlementWeight numeric(18,2) = 0,	--总结算重量
		@WarehouseFee decimal(18,2) = 0,			--包仓费		
		@SettlementUpLimit decimal(18, 2) = 0,		--结算重量上限		
		@VolumeUpLimit decimal(18, 2) = 0,			--体积上限		
		@ActualUpLimit decimal(18, 2) = 0,			--实际重量上限
		@ExcessSettlementWeight decimal(18,2) = 0,	--超出部分结算重量
		@ExcessActualWeight decimal(18,2) = 0,		--超出部分实际重量
		@ExcessVolume decimal(18,2) = 0,			--超出部分体积
		@ExcessFee decimal(18,2) = 0,				--超额加收费
		@TotalFee decimal(18,2) = 0,				--总费用

		@ExcessSettlementFee decimal(18,2) = 0,		--超出部分结算重量加收费
		@ExcessActualFee decimal(18,2) = 0,			--超出部分实际重量加收费
		@ExcessVolumeFee decimal(18,2) = 0,			--超出部分体积加收费
		@LadderWarehouseFee decimal(18, 2),			--阶梯包仓费
		@Rate decimal(18, 2)						--费率

BEGIN TRANSACTION t1
BEGIN TRY
	--查询前一天的账单数据
	DECLARE cur CURSOR FOR 
	SELECT id, WarehouseId, WarehouseFee, StationID, StationName, FeeCycle, FeeType, SettlementWeightUpLimit, VolumeUpLimit, ActualWeightUpLimit,
		WarehouseStationID, WarehouseStationName, LineCode, LineName, LinecityName 
	FROM FN_WarehousePositionFeeBill WHERE BillTime >= @yestoday AND BillTime < @today
	OPEN cur
	FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
		@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LineCityName 
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--下属网点
		DECLARE @stationTable table (StationID varchar(100))
		DELETE FROM @stationTable
		INSERT INTO @stationTable (StationID) VALUES (@WarehouseStationId)
		INSERT INTO @stationTable (StationID) SELECT StationID FROM Bas_WPF_Station WHERE StationType = 2 AND WarehouseId = @WarehouseId 

		IF EXISTS (
			SELECT 1 FROM Op_Forecast a 
			JOIN Op_Out_ConfigToCompanyDetail b ON b.ConfigToCompID = a.ForecastID
			JOIN OP_In_Consign c ON c.ConsignID = b.ConsignID
			JOIN @stationTable d ON c.StartStationID = d.StationID
			JOIN FN_WarehousePositionFeeBillDetails e ON a.LineCode = e.LineCode AND e.BillId = @id
			WHERE b.IfDel = 0 AND b.BillType = 0 AND a.StartTime >= @yestoday AND a.StartTime < @today
		)
		BEGIN
			--更新子表数据			
			DECLARE @detailsId int, 
					@detailsLineID varchar(100), 
					@detailsLineCityName varchar(100), 
					@detailsWarehouseStationID varchar(100), 
					@detailsStartStationID varchar(100), 
					@detailsEndStationID varchar(100)

			DECLARE cur_details CURSOR FOR			
			SELECT a.Id, a.LineID, a.LineCityName, b.WarehouseStationID, c.StartStationID, c.EndStationID
			FROM FN_WarehousePositionFeeBillDetails a 
			JOIN FN_WarehousePositionFeeBill b ON a.BillId = b.Id 
			JOIN Bas_Line c on a.lineid = c.LineID
			WHERE B.IfDel = 0 AND c.ifDel = 0 AND BillId = @id

			OPEN cur_details
			FETCH NEXT FROM cur_details INTO @detailsId, @detailsLineID, @detailsLineCityName, @detailsWarehouseStationID, @detailsStartStationID, @detailsEndStationID
			WHILE @@FETCH_STATUS = 0
			BEGIN
				SELECT @TotalSettlementWeight = ISNULL(SUM(TotalJSWeight),0), @TotalVolume = ISNULL(SUM(TotalBulk),0), @TotalActualWeight = ISNULL(SUM(TotalWeight),0),
					@TotalBillNum = ISNULL(SUM(TotalBillNum),0), @TotalGoodsNum = ISNULL(SUM(TotalGoodsNum),0)
				FROM Op_Forecast a 
				JOIN Op_Out_ConfigToCompanyDetail b ON b.ConfigToCompID = a.ForecastID
				JOIN OP_In_Consign c ON c.ConsignID = b.ConsignID
				JOIN @stationTable d ON c.StartStationID = d.StationID				
				JOIN Bas_Line e on a.StartStationID = e.StartStationID and a.NextStationID = e.EndStationID and a.LineCode = e.LineCode				
				WHERE b.BillType = 0 AND e.LineID = @detailsLineID AND a.StartStationID = @detailsStartStationID AND a.StartTime >= @yestoday AND a.StartTime < @today

				UPDATE FN_WarehousePositionFeeBillDetails SET TotalBillNum = @TotalBillNum, TotalGoodsNum = @TotalGoodsNum, 
					TotalActualWeight = @TotalActualWeight, TotalVolume = @TotalVolume, TotalSettlementWeight = @TotalSettlementWeight
				WHERE id = @detailsId

				FETCH NEXT FROM cur_details INTO @detailsId, @detailsLineID, @detailsLineCityName, @detailsWarehouseStationID, @detailsStartStationID, @detailsEndStationID
			END
			CLOSE cur_details
			DEALLOCATE cur_details

			--总网点货量,从明细统计总网点货量
			SELECT @TotalBillNum = SUM(ISNULL(TotalBillNum, 0)), @TotalGoodsNum = SUM(ISNULL(TotalGoodsNum, 0)), @TotalActualWeight = SUM(ISNULL(TotalActualWeight, 0)), 
				@TotalVolume = SUM(ISNULL(TotalVolume, 0)), @TotalSettlementWeight = SUM(ISNULL(TotalSettlementWeight, 0))  
			FROM FN_WarehousePositionFeeBillDetails WHERE BillId = @id

			--初始化变量
			SELECT @ExcessSettlementWeight = 0, @ExcessActualWeight = 0, @ExcessVolume = 0, @ExcessFee = 0, @TotalFee = @WarehouseFee
					
			IF @FeeType = 2 --阶梯包仓费
			BEGIN				
				SELECT @LadderWarehouseFee = ISNULL(WarehouseFee, 0) FROM Bas_WPF_Weight 
				WHERE WarehouseId = @WarehouseId AND @TotalSettlementWeight > StartWeight AND @TotalSettlementWeight <= EndWeight

				IF @WarehouseFee < @LadderWarehouseFee
				BEGIN
					SET @WarehouseFee = @LadderWarehouseFee
				END
			END
			IF @FeeType = 3 --超额加收
			BEGIN
				--判断结算重量是否大于上限, 上限大于零说明已经选择了此项
				IF @SettlementUpLimit > 0 AND @TotalSettlementWeight > @SettlementUpLimit
				BEGIN
					SET @ExcessSettlementWeight = @TotalSettlementWeight - @SettlementUpLimit

					SELECT @Rate = ISNULL(Rate, 0) FROM Bas_WPF_Excess
					WHERE WarehouseId = @WarehouseId AND ExcessType = 1 AND @ExcessActualWeight > StartValue AND @ExcessActualWeight <= EndValue

					IF @Rate > 0 
					BEGIN
						SET @ExcessSettlementFee = @ExcessSettlementWeight * @Rate
						SET @ExcessFee = IIF(@ExcessFee > @ExcessSettlementFee, @ExcessFee, @ExcessSettlementFee)
					END
				END				
				--判断体积是否大于上限
				IF @VolumeUpLimit > 0 AND @TotalVolume > @VolumeUpLimit
				BEGIN
					SET @ExcessVolume = @TotalVolume - @VolumeUpLimit

					SELECT @Rate = ISNULL(Rate, 0) FROM Bas_WPF_Excess
					WHERE WarehouseId = @WarehouseId AND ExcessType = 2 AND @ExcessActualWeight > StartValue AND @ExcessActualWeight <= EndValue

					IF @Rate > 0 
					BEGIN
						SET @ExcessVolumeFee = @ExcessVolume * @Rate
						SET @ExcessFee = IIF(@ExcessFee > @ExcessVolumeFee, @ExcessFee, @ExcessVolumeFee)
					END
				END
				--判断实际重量是否大于上限
				IF @ActualUpLimit > 0 AND @TotalActualWeight > @ActualUpLimit
				BEGIN
					SET @ExcessActualWeight = @TotalActualWeight - @ActualUpLimit

					SELECT @Rate = ISNULL(Rate, 0) FROM Bas_WPF_Excess
					WHERE WarehouseId = @WarehouseId AND ExcessType = 3 AND @ExcessActualWeight > StartValue AND @ExcessActualWeight <= EndValue

					IF @Rate > 0 
					BEGIN
						SET @ExcessActualFee = @ExcessActualWeight * @Rate
						SET @ExcessFee = IIF(@ExcessFee > @ExcessActualFee, @ExcessFee, @ExcessActualFee)
					END
				END

				SET @TotalFee = @WarehouseFee + @ExcessFee
				
			END

			--更新主表数据
			UPDATE FN_WarehousePositionFeeBill SET TotalBillNum = @TotalBillNum, TotalGoodsNum = @TotalGoodsNum,
				TotalActualWeight = @TotalActualWeight, TotalVolume = @TotalVolume, TotalSettlementWeight = @TotalSettlementWeight, WarehouseFee = @WarehouseFee,
				ExcessSettlementWeight = @ExcessSettlementWeight, ExcessActualWeight = @ExcessActualWeight, ExcessVolume = @ExcessVolume, ExcessFee = @ExcessFee, TotalFee = @TotalFee,
				UpdateTime = GETDATE()
			WHERE Id = @id	
		END

		FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
			@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName 
	END
	CLOSE cur
	DEALLOCATE cur

	COMMIT TRANSACTION t1	
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION t1	
END CATCH
GO

/*
每日凌晨01:00:00执行包仓费扣费
*/
IF OBJECT_ID('P_DeductWarehouseFeeBill', 'P') IS NOT NULL   
    DROP PROCEDURE P_DeductWarehouseFeeBill
GO 
CREATE PROCEDURE P_DeductWarehouseFeeBill
AS

DECLARE @today varchar(10) = CONVERT(varchar(10), GETDATE(), 120)
DECLARE @yestoday varchar(10) = DATEADD(d, -1, @today)
DECLARE @tomorrow varchar(10) = DATEADD(d, 1, @today)

/*测试
SET @today = '2019-9-19'
SET @yestoday = DATEADD(d, -1, @today)
--*/

DECLARE @startTime datetime, 
		@endTime datetime

DECLARE @id int,
		@WarehouseId int,							--包仓费设置ID
		@StationId nvarchar(100),					--收款单位ID
		@StationName nvarchar(100),					--收款单位
		@WarehouseStationId nvarchar(100),			--包仓网点ID
		@WarehouseStationName nvarchar(100),		--包仓网点
		@LineCode nvarchar(100),					--包仓线路Code
		@LineName nvarchar(100),					--包仓线路
		@LineCityName nvarchar(100),				--货物流向
		@FeeCycle int,								--包仓扣费周期
		@FeeType int,								--包仓类型
		@WarehouseFee decimal(18,2) = 0,			--包仓费
		@SettlementUpLimit decimal(18, 2) = 0,		--结算重量上限
		@VolumeUpLimit decimal(18, 2) = 0,			--体积上限
		@ActualUpLimit decimal(18, 2) = 0,			--实际重量上限
		@TotalFee decimal(18,2) = 0					--总费用

DECLARE @StationYE decimal(18,2) , @WarehouseStationYE decimal(18,2)

--今天计算过不再重新计算
IF EXISTS (SELECT * FROM FN_WarehousePositionFeeBillLog WHERE CreateTime >= @today AND CreateTime < @tomorrow)
BEGIN
	PRINT '已经扣过费'
	RETURN
END

BEGIN TRANSACTION t1
BEGIN TRY
	--1、按自然日：针对一条包仓数据，在包仓设置有效期内，每日凌晨1:00:00，查询前一日发站是否有包仓线路+货物流向的数据，有1条以上（含1条）数据时，从包仓网点扣包仓费，付给收款单位；无数据时，不扣款；
	SET @startTime = @yestoday
	SET @endTime = @today

	DECLARE cur CURSOR FOR 
	SELECT id, WarehouseId, WarehouseFee, StationID, StationName, FeeCycle, FeeType, SettlementWeightUpLimit, VolumeUpLimit, ActualWeightUpLimit,
		WarehouseStationID, WarehouseStationName, LineCode, LineName, LinecityName, TotalFee
	FROM FN_WarehousePositionFeeBill 
	WHERE IsAbnormal = 0 AND IsDeduct = 0 AND FeeCycle = 1 AND BillTime >= @startTime AND BillTime < @endTime AND TotalFee > 0
	OPEN cur
	FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
		@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName, @TotalFee
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--PRINT '扣款'			
		UPDATE FN_Recharge SET @WarehouseStationYE = YE, YE = YE - @TotalFee, OperTime = GETDATE() WHERE StationID = @WarehouseStationId
		UPDATE FN_Recharge SET @StationYE = YE, YE = YE + @TotalFee, OperTime = GETDATE() WHERE StationID = @StationId

		SELECT @WarehouseStationYE -= @TotalFee, @StationYE += @TotalFee

		INSERT INTO Fn_RechargeList (CurStation, CurStationID, OccurStation, OccurStationID, ConsignID, ExpenseType, ExpenseTypeID, GetMoney, PayMoney, YE, OperTime, OperMan, OperStatus, ifBack, Remark, OperStationID, OperStationName, IsPDA)
		VALUES (@StationName, @StationId, @WarehouseStationName, @WarehouseStationId, '', '包仓费', '包仓费', @TotalFee, 0, @StationYE, getdate(), '系统', 1, 0, '按日收包仓费', '000000', '总部', 0)

		INSERT INTO Fn_RechargeList (CurStation, CurStationID, OccurStation, OccurStationID, ConsignID, ExpenseType, ExpenseTypeID, GetMoney, PayMoney, YE, OperTime, OperMan, OperStatus, ifBack, Remark, OperStationID, OperStationName, IsPDA)
		VALUES (@WarehouseStationName, @WarehouseStationId, @StationName, @StationId, '', '包仓费', '包仓费', 0, @TotalFee, @WarehouseStationYE, getdate(), '系统', 1, 0, '按日付包仓费', '000000', '总部', 0)

		INSERT INTO FN_WarehousePositionFeeBillLog (BillId, FeeCycle, StationID, StationName, WarehouseStationID, WarehouseStationName, TotalFee, StationYE, WarehouseStationYE, Remark, CreateUserID, CreateUserName)
		VALUES (@id, 1, @StationId, @StationName, @WarehouseStationId, @WarehouseStationName, @TotalFee, @StationYE, @WarehouseStationYE, '按日扣费', '', '系统')

		FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
			@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName, @TotalFee
	END
	CLOSE cur
	DEALLOCATE cur

	--按自然周：针对一条包仓数据，在包仓设置有效期内，每周二凌晨1:00:00，查询上周一00:00:00到上周日23:59:59内，发站是否有包仓线路+货物流向的数据，有1条以上（含1条）数据时，从包仓网点扣包仓费，付给收款单位；无数据时，不扣款；
	IF(DATEPART(WEEKDAY, @today) = 3) --周二
	BEGIN
		SET @startTime = DATEADD(d, -8, @today)
		SET @endTime = DATEADD(d, -1, @today)

		DECLARE cur CURSOR FOR 
		SELECT id, WarehouseId, WarehouseFee, StationID, StationName, FeeCycle, FeeType, SettlementWeightUpLimit, VolumeUpLimit, ActualWeightUpLimit,
			WarehouseStationID, WarehouseStationName, LineCode, LineName, LinecityName 
		FROM FN_WarehousePositionFeeBill WHERE IsAbnormal = 0 AND IsDeduct = 0 AND FeeCycle = 2 AND BillTime >= @startTime AND BillTime < @endTime
		OPEN cur
		FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
			@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName 
		WHILE @@FETCH_STATUS = 0
		BEGIN
			--PRINT '扣款'
			UPDATE FN_Recharge SET @WarehouseStationYE = YE, YE = YE - @TotalFee, OperTime = GETDATE() WHERE StationID = @WarehouseStationId
			UPDATE FN_Recharge SET @StationYE = YE, YE = YE + @TotalFee, OperTime = GETDATE() WHERE StationID = @StationId

			SELECT @WarehouseStationYE -= @TotalFee, @StationYE += @TotalFee

			INSERT INTO Fn_RechargeList (CurStation, CurStationID, OccurStation, OccurStationID, ConsignID, ExpenseType, ExpenseTypeID, GetMoney, PayMoney, YE, OperTime, OperMan, OperStatus, ifBack, Remark, OperStationID, OperStationName, IsPDA)
			VALUES (@StationName, @StationId, @WarehouseStationName, @WarehouseStationId, '', '包仓费', '包仓费', @TotalFee, 0, @StationYE, getdate(), '系统', 1, 0, '按周收包仓费', '000000', '总部', 0)

			INSERT INTO Fn_RechargeList (CurStation, CurStationID, OccurStation, OccurStationID, ConsignID, ExpenseType, ExpenseTypeID, GetMoney, PayMoney, YE, OperTime, OperMan, OperStatus, ifBack, Remark, OperStationID, OperStationName, IsPDA)
			VALUES (@WarehouseStationName, @WarehouseStationId, @StationName, @StationId, '', '包仓费', '包仓费', 0, @TotalFee, @WarehouseStationYE, getdate(), '系统', 1, 0, '按周付包仓费', '000000', '总部', 0)

			INSERT INTO FN_WarehousePositionFeeBillLog (BillId, FeeCycle, StationID, StationName, WarehouseStationID, WarehouseStationName, TotalFee, StationYE, WarehouseStationYE, Remark, CreateUserID, CreateUserName)
			VALUES (@id, 1, @StationId, @StationName, @WarehouseStationId, @WarehouseStationName, @TotalFee, @StationYE, @WarehouseStationYE, '按周扣费', '', '系统')

			FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
				@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName 
		END
		CLOSE cur
		DEALLOCATE cur
	END

	--3、按自然月：针对一条包仓数据，在包仓设置有效期内，每月5号凌晨1:00:00，查询上月1号00:00:00到上月最后一天23:59:59内，发站是否有包仓线路+货物流向的数据，有1条以上（含1条）数据时，从包仓网点扣包仓费，付给收款单位；无数据时，不扣款；
	IF(@FeeCycle = 3 AND DATEPART(DAY, GETDATE()) = 5) --5号
	BEGIN
		SET @startTime = CONVERT(varchar(8), DATEADD(m, -1, @today), 120) + '01'
		SET @endTime = left(@today, 8) + '01'
		
		DECLARE cur CURSOR FOR 
		SELECT id, WarehouseId, WarehouseFee, StationID, StationName, FeeCycle, FeeType, SettlementWeightUpLimit, VolumeUpLimit, ActualWeightUpLimit,
			WarehouseStationID, WarehouseStationName, LineCode, LineName, LinecityName 
		FROM FN_WarehousePositionFeeBill WHERE IsAbnormal = 0 AND IsDeduct = 0 AND FeeCycle = 3 AND BillTime >= @startTime AND BillTime < @endTime 
		OPEN cur
		FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
			@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName 
		WHILE @@FETCH_STATUS = 0
		BEGIN
			--PRINT '扣款'
			UPDATE FN_Recharge SET @WarehouseStationYE = YE, YE = YE - @TotalFee, OperTime = GETDATE() WHERE StationID = @WarehouseStationId
			UPDATE FN_Recharge SET @StationYE = YE, YE = YE + @TotalFee, OperTime = GETDATE() WHERE StationID = @StationId

			SELECT @WarehouseStationYE -= @TotalFee, @StationYE += @TotalFee

			INSERT INTO Fn_RechargeList (CurStation, CurStationID, OccurStation, OccurStationID, ConsignID, ExpenseType, ExpenseTypeID, GetMoney, PayMoney, YE, OperTime, OperMan, OperStatus, ifBack, Remark, OperStationID, OperStationName, IsPDA)
			VALUES (@StationName, @StationId, @WarehouseStationName, @WarehouseStationId, '', '包仓费', '包仓费', @TotalFee, 0, @StationYE, getdate(), '系统', 1, 0, '按月收包仓费', '000000', '总部', 0)

			INSERT INTO Fn_RechargeList (CurStation, CurStationID, OccurStation, OccurStationID, ConsignID, ExpenseType, ExpenseTypeID, GetMoney, PayMoney, YE, OperTime, OperMan, OperStatus, ifBack, Remark, OperStationID, OperStationName, IsPDA)
			VALUES (@WarehouseStationName, @WarehouseStationId, @StationName, @StationId, '', '包仓费', '包仓费', 0, @TotalFee, @WarehouseStationYE, getdate(), '系统', 1, 0, '按月付包仓费', '000000', '总部', 0)

			INSERT INTO FN_WarehousePositionFeeBillLog (BillId, FeeCycle, StationID, StationName, WarehouseStationID, WarehouseStationName, TotalFee, StationYE, WarehouseStationYE, Remark, CreateUserID, CreateUserName)
			VALUES (@id, 1, @StationId, @StationName, @WarehouseStationId, @WarehouseStationName, @TotalFee, @StationYE, @WarehouseStationYE, '按月扣费', '', '系统')

			FETCH NEXT FROM cur INTO @id, @WarehouseId, @WarehouseFee, @StationId, @StationName, @FeeCycle, @FeeType, @SettlementUpLimit, @VolumeUpLimit, @ActualUpLimit, 
				@WarehouseStationID, @WarehouseStationName, @LineCode, @LineName, @LinecityName 
		END
		CLOSE cur
		DEALLOCATE cur
	END

	COMMIT TRANSACTION t1
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION t1
END CATCH

GO


USE [msdb]
GO

/****** Object:  Job [包仓费]    Script Date: 2019/9/24 10:43:55 ******/
EXEC msdb.dbo.sp_delete_job @job_id=N'3363a2b6-e86c-4824-84f5-eee6f6da9522', @delete_unused_schedule=1
GO

/****** Object:  Job [包仓费]    Script Date: 2019/9/24 10:43:55 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2019/9/24 10:43:56 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'包仓费', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'包仓费生成数据、计算、扣费', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [生成当天的包仓费数据]    Script Date: 2019/9/24 10:43:56 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'生成当天的包仓费数据', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE P_GenerateWarehouseFeeBill', 
		@database_name=N'ztwl', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [计算前一天包仓费]    Script Date: 2019/9/24 10:43:56 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'计算前一天包仓费', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE P_ComputeWarehouseFeeBill', 
		@database_name=N'ztwl', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [根据包仓费周期扣费]    Script Date: 2019/9/24 10:43:56 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'根据包仓费周期扣费', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--EXECUTE P_DeductWarehouseFeeBill', 
		@database_name=N'ztwl', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'每天一点执行', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20190910, 
		@active_end_date=99991231, 
		@active_start_time=10000, 
		@active_end_time=235959, 
		@schedule_uid=N'ae53270b-cfec-454e-a91b-ba2e239eb987'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO



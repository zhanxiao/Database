exec sp_executesql N'
Insert PDA_BankDetails(ID,BusTerminal,PayAccount,BusDateTime,BusDate,BusTime,BalanceDate,Type,BankMoney,Poundage,GetMoney,LicenseKey,BusNumber,BandCardType,OperStation,OperStationID,OperMan,OperTime,CancellationStatus,CancellationRemark,CancellationPerson,CancellationDate,Ordernumber,PayType,IsAgreement)
values(@ID,@BusTerminal,@PayAccount,@BusDateTime,@BusDate,@BusTime,@BalanceDate,@Type,@BankMoney,@Poundage,@GetMoney,@LicenseKey,@BusNumber,@BandCardType,@OperStation,@OperStationID,@OperMan,@OperTime,@CancellationStatus,@CancellationRemark,@CancellationPerson,@CancellationDate,@Ordernumber,@PayType,@IsAgreement)',
N'@ID uniqueidentifier,@BusTerminal nvarchar(8),@PayAccount nvarchar(16),@BusDateTime datetime,@BusDate nvarchar(8),@BusTime nvarchar(6),@BalanceDate datetime,@Type nvarchar(4000),@BankMoney nvarchar(6),@Poundage nvarchar(4),@GetMoney nvarchar(6),@LicenseKey nvarchar(4000),@BusNumber nvarchar(12),@BandCardType nvarchar(2),@OperStation nvarchar(2),@OperStationID nvarchar(6),@OperMan nvarchar(2),@OperTime datetime,@CancellationStatus int,@CancellationRemark nvarchar(4000),@CancellationPerson nvarchar(4000),@CancellationDate datetime,@Ordernumber nvarchar(20),@PayType int,@IsAgreement bit',
@ID='49EA9CF2-CF4F-44F2-B6B6-8268B8A3794B',@BusTerminal=N'32210782',@PayAccount=N'622155******1089',@BusDateTime='2019-09-22 18:36:30',@BusDate=N'20190922',@BusTime=N'183630',@BalanceDate='2019-09-23 00:00:00',@Type=N'',@BankMoney=N'800.00',@Poundage=N'3.20',@GetMoney=N'796.80',@LicenseKey=N'',@BusNumber=N'183630386593',@BandCardType=N'02',@OperStation=N'总部',@OperStationID=N'000000',@OperMan=N'系统',@OperTime='2019-09-24 14:13:21.867',@CancellationStatus=2,@CancellationRemark=N'',@CancellationPerson=N'',@CancellationDate='2019-09-24 14:13:21.867',@Ordernumber=N'19092218360770010204',@PayType=1,@IsAgreement=0

exec sp_executesql N'
Insert PDA_BankDetails(ID,BusTerminal,PayAccount,BusDateTime,BusDate,BusTime,BalanceDate,Type,BankMoney,Poundage,GetMoney,LicenseKey,BusNumber,BandCardType,OperStation,OperStationID,OperMan,OperTime,CancellationStatus,CancellationRemark,CancellationPerson,CancellationDate,Ordernumber,PayType,IsAgreement)
values(@ID,@BusTerminal,@PayAccount,@BusDateTime,@BusDate,@BusTime,@BalanceDate,@Type,@BankMoney,@Poundage,@GetMoney,@LicenseKey,@BusNumber,@BandCardType,@OperStation,@OperStationID,@OperMan,@OperTime,@CancellationStatus,@CancellationRemark,@CancellationPerson,@CancellationDate,@Ordernumber,@PayType,@IsAgreement)',
N'@ID uniqueidentifier,@BusTerminal nvarchar(8),@PayAccount nvarchar(16),@BusDateTime datetime,@BusDate nvarchar(8),@BusTime nvarchar(6),@BalanceDate datetime,@Type nvarchar(4000),@BankMoney nvarchar(6),@Poundage nvarchar(4),@GetMoney nvarchar(6),@LicenseKey nvarchar(4000),@BusNumber nvarchar(12),@BandCardType nvarchar(2),@OperStation nvarchar(2),@OperStationID nvarchar(6),@OperMan nvarchar(2),@OperTime datetime,@CancellationStatus int,@CancellationRemark nvarchar(4000),@CancellationPerson nvarchar(4000),@CancellationDate datetime,@Ordernumber nvarchar(20),@PayType int,@IsAgreement bit',
@ID='0AC70353-E0A5-4E9B-A6CD-D86CBFC9E3E3',@BusTerminal=N'32210187',@PayAccount=N'622235******2582',@BusDateTime='2019-09-22 11:01:28',@BusDate=N'20190922',@BusTime=N'110128',@BalanceDate='2019-09-23 00:00:00',@Type=N'',@BankMoney=N'120.00',@Poundage=N'0.50',@GetMoney=N'119.50',@LicenseKey=N'',@BusNumber=N'110128380421',@BandCardType=N'02',@OperStation=N'总部',@OperStationID=N'000000',@OperMan=N'系统',@OperTime='2019-09-24 14:13:21.853',@CancellationStatus=2,@CancellationRemark=N'',@CancellationPerson=N'',@CancellationDate='2019-09-24 14:13:21.853',@Ordernumber=N'19092211005832010012',@PayType=1,@IsAgreement=0

exec sp_executesql N'
Insert PDA_BankDetails(ID,BusTerminal,PayAccount,BusDateTime,BusDate,BusTime,BalanceDate,Type,BankMoney,Poundage,GetMoney,LicenseKey,BusNumber,BandCardType,OperStation,OperStationID,OperMan,OperTime,CancellationStatus,CancellationRemark,CancellationPerson,CancellationDate,Ordernumber,PayType,IsAgreement)
values(@ID,@BusTerminal,@PayAccount,@BusDateTime,@BusDate,@BusTime,@BalanceDate,@Type,@BankMoney,@Poundage,@GetMoney,@LicenseKey,@BusNumber,@BandCardType,@OperStation,@OperStationID,@OperMan,@OperTime,@CancellationStatus,@CancellationRemark,@CancellationPerson,@CancellationDate,@Ordernumber,@PayType,@IsAgreement)',
N'@ID uniqueidentifier,@BusTerminal nvarchar(8),@PayAccount nvarchar(16),@BusDateTime datetime,@BusDate nvarchar(8),@BusTime nvarchar(6),@BalanceDate datetime,@Type nvarchar(4000),@BankMoney nvarchar(6),@Poundage nvarchar(4),@GetMoney nvarchar(5),@LicenseKey nvarchar(4000),@BusNumber nvarchar(12),@BandCardType nvarchar(2),@OperStation nvarchar(2),@OperStationID nvarchar(6),@OperMan nvarchar(2),@OperTime datetime,@CancellationStatus int,@CancellationRemark nvarchar(4000),@CancellationPerson nvarchar(4000),@CancellationDate datetime,@Ordernumber nvarchar(20),@PayType int,@IsAgreement bit',
@ID='C52D97A5-8D84-4800-BF00-FD322F20032D',@BusTerminal=N'32210782',@PayAccount=N'622155******1089',@BusDateTime='2019-09-20 21:51:54',@BusDate=N'20190920',@BusTime=N'215154',@BalanceDate='2019-09-21 00:00:00',@Type=N'',@BankMoney=N'100.00',@Poundage=N'0.50',@GetMoney=N'99.50',@LicenseKey=N'',@BusNumber=N'215154362862',@BandCardType=N'02',@OperStation=N'总部',@OperStationID=N'000000',@OperMan=N'系统',@OperTime='2019-09-24 14:13:21.837',@CancellationStatus=2,@CancellationRemark=N'',@CancellationPerson=N'',@CancellationDate='2019-09-24 14:13:21.837',@Ordernumber=N'19092021513508019525',@PayType=1,@IsAgreement=0

exec sp_executesql N'
Insert PDA_BankDetails(ID,BusTerminal,PayAccount,BusDateTime,BusDate,BusTime,BalanceDate,Type,BankMoney,Poundage,GetMoney,LicenseKey,BusNumber,BandCardType,OperStation,OperStationID,OperMan,OperTime,CancellationStatus,CancellationRemark,CancellationPerson,CancellationDate,Ordernumber,PayType,IsAgreement)
values(@ID,@BusTerminal,@PayAccount,@BusDateTime,@BusDate,@BusTime,@BalanceDate,@Type,@BankMoney,@Poundage,@GetMoney,@LicenseKey,@BusNumber,@BandCardType,@OperStation,@OperStationID,@OperMan,@OperTime,@CancellationStatus,@CancellationRemark,@CancellationPerson,@CancellationDate,@Ordernumber,@PayType,@IsAgreement)',
N'@ID uniqueidentifier,@BusTerminal nvarchar(8),@PayAccount nvarchar(16),@BusDateTime datetime,@BusDate nvarchar(8),@BusTime nvarchar(6),@BalanceDate datetime,@Type nvarchar(4000),@BankMoney nvarchar(6),@Poundage nvarchar(4),@GetMoney nvarchar(6),@LicenseKey nvarchar(4000),@BusNumber nvarchar(12),@BandCardType nvarchar(2),@OperStation nvarchar(2),@OperStationID nvarchar(6),@OperMan nvarchar(2),@OperTime datetime,@CancellationStatus int,@CancellationRemark nvarchar(4000),@CancellationPerson nvarchar(4000),@CancellationDate datetime,@Ordernumber nvarchar(20),@PayType int,@IsAgreement bit',
@ID='4C25B179-AEA4-448C-993E-FBC186789673',@BusTerminal=N'32210782',@PayAccount=N'625965******8557',@BusDateTime='2019-09-20 21:10:16',@BusDate=N'20190920',@BusTime=N'211016',@BalanceDate='2019-09-21 00:00:00',@Type=N'',@BankMoney=N'200.00',@Poundage=N'0.80',@GetMoney=N'199.20',@LicenseKey=N'',@BusNumber=N'211016363715',@BandCardType=N'02',@OperStation=N'总部',@OperStationID=N'000000',@OperMan=N'系统',@OperTime='2019-09-24 14:13:21.797',@CancellationStatus=2,@CancellationRemark=N'',@CancellationPerson=N'',@CancellationDate='2019-09-24 14:13:21.797',@Ordernumber=N'19092021095634019503',@PayType=1,@IsAgreement=0

exec sp_executesql N'
Insert PDA_BankDetails(ID,BusTerminal,PayAccount,BusDateTime,BusDate,BusTime,BalanceDate,Type,BankMoney,Poundage,GetMoney,LicenseKey,BusNumber,BandCardType,OperStation,OperStationID,OperMan,OperTime,CancellationStatus,CancellationRemark,CancellationPerson,CancellationDate,Ordernumber,PayType,IsAgreement)
values(@ID,@BusTerminal,@PayAccount,@BusDateTime,@BusDate,@BusTime,@BalanceDate,@Type,@BankMoney,@Poundage,@GetMoney,@LicenseKey,@BusNumber,@BandCardType,@OperStation,@OperStationID,@OperMan,@OperTime,@CancellationStatus,@CancellationRemark,@CancellationPerson,@CancellationDate,@Ordernumber,@PayType,@IsAgreement)',
N'@ID uniqueidentifier,@BusTerminal nvarchar(8),@PayAccount nvarchar(19),@BusDateTime datetime,@BusDate nvarchar(8),@BusTime nvarchar(6),@BalanceDate datetime,@Type nvarchar(4000),@BankMoney nvarchar(6),@Poundage nvarchar(4),@GetMoney nvarchar(5),@LicenseKey nvarchar(4000),@BusNumber nvarchar(12),@BandCardType nvarchar(2),@OperStation nvarchar(2),@OperStationID nvarchar(6),@OperMan nvarchar(2),@OperTime datetime,@CancellationStatus int,@CancellationRemark nvarchar(4000),@CancellationPerson nvarchar(4000),@CancellationDate datetime,@Ordernumber nvarchar(20),@PayType int,@IsAgreement bit',
@ID='9CFEF886-DCF5-4E48-AF74-96D885D283C8',@BusTerminal=N'32210778',@PayAccount=N'621799*********1167',@BusDateTime='2019-09-20 18:51:56',@BusDate=N'20190920',@BusTime=N'185156',@BalanceDate='2019-09-21 00:00:00',@Type=N'',@BankMoney=N'100.00',@Poundage=N'0.50',@GetMoney=N'99.50',@LicenseKey=N'',@BusNumber=N'185156364053',@BandCardType=N'01',@OperStation=N'总部',@OperStationID=N'000000',@OperMan=N'系统',@OperTime='2019-09-24 14:13:21.740',@CancellationStatus=2,@CancellationRemark=N'',@CancellationPerson=N'',@CancellationDate='2019-09-24 14:13:21.740',@Ordernumber=N'19092018512830019444',@PayType=1,@IsAgreement=0

exec sp_executesql N'
Insert PDA_BankDetails(ID,BusTerminal,PayAccount,BusDateTime,BusDate,BusTime,BalanceDate,Type,BankMoney,Poundage,GetMoney,LicenseKey,BusNumber,BandCardType,OperStation,OperStationID,OperMan,OperTime,CancellationStatus,CancellationRemark,CancellationPerson,CancellationDate,Ordernumber,PayType,IsAgreement)
values(@ID,@BusTerminal,@PayAccount,@BusDateTime,@BusDate,@BusTime,@BalanceDate,@Type,@BankMoney,@Poundage,@GetMoney,@LicenseKey,@BusNumber,@BandCardType,@OperStation,@OperStationID,@OperMan,@OperTime,@CancellationStatus,@CancellationRemark,@CancellationPerson,@CancellationDate,@Ordernumber,@PayType,@IsAgreement)',
N'@ID uniqueidentifier,@BusTerminal nvarchar(8),@PayAccount nvarchar(16),@BusDateTime datetime,@BusDate nvarchar(8),@BusTime nvarchar(6),@BalanceDate datetime,@Type nvarchar(4000),@BankMoney nvarchar(6),@Poundage nvarchar(4),@GetMoney nvarchar(5),@LicenseKey nvarchar(4000),@BusNumber nvarchar(12),@BandCardType nvarchar(2),@OperStation nvarchar(2),@OperStationID nvarchar(6),@OperMan nvarchar(2),@OperTime datetime,@CancellationStatus int,@CancellationRemark nvarchar(4000),@CancellationPerson nvarchar(4000),@CancellationDate datetime,@Ordernumber nvarchar(20),@PayType int,@IsAgreement bit',
@ID='8AC92364-155C-4494-8FF8-9F7D8A0B9028',@BusTerminal=N'32210782',@PayAccount=N'622155******1089',@BusDateTime='2019-09-19 00:32:57',@BusDate=N'20190919',@BusTime=N'003257',@BalanceDate='2019-09-20 00:00:00',@Type=N'',@BankMoney=N'100.00',@Poundage=N'0.50',@GetMoney=N'99.50',@LicenseKey=N'',@BusNumber=N'003257336007',@BandCardType=N'02',@OperStation=N'总部',@OperStationID=N'000000',@OperMan=N'系统',@OperTime='2019-09-24 14:13:21.713',@CancellationStatus=2,@CancellationRemark=N'',@CancellationPerson=N'',@CancellationDate='2019-09-24 14:13:21.713',@Ordernumber=N'19091900323023018688',@PayType=1,@IsAgreement=0
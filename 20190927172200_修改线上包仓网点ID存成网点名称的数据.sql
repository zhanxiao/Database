UPDATE [Bas_WPF_Station] SET [StationID] = a.StationID
FROM Bas_StationInformation a 
WHERE [Bas_WPF_Station].[StationID] = A.[StationName] AND [WarehouseId] = 2
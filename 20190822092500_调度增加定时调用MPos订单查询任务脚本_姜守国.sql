/*
增加一个非队列任务 
定时调用MPos订单查询
*/
ALTER TABLE TaskCycle ADD OperTime datetime, Remark nvarchar(500)
GO

INSERT INTO TaskCycle (CycleTime, DeathTime, LastTime, TaskName, Type, ThreadCount, Remark) VALUES (3600000, 1000, NULL, 'TimedMPosOrderQuery', 'NQ', 1, '定时调用MPos订单查询')
GO


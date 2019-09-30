/*
增加一个非队列任务 
自动提现调度任务
*/
INSERT INTO TaskCycle (CycleTime, DeathTime, LastTime, TaskName, Type, ThreadCount) VALUES (86400000, 1000, NULL, 'TimedCashWithdrawal', 'NQ', 1)
GO

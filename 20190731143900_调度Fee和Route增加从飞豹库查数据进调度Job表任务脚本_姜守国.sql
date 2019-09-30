/*
增加队列任务 
CreatFeeComputeTask
CreatRouteDecomposeTask
数据从ztwl库查询并插入到dawn的JobDetails表任务
*/
INSERT INTO TaskCycle (CycleTime, DeathTime, LastTime, TaskName, Type, ThreadCount) VALUES 
(1000, 1000, NULL, 'CreatFeeComputeTask', 'Listen', 1),
(1000, 1000, NULL, 'CreatRouteDecomposeTask', 'Listen', 1)
GO

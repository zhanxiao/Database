/*
����һ���Ƕ������� 
��ʱ����MPos������ѯ
*/
ALTER TABLE TaskCycle ADD OperTime datetime, Remark nvarchar(500)
GO

INSERT INTO TaskCycle (CycleTime, DeathTime, LastTime, TaskName, Type, ThreadCount, Remark) VALUES (3600000, 1000, NULL, 'TimedMPosOrderQuery', 'NQ', 1, '��ʱ����MPos������ѯ')
GO


--项目物流本部 22451

/*
DROP TABLE #temp
DROP TABLE #tempEmployeeCode
*/
--SELECT * FROM #temp
SELECT ID,FatherID,Type,RelationID INTO #temp FROM PUB_FrameworkRelation WHERE ID = 22451 --项目物流本部
SET IDENTITY_INSERT #temp ON

--10层部门关系插入临时表
DECLARE @i int = 0
WHILE @i < 10
BEGIN
	INSERT INTO #temp (ID,FatherID,Type,RelationID)
	SELECT ID,FatherID,Type,RelationID FROM PUB_FrameworkRelation a 
	WHERE FatherID IN (SELECT ID FROM #temp) AND a.CancelState = 0 AND a.Type = 2 AND ID NOT IN (SELECT ID FROM #temp)

	SET @i = @i + 1
END
--SELECT * FROM #temp

SELECT DISTINCT a.RelationID,0 AS Type INTO #tempEmployeeCode 
FROM PUB_FrameworkRelation a 
JOIN #temp b ON a.FatherID = b.ID 
WHERE a.CancelState = 0 AND a.Type IN (4)

--已经存在于职员权限表的员工编号加标记
UPDATE #tempEmployeeCode SET Type = 1 WHERE RelationID IN (SELECT EmployeeCode FROM Mob_Jurisdiction)

--不存在的直接插入
INSERT INTO Mob_Jurisdiction (EmployeeCode, PopedomString, PopedomName, CancelState)
SELECT RelationID, '107', '出行登记', 0 FROM #tempEmployeeCode WHERE Type = 0

--存在的更新
UPDATE Mob_Jurisdiction SET PopedomString = PopedomString + ',107', PopedomName = PopedomName + ',出行登记' 
WHERE EmployeeCode IN (SELECT RelationID FROM #tempEmployeeCode) AND CancelState = 0


/*
初始化员工App权限
将指定的员工增加出行登录App权限
*/
--DROP TABLE #tempEmployeeCode
CREATE TABLE #tempEmployeeCode (RelationID char(6), Type int)
INSERT INTO #tempEmployeeCode VALUES 
('109563', 0),('100152', 0),('102162', 0),('102159', 0),('102783', 0),('109609', 0),('102163', 0),('106117', 0),('100148', 0),('102171', 0),('106715', 0),('102219', 0),('102156', 0),('102201', 0),('102245', 0),('102155', 0),('102218', 0),('108439', 0),('106563', 0),('103832', 0),('107024', 0),('108561', 0),('106158', 0),('109176', 0),('110260', 0),('110192', 0),('102246', 0),('103505', 0),('103857', 0),('105476', 0),('100241', 0),('103862', 0),('104817', 0),('107459', 0),('107333', 0),('109795', 0),('110024', 0),('110190', 0),('103852', 0),('108574', 0),('102248', 0),('103840', 0),('102250', 0),('105405', 0),('103868', 0),('102687', 0),('106416', 0),('109080', 0),('109082', 0),('107989', 0),('109793', 0),('108016', 0),('110266', 0),('107988', 0),('107987', 0),('103988', 0),('106369', 0),('106582', 0),('102751', 0),('103866', 0),('106910', 0),('102251', 0),('102207', 0),('107791', 0),('102252', 0),('106737', 0),('106565', 0),('106546', 0),('108575', 0),('107929', 0),('106625', 0),('106547', 0),('108336', 0),('102686', 0),('107326', 0),('108956', 0),('108909', 0),('103806', 0),('103869', 0),('103870', 0),('102205', 0),('100246', 0),('109380', 0),('105258', 0),('103808', 0),('106862', 0),('103983', 0),('110372', 0),('109183', 0),('102752', 0),('107963', 0),('107692', 0),('108441', 0),('106843', 0),('110342', 0),('103819', 0),('107707', 0),('106083', 0),('104824', 0),('108955', 0),('100231', 0),('102202', 0),('102689', 0),('102688', 0),('107023', 0),('108915', 0),('110370', 0),('109079', 0),('108822', 0),('107935', 0),('107932', 0),('107937', 0),('107073', 0),('107885', 0),('109249', 0),('107934', 0),('107942', 0),('105746', 0),('105929', 0),('107943', 0),('109376', 0),('103812', 0),('105936', 0),('107940', 0),('105474', 0),('102195', 0),('104225', 0),('103814', 0),('105948', 0),('109511', 0),('109734', 0),('110019', 0),('110244', 0),('106316', 0),('102221', 0),('106540', 0),('107928', 0),('102697', 0),('105460', 0),('106364', 0),('109951', 0),('109792', 0),('108682', 0),('103820', 0),('100731', 0),('100727', 0),('108170', 0),('108963', 0),('108182', 0),('103798', 0),('102196', 0),('102200', 0),('102744', 0),('107499', 0),('108748', 0),('102209', 0),('102702', 0),('102703', 0),('102211', 0),('103821', 0),('109857', 0),('108917', 0),('979309', 0),('985197', 0),('985194', 0),('107679', 0),('979304', 0),('985456', 0),('985004', 0),('102212', 0),('102214', 0),('102253', 0),('109491', 0),('109925', 0),('102760', 0),('109369', 0),('107985', 0),('107959', 0),('105953', 0),('108175', 0),('109886', 0),('109873', 0),('102222', 0),('108692', 0),('107801', 0),('107790', 0),('107793', 0),('108013', 0),('109383', 0),('109689', 0),('109794', 0),('102242', 0),('102239', 0),('102711', 0),('102220', 0),('102712', 0),('107843', 0),('108576', 0),('107013', 0),('108342', 0),('102224', 0),('109379', 0),('109062', 0),('102717', 0),('102719', 0),('102720', 0),('109375', 0),('103839', 0),('104627', 0),('109502', 0),('110270', 0),('110271', 0),('110269', 0),('110371', 0),('103843', 0),('105403', 0),('110127', 0),('109180', 0),('106009', 0),('102724', 0),('107068', 0),('108948', 0),('104523', 0),('110126', 0),('108965', 0),('107797', 0),('108966', 0),('109508', 0),('110128', 0),('109233', 0),('109078', 0),('110160', 0),('109791', 0),('102199', 0),('102241', 0),('106153', 0),('105703', 0),('107016', 0),('103854', 0),('105899', 0),('102741', 0),('108172', 0),('108443', 0),('106260', 0),('108959', 0),('108962', 0),('108433', 0),('106514', 0),('110002', 0),('105262', 0),('109248', 0),('109247', 0),('102231', 0),('107448', 0),('107986', 0)

--已经存在于职员权限表的员工编号加标记
UPDATE #tempEmployeeCode SET Type = 1 WHERE RelationID IN (SELECT EmployeeCode FROM Mob_Jurisdiction)

--SELECT * FROM #tempEmployeeCode

--不存在的直接插入
INSERT INTO Mob_Jurisdiction (EmployeeCode, PopedomString, PopedomName, CancelState)
SELECT RelationID, '107', '出行登记', 0 FROM #tempEmployeeCode WHERE Type = 0

--存在的更新
UPDATE Mob_Jurisdiction SET PopedomString = PopedomString + ',107', PopedomName = PopedomName + ',出行登记' 
WHERE EmployeeCode IN (SELECT RelationID FROM #tempEmployeeCode) AND CancelState = 0

GO
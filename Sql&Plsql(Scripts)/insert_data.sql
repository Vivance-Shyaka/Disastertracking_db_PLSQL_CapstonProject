-- 5 Sample data insert for each table
--Insert in DISASTER
INSERT INTO Disaster VALUES (1, 'Flood', 'Kigali', 'High', SYSDATE, 'Ongoing');
INSERT INTO Disaster VALUES (2, 'Earthquake', 'Musanze', 'Critical', SYSDATE - 2, 'Contained');
INSERT INTO Disaster VALUES (3, 'Landslide', 'Rubavu', 'Moderate', SYSDATE - 4, 'Recovering');
INSERT INTO Disaster VALUES (4, 'Drought', 'Eastern Province', 'Low', SYSDATE - 10, 'Monitoring');
INSERT INTO Disaster VALUES (5, 'Fire', 'Nyagatare', 'High', SYSDATE - 1, 'Ongoing');
INSERT INTO Disaster VALUES (6, 'Storm', 'Huye', 'Moderate', SYSDATE - 5, 'Resolved');
---Insert in Response_Team
INSERT INTO Response_Team VALUES (101, 'Kigali Fire Unit', 'Fire', 'Available');
INSERT INTO Response_Team VALUES (102, 'Medical Team A', 'Medical', 'Deployed');
INSERT INTO Response_Team VALUES (103, 'Search & Rescue South', 'Rescue', 'Available');
INSERT INTO Response_Team VALUES (104, 'North Evac Squad', 'Evacuation', 'Standby');
INSERT INTO Response_Team VALUES (105, 'Flood Response Unit', 'Water Rescue', 'Deployed');
INSERT INTO Response_Team VALUES (106, 'Rapid Medical East', 'Medical', 'Available');
---Insert in Resources
INSERT INTO Resources VALUES (201, 'Emergency Kit', 'Medical', 100, 1);
INSERT INTO Resources VALUES (202, 'Water Bottles', 'Food', 500, 1);
INSERT INTO Resources VALUES (203, 'Blankets', 'Shelter', 200, 2);
INSERT INTO Resources VALUES (204, 'Tents', 'Shelter', 50, 2);
INSERT INTO Resources VALUES (205, 'Medical Supplies', 'Medical', 300, 3);
INSERT INTO Resources VALUES (206, 'Power Generators', 'Utility', 10, 3);
---Insert in Affected_Individual
INSERT INTO Affected_Individual VALUES (301, 'John Doe', 34, 'Male', 'Nyamirambo', 'Medical Aid', 'Injured', 1);
INSERT INTO Affected_Individual VALUES (302, 'Jane Uwase', 28, 'Female', 'Musanze Center', 'Evacuation', 'Displaced', 2);
INSERT INTO Affected_Individual VALUES (303, 'Eric Nshimiyimana', 45, 'Male', 'Rubavu Town', 'Food & Water', 'Stable', 3);
INSERT INTO Affected_Individual VALUES (304, 'Alice Ingabire', 65, 'Female', 'Nyagatare District', 'Medical Aid', 'Injured', 5);
INSERT INTO Affected_Individual VALUES (305, 'Samuel Habimana', 50, 'Male', 'Huye Sector', 'Shelter', 'Safe', 6);
INSERT INTO Affected_Individual VALUES (306, 'Diane Mukamana', 23, 'Female', 'Eastern Zone A', 'Water Supply', 'Affected', 4);
---Insert in Team_Assignment
INSERT INTO Team_Assignment VALUES (401, 101, 1, SYSDATE, 'Assigned');
INSERT INTO Team_Assignment VALUES (402, 102, 2, SYSDATE - 2, 'Completed');
INSERT INTO Team_Assignment VALUES (403, 103, 3, SYSDATE - 4, 'Active');
INSERT INTO Team_Assignment VALUES (404, 104, 4, SYSDATE - 5, 'Monitoring');
INSERT INTO Team_Assignment VALUES (405, 105, 5, SYSDATE - 1, 'Deployed');
INSERT INTO Team_Assignment VALUES (406, 106, 6, SYSDATE - 3, 'Assigned');
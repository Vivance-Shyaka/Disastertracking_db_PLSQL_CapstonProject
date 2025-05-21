-- SQL scripts to create tables of Disaster Tracking System
-- Disaster Table
CREATE TABLE Disaster (
    Disaster_ID        NUMBER PRIMARY KEY,
    Type               VARCHAR2(50) NOT NULL,
    Location           VARCHAR2(100),
    Severity           VARCHAR2(20) CHECK (Severity IN ('Low', 'Moderate', 'High', 'Critical')),
    Date_Reported      DATE DEFAULT SYSDATE,
    Status             VARCHAR2(20)
);

-- Response Team Table
CREATE TABLE Response_Team (
    Team_ID            NUMBER PRIMARY KEY,
    Team_Name          VARCHAR2(100),
    Specialization     VARCHAR2(50),
    Availability_Status VARCHAR2(20)
);

-- Resource Table
CREATE TABLE Resources (
    Resource_ID        NUMBER PRIMARY KEY,
    Resource_Name      VARCHAR2(100),
    Type               VARCHAR2(50),
    Quantity           NUMBER,
    Location_ID        NUMBER
);

-- Affected Individual Table
CREATE TABLE Affected_Individual (
    Individual_ID      NUMBER PRIMARY KEY,
    Full_Name          VARCHAR2(100),
    Age                NUMBER,
    Gender             VARCHAR2(10),
    Location           VARCHAR2(100),
    Needs              VARCHAR2(200),
    Status             VARCHAR2(50),
    Disaster_ID        NUMBER REFERENCES Disaster(Disaster_ID)
);


-- Team Assignment Table
CREATE TABLE Team_Assignment (
    Assignment_ID      NUMBER PRIMARY KEY,
    Team_ID            NUMBER REFERENCES Response_Team(Team_ID),
    Disaster_ID        NUMBER REFERENCES Disaster(Disaster_ID),
    Date_Assigned      DATE,
    Assignment_Status  VARCHAR2(50)
);

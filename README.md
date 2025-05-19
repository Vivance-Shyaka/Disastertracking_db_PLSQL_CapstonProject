# 🌪️ Disaster Tracking System
### AUCA 2025 PL/SQL Capstone Project – Oracle Database Design and Implementation

---

## 👤 Student Profile
- **Name**: Shyaka Vivance  
- **Student ID**: 27237  
- **Group**: A (Monday)  
- **Database Name**: `MON_27237_VIVANCE_DISASTERTS_DB`  
- **Course**: INSY 8311 – Database Development with PL/SQL  
- **Lecturer**: Mr. Eric Maniraguha (eric.maniraguha@auca.ac.rw)

---

## 🧠 Project Overview

The ***Disaster Tracking System (DTS)***  aims to address the challenges of managing and responding to natural disasters, such as floods, earthquakes, and hurricanes. During such events, timely information is crucial for effective response and recovery. The current systems often lack real-time data, leading to delays in rescue operations, inefficient resource allocation, and increased risks to human life and property.

The **Disaster Tracking System (DTS)** is a centralized, PL/SQL-based solution that empowers emergency agencies with **real-time visibility**, **automated coordination**, and **auditable workflows** to enhance disaster response operations.

---
## 🛍️ Target Users
- Emergency Responders
- Government Officials
- NGO Workers
- Community Members

## 🎯 Objectives

- ✅ Centralize disaster-related data from multiple agencies  
- ✅ Improve decision-making using stored procedures and analytics  
- ✅ Restrict data manipulation on critical dates (weekdays & public holidays)  
- ✅ Ensure secure operations through auditing and access control  
- ✅ Ensure that sensitive information is protected and accessible only to authorized users.
  

---

## 🗂️ Repository Structure

```
📁 DisasterTrackingSystem
├── README.md
├── /sql
│   ├── create_tables.sql
│   ├── insert_data.sql
│   ├── procedures_functions.sql
│   ├── triggers_auditing.sql
├── /diagrams
│   ├── erd_disaster_system.png
│   ├── bpmn_disaster_response.png
├── /screenshots
│   ├── session_container_check.png            ← Include in Section: Setup & Configuration
│   ├── user_creation_vivance.png              ← Include in Section: User Management
│   ├── trigger_block_weekday.png              ← Include in Section: Trigger Restriction Test
│   ├── audit_log_output.png                   ← Include in Section: Auditing Output
│   ├── oem_monitoring_view.png                ← Include in Section: Monitoring Environment
```

---

## 🛠️ Tech Stack

- Oracle 12c+ (Pluggable Database)
- Database Modeler
- Oracle SQL Developer
- Oracle Enterprise Manager Express (OEM)
- draw.io / Lucidchart for BPMN & ERD modeling

---

## 🧩 Key Features

| Feature                     | Description                                                                 |
|-----------------------------|-----------------------------------------------------------------------------|
| 📦 Modular Database Design  | Tables for disasters, teams, resources, individuals, and assignments        |
| 🔄 Reusable PL/SQL Logic    | Procedures and functions for fetching, transforming, and counting data      |
| 🕵️ Auditing Mechanism       | Tracks user actions (who, what, when, status) for accountability            |
| 🔒 DML Restrictions         | Triggers block insert/update/delete on weekdays and public holidays         |
| 📊 MIS Integration          | Enables analysis, traceability, and coordination across all stakeholders    |

---

## 💻 Setup & Configuration

**1. Create and connect to your pluggable database**
```sql
ALTER SESSION SET CONTAINER = MON_27237_VIVANCE_DISASTERTS_DB;
```

**2. Create your project user**
```sql
CREATE USER vivance IDENTIFIED BY vivance;
GRANT CONNECT, RESOURCE, DBA TO vivance;
ALTER USER vivance QUOTA UNLIMITED ON USERS;
```

**3. Verify session container**
```sql
SELECT SYS_CONTEXT('USERENV', 'CON_NAME') FROM DUAL;
```
📸 *Screenshot: session_container_check.png*
![user creation and set container](https://github.com/user-attachments/assets/205783a1-093f-4da4-8ce0-3e0943cb0f5f)

---

## 📋 Database Implementation

### ER Diagram & Normalized Structure
- ERD includes `Disaster`, `Response_Team`, `Resource`, `Affected_Individual`, `Team_Assignment`, and relationships.
📸 *Screenshot: erd_disaster_system.png*
![disaster_management_ERdiagram](https://github.com/user-attachments/assets/6b95ed7e-7eb6-49c5-bf3f-0b8f09038f2b)

### Table Creation Example
```sql
CREATE TABLE Disaster (
    Disaster_ID        NUMBER PRIMARY KEY,
    Type               VARCHAR2(50),
    Location           VARCHAR2(100),
    Severity           VARCHAR2(20),
    Date_Reported      DATE DEFAULT SYSDATE,
    Status             VARCHAR2(20)
);
```

---

## 📥 Data Insertion Samples

```sql
INSERT INTO Disaster VALUES (1, 'Flood', 'Kigali', 'High', SYSDATE, 'Ongoing');
INSERT INTO Response_Team VALUES (101, 'Kigali Fire Unit', 'Fire', 'Available');
INSERT INTO Affected_Individual VALUES (301, 'John Doe', 34, 'Male', 'Nyamirambo', 'Medical Aid', 'Injured', 1);
```
📸 *Screenshot: user_creation_vivance.png*
![enter as user](https://github.com/user-attachments/assets/bce6addf-f3f4-4496-93e4-56deeb6c7d65)

---

## 🔄 Procedures, Functions & Cursors

### Procedure: Get Teams by Disaster
```sql
CREATE OR REPLACE PROCEDURE Get_Teams_By_Disaster (p_disaster_id IN NUMBER) IS
BEGIN
    FOR rec IN (
        SELECT rt.Team_Name, ta.Assignment_Status
        FROM Team_Assignment ta
        JOIN Response_Team rt ON ta.Team_ID = rt.Team_ID
        WHERE ta.Disaster_ID = p_disaster_id
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Team: ' || rec.Team_Name || ' | Status: ' || rec.Assignment_Status);
    END LOOP;
END;
```
📸 *Screenshot: procedure output*
![test procedure](https://github.com/user-attachments/assets/a93886c1-f7ca-4ab9-a620-61d20b6fc231)

### Function: Count Affected Individuals
```sql
CREATE OR REPLACE FUNCTION Count_Affected_Individuals (p_disaster_id IN NUMBER) RETURN NUMBER IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM Affected_Individual WHERE Disaster_ID = p_disaster_id;
    RETURN v_count;
END;
```
📸 *Screenshot: function output*
![test function](https://github.com/user-attachments/assets/83e10a8c-bcce-4c5e-bf0b-015e360a7d37)

---

## 🧾 Trigger & Auditing Logic

### Holiday Table for Restrictions
```sql
CREATE TABLE Public_Holidays (
    Holiday_Date DATE PRIMARY KEY,
    Description  VARCHAR2(100)
);
```

### DML Restriction Trigger
```sql
CREATE OR REPLACE TRIGGER restrict_dml_on_response_team
BEFORE INSERT OR UPDATE OR DELETE ON Response_Team
FOR EACH ROW
DECLARE
    v_today DATE := TRUNC(SYSDATE);
    v_day   VARCHAR2(10);
    v_holiday NUMBER;
BEGIN
    SELECT TO_CHAR(v_today, 'DY') INTO v_day FROM DUAL;
    SELECT COUNT(*) INTO v_holiday FROM Public_Holidays WHERE Holiday_Date = v_today;
    IF v_day IN ('MON', 'TUE', 'WED', 'THU', 'FRI') OR v_holiday > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'DML operations on weekdays or public holidays are blocked.');
    END IF;
END;
```
📸 *Screenshot: trigger_block_weekday.png*
![all triggers](https://github.com/user-attachments/assets/5839936c-c08b-4589-9cf0-9787f753d377)


### Audit Log Table and Trigger
```sql
CREATE TABLE Audit_Log (
    Audit_ID        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Username        VARCHAR2(50),
    Action          VARCHAR2(20),
    Table_Affected  VARCHAR2(50),
    Action_Date     DATE,
    Status          VARCHAR2(20)
);

CREATE OR REPLACE TRIGGER audit_response_team_changes
AFTER INSERT OR UPDATE OR DELETE ON Response_Team
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Log (Username, Action, Table_Affected, Action_Date, Status)
    VALUES (USER, ORA_SYSEVENT, 'Response_Team', SYSDATE, 'ALLOWED');
END;
```
📸 *Screenshot: audit_log_output.png*
![checking audit log](https://github.com/user-attachments/assets/4f004b8b-026b-498f-aa8a-41042a9a8c6e)

---

## 📊 Monitoring with OEM Express
- View session activity, user login attempts, and tablespace usage
📸 *Screenshot: oem_monitoring_view.png*
![image (1)](https://github.com/user-attachments/assets/c49124b8-ebb7-41d2-8844-79243ca960ef)


---

## 🧠 Lessons Learned

- Design and normalization for real-time operations
- Dynamic interaction through PL/SQL logic
- Real-world application of triggers and auditing
- Integration of security and MIS decision support

---
# 📅 Project Timeline – Disaster Tracking System

### ✅ Phase I: Problem Definition
The system addresses a critical gap in disaster management—lack of real-time coordination during natural disasters such as floods, earthquakes, and landslides. It establishes clear objectives to design a secure, PL/SQL-based information system for automating disaster reporting, team deployment, and resource tracking.

### ✅ Phase II: Business Process Modeling
A comprehensive BPMN swimlane diagram was designed to represent the end-to-end flow:
- Community members report disasters
- The system validates and logs events
- Admins confirm severity and location
- Response teams are alerted and dispatched
- NGO staff coordinate aid delivery
Each actor’s responsibilities are visualized with decision points and data flow paths.

🖼️ (Diagram: See diagrams/BPMN.png)

### ✅ Phase III: Logical Design (ERD + Normalization)
An Entity-Relationship Diagram (ERD) defines all core entities:
- Disaster
- AffectedIndividual
- ResponseTeam
- TeamAssignment
- Resources 

Normalization up to 3NF was applied to reduce redundancy. Primary keys, foreign keys, and constraints were mapped based on business rules.

🖼️ (Diagram: See diagrams/ERD.png)
![ERDiagram](https://github.com/user-attachments/assets/cbc1446e-1ed7-4f4b-b1e8-1d9f42954f67)


### ✅ Phase IV: Database Creation
The physical schema was implemented in Oracle using SQL DDL. Sequences were used for ID generation where needed. All integrity constraints (PKs, FKs, NOT NULL) were enforced.

📂 See: /ddl/create_tables.sql

### ✅ Phase V: Data Insertion & Validation
Sample datasets were inserted:
- 5 records per table (disasters, people, teams, NGOs, etc.)
- Tested insertions for referential integrity
- Validated through SELECT queries and joins

📂 See: /dml/insert_sample_data.sql

### ✅ Phase VI: PL/SQL – Procedures, Functions, and Triggers
Custom PL/SQL components include:
- assignTeamToDisaster procedure
- distributeResources procedure
- A trigger to restrict DML on Resource table during weekdays or holidays

📂 See: /plsql/*.sql

### ✅ Phase VII: Auditing & Security Logic
Security logic was implemented via:
- A Holiday table for policy enforcement
- An Audit_Log table to track all attempts on sensitive tables
- A DML-restricting trigger on Resource that enforces operational hours

📂 See: /plsql/trg_restrict_resource_dml.sql

## 💬 Acknowledgment

Special thanks to **Mr. Eric Maniraguha** and AUCA’s IT faculty for continuous support, mentorship, and technical guidance throughout the development of this system.

---
## 📄 License

This project is submitted as part of the Capstone Project for Database Development with PL/SQL, Academic Year 2024-2025, Adventist University of Central Africa (AUCA).

> *"We cannot stop disasters, but we can prepare with knowledge."*  
> — *Thank you*

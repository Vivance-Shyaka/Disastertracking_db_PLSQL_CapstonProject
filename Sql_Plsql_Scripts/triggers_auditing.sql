-- PLSQL Queries for Triggers and auditing
--i firstly created a holiday table for reference

----Create: Holiday Reference Table
CREATE TABLE Public_Holidays (
    Holiday_Date DATE PRIMARY KEY,
    Description  VARCHAR2(100)
);
-- Sample holidays for upcoming month
INSERT INTO Public_Holidays VALUES (TO_DATE('2025-06-01', 'YYYY-MM-DD'), 'National Unity Day');
INSERT INTO Public_Holidays VALUES (TO_DATE('2025-06-10', 'YYYY-MM-DD'), 'Heroes Day');
INSERT INTO Public_Holidays VALUES (TO_DATE('2025-06-20', 'YYYY-MM-DD'), 'Independence Day');

---Trigger Implementation
---Trigger(1): Restrict INSERT/UPDATE/DELETE on Weekdays & Holidays
CREATE OR REPLACE TRIGGER restrict_dml_on_disaster
BEFORE INSERT OR UPDATE OR DELETE ON Disaster
FOR EACH ROW
DECLARE
    v_today DATE := TRUNC(SYSDATE);
    v_day   VARCHAR2(10);
    v_count NUMBER;
BEGIN
    SELECT TO_CHAR(v_today, 'DY') INTO v_day FROM DUAL;
    
    SELECT COUNT(*) INTO v_count
    FROM Public_Holidays
    WHERE Holiday_Date = v_today;

    IF v_day IN ('MON', 'TUE', 'WED', 'THU', 'FRI') OR v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Modifications not allowed on weekdays or public holidays.');
    END IF;
END;

---Restriction Trigger(2): for Affected_Individual

CREATE OR REPLACE TRIGGER restrict_dml_on_affected
BEFORE INSERT OR UPDATE OR DELETE ON Affected_Individual
FOR EACH ROW
DECLARE
    v_today DATE := TRUNC(SYSDATE);
    v_day   VARCHAR2(10);
    v_count NUMBER;
BEGIN
    SELECT TO_CHAR(v_today, 'DY') INTO v_day FROM DUAL;

    SELECT COUNT(*) INTO v_count
    FROM Public_Holidays
    WHERE Holiday_Date = v_today;

    IF v_day IN ('MON', 'TUE', 'WED', 'THU', 'FRI') OR v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Changes to affected individuals are not allowed on weekdays or public holidays.');
    END IF;
END;

---Trigger(3): Restrict DML on Response_Team
CREATE OR REPLACE TRIGGER restrict_dml_on_response_team
BEFORE INSERT OR UPDATE OR DELETE ON Response_Team
FOR EACH ROW
DECLARE
    v_today DATE := TRUNC(SYSDATE);
    v_day   VARCHAR2(10);
    v_holiday NUMBER;
BEGIN
    SELECT TO_CHAR(v_today, 'DY') INTO v_day FROM DUAL;

    SELECT COUNT(*) INTO v_holiday
    FROM Public_Holidays
    WHERE Holiday_Date = v_today;

    IF v_day IN ('MON', 'TUE', 'WED', 'THU', 'FRI') OR v_holiday > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'DML operations on Response_Team are blocked on weekdays or public holidays.');
    END IF;
END;

---Auditing Implementation
----i firstly created Auditing log table
---Auditing with Restrictions and Tracking
CREATE TABLE Audit_Log (
    Audit_ID      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Username      VARCHAR2(50),
    Action        VARCHAR2(20),
    Table_Affected VARCHAR2(50),
    Action_Date   DATE,
    Status        VARCHAR2(20)
);
----I implemented triggers for audit log

---Trigger for Logging Actions
CREATE OR REPLACE TRIGGER audit_disaster_actions
AFTER INSERT OR DELETE OR UPDATE ON Disaster
FOR EACH ROW
DECLARE
    v_user VARCHAR2(50) := USER;
    v_status VARCHAR2(20) := 'ALLOWED';
BEGIN
    INSERT INTO Audit_Log (Username, Action, Table_Affected, Action_Date, Status)
    VALUES (v_user, ORA_SYSEVENT, 'Disaster', SYSDATE, v_status);
END;
---Audit Trigger for Affected_Individual
CREATE OR REPLACE TRIGGER audit_affected_individuals
AFTER INSERT OR DELETE OR UPDATE ON Affected_Individual
FOR EACH ROW
DECLARE
    v_user   VARCHAR2(50) := USER;
    v_status VARCHAR2(20) := 'ALLOWED';
BEGIN
    INSERT INTO Audit_Log (Username, Action, Table_Affected, Action_Date, Status)
    VALUES (v_user, ORA_SYSEVENT, 'Affected_Individual', SYSDATE, v_status);
END;
---Trigger: Audit Changes to Response_Team
CREATE OR REPLACE TRIGGER audit_response_team_changes
AFTER INSERT OR UPDATE OR DELETE ON Response_Team
FOR EACH ROW
DECLARE
    v_user   VARCHAR2(50) := USER;
    v_status VARCHAR2(20) := 'ALLOWED';
BEGIN
    INSERT INTO Audit_Log (Username, Action, Table_Affected, Action_Date, Status)
    VALUES (v_user, ORA_SYSEVENT, 'Response_Team', SYSDATE, v_status);
END;

------Example For Testing
-- Attempt to insert on a weekday (should fail with restriction if today is M-F or a listed holiday)
INSERT INTO Response_Team VALUES (107, 'West Rapid Rescue', 'Rescue', 'Available');

-- Check audit log
SELECT * FROM Audit_Log WHERE Table_Affected = 'Response_Team';




--PLSQL script of  Cursors and Packages
---Cursors : Show All Disasters With Affected Count
DECLARE
    CURSOR cur_disasters IS
        SELECT Disaster_ID, Type, Location FROM Disaster;

    v_count NUMBER;
BEGIN
    FOR rec IN cur_disasters LOOP
        v_count := Count_Affected_Individuals(rec.Disaster_ID);
        DBMS_OUTPUT.PUT_LINE('Disaster: ' || rec.Type || ' at ' || rec.Location || ' has ' || v_count || ' affected individuals.');
    END LOOP;
END;

--- Package for reusable disaster tracking procedures and functions

CREATE OR REPLACE PACKAGE Disaster_Utils AS
    PROCEDURE Get_Teams_By_Disaster(p_disaster_id IN NUMBER);
    FUNCTION Count_Affected_Individuals(p_disaster_id IN NUMBER) RETURN NUMBER;
END Disaster_Utils;
/

CREATE OR REPLACE PACKAGE BODY Disaster_Utils AS
    PROCEDURE Get_Teams_By_Disaster(p_disaster_id IN NUMBER) IS
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

    FUNCTION Count_Affected_Individuals(p_disaster_id IN NUMBER) RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM Affected_Individual
        WHERE Disaster_ID = p_disaster_id;
        RETURN v_count;
    END;
END Disaster_Utils;

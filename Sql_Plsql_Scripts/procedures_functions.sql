-- PL/SQL script of procedures and functions including testing it
---Procedure: Get Teams Assigned to a Disaster
CREATE OR REPLACE PROCEDURE Get_Teams_By_Disaster (
    p_disaster_id IN NUMBER
) IS
BEGIN
    FOR rec IN (
        SELECT rt.Team_Name, ta.Assignment_Status
        FROM Team_Assignment ta
        JOIN Response_Team rt ON ta.Team_ID = rt.Team_ID
        WHERE ta.Disaster_ID = p_disaster_id
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Team: ' || rec.Team_Name || ' | Status: ' || rec.Assignment_Status);
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No teams assigned.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;

-- Test procedure
BEGIN
    Get_Teams_By_Disaster(3);
END;

---Function: Count Affected Individuals by Disaster
CREATE OR REPLACE FUNCTION Count_Affected_Individuals (
    p_disaster_id IN NUMBER
) RETURN NUMBER IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM Affected_Individual
    WHERE Disaster_ID = p_disaster_id;
    RETURN v_count;
EXCEPTION
    WHEN OTHERS THEN
        RETURN -1;
END;

-- Test function
SELECT Count_Affected_Individuals(1) FROM DUAL;


CREATE OR REPLACE TRIGGER biu_students_groups_limit
BEFORE INSERT OR UPDATE ON students_groups
FOR EACH ROW
DECLARE
    v_student_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_student_count
    FROM students_groups
    WHERE group_id = :NEW.group_id;

    IF v_student_count >= 20 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Can''t add more than 20 students to a single group.');
    END IF;
END;
/

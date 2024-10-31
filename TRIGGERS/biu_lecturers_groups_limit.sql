-- This trigger ensures that a lecturer cannot be assigned to more than ten groups by checking the current group count for each lecturer.
CREATE OR REPLACE TRIGGER biu_lecturers_groups_limit
BEFORE INSERT OR UPDATE ON lecturers_groups
FOR EACH ROW
DECLARE
  v_group_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_group_count
    FROM lecturers_groups
    WHERE lecturer_id = :NEW.lecturer_id;

    IF v_group_count >= 10 THEN
        RAISE_APPLICATION_ERROR(-20006, 'Can''t add more than 10 groups to one lecturer.');
    END IF;
END;
/

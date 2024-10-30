-- This trigger ensures only one grade can be added per exam by checking if a grade already exists for the given exam_id.
CREATE OR REPLACE TRIGGER biu_grade_exam_limit
BEFORE INSERT OR UPDATE ON grades
FOR EACH ROW
DECLARE
    v_exam_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_exam_count
    FROM grades
    WHERE exam_id = :NEW.exam_id;

    IF v_exam_count >= 2 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Can''t add more than 1 grade to one exam.');
    END IF;
END;
/
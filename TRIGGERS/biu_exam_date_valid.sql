CREATE OR REPLACE TRIGGER biu_exam_date_valid
BEFORE INSERT OR UPDATE ON exams
FOR EACH ROW
DECLARE
BEGIN
  IF :NEW.exam_date <= SYSDATE THEN
    RAISE_APPLICATION_ERROR(-20002, 'You can''t add exam date equal or lower over sysdate. Please try again');
  END IF;
END;
/

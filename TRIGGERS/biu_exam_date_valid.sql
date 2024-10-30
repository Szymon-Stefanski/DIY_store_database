-- Trigger to ensure exam dates are set in the future
CREATE OR REPLACE TRIGGER biu_exam_date_valid
BEFORE INSERT OR UPDATE ON exams
FOR EACH ROW
DECLARE
BEGIN
  IF :NEW.exam_date <= SYSDATE THEN
    RAISE_APPLICATION_ERROR(-20002, 'You can''t add or update an exam with 
    an exam date that is today or in the past. Please choose a future date');
  END IF;
END;
/

CREATE OR REPLACE TRIGGER biu_schedule_date_valid
BEFORE INSERT OR UPDATE ON schedules
FOR EACH ROW
DECLARE
BEGIN
  IF :NEW.start_time <= SYSDATE 
     OR :NEW.end_time <= SYSDATE 
     OR :NEW.schedule_date <= SYSDATE 
  THEN
    RAISE_APPLICATION_ERROR(-20002, 'You can''t add or update a schedule with 
    a start time, end time, or schedule date that is today or in the past. 
    Please choose a future date.');
  END IF;
END;
/

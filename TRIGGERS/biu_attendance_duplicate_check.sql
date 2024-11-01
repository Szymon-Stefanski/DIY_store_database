-- This trigger prevents duplicate attendance records for the same student and schedule.
CREATE OR REPLACE TRIGGER biu_attendance_duplicate_check
BEFORE INSERT ON attendances
FOR EACH ROW
DECLARE
    v_duplicate_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_duplicate_count
    FROM attendances
    WHERE student_id = :NEW.student_id
      AND schedule_id = :NEW.schedule_id;

    IF v_duplicate_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20008, 'Attendance record for this student and schedule already exists.');
    END IF;
END;
/

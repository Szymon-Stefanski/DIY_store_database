-- This trigger ensures that an exam cannot be assigned to room that are already booked.
CREATE OR REPLACE TRIGGER biu_exam_room_availability
BEFORE INSERT OR UPDATE ON exams
FOR EACH ROW
DECLARE
    v_conflict_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_conflict_count
    FROM exams
    WHERE room_id = :NEW.room_id
    AND exam_date = :NEW.exam_date
    AND exam_id != :NEW.exam_id;

    IF v_conflict_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20007, 'The room is already booked for another exam at this time.');
    END IF;
END;
/
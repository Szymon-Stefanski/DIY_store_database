-- PACKAGE FOR SCHEDULE MANAGEMENT OPERATIONS
CREATE OR REPLACE PACKAGE pkg_schedule_management
IS
  PROCEDURE create_schedule (
    v_start_time    schedules.start_time%TYPE,
    v_end_time      schedules.end_time%TYPE,
    v_course_id     schedules.course_id%TYPE,
    v_group_id      schedules.group_id%TYPE,
    v_room_id       schedules.room_id%TYPE,
    v_lecturer_id   schedules.lecturer_id%TYPE,
    v_schedule_date schedules.schedule_date%TYPE,
    v_duration      schedules.duration%TYPE
    );
  PROCEDURE delete_schedule (v_schedule_id schedules.schedule_id%TYPE);
  PROCEDURE update_schedule (
    v_schedule_id   schedules.schedule_id%TYPE,
    v_start_time    schedules.start_time%TYPE,
    v_end_time      schedules.end_time%TYPE,
    v_course_id     schedules.course_id%TYPE,
    v_group_id      schedules.group_id%TYPE,
    v_room_id       schedules.room_id%TYPE,
    v_lecturer_id   schedules.lecturer_id%TYPE,
    v_schedule_date schedules.schedule_date%TYPE,
    v_duration      schedules.duration%TYPE
    );
  
END pkg_schedule_management;
/

CREATE OR REPLACE PACKAGE BODY pkg_schedule_management
IS
  -- PROCEDURE TO CREATE A NEW SCHEDULE
  PROCEDURE create_schedule (
  v_start_time    schedules.start_time%TYPE,
  v_end_time      schedules.end_time%TYPE,
  v_course_id     schedules.course_id%TYPE,
  v_group_id      schedules.group_id%TYPE,
  v_room_id       schedules.room_id%TYPE,
  v_lecturer_id   schedules.lecturer_id%TYPE,
  v_schedule_date schedules.schedule_date%TYPE,
  v_duration      schedules.duration%TYPE
  )
  IS
  BEGIN
    INSERT INTO schedules
    (start_time, end_time, course_id, group_id, room_id, lecturer_id, schedule_date, duration) 
    VALUES 
    (v_start_time, v_end_time, v_course_id, v_group_id, v_room_id, v_lecturer_id, v_schedule_date, v_duration);
    
    IF SQL%ROWCOUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Schedule can''t be added, please try again');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Schedule added successfully!');
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error occurred. SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
  END create_schedule;



  -- PROCEDURE TO DELETE A SCHEDULE
  PROCEDURE delete_schedule (v_schedule_id schedules.schedule_id%TYPE)
  IS
  BEGIN
    DELETE FROM schedules WHERE schedule_id = v_schedule_id;

    IF SQL%ROWCOUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Schedule can''t be deleted, please try again');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Schedule deleted successfully!');
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error occurred. SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
  END delete_schedule;



  -- PROCEDURE TO UPDATE A SCHEDULE
  PROCEDURE update_schedule (
    v_schedule_id   schedules.schedule_id%TYPE,
    v_start_time    schedules.start_time%TYPE,
    v_end_time      schedules.end_time%TYPE,
    v_course_id     schedules.course_id%TYPE,
    v_group_id      schedules.group_id%TYPE,
    v_room_id       schedules.room_id%TYPE,
    v_lecturer_id   schedules.lecturer_id%TYPE,
    v_schedule_date schedules.schedule_date%TYPE,
    v_duration      schedules.duration%TYPE
    )
  IS
  BEGIN
    UPDATE  schedules
    SET     start_time = v_start_time,
            end_time = v_end_time,
            course_id = v_course_id,
            group_id = v_group_id,
            room_id = v_room_id,
            lecturer_id = v_lecturer_id,
            schedule_date = v_schedule_date,
            duration = v_duration
    WHERE   schedule_id = v_schedule_id;

    IF SQL%ROWCOUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Schedule can''t be updated, please try again');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Schedule updated successfully!');
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error occurred. SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
  END update_schedule;
END pkg_schedule_management;

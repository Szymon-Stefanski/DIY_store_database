-- TESTS FOR SCHEDULE MANAGEMENT OPERATIONS
CREATE OR REPLACE PACKAGE test_pkg_schedule_management
IS
  --%suite

  --%test test_create_schedule
  PROCEDURE test_create_schedule;
  
  --%test test_delete_schedule
  PROCEDURE test_delete_schedule;

  --%test test_update_schedule
  PROCEDURE test_update_schedule;

  --%test test_display_schedule
  PROCEDURE test_display_schedule;
END test_pkg_schedule_management;
/


CREATE OR REPLACE PACKAGE BODY test_pkg_schedule_management
IS
  --TEST TO CREATE A SCHEDULE
  PROCEDURE test_create_schedule
  IS
    v_schedule_count_before NUMBER;
    v_schedule_count_after NUMBER;
    v_schedule_date DATE;

  BEGIN
    SELECT COUNT(*) INTO v_schedule_count_before FROM NEO.schedules;

    NEO.pkg_schedule_management.create_schedule(
      v_start_time    => TIMESTAMP '2024-11-19 09:00:00',
      v_end_time      => TIMESTAMP '2024-11-19 13:00:00',
      v_course_id     => 1,
      v_group_id      => 1,
      v_room_id       => 1,
      v_lecturer_id   => 1,
      v_schedule_date => TO_DATE('2024-11-19','YYYY-MM-DD'),
      v_duration      => 240
    );

    SELECT COUNT(*) INTO v_schedule_count_after FROM NEO.schedules;
    ut.expect(v_schedule_count_after).to_equal(v_schedule_count_before + 1);

    SELECT schedule_date
    INTO v_schedule_date
    FROM NEO.schedules
    WHERE start_time = TIMESTAMP '2024-11-19 09:00:00' AND end_time = TIMESTAMP '2024-11-19 13:00:00';

    ut.expect(v_schedule_date).to_equal(TO_DATE('2024-11-19','YYYY-MM-DD'));

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ut.fail('Failed to find the inserted attendance record');
      WHEN OTHERS THEN
        ut.fail('Unexpected error: ' || SQLERRM);
  END test_create_schedule;


  --TEST TO DELETE A SCHEDULE
  PROCEDURE test_delete_schedule
  IS
    v_schedule_count_before NUMBER;
    v_schedule_count_after NUMBER;
    v_schedule_id NEO.schedules.schedule_id%TYPE;

  BEGIN
    SELECT COUNT(*) INTO v_schedule_count_before FROM NEO.schedules;
    
    NEO.pkg_schedule_management.create_schedule(
      v_start_time    => TIMESTAMP '2024-11-19 09:00:00',
      v_end_time      => TIMESTAMP '2024-11-19 13:00:00',
      v_course_id     => 1,
      v_group_id      => 1,
      v_room_id       => 1,
      v_lecturer_id   => 1,
      v_schedule_date => TO_DATE('2024-11-19','YYYY-MM-DD'),
      v_duration      => 240
    );
    
    SELECT schedule_id
    INTO v_schedule_id
    FROM NEO.schedules
    WHERE start_time = TIMESTAMP '2024-11-19 09:00:00' AND end_time = TIMESTAMP '2024-11-19 13:00:00';

    NEO.pkg_schedule_management.delete_schedule(v_schedule_id);

    SELECT COUNT(*) INTO v_schedule_count_after FROM NEO.schedules;
    ut.expect(v_schedule_count_after).to_equal(v_schedule_count_before);

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ut.fail('Failed to find the inserted attendance record');
      WHEN OTHERS THEN
        ut.fail('Unexpected error: ' || SQLERRM);
  END test_delete_schedule;


  --TEST TO UPDATE A SCHEDULE
  PROCEDURE test_update_schedule
  IS
    v_schedule_count_before NUMBER;
    v_schedule_count_after NUMBER;
    v_schedule_id_test NEO.schedules.schedule_id%TYPE;
    v_room_id NEO.schedules.room_id%TYPE;

  BEGIN
    SELECT COUNT(*) INTO v_schedule_count_before FROM NEO.schedules;
    
    NEO.pkg_schedule_management.create_schedule(
      v_start_time    => TIMESTAMP '2024-11-19 09:00:00',
      v_end_time      => TIMESTAMP '2024-11-19 13:00:00',
      v_course_id     => 1,
      v_group_id      => 1,
      v_room_id       => 1,
      v_lecturer_id   => 1,
      v_schedule_date => TO_DATE('2024-11-19','YYYY-MM-DD'),
      v_duration      => 240
    );

    SELECT schedule_id
    INTO v_schedule_id_test
    FROM NEO.schedules
    WHERE start_time = TIMESTAMP '2024-11-19 09:00:00' AND end_time = TIMESTAMP '2024-11-19 13:00:00';

    NEO.pkg_schedule_management.update_schedule(
      v_schedule_id   => v_schedule_id_test,
      v_start_time    => TIMESTAMP '2024-11-19 09:00:00',
      v_end_time      => TIMESTAMP '2024-11-19 13:00:00',
      v_course_id     => 1,
      v_group_id      => 1,
      v_room_id       => 2,
      v_lecturer_id   => 1,
      v_schedule_date => TO_DATE('2024-11-19','YYYY-MM-DD'),
      v_duration      => 240
    );

    SELECT COUNT(*) INTO v_schedule_count_after FROM NEO.schedules;
    ut.expect(v_schedule_count_after).to_equal(v_schedule_count_before + 1);

    SELECT room_id
    INTO v_room_id
    FROM NEO.schedules
    WHERE start_time = TIMESTAMP '2024-11-19 09:00:00' AND end_time = TIMESTAMP '2024-11-19 13:00:00';

    ut.expect(v_room_id).to_equal(2);

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ut.fail('Failed to find the inserted attendance record');
      WHEN OTHERS THEN
        ut.fail('Unexpected error: ' || SQLERRM);
  END test_update_schedule;


  -- TEST TO DISPLAY SCHEDULE
  PROCEDURE test_display_schedule
  IS
      v_schedule_id   NEO.schedules.schedule_id%TYPE := 1;
      v_expected_info VARCHAR2(200);
      v_actual_info   VARCHAR2(200);
      v_start_time    NEO.schedules.start_time%TYPE;
      v_end_time      NEO.schedules.end_time%TYPE;
      v_course_id     NEO.schedules.course_id%TYPE;
      v_group_id      NEO.schedules.group_id%TYPE;
      v_room_id       NEO.schedules.room_id%TYPE;
      v_lecturer_id   NEO.schedules.lecturer_id%TYPE;
      v_schedule_date NEO.schedules.schedule_date%TYPE;
      v_duration      NEO.schedules.duration%TYPE;
      
  BEGIN
      SELECT start_time, end_time, course_id, group_id, room_id, lecturer_id, schedule_date, duration
      INTO v_start_time, v_end_time, v_course_id, v_group_id, v_room_id, v_lecturer_id, v_schedule_date, v_duration
      FROM NEO.schedules
      WHERE schedule_id = v_schedule_id;

      v_expected_info := 'Schedule ID: ' || v_schedule_id ||
               'Start time: ' || TO_CHAR(v_start_time, 'HH24:MI') || 
               ', End time: ' || TO_CHAR(v_end_time, 'HH24:MI') || 
               'Course ID: ' || v_course_id || 
               ', Group ID: ' || v_group_id || 
               ', Room ID: ' || v_room_id || 
               ', Lecturer ID: ' || v_lecturer_id || 
               ', Schedule date: ' || TO_CHAR(v_schedule_date, 'YYYY-MM-DD') || 
               ', Duration: ' || v_duration;

      v_actual_info := NEO.pkg_schedule_management.display_schedule(v_schedule_id);

      ut.expect(v_actual_info).to_equal(v_expected_info);

  EXCEPTION
      WHEN NO_DATA_FOUND THEN
          ut.fail('No schedule found with this ID.');
      WHEN OTHERS THEN
          ut.fail('Unexpected error: ' || SQLERRM);
  END test_display_schedule;
END test_pkg_schedule_management;
/

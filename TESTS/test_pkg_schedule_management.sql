-- TESTS FOR SCHEDULE MANAGEMENT OPERATIONS
CREATE OR REPLACE PACKAGE test_pkg_schedule_management
IS
  --%suite

  --%test test_create_schedule
  PROCEDURE test_create_schedule;
  
  --%test test_delete_schedule
  PROCEDURE test_delete_schedule;
/*
  --%test test_update_schedule
  PROCEDURE test_update_schedule;

  --%test test_display_schedule
  PROCEDURE test_display_schedule;
*/
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
    v_schedule_id NEO.schedules.schedule_id%TYPE := 10;
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



/*
  PROCEDURE test_update_schedule
  IS
  
  END test_update_schedule;


  PROCEDURE test_display_schedule
  IS
  
  END test_display_schedule;
*/
END test_pkg_schedule_management;
/

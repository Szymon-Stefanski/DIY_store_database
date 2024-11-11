-- TESTS FOR ATTENCANDE MANAGEMENT OPERATIONS
CREATE OR REPLACE PACKAGE test_pkg_attendance_management
IS
  --%suite

  --%test test_insert_attendance
  PROCEDURE test_insert_attendance;

  --%test test_update_attendance
  PROCEDURE test_update_attendance;
/*
  --%test test_generate_attendance_report
  PROCEDURE test_generate_attendance_report;

  --%test test_check_student_leaves
  PROCEDURE test_check_student_leaves;
*/
END test_pkg_attendance_management;
/

CREATE OR REPLACE PACKAGE BODY test_pkg_attendance_management
IS
  --TEST TO ADD AN ATTENCANDE RECORD
  PROCEDURE test_insert_attendance
  IS
    v_student_count_before NUMBER;
    v_student_count_after NUMBER;
    v_status NEO.attendances.status%TYPE;
  BEGIN
    SELECT COUNT(*) INTO v_student_count_before FROM NEO.attendances;
    
    DELETE FROM NEO.attendances WHERE student_id = 1 AND schedule_id = 1;

    NEO.pkg_attendance_management.insert_attendance(
      v_student_id => 1,
      v_schedule_id => 1,
      v_status => '0'
    );

    SELECT COUNT(*) INTO v_student_count_after FROM NEO.attendances;
    ut.expect(v_student_count_after).to_equal(v_student_count_before);

    SELECT status
    INTO v_status
    FROM NEO.attendances
    WHERE student_id = 1 AND schedule_id = 1;

    ut.expect(v_status).to_equal('0');

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ut.fail('Failed to find the inserted attendance record');

  END test_insert_attendance;


  --TEST TO UPDATE AN ATTENCANDE RECORD
  PROCEDURE test_update_attendance
  IS    
    v_student_count_before NUMBER;
    v_student_count_after NUMBER;
    v_status NEO.attendances.status%TYPE;
  BEGIN
    SELECT COUNT(*) INTO v_student_count_before FROM NEO.attendances;

    NEO.pkg_attendance_management.update_attendance(
      v_student_id => 1,
      v_schedule_id => 1,
      v_status => '0'
    );

    SELECT COUNT(*) INTO v_student_count_after FROM NEO.attendances;
    ut.expect(v_student_count_after).to_equal(v_student_count_before);

    SELECT status
    INTO v_status
    FROM NEO.attendances
    WHERE student_id = 1 AND schedule_id = 1;

    ut.expect(v_status).to_equal('0');

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ut.fail('Failed to find the inserted attendance record');
  
  END test_update_attendance;

/*
  PROCEDURE test_generate_attendance_report
  IS
  
  END test_generate_attendance_report;


  PROCEDURE test_check_student_leaves
  IS
  
  END test_check_student_leaves;
*/
END test_pkg_attendance_management;
/

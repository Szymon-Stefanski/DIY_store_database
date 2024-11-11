-- TESTS FOR ATTENCANDE MANAGEMENT OPERATIONS
CREATE OR REPLACE PACKAGE test_pkg_attendance_management
IS
  --%suite

  --%test test_insert_attendance
  PROCEDURE test_insert_attendance;

  --%test test_update_attendance
  PROCEDURE test_update_attendance;

  --%test test_generate_attendance_report
  PROCEDURE test_generate_attendance_report;

  --%test test_check_student_leaves
  PROCEDURE test_check_student_leaves;

END test_pkg_attendance_management;
/

CREATE OR REPLACE PACKAGE BODY test_pkg_attendance_management
IS
  --TEST TO ADD AN ATTENCANDE RECORD
  PROCEDURE test_insert_attendance
  IS
    v_attendance_count_before NUMBER;
    v_attendance_count_after NUMBER;
    v_status NEO.attendances.status%TYPE;
  BEGIN
    SELECT COUNT(*) INTO v_attendance_count_before FROM NEO.attendances;
    
    DELETE FROM NEO.attendances WHERE student_id = 1 AND schedule_id = 1;

    NEO.pkg_attendance_management.insert_attendance(
      v_student_id => 1,
      v_schedule_id => 1,
      v_status => '0'
    );

    SELECT COUNT(*) INTO v_attendance_count_after FROM NEO.attendances;
    ut.expect(v_attendance_count_after).to_equal(v_attendance_count_before);

    SELECT status
    INTO v_status
    FROM NEO.attendances
    WHERE student_id = 1 AND schedule_id = 1;

    ut.expect(v_status).to_equal('0');

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ut.fail('Failed to find the inserted attendance record');
      WHEN OTHERS THEN
        ut.fail('Unexpected error: ' || SQLERRM);

  END test_insert_attendance;


  --TEST TO UPDATE AN ATTENCANDE RECORD
  PROCEDURE test_update_attendance
  IS    
    v_attendance_count_before NUMBER;
    v_attendance_count_after NUMBER;
    v_status NEO.attendances.status%TYPE;
  BEGIN
    SELECT COUNT(*) INTO v_attendance_count_before FROM NEO.attendances;

    NEO.pkg_attendance_management.update_attendance(
      v_student_id => 1,
      v_schedule_id => 1,
      v_status => '0'
    );

    SELECT COUNT(*) INTO v_attendance_count_after FROM NEO.attendances;
    ut.expect(v_attendance_count_after).to_equal(v_attendance_count_before);

    SELECT status
    INTO v_status
    FROM NEO.attendances
    WHERE student_id = 1 AND schedule_id = 1;

    ut.expect(v_status).to_equal('0');

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ut.fail('Failed to find the inserted attendance record');
      WHEN OTHERS THEN
        ut.fail('Unexpected error: ' || SQLERRM);
  
  END test_update_attendance;


  --TEST TO GENERATE ATTENDANCE REPORT
  PROCEDURE test_generate_attendance_report
  IS
    v_schedule_id NEO.attendances.schedule_id%TYPE := 1;
    v_group_id    NEO.groups.group_id%TYPE := 1;
    v_expected_info VARCHAR2(2000);
    v_actual_info VARCHAR2(2000);

    CURSOR attendance_cursor IS
      SELECT s.student_id, s.first_name, s.last_name, a.status
      FROM NEO.students s
      LEFT JOIN NEO.attendances a ON s.student_id = a.student_id
      WHERE a.schedule_id = v_schedule_id;

  BEGIN
    v_expected_info := 'Attendance Report for Schedule ID: ' || v_schedule_id || CHR(10) ||
                      '----------------------------------------' || CHR(10) ||
                      'Student ID | First Name | Last Name | Status';

    FOR attendance_record IN attendance_cursor LOOP
        v_expected_info := v_expected_info || CHR(10) ||
                          attendance_record.student_id || ' | ' ||
                          attendance_record.first_name || ' | ' ||
                          attendance_record.last_name || ' | ' ||
                          NVL(attendance_record.status, 'Not Recorded');
    END LOOP;

    v_expected_info := v_expected_info || CHR(10) || '----------------------------------------' || CHR(10) || 'Report Generation Completed.';

    v_actual_info := NEO.pkg_attendance_management.generate_attendance_report(v_schedule_id, v_group_id);

    ut.expect(v_actual_info).to_equal(v_expected_info);

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      ut.fail('Failed to find attendance records for the specified schedule and group.');
    WHEN OTHERS THEN
      ut.fail('Unexpected error: ' || SQLERRM);
  END test_generate_attendance_report;

  --TEST TO CHECK STUDENTS LEAVES
  PROCEDURE test_check_student_leaves
  IS
    v_student_id NEO.students.student_id%TYPE := 1;
    v_expected_info NUMBER;
    v_actual_info NUMBER;
  BEGIN
      SELECT COUNT(*)
      INTO v_expected_info
      FROM NEO.attendances
      WHERE student_id = v_student_id
        AND status = 0;

      v_actual_info := NEO.pkg_attendance_management.check_student_leaves(v_student_id);

      ut.expect(v_actual_info).to_equal(v_expected_info);

      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          ut.fail('Failed to find the inserted attendance record');
        WHEN OTHERS THEN
          ut.fail('Unexpected error: ' || SQLERRM);

  END test_check_student_leaves;

END test_pkg_attendance_management;
/

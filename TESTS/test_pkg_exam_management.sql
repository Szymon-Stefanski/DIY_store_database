-- TESTS FOR EXAM MANAGEMENT OPERATIONS
CREATE OR REPLACE PACKAGE test_pkg_exam_management
IS
  --%suite

  --%test test_add_exam
  PROCEDURE test_add_exam;

  --%test test_delete_exam
  PROCEDURE test_delete_exam;

  --%test test_update_exam
  PROCEDURE test_update_exam;

  --%test test_display_exam
  PROCEDURE test_display_exam;
END test_pkg_exam_management;
/


CREATE OR REPLACE PACKAGE BODY test_pkg_exam_management
IS
  --TEST TO ADD AN EXAM
  PROCEDURE test_add_exam
  IS
    v_exam_count_before NUMBER;
    v_exam_count_after NUMBER;
    v_exam_date NEO.exams.exam_date%TYPE;
    
  BEGIN
    SELECT COUNT(*) INTO v_exam_count_before FROM NEO.exams;

   NEO.pkg_exam_management.add_exam(
      v_course_id    => 1,
      v_group_id     => 1,
      v_exam_date    => TIMESTAMP '2024-11-19 10:00:00',
      v_room_id      => 1
    );

    SELECT COUNT(*) INTO v_exam_count_after FROM NEO.exams;
    ut.expect(v_exam_count_after).to_equal(v_exam_count_before + 1);

    SELECT exam_date
    INTO   v_exam_date
    FROM   NEO.exams
    WHERE  course_id = 1 AND group_id = 1 AND room_id = 1 AND exam_date > TIMESTAMP '2024-11-13 10:00:00';

    ut.expect(v_exam_date).to_equal(TIMESTAMP '2024-11-19 10:00:00');

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ut.fail('Failed to find the inserted exam record');
      WHEN OTHERS THEN
        ut.fail('Unexpected error: ' || SQLERRM);
  END test_add_exam;


  --TEST TO DELETE AN EXAM
  PROCEDURE test_delete_exam
  IS
    v_exam_count_before NUMBER;
    v_exam_count_after NUMBER;
    v_exam_id NEO.exams.exam_id%TYPE;
    
  BEGIN
    SELECT COUNT(*) INTO v_exam_count_before FROM NEO.exams;

    NEO.pkg_exam_management.add_exam(
      v_course_id    => 1,
      v_group_id     => 1,
      v_exam_date    => TIMESTAMP '2024-11-19 10:00:00',
      v_room_id      => 1
    );
    
    SELECT exam_id
    INTO   v_exam_id
    FROM   NEO.exams
    WHERE  course_id = 1 AND group_id = 1 AND room_id = 1 AND exam_date > SYSDATE;

    SELECT COUNT(*) INTO v_exam_count_after FROM NEO.exams;
    ut.expect(v_exam_count_after).to_equal(v_exam_count_before + 1);

    NEO.pkg_exam_management.delete_exam(v_exam_id);

    SELECT COUNT(*) INTO v_exam_count_after FROM NEO.exams;
    ut.expect(v_exam_count_after).to_equal(v_exam_count_before);

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ut.fail('Failed to find the exam record');
      WHEN OTHERS THEN
        ut.fail('Unexpected error: ' || SQLERRM);
  END test_delete_exam;


  --TEST TO UPDATE AN EXAM
  PROCEDURE test_update_exam
  IS
    v_exam_count_before NUMBER;
    v_exam_count_after NUMBER;
    v_exam_id NEO.exams.exam_id%TYPE;
    v_exam_date NEO.exams.exam_date%TYPE;
    
  BEGIN
    SELECT COUNT(*) INTO v_exam_count_before FROM NEO.exams;

    NEO.pkg_exam_management.add_exam(
      v_course_id    => 1,
      v_group_id     => 1,
      v_exam_date    => TIMESTAMP '2024-11-19 10:00:00',
      v_room_id      => 1
    );
    
    SELECT exam_id
    INTO   v_exam_id
    FROM   NEO.exams
    WHERE  course_id = 1 AND group_id = 1 AND room_id = 1 AND exam_date > SYSDATE;

    NEO.pkg_exam_management.update_exam (
      v_exam_id      => v_exam_id,
      v_course_id    => 1,
      v_group_id     => 1,
      v_exam_date    => TIMESTAMP '2024-12-19 10:00:00',
      v_room_id      => 1
    );

    SELECT COUNT(*) INTO v_exam_count_after FROM NEO.exams;
    ut.expect(v_exam_count_after).to_equal(v_exam_count_before + 1);

    SELECT exam_date
    INTO   v_exam_date
    FROM   NEO.exams
    WHERE  course_id = 1 AND group_id = 1 AND room_id = 1 AND exam_date > SYSDATE;

    ut.expect(v_exam_date).to_equal(TIMESTAMP '2024-12-19 10:00:00');

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ut.fail('Failed to find the exam record');
      WHEN OTHERS THEN
        ut.fail('Unexpected error: ' || SQLERRM);
  END test_update_exam;


  --TEST TO DISPLAY AN EXAM
  PROCEDURE test_display_exam
  IS
    v_exam_id   NEO.exams.exam_id%TYPE := 1;
    v_expected_info VARCHAR2(200);
    v_actual_info   VARCHAR2(200);
    v_course_id    NEO.exams.course_id%TYPE;
    v_group_id     NEO.exams.group_id%TYPE;
    v_exam_date    NEO.exams.exam_date%TYPE;
    v_room_id      NEO.exams.room_id%TYPE;
    
  BEGIN
    SELECT course_id, group_id, exam_date, room_id
    INTO v_course_id, v_group_id, v_exam_date, v_room_id
    FROM NEO.exams
    WHERE exam_id = v_exam_id;

    v_expected_info :=   'Exam ID: ' || v_exam_id ||
            ', Course ID: ' || v_course_id || 
            ', Group ID: ' || v_group_id || 
            ', Exam date: ' || TO_CHAR(v_exam_date, 'YYYY-MM-DD') || 
            ', Room ID: ' || v_room_id;
    
    v_actual_info := NEO.pkg_exam_management.display_exam(v_exam_id);

    ut.expect(v_actual_info).to_equal(v_expected_info);

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ut.fail('Failed to find the exam record with this id');
      WHEN OTHERS THEN
        ut.fail('Unexpected error: ' || SQLERRM);
  END test_display_exam;
END test_pkg_exam_management;
/

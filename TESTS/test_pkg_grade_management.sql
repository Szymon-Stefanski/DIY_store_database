-- TESTS FOR GRADE MANAGEMENT OPERATIONS
CREATE OR REPLACE PACKAGE test_pkg_grade_management 
IS
  --%suite

  --%test test_add_grade
  PROCEDURE test_add_grade;

  --%test test_update_grade
  PROCEDURE test_update_grade;

  --%test test_avg_grade
  PROCEDURE test_avg_grade;

  --%test test_get_all_grades
  PROCEDURE test_get_all_grades;

END test_pkg_grade_management;
/

CREATE OR REPLACE PACKAGE BODY test_pkg_grade_management
IS
  --TEST FOR ADDING A NEW GRADE RECORD
  PROCEDURE test_add_grade
  IS
    v_grade_count_before NUMBER;
    v_grade_count_after NUMBER;
    v_grade NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_grade_count_before FROM NEO.grades;

    NEO.pkg_grade_management.add_grade(
      v_student_id => 1,
      v_course_id => 1,
      v_exam_id => 1,
      v_grade => 2.0
    );

    SELECT COUNT(*) INTO v_grade_count_after FROM NEO.grades;
    ut.expect(v_grade_count_after).to_equal(v_grade_count_before + 1);

    SELECT g.grade 
    INTO v_grade
    FROM NEO.grades g
    JOIN NEO.students_grades s
    ON s.grade_id = g.grade_id
    WHERE s.student_id = 1 AND g.course_id = 1 AND g.exam_id = 1 AND g.grade < 3.0;

    ut.expect(v_grade).to_equal(2.0);

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      ut.fail('Failed to find the inserted grade record');
    WHEN OTHERS THEN
      ut.fail('Unexpected error: ' || SQLERRM);

  END test_add_grade;

  --TEST FOR UPDATING A GRADE RECORD
  PROCEDURE test_update_grade
  IS
    v_grade_count_before NUMBER;
    v_grade_count_after NUMBER;
    v_grade NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_grade_count_before FROM NEO.grades;

    NEO.pkg_grade_management.update_grade(
      v_grade_id => 1,
      v_grade => 2.0
    );

    SELECT COUNT(*) INTO v_grade_count_after FROM NEO.grades;
    ut.expect(v_grade_count_after).to_equal(v_grade_count_before);

    SELECT grade
    INTO v_grade
    FROM NEO.grades
    WHERE grade_id = 1;

    ut.expect(v_grade).to_equal(2.0);
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      ut.fail('Failed to find the inserted grade record');
    WHEN OTHERS THEN
      ut.fail('Unexpected error: ' || SQLERRM);

  END test_update_grade;

  --TEST FOR GETTING AN AVERAGE FROM STUDENT'S GRADES
  PROCEDURE test_avg_grade
  IS
    v_student_id NEO.students.student_id%TYPE := 1;
    v_grade NEO.grades.grade%TYPE;
    v_expected_info VARCHAR2(100);
    v_actual_info VARCHAR2(100);
  BEGIN
    SELECT NVL(AVG(g.grade), 0)
    INTO v_grade
    FROM NEO.grades g
    INNER JOIN NEO.students_grades s ON g.grade_id = s.grade_id
    WHERE s.student_id = v_student_id;

    v_actual_info := 'Average grade: ' || v_grade;

    v_expected_info := NEO.pkg_grade_management.avg_grade(v_student_id);

    ut.expect(v_actual_info).to_equal(v_expected_info);

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      ut.fail('Failed to find average grades for student with this id');
    WHEN OTHERS THEN
      ut.fail('Unexpected error: ' || SQLERRM);

  END test_avg_grade;

  --TEST FOR GETTING ALL STUDENT'S GRADES
  PROCEDURE test_get_all_grades
  IS
    v_student_id NEO.students.student_id%TYPE := 1;
    v_expected_info VARCHAR2(200);
    v_actual_info VARCHAR2(200);

    CURSOR grade_cursor IS
      SELECT g.grade_id, g.course_id, g.exam_id, g.grade
      FROM NEO.grades g
      INNER JOIN NEO.students_grades s ON g.grade_id = s.grade_id
      WHERE s.student_id = v_student_id;

    v_output      VARCHAR2(1000) := 'Grades for Student ID: ' || v_student_id || ': ';
    v_first       BOOLEAN := TRUE;
  BEGIN
    FOR grade_record IN grade_cursor LOOP
        v_first := FALSE;
        v_actual_info := v_output || 
                    'Grade ID: ' || grade_record.grade_id || ', ' ||
                    'Course ID: ' || grade_record.course_id || ', ' ||
                    'Exam ID: ' || grade_record.exam_id || ', ' ||
                    'Grade: ' || grade_record.grade || '; ';
    END LOOP;

    v_expected_info := NEO.pkg_grade_management.get_all_grades(1);
    
    ut.expect(v_actual_info).to_equal(v_expected_info);

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      ut.fail('Failed to find average grades for student with this id');
    WHEN OTHERS THEN
      ut.fail('Unexpected error: ' || SQLERRM);
  END test_get_all_grades;

END test_pkg_grade_management;
/

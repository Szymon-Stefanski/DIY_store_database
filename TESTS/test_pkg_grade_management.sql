CREATE OR REPLACE PACKAGE test_pkg_grade_management 
IS
  --%suite

  --%test test_add_grade
  PROCEDURE test_add_grade;

  --%test test_update_grade
  PROCEDURE test_update_grade;
/*
  --%test test_avg_grade
  PROCEDURE test_avg_grade;

  --%test test_get_all_grades
  PROCEDURE test_get_all_grades;
  */
END test_pkg_grade_management;
/

CREATE OR REPLACE PACKAGE BODY test_pkg_grade_management
IS

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


/*
  PROCEDURE test_avg_grade
  IS

  END test_avg_grade;


  PROCEDURE test_get_all_grades
  IS
  
  END test_get_all_grades;
*/
END test_pkg_grade_management;
/

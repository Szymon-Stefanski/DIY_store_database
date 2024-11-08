CREATE OR REPLACE PACKAGE test_pkg_course_management IS
  --%suite

  --%test test_create_course
  PROCEDURE test_create_course;

  /*
  --%test test_delete_course
  PROCEDURE test_delete_course;

  --%test test_update_course
  PROCEDURE test_update_course;

  --%test test_display_course
  PROCEDURE test_display_course;
  */
END test_pkg_course_management;
/

CREATE OR REPLACE PACKAGE BODY test_pkg_course_management IS

  PROCEDURE test_create_course IS
    v_course_count_before NUMBER;
    v_course_count_after  NUMBER;
    v_course_name         NEO.courses.course_name%TYPE;
    v_course_id           NEO.courses.course_id%TYPE;
  BEGIN
    SELECT COUNT(*) INTO v_course_count_before FROM NEO.courses;

    University.pkg_course_management.create_course(
      v_course_name => 'v_course'
    );

    SELECT COUNT(*) INTO v_course_count_after FROM NEO.courses;
    ut.expect(v_course_count_after).to_equal(v_course_count_before + 1);

    SELECT course_id, course_name
    INTO v_course_id, v_course_name
    FROM NEO.courses
    WHERE course_name = 'v_course';

    ut.expect(v_course_name).to_equal('v_course');

    DELETE FROM NEO.courses WHERE course_name = 'v_course';

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      ut.fail('Failed to find the inserted course record');
    WHEN OTHERS THEN
      ut.fail('Unexpected error: ' || SQLERRM);
  END test_create_course;

  /*
  PROCEDURE test_delete_course IS

  END test_delete_course;


  PROCEDURE test_update_course IS
  
  END test_update_course;

 
  PROCEDURE test_display_course IS
  
  END test_display_course;
  */
END test_pkg_course_management;

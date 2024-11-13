-- TESTS FOR COURSE MANAGEMENT OPERATIONS
CREATE OR REPLACE PACKAGE test_pkg_course_management 
IS
  --%suite

  --%test test_create_course
  PROCEDURE test_create_course;

  --%test test_delete_course
  PROCEDURE test_delete_course;

  --%test test_update_course
  PROCEDURE test_update_course;

  --%test test_display_course
  PROCEDURE test_display_course;
END test_pkg_course_management;
/


CREATE OR REPLACE PACKAGE BODY test_pkg_course_management 
IS
  --TEST TO CREATE A NEW COURSE RECORD
  PROCEDURE test_create_course IS
    v_course_count_before NUMBER;
    v_course_count_after  NUMBER;
    v_course_name         NEO.courses.course_name%TYPE;
    v_course_id           NEO.courses.course_id%TYPE;

  BEGIN
    SELECT COUNT(*) INTO v_course_count_before FROM NEO.courses;

    NEO.pkg_course_management.create_course(
      v_course_name => 'v_course'
    );

    SELECT COUNT(*) INTO v_course_count_after FROM NEO.courses;
    ut.expect(v_course_count_after).to_equal(v_course_count_before + 1);

    SELECT course_id, course_name
    INTO v_course_id, v_course_name
    FROM NEO.courses
    WHERE course_name = 'v_course';

    ut.expect(v_course_name).to_equal('v_course');

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      ut.fail('Failed to find the inserted course record');
    WHEN OTHERS THEN
      ut.fail('Unexpected error: ' || SQLERRM);
  END test_create_course;


  --TEST TO DELETE A COURSE RECORD
  PROCEDURE test_delete_course 
  IS
    v_course_count_before NUMBER;
    v_course_count_after  NUMBER;
    v_course_name         NEO.courses.course_name%TYPE;
    v_course_id           NEO.courses.course_id%TYPE;

  BEGIN

    SELECT COUNT(*) INTO v_course_count_before FROM NEO.courses;

    NEO.pkg_course_management.create_course(
      v_course_name => 'v_course'
    );

    SELECT COUNT(*) INTO v_course_count_after FROM NEO.courses;
    ut.expect(v_course_count_after).to_equal(v_course_count_before + 1);

    SELECT course_id, course_name
    INTO v_course_id, v_course_name
    FROM NEO.courses
    WHERE course_name = 'v_course';

    NEO.pkg_course_management.delete_course(v_course_id);

    SELECT COUNT(*) INTO v_course_count_after FROM NEO.courses;
    ut.expect(v_course_count_after).to_equal(v_course_count_before);

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      ut.fail('Failed to find the course record');
    WHEN OTHERS THEN
      ut.fail('Unexpected error: ' || SQLERRM);
  END test_delete_course;


  --TEST TO UPDATE A COURSE RECORD
  PROCEDURE test_update_course 
  IS
    v_course_count_before NUMBER;
    v_course_count_after  NUMBER;
    v_course_name         NEO.courses.course_name%TYPE;
    v_course_id           NEO.courses.course_id%TYPE;

  BEGIN
    SELECT COUNT(*) INTO v_course_count_before FROM NEO.courses;
  
    NEO.pkg_course_management.create_course(
        v_course_name => 'v_course'
      );
  
    SELECT COUNT(*) INTO v_course_count_after FROM NEO.courses;
    ut.expect(v_course_count_after).to_equal(v_course_count_before + 1);
  
    SELECT course_id 
    INTO v_course_id 
    FROM NEO.courses 
    WHERE course_name = 'v_course';
  
    UPDATE NEO.courses
    SET course_name = 'test_course_name'
    WHERE course_id = v_course_id;
  

    SELECT course_name 
    INTO v_course_name 
    FROM NEO.courses 
    WHERE course_id = v_course_id;

    ut.expect(v_course_name).to_equal('test_course_name');
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      ut.fail('Failed to find the course record');
    WHEN OTHERS THEN
      ut.fail('Unexpected error: ' || SQLERRM);
  END test_update_course;


  --TEST TO DISPLAY A COURSE RECORD
  PROCEDURE test_display_course 
  IS
    v_course_id NEO.courses.course_id%TYPE;
    v_course_name NEO.courses.course_name%TYPE;
    v_expected_info VARCHAR2(100);
    v_actual_info VARCHAR2(100);

  BEGIN
    INSERT INTO NEO.courses(course_name) VALUES ('test_course')
    RETURNING course_id, course_name INTO v_course_id, v_course_name;

    v_expected_info :=  'Course ID: ' || v_course_id || 
                    ', Course name: ' || v_course_name;
    
    v_actual_info := NEO.pkg_course_management.display_course(v_course_id);

    ut.expect(v_expected_info).to_equal(v_actual_info);

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      ut.fail('Failed to find the course record');
    WHEN OTHERS THEN
      ut.fail('Unexpected error: ' || SQLERRM);
  END test_display_course;
END test_pkg_course_management;
/

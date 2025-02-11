-- PACKAGE FOR COURSE MANAGEMENT OPERATIONS
CREATE OR REPLACE PACKAGE pkg_course_management
IS
  PROCEDURE create_course (v_course_name courses.course_name%TYPE);

  PROCEDURE delete_course (v_course_id courses.course_id%TYPE);

  PROCEDURE update_course (
    v_course_id courses.course_id%TYPE, 
    v_course_name courses.course_name%TYPE
    );

  FUNCTION display_course(v_course_id courses.course_id%TYPE) RETURN VARCHAR2;
END pkg_course_management;
/


CREATE OR REPLACE PACKAGE BODY pkg_course_management
IS
  -- PROCEDURE TO CREATE A NEW COURSE
  PROCEDURE create_course (v_course_name courses.course_name%TYPE)
  IS

  BEGIN
    INSERT INTO courses(course_name) VALUES (v_course_name);

    IF SQL%ROWCOUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Course can''t be added, please try again');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Course added successfully!');
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error occurred. SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
  END create_course;


  -- PROCEDURE TO DELETE A COURSE
  PROCEDURE delete_course (v_course_id courses.course_id%TYPE)
  IS

  BEGIN
    DELETE FROM courses WHERE course_id = v_course_id;

    IF SQL%ROWCOUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Course can''t be deleted, please try again');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Course deleted successfully!');
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error occurred. SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
  END delete_course;


  -- PROCEDURE TO UPDATE A COURSE
  PROCEDURE update_course (
    v_course_id courses.course_id%TYPE, 
    v_course_name courses.course_name%TYPE
    )
  IS

  BEGIN
    UPDATE  courses
    SET     course_name = v_course_name
    WHERE   course_id = v_course_id;

    IF SQL%ROWCOUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Course can''t be updated, please try again');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Course updated successfully!');
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error occurred. SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
  END update_course;


    --FUNCTION FOR DISPLAYING COURSE DETAILS
  FUNCTION display_course(v_course_id courses.course_id%TYPE) 
  RETURN VARCHAR2
  IS
      v_course_name  courses.course_name%TYPE;

  BEGIN
      SELECT course_name
      INTO v_course_name
      FROM courses
      WHERE course_id = v_course_id;

      RETURN  'Course ID: ' || v_course_id || 
              ', Course name: ' || v_course_name;
    
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN 'No course found with this ID.';
      WHEN OTHERS THEN
        RETURN 'Error occurred. SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM;
  END display_course;
END pkg_course_management;
/

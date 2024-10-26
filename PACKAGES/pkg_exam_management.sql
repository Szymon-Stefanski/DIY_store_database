-- PACKAGE FOR EXAM MANAGEMENT OPERATIONS
CREATE OR REPLACE PACKAGE pkg_exam_management
IS
  PROCEDURE add_exam (
    v_course_id    exams.course_id%TYPE,
    v_group_id     exams.group_id%TYPE,
    v_exam_date    exams.exam_date%TYPE,
    v_room_id      exams.room_id%TYPE
    );
  PROCEDURE delete_exam (v_exam_id exams.exam_id%TYPE);
  PROCEDURE update_exam (
    v_exam_id      exams.exam_id%TYPE,
    v_course_id    exams.course_id%TYPE,
    v_group_id     exams.group_id%TYPE,
    v_exam_date    exams.exam_date%TYPE,
    v_room_id      exams.room_id%TYPE
    );
    FUNCTION display_exam(v_exam_id exams.exam_id%TYPE) RETURN VARCHAR2;
  
END pkg_exam_management;
/

CREATE OR REPLACE PACKAGE BODY pkg_exam_management
IS
  -- PROCEDURE TO ADD AN EXAM
  PROCEDURE add_exam (
    v_course_id    exams.course_id%TYPE,
    v_group_id     exams.group_id%TYPE,
    v_exam_date    exams.exam_date%TYPE,
    v_room_id      exams.room_id%TYPE
    )
  IS
  BEGIN
    INSERT INTO exams
    (course_id, group_id, exam_date, room_id) 
    VALUES 
    (v_course_id, v_group_id, v_exam_date, v_room_id);
    
    IF SQL%ROWCOUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Exam can''t be added, please try again');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Exam added successfully!');
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error occurred. SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
  END add_exam;



  -- PROCEDURE TO DELETE AN EXAM
  PROCEDURE delete_exam (v_exam_id exams.exam_id%TYPE)
    IS
  BEGIN
    DELETE FROM exams WHERE exam_id = v_exam_id;

    IF SQL%ROWCOUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Exam can''t be deleted, please try again');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Exam deleted successfully!');
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error occurred. SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
  END delete_exam;


  -- PROCEDURE TO UPDATE AN EXAM
  PROCEDURE update_exam (
    v_exam_id      exams.exam_id%TYPE,
    v_course_id    exams.course_id%TYPE,
    v_group_id     exams.group_id%TYPE,
    v_exam_date    exams.exam_date%TYPE,
    v_room_id      exams.room_id%TYPE
    )
  IS
  BEGIN
    UPDATE  exams
    SET     course_id = v_course_id,
            group_id =  v_group_id,
            exam_date = v_exam_date,
            room_id =   v_room_id
    WHERE   exam_id = v_exam_id;

    IF SQL%ROWCOUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Exam can''t be updated, please try again');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Exam updated successfully!');
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error occurred. SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
  END update_exam;


  --FUNCTION FOR DISPLAYING EXAM DETAILS
  FUNCTION display_exam(v_exam_id exams.exam_id%TYPE) 
  RETURN VARCHAR2
  IS
      v_course_id    exams.course_id%TYPE;
      v_group_id     exams.group_id%TYPE;
      v_exam_date    exams.exam_date%TYPE;
      v_room_id      exams.room_id%TYPE;
  BEGIN
      SELECT course_id, group_id, exam_date, room_id
      INTO v_course_id, v_group_id, v_exam_date, v_room_id
      FROM exams
      WHERE exam_id = v_exam_id;

      RETURN 'Course ID: ' || v_course_id || ', Group ID: ' || v_group_id 
            || ', Exam date: ' || TO_CHAR(v_exam_date, 'YYYY-MM-DD') 
            || ', Room ID: ' || v_room_id;
    
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN 'No exam found with this ID.';
      WHEN OTHERS THEN
        RETURN 'Error occurred. SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM;
  END display_exam;
END pkg_exam_management;

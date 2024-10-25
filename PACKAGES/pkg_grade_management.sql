-- PACKAGE FOR GRADES MANAGEMENT OPERATIONS
CREATE OR REPLACE PACKAGE pkg_grade_management
IS
  PROCEDURE add_grade(
    v_student_id  students_grades.student_id%TYPE,
    v_course_id   grades.course_id%TYPE,
    v_exam_id     grades.exam_id%TYPE,
    v_grade       grades.grade%TYPE
  );

  PROCEDURE update_grade(
    v_student_id  students_grades.student_id%TYPE,
    v_course_id   grades.course_id%TYPE,
    v_exam_id     grades.exam_id%TYPE,
    v_grade       grades.grade%TYPE
  );

  FUNCTION avg_grade(v_student_id students_grades.student_id%TYPE) RETURN VARCHAR2;
  FUNCTION get_all_grades(v_student_id students_grades.student_id%TYPE) RETURN VARCHAR2;
END pkg_grade_management;
/ 

CREATE OR REPLACE PACKAGE BODY pkg_grade_management
IS
  -- PROCEDURE TO ADD A NEW GRADE RECORD
  PROCEDURE add_grade(
    v_student_id  students_grades.student_id%TYPE,
    v_course_id   grades.course_id%TYPE,
    v_exam_id     grades.exam_id%TYPE,
    v_grade       grades.grade%TYPE
  )
  IS
    ex_grade EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_grade, -20001);

    v_grade_id grades.grade_id%TYPE;
  BEGIN
    IF v_grade BETWEEN 2.0 AND 5.0 THEN
      INSERT INTO grades (course_id, exam_id, grade)
      VALUES (v_course_id, v_exam_id, v_grade)
      RETURNING grade_id INTO v_grade_id;;

      INSERT INTO students_grades (student_id, grade_id)
      VALUES (v_student_id, v_grade)
      DBMS_OUTPUT.PUT_LINE('Grade added successfully.');
    ELSE
      RAISE ex_grade;
    END IF;

  EXCEPTION
    WHEN ex_grade THEN
      DBMS_OUTPUT.PUT_LINE('Please, add grade in range: 2.0 to 5.0');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error occurred. SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
  END add_grade;

  -- PROCEDURE TO UPDATE A STUDENT'S GRADE
  PROCEDURE update_grade(
      v_student_id  students_grades.student_id%TYPE,
      v_course_id   grades.course_id%TYPE,
      v_exam_id     grades.exam_id%TYPE,
      v_grade       grades.grade%TYPE
  )
  IS
  BEGIN
    UPDATE grades g
    SET g.grade = v_grade
    WHERE g.grade_id = (
        SELECT s.grade_id
        FROM students_grades s
        WHERE s.student_id = v_student_id
          AND g.course_id = v_course_id
          AND g.exam_id = v_exam_id
    );

      IF SQL%ROWCOUNT = 0 THEN
          DBMS_OUTPUT.PUT_LINE('No matching record found for the provided student, course, and exam IDs.');
      ELSE
          DBMS_OUTPUT.PUT_LINE('Student grade updated successfully.');
      END IF;

  EXCEPTION
      WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('Error occurred. SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
  END update_grade;

  -- FUNCTION TO RETRIEVE AVERAGE GRADE BY STUDENT ID
  FUNCTION avg_grade(v_student_id students_grades.student_id%TYPE)
  RETURN VARCHAR2 
  IS
    v_grade       NUMBER;
    v_output      VARCHAR2(100);
  BEGIN
    SELECT NVL(AVG(g.grade), 0)
    INTO v_grade
    FROM grades g
    INNER JOIN students_grades s ON g.grade_id = s.grade_id
    WHERE s.student_id = v_student_id;

    v_output := 'Average grade: ' || v_grade;

    RETURN v_output;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 'No grades found for this student.';
    WHEN OTHERS THEN
      RETURN 'Error occurred. SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM;

  END avg_grade;

  -- FUNCTION TO RETRIEVE ALL GRADES INFORMATION BY STUDENT ID
  FUNCTION get_all_grades(v_student_id students_grades.student_id%TYPE)
  RETURN VARCHAR2
  IS
      CURSOR grade_cursor IS
          SELECT g.grade_id, g.course_id, g.exam_id, g.grade
          FROM grades g
          INNER JOIN students_grades s ON g.grade_id = s.grade_id
          WHERE s.student_id = v_student_id;

      v_output      VARCHAR2(1000) := 'Grades for Student ID: ' || v_student_id || ': ';
      v_first       BOOLEAN := TRUE;

  BEGIN
      FOR grade_record IN grade_cursor LOOP
          v_first := FALSE;
          v_output := v_output || 
                      'Grade ID: ' || grade_record.grade_id || ', ' ||
                      'Course ID: ' || grade_record.course_id || ', ' ||
                      'Exam ID: ' || grade_record.exam_id || ', ' ||
                      'Grade: ' || grade_record.grade || '; ';
      END LOOP;

      IF v_first THEN
          RETURN 'No grades found for this student.';
      ELSE
          RETURN v_output;
      END IF;

  EXCEPTION
      WHEN OTHERS THEN
          RETURN 'Error occurred. SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM;
  END get_all_grades;

END pkg_grade_management;

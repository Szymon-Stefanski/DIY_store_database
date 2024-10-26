-- PACKAGE FOR STUDENT MANAGEMENT OPERATIONS
CREATE OR REPLACE PACKAGE pkg_student_management 
IS
  PROCEDURE add_new_student(    
    v_first_name    students.first_name%TYPE,
    v_last_name     students.last_name%TYPE,
    v_email         students.email%TYPE,
    v_city          students.city%TYPE,
    v_street        students.street%TYPE,
    v_home_number   students.home_number%TYPE,
    v_postal_code   students.postal_code%TYPE,
    v_phone_number  students.phone_number%TYPE,
    v_pesel         students.PESEL%TYPE
    );
  PROCEDURE delete_student_record(v_student_id students.student_id%TYPE);
  PROCEDURE update_student_address(
    v_student_id    students.student_id%TYPE,
    v_city          students.city%TYPE,
    v_street        students.street%TYPE,
    v_home_number   students.home_number%TYPE,
    v_postal_code   students.postal_code%TYPE
    );
  FUNCTION get_student_info(v_student_id students.student_id%TYPE) RETURN VARCHAR2;
END pkg_student_management;
/


CREATE OR REPLACE PACKAGE BODY pkg_student_management 
IS
  -- PROCEDURE TO ADD A NEW STUDENT RECORD
  PROCEDURE add_new_student(    
    v_first_name    students.first_name%TYPE,
    v_last_name     students.last_name%TYPE,
    v_email         students.email%TYPE,
    v_city          students.city%TYPE,
    v_street        students.street%TYPE,
    v_home_number   students.home_number%TYPE,
    v_postal_code   students.postal_code%TYPE,
    v_phone_number  students.phone_number%TYPE,
    v_pesel         students.PESEL%TYPE
  )
  IS
  BEGIN
    INSERT INTO 
    students (first_name, last_name, email, city, street, home_number, postal_code, phone_number, PESEL)
    VALUES 
    (v_first_name, v_last_name, v_email, v_city, v_street, v_home_number, v_postal_code, v_phone_number, v_pesel);

    
    IF SQL%ROWCOUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Student can''t be added, please try again.');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Student added successfully.');
    END IF;

  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      DBMS_OUTPUT.PUT_LINE('Error: A student with this phone number or PESEL already exists.');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error occurred. SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
  END add_new_student;



  -- PROCEDURE TO DELETE A STUDENT RECORD BY STUDENT ID
  PROCEDURE delete_student_record(v_student_id students.student_id%TYPE)
  IS
  BEGIN
    DELETE FROM students WHERE student_id = v_student_id;

    IF SQL%ROWCOUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Student not found.');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Student deleted successfully.');
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error occurred. SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
  END delete_student_record;



  -- PROCEDURE TO UPDATE A STUDENT'S ADDRESS
  PROCEDURE update_student_address(
    v_student_id    students.student_id%TYPE,
    v_city          students.city%TYPE,
    v_street        students.street%TYPE,
    v_home_number   students.home_number%TYPE,
    v_postal_code   students.postal_code%TYPE
  )
  IS
  BEGIN
    UPDATE students 
    SET city = v_city,
        street = v_street,
        home_number = v_home_number,
        postal_code = v_postal_code
    WHERE student_id = v_student_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Student not found.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Student address updated successfully.');
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error occurred. SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
  END update_student_address;



  -- FUNCTION TO RETRIEVE STUDENT INFORMATION BY STUDENT ID
  FUNCTION get_student_info(v_student_id students.student_id%TYPE) 
  RETURN VARCHAR2
  IS
    v_first_name    students.first_name%TYPE;
    v_last_name     students.last_name%TYPE;
    v_email         students.email%TYPE;
    v_city          students.city%TYPE;
    v_street        students.street%TYPE;
    v_home_number   students.home_number%TYPE;
    v_postal_code   students.postal_code%TYPE;
    v_phone_number  students.phone_number%TYPE;
    v_pesel         students.PESEL%TYPE;
    v_output        VARCHAR2(500);

  BEGIN
    SELECT first_name, last_name, email, city, street, home_number, postal_code, phone_number, PESEL
    INTO v_first_name, v_last_name, v_email, v_city, v_street, v_home_number, v_postal_code, v_phone_number, v_pesel
    FROM students
    WHERE student_id = v_student_id;

    v_output := 'Student ID: ' || v_student_id || ', ' ||
                'First Name: ' || v_first_name || ', ' ||
                'Last Name: ' || v_last_name || ', ' ||
                'Email: ' || v_email || ', ' ||
                'City: ' || v_city || ', ' ||
                'Street: ' || v_street || ', ' ||
                'Home Number: ' || v_home_number || ', ' ||
                'Postal Code: ' || v_postal_code || ', ' ||
                'Phone Number: ' || v_phone_number || ', ' ||
                'PESEL: ' || v_pesel;

    RETURN v_output;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 'Student not found.';
    WHEN OTHERS THEN
      RETURN 'Error occurred. SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM;

  END get_student_info;

END pkg_student_management;

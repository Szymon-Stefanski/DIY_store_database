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
  --PROCEDURE delete_student_record;
  --PROCEDURE update_student_address;
  FUNCTION get_student_info(p_student_id students.student_id%TYPE) RETURN VARCHAR2;
END pkg_student_management;
/

CREATE OR REPLACE PACKAGE BODY pkg_student_management 
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
    )
  IS
  BEGIN
    INSERT INTO 
    students (first_name, last_name, email, city, street, home_number, postal_code, phone_number, PESEL)
    VALUES 
    (v_first_name, v_last_name, v_email, v_city, v_street, v_home_number, v_postal_code, v_phone_number, v_pesel);
    
    DBMS_OUTPUT.PUT_LINE('Student added successfully.');
    
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      DBMS_OUTPUT.PUT_LINE('Error: A student with this phone number or PESEL already exists.');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error occurred. SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
  END add_new_student;

  FUNCTION get_student_info(p_student_id students.student_id%TYPE) 
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
    WHERE student_id = p_student_id;

    v_output := 'Student ID: ' || p_student_id || ', ' ||
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

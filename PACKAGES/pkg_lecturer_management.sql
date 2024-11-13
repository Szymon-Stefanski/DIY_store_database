-- PACKAGE FOR LECTURERS MANAGEMENT OPERATIONS
CREATE OR REPLACE PACKAGE pkg_lecturer_management 
IS
  PROCEDURE add_new_lecturer(    
    v_first_name    lecturers.first_name%TYPE,
    v_last_name     lecturers.last_name%TYPE,
    v_email         lecturers.email%TYPE,
    v_phone_number  lecturers.phone_number%TYPE
    );

  PROCEDURE delete_lecturer_record(v_lecturer_id lecturers.lecturer_id%TYPE);

  FUNCTION get_lecturer_info(v_lecturer_id lecturers.lecturer_id%TYPE) RETURN VARCHAR2;
END pkg_lecturer_management;
/

CREATE OR REPLACE PACKAGE BODY pkg_lecturer_management 
IS
  -- PROCEDURE TO ADD A NEW LECTURER RECORD
  PROCEDURE add_new_lecturer(    
    v_first_name    lecturers.first_name%TYPE,
    v_last_name     lecturers.last_name%TYPE,
    v_email         lecturers.email%TYPE,
    v_phone_number  lecturers.phone_number%TYPE
  )
  IS

  BEGIN
    INSERT INTO 
    lecturers (first_name, last_name, email, phone_number)
    VALUES 
    (v_first_name, v_last_name, v_email, v_phone_number);

    IF SQL%ROWCOUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Lecturer can''t be added, please try again.');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Lecturer added successfully.');
    END IF;

  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      DBMS_OUTPUT.PUT_LINE('Error: A lecturer with this phone number already exists.');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error occurred. SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
  END add_new_lecturer;


  -- PROCEDURE TO DELETE A LECTURER RECORD BY LECTURER ID
  PROCEDURE delete_lecturer_record(v_lecturer_id lecturers.lecturer_id%TYPE)
  IS

  BEGIN
    DELETE FROM lecturers WHERE lecturer_id = v_lecturer_id;

    IF SQL%ROWCOUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Lecturer not found.');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Lecturer deleted successfully.');
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error occurred. SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
  END delete_lecturer_record;


  -- FUNCTION TO RETRIEVE LECTURER INFORMATION BY LECTURER ID
  FUNCTION get_lecturer_info(v_lecturer_id lecturers.lecturer_id%TYPE)
  RETURN VARCHAR2
  IS
    v_first_name    lecturers.first_name%TYPE;
    v_last_name     lecturers.last_name%TYPE;
    v_email         lecturers.email%TYPE;
    v_phone_number  lecturers.phone_number%TYPE;
    v_output        VARCHAR2(500);

  BEGIN
    SELECT first_name, last_name, email, phone_number
    INTO v_first_name, v_last_name, v_email, v_phone_number
    FROM lecturers
    WHERE lecturer_id = v_lecturer_id;

    v_output := 'Lecturer ID: ' || v_lecturer_id || ', ' ||
                'First Name: ' || v_first_name || ', ' ||
                'Last Name: ' || v_last_name || ', ' ||
                'Email: ' || v_email || ', ' ||
                'Phone Number: ' || v_phone_number;

    RETURN v_output;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 'Lecturer not found.';
    WHEN OTHERS THEN
      RETURN 'Error occurred. SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM;
  END get_lecturer_info;
END pkg_lecturer_management;
/

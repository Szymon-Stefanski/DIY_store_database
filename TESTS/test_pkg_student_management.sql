-- TESTS FOR STUDENT MANAGEMENT OPERATIONS
CREATE OR REPLACE PACKAGE test_pkg_student_management IS
  --%suite
  
  --%test test_add_student_success
  PROCEDURE test_add_student_success;

  --%test test_delete_student_success
  PROCEDURE test_delete_student_success;

  --%test test_update_student_success
  PROCEDURE test_update_student_success;

  --%test test_get_student_info_success
  PROCEDURE test_get_student_info_success;
END test_pkg_student_management;
/

CREATE OR REPLACE PACKAGE BODY test_pkg_student_management IS
  -- TEST TO ADD A NEW STUDENT RECORD
  PROCEDURE test_add_student_success IS
    v_student_count_before NUMBER;
    v_student_count_after NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_student_count_before FROM NEO.students;

    NEO.pkg_student_management.add_new_student(
      v_first_name => 'John',
      v_last_name => 'Doe',
      v_email => 'john.doe@example.com',
      v_city => 'SampleCity',
      v_street => 'SampleStreet',
      v_home_number => '12',
      v_postal_code => '12-345',
      v_phone_number => '123456789',
      v_pesel => '90010112345'
    );

    SELECT COUNT(*) INTO v_student_count_after FROM NEO.students;
    ut.expect(v_student_count_after).to_equal(v_student_count_before + 1);

    DECLARE
      v_first_name NEO.students.first_name%TYPE;
      v_last_name NEO.students.last_name%TYPE;
    BEGIN
      SELECT first_name, last_name
      INTO v_first_name, v_last_name
      FROM NEO.students
      WHERE phone_number = '123456789' AND pesel = '90010112345';

      ut.expect(v_first_name).to_equal('John');
      ut.expect(v_last_name).to_equal('Doe');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ut.fail('Failed to find the inserted student record');
    END;

    DELETE FROM NEO.students WHERE phone_number = '123456789' AND pesel = '90010112345';
    ROLLBACK;
  END test_add_student_success;

  -- TEST TO DELETE A STUDENT RECORD
  PROCEDURE test_delete_student_success IS
    v_student_count_before NUMBER;
    v_student_count_after NUMBER;
    v_student_id NEO.students.student_id%TYPE;
  BEGIN
    SELECT COUNT(*) INTO v_student_count_before FROM NEO.students;

    NEO.pkg_student_management.add_new_student(
      v_first_name => 'John',
      v_last_name => 'Doe',
      v_email => 'john.doe@example.com',
      v_city => 'SampleCity',
      v_street => 'SampleStreet',
      v_home_number => '12',
      v_postal_code => '12-345',
      v_phone_number => '123456789',
      v_pesel => '90010112345'
    );

    SELECT student_id 
    INTO v_student_id 
    FROM NEO.students 
    WHERE phone_number = '123456789' AND pesel = '90010112345';

    SELECT COUNT(*) INTO v_student_count_after FROM NEO.students;
    ut.expect(v_student_count_after).to_equal(v_student_count_before + 1);

    NEO.pkg_student_management.delete_student_record(v_student_id);

    SELECT COUNT(*) INTO v_student_count_after FROM NEO.students;
    ut.expect(v_student_count_after).to_equal(v_student_count_before);

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      ut.fail('Failed to find a student record with this id');
  END test_delete_student_success;

  -- TEST TO UPDATE A STUDENT ADDRESS
  PROCEDURE test_update_student_success IS
    v_student_count_before NUMBER;
    v_student_count_after NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_student_count_before FROM NEO.students;

    NEO.pkg_student_management.add_new_student(
      v_first_name => 'John',
      v_last_name => 'Doe',
      v_email => 'john.doe@example.com',
      v_city => 'SampleCity',
      v_street => 'SampleStreet',
      v_home_number => '12',
      v_postal_code => '12-345',
      v_phone_number => '123456789',
      v_pesel => '90010112345'
    );

    UPDATE NEO.students 
    SET city = 'test_city',
        street = 'test_street',
        home_number = '123',
        postal_code = '12-345'
    WHERE phone_number = '123456789' AND pesel = '90010112345';

    SELECT COUNT(*) INTO v_student_count_after FROM NEO.students;
    ut.expect(v_student_count_after).to_equal(v_student_count_before + 1);

    DECLARE
      v_city NEO.students.city%TYPE;
      v_street NEO.students.street%TYPE;
      v_home_number NEO.students.home_number%TYPE;
      v_postal_code NEO.students.postal_code%TYPE;
    BEGIN
      SELECT city, street, home_number, postal_code
      INTO v_city, v_street, v_home_number, v_postal_code
      FROM NEO.students
      WHERE phone_number = '123456789' AND pesel = '90010112345';

      ut.expect(v_city).to_equal('test_city');
      ut.expect(v_street).to_equal('test_street');
      ut.expect(v_home_number).to_equal('123');
      ut.expect(v_postal_code).to_equal('12-345');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ut.fail('Failed to find the inserted student record');
    END;

    DELETE FROM NEO.students WHERE phone_number = '123456789' AND pesel = '90010112345';
    ROLLBACK;
  END test_update_student_success;

  ---- TEST TO GET AN INFO ABOUT STUDENT
  PROCEDURE test_get_student_info_success IS
    v_student_id    NEO.students.student_id%TYPE;
    v_expected_info VARCHAR2(500);
    v_actual_info   VARCHAR2(500);
  BEGIN
    INSERT INTO NEO.students (first_name, last_name, email, city, street, home_number, postal_code, phone_number, PESEL)
    VALUES ('John', 'Doe', 'john.doe@example.com', 'SampleCity', 'SampleStreet', '12', '12-345', '123456789', '90010112345')
    RETURNING student_id INTO v_student_id;

    v_expected_info := 'Student ID: ' || v_student_id || ', ' ||
                       'First Name: John, ' ||
                       'Last Name: Doe, ' ||
                       'Email: john.doe@example.com, ' ||
                       'City: SampleCity, ' ||
                       'Street: SampleStreet, ' ||
                       'Home Number: 12, ' ||
                       'Postal Code: 12345, ' ||
                       'Phone Number: 123456789, ' ||
                       'PESEL: 90010112345';


    v_actual_info := NEO.pkg_student_management.get_student_info(v_student_id);


    ut.expect(v_actual_info).to_equal(v_expected_info);

    DELETE FROM NEO.students WHERE student_id = v_student_id;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.put_line('Error occurred: ' || SQLERRM);
  END test_get_student_info_success;

END test_pkg_student_management;
/

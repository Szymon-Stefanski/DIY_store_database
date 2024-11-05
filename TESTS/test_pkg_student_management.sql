-- TESTS FOR STUDENT MANAGEMENT OPERATIONS
CREATE OR REPLACE PACKAGE test_pkg_student_management IS
  --%suite
  
  --%test test_add_student_success
  PROCEDURE test_add_student_success;
END test_pkg_student_management;
/

CREATE OR REPLACE PACKAGE BODY test_pkg_student_management IS
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
      v_postal_code => '12345',
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
  END test_add_student_success;
END test_pkg_student_management;
/

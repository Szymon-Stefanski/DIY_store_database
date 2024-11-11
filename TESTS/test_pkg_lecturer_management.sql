-- TESTS FOR LECTURER MANAGEMENT OPERATIONS
CREATE OR REPLACE PACKAGE test_pkg_lecturer_management 
IS
  --%suite

  --%test test_add_lecturer_success
  PROCEDURE test_add_lecturer_success;

  --%test test_delete_lecturer_success
  PROCEDURE test_delete_lecturer_success;

  --%test test_get_lecturer_info_success
  PROCEDURE test_get_lecturer_info_success;
END test_pkg_lecturer_management;
/

CREATE OR REPLACE PACKAGE BODY test_pkg_lecturer_management 
IS
  --TEST TO ADD A NEW LECTURER RECORD
  PROCEDURE test_add_lecturer_success 
  IS
    v_lecturer_count_before NUMBER;
    v_lecturer_count_after NUMBER;
    v_first_name NEO.lecturers.first_name%TYPE;
    v_last_name NEO.lecturers.last_name%TYPE;
  BEGIN
    SELECT COUNT(*) INTO v_lecturer_count_before FROM NEO.lecturers;

    NEO.pkg_lecturer_management.add_new_lecturer(
      v_first_name => 'John',
      v_last_name => 'Doe',
      v_email => 'john.doe@example.com',
      v_phone_number => '123456789'
    );

    SELECT COUNT(*) INTO v_lecturer_count_after FROM NEO.lecturers;
    ut.expect(v_lecturer_count_after).to_equal(v_lecturer_count_before + 1);

    SELECT first_name, last_name
    INTO v_first_name, v_last_name
    FROM NEO.lecturers
    WHERE phone_number = '123456789' AND email = 'john.doe@example.com';

    ut.expect(v_first_name).to_equal('John');
    ut.expect(v_last_name).to_equal('Doe');

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ut.fail('Failed to find the inserted lecturer record');
  END test_add_lecturer_success;

  --TEST TO DELETE A LECTURER RECORD BY ID
  PROCEDURE test_delete_lecturer_success 
  IS
    v_lecturer_count_before NUMBER;
    v_lecturer_count_after NUMBER;
    v_lecturer_id NEO.lecturers.lecturer_id%TYPE;
  BEGIN
    SELECT COUNT(*) INTO v_lecturer_count_before FROM NEO.lecturers;

    NEO.pkg_lecturer_management.add_new_lecturer(
      v_first_name => 'John',
      v_last_name => 'Doe',
      v_email => 'john.doe@example.com',
      v_phone_number => '123456789'
    );

    SELECT lecturer_id 
    INTO v_lecturer_id 
    FROM NEO.lecturers 
    WHERE phone_number = '123456789' AND email = 'john.doe@example.com';

    SELECT COUNT(*) INTO v_lecturer_count_after FROM NEO.lecturers;
    ut.expect(v_lecturer_count_after).to_equal(v_lecturer_count_before + 1);

    NEO.pkg_lecturer_management.delete_lecturer_record(v_lecturer_id);

    SELECT COUNT(*) INTO v_lecturer_count_after FROM NEO.lecturers;
    ut.expect(v_lecturer_count_after).to_equal(v_lecturer_count_before);
    

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      ut.fail('Failed to find a lecturer record with this id');
  END test_delete_lecturer_success;

  --TEST TO RETRIEVE LECTURER INFORMATION
  PROCEDURE test_get_lecturer_info_success 
  IS
    v_lecturer_id    NEO.lecturers.lecturer_id%TYPE;
    v_first_name     VARCHAR2(100) := 'John';
    v_last_name      VARCHAR2(100) := 'Doe';
    v_email          VARCHAR2(100) := 'john.doe@example.com';
    v_phone_number   VARCHAR2(20)  := '123456789';
    v_expected_info  VARCHAR2(500);
    v_actual_info    VARCHAR2(500);

  BEGIN
    INSERT INTO NEO.lecturers (first_name, last_name, email, phone_number)
    VALUES (v_first_name, v_last_name, v_email, v_phone_number)
    RETURNING lecturer_id INTO v_lecturer_id;

    v_expected_info := 'Lecturer ID: ' || v_lecturer_id || ', ' ||
                       'First Name: ' || v_first_name || ', ' ||
                       'Last Name: ' || v_last_name || ', ' ||
                       'Email: ' || v_email || ', ' ||
                       'Phone Number: ' || v_phone_number;

    v_actual_info := NEO.pkg_lecturer_management.get_lecturer_info(v_lecturer_id);

    ut.expect(v_actual_info).to_equal(v_expected_info);

  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.put_line('Error occurred: ' || SQLERRM);
  END test_get_lecturer_info_success;
END test_pkg_lecturer_management;
/

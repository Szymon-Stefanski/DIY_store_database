INSERT INTO FACULTIES (faculty_name) VALUES ('Computer Science');
INSERT INTO FACULTIES (faculty_name) VALUES ('Graphic Design');

INSERT INTO DEPARTMENTS (department_name) VALUES ('Software Engineering');
INSERT INTO DEPARTMENTS (department_name) VALUES ('Data Science');
INSERT INTO DEPARTMENTS (department_name) VALUES ('Visual Communication');
INSERT INTO DEPARTMENTS (department_name) VALUES ('3D Animation');

INSERT INTO FACULTIES_DEPARTMENTS (faculty_id, department_id) VALUES (1, 1);
INSERT INTO FACULTIES_DEPARTMENTS (faculty_id, department_id) VALUES (1, 2);
INSERT INTO FACULTIES_DEPARTMENTS (faculty_id, department_id) VALUES (2, 3);
INSERT INTO FACULTIES_DEPARTMENTS (faculty_id, department_id) VALUES (2, 4);

INSERT INTO COURSES (course_name) VALUES ('Introduction to Programming');
INSERT INTO COURSES (course_name) VALUES ('Data Structures and Algorithms');
INSERT INTO COURSES (course_name) VALUES ('Web Design');
INSERT INTO COURSES (course_name) VALUES ('Digital Illustration');

INSERT INTO DEPARTMENTS_COURSES (department_id, course_id) VALUES (1, 1);
INSERT INTO DEPARTMENTS_COURSES (department_id, course_id) VALUES (2, 2);
INSERT INTO DEPARTMENTS_COURSES (department_id, course_id) VALUES (3, 3);
INSERT INTO DEPARTMENTS_COURSES (department_id, course_id) VALUES (4, 4);

INSERT INTO GROUPS (group_name, term) VALUES ('CS_term_1', 1);
INSERT INTO GROUPS (group_name, term) VALUES ('CS_term_2', 2);
INSERT INTO GROUPS (group_name, term) VALUES ('GD_term_1', 1);
INSERT INTO GROUPS (group_name, term) VALUES ('GD_term_2', 2);

INSERT INTO LECTURERS (first_name, last_name, email, phone_number)
VALUES ('Adam', 'Kowalski', 'adam.kowalski@example.com', '500100100');
INSERT INTO LECTURERS (first_name, last_name, email, phone_number)
VALUES ('Ewa', 'Nowak', 'ewa.nowak@example.com', '500100101');
INSERT INTO LECTURERS (first_name, last_name, email, phone_number)
VALUES ('Piotr', 'Zielinski', 'piotr.zielinski@example.com', '500100102');
INSERT INTO LECTURERS (first_name, last_name, email, phone_number)
VALUES ('Marek', 'Wojcik', 'marek.wojcik@example.com', '500100103');

INSERT INTO BUILDINGS (street, building_number, postal_code)
VALUES ('University Ave', '10', '01-001');
INSERT INTO BUILDINGS (street, building_number, postal_code)
VALUES ('Main St', '20', '01-002');

INSERT INTO ROOMS (building_id, capacity) VALUES (1, 30);
INSERT INTO ROOMS (building_id, capacity) VALUES (1, 25);
INSERT INTO ROOMS (building_id, capacity) VALUES (2, 30);
INSERT INTO ROOMS (building_id, capacity) VALUES (2, 25);

INSERT INTO STUDENTS (first_name, last_name, email, city, street, home_number, postal_code, phone_number, PESEL)
VALUES ('Anna', 'Kowalska', 'anna.kowalska@example.com', 'Warsaw', 'Main St', '1', '00-001', '511111111', '99010112345');
INSERT INTO STUDENTS (first_name, last_name, email, city, street, home_number, postal_code, phone_number, PESEL)
VALUES ('Jan', 'Nowak', 'jan.nowak@example.com', 'Cracow', 'Elm St', '12', '30-001', '511111112', '99020223456');
INSERT INTO STUDENTS (first_name, last_name, email, city, street, home_number, postal_code, phone_number, PESEL)
VALUES ('Piotr', 'Zielinski', 'piotr.zielinski@example.com', 'Lodz', 'Pine St', '3', '90-002', '511111113', '99030334567');
INSERT INTO STUDENTS (first_name, last_name, email, city, street, home_number, postal_code, phone_number, PESEL)
VALUES ('Kasia', 'Wojcik', 'kasia.wojcik@example.com', 'Gdansk', 'Maple St', '4', '80-003', '511111114', '99040445678');
INSERT INTO STUDENTS (first_name, last_name, email, city, street, home_number, postal_code, phone_number, PESEL)
VALUES ('Marek', 'Kowalski', 'marek.kowalski@example.com', 'Poznan', 'Oak St', '5', '60-004', '511111115', '99050556789');
INSERT INTO STUDENTS (first_name, last_name, email, city, street, home_number, postal_code, phone_number, PESEL)
VALUES ('Ola', 'Nowak', 'ola.nowak@example.com', 'Lublin', 'Birch St', '6', '20-005', '511111116', '99060667890');
INSERT INTO STUDENTS (first_name, last_name, email, city, street, home_number, postal_code, phone_number, PESEL)
VALUES ('Bartek', 'Zielinski', 'bartek.zielinski@example.com', 'Warsaw', 'Spruce St', '7', '00-006', '511111117', '99070778901');
INSERT INTO STUDENTS (first_name, last_name, email, city, street, home_number, postal_code, phone_number, PESEL)
VALUES ('Magda', 'Wojcik', 'magda.wojcik@example.com', 'Cracow', 'Ash St', '8', '30-007', '511111118', '99080889012');
INSERT INTO STUDENTS (first_name, last_name, email, city, street, home_number, postal_code, phone_number, PESEL)
VALUES ('Robert', 'Kowalski', 'robert.kowalski@example.com', 'Lodz', 'Elm St', '9', '90-008', '511111119', '99090990123');
INSERT INTO STUDENTS (first_name, last_name, email, city, street, home_number, postal_code, phone_number, PESEL)
VALUES ('Emilia', 'Nowak', 'emilia.nowak@example.com', 'Gdansk', 'Maple St', '10', '80-009', '511111120', '99101001234');

INSERT INTO STUDENTS_GROUPS (student_id, group_id) VALUES (1, 1);
INSERT INTO STUDENTS_GROUPS (student_id, group_id) VALUES (2, 2);
INSERT INTO STUDENTS_GROUPS (student_id, group_id) VALUES (3, 1);
INSERT INTO STUDENTS_GROUPS (student_id, group_id) VALUES (4, 3);
INSERT INTO STUDENTS_GROUPS (student_id, group_id) VALUES (5, 2);
INSERT INTO STUDENTS_GROUPS (student_id, group_id) VALUES (6, 4);
INSERT INTO STUDENTS_GROUPS (student_id, group_id) VALUES (7, 1);
INSERT INTO STUDENTS_GROUPS (student_id, group_id) VALUES (8, 3);
INSERT INTO STUDENTS_GROUPS (student_id, group_id) VALUES (9, 3);
INSERT INTO STUDENTS_GROUPS (student_id, group_id) VALUES (10, 2);

INSERT INTO LECTURERS_GROUPS (lecturer_id, group_id) VALUES (1, 1);
INSERT INTO LECTURERS_GROUPS (lecturer_id, group_id) VALUES (2, 2);
INSERT INTO LECTURERS_GROUPS (lecturer_id, group_id) VALUES (3, 3);
INSERT INTO LECTURERS_GROUPS (lecturer_id, group_id) VALUES (4, 4);

INSERT INTO SCHEDULES (start_time, end_time, course_id, group_id, room_id, lecturer_id, schedule_date, duration) 
VALUES (TIMESTAMP '2024-10-19 09:00:00', TIMESTAMP '2024-10-19 13:00:00', 1, 1, 1, 1, TIMESTAMP '2024-10-19 00:00:00', 240);
INSERT INTO SCHEDULES (start_time, end_time, course_id, group_id, room_id, lecturer_id, schedule_date, duration) 
VALUES (TIMESTAMP '2024-10-19 14:00:00', TIMESTAMP '2024-10-19 18:00:00', 2, 1, 2, 2, TIMESTAMP '2024-10-19 00:00:00', 240);
INSERT INTO SCHEDULES (start_time, end_time, course_id, group_id, room_id, lecturer_id, schedule_date, duration) 
VALUES (TIMESTAMP '2024-10-26 09:00:00', TIMESTAMP '2024-10-26 13:00:00', 3, 2, 3, 3, TIMESTAMP '2024-10-26 00:00:00', 240);
INSERT INTO SCHEDULES (start_time, end_time, course_id, group_id, room_id, lecturer_id, schedule_date, duration) 
VALUES (TIMESTAMP '2024-10-26 14:00:00', TIMESTAMP '2024-10-26 18:00:00', 4, 2, 4, 4, TIMESTAMP '2024-10-26 00:00:00', 240);

INSERT INTO EXAMS (course_id, group_id, exam_date, room_id) 
VALUES (1, 1, TIMESTAMP '2024-10-13 10:00:00', 1);
INSERT INTO EXAMS (course_id, group_id, exam_date, room_id) 
VALUES (2, 1, TIMESTAMP '2025-01-16 10:00:00', 2);
INSERT INTO EXAMS (course_id, group_id, exam_date, room_id) 
VALUES (3, 2, TIMESTAMP '2025-01-22 10:00:00', 3);
INSERT INTO EXAMS (course_id, group_id, exam_date, room_id) 
VALUES (4, 2, TIMESTAMP '2025-01-23 10:00:00', 4);

INSERT INTO ATTENDANCES (student_id, schedule_id, status) VALUES (1, 1, '1');
INSERT INTO ATTENDANCES (student_id, schedule_id, status) VALUES (2, 1, '0');
INSERT INTO ATTENDANCES (student_id, schedule_id, status) VALUES (3, 2, '1');
INSERT INTO ATTENDANCES (student_id, schedule_id, status) VALUES (4, 2, '1');
INSERT INTO ATTENDANCES (student_id, schedule_id, status) VALUES (5, 1, '0');
INSERT INTO ATTENDANCES (student_id, schedule_id, status) VALUES (6, 1, '1');
INSERT INTO ATTENDANCES (student_id, schedule_id, status) VALUES (7, 2, '0');
INSERT INTO ATTENDANCES (student_id, schedule_id, status) VALUES (8, 2, '1');
INSERT INTO ATTENDANCES (student_id, schedule_id, status) VALUES (9, 1, '1');
INSERT INTO ATTENDANCES (student_id, schedule_id, status) VALUES (10, 1, '0');

INSERT INTO GRADES (student_id, course_id, exam_id, grade) VALUES (1, 1, 1, 4.5);
INSERT INTO GRADES (student_id, course_id, exam_id, grade) VALUES (2, 1, 1, 3.5);
INSERT INTO GRADES (student_id, course_id, exam_id, grade) VALUES (3, 1, 1, 5.0);
INSERT INTO GRADES (student_id, course_id, exam_id, grade) VALUES (4, 1, 1, 4.0);
INSERT INTO GRADES (student_id, course_id, exam_id, grade) VALUES (5, 1, 1, 3.5);
INSERT INTO GRADES (student_id, course_id, exam_id, grade) VALUES (6, 1, 1, 4.0);
INSERT INTO GRADES (student_id, course_id, exam_id, grade) VALUES (7, 1, 1, 3.0);
INSERT INTO GRADES (student_id, course_id, exam_id, grade) VALUES (8, 1, 1, 3.5);
INSERT INTO GRADES (student_id, course_id, exam_id, grade) VALUES (9, 1, 1, 4.0);
INSERT INTO GRADES (student_id, course_id, exam_id, grade) VALUES (10, 1, 1, 4.0);
/

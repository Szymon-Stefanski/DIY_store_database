CREATE TABLE STUDENTS (
    student_id NUMBER(6) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR2(15) NOT NULL,
    last_name VARCHAR2(30) NOT NULL,
    email VARCHAR2(50) UNIQUE NOT NULL,
    city VARCHAR2(20) NOT NULL,
    street VARCHAR2(20) NOT NULL,
    home_number VARCHAR2(4) NOT NULL,
    postal_code VARCHAR2(6) NOT NULL,
    phone_number VARCHAR2(12) UNIQUE NOT NULL,
    PESEL VARCHAR2(11) UNIQUE NOT NULL,
    CONSTRAINT CK_STUDENTS_EMAIL_FORMAT CHECK (email LIKE '%@%.%'),
    CONSTRAINT CK_STUDENTS_PHONE_FORMAT CHECK (REGEXP_LIKE(phone_number, '^[0-9]+$')),
    CONSTRAINT CK_STUDENTS_PESEL_FORMAT CHECK (REGEXP_LIKE(PESEL, '^[0-9]{11}$')),
    CONSTRAINT CK_STUDENTS_POSTAL_CODE_FORMAT CHECK (REGEXP_LIKE(postal_code, '^[0-9]{2}-[0-9]{3}$'))
);

CREATE TABLE GROUPS (
    group_id NUMBER(2) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    group_name VARCHAR2(20) UNIQUE NOT NULL,
    term NUMBER(1) NOT NULL,
    CONSTRAINT CK_GROUPS_TERM CHECK (term BETWEEN 1 AND 10)
);

CREATE TABLE LECTURERS (
    lecturer_id NUMBER(2) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR2(15) NOT NULL,
    last_name VARCHAR2(30) NOT NULL,
    email VARCHAR2(50) UNIQUE NOT NULL,
    phone_number VARCHAR2(12) UNIQUE NOT NULL,
    CONSTRAINT CK_LECTURERS_EMAIL_FORMAT CHECK (email LIKE '%@%.%'),
    CONSTRAINT CK_LECTURERS_PHONE_FORMAT CHECK (REGEXP_LIKE(phone_number, '^[0-9]+$'))
);

CREATE TABLE STUDENTS_GROUPS (
    group_id NUMBER(2),
    student_id NUMBER(6),
    PRIMARY KEY (group_id, student_id),
    FOREIGN KEY (group_id) REFERENCES GROUPS(group_id),
    FOREIGN KEY (student_id) REFERENCES STUDENTS(student_id)
);

CREATE TABLE LECTURERS_GROUPS (
    lecturer_id NUMBER(2),
    group_id NUMBER(2),
    PRIMARY KEY (lecturer_id, group_id),
    FOREIGN KEY (lecturer_id) REFERENCES LECTURERS(lecturer_id),
    FOREIGN KEY (group_id) REFERENCES GROUPS(group_id)
);

CREATE TABLE COURSES (
    course_id NUMBER(2) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    course_name VARCHAR2(100) NOT NULL
);

CREATE TABLE BUILDINGS (
    building_id NUMBER(1) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    street VARCHAR2(20) NOT NULL,
    building_number VARCHAR2(3) UNIQUE NOT NULL,
    postal_code VARCHAR2(6) NOT NULL,
    CONSTRAINT CK_BUILDINGS_POSTAL_CODE CHECK (REGEXP_LIKE(postal_code, '^[0-9]{2}-[0-9]{3}$'))
);

CREATE TABLE ROOMS (
    room_id NUMBER(2) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    building_id NUMBER(1) NOT NULL,
    capacity NUMBER(3) NOT NULL,
    CONSTRAINT CK_ROOMS_CAPACITY CHECK (capacity BETWEEN 1 AND 500),
    FOREIGN KEY (building_id) REFERENCES BUILDINGS(building_id)
);

CREATE TABLE EXAMS (
    exam_id NUMBER(6) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    course_id NUMBER(2) NOT NULL,
    group_id NUMBER(2) NOT NULL,
    exam_date TIMESTAMP NOT NULL,
    room_id NUMBER(2) NOT NULL,
    CONSTRAINT CK_EXAMS_DATE CHECK (exam_date >= TIMESTAMP '2024-10-12 00:00:00'),
    FOREIGN KEY (course_id) REFERENCES COURSES(course_id),
    FOREIGN KEY (group_id) REFERENCES GROUPS(group_id),
    FOREIGN KEY (room_id) REFERENCES ROOMS(room_id)
);

CREATE TABLE DEPARTMENTS (
    department_id NUMBER(1) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_name VARCHAR2(50) UNIQUE NOT NULL
);

CREATE TABLE DEPARTMENTS_COURSES (
    department_id NUMBER(1),
    course_id NUMBER(2),
    PRIMARY KEY (department_id, course_id),
    FOREIGN KEY (department_id) REFERENCES DEPARTMENTS(department_id),
    FOREIGN KEY (course_id) REFERENCES COURSES(course_id)
);

CREATE TABLE FACULTIES (
    faculty_id NUMBER(1) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    faculty_name VARCHAR2(50) UNIQUE NOT NULL
);

CREATE TABLE FACULTIES_DEPARTMENTS (
    faculty_id NUMBER(1),
    department_id NUMBER(1),
    PRIMARY KEY (faculty_id, department_id),
    FOREIGN KEY (faculty_id) REFERENCES FACULTIES(faculty_id),
    FOREIGN KEY (department_id) REFERENCES DEPARTMENTS(department_id)
);

CREATE TABLE SCHEDULES (
    schedule_id NUMBER(6) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    course_id NUMBER(2) NOT NULL,
    group_id NUMBER(2) NOT NULL,
    room_id NUMBER(2) NOT NULL,
    lecturer_id NUMBER(2) NOT NULL,
    schedule_date TIMESTAMP NOT NULL,
    duration NUMBER(3) NOT NULL,
    CONSTRAINT CK_SCHEDULES_TIMES CHECK (end_time > start_time),
    FOREIGN KEY (course_id) REFERENCES COURSES(course_id),
    FOREIGN KEY (group_id) REFERENCES GROUPS(group_id),
    FOREIGN KEY (room_id) REFERENCES ROOMS(room_id),
    FOREIGN KEY (lecturer_id) REFERENCES LECTURERS(lecturer_id)
);

CREATE TABLE ATTENDANCES (
    attendance_id NUMBER(6) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_id NUMBER(6) NOT NULL,
    schedule_id NUMBER(6) NOT NULL,
    status CHAR(1) NOT NULL,
    CONSTRAINT CK_ATTENDANCES_STATUS CHECK (status IN ('0', '1')),
    FOREIGN KEY (student_id) REFERENCES STUDENTS(student_id),
    FOREIGN KEY (schedule_id) REFERENCES SCHEDULES(schedule_id)
);

CREATE TABLE GRADES (
    grade_id NUMBER(6) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    course_id NUMBER(2) NOT NULL,
    exam_id NUMBER(6) NOT NULL,
    grade NUMBER(5,2) NOT NULL,
    CONSTRAINT CK_GRADES_VALUE CHECK (grade BETWEEN 2.0 AND 5.0),
    FOREIGN KEY (course_id) REFERENCES COURSES(course_id) ON DELETE CASCADE,
    FOREIGN KEY (exam_id) REFERENCES EXAMS(exam_id) ON DELETE CASCADE
);

CREATE TABLE STUDENTS_GRADES (
    student_id NUMBER(6),
    grade_id NUMBER(6),
    PRIMARY KEY (lecturer_id, group_id),
    FOREIGN KEY (student_id) REFERENCES STUDENTS(student_id) ON DELETE CASCADE,
    FOREIGN KEY (grade_id) REFERENCES GRADES(grade_id) ON DELETE CASCADE,
);
/

CREATE INDEX idx_courses_name ON COURSES(course_name);


CREATE INDEX idx_exams_course ON EXAMS(course_id);
CREATE INDEX idx_exams_date ON EXAMS(exam_date);
CREATE INDEX idx_exams_group ON EXAMS(group_id);
CREATE INDEX idx_exams_course_group ON EXAMS(course_id, group_id);


CREATE INDEX idx_schedules_start_time ON SCHEDULES(start_time);
CREATE INDEX idx_schedules_end_time ON SCHEDULES(end_time);
CREATE INDEX idx_schedules_course ON SCHEDULES(course_id);
CREATE INDEX idx_schedules_group ON SCHEDULES(group_id);
CREATE INDEX idx_schedules_room ON SCHEDULES(room_id);
CREATE INDEX idx_schedules_lecturer ON SCHEDULES(lecturer_id);
CREATE INDEX idx_schedules_course_group ON SCHEDULES(course_id, group_id);


CREATE INDEX idx_rooms_building ON ROOMS(building_id);


CREATE INDEX idx_attendances_status ON ATTENDANCES(status);
CREATE INDEX idx_attendances_student ON ATTENDANCES(student_id);
CREATE INDEX idx_attendances_schedule ON ATTENDANCES(schedule_id);


CREATE INDEX idx_students_groups_student ON STUDENTS_GROUPS(student_id);
CREATE INDEX idx_students_groups_group ON STUDENTS_GROUPS(group_id);


CREATE INDEX idx_lecturers_groups_lecturer ON LECTURERS_GROUPS(lecturer_id);
CREATE INDEX idx_lecturers_groups_group ON LECTURERS_GROUPS(group_id);


CREATE INDEX idx_faculties_departments_department ON FACULTIES_DEPARTMENTS(faculty_id);
CREATE INDEX idx_faculties_departments_faculty ON FACULTIES_DEPARTMENTS(department_id);


CREATE INDEX idx_departments_courses_department ON DEPARTMENTS_COURSES(department_id);
CREATE INDEX idx_departments_courses_course ON DEPARTMENTS_COURSES(course_id);


CREATE INDEX idx_grades_course ON GRADES(course_id);


CREATE INDEX idx_students_grades_student ON STUDENTS_GRADES(student_id);
CREATE INDEX idx_students_grades_grade ON STUDENTS_GRADES(grade_id);
/



COMMENT ON TABLE STUDENTS IS 'Table storing student information including personal details and contact data.';
COMMENT ON COLUMN STUDENTS.student_id IS 'Unique identifier for each student.';
COMMENT ON COLUMN STUDENTS.first_name IS 'First name of the student.';
COMMENT ON COLUMN STUDENTS.last_name IS 'Last name of the student.';
COMMENT ON COLUMN STUDENTS.email IS 'Email address of the student, must be unique.';
COMMENT ON COLUMN STUDENTS.city IS 'City of the student''s residence.';
COMMENT ON COLUMN STUDENTS.street IS 'Street of the student''s residence.';
COMMENT ON COLUMN STUDENTS.home_number IS 'Home number of the student''s residence.';
COMMENT ON COLUMN STUDENTS.postal_code IS 'Postal code of the student''s residence.';
COMMENT ON COLUMN STUDENTS.phone_number IS 'Phone number of the student, must be unique.';
COMMENT ON COLUMN STUDENTS.PESEL IS 'Unique PESEL number for each student.';


COMMENT ON TABLE GROUPS IS 'Table storing information about student groups.';
COMMENT ON COLUMN GROUPS.group_id IS 'Unique identifier for each group.';
COMMENT ON COLUMN GROUPS.group_name IS 'Name of the group.';
COMMENT ON COLUMN GROUPS.term IS 'Term number of the group, must be between 1 and 10.';


COMMENT ON TABLE LECTURERS IS 'Table storing lecturer information including personal details and contact data.';
COMMENT ON COLUMN LECTURERS.lecturer_id IS 'Unique identifier for each lecturer.';
COMMENT ON COLUMN LECTURERS.first_name IS 'First name of the lecturer.';
COMMENT ON COLUMN LECTURERS.last_name IS 'Last name of the lecturer.';
COMMENT ON COLUMN LECTURERS.email IS 'Email address of the lecturer, must be unique.';
COMMENT ON COLUMN LECTURERS.phone_number IS 'Phone number of the lecturer, must be unique.';


COMMENT ON TABLE STUDENTS_GROUPS IS 'Associative table mapping students to their respective groups.';
COMMENT ON COLUMN STUDENTS_GROUPS.group_id IS 'Identifier for the group the student belongs to.';
COMMENT ON COLUMN STUDENTS_GROUPS.student_id IS 'Identifier for the student belonging to a group.';


COMMENT ON TABLE LECTURERS_GROUPS IS 'Associative table mapping lecturers to the groups they teach.';
COMMENT ON COLUMN LECTURERS_GROUPS.lecturer_id IS 'Identifier for the lecturer assigned to a group.';
COMMENT ON COLUMN LECTURERS_GROUPS.group_id IS 'Identifier for the group assigned to a lecturer.';


COMMENT ON TABLE COURSES IS 'Table storing information about courses.';
COMMENT ON COLUMN COURSES.course_id IS 'Unique identifier for each course.';
COMMENT ON COLUMN COURSES.course_name IS 'Name of the course, must be unique.';


COMMENT ON TABLE BUILDINGS IS 'Table storing building information.';
COMMENT ON COLUMN BUILDINGS.building_id IS 'Unique identifier for each building.';
COMMENT ON COLUMN BUILDINGS.street IS 'Street where the building is located.';
COMMENT ON COLUMN BUILDINGS.building_number IS 'Number of the building, must be unique.';
COMMENT ON COLUMN BUILDINGS.postal_code IS 'Postal code of the building location.';


COMMENT ON TABLE ROOMS IS 'Table storing information about rooms in buildings.';
COMMENT ON COLUMN ROOMS.room_id IS 'Unique identifier for each room.';
COMMENT ON COLUMN ROOMS.building_id IS 'Identifier for the building where the room is located.';
COMMENT ON COLUMN ROOMS.capacity IS 'Maximum capacity of the room, must be between 1 and 500.';


COMMENT ON TABLE EXAMS IS 'Table storing information about exams.';
COMMENT ON COLUMN EXAMS.exam_id IS 'Unique identifier for each exam.';
COMMENT ON COLUMN EXAMS.course_id IS 'Identifier for the course related to the exam.';
COMMENT ON COLUMN EXAMS.group_id IS 'Identifier for the group taking the exam.';
COMMENT ON COLUMN EXAMS.exam_date IS 'Date and time of the exam.';
COMMENT ON COLUMN EXAMS.room_id IS 'Identifier for the room where the exam is held.';


COMMENT ON TABLE DEPARTMENTS IS 'Table storing department information.';
COMMENT ON COLUMN DEPARTMENTS.department_id IS 'Unique identifier for each department.';
COMMENT ON COLUMN DEPARTMENTS.department_name IS 'Name of the department, must be unique.';


COMMENT ON TABLE FACULTIES IS 'Table storing faculty information.';
COMMENT ON COLUMN FACULTIES.faculty_id IS 'Unique identifier for each faculty.';
COMMENT ON COLUMN FACULTIES.faculty_name IS 'Name of the faculty, must be unique.';


COMMENT ON TABLE FACULTIES_DEPARTMENTS IS 'Associative table linking faculties to departments.';
COMMENT ON COLUMN FACULTIES_DEPARTMENTS.faculty_id IS 'Identifier for the faculty in the relation.';
COMMENT ON COLUMN FACULTIES_DEPARTMENTS.department_id IS 'Identifier for the department in the relation.';


COMMENT ON TABLE DEPARTMENTS_COURSES IS 'Associative table linking departments to courses.';
COMMENT ON COLUMN DEPARTMENTS_COURSES.department_id IS 'Identifier for the department in the relation.';
COMMENT ON COLUMN DEPARTMENTS_COURSES.course_id IS 'Identifier for the course in the relation.';


COMMENT ON TABLE SCHEDULES IS 'Table storing class schedules.';
COMMENT ON COLUMN SCHEDULES.schedule_id IS 'Unique identifier for each schedule.';
COMMENT ON COLUMN SCHEDULES.start_time IS 'Starting time of the scheduled class.';
COMMENT ON COLUMN SCHEDULES.end_time IS 'Ending time of the scheduled class.';
COMMENT ON COLUMN SCHEDULES.course_id IS 'Identifier for the course associated with the schedule.';
COMMENT ON COLUMN SCHEDULES.group_id IS 'Identifier for the group attending the scheduled class.';
COMMENT ON COLUMN SCHEDULES.room_id IS 'Identifier for the room where the class is held.';
COMMENT ON COLUMN SCHEDULES.lecturer_id IS 'Identifier for the lecturer conducting the class.';
COMMENT ON COLUMN SCHEDULES.schedule_date IS 'Date of the scheduled class.';
COMMENT ON COLUMN SCHEDULES.duration IS 'Duration of the scheduled class in minutes.';


COMMENT ON TABLE ATTENDANCES IS 'Table storing attendance records for students.';
COMMENT ON COLUMN ATTENDANCES.attendance_id IS 'Unique identifier for each attendance record.';
COMMENT ON COLUMN ATTENDANCES.student_id IS 'Identifier for the student marked for attendance.';
COMMENT ON COLUMN ATTENDANCES.schedule_id IS 'Identifier for the schedule related to the attendance.';
COMMENT ON COLUMN ATTENDANCES.status IS 'Attendance status (0 for absent, 1 for present).';


COMMENT ON TABLE GRADES IS 'Table storing information about students'' grades for courses.';
COMMENT ON COLUMN GRADES.grade_id IS 'Unique identifier for each grade record.';
COMMENT ON COLUMN GRADES.student_id IS 'Identifier for the student who received the grade.';
COMMENT ON COLUMN GRADES.course_id IS 'Identifier for the course associated with the grade.';
COMMENT ON COLUMN GRADES.exam_id IS 'Identifier for the exam related to the grade, if applicable.';
COMMENT ON COLUMN GRADES.grade IS 'The grade a student receives';


COMMENT ON TABLE GRADES IS 'Table storing information about students'' grades for courses.';
COMMENT ON COLUMN GRADES.grade_id IS 'Unique identifier for each grade record.';
COMMENT ON COLUMN GRADES.course_id IS 'Identifier for the course associated with the grade.';
COMMENT ON COLUMN GRADES.exam_id IS 'Identifier for the exam related to the grade, if applicable.';
COMMENT ON COLUMN GRADES.grade IS 'The grade a student receives';


COMMENT ON TABLE STUDENTS_GRADES IS 'Table storing associations between students and grades.';
COMMENT ON COLUMN STUDENTS_GRADES.student_id IS 'Identifier for the student who received the grade.';
COMMENT ON COLUMN STUDENTS_GRADES.grade_id IS 'Unique identifier for each grade record.';
/

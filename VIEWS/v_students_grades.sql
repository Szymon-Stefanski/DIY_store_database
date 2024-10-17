/*This view effectively combines student and course data with their grades, 
providing a clear picture of student performance.*/
CREATE OR REPLACE VIEW v_students_grades AS
SELECT  s.student_id AS "Student id",
        s.first_name AS "Student name",
        s.last_name AS "Student surname",
        c.course_name AS "Course name",
        g.grade AS "Grade"
FROM students s
INNER JOIN grades g ON g.student_id = s.student_id
INNER JOIN courses c ON c.course_id = g.course_id;

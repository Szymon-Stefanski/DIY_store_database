/*This view retrieves information about exams that students have failed*/
CREATE OR REPLACE VIEW v_failed_exams AS
SELECT  s.student_id AS "Student id",
        g.grade_id AS "Grade id",
        g.grade AS "Grade",
        g.exam_id AS "Exam id"
FROM grades g
INNER JOIN students s ON s.student_id = g.student_id
WHERE grade < 3.0;

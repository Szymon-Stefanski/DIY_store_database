/*This view is created to show the number of attempts and the last grade 
for each student per course.*/
CREATE OR REPLACE VIEW v_student_exam_attempts AS
SELECT s.student_id AS "Student id",
       e.course_id AS "Course id",
       COUNT(e.exam_id) AS "Exam attempts",
       MAX(g.grade) AS "Last grade"
FROM students s
INNER JOIN grades g ON g.student_id = s.student_id
INNER JOIN exams e ON e.exam_id = g.exam_id
WHERE g.exam_id IN (
    SELECT MAX(exam_id)
    FROM grades g2
    WHERE g2.student_id = s.student_id AND g2.course_id = e.course_id
)
GROUP BY s.student_id, e.course_id;

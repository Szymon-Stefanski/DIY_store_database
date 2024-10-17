/*This view correctly identifies students with the highest average grades 
per course.*/
CREATE OR REPLACE VIEW v_students_best_grades AS
WITH avg_grades AS (
    SELECT s.student_id,
           s.first_name,
           s.last_name,
           c.course_name,
           AVG(g.grade) AS avg_grade
    FROM students s
    INNER JOIN grades g ON g.student_id = s.student_id
    INNER JOIN courses c ON c.course_id = g.course_id
    GROUP BY s.student_id, s.first_name, s.last_name, c.course_name
)
SELECT *
FROM avg_grades ag1
WHERE ag1.avg_grade = (
    SELECT MAX(ag2.avg_grade)
    FROM avg_grades ag2
    WHERE ag2.course_name = ag1.course_name
);

/*This view provides a comprehensive overview of pass rates and averages for 
each course, which is essential for understanding course effectiveness.*/
CREATE OR REPLACE VIEW v_pass_rate_courses AS
SELECT c.course_id,
       c.course_name,
       COUNT(DISTINCT g.student_id) AS "Total students",
       COUNT(DISTINCT CASE WHEN g.grade >= 3.0 THEN g.student_id END) 
       AS "Passed students",
       CASE 
           WHEN COUNT(DISTINCT g.student_id) > 0 THEN
               ROUND(COUNT(DISTINCT CASE WHEN g.grade >= 3.0 
               THEN g.student_id END) * 100.0 / COUNT(DISTINCT g.student_id), 2)
           ELSE 0
       END AS "Pass rate",
       COUNT(g.exam_id) AS "Total attempts",
       AVG(g.grade) AS "Average grade"
FROM courses c
LEFT JOIN grades g ON g.course_id = c.course_id
GROUP BY c.course_id, c.course_name;

/*This view summarizes average grades for each course, which is essential 
for performance evaluation.*/
CREATE OR REPLACE VIEW v_courses_averages_grades AS
SELECT  c.course_id AS "Course id",
        c.course_name AS "Course name",
        AVG(g.grade) AS "Average grade"
FROM grades g
INNER JOIN courses c ON g.course_id = c.course_id
GROUP BY c.course_id, c.course_name;

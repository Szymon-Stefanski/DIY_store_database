/*This view effectively ties together group information with student grades, 
which is useful for analyzing group performance.*/
CREATE OR REPLACE VIEW v_grades_groups AS
SELECT  g.group_id AS "Group id",
        g.group_name AS "Group name",
        s.student_id AS "Student id",
        g2.grade  AS "Grade"
FROM groups g
INNER JOIN students_groups s ON s.group_id = g.group_id
INNER JOIN grades g2 ON g2.student_id = s.student_id
ORDER BY g.group_id;

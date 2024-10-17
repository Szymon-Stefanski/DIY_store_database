/*This view effectively ranks students by their grades within each course, 
providing a clear leaderboard.*/
CREATE OR REPLACE VIEW v_courses_grades_rank AS
SELECT  c.course_id AS "Course id",
        c.course_name AS "Course name",
        s.first_name AS "Student name",
        s.last_name AS "Student surname",
        g.grade AS "Grade",
        RANK() OVER (PARTITION BY c.course_id ORDER BY g.grade DESC) AS "Rank"
FROM courses c
INNER JOIN grades g ON g.course_id = c.course_id
INNER JOIN students s ON s.student_id = g.student_id
ORDER BY c.course_name, g.grade DESC;

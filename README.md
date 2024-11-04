# University Database Project

![SQL](https://img.shields.io/badge/SQL-%23468583.svg?style=flat&logo=sql&logoColor=white)
![PL/SQL](https://img.shields.io/badge/PL%2FSQL-%239148C1.svg?style=flat&logo=oracle&logoColor=white)
![utPL/SQL](https://img.shields.io/badge/utPL%2FSQL-%23F80000.svg?style=flat&logo=oracle&logoColor=white)
![Oracle Database 23ai](https://img.shields.io/badge/Oracle%20DB-23ai-red?style=flat&logo=oracle)

## Table of Contents

- [Introduction](#introduction)
- [Installation](#installation)
- [Usage](#usage)

## Introduction

![University](https://github.com/Szymon-Stefanski/university_project/blob/main/README/University.png)

This project involves the design and implementation of a database system for managing university operations using Oracle Database and PL/SQL.
The database tracks essential university data, including students, courses, exams, grades, and student groups. It features multiple views to
analyze student performance, course pass rates, and exam attempts, along with ensuring data integrity through constraints and relational keys.

**The project includes:**

- SQL scripts to create tables, relationships, views and for populating tables with example data.<br>
- Views for tracking student rankings, group performance, grades, failed exams etc.<br>
- Packages in PL/SQL for streamlined management of key database operations, covering functionalities for handling student attendance, courses, exams, grades, lecturers, schedules, and student information.<br>
- Triggers to enforce business rules and data integrity, such as limiting the number of students per group, ensuring exam dates are set in the future, and validating schedule dates and times.<br>

The system is designed to support administrative functions and provide insightful reports for student performance and course management.

## Installation

**How to install all components:**

- Use SQL Developer - instruction for installing:<br>
  https://docs.oracle.com/en/database/oracle/sql-developer/19.1/rptig/installing-sql-developer.html#GUID-A3509B92-90A4-4268-8027-FE85DE5554A8

- Create a new connection - instruction for that:<br>
  https://docs.oracle.com/en/database/oracle/oracle-database/tutorial-create-conn/index.html?opt-release-19c

**If everything is fine then you can download files from folder DATA_SCRIPTS in my respository and open it in SQL Developer:**<br>
![install_1](https://github.com/user-attachments/assets/4594ab9e-5dbe-41c2-bb65-9daa1a9a4bc5)

**Next just click on icon with the small green arrow or press F5 key to run script:**
![image](https://github.com/user-attachments/assets/d8303d9f-1f9c-4372-860e-caaa26fab9a5)

## Usage

**Functionalities:**

- **pkg_attendance_management**: Manages student attendance records, with procedures to insert, update, and report attendance by schedule or group. A function also checks student leave count.

- **pkg_course_management**: Provides operations for creating, updating, and deleting course records, as well as retrieving course information.

- **pkg_exam_management**: Manages exam records, including adding, updating, and deleting exams, and allows retrieval of detailed exam information by exam ID.

- **pkg_grade_management**: Handles student grades, with procedures to add or update grades, calculate average grades, and list all grades for a student.

- **pkg_lecturer_management**: Manages lecturer records, allowing for adding new lecturers, deleting lecturer records, and retrieving lecturer details by ID.

- **pkg_schedule_management**: Controls scheduling of classes and exams, including procedures to create, update, and delete schedules, with a function to display schedule details.

- **pkg_student_management**: Manages student records, including adding new students, updating addresses, and retrieving student information by ID.

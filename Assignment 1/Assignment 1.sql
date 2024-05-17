/*
Create a table called  employees with the following columns and datatypes:

ID - INT autoincrement
last_name - VARCHAR of size 50 should not be null
first_name - VARCHAR of size 50 should not be null
age - INT
job_title - VARCHAR of size 100
date_of_birth - DATE
phone_number - INT
insurance_id - VARCHAR of size 15

SET ID AS PRIMARY KEY DURING TABLE CREATION

*/
create schema employee_data;
create table employees(emp_ID INT auto_increment Primary key, first_name  VARCHAR(50), last_name VARCHAR(50), age INT, job_title VARCHAR(100), date_of_birth DATE, phone_number INT, insurance_id VARCHAR(15));

/*
Add the following data to this table in a SINGLE query:

Smith | John | 32 | Manager | 1989-05-12 | 5551234567 | INS736 |
Johnson | Sarah | 28 | Analyst | 1993-09-20 | 5559876543 | INS832 |
Davis | David | 45 | HR | 1976-02-03 | 5550555995 | INS007 |
Brown | Emily | 37 | Lawyer | 1984-11-15 | 5551112022 | INS035 |
Wilson | Michael | 41 | Accountant | 1980-07-28 | 5554403003 | INS943 |
Anderson | Lisa | 22 | Intern | 1999-03-10 | 5556667777 | INS332 |
Thompson | Alex | 29 | Sales Representative| 5552120111 | 555-888-9999 | INS433 |

*/


INSERT INTO employees (first_name, last_name, age, job_title, date_of_birth, phone_number, insurance_id)
VALUES 
    ('John', 'Smith', 32, 'Manager', '1989-05-12', 5551234567, 'INS736'),
    ('Sarah', 'Johnson', 28, 'Analyst', '1993-09-20', 5559876543, 'INS832'),
    ('David', 'Davis', 45, 'HR', '1976-02-03', 5550555995, 'INS007'),
    ('Emily', 'Brown', 37, 'Lawyer', '1984-11-15', 5551112022, 'INS035'),
    ('Michael', 'Wilson', 41, 'Accountant', '1980-07-28', 5554403003, 'INS943'),
    ('Lisa', 'Anderson', 22, 'Intern', '1999-03-10', 5556667777, 'INS332'),
    ('Alex', 'Thompson', 29, 'Sales Representative', '1999-03-10', 5552120111, 'INS433');


-- While inserting the above data, you might get error because of Phone number column.
-- As phone_number is INT right now. Change the datatype of phone_number to make them strings of FIXED LENGTH of 10 characters.
-- Do some research on which datatype you need to use for this.

ALTER TABLE employees MODIFY COLUMN phone_number VARCHAR(10); 


-- Explore unique job titles
select distinct job_title from employees; 

-- Name the top three youngest employees
SELECT * FROM employee_data.employees;
select first_name, last_name, age from employees order by age Limit 3;

-- Update date of birth for Alex Thompson as it is 1992-06-24

set sql_safe_updates=0;
update employees SET date_of_birth='1992-06-24' where first_name='Alex' AND last_name='Thompson';


-- Delete the data of employees with age greater than 30
delete from employees where age>30;


-- Concatenating First name and Last name:

select concat(first_name, last_name) as full_name from employees; 

/*-- Create a table called employee_insurance with the following columns and datatypes:

insurance_id VARCHAR of size 15
insurance_info VARCHAR of size 100

Make insurance_id the primary key of this table
							
*/
create table employee_insurance(insurance_id VARCHAR(15) primary key, insurance_info VARCHAR(100));



/*
Insert the following values into employee_insurance:

"INS736", "unavailable"
"INS832", "unavailable"
"INS007", "unavailable"
"INS035", "unavailable"
"INS943", "unavailable"
"INS332", "unavailable"
"INS433", "unavailable"

*/
insert into employee_insurance values("INS736", "unavailable"),
("INS832", "unavailable"),("INS007", "unavailable"),("INS035", "unavailable"),("INS943", "unavailable"),
("INS332", "unavailable"),("INS433", "unavailable");


-- Add a column called email to the employees table. Remember to set an appropriate datatype
alter table employees add column email VARCHAR(100);

-- Add the value "unavailable" for all records in email in a SINGLE query
update employees set email='unavailable';


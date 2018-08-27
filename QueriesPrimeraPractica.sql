CREATE TABLE employees
(
  id INT PRIMARY KEY,
  manager_id INT,
  date_of_joining DATE NOT NULL,
  name varchar2(50 BYTE) NOT NULL,
  last_name varchar2(50 BYTE) NOT NULL,
  salary int,
  CONSTRAINT chk_salary check (salary >50000),
  CONSTRAINT fk_manager_id
    FOREIGN KEY (manager_id)
    REFERENCES employees(id)
);

CREATE TABLE PROJECTS
(
  id INT PRIMARY KEY,
  code VARCHAR2(40 BYTE) NOT NULL,
  manager_id INT NOT NULL,
  budget NUMBER(19,4) NOT NULL,
  date_of_beginning DATE,
  date_of_ending DATE,
  CONSTRAINT fk_manager_project
    FOREIGN KEY (manager_id)
    REFERENCES employees(id)
);

CREATE TABLE assignments 
(
  id INT PRIMARY KEY,
  employee_id INT NOT NULL,
  project_id INT NOT NULL,
  CONSTRAINT fk_assignment_employee
    FOREIGN KEY (employee_id)
    REFERENCES employees(id),
    CONSTRAINT fk_assignment_project
    FOREIGN KEY (project_id)
    REFERENCES PROJECTS(id)
);




--1.Show id of the project, code of the project and the number of employees associated to each
--project (number_of_employees) order by number_of_employees descending.
SELECT PROJECTS.ID, PROJECTS.CODE, COUNT(PROJECTS.CODE) AS "number_of_employees" 
FROM PROJECTS 
INNER JOIN ASSIGNMENTS
ON PROJECTS.ID = ASSIGNMENTS.PROJECT_ID
INNER JOIN EMPLOYEES
ON ASSIGNMENTS.EMPLOYEE_ID = EMPLOYEES.ID
GROUP BY PROJECTS.CODE, PROJECTS.ID
ORDER BY COUNT(CODE) DESC;

--2. Show the id, name and last name of the employees associated to the project with code
--"d1373b16-b953-48ab-82b0-23ae2c7e4670" (One query)
SELECT  EMPLOYEES.ID, EMPLOYEES.NAME, EMPLOYEES.LAST_NAME
FROM EMPLOYEES
INNER JOIN ASSIGNMENTS
ON EMPLOYEES.ID = ASSIGNMENTS.EMPLOYEE_ID
INNER JOIN PROJECTS
ON ASSIGNMENTS.PROJECT_ID = PROJECTS.ID
WHERE PROJECTS.CODE = 'd1373b16-b953-48ab-82b0-23ae2c7e4670';

--3. Write a SQL query to fetch employee names (one column, don't change the alias) having salary
--greater than or equal to 80000 and less than or equal 120000.
SELECT EMPLOYEES.NAME
FROM EMPLOYEES
WHERE EMPLOYEES.SALARY >= 80000 AND EMPLOYEES.SALARY <= 120000;

--4. Write a SQL query to fetch all the Employees who are assigned to any project as managers.
--name and last name should be displayed in one single column named "full_name", don't
--duplicate names.
SELECT DISTINCT(EMPLOYEES.NAME ||' '|| EMPLOYEES.LAST_NAME) AS full_name 
FROM EMPLOYEES  
INNER JOIN ASSIGNMENTS
ON EMPLOYEES.ID = ASSIGNMENTS.EMPLOYEE_ID 
INNER JOIN PROJECTS
ON ASSIGNMENTS.PROJECT_ID = PROJECTS.ID;

--5. Write a SQL query to fetch each employee with the name of his/her boss in one column named
--"employee_boss" separated by ' - ' (don't forget the spaces). Example: "Drew Rosario - Holmes
--Manning", "Emery Kelley - Holmes Manning" (employee name - manager name)
SELECT (MANAGER.NAME ||' '|| MANAGER.LAST_NAME ||' - '|| EMPLOYEE.NAME ||' '|| EMPLOYEE.LAST_NAME) as employee_boss
FROM EMPLOYEES EMPLOYEE       
INNER JOIN EMPLOYEES MANAGER
ON MANAGER.MANAGER_ID = EMPLOYEE.ID;

--6. Write a SQL query to fecth the id, name, last name, date_of_joining and employees_in_charge
--(employees_in_charge is the counter of employees for whom each boss is in charge). You
--should order the results by the oldest employee in the company.



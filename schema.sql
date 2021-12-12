-- Creating tables for PH-EmployeeDB
CREATE TABLE departments(
	dept_no VARCHAR(4) NOT NULL,
	dept_name VARCHAR(40) NOT NULL,
	PRIMARY KEY (dept_no),
	UNIQUE (dept_name)
);

CREATE TABLE Employees (
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	gender VARCHAR(10) NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
		PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no)
);

-- has no row with unique values, yet mod 7.1.5 ERD suggests emp_no, title and from_date are all keys. Are they foreign keys?
create table titles (
	emp_no INT NOT NULL,
	title VARCHAR(20) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
);

CREATE TABLE Dept_Employees (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (dept_no, emp_no)
);

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Create new table from retirement eligibility
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- drop retirement_info table, this table was a query so no connections to sever 
DROP TABLE retirement_info;

-- Create new table for retiring employees, now includes emp_no for joining
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- inner join departments and dept_manager
SELECT departments.dept_name, 
	dept_manager.emp_no, 
	dept_manager.from_date, 
	dept_manager.to_date
FROM departments as d
INNER JOIN dept_manager as dm 
ON d.dept_no = dm.dept_no;

-- inner join of departments and dept_manager with aliases
SELECT d.dept_name,
	dm.emp_no
	dm.from_date
	dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- make join between retirement_info and dept_emp
-- the order of select determines order of columns displayed, after join we want all information from (left table) retirement_info AND
-- all info from (right table) dept_employees where there is a match on emp.no
SELECT retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
	dept_employees.to_date
FROM retirement_info
LEFT JOIN dept_employees ON retirement_info.emp_no = dept_employees.emp_no;

-- left join of retirement_info and dept_employees into new table with only current employees
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_employees as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01')

-- join current_emp and dept_emp to do employee count by department
-- we only need the count of employees per department so only 2 columns selected
-- count() was used to count individual employees instead of SUM() of their employee numbers. 
-- The resulting table will return count in place of employee numbers

SELECT COUNT(ce.emp_no), de.dept_no --ce.emp_no is what we're interested in getting summary stats for. de.dept_no is what we want to group by. Must be selected if using group by.
FROM current_emp as ce 
LEFT JOIN dept_employees as de
ON ce.emp_no = de.emp_no 
GROUP BY de.dept_no
ORDER BY de.dept_no; -- default is ascending?

-- Skill drill, update ce and de left join to save as new table and export to CSV
SELECT COUNT(ce.emp_no), de.dept_no 
INTO elig_retirees
FROM current_emp as ce 
LEFT JOIN dept_employees as de
ON ce.emp_no = de.emp_no 
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- List 1: general employee list with emp_no, last_name, first_name, gender, salary, to_date. Join with 3 tables
-- 1) Start from code that made current_emp table
SELECT e.emp_no, 
	e.first_name, 
	e.last_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no=s.emp_no)
INNER JOIN dept_employees as de
ON (e.emp_no=de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

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


-- make join between retirement_info and dept_emp, attempt 1.
-- Left join in this way returned with 331603 rows and a bunch of nulls
-- substituting right join returned with 45784 rows and no nulls
SELECT dept_employees.to_date,
	retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name
FROM dept_employees as d
LEFT JOIN retirement_info as ri ON ri.emp_no = d.emp_no
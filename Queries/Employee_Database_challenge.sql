-- Deliverable 1
-- Create Retirement Titles table
SELECT e.emp_no,
    e.first_name,
    e.last_name,
    t.title,
    t.from_date,
    t.to_date
INTO Retirement_titles
FROM employees as e
INNER JOIN titles as t
ON e.emp_no=t.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no;

-- query: titles of current employees eligible for retirement 
SELECT DISTINCT ON(emp_no) emp_no,
	first_name,
	last_name,
	title
-- INTO unique_titles
FROM retirement_titles
WHERE to_date = '9999-01-01';

-- query: retrieve number of employees by most recent job title who are eligible for retirement
SELECT COUNT(title) as title_counts, title
-- INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY title_counts DESC;

-- Deliverable 2
-- mentorship elibility table
SELECT DISTINCT ON (e.emp_no) e.emp_no,
    e.first_name,
    e.last_name,
    e.birth_date,
    de.from_date,
    de.to_date,
    titles.title
-- INTO mentorship_eligibility
FROM employees as e
INNER JOIN dept_employees as de
    ON e.emp_no = de.emp_no
INNER JOIN titles 
    ON de.emp_no = titles.emp_no
WHERE de.to_date = '9999-01-01'
AND (e.birth_date BETWEEN '1965-01-01' and '1965-12-31')
ORDER BY emp_no ASC;

-- summary table of mentorship eligible grouped by titles
SELECT COUNT(title) AS title_counts,
	title
FROM mentorship_eligibility
GROUP BY title
ORDER BY title_counts DESC;

-- query of those eligible by birth year, how many hold the appropriate experience i.e. X years with current title
SELECT me.emp_no,
    me.first_name,
    me.last_name,
    me.birth_date,
    me.from_date,
    me.to_date,
    me.title,
    titles.to_date
FROM mentorship_eligibility as me
INNER JOIN titles
ON me.emp_no = titles.emp_no
WHERE titles.to_date BETWEEN '1965-01-01' AND '2011-12-31'; 
-- alternative to above
SELECT me.*,
    titles.to_date
FROM mentorship_eligibility as me
INNER JOIN titles
ON me.emp_no = titles.emp_no
WHERE titles.to_date BETWEEN '1965-01-01' AND '2011-12-31';

-- 2. from current employees, query those that hold Senior Engineer for, e.g. the last 20 years.
SELECT DISTINCT ON (ce.emp_no) ce.emp_no,
	ce.first_name,
	ce.last_name,
	titles.title,
	titles.from_date,
	titles.to_date
FROM current_emp as ce
INNER JOIN titles
ON (ce.emp_no = titles.emp_no)
WHERE titles.title = 'Senior Engineer'
AND titles.from_date BETWEEN '2000-01-01' AND '9999-01-01';
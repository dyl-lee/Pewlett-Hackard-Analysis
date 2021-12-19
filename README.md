# Pewlett-Hackard-Analysis
## Overview
An employee database of a large company was built from flat-file using SQL and subsequently queried to return more detailed information about retirement eligible employees and how best to prepare for their eventual departure. 

## Resources
### Data Sources
* departments.csv
* dept_emp.csv
* dept_manager.csv
* employees.csv
* salaries.csv
* titles.csv
### Software
* PostgreSQL 14
* pgAdmin 4
* Visual Studio Code 1.62.3
### Queries (exported as CSV)
* retirement_titles.csv
* unique_titles.csv
* retiring_titles.csv
* mentorship_eligibility.csv

## Results
### Highlights
* 72,458 currently employed at Pewlett-Hackard are eligible for retirement.
* The breakdown for each (most recent) title is summarized in the table below:

![retiring_titles](https://user-images.githubusercontent.com/90335218/146656299-f7fb61f2-5f7e-47a3-8d82-225b625b2064.png)

* Senior Engineers and Senior Staff comprising a combined 70% (50,842) of all eligible for retirement.
* 1,549 current employees (with 1965 birth year) are eligible for the mentorship program.

## Summary and future directions
A total of 72,458 employees are eligible for retirement and hence will need to be filled. Of those retirement-eligible, a majority (70% or 50,842 of 72,458) of those employees hold senior-level titles indicating a significant talent depletion as this 'silver tsunami' hits. Based on the suggested criteria for the mentorship program, 1965 birth year, there are 1,549 current employees ready to mentor the next generation of employees. This is hardly a sufficient number of mentors to replenish the number of employees expected to leave, especially when considering the proportion of mentors:trainees per department as the following query shows:

```
-- summary table of mentorship eligible grouped by titles
SELECT COUNT(title) AS title_counts,
	title
FROM mentorship_eligibility
GROUP BY title
ORDER BY title_counts DESC;
```
![title_count_mentorship](https://user-images.githubusercontent.com/90335218/146687160-c0616ab9-13d7-4d0e-ad2e-ca33f03b3ac1.png)

At best this represents:

| Title | Trainees per Eligible Mentor |
| --- | --- |
| Senior Enginer | 49 |
| Senior Staff | 170 |
| Engineer | 49 |
| Staff | 13 |
| Technique Leader | 47 |
| Assistant Engineer | 38 |

With the current criteria for eligible mentors, there are no employees available to replace the 2 managers expected to retire.

For this reason it may be wise to extend the criteria for the mentorship program, either include employees not yet retiring or include employees outsde the birth year criteria with sufficient work experience (i.e. X number of years with senior-level title):

```
-- 1. Extend birth year criteria (e.g. by 10 years) to include employees who are not yet retiring.
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
AND (e.birth_date BETWEEN '1965-01-01' and '1975-12-31')
ORDER BY emp_no ASC;
```

```
-- 2. from all current employees, instead of those born in 1965, query those that hold Senior Engineer for, e.g. the last 20 years.
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
```

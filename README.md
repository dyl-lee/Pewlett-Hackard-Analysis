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
* 1,549 current employees (with birth years as early as 1965) are eligible for the mentorship program.

## Summary and future directions
A total of 72,458 employees are eligible for retirement and hence will need to be filled. Of those retirement-eligible, a majority (70% or 50,842 of 72,458) of those employees hold senior-level titles indicating a significant talent depletion as this 'silver tsunami' hits. Based on the suggested criteria, 1965 birth year, for the mentorship program, there are 1,549 current employees ready to mentor the next generation of employees. This is hardly a sufficient number of mentors to replenish the number of employees expected to leave (approximately 1 mentor for 47 trainees). For this reason it may be wise to extend the criteria for the mentorship program, either include employees not yet retiring or include employees with sufficient work experience (i.e. X number of years with senior-level title).

How many roles will need to be filled as the retirement wave begins to make an impact? Are there enough qualified, retirement-ready employees in departments to mentor the next generation of employees?

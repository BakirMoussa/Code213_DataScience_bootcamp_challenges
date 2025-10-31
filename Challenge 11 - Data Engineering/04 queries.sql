-- ================================================================
-- Pewlett Hackard Data Analysis Queries
-- Data Engineering Challenge Solution
-- ================================================================

-- ================================================================
-- QUERY 1: List employee details with salary
-- Shows: employee number, last name, first name, gender, and salary
-- ================================================================
SELECT 
    e.emp_no,
    e.last_name,
    e.first_name,
    e.sex,
    s.salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
ORDER BY e.emp_no;


-- ================================================================
-- QUERY 2: Employees hired in 1986
-- Shows: first name, last name, and hire date
-- ================================================================
SELECT 
    first_name,
    last_name,
    hire_date
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 1986
-- Alternative for SQLite: WHERE hire_date LIKE '%1986'
ORDER BY hire_date;


-- ================================================================
-- QUERY 3: Manager of each department
-- Shows: department number, department name, manager's employee number,
--        manager's last name, first name, and employment dates
-- ================================================================
SELECT 
    d.dept_no,
    d.dept_name,
    dm.emp_no,
    e.last_name,
    e.first_name
FROM departments d
JOIN dept_manager dm ON d.dept_no = dm.dept_no
JOIN employees e ON dm.emp_no = e.emp_no
ORDER BY d.dept_no;


-- ================================================================
-- QUERY 4: Department of each employee
-- Shows: employee number, last name, first name, and department name
-- ================================================================
SELECT 
    e.emp_no,
    e.last_name,
    e.first_name,
    d.dept_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
ORDER BY e.emp_no;


-- ================================================================
-- QUERY 5: Employees named Hercules with last names beginning with B
-- Shows: first name, last name, and sex
-- ================================================================
SELECT 
    first_name,
    last_name,
    sex
FROM employees
WHERE first_name = 'Hercules' 
  AND last_name LIKE 'B%'
ORDER BY last_name;


-- ================================================================
-- QUERY 6: Employees in Sales department
-- Shows: employee number, last name, first name, and department name
-- ================================================================
SELECT 
    e.emp_no,
    e.last_name,
    e.first_name,
    d.dept_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales'
ORDER BY e.emp_no;


-- ================================================================
-- QUERY 7: Employees in Sales and Development departments
-- Shows: employee number, last name, first name, and department name
-- ================================================================
SELECT 
    e.emp_no,
    e.last_name,
    e.first_name,
    d.dept_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name IN ('Sales', 'Development')
ORDER BY d.dept_name, e.emp_no;


-- ================================================================
-- QUERY 8: Frequency count of employee last names (descending order)
-- Shows: last name and frequency count
-- ================================================================
SELECT 
    last_name,
    COUNT(*) as frequency
FROM employees
GROUP BY last_name
ORDER BY frequency DESC, last_name
LIMIT 20;

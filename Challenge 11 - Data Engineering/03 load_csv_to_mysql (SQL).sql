-- Disable foreign key checks temporarily to allow data loading in any order
SET FOREIGN_KEY_CHECKS = 0;

-- 3. Import CSV files (MySQL equivalent of PostgreSQL \copy)

LOAD DATA INFILE '../Uploads/data/departments.csv'
INTO TABLE departments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE '../Uploads/data/titles.csv'
INTO TABLE titles
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE '../Uploads/data/employees.csv'
INTO TABLE employees
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    -- Load raw data into temporary stage variables first
    emp_no,
    emp_title_id,
    @birth_date_var, -- Use a user variable to hold the raw date string
    first_name,
    last_name,
    sex,
    @hire_date_var   -- Use a variable for hire date as well, if in mm/dd/yyyy
)
SET -- Use the SET clause to convert the string variables to the correct DATE format
    birth_date = STR_TO_DATE(@birth_date_var, '%m/%d/%Y'),
    hire_date = STR_TO_DATE(@hire_date_var, '%m/%d/%Y');

LOAD DATA INFILE '../Uploads/data/salaries.csv'
INTO TABLE salaries
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE '../Uploads/data/dept_emp.csv'
INTO TABLE dept_emp
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE '../Uploads/data/dept_manager.csv'
INTO TABLE dept_manager
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Re-enable foreign key checks after data import is complete
SET FOREIGN_KEY_CHECKS = 1;

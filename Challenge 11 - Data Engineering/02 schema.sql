-- ================================================================
-- Pewlett Hackard Database Schema
-- Data Engineering Challenge Solution
-- ================================================================

-- Drop database if it exists and create a new one
DROP DATABASE IF EXISTS Pewlett_Hackard;
CREATE DATABASE Pewlett_Hackard;

-- Use the newly created database
USE Pewlett_Hackard;

-- Drop tables if they exist (in correct order due to foreign keys)
DROP TABLE IF EXISTS dept_manager;
DROP TABLE IF EXISTS dept_emp;
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS titles;
DROP TABLE IF EXISTS departments;

-- ================================================================
-- TABLE 1: Departments
-- Contains company department information
-- ================================================================
CREATE TABLE departments (
    dept_no VARCHAR(4) PRIMARY KEY,
    dept_name VARCHAR(40) NOT NULL UNIQUE
);

-- ================================================================
-- TABLE 2: Titles
-- Contains job title reference data
-- ================================================================
CREATE TABLE titles (
    title_id VARCHAR(5) PRIMARY KEY,
    title VARCHAR(50) NOT NULL UNIQUE
);

-- ================================================================
-- TABLE 3: Employees
-- Contains employee personal and employment information
-- ================================================================
CREATE TABLE employees (
    emp_no INTEGER PRIMARY KEY,
    emp_title_id VARCHAR(5) NOT NULL,
    birth_date DATE NOT NULL,
    first_name VARCHAR(14) NOT NULL,
    last_name VARCHAR(16) NOT NULL,
    sex CHAR(1) NOT NULL CHECK (sex IN ('M', 'F')),
    hire_date DATE NOT NULL,
    FOREIGN KEY (emp_title_id) REFERENCES titles(title_id)
);

-- ================================================================
-- TABLE 4: Salaries
-- Contains salary information for each employee
-- One-to-one relationship with employees
-- ================================================================
CREATE TABLE salaries (
    emp_no INTEGER PRIMARY KEY,
    salary INTEGER NOT NULL CHECK (salary > 0),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

-- ================================================================
-- TABLE 5: Department-Employee (Junction Table)
-- Many-to-many relationship between departments and employees
-- An employee can work in multiple departments over time
-- ================================================================
CREATE TABLE dept_emp (
    emp_no INTEGER NOT NULL,
    dept_no VARCHAR(4) NOT NULL,
    PRIMARY KEY (emp_no, dept_no),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

-- ================================================================
-- TABLE 6: Department Managers (Junction Table)
-- Many-to-many relationship between departments and employee managers
-- A department can have multiple managers over time
-- ================================================================
CREATE TABLE dept_manager (
    dept_no VARCHAR(4) NOT NULL,
    emp_no INTEGER NOT NULL,
    PRIMARY KEY (dept_no, emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

-- ================================================================
-- Indexes for improved query performance
-- ================================================================
CREATE INDEX idx_employees_last_name ON employees(last_name);
CREATE INDEX idx_employees_first_name ON employees(first_name);
CREATE INDEX idx_employees_hire_date ON employees(hire_date);
CREATE INDEX idx_dept_emp_dept_no ON dept_emp(dept_no);
CREATE INDEX idx_dept_manager_emp_no ON dept_manager(emp_no);

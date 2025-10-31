"""
CSV to MySQL Data Loader
This script loads CSV files from the data folder into MySQL database
without requiring files to be in MySQL's secure upload directory.
"""

import pandas as pd
import mysql.connector
from mysql.connector import Error
import os
from pathlib import Path

# Database configuration
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'root',
    'database': 'Pewlett_Hackard'
}

# Get the directory where this script is located
SCRIPT_DIR = Path(__file__).parent
DATA_DIR = SCRIPT_DIR / 'data'


def create_connection():
    """Create a database connection to MySQL"""
    try:
        connection = mysql.connector.connect(**DB_CONFIG)
        if connection.is_connected():
            print(f"Successfully connected to MySQL database: {DB_CONFIG['database']}")
            return connection
    except Error as e:
        print(f"Error connecting to MySQL: {e}")
        return None


def load_csv_to_table(connection, csv_file, table_name, date_columns=None):
    """
    Load a CSV file into a MySQL table

    Args:
        connection: MySQL connection object
        csv_file: Path to the CSV file
        table_name: Name of the target table
        date_columns: List of column names that contain dates to be converted
    """
    try:
        print(f"\nLoading {csv_file.name} into {table_name}...")

        # Read CSV file
        df = pd.read_csv(csv_file)

        # Convert date columns if specified
        if date_columns:
            for col in date_columns:
                if col in df.columns:
                    df[col] = pd.to_datetime(df[col], format='%m/%d/%Y')

        # Get cursor
        cursor = connection.cursor()

        # Prepare the INSERT statement
        columns = ', '.join(df.columns)
        placeholders = ', '.join(['%s'] * len(df.columns))
        insert_query = f"INSERT INTO {table_name} ({columns}) VALUES ({placeholders})"

        # Convert DataFrame to list of tuples with native Python types
        # Replace NaN with None and convert numpy types to Python types
        df = df.where(pd.notnull(df), None)
        data = [tuple(x.item() if hasattr(x, 'item') else x for x in row)
                for row in df.values]

        # Execute batch insert
        cursor.executemany(insert_query, data)
        connection.commit()

        print(f"✓ Successfully loaded {len(df)} rows into {table_name}")

        cursor.close()

    except Error as e:
        print(f"✗ Error loading {csv_file.name} into {table_name}: {e}")
        connection.rollback()
    except Exception as e:
        print(f"✗ Unexpected error with {csv_file.name}: {e}")
        connection.rollback()


def main():
    """Main function to load all CSV files into the database"""

    # Check if data directory exists
    if not DATA_DIR.exists():
        print(f"Error: Data directory not found at {DATA_DIR}")
        return

    # Create database connection
    connection = create_connection()
    if not connection:
        return

    try:
        cursor = connection.cursor()

        # Disable foreign key checks temporarily
        print("\nDisabling foreign key checks...")
        cursor.execute("SET FOREIGN_KEY_CHECKS = 0")

        # Load tables in the correct order (respecting foreign key dependencies)
        # 1. Load departments (no dependencies)
        load_csv_to_table(
            connection,
            DATA_DIR / 'departments.csv',
            'departments'
        )

        # 2. Load titles (no dependencies)
        load_csv_to_table(
            connection,
            DATA_DIR / 'titles.csv',
            'titles'
        )

        # 3. Load employees (depends on titles)
        load_csv_to_table(
            connection,
            DATA_DIR / 'employees.csv',
            'employees',
            date_columns=['birth_date', 'hire_date']
        )

        # 4. Load salaries (depends on employees)
        load_csv_to_table(
            connection,
            DATA_DIR / 'salaries.csv',
            'salaries'
        )

        # 5. Load dept_emp (depends on departments and employees)
        load_csv_to_table(
            connection,
            DATA_DIR / 'dept_emp.csv',
            'dept_emp'
        )

        # 6. Load dept_manager (depends on departments and employees)
        load_csv_to_table(
            connection,
            DATA_DIR / 'dept_manager.csv',
            'dept_manager'
        )

        # Re-enable foreign key checks
        print("\nRe-enabling foreign key checks...")
        cursor.execute("SET FOREIGN_KEY_CHECKS = 1")

        cursor.close()
        print("\n" + "="*50)
        print("✓ All CSV files loaded successfully!")
        print("="*50)

    except Error as e:
        print(f"\n✗ Database error: {e}")
    finally:
        if connection and connection.is_connected():
            connection.close()
            print("\nDatabase connection closed.")


if __name__ == "__main__":
    print("="*50)
    print("CSV to MySQL Data Loader")
    print("="*50)
    main()

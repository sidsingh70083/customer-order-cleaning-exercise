# Sales Data Analytics Preparation Project

## 🎯 Business Objective
This project takes raw, messy customer order data from a CSV file and transforms it into a clean, standardized, and deduplicated table in a SQL database. The goal is to create a reliable "single source of truth" that is ready for business intelligence (BI) dashboards and sales analysis.

## 📊 Dataset & Methodology
- **Data Source:** A raw CSV file (`customer_orders.csv`) containing transactional data with multiple inconsistencies.
- **Tools Used:**
    - **Python (Pandas, SQLAlchemy):** For the initial ETL pipeline (Extracting from CSV, Loading into MySQL).
    - **MySQL:** For all data transformation, cleaning, and deduplication.
- **Analysis Approach:**
    1.  **Load:** Ingested raw data into a `cust_ord` table using a Python script.
    2.  **Transform:** Wrote a single, comprehensive SQL query using Common Table Expressions (CTEs) to clean all data in one step.
    3.  **Final Table:** The final query selects only the clean, unique rows into a final view or table.

## 🔍 Key Cleaning & Transformation Steps
My SQL script performs several key transformations to prepare the data for analysis:

- **Standardization (Status):** Grouped inconsistent `order_status` fields (e.g., "Shipped", "ship") into clean categories ("Shipped", "Delivered", "Returned") using `CASE` statements.
- **Standardization (Country):** Cleaned and grouped country names (e.g., "USA", "united states" -> "USA").
- **Data Type Conversion:** Converted `quantity` from text (like 'two') to numeric integers using `REGEXP` and `CAST`.
- **Date/Time Handling:** Parsed multiple date formats (e.g., `YYYY-MM-DD`, `MM/DD/YYYY`) into a single, standard `DATE` format using `COALESCE` and `STR_TO_DATE`.
- **Feature Engineering:** Extracted the `day_of_week` from the cleaned order date to enable time-based analysis.
- **Deduplication:** Used the `ROW_NUMBER() OVER(PARTITION BY ...)` window function to identify and remove duplicate customer orders, keeping only the first instance.

## 🛠 Skills & Learnings
This project demonstrates proficiency in:
- **Technical Skills:**
    - Advanced SQL (Window Functions, CTEs, `CASE`, `CAST`, `REGEXP`)
    - Python (Pandas) for ETL
    - Database Management (MySQL Workbench)
- **Learnings:**
    - Followed a practical tutorial ([Watch me Cleaning Data in minutes with SQL](https://youtu.be/eOlHqTfWi6k)) and applied the concepts to a local environment.
    - Practiced debugging SQL.

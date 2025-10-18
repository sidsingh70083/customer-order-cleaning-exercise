# SQL Data Cleaning Practice Session

## 🎯 Objective
This is a small personal project to practice foundational data cleaning techniques in SQL. The dataset is a 15-row sample (`customer_orders.csv`) with common data quality issues.

The goal was to write a single, clean query to:
1.  Standardize messy categorical data.
2.  Convert mixed data types.
3.  Handle inconsistent date formats.
4.  Remove duplicate entries.

## 💻 Tools & Process
- **Tools:** Python (Pandas, SQLAlchemy) to load the CSV, MySQL Workbench for querying.
- **Process:**
    1.  Loaded the raw CSV into a MySQL table (`cust_ord`) using a simple Python script.
    2.  Wrote the `2_clean_and_deduplicate.sql` query using CTEs to build the cleaning logic in steps.
    3.  The final `SELECT` statement shows the clean, deduplicated output.

## 🛠 Skills Practiced
This exercise was a great sandbox for practicing:
-   **Window Functions:** Using `ROW_NUMBER() OVER(PARTITION BY ...)` to identify duplicates.
-   **Data Standardization:** Using `CASE` statements to clean `order_status` and `country`.
-   **Type Conversion:** Using `CAST` and `REGEXP` to convert text quantities (like 'two') to integers.
-   **Date Handling:** Using `COALESCE` and `STR_TO_DATE` to parse multiple date formats.
-   **Query Readability:** Using Common Table Expressions (CTEs) to keep the query organized.

This was based on a helpful tutorial from Lore So What ([link](https://youtu.be/eOlHqTfWi6k)).

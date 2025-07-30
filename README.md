# SQL Reporting Assessment

This project generates a report showing daily lead and order activity by lead source over the last 30 days. It includes:

- Valid leads  
- New clients  
- Total orders  
- Total order value

---

## Files

- `create-table.sql`  
  Creates the `LEADS`, `CLIENTS`, and `ORDERS` tables for the assessment.

- `insert-sample-data.sql`  
  Adds sample data to test and validate the query logic.

- `main-query.sql`  
  Contains the final SQL query that generates the 30-day report.

- `create-index.sql`  
  Adds indexes to speed up query execution time. See the analysis below for details.

---

## How to Run

1. Create your PostgreSQL database:

    ```bash
    psql -U your_user -c "CREATE DATABASE your_db;"
    ````

2. Set up the schema and data:

    ```bash
    psql -U your_user -d your_db -f create-table.sql
    psql -U your_user -d your_db -f insert-sample-data.sql
    ```

3. (Optional) Add indexes to improve performance:

    ```bash
    psql -U your_user -d your_db -f create-index.sql
    ```

4. Run the report query:

    ```bash
    psql -U your_user -d your_db -f main-query.sql
    ```

---

## Performance Analysis

Before optimization, the query execution time was around **1.350 ms**.

To improve performance, I created `create-index.sql` which adds indexes to:

* Date filtering columns: `lead_creation_datetime`, `order_creation_datetime`
* Join keys: `lead_id`, `client_id`
* Grouping column: `lead_source`

These indexes help PostgreSQL avoid full table scans and use faster indexed lookups.

**Before Optimization:**
![Original execution time](imgs/1.png)

**After Running Index Script:**
Execution time improved to **1.115 ms**, which is approximately **82.6% of the original time**.
![Improved execution time](imgs/2.png)


This optimization makes the query more scalable for larger datasets.
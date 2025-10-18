SELECT * FROM cust_ord;


-- clean_order_status
SELECT 
    order_status,
CASE
	WHEN LOWER(order_status) LIKE '%deliver%' Then "Delivered"
	WHEN LOWER(order_status) LIKE '%ship%' Then "Shipped"
    WHEN LOWER(order_status) LIKE '%pend%' Then "Pending"
    WHEN LOWER(order_status) LIKE '%return%' Then "Returned"
    WHEN LOWER(order_status) LIKE '%refund%' Then "Refunded"
	ELSE 'Other'
END AS cleaned_order_status

FROM
    cust_ord ;
    
    
-- cleaning product_name
SELECT LOWER(product_name) FROM cust_ord;


-- cleaning quantity
SELECT quantity,
CASE
	WHEN LOWER(quantity) = 'two' THEN 2
    WHEN quantity REGEXP '^[0-9]+$' THEN CAST(quantity AS SIGNED)
    ELSE NULL
END AS cleaned_quantity
FROM
	cust_ord;
    
    
-- clean_customer_name
-- SELECT 
--   customer_name,
--   CONCAT(UPPER(SUBSTRING(customer_name, 1, 1)), 
--          LOWER(SUBSTRING(customer_name, 2))) AS capitalized_name
-- FROM 
--   cust_ord
-- WHERE 
--   customer_name IS NOT NULL;

SELECT LOWER(customer_name) AS clean_customer_name
FROM
cust_ord
WHERE customer_name IS NOT NULL;


-- remove duplicate orders
SELECT *
FROM(
SELECT *,
	ROW_NUMBER() OVER(PARTITION BY LOWER(customer_name),LOWER(product_name),LOWER(email) ORDER BY order_id) AS rn
FROM cust_ord
) AS rd
WHERE rn=1;


-- cleaned_order_date
SELECT
  order_date,
  COALESCE(
    STR_TO_DATE(order_date, '%Y-%m-%d'),
    STR_TO_DATE(order_date, '%Y/%m/%d'), 
    STR_TO_DATE(order_date, '%m/%d/%Y')  
  ) AS clean_order_date,
  
  -- This test will only work on a real DATE, not on a string
  DAYNAME(
    COALESCE(
      STR_TO_DATE(order_date, '%Y-%m-%d'),
      STR_TO_DATE(order_date, '%Y/%m/%d'), 
      STR_TO_DATE(order_date, '%m/%d/%Y')
    )
  ) AS day_of_week
  
FROM
  cust_ord;


/*
  This query uses two Common Table Expressions (CTEs) to first clean all
  the data in one step, and then deduplicate that clean data in a second step.
*/

-- STEP 1: Create a 'cleaned_data' CTE with all cleaning logic applied
WITH cleaned_data AS (
  SELECT
    order_id,
    
    -- Clean customer_name (standardized to lowercase)
    LOWER(customer_name) AS cleaned_customer_name,
    email,
    
    -- Clean product_name (standardized to lowercase)
    LOWER(product_name) AS cleaned_product_name,
    price,
    
    -- Clean and standardize country names
    CASE
      WHEN LOWER(country) IN ('usa', 'united states') THEN 'USA'
      WHEN LOWER(country) IN ('uk', 'united kingdom') THEN 'UK'
      -- Simple capitalization for the rest
      WHEN LOWER(country) = 'spain' THEN 'Spain'
      WHEN LOWER(country) = 'india' THEN 'India'
      WHEN LOWER(country) = 'canada' THEN 'Canada'
      ELSE 'Other'
    END AS cleaned_country,
    
    -- Clean order_status (grouped into standard categories)
    CASE
      WHEN LOWER(order_status) LIKE '%deliver%' THEN 'Delivered'
      WHEN LOWER(order_status) LIKE '%ship%' THEN 'Shipped'
      WHEN LOWER(order_status) LIKE '%pend%' THEN 'Pending'
      WHEN LOWER(order_status) LIKE '%return%' THEN 'Returned'
      WHEN LOWER(order_status) LIKE '%refund%' THEN 'Refunded'
      ELSE 'Other'
    END AS cleaned_order_status,
    
    -- Clean quantity (converting 'two' and text-based numbers)
    CASE
      WHEN LOWER(quantity) = 'two' THEN 2
      WHEN quantity REGEXP '^[0-9]+$' THEN CAST(quantity AS SIGNED)
      ELSE NULL
    END AS cleaned_quantity,
    
    -- Clean order_date (handling multiple text formats)
    COALESCE(
      STR_TO_DATE(order_date, '%Y-%m-%d'),
      STR_TO_DATE(order_date, '%Y/%m/%d'),
      STR_TO_DATE(order_date, '%m/%d/%Y')
    ) AS cleaned_order_date,
    
    -- Extract day of week from the new clean date
    DAYNAME(
      COALESCE(
        STR_TO_DATE(order_date, '%Y-%m-%d'),
        STR_TO_DATE(order_date, '%Y/%m/%d'),
        STR_TO_DATE(order_date, '%m/%d/%Y')
      )
    ) AS day_of_week,
    notes
    
  FROM
    cust_ord
),

-- STEP 2: Create a 'deduplicated_data' CTE that reads *from the clean data*
deduplicated_data AS (
  SELECT
    *,
    -- Assign a row number (rn) to each group of duplicates
    ROW_NUMBER() OVER (
      PARTITION BY
        cleaned_customer_name,
        email,
        cleaned_product_name
      ORDER BY
        order_id ASC 
    ) AS rn
  FROM
    cleaned_data -- <-- This now correctly reads from the 'cleaned_data' CTE
)

-- STEP 3: Select only the final, clean, unique rows (where rn = 1)
SELECT
  order_id,
  cleaned_customer_name,
  email,
  cleaned_product_name,
  price,
  cleaned_country,
  cleaned_order_status,
  cleaned_quantity,
  cleaned_order_date,
  day_of_week,
  notes
FROM
  deduplicated_data 
WHERE
  rn = 1;

-- ================================================
-- Project: Business Performance 360 Dashboard
-- Author: Keshav Chandra Kumar
-- Tools: SQL, Power BI, Excel, Pandas, Power Query
-- ================================================

-- 1. Total net sales kitni hai
SELECT 
    ROUND(SUM(sales_amount), 2) AS total_net_sales
FROM sales.transactions;

-- 2. Har market ka total sales
SELECT 
    m.markets_name,
    ROUND(SUM(t.sales_amount), 2) AS total_sales
FROM sales.transactions t
JOIN sales.markets m ON t.market_code = m.markets_code
GROUP BY m.markets_name
ORDER BY total_sales DESC;

-- 3. Har saal ka total revenue
SELECT 
    d.year,
    ROUND(SUM(t.sales_amount), 2) AS yearly_revenue
FROM sales.transactions t
JOIN sales.date d ON t.order_date = d.date
GROUP BY d.year
ORDER BY d.year;

-- 4. Har mahine ka sales trend
SELECT 
    d.year,
    d.month_name,
    ROUND(SUM(t.sales_amount), 2) AS monthly_sales
FROM sales.transactions t
JOIN sales.date d ON t.order_date = d.date
GROUP BY d.year, d.month_name
ORDER BY d.year, monthly_sales DESC;

-- 5. Top 5 customers by revenue
SELECT 
    c.custmer_name,
    ROUND(SUM(t.sales_amount), 2) AS total_revenue
FROM sales.transactions t
JOIN sales.customers c ON t.customer_code = c.customer_code
GROUP BY c.custmer_name
ORDER BY total_revenue DESC
LIMIT 5;

-- 6. Top 5 products by sales
SELECT 
    product_code,
    ROUND(SUM(sales_amount), 2) AS total_sales,
    SUM(sales_qty) AS total_quantity
FROM sales.transactions
GROUP BY product_code
ORDER BY total_sales DESC
LIMIT 5;

-- 7. Market wise profit margin
SELECT 
    m.markets_name,
    ROUND(SUM(t.sales_amount), 2) AS total_sales,
    ROUND(SUM(t.profit_margin), 2) AS total_profit,
    ROUND(SUM(t.profit_margin) * 100.0 / SUM(t.sales_amount), 2) AS profit_margin_pct
FROM sales.transactions t
JOIN sales.markets m ON t.market_code = m.markets_code
GROUP BY m.markets_name
ORDER BY profit_margin_pct DESC;

-- 8. Year over year growth
SELECT 
    d.year,
    ROUND(SUM(t.sales_amount), 2) AS total_sales,
    LAG(ROUND(SUM(t.sales_amount), 2)) OVER (ORDER BY d.year) AS prev_year_sales,
    ROUND((SUM(t.sales_amount) - LAG(SUM(t.sales_amount)) OVER (ORDER BY d.year)) 
          * 100.0 / LAG(SUM(t.sales_amount)) OVER (ORDER BY d.year), 2) AS growth_pct
FROM sales.transactions t
JOIN sales.date d ON t.order_date = d.date
GROUP BY d.year
ORDER BY d.year;

-- 9. Customer segment performance
SELECT 
    c.customer_type,
    COUNT(DISTINCT t.customer_code) AS total_customers,
    ROUND(SUM(t.sales_amount), 2) AS total_revenue,
    ROUND(AVG(t.sales_amount), 2) AS avg_order_value
FROM sales.transactions t
JOIN sales.customers c ON t.customer_code = c.customer_code
GROUP BY c.customer_type
ORDER BY total_revenue DESC;

-- 10. Low performing markets (bottom 3)
SELECT 
    m.markets_name,
    ROUND(SUM(t.sales_amount), 2) AS total_sales
FROM sales.transactions t
JOIN sales.markets m ON t.market_code = m.markets_code
GROUP BY m.markets_name
ORDER BY total_sales ASC
LIMIT 3;

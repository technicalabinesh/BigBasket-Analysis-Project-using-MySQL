
-- =====================================================
-- PROJECT: BIGBASKET CUSTOMER PURCHASE ANALYSIS
-- DATABASE: MySQL 8.0
-- =====================================================

CREATE DATABASE bigbasket_project;
USE bigbasket_project;

-- 1. CREATE TABLE

CREATE TABLE bigbasket_orders (
    Member VARCHAR(20) NOT NULL,
    `Order` VARCHAR(30) NOT NULL,
    SKU VARCHAR(30) NOT NULL,
    `Created On` DATETIME NOT NULL,
    Description VARCHAR(255) NOT NULL,
    
    PRIMARY KEY (`Order`, SKU)
);

-- 2. INSERT SAMPLE DATA

INSERT INTO bigbasket_orders
(Member, `Order`, SKU, `Created On`, Description)
VALUES
('M001', 'ORD1001', 'SKU101', '2026-01-05 09:15:00', 'Fresh Milk'),
('M001', 'ORD1001', 'SKU102', '2026-01-05 09:15:00', 'Brown Bread'),
('M002', 'ORD1002', 'SKU103', '2026-01-06 10:30:00', 'Basmati Rice'),
('M003', 'ORD1003', 'SKU104', '2026-01-06 14:45:00', 'Cooking Oil'),
('M001', 'ORD1004', 'SKU105', '2026-01-08 18:20:00', 'Eggs'),
('M004', 'ORD1005', 'SKU101', '2026-01-10 08:10:00', 'Fresh Milk'),
('M002', 'ORD1006', 'SKU106', '2026-01-12 11:00:00', 'Apples'),
('M005', 'ORD1007', 'SKU107', '2026-01-12 16:25:00', 'Biscuits'),
('M003', 'ORD1008', 'SKU102', '2026-01-15 12:40:00', 'Brown Bread'),
('M004', 'ORD1009', 'SKU103', '2026-01-18 19:05:00', 'Basmati Rice'),
('M001', 'ORD1010', 'SKU106', '2026-02-02 09:35:00', 'Apples'),
('M005', 'ORD1011', 'SKU104', '2026-02-04 13:15:00', 'Cooking Oil'),
('M002', 'ORD1012', 'SKU101', '2026-02-07 17:50:00', 'Fresh Milk'),
('M003', 'ORD1013', 'SKU107', '2026-02-10 10:20:00', 'Biscuits'),
('M004', 'ORD1014', 'SKU105', '2026-02-14 15:30:00', 'Eggs');

-- 3. VIEW ALL RECORDS

SELECT *
FROM bigbasket_orders;

-- 4. COUNT TOTAL ORDERS

SELECT COUNT(DISTINCT `Order`) AS total_orders
FROM bigbasket_orders;

-- 5. COUNT UNIQUE CUSTOMERS

SELECT COUNT(DISTINCT Member) AS total_customers
FROM bigbasket_orders;

-- 6. TOP 5 MOST PURCHASED PRODUCTS

SELECT
    SKU,
    Description,
    COUNT(*) AS purchase_count
FROM bigbasket_orders
GROUP BY SKU, Description
ORDER BY purchase_count DESC
LIMIT 5;

-- 7. CUSTOMER ORDER FREQUENCY

SELECT
    Member,
    COUNT(DISTINCT `Order`) AS total_orders
FROM bigbasket_orders
GROUP BY Member
ORDER BY total_orders DESC;

-- 8. DAILY ORDER COUNT

SELECT
    DATE(`Created On`) AS order_date,
    COUNT(DISTINCT `Order`) AS total_orders
FROM bigbasket_orders
GROUP BY DATE(`Created On`)
ORDER BY order_date;

-- 9. MONTHLY ORDER COUNT

SELECT
    DATE_FORMAT(`Created On`, '%Y-%m') AS order_month,
    COUNT(DISTINCT `Order`) AS total_orders
FROM bigbasket_orders
GROUP BY DATE_FORMAT(`Created On`, '%Y-%m')
ORDER BY order_month;

-- 10. CUSTOMERS WHO PURCHASED MORE THAN 2 ORDERS

SELECT
    Member,
    COUNT(DISTINCT `Order`) AS total_orders
FROM bigbasket_orders
GROUP BY Member
HAVING COUNT(DISTINCT `Order`) > 2;

-- 11. PRODUCTS PURCHASED BY EACH CUSTOMER

SELECT
    Member,
    Description,
    COUNT(*) AS times_purchased
FROM bigbasket_orders
GROUP BY Member, Description
ORDER BY Member, times_purchased DESC;

-- 12. REPEAT CUSTOMERS

SELECT
    Member,
    COUNT(DISTINCT `Order`) AS total_orders
FROM bigbasket_orders
GROUP BY Member
HAVING COUNT(DISTINCT `Order`) > 1;

-- 13. MOST RECENT PURCHASE FOR EACH CUSTOMER

WITH ranked_orders AS (
    SELECT
        Member,
        `Order`,
        SKU,
        `Created On`,
        Description,
        ROW_NUMBER() OVER (
            PARTITION BY Member
            ORDER BY `Created On` DESC, `Order` DESC
        ) AS rn
    FROM bigbasket_orders
)
SELECT
    Member,
    `Order`,
    SKU,
    `Created On`,
    Description
FROM ranked_orders
WHERE rn = 1;

-- 14. PEAK PURCHASE HOURS

SELECT
    HOUR(`Created On`) AS purchase_hour,
    COUNT(DISTINCT `Order`) AS total_orders
FROM bigbasket_orders
GROUP BY HOUR(`Created On`)
ORDER BY total_orders DESC;

-- 15. CUSTOMERS WHO BOUGHT FRESH MILK

SELECT DISTINCT Member
FROM bigbasket_orders
WHERE Description = 'Fresh Milk';

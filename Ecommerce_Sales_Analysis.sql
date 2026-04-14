use ecommerce;

CREATE TABLE ecommerce (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description TEXT,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    CustomerID INT,
    Country VARCHAR(100)
);

SET GLOBAL local_infile = 1;

-- Load

LOAD DATA LOCAL INFILE 'C:/Users/LENOVO/Downloads/archive (4)/data.csv'
INTO TABLE ecommerce
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(InvoiceNo, StockCode, Description, Quantity, UnitPrice, CustomerID, Country);

SET SQL_SAFE_UPDATES = 0;

SELECT COUNT(*) FROM ecommerce;

-- Transform

-- Handle Missing CustomerID
UPDATE ecommerce
SET CustomerID = NULL
WHERE CustomerID = 0;
SET SQL_SAFE_UPDATES = 0;

-- Remove Cancelled Orders
DELETE FROM ecommerce
WHERE InvoiceNo LIKE 'C%';

-- Remove Invalid Quantity

DELETE FROM ecommerce
WHERE Quantity <= 0;

-- Remove Invalid Price

DELETE FROM ecommerce
WHERE UnitPrice <= 0;

-- Add Revenue Column

ALTER TABLE ecommerce ADD COLUMN Revenue DECIMAL(10,2);

-- Calculate Revenue
UPDATE ecommerce
SET Revenue = Quantity * UnitPrice;


SELECT Country, SUM(Quantity * UnitPrice) AS Revenue
FROM ecommerce
GROUP BY Country
ORDER BY Revenue DESC;

SELECT SUM(Quantity * UnitPrice) AS TotalRevenue FROM ecommerce;

SELECT COUNT(DISTINCT CustomerID) FROM ecommerce;


SELECT Country, 
       SUM(Quantity * UnitPrice) AS Revenue,
       COUNT(*) AS Transactions
FROM ecommerce
GROUP BY Country
ORDER BY Revenue DESC;


SELECT Description, 
       SUM(Quantity * UnitPrice) AS Revenue
FROM ecommerce
GROUP BY Description
ORDER BY Revenue DESC
LIMIT 10;

select * from ecommerce;
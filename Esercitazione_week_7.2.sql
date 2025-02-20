SHOW DATABASES;
USE AdventureWorksDW;
SHOW TABLES;

SELECT * FROM dimproduct;							-- 606 record				
SELECT * FROM dimproductsubcategory;				-- 37 record
SELECT * FROM dimproductcategory;					-- 4 record

-- Creare una VISTA Product con campi: prodotto, Subcategory, e Category
CREATE VIEW Product AS
SELECT P.ProductKey AS productID, P.EnglishProductName AS Product,
	IFNULL(S.EnglishProductSubcategoryName, 'NA') AS Subcategory,
	IFNULL(C.EnglishProductCategoryName, 'NA') AS Category
FROM dimproduct AS P LEFT JOIN dimproductsubcategory AS S ON P.ProductSubcategoryKey = S.ProductSubcategoryKey 
LEFT JOIN dimproductcategory AS C ON S.ProductCategoryKey = C.ProductCategoryKey;

SELECT * FROM Product;								-- 606 record


-- Creare una VISTA Reseller: nome rivenditore, Città, Regione
SELECT * FROM dimreseller;							-- 701 record
SELECT * FROM dimgeography;							-- 655 record

CREATE VIEW Reseller AS
SELECT R.ResellerKey AS resellerID, R.ResellerName, G.City, G.EnglishCountryRegionName AS Region
FROM dimreseller AS R JOIN dimgeography AS G ON R.GeographyKey = G.GeographyKey;
 
SELECT * FROM Reseller;								-- 701 record


-- 3. Vista Sales
SELECT * FROM factresellersales;	

CREATE VIEW Sales AS
SELECT s.OrderDate, s.SalesOrderNumber, s.SalesOrderLineNumber, p.ProductKey AS productID,
	d.ResellerKey AS resellerID, s.OrderQuantity as Quantità, s.SalesAmount AS Totale_Vendite,
	ROUND(SUM(s.SalesAmount - IFNULL(s.TotalProductCost, 0)), 2) AS Profitto
FROM dimproduct AS p JOIN factresellersales AS s ON p.ProductKey = s.ProductKey
JOIN dimreseller AS d ON s.ResellerKey = d.ResellerKey
GROUP BY s.OrderDate, s.OrderQuantity, s.SalesOrderNumber, s.SalesOrderLineNumber, s.SalesAmount, d.ResellerKey, p.ProductKey;

SELECT * FROM Sales;								-- 50000 record

SELECT * FROM Sales WHERE Profit < 0; 			    -- Visualizzo i profitti minori di 0
SELECT * FROM Sales ORDER BY Profit;                -- Ordino ASC: dal profitto minore a quello maggiore
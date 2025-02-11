USE AdventureWorksDW;
SELECT * FROM dimproduct;
SELECT * FROM dimproductsubcategory;

-- 1. Esponi l'anagrafica dei prodotti indicando per ciascun prodotto anche la sua sottocategoria.
SELECT dimproduct.ProductKey, dimproduct.EnglishProductName, dimproductsubcategory.EnglishProductSubcategoryName
FROM dimproduct LEFT JOIN dimproductsubcategory
ON dimproduct.ProductSubcategoryKey = dimproductsubcategory.ProductSubcategoryKey;


-- 2. Esponi l'anagrafica dei prodotti indicando per ciascun prodotto la sua sottocategoria e categoria.
SELECT dimproduct.ProductKey, dimproduct.EnglishProductName AS NameProduct, dimproductsubcategory.EnglishProductSubcategoryName AS NameSubcategory, dimproductcategory.EnglishProductCategoryName AS NameCategory
FROM dimproduct JOIN dimproductsubcategory
ON dimproduct.ProductSubcategoryKey = dimproductsubcategory.ProductSubcategoryKey
JOIN dimproductcategory
ON dimproductsubcategory.ProductCategoryKey = dimproductcategory.ProductCategoryKey;


-- 3. Elenco dei soli prodotti venduti -> solo per quelli che hanno la corrispondenza dell'ordine, senza i NULL.
SELECT dimproduct.ProductKey, dimproduct.EnglishProductName AS NameProduct, factresellersales.SalesOrderNumber AS NumeroOrdine
FROM dimproduct RIGHT JOIN factresellersales
ON dimproduct.ProductKey = factresellersales.ProductKey;

-- 	Se si usasse una Subquery.
SELECT ProductKey, EnglishProductName, StandardCost, Color, ListPrice, Size, FinishedGoodsFlag
FROM dimproduct
WHERE ProductKey IN (SELECT ProductKey FROM factresellersales);     -- si selezionano tutti i prodotti dove il Productkey (PK) è nei prodotti venduti.

-- 4. Elenco dei prodotti non venduti (si considerano solo i prodotti finiti dove FinishedGoodsFlag = 1).
SELECT ProductKey, EnglishProductName AS NomeProdotto, StandardCost, Color, ListPrice, Size, FinishedGoodsFlag
FROM dimproduct
WHERE ProductKey NOT IN (SELECT ProductKey FROM factresellersales) AND FinishedGoodsFlag =1;	-- Subquery

-- 5. Esponi l'elenco delle transazioni di vendita (FactResellerSales) indicando anche il nome del prodotto venduto (dimproduct).
SELECT factresellersales.SalesOrderNumber, factresellersales.OrderDate, factresellersales.SalesAmount, dimproduct.EnglishProductName
FROM factresellersales JOIN dimproduct
ON dimproduct.ProductKey = factresellersales.ProductKey;			-- 1000 RIGHE

-- 	Restituisce in tutti e due i casi 1000 righe.
SELECT P.ProductKey, P.EnglishProductName AS ProductName, F.SalesOrderNumber, F.OrderDate, F.SalesAmount
FROM dimproduct AS P RIGHT JOIN factresellersales AS F
ON P.ProductKey = F.ProductKey
ORDER BY SalesAmount;

-- Recuperare dati del Prodotto che è stato venduto come ULTIMA transazione --> MAX (il più alto = più recente).
SELECT P.ProductKey, P.EnglishProductName AS ProductName, P.StandardCost, F.OrderDate
FROM dimproduct AS P INNER JOIN factresellersales AS F ON P.ProductKey = F.ProductKey
WHERE F.OrderDate = (SELECT MAX(OrderDate) FROM factresellersales)     -- SUBQUERY INTERNA (dal SELECT)
ORDER BY StandardCost DESC;


-- 1. Esponi l'elenco delle transazioni di vendita indicando la categoria di appartenenza di ciascun prodotto venduto. 
SELECT * FROM factresellersales;

SELECT F.SalesOrderNumber, F.OrderDate, F.SalesAmount, P.EnglishProductName AS ProductName, P.ProductKey, C.EnglishProductCategoryName AS CategoryProduct
FROM factresellersales AS F JOIN dimproduct AS P ON F.ProductKey = P.ProductKey
LEFT JOIN dimproductsubcategory ON P.ProductSubcategoryKey = dimproductsubcategory.ProductSubcategoryKey
LEFT JOIN dimproductcategory AS C ON dimproductsubcategory.ProductCategoryKey = C.ProductCategoryKey
ORDER BY OrderDate;

-- 2. Esponi in output l'elenco dei reseller indicando, per ciascun reseller, anche la sua area geografica. (DimReseller)
SELECT * FROM dimreseller;
SELECT  ResellerKey, ResellerName AS NomeRivenditore, GeographyKey FROM dimreseller;    -- 701 TIGHE

SELECT DISTINCT GeographyKey FROM dimreseller;     -- 510 RIGHE
SELECT * FROM dimgeography;						-- 655 RIGHE	Non tutte le aree geografiche hanno un Rivenditore, FK = PK.

SELECT R.ResellerKey, R.ResellerName AS NomeRivenditore, R.GeographyKey, G.City, G.StateProvinceName
FROM dimreseller AS R LEFT JOIN dimgeography AS G ON R.GeographyKey = G.GeographyKey;		-- ritorna anche Città e Stato, 701 RIGHE

SELECT P.ResellerKey, P.ResellerName AS NomeRivenditore, P.AnnualRevenue, P.GeographyKey, G.City, G.StateProvinceName
FROM dimreseller AS P JOIN dimgeography AS G ON P.GeographyKey = G.GeographyKey
WHERE AnnualRevenue > (SELECT AVG(AnnualRevenue) FROM dimreseller); 		-- Dove è > della media. 204 RIGHE


-- 3. Esponi l'elenco delle transazioni di vendita. Il result set deve esporre i campi: SalesOrderNumber, 
-- SalesOrderLineNumber, OrderDate, UnitPrice, Quantity, TotalProductCost.
-- Il result set deve anche indicare il nome del prodotto, il nome della categoria del prodotto, il nome del reseller e l'area geografica.
SELECT F.SalesOrderNumber, F.SalesOrderLineNumber, F.OrderDate, F.UnitPrice, F.OrderQuantity, F.TotalProductCost,
P.ProductKey, P.EnglishProductName AS ProductName, C.EnglishProductCategoryName AS NameCategory, R.ResellerName AS NomeRivenditore,
R.GeographyKey, G.StateProvinceName
FROM factresellersales AS F
JOIN dimproduct AS P ON F.ProductKey = P.ProductKey
JOIN dimproductsubcategory ON P.ProductSubcategoryKey = dimproductsubcategory.ProductSubcategoryKey
JOIN dimproductcategory AS C ON dimproductsubcategory.ProductCategoryKey = C.ProductCategoryKey
JOIN dimreseller AS R ON F.ResellerKey = R.ResellerKey
JOIN dimgeography AS G ON R.GeographyKey = G.GeographyKey; 			-- 1000 RIGHE





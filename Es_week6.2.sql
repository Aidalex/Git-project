USE AdventureWorksDW;
SELECT * FROM dimproduct;
SELECT * FROM dimproductsubcategory;

-- 1. Esponi l'anagrafica dei prodotti indicando per ciascun prodotto anche la sua sottocategoria.
SELECT dimproduct.ProductKey, dimproduct.EnglishProductName, dimproductsubcategory.EnglishProductSubcategoryName
FROM dimproduct LEFT JOIN dimproductsubcategory
ON dimproduct.ProductSubcategoryKey = dimproductsubcategory.ProductSubcategoryKey;


-- 2. Esponi l'anagrafica dei prodotti indicando per ciascun prodotto la sua sottocategoria e categoria.
SELECT dimproduct.ProductKey, dimproduct.EnglishProductName AS NameProduct, dimproductsubcategory.EnglishProductSubcategoryName AS NameSubcategory, dimproductcategory.EnglishProductCategoryName AS NameCategory
FROM dimproduct  JOIN dimproductsubcategory
ON dimproduct.ProductSubcategoryKey = dimproductsubcategory.ProductSubcategoryKey
JOIN dimproductcategory
ON dimproductsubcategory.ProductCategoryKey = dimproductcategory.ProductCategoryKey;


-- 3. Elenco dei soli prodotti venduti -> solo per quelli che hanno la corrispondenza dell'ordine, senza i NULL
SELECT dimproduct.ProductKey, dimproduct.EnglishProductName AS NameProduct, factresellersales.SalesOrderNumber AS NumeroOrdine
FROM dimproduct RIGHT JOIN factresellersales
ON dimproduct.ProductKey = factresellersales.ProductKey;

-- se si usasse una Subquery
SELECT ProductKey, EnglishProductName, StandardCost, Color, ListPrice, Size, FinishedGoodsFlag
FROM dimproduct
WHERE ProductKey IN (SELECT ProductKey FROM factresellersales);     -- si selezionano tutti i prodotti dove il Productkey è nei prodotti venduti

-- 4. Elenco dei prodotti non venduti (si considerano solo i prodotti finiti dove FinishedGoodsFlag = 1)
SELECT ProductKey, EnglishProductName AS NomeProdotto, StandardCost, Color, ListPrice, Size, FinishedGoodsFlag
FROM dimproduct
WHERE ProductKey NOT IN (select ProductKey from factresellersales) AND FinishedGoodsFlag =1;

-- 5. Esponi l'elenco delle transazioni di vendita (
SELECT factresellersales.SalesOrderNumber, factresellersales.OrderDate, factresellersales.SalesAmount, dimproduct.EnglishProductName
FROM factresellersales JOIN dimproduct
ON dimproduct.ProductKey = factresellersales.ProductKey;

-- recuperare dati del Prodotto che è stato venduto come ULTIMA transazione --> MAX (il più alto = più recente)
SELECT P.ProductKey, P.EnglishProductName AS ProductName, P.StandardCost, F.OrderDate
FROM dimproduct AS P INNER JOIN factresellersales AS F ON P.ProductKey = F.ProductKey
WHERE F.OrderDate = (SELECT MAX(OrderDate) FROM factresellersales)     -- INTERNA (dal SELECT)
ORDER BY StandardCost DESC;


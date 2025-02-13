SHOW DATABASES;
USE AdventureWorksDW;
SHOW TABLES;


-- 1. Scrivere una query per verificare che il campo ProductKey nella Tabella DimProduct sia una chiave primaria.
-- queli considerazioni/ragionamenti è necessario che si faccia?
DESCRIBE dimproduct;				-- risulta come PK e non può essere NULL.
SHOW KEYS FROM dimproduct;			-- mi restituisce la tipologia delle CHIAVI

SELECT * FROM dimproduct;			-- ritorna 606 RIGHE
SELECT COUNT(ProductKey) AS numeroProdotti FROM dimproduct;		-- 606 = PK non conterebbe i NULL

SELECT DISTINCT COUNT(ProductKey) FROM dimproduct;				-- ritorna sempre 606 -> PK 

SELECT ProductKey, COUNT(*) AS uniche							-- con il COUNT se c'è qualcosa NULL non lo conta 606
FROM dimproduct
GROUP BY ProductKey
HAVING uniche > 1;					-- non resituisce risultato: è univoco.


SELECT COUNT(*)
FROM dimproduct
WHERE ProductKey = NULL;			-- non restituisce risultati, non potrebbero essereci risultati nulli.


-- 2. verificare che la combinazione dei campi SalesOrderNumber e SalesOrderLineNumber del factresellersales sono PK.
SHOW KEYS FROM factresellersales;

-- 3. Conta il numero transazioni (SalesOrderLineNumber) realizzate ogni giorno a partire dal 1/01/2020.
SELECT * FROM factresellersales;
SELECT F.OrderDate, COUNT(F.SalesOrderLineNumber) AS NumeroTransazioni
FROM factresellersales AS F
GROUP BY OrderDate
HAVING OrderDate >= '2020-01-01';

-- 4. Calcola il fatturato totale (FactResellerSales.SalesAmount), la q.tà totale vednuta (FactResellerSales.OrderQuantity)
-- e il Prezzo medio di vendita (FactResellerSales.UnitPrice) per prodotto (dimproduct) a partire dal 1/1/2020.
-- Il result set deve esporre pertanto il nome del prodotto, il fatturato totale, la q.tà totale venduta e il Prezzo medio di vendita.
-- I campi in output devono essere parlanti!

SELECT * FROM factresellersales;
SELECT dimproduct.EnglishProductName, factresellersales.orderdate,
	SUM(factresellersales.salesamount) AS fatturatoTotale,
    SUM(factresellersales.OrderQuantity) AS quantitaTotale,
    ROUND(AVG(factresellersales.UnitPrice), 2) AS prezzoMedio
FROM dimproduct JOIN factresellersales ON dimproduct.ProductKey = factresellersales.ProductKey
WHERE factresellersales.OrderDate >= '2020-01-01'
GROUP BY dimproduct.EnglishProductName;					-- facciamo prima il filtro con il WHERE


-- 1.2 Calcolo il fatturata totale (FactResellerSales.SalesAmount) e la q.tà totale venduta (FactResellerSales.OrderQuantity) per Categoria prodotto (dimproductCategory).
-- Il result set deve esporre pertanto il nome della categoria prodotto, il fatturato totale e la q.tà totale venduta. 
-- I campi in output devono essere parlanti!
SELECT C.EnglishProductCategoryName,
	SUM(F.SalesAmount) AS fatturatoTotale,
	SUM(F.OrderQuantity) AS qtaTotale
FROM factresellersales AS F JOIN dimproduct AS P ON F.ProductKey = P.ProductKey
JOIN dimproductsubcategory JOIN dimproductcategory AS C ON dimproductsubcategory.ProductCategoryKey = C.ProductCategoryKey
GROUP BY C.EnglishProductCategoryName;


-- 2.2 Calcolo il fatturato totale per area città (dimgeography.City) realizzato a partire dal 1/01/2020.
-- Il result set deve esporre l'elenco delle città con fatturato realizzato superiore a 60K

SELECT G.City, SUM(F.SalesAmount) AS fatturatoTotale
FROM factresellersales AS F JOIN dimreseller AS R ON F.ResellerKey = R.ResellerKey
JOIN dimgeography AS G ON R.GeographyKey = G.GeographyKey
WHERE F.OrderDate >= '2020-01-01'
GROUP BY G.City
HAVING fatturatoTotale > 60000;							-- 65 righe

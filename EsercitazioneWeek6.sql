USE AdventureWorksDW;  -- uso il database Adventure
SHOW tables;    -- vedo le tabelle dentro il database
SELECT * FROM dimproduct WHERE ProductSubcategoryKey IS NOT NULL;    -- prendo solo la tabella DimProduct SENZA I NULLI

-- Eseguire una query: Visualizzazione output dei campi e il campo FinishedGoodsFlag = 1
SELECT ProductKey, ProductAlternateKey AS Codice, EnglishProductName, Color, StandardCost, FinishedGoodsFlag AS ProdottiFiniti
FROM dimproduct 
WHERE ProdottiFiniti = 1;  

-- Eseguire una nuova query: Visualizzazione output dei campi ProductKey, ProductAlternateKey, NomeProdotto, CostoSTD, PrezzoListinodimsalesterritory
-- e che il ProductAlternateKey che cominci per FR o BK. 
SELECT ProductKey AS CodProdotto, ProductAlternateKey, EnglishProductName AS NomeProdotto, StandardCost, ListPrice AS PrezzoListino
FROM dimproduct
WHERE ProductAlternateKey LIKE 'FR%' OR ProductAlternateKey LIKE 'BK%';

-- si aggiunga il Markup (ListPrice - StandardCost)
SELECT ProductKey AS CodProdotto, ProductAlternateKey, EnglishProductName AS NomeProdotto, StandardCost, ListPrice, ListPrice - StandardCost AS Markup
FROM dimproduct
WHERE ProductAlternateKey LIKE 'FR%' OR ProductAlternateKey LIKE 'BK%';

-- Eseguire una query: Visualizzazione output dei prodotti finiti con listino prezzo tra i 1000 e i 2000.
SELECT * FROM dimproduct 
WHERE FinishedGoodsFlag = 1 AND ListPrice BETWEEN 1000 AND 2000;

-- Visualizzare solo la tabella Impiegati
SELECT * FROM dimemployee;

-- Eseguire una Query: Elenco degli Agenti dalla tabella Impiegati
SELECT EmployeeKey, FirstName AS Nome, LastName AS Cognome, SalesPersonFlag
FROM dimemployee
WHERE SalesPersonFlag = 1;

-- Eseguire una query: Visualizzazione output delle Vendite (FactResellerSales)
SELECT * FROM factresellersales;

-- Interroga la tabella delle vendite (FactResellerSales). Esponi in output lʼelenco delle transazioni registrate a partire dal 1 gennaio 2020 
-- dei soli codici prodotto: 597, 598, 477, 214. Calcola per ciascuna transazione il profitto (SalesAmount - TotalProductCost).
SELECT * FROM factresellersales WHERE DueDate >= '2020-01-01' AND ProductKey IN (597,598,477,214);
SELECT * FROM factresellersales;
SELECT DueDate, ProductKey, SalesAmount - TotalProductCost AS Profitto FROM factresellersales WHERE DueDate >= '2020-01-01' 
AND ProductKey IN (597,598,477,214)
ORDER BY Profitto DESC;

CREATE TABLE Sales(
		SalesID int NOT NULL,
		OrderID int NOT NULL,
		Customer varchar(100) NOT NULL,
		Product varchar(100) NOT NULL,
		Date int NOT NULL,
		Quantity float NOT NULL,
		UnitPrice float NOT NULL)
CREATE TABLE Profit(
		Product varchar(100) NOT NULL,
		ProfitRatio float NOT NULL)
go
INSERT INTO Sales(SalesID, OrderID, Customer, Product, Date, Quantity, UnitPrice)
VALUES
(1, 1, 'C1', 'P1', 1, 2, 100),
(2, 1, 'C1', 'P2', 1, 4, 150),
(3, 2, 'C2', 'P2', 1, 5, 150),
(4, 3, 'C3', 'P4', 1, 3, 550),
(5, 4, 'C4', 'P3', 1, 1, 300), 
(6, 4, 'C4', 'P6', 1, 6, 150), 
(7, 4, 'C4', 'P4', 1, 6, 550), 
(8, 5, 'C5', 'P2', 1, 3, 150), 
(9, 5, 'C5', 'P1', 1, 6, 100), 
(10, 6, 'C2', 'P3', 2, 1, 300), 
(11, 6, 'C2', 'P4', 2, 3, 550), 
(12, 6, 'C2', 'P5', 2, 6, 400), 
(13, 6, 'C2', 'P1', 2, 4, 100), 
(14, 7, 'C4', 'P6', 2, 3, 150), 
(15, 8, 'C6', 'P3', 2, 2, 300), 
(16, 8, 'C6', 'P4', 2, 3, 550), 
(17, 9, 'C7', 'P1', 2, 5, 100), 
(18, 9, 'C7', 'P2', 2, 3, 150), 
(19, 9, 'C7', 'P3', 2, 1, 300), 
(20, 10, 'C1', 'P4', 3, 6, 550), 
(21, 11, 'C2', 'P5', 3, 3, 400), 
(22, 12, 'C8', 'P1', 3, 6, 100), 
(23, 12, 'C8', 'P3', 3, 3, 300), 
(24, 12, 'C8', 'P5', 3, 5, 400), 
(25, 13, 'C9', 'P2', 3, 2, 150)
go
INSERT INTO Profit(Product, ProfitRatio)
VALUES
 ('P1', 5 ),
 ('P2', 25),
 ('P3', 10),
 ('P4', 20),
 ('P5', 10)
INSERT INTO Profit
SELECT DISTINCT Product,10 FROM Sales WHERE Product NOT IN (SELECT DISTINCT Product FROM Profit)
go
-----------------------------
-----------------------------
--Question 1:
SELECT SUM(Quantity*UnitPrice) FROM Sales
go
--Question 2:
SELECT COUNT(DISTINCT Customer) FROM Sales
go
--Question 3:
SELECT Product, SUM(Quantity) FROM Sales GROUP BY Product
go
--Question 4:
SELECT DISTINCT Customer INTO #CUST FROM Sales WHERE OrderID IN 
	(SELECT OrderID FROM Sales GROUP BY OrderID HAVING SUM(Quantity*UnitPrice)>1500 )

SELECT Customer,SUM(Quantity*UnitPrice) AS NetAmount,COUNT(DISTINCT OrderID) AS SalesOrderQty,COUNT(SalesID) AS SalesItemQty
	FROM Sales WHERE Customer IN (SELECT Customer FROM #CUST) GROUP BY Customer 
go
--Question 5:
SELECT ROUND(SUM(S.Quantity*S.UnitPrice*P.ProfitRatio/100.0),2) AS ProfitAmount,
	   ROUND(SUM(S.Quantity*S.UnitPrice*P.ProfitRatio/100.0)/SUM(Quantity*UnitPrice)*100.0,2) AS ProfitPercentage
	FROM Sales S JOIN Profit P ON S.Product=P.Product
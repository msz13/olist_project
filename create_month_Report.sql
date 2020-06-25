CREATE TABLE Analitics.MonthReport (
    Year SMALLINT,
    Month TINYINT,
    Sales INT,
    NumberOfOrders Int,
    AverageOrderValue DECIMAL(5,2),
    NumberOfItems INT,
    NumberOfActiveCustomers INT,
    RetainedCustomers INT
)
GO

CREATE PROCEDURE dbo.CreateKPIMonthReport (
@yearFrom as SMALLINT,
@monthFrom as TINYINT
)
AS BEGIN
INSERT INTO Analitics.MonthReport
SELECT YEAR(OrderApprovedAt) AS Year, MONTH(OrderApprovedAt) AS MONTH, 
SUM(ItemsValue) AS Sales, COUNT(OrderId) AS NumberOfOrders, 
TRY_CAST(AVG(ItemsValue) AS decimal(5,2)) AS AverageOrderValue, 
SUM(NumberOfItems) AS NumberOfItems,
COUNT(DISTINCT CustomerId) AS NumberOfActiveCustomers, 
COUNT(DISTINCT CASE WHEN MonthsFromFirstPurchase > 0 THEN CustomerID ELSE NULL END) AS RetainedCustomersRatio
FROM [Analitics].OrdersSummary
WHERE  YEAR(OrderApprovedAt) >= @yearFrom AND MONTH(OrderApprovedAt) >= @monthFrom
GROUP BY YEAR(OrderApprovedAt), MONTH(OrderApprovedAt)
ORDER BY [YEAR], [MONTH]
END

GO
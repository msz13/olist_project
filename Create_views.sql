CREATE SCHEMA Analitics
GO


CREATE VIEW [Analitics].OrdersSummary
AS 
WITH
orderitems (OrderId, ItemsValue, NumberOfItems)
AS
(
SELECT OrderId, SUM(Price) AS ItemsValue, MAX(OrderItemId) NumberOfItems
FROM dbo.OrderItems
GROUP BY OrderId
),
customerInfo(CustomerId, FirstPurchaseAt)
AS
(
    SELECT CustomerId, MIN(OrderApprovedAt) AS FirstPurchase
    FROM dbo.Orders
    GROUP By CustomerId
)
SELECT o.OrderId,
o.OrderApprovedAt,
o.CustomerId,
i.ItemsValue,
i.NumberOfItems,
c.FirstPurchaseAt,
DATEDIFF(month, c.FirstPurchaseAt, o.OrderApprovedAt) AS MonthsFromFirstPurchase
FROM dbo.Orders AS o
JOIN customerInfo AS c 
ON o.CustomerId = c.CustomerId
JOIN orderitems AS i 
ON o.OrderId = i.OrderId
WHERE OrderStatus = 'delivered'
GO
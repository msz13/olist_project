-- Create a new table calAnalitics '[SellersKPI]' in schema '[dbo]'
-- Drop the table if it already exists
IF OBJECT_ID('[Analitics].[SellersKPI]', 'U') IS NOT NULL
DROP TABLE [Analitics].[SellersKPI]
GO
-- Create the table in the specified schema
CREATE TABLE [Analitics].[SellersKPI]
(
    SellerId UNIQUEIDENTIFIER PRIMARY KEY,
    ReportDayFrom DATE,
    ReportDayTo DATE,
    Tenure INT,
    ItemsSold INT,
    Recency INT,    
    Revenue DECIMAL(8,2)
);
GO

-- Create a new stored procedure called 'CreateSellersKPI' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'CreateSellersKPI'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.CreateSellersKPI
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.CreateSellersKPI
    @dateFrom DATE,
    @dateTo DATE
AS
        INSERT INTO [Analitics].[SellersKPI]
        SELECT SellerId, 
        @dateFrom ReportDateFrom,
        @dateTo ReportDateTo,
        DATEDIFF(WEEK, MIN(OrderDeliveredCustomerDate),@dateTo) + 1 AS Tenure, 
        COUNT(Id) ItemsSold, 
        DATEDIFF(WEEK, MAX(OrderDeliveredCustomerDate), @dateTo) + 1 AS Recency, 
        SUM(Price) Revenue 
    FROM dbo.OrderItems as i 
    JOIN dbo.Orders AS o 
    ON i.OrderId = o.OrderId
    WHERE OrderDeliveredCustomerDate >=@dateFrom AND OrderDeliveredCustomerDate <= @dateTo
    GROUP BY i.SellerId
GO




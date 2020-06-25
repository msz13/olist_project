CREATE TABLE [dbo].[Orders](
	[OrderId] [uniqueidentifier] NOT NULL PRIMARY KEY,
	[CustomerId] [uniqueidentifier] NULL,
	[OrderStatus] [nvarchar](50) NULL,
    [CustomerZipCode] [int] NULL,
	[OrderPurchaseTimestamp] [datetime] NULL,
	[OrderApprovedAt] [datetime] NULL,
	[OrderCeliveredCarrierDate] [datetime] NULL,
	[OrderDeliveredCustomerDate] [datetime] NULL,
	[OrderEstimatedSeliveryDate] [datetime] NULL
) ON [PRIMARY]
GO

INSERT INTO [dbo].[Orders]
SELECT dbo.TRY_CONVERT_TO_UID(o.order_id) AS OrderID, 
dbo.TRY_CONVERT_TO_UID(c.customer_unique_id) AS CustomerId, 
order_status AS OrderStatus,
c.customer_zip_code_prefix AS CustomerZipCode,
Try_Cast(order_purchase_timestamp AS DATETIME) AS OrderPurchaseTimestamp,
TRY_CAST(order_approved_at AS datetime) AS OrderApprovedAt,
TRY_CAST(order_delivered_carrier_date AS datetime) As OrderDeliveredCarrierDate,
TRY_CAST(order_delivered_customer_date AS datetime) AS OrderDeliveredCustomerDate,
TRY_CAST(order_estimated_delivery_date AS datetime) AS OrderEstimatedDeliveryDate
FROM [raw_data].[Orders] as o
JOIN [raw_data].[olist_customers_dataset] as c
ON o.customer_id = c.customer_id
GO
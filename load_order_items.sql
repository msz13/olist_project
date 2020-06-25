USE olist
GO

CREATE TABLE [dbo].[Order_Items](
	[Id] int IDENTITY PRIMARY KEY,
    [OrderId] [UNIQUEIDENTIFIER] NOT NULL,
	[OrderItemId] [tinyint] NULL,
	[ProductId] [UNIQUEIDENTIFIER] NULL,
	[SellerId] [UNIQUEIDENTIFIER] NULL,
	[ShippingLimitDate] [datetime] NULL,
    Price DECIMAL(6,2) NULL,
	FreightValue DECIMAL(5,2) NULL
) ON [PRIMARY]

INSERT INTO [dbo].[Order_Items]
SElECT dbo.TRY_CONVERT_TO_UID(order_id) AS OrderId,
    TRY_CAST(order_item_id as tinyint) AS OrderItemId,
    dbo.TRY_CONVERT_TO_UID(product_id) AS ProductId,
    dbo.TRY_CONVERT_TO_UID(seller_id) AS SellerId,
    TRY_CAST(shipping_limit_date as datetime) AS ShippingLimitDate,
    TRY_CAST(price as decimal(6,2)) as Price,
    TRY_CAST(freight_value as decimal(5,2)) AS FreightValue
FROM [raw_data].[Order_items]
GO
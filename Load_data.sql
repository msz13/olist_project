SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE [dbo].[Category_Name_Translation](
	[column1] [nvarchar](50) NOT NULL,
	[column2] [nvarchar](50) NULL
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[Order_Items](
	[order_id] [UNIQUEIDENTIFIER] NOT NULL,
	[order_item_id] [tinyint] NULL,
	[product_id] [UNIQUEIDENTIFIER] NULL,
	[seller_id] [UNIQUEIDENTIFIER] NULL,
	[shipping_limit_date] [datetime] NULL,
    price DECIMAL(6,2) NULL,
	freight_value DECIMAL(5,2) NULL
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[Geolocation](
	[geolocation_zip_code_prefix] [int] NULL,
	[geolocation_lat] [nvarchar](50) NULL,
	[geolocation_lng] [nvarchar](50) NULL,
	[geolocation_city] [nvarchar](50) NULL,
	[geolocation_state] [nvarchar](50) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[olist_customers_dataset](
	[customer_id] [nvarchar](50) NOT NULL,
	[customer_unique_id] [nvarchar](50) NOT NULL,
	[customer_zip_code_prefix] [int] NULL,
	[customer_city] [nvarchar](50) NULL,
	[customer_state] [nvarchar](50) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Order_items](
	[order_id] [UNIQUEIDENTIFIER] NOT NULL,
	[order_item_id] [int] NULL,
	[product_id] [nvarchar](50) NULL,
	[seller_id] [nvarchar](50) NULL,
	[shipping_limit_date] [datetime2](7) NULL,
	[price] [decimal(6,2)](50) NULL,
	[freight_value] [decimal] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Order_payments](
	[order_id] [nvarchar](50) NOT NULL,
	[payment_sequential] [int] NULL,
	[payment_type] [nvarchar](50) NULL,
	[payment_installments] [int] NULL,
	[payment_value] [nvarchar](50) NULL,
	[cPayment_value] [decimal](7, 2) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Order_Reviews](
	[review_id] [nvarchar](50) NOT NULL,
	[order_id] [nvarchar](50) NULL,
	[review_score] [tinyint] NULL,
	[review_comment_title] [nvarchar](50) NULL,
	[review_comment_message] [nvarchar](250) NULL,
	[review_creation_date] [datetime2](7) NULL,
	[review_answer_timestamp] [datetime2](7) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Orders](
	[order_id] [nvarchar](50) NOT NULL,
	[customer_id] [nvarchar](50) NULL,
	[order_status] [nvarchar](50) NULL,
	[order_purchase_timestamp] [datetime2](7) NULL,
	[order_approved_at] [datetime2](7) NULL,
	[order_delivered_carrier_date] [datetime2](7) NULL,
	[order_delivered_customer_date] [datetime2](7) NULL,
	[order_estimated_delivery_date] [datetime2](7) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON

CREATE TABLE [dbo].[Products](
	[product_id] [nvarchar](50) NOT NULL,
	[product_category_name] [nvarchar](50) NULL,
	[product_name_lenght] [nvarchar](50) NULL,
	[product_description_lenght] [smallint] NULL,
	[product_photos_qty] [tinyint] NULL,
	[product_weight_g] [nvarchar](50) NULL,
	[product_length_cm] [nvarchar](50) NULL,
	[product_height_cm] [tinyint] NULL,
	[product_width_cm] [tinyint] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Sellers](
	[seller_id] [nvarchar](50) NOT NULL,
	[seller_zip_code_prefix] [nvarchar](50) NULL,
	[seller_city] [nvarchar](50) NULL,
	[seller_state] [nvarchar](50) NULL
) ON [PRIMARY]
GO

USE olist
GO

CREATE FUNCTION TRY_CONVERT_TO_UID (@uuid NVARCHAR(50))
RETURNS UNIQUEIDENTIFIER 
AS 
BEGIN
RETURN (
    SELECT  CAST(SUBSTRING(@uuid, 1, 8) + '-' + SUBSTRING(@uuid, 9, 4) + '-' + SUBSTRING(@uuid, 13, 4) + '-'+ SUBSTRING(@uuid, 17, 4) + '-' + SUBSTRING(@uuid, 21, 12) 
        AS UNIQUEIDENTIFIER)
)
END
GO

BULK INSERT Category_Name_Translation2
FROM '/var/opt/mssql/data/product_category_name_translation.csv'
WITH (FORMAT = 'CSV',
  FIRSTROW = 2,
  MAXERRORS = 100,
  ERRORFILE = '/var/opt/mssql/data/product_cat_erros_log');
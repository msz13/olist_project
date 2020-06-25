DROP TABLE dbo.OrderPayments
GO
CREATE TABLE [dbo].[OrderPayments](
	[PaymentId][int] IDENTITY PRIMARY KEY,
    [OrderId] [uniqueidentifier] NOT NULL FOREIGN KEY REFERENCES dbo.Orders(OrderId),
	[PaymentSequential] [tinyint] NULL,
	[PaymentType] [nvarchar](20) NULL,
	[PaymentInstallments] [smallint] NULL,
	[PaymentValue] [decimal](7,2) NULL,	
) ON [PRIMARY]
GO

INSERT INTO [dbo].[OrderPayments]
SELECT dbo.TRY_CONVERT_TO_UID(order_id) AS OrderId,
TRY_CAST(payment_sequential AS tinyint) AS PaymentSequential,
TRY_CAST(payment_type AS nvarchar(20)),
TRY_CAST(payment_installments as smallint) AS PaymentInstallments,
TRY_CAST(payment_value AS decimal(7,2)) AS PaymentValue
FROM [raw_data].[Order_payments]
GO
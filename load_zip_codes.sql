-- Create a new table called '[ZipCodes]' in schema '[dbo]'
-- Drop the table if it already exists
IF OBJECT_ID('[dbo].[ZipCodes]', 'U') IS NULL
-- Create the table in the specified schema
CREATE TABLE [dbo].[ZipCodes]
(
    [ZipCodePrefix] INT NOT NULL PRIMARY KEY, -- Primary Key column
    [City] NVARCHAR(50) NOT NULL,
    [State] NVARCHAR(10) NOT NULL
);
GO

IF OBJECT_ID('[dbo].[Geolocation]', 'U') IS NULL
CREATE TABLE [dbo].[Geolocation](
	[ZipCodePrefix] [int] NOT NULL FOREIGN KEY REFERENCES ZipCodes(ZipCodePrefix),
	[GeolocationLat] NVARCHAR(50) NULL,
	[GeolocationLng] NVARCHAR(50) NULL,
) ON [PRIMARY]
GO

-- Insert rows into table 'TableName' in schema '[dbo]'
INSERT INTO [dbo].[ZipCodes]
-- Select rows from a Table or Vraw_data '[]' in schema '[dbo]'
SELECT DISTINCT geolocation_zip_code_prefix AS ZipCodePrefix,
MIN([geolocation_city]) AS City,
MIN (geolocation_state) AS State
FROM [raw_data].[Geolocation]
GROUP BY geolocation_zip_code_prefix 
GO



-- Insert rows into table 'TableName' in schema '[dbo]'
INSERT INTO [dbo].[Geolocation]
-- Select rows from a Table or Vraw_data '[]' in schema '[dbo]'
SELECT geolocation_zip_code_prefix AS ZipCodePrefix,
	 [geolocation_lat] AS GeolocationLat,
      [geolocation_lng] AS GeolocationLng
FROM [raw_data].[Geolocation]
GO



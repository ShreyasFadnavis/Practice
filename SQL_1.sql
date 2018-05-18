SELECT 
type_ Type, 
SUM(Total_Sales) Total_Sales, 
SUM(Non_Taxable_Sales) Non_Taxable_Sales, 
SUM(Taxable_Sales) Taxable_Sales, 
SUM(Tax_Collected) Tax_Collected 

FROM
(
	-- PubSales
	SELECT *
	FROM
	(
		SELECT
		  'Indiana Sales Tax' type_,
		  SUM(Total_Sales) Total_Sales,
		  SUM(Non_Taxable_Sales) Non_Taxable_Sales,
		  SUM(Taxable_Sales) + SUM(Tax_Collected) Taxable_Sales,
		  SUM(Tax_Collected) Tax_Collected
		FROM (
		  SELECT
			total Total_Sales,
			ISNULL((SELECT SUM(qty * rate) FROM OrderItems WHERE taxable = 0 AND order_id = Orders.id), 0) + shipping Non_Taxable_Sales,
			ISNULL((SELECT SUM(qty * rate) FROM OrderItems WHERE taxable = 1 AND order_id = Orders.id), 0) Taxable_Sales,
			tax Tax_Collected
		  FROM Orders WHERE (state = 'IN' AND tax_exemption IS NULL)
		  AND date BETWEEN '1/1/2017' AND '6/1/2018'
		) I

		UNION

		SELECT
		  'Out of State, or Tax Exempt' type_,
		  SUM(Total_Sales) Total_Sales,
		  SUM(Non_Taxable_Sales) Non_Taxable_Sales,
		  SUM(Taxable_Sales) + SUM(Tax_Collected) Taxable_Sales,
		  SUM(Tax_Collected) Tax_Collected
		FROM (
		  SELECT
			total Total_Sales,
			ISNULL((SELECT SUM(qty * rate) FROM OrderItems WHERE taxable = 0 AND order_id = Orders.id), 0) + shipping Non_Taxable_Sales,
			ISNULL((SELECT SUM(qty * rate) FROM OrderItems WHERE taxable = 1 AND order_id = Orders.id), 0) Taxable_Sales,
			tax Tax_Collected
		  FROM Orders WHERE (state != 'IN' OR tax_exemption IS NOT NULL)
		  AND date BETWEEN '1/1/2017' AND '6/1/2018'
		) I
	) I

	UNION

	-- IGSStore
	SELECT *
	FROM
	(
		SELECT
		  'Indiana Sales Tax' type_,
		  SUM(Total_Sales) Total_Sales,
		  SUM(Non_Taxable_Sales) Non_Taxable_Sales,
		  SUM(Taxable_Sales) + SUM(Tax_Collected) Taxable_Sales,
		  SUM(Tax_Collected) Tax_Collected
		FROM
		(
		  SELECT
			AmountCharged Total_Sales,
			ISNULL((SELECT SUM(quantity * price) FROM IGSStore.dbo.OrderItems WHERE OrderID = Orders.OrderID AND SystemID NOT IN (1, 4)), 0) + ShippingCharged Non_Taxable_Sales,
			ISNULL((SELECT SUM(quantity * price) FROM IGSStore.dbo.OrderItems WHERE OrderID = Orders.OrderID AND SystemID IN (1, 4)), 0) Taxable_Sales,
			ROUND(TaxCharged, 2) Tax_Collected
		  FROM IGSStore.dbo.Orders
		  WHERE (StateID = 13 AND TaxExemptNumber = '')
		  AND DateOrdered BETWEEN '1/1/2017' AND '6/1/2018'
		) I

		UNION

		SELECT
		  'Out of State, or Tax Exempt' type_,
		  SUM(Total_Sales) Total_Sales,
		  SUM(Non_Taxable_Sales) Non_Taxable_Sales,
		  SUM(Taxable_Sales) + SUM(Tax_Collected) Taxable_Sales,
		  SUM(Tax_Collected) Tax_Collected
		FROM
		(
		  SELECT
			AmountCharged Total_Sales,
			ISNULL((SELECT SUM(quantity * price) FROM IGSStore.dbo.OrderItems WHERE OrderID = Orders.OrderID AND SystemID NOT IN (1, 4)), 0) + ShippingCharged Non_Taxable_Sales,
			ISNULL((SELECT SUM(quantity * price) FROM IGSStore.dbo.OrderItems WHERE OrderID = Orders.OrderID AND SystemID IN (1, 4)), 0) Taxable_Sales,
			ROUND(TaxCharged, 2) Tax_Collected
		  FROM IGSStore.dbo.Orders
		  WHERE (StateID != 13 OR TaxExemptNumber != '')
		  AND DateOrdered BETWEEN '1/1/2017' AND '6/1/2018' 
		) I
	) I
) I
GROUP BY type_

-- # To understand the structure of the database using state identification:
-- select * from Orders where state = 'IN'
-- select * from IGSStore.dbo.Orders where StateID = 13

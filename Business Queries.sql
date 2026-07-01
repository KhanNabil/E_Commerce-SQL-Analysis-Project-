------------------------------------------------
-- Customer Analysis
------------------------------------------------
-- 1. Business Requirement:
-- Which customers contribute the highest revenue to the business?
select CustomerName,sum(Price*Quantity) as TotalSpending
from Customer
Inner Join Orders
on Customer.CustomerID = Orders.CustomerID
Inner Join OrdersDetails
on Orders.OrderID = OrdersDetails.OrderID
Inner Join Product 
on Product.ProductID = OrdersDetails.ProductID
group by CustomerName
order by TotalSpending desc 

-- 2. Business Requirement:
-- Which customers perform above the average spending level and should be prioritized for retention campaigns?
select CustomerName,sum(Price*Quantity) as TotalSpending,
case
when sum(Price*Quantity) >= (select avg(TotalSpending) as AvgSpending 
							from (select CustomerName,sum(Price*Quantity) as TotalSpending
							from Customer
							Inner Join Orders
							on Customer.CustomerID = Orders.CustomerID
							Inner Join OrdersDetails
							on Orders.OrderID = OrdersDetails.OrderID
							Inner Join Product 
							on Product.ProductID = OrdersDetails.ProductID
							group by CustomerName) as AvgTable)
							then 'High Performer'
							else 'Low Performer'
							end as Performance_Customer
							from Customer
								Inner Join Orders
								on Customer.CustomerID = Orders.CustomerID
								Inner Join OrdersDetails
								on Orders.OrderID = OrdersDetails.OrderID
								Inner Join Product 
								on Product.ProductID = OrdersDetails.ProductID
								group by CustomerName

create view Customer_TotalSpends as 
select CustomerName,sum(Price*Quantity) as TotalSpending
from Customer
Inner Join Orders
on Customer.CustomerID = Orders.CustomerID
Inner Join OrdersDetails
on Orders.OrderID = OrdersDetails.OrderID
Inner Join Product 
on Product.ProductID = OrdersDetails.ProductID
group by CustomerName

-- 3. Business Requirement:
-- Segment customers into VIP, Regular, and Basic tiers to support loyalty and marketing strategies.
select CustomerName,Category,
case 
when Category = 'VIP' then 1
when Category = 'Regular' then 2 
else 3
end as IDs
from(
select CustomerName,
case
when TotalSpending >= 15000 then 'VIP'
when TotalSpending >= 10000 then 'Regular'
else 'Basic'
end as Category
from Customer_TotalSpends) as IDTable
order by IDs asc

-- 4. Business Requirement:
-- Analyze confirmed customer revenue by excluding non-completed orders, ensuring revenue reports reflect actual business earnings..
select CustomerName,sum(
case 
when OrderStatus = 'Confirmed'
then Price*Quantity
else 0
end) as ConfirmedRevenue
from Customer
Inner Join Orders
on Customer.CustomerID = Orders.CustomerID
Inner Join OrdersDetails
on Orders.OrderID = OrdersDetails.OrderID
Inner Join Product 
on Product.ProductID = OrdersDetails.ProductID
group by CustomerName
------------------------------------------------
-- Product Analysis
------------------------------------------------
-- 5. Business Requirement:
-- Which products contribute the most revenue and should remain a strategic sales focus?
select ProductName,sum(Price*Quantity) as Revenue
from Product
Inner Join OrdersDetails
on Product.ProductID = OrdersDetails.ProductID
group by ProductName 
order by Revenue desc

-- 6. Business Requirement:
-- Which products perform above the average revenue and should be prioritized for future promotions and inventory planning.
select ProductName,sum(Price*Quantity) as Revenue,
case 
when sum(Price*Quantity) > (
select avg(Revenue) as AvgRevenue 
from(select ProductName,sum(Price*Quantity) as Revenue
from Product
Inner Join OrdersDetails
on Product.ProductID = OrdersDetails.ProductID
group by ProductName) as AvgTable) 
then 'Above Average'
else 'Below Average'
end as Category
from Product
Inner Join OrdersDetails
on Product.ProductID = OrdersDetails.ProductID
group by ProductName 

-- 7. Business Requirement:
-- Classify products based on sales performance to identify best-selling and underperforming items.
select ProductName,sum(Quantity) as QuantitySold,
case 
when sum(Quantity) >=4 then 'Excellent'
when sum(Quantity) > 2 then 'Good'
else 'Poor'
end as Category
from Product
Inner Join OrdersDetails
on Product.ProductID = OrdersDetails.ProductID
group by ProductName

-- 8. Business Requirement:
-- Which products require immediate restocking to prevent stock shortages and ensure uninterrupted sales?select ProductName,StockQuantity,
case 
when StockQuantity < 20 then 'Restock Immediately'
when StockQuantity < 50 then 'Monitor Stock'
else 'Sufficient Stock'
end as Stocks
from Product
------------------------------------------------
-- Order Analysis
------------------------------------------------
-- 9. Business Requirement:
-- How much revenue comes from Confirmed, Pending, and Cancelled orders?
select sum( 
case
when OrderStatus = 'Confirmed'
then Price*Quantity
else 0
end) as ConfirmedRevenue,
sum(
case
when OrderStatus = 'Pending'
then Price*Quantity
else 0
end) as PendingRevenue,
sum(
case 
when OrderStatus = 'Cancelled'
then Price*Quantity
else 0
end) as CancelledRevenue
from Orders
Inner Join OrdersDetails
on Orders.OrderID = OrdersDetails.OrderID
Inner Join Product
on Product.ProductID = OrdersDetails.ProductID

-- 10. Business Requirement:
-- What is the distribution of order statuses across the business?
select sum(
case 
when OrderStatus = 'Confirmed' then 1 
else 0
end) as ConfirmedOrders,
sum(
case 
when OrderStatus = 'Pending' then 1
else 0
end) as PendingOrders,
sum(
case 
when OrderStatus = 'Cancelled' then 1 
else 0
end) as CancelledOrders
from Orders

-- 11. Business Requirement:
-- Which customers place orders most frequently and should be considered loyal customers?
select CustomerName,count(distinct OrderID) as TotalOrders
from Customer
Inner Join Orders
on Customer.CustomerID = Orders.CustomerID
group by CustomerName

-- 12. Business Requirement:
-- Which product generates the highest revenue and should be prioritized for inventory, marketing, and future sales strategies?
select top 1 ProductName,sum(Price*Quantity) as Revenue
from Product
Inner Join OrdersDetails
on Product.ProductID = OrdersDetails.ProductID
group by ProductName 
order by Revenue desc
------------------------------------------------
-- Executive Reports
------------------------------------------------
-- 13. Business Requirement:
-- Provide an executive dashboard summarizing customers, orders, total revenue, and average order value.
select 
count(distinct Customer.CustomerID) as TotalCustomers,
count(distinct Orders.OrderID) as TotalOrders,
sum(Price*Quantity) as TotalRevenue,
avg(Price*Quantity) as AverageOrderValue
from Customer
Inner Join Orders
on Customer.CustomerID = Orders.CustomerID
Inner Join OrdersDetails
on Orders.OrderID = OrdersDetails.OrderID
Inner Join Product
on Product.ProductID = OrdersDetails.ProductID

-- 14. Business Requirement:
-- Identify customers who have successfully completed at least one purchase, making them eligible for loyalty and retention campaigns.
select CustomerName
from Customer
where exists(select 1 from Orders
where Customer.CustomerID = Orders.CustomerID
and OrderStatus = 'Confirmed')

-- 15. Business Requirement:
-- Identify customers who purchased both a Smartphone and a Smartwatch but have never purchased a Laptop. These customers are ideal targets for laptop cross-selling campaigns.
select CustomerName
from Customer
where CustomerID in(
select CustomerID from Orders
where OrderID in(
select OrderID from OrdersDetails
where ProductID in(
select ProductID from Product
where ProductName = 'Smartphone')))
Intersect
select CustomerName
from Customer
where CustomerID in(
select CustomerID from Orders
where OrderID in(
select OrderID from OrdersDetails
where ProductID in(
select ProductID from Product
where ProductName = 'Smartwatch')))
Intersect 
select CustomerName
from Customer
where not exists(select 1 from Orders
Inner Join OrdersDetails
on Orders.OrderID = OrdersDetails.OrderID
Inner Join Product
on Product.ProductID = OrdersDetails.ProductID
where Customer.CustomerID = Orders.CustomerID
and ProductName = 'Laptop')

-- 16. Business Requirement:
-- Identify customers who have placed orders but have never used Online payment, helping the business target them for digital payment adoption.
select CustomerName
from Customer
Inner Join Orders
on Customer.CustomerID = Orders.CustomerID
except 
select CustomerName
from Customer
Inner Join Orders
on Customer.CustomerID = Orders.CustomerID
Inner Join Payments
on Orders.OrderID = Payments.OrderID
where PaymentMethod = 'Online'

-- 17. Business Requirement:
-- Generate standardized purchase labels for customer order tracking.
select concat(CustomerName,' - ',upper(ProductName),' - ',Price) as ProductLabel
from Product
Inner Join OrdersDetails
on Product.ProductID = OrdersDetails.ProductID
Inner Join Orders
on Orders.OrderID = OrdersDetails.OrderID
Inner Join Customer
on Orders.CustomerID = Customer.CustomerID

-- 18. Business Requirement:
-- Monitor delivery progress by identifying whether each order is overdue or still within its expected delivery timeline.
select OrderID,dateadd(day,15,OrderDate) as [Delivery Date],day(OrderDate) as Day,
case
when dateadd(day,25,OrderDate) < getdate() then 'Delivery Successful'
else 'Not yet delivered'
end as DeliveryDetails
from Orders

-- 19. Business Requirement:
-- Generate customer order reference reports with separated customer names and unique reference codes for internal tracking.
select substring(CustomerName,1,charindex(' ',CustomerName)) as [First Name],
substring(CustomerName,charindex(' ',CustomerName)+1,len(CustomerName)) as [Last Name],
concat(Product.ProductID,' ',ProductName) as [Products Purchase],
cast(abs(checksum(newid()))%9000+1000 as varchar(4)) as [Reference Code]
from Customer
Inner Join Orders
on Customer.CustomerID = Orders.CustomerID
Inner Join OrdersDetails
on Orders.OrderID = OrdersDetails.OrderID
Inner Join Product
on Product.ProductID = OrdersDetails.ProductID

-- 20. Business Requirement:
-- Which payment method contributes the highest completed payment revenue?
select PaymentMethod,sum(Amount) as TotalRevenue
from Payments
where PaymentStatus = 'Paid'
group by PaymentMethod
order by TotalRevenue desc
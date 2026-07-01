insert into Customer (CustomerID, CustomerName, City, Email)
values
('C001', 'Aarav Khan', 'Mumbai', 'aarav@gmail.com'),
('C002', 'Sana Shaikh', 'Delhi', 'sana@gmail.com'),
('C003', 'Rohan Mehta', 'Pune', 'rohan@gmail.com'),
('C004', 'Zoya Ali', 'Mumbai', 'zoya@gmail.com'),
('C005', 'Kabir Shah', 'Bangalore', 'kabir@gmail.com'),
('C006', 'Meera Rao', 'Hyderabad', 'meera@gmail.com'),
('C007', 'Ishaan Verma', 'Delhi', 'ishaan@gmail.com');

insert into Product (ProductID, ProductName, Category, Price, StockQuantity)
values
('P001', 'Smartphone', 'Electronics', 18999.00, 25),
('P002', 'Laptop', 'Electronics', 55999.00, 10),
('P003', 'Headphones', 'Electronics', 2499.00, 40),
('P004', 'T-Shirt', 'Fashion', 799.00, 60),
('P005', 'Jeans', 'Fashion', 1799.00, 35),
('P006', 'Sneakers', 'Fashion', 2999.00, 20),
('P007', 'SQL Book', 'Books', 599.00, 50),
('P008', 'Python Book', 'Books', 699.00, 45),
('P009', 'Notebook', 'Books', 149.00, 100),
('P010', 'Smartwatch', 'Electronics', 4999.00, 15);

insert into Orders (OrderID, CustomerID, OrderDate, OrderStatus)
values
('O001', 'C001', '2026-05-01', 'Confirmed'),
('O002', 'C002', '2026-05-01', 'Confirmed'),
('O003', 'C003', '2026-05-02', 'Pending'),
('O004', 'C004', '2026-05-02', 'Confirmed'),
('O005', 'C005', '2026-05-03', 'Cancelled'),
('O006', 'C001', '2026-05-03', 'Confirmed'),
('O007', 'C006', '2026-05-04', 'Pending'),
('O008', 'C007', '2026-05-04', 'Confirmed'),
('O009', 'C002', '2026-05-05', 'Confirmed'),
('O010', 'C004', '2026-05-05', 'Confirmed');

insert into OrdersDetails (OrderDetailID, OrderID, ProductID, Quantity)
values
('OD01', 'O001', 'P001', 1),
('OD02', 'O001', 'P003', 2),
('OD03', 'O002', 'P004', 3),
('OD04', 'O002', 'P007', 1),
('OD05', 'O003', 'P002', 1),
('OD06', 'O004', 'P005', 2),
('OD07', 'O004', 'P006', 1),
('OD08', 'O005', 'P010', 1),
('OD09', 'O006', 'P008', 2),
('OD10', 'O006', 'P009', 5),
('OD11', 'O007', 'P003', 1),
('OD12', 'O008', 'P001', 1),
('OD13', 'O008', 'P004', 2),
('OD14', 'O009', 'P006', 2),
('OD15', 'O010', 'P007', 3);

insert into Payments (PaymentID, OrderID, PaymentMethod, PaymentStatus, Amount)
values
('PM01', 'O001', 'Online', 'Paid', 23997.00),
('PM02', 'O002', 'Card', 'Paid', 2996.00),
('PM03', 'O003', 'Online', 'Pending', 55999.00),
('PM04', 'O004', 'Cash', 'Paid', 6597.00),
('PM05', 'O005', 'Card', 'UnPaid', 4999.00),
('PM06', 'O006', 'Online', 'Paid', 2143.00),
('PM07', 'O007', 'Cash', 'Pending', 2499.00),
('PM08', 'O008', 'Card', 'Paid', 20597.00),
('PM09', 'O009', 'Online', 'Paid', 5998.00),
('PM10', 'O010', 'Cash', 'Paid', 1797.00);
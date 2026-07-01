create database E_Commerce;

use E_Commerce;

create table Customer 
(CustomerID varchar(5) primary key,
CustomerName varchar(20) not null,
City varchar(20) not null,
Email varchar(50) unique not null);

create table Product
(ProductID varchar(5) primary key,
ProductName varchar(30) not null,
Category varchar(50) check(Category in ('Fashion','Electronics','Books')),
Price decimal(10,2) not null default(0),
StockQuantity int not null default(0));

create table Orders
(OrderID varchar(5) primary key,
CustomerID varchar(5) not null,
OrderDate date not null,
OrderStatus varchar(20) not null check(OrderStatus in ('Confirmed','Cancelled','Pending')),
foreign key (CustomerID) references Customer(CustomerID));

create table OrdersDetails
(OrderDetailID varchar(5) primary key,
OrderID varchar(5) not null,
ProductID varchar(5) not null,
Quantity int check(Quantity >= 1) not null,
foreign key (OrderID) references Orders(OrderID),
foreign key (ProductID) references Product(ProductID));

create table Payments
(PaymentID varchar(5) primary key,
OrderID varchar(5) not null,
PaymentMethod varchar(20) not null check(PaymentMethod in ('Online','Cash','Card')),
PaymentStatus varchar(20) not null check(PaymentStatus in ('Paid','Pending','UnPaid')),
Amount decimal(10,2) not null check(Amount > 0),
foreign key (OrderID) references Orders(OrderID));

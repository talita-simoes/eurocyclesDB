create database eurocyclesDatabase;

use eurocyclesDatabase;

CREATE TABLE TeamMember
(
memberID int,
lName varchar(255),
fName varchar(255),
position varchar(255),
email varchar(255),
telephone varchar(255),
address varchar(255),
PRIMARY KEY (memberID)
);
CREATE TABLE Clients
(
clientID int,
lName varchar(255),
fName varchar(255),
email varchar(255),
telephone varchar(255),
address varchar(255),
PRIMARY KEY (clientID)
);
CREATE TABLE Orders
(
orderNumber int,
date_time_Transaction datetime,
date_time_Approval datetime,
date_time_Dispatched datetime,
clientID int,
memberID int,
itemID int,
PRIMARY KEY (orderNumber),
foreign key (clientID) REFERENCES Clients(clientID),
foreign key (memberID) REFERENCES TeamMember(memberID),
foreign key (itemID) REFERENCES Items(itemID)
);
CREATE TABLE Items
(
itemID int,
itemName varchar(255),
itemDescription varchar(255),
quantityInStock int,
brand varchar(30),
salesPrice decimal(19,2),
PRIMARY KEY (itemID)
);

CREATE TABLE Supplier
(
supplierID int,
companyName varchar(255),
contactName varchar(255),
email varchar(255),
telephone varchar(255),
PRIMARY KEY (supplierID)
);

CREATE TABLE Interacts
(
id serial,
memberID int,
clientID int,
orderNumber int,
PRIMARY KEY (id),
FOREIGN KEY (memberID) REFERENCES TeamMember(memberId) ON DELETE CASCADE,
FOREIGN KEY (clientID) REFERENCES Clients(clientId) ON DELETE CASCADE,
FOREIGN KEY (orderNumber) REFERENCES Orders(orderNumber) ON DELETE CASCADE
);

CREATE TABLE Contain
(
id_c serial,
orderNumber int NOT NULL,
itemID int NOT NULL,
quantityOfItems int,
deliveryMethod varchar(30),
discount decimal(4,2),
totalValue decimal(19,2),
PRIMARY KEY (id_c),
FOREIGN KEY (orderNumber) REFERENCES Orders(orderNumber) ON DELETE CASCADE,
FOREIGN KEY (itemID) REFERENCES Items(itemID) ON DELETE CASCADE

);

CREATE TABLE Supplies
(
id_s serial,
purchasePrice decimal(19,2),
supplierID int,
itemID int,
PRIMARY KEY (id_s),
FOREIGN KEY (supplierID) REFERENCES Supplier(supplierID) ON DELETE CASCADE,
FOREIGN KEY (itemID) REFERENCES Items(itemID) ON DELETE CASCADE
);

CREATE TABLE Contacts
(
id_cs serial,
supplierID int,
memberID int,
date_time_Contact datetime,
PRIMARY KEY (id_cs),
FOREIGN KEY (supplierID) REFERENCES Supplier(supplierID) ON DELETE CASCADE,
FOREIGN KEY (memberID) REFERENCES TeamMember(memberID) ON DELETE CASCADE
);

INSERT INTO TeamMember (memberID, lName, fName, position, email, telephone, address)
				VALUES (001, 'Goodall', 'Marion', 'Manager-OL', 'marion@eurocycles.com', '353018845699','26, Leinster Road, Dublin 6, Ireland'),
					   (002, 'Griffin', 'Shane','Manager-SW', 'shane@eurocycles.com','353018544555', '12, Grosvesnor Park, Dublin2, Ireland'),
					   (003, 'Joyce', 'Ciat','Manager-LR', 'joyce@eurocycles.com','353538863025', '7, OConnel Street, Dublin1, Ireland'),
					   (004, 'Ibbotson', 'Cian','Sales Assistant-SW', 'cian@eurocycles.com','353215693554', '35, Marion Avenue, Dublin11, Ireland'),
					   (005, 'Willet', 'James','Sales Assistant-SW', 'willet@eurocycles.com','3530568895623', '1, Effra Street, Dublin6, Ireland'),
					   (006, 'Davis', 'Gavin','Mechanic-SW', 'gavin@eurocycles.com','353018745541', '6, Longford Road, Dublin11, Ireland');

INSERT INTO Clients (clientId, lName, fName, email, telephone, address)
	         VALUES (1001, 'Richardson', 'William', 'willian.ric@yahoo.ie', '353012566684', '34, Aungier Street, Dublin2, Ireland'),
					(1002, 'Mayer', 'Shirley', 'shirley.mayer@gmail.com', '353569955634', '20, Stephen Street, Dublin1, Ireland'),
                    (1003, 'McCollin', 'Donna', 'donna123@outlook.com', '353025698477', '10, Ferdinand Road, Dublin3, Ireland'),
                    (1004, 'Carrey', 'Mariah', 'famous.mariah@aol.com', '0445689652214', '20, Hall of Fame, Holyywwod, United States'),
                    (1005, 'Chrisholm', 'Melanie', 'spice.melaniec@gmail.com.uk', '35536254411235', '15, The Beatles Street, Liverpool, United Kingdom'),
                    (1006, 'Foullet', 'Jean', 'jean.foullet12@gmail.fr', '389035699842', '8, Rue Petit Palais, PAris2, France');
						
INSERT INTO Items (itemID, itemName, itemDescription, quantityInStock, brand, salesPrice)
		   VALUES (001, 'Road Bike', 'Red Bicycle Adult', 3, 'Giant', 645.50),
				  (002, 'Road Bike', 'Gray Bicycle Adult', 2, 'Giant', 645.50),
                  (003, 'Helmet', 'Black Helmet Adult', 2, 'Giro', 32.20),
                  (004, 'Electric Bike', 'Bakery Electric Bike (2021) White', 2, 'Bergamount', 3899.00),
                  (005, 'Electric Bike', 'E-Revox 4 Electric Bike 2021 Blue', 3, 'Bergamount', 2599.00),
                  (006, 'Electric Bike', 'E-Revox 4 Electric Bike 2021 Blue', 3, 'Bergamount', 2599.00),
                  (007, 'Electric Bike', 'Centros Low Step Derailleur Electric Bike 2020 Black', 2, 'Raleigh', 2452.50);

/*Part3-1*/
SELECT * FROM Items WHERE salesPrice > 100.00;

/*Part3-2*/
SELECT Items.ItemID, Items.itemName, Items.brand, Supplies.supplierID, 
Supplier.companyName, Supplier.contactName, Supplier.email, Supplier.telephone
FROM Items
INNER JOIN Supplies
ON (Supplies.itemID = Items.itemID)
INNER JOIN Supplier
ON (Supplies.supplierID = Supplier.supplierID);

/*Part3-3*/

/*This is the test for create the procedure*/
SELECT * FROM Orders 
WHERE date_time_Transaction BETWEEN '2020-08-08 18:01:14' AND '2020-10-01 00:00:00'
;

/*Procedure*/
Delimiter //
CREATE PROCEDURE displayTransactions (startDate datetime, endDate dateTime)

BEGIN
SELECT * FROM Orders 
WHERE date_time_Transaction BETWEEN startDate AND endDate
;
END//
Delimiter ;

/*run the procedure*/
call eurocyclesDatabase.displayTransactions('2020-08-01', '2020-10-01');

SELECT orderNumber FROM Orders 
WHERE date_time_Approval BETWEEN '2020-10-01' AND '2020-10-31';


/*Part3-4*/
CREATE VIEW items_period
AS
	select o.clientID, o.orderNumber, o.date_time_Approval, c.quantityOfItems, c.totalValue from
	Orders o  inner join Contain c
	on o.orderNumber = c.orderNumber
	WHERE date_time_Approval BETWEEN '2020-10-01' AND '2020-10-31';

/*Part3-5*/

Delimiter $$
	CREATE TRIGGER Update_Stock
	After Insert On eurocyclesDatabase.Contain
    For Each Row
    BEGIN
    UPDATE Items
    SET Items.quantityInStock = Items.quantityInStock - New.quantityOfItems
    WHERE Items.itemID = new.itemID;
    END $$
Delimiter ;

/*Part3-6* - Items Sold=1218 | Total_Sold= 898.076,34*/

select coalesce (orderNumber, 'Items_Sold'), sum(quantityOfItems)
from Contain
Group by orderNumber
with ROLLUP;

select coalesce (orderNumber, 'Total_Sold'), sum(totalValue)
from Contain
Group by orderNumber
with ROLLUP;

select
o.date_time_Approval, c.totalValue
from Orders o
left join Contain c on c.orderNumber = o.orderNumber WHERE c.totalValue IS NOT NULL;

select
o.date_time_Approval, c.quantityOfItems
from Orders o
left join Contain c on c.orderNumber = o.orderNumber WHERE c.quantityOfItems IS NOT NULL;


/*Part3-7*/

select o.date_time_Approval, c.totalValue from Orders o
left join Contain c on c.orderNumber = o.orderNumber WHERE c.totalValue IS NOT NULL
Order by date_time_Approval;

/*Part3-8*/

select  c.clientID, c.fName, orderNumber
FROM Clients c
LEFT JOIN
Orders o ON c.clientID = o.clientID
WHERE
orderNumber IS NULL;

delete Clients 
from Clients
left join
Orders on Clients.clientID = Orders.clientID 
where
orderNumber is null;



 












                 
                 







	
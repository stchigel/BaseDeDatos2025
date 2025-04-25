/*1*/
CREATE TABLE `customers_audit` (
  `idAudit` int auto_increment NOT NULL,
  `operacion` char(6),
  `user`varchar(50),
  `last_date_modified` date,
  `customer_Name`varchar(50),
  `customer_Number`int,
  PRIMARY KEY (`idAudit`)
  );
/*A*/
delimiter //
create trigger after_insert_customers after insert on customers for each row
begin
	insert into customers_audit values (null, "insert", current_user(), current_date(), new.customerName, new.customerNumber);
end //
delimiter ;

/*B*/
delimiter //
create trigger before_update_customers before update on customers for each row
begin
	insert into customers_audit values (null, "update", current_user(), current_date(), old.customerName, old.customerNumber);
end //
delimiter ;

/*C*/
delimiter //
create trigger before_delete_customers before delete on customers for each row
begin
	insert into customers_audit values (null, "delete", current_user(), current_date(), old.customerName, old.customerNumber);
end //
delimiter ;

/*probar*/
INSERT INTO customers VALUES (500, "Benjamin Ricci", "Ricci", "Benjamin", "3456434565", "Callao 1232", null, "Lomas de zamora", "Provincia de malos aires", "C1723AVB", "Azerbaiyan", 1370, 47);
select * from customers_audit;

update customers set creditLimit=1000000 where customerNumber=500;

delete from customers where customerNumber=500;

/*2*/
CREATE TABLE `employees_audit` (
  `idAudit` int auto_increment NOT NULL,
  `operacion` char(6),
  `user`varchar(50),
  `last_date_modified` date,
  `customer_Name`varchar(50),
  `customer_Number`int,
  PRIMARY KEY (`idAudit`)
  );

delimiter //
create trigger after_insert_employees after insert on employees for each row
begin
	insert into employees_audit values (null, "insert", current_user(), current_date(), new.firstName, new.employeeNumber);
end //
delimiter ;

delimiter //
create trigger after_update_employees after update on employees for each row
begin
	insert into employees_audit values (null, "update", current_user(), current_date(), old.firstName, old.employeeNumber);
end //
delimiter ;

delimiter //
create trigger after_delete_employees after delete on employees for each row
begin
	insert into employees_audit values (null, "delete", current_user(), current_date(), old.firstName, old.employeeNumber);
end //
delimiter ;

/*probamos*/
INSERT INTO employees VALUES (1001, 'Doe', 'John', 'x1234', 'johndoe@example.com', 3, NULL, 'Manager', 5000);
select * from employees_audit;

update employees set comision=100 where employeeNumber=1001;

delete from employees where employeeNumber=1001;

/*3*/
delimiter //
create trigger before_delete_products before delete on products for each row
begin
	if exists (select * from orderdetails join orders on orderdetails.orderNumber=orders.orderNumber
    where productCode=old.productCode and TIMESTAMPDIFF(MONTH, orderDate, CURRENT_DATE) < 2) then
		signal sqlstate '45000' set message_text="Error, tiene órdenes asociadas";
	end if;
end//
delimiter ;

delete from products where productCode="S18_1749";
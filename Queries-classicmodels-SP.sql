/*1*/
delimiter //
create procedure listProd(out cant int)
begin
	select * from products where buyPrice > (select avg(buyPrice) from products);
    select count(*) into cant from products where buyPrice > (select avg(buyPrice) from products);
end//
delimiter ;

call listProd(@variable);
select @variable;

/*2*/
delimiter //
create procedure delOrder(in orderNum int, out cant int)
begin
    select count(*) into cant from orderdetails where orderNumber=orderNum;
    delete from orderdetails where orderNumber=orderNum;
    delete from orders where orderNumber=orderNum;
end//
delimiter ;

call listProd(10236, @variable2);
select @variable2;

/*3*/
delimiter //
create function contLinprod (lineaProducto text) returns int deterministic
begin
	declare cantProducts int default 0;
    select count(*) into cantProducts from products where productLine = lineaProducto;
	return cantProducts;
    end//
delimiter ;
delimiter //
create procedure delLinprod(in lineaProducto text, out resp text)
begin
    if contLinprod(lineaProducto)>0 then
		set resp="La línea de productos no pudo borrarse porque contiene productos asociados";
	else
		delete from productlines where productLine=lineaProducto;
		set resp="La línea de productos fue borrada";
	end if;
end//
delimiter ;

call delLinprod("Motorcycles", @variable3);
select @variable3;

/*4*/
delimiter //
create procedure cantProductos ()
begin
select count(orderNumber) from orders group by status;
end//
delimiter ;

/*5*/
delimiter //
create procedure cantSUB ()
begin
	select count(*), reportsTo from employees group by reportsTo;
    /*Con nombre:
    select jefe.lastname, count(*) from employees 
    join employees as jefe on employees.reportsTo=jefe.employeeNumber group by jefe.employeeNumber;
    */
end//
delimiter ;
call cantSUB();

/*6*/
delimiter //
create procedure totOrd ()
begin
	select orderNumber, sum(quantityOrdered*priceEach) from orderdetails group by orderNumber;
end//
delimiter ;
call totOrd();

/*7*/
delimiter //
create procedure totOrdNom ()
begin
	select customers.customerName, customers.customerNumber, orders.orderNumber, sum(priceEach*quantityOrdered) as Total 
    from customers join orders on customers.customerNumber=orders.customerNumber 
    join orderdetails on orders.orderNumber = orderdetails.orderNumber 
    group by orders.orderNumber;
end//
delimiter ;
call totOrdNom();

/*8*/
delimiter //
create procedure coment(in ordenNomero int, in comm text, out resp bool)
begin
    if exists(select * from orders where ordenNomero=orderNumber) then
		update orders set comments=comm where orderNumber=ordenNomero;
        set resp=true;
	else
		set resp=false;
	end if;
end//
delimiter ;
call coment(10100,"Que lindo es caminar, que lindo es caminar, yo camino y vos no, que lindo es caminar", @resp);
select @resp;
select * from orders where orderNumber=10100;

/*9*/
delimiter //
create procedure getCiudadesOffices(out listaCiudades text) 
begin
	declare hayFilas boolean default 1;
	declare ciudadAct varchar(45) default "";
	declare nombreCursor cursor for select city from offices;
	declare continue handler for not found set hayFilas = 0;
	open nombreCursor;
	bucle:loop
		fetch nombreCursor into ciudadAct;
		if hayFilas = 0 then
			leave bucle;
		end if;
		set listaCiudades =  concat(listaCiudades, ",", ciudadAct);
	end loop bucle;
	close nombreCursor;
end//
delimiter ;
call getCiudadesOffices(@listaCiudades);
select @listaCiudades;

/*10*/
CREATE TABLE `CancelledOrders` (
  `orderNumber` int NOT NULL,
  `orderDate` date NOT NULL,
  `shippedDate` date DEFAULT NULL,
  `customerNumber` int NOT NULL,
  PRIMARY KEY (`orderNumber`),
  KEY `customerNumber` (`customerNumber`),
  CONSTRAINT `orders_ibfk_43545` FOREIGN KEY (`customerNumber`) REFERENCES `customers` (`customerNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

delimiter //
create procedure ordCan(out cantCancel int) 
begin
	declare hayFilas boolean default 1;
    declare custNum int;
    declare ordNum int;
    declare ordDate DATE;
    declare shipDate DATE;
    declare stat varchar(45);
	declare nombreCursor cursor for select orderNumber, orderDate, shippedDate, customerNumber from orders where status="Cancelled";
	declare continue handler for not found set hayFilas = 0;
	open nombreCursor;
	bucle:loop
		fetch nombreCursor into ordNum, ordDate, shipDate, custNum;
		if hayFilas = 0 then
			leave bucle;
		end if;
		set cantCancel = cantCancel+1;
        insert into CancelledOrders values (ordNum, ordDate, shipDate, custNum);
	end loop bucle;
	close nombreCursor;
end//
delimiter ;
drop procedure ordCan;
call ordCan(@cantCancel);
select @cantCancel;
select * from CancelledOrders;
delete from CancelledOrders;

/*11*/
delimiter //
create procedure comentario(in custNum int) 
begin
	declare hayFilas boolean default 1;
    declare totalOrden float default 0;
    declare ordNum int;
    declare stat varchar(45);
	declare nombreCursor cursor for 
    select orderNumber from orders where customerNumber=custNum and comments is null;
	declare continue handler for not found set hayFilas = 0;
	open nombreCursor;
	bucle:loop
		fetch nombreCursor into ordNum;
		if hayFilas = 0 then
			leave bucle;
		end if;
        set totalOrden=(select sum(quantityOrdered*priceEach) from orderdetails where orderNumber=ordNum);
		update orders set comments = concat("El total de la orden es ", totalOrden) where orderNumber= ordNum;
	end loop bucle;
	close nombreCursor;
end//
delimiter ;

/*12*/
alter table employees add comision int;
delimiter //
create procedure comisionEmp() 
begin
	declare hayFilas boolean default 1;
	declare ventas int default 0;
	declare orderCursor cursor for select customers.customerNumber, phone, max(orderDate) 
    from orders join customers on customers.customerNumber = orders.customerNumber 
    where status="Cancelled" group by customerNumber;
	declare continue handler for not found set hayFilas = 0;
	open orderCursor;
	bucle:loop
		fetch orderCursor into custAct, telAct, fechaAct;
		if hayFilas = 0 then
			leave bucle;
		end if;
        if (select count(*) from orders where customerNumber=custAct and status!="Cancelled"
        and orderDate>fechaAct)>0 then
			set listaTel =  concat(listaTel, ",", telAct);
		end if;
	end loop bucle;
	close orderCursor;
end//
delimiter ;
drop procedure cancelSinComp;
call cancelSinComp(@listaTel);
select @listaTel;

/*13*/
ALTER TABLE employees ADD comission int;
delimiter //
create procedure actuComision()
begin
	declare hayFilas boolean default 1;
	declare plataVentas float default 0;
    declare empNumber int default null;
	declare empleadoCursor cursor for select employees.employeeNumber from employees;
	declare continue handler for not found set hayFilas = 0;
	open empleadoCursor;
	bucle:loop
		fetch empleadoCursor into empNumber;
		if hayFilas = 0 then
			leave bucle;
		end if;
        select sum(quantityOrdered*priceEach) into plataVentas from orderdetails 
		join orders on orderdetails.orderNumber = orders.orderNumber
		join customers on orders.customerNumber = customers.customerNumber
		join employees on customers.salesRepEmployeeNumber = employees.employeeNumber
		where employeeNumber=empNumber;
        if plataVentas > 100000 then
			update employees set employees.comission=((5*plataVentas)/100) where employeeNumber=empNumber;
		else if plataVentas >=50000 and plataVentas<=100000 then
			update employees set employees.comission=((3*plataVentas)/100) where employeeNumber=empNumber;
		else
			update employees set employees.comission=0 where employeeNumber=empNumber;
		end if;
		end if;
	end loop bucle;
    close empleadoCursor;
delimiter ;

/*14*/
delimiter //
create procedure asigEMP()
begin
	declare hayFilas boolean default 1;
    declare empNumber int default null;
    declare empMenosClientes int default 0;
	declare customan cursor for select customers.salesRepEmployeeNumber from customers;
	declare continue handler for not found set hayFilas = 0;
	open customan;
	bucle:loop
		fetch customan into empNumber;
        set empMenosClientes = (select salesRepEmployeeNumber from customers group by salesRepEmployeeNumber order by count(*) asc limit 1);
		if hayFilas = 0 then
			leave bucle;
		end if;
        if customers.salesRepEmployeeNumber is null then
			update customers set salesRepEmployeeNumber = empMenosClientes;
		end if;
	end loop bucle;
    close empleadoCursor;
delimiter ;
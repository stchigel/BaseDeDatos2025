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
	select count(*), reportsTo from employees group by employeeNumber;
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
create procedure totOrd ()
begin
	select customerName,customerNumber,  
end//
delimiter ;
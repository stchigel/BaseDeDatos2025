/*/*1*/ 
delimiter //
create function CR7GOAT (estado text, fechaInicio date, fechaFin date) returns int deterministic
begin
	declare cantOrdenes int default 0;
    select count(*) into cantOrdenes from orders where status = estado and orderDate between 
	fechaInicio and fechaFin;
	return cantOrdenes;
    end//
delimiter ;
select CR7GOAT("Cancelled", "2001-09-11", "2003-12-25");

/*2*/
delimiter //
create function CR7GOAT2 (fechaEntrega1 date, fechaEntrega2 date) returns int deterministic
begin
	declare cantOrdenes int default 0;
    select count(*) into cantOrdenes from orders 
    where shippedDate between fechaEntrega1 and fechaEntrega2;
	return cantOrdenes;
    end//
delimiter ;
select CR7GOAT2("2001-09-11", "2003-12-25");

/*3*/
delimiter //
create function Gustavo_Adolfo_Costas_Makeira (numeroCLIENT int) returns text deterministic
begin
	declare ciudad text default "No City";
    select offices.city into ciudad from employees
    join offices on employees.officeCode = offices.officeCode
    join customers on customers.salesRepEmployeeNumber = employees.employeeNumber
    where customerNumber = numeroCLIENT;
	return ciudad;
    end//
delimiter ;
select Gustavo_Adolfo_Costas_Makeira(175);

/*4*/
delimiter //
create function CR7GOAT4 (lineaProducto int) returns int deterministic
begin
	declare cantProducts int default 0;
    select count(*) into cantProducts from products where productLine = lineaProducto;
	return cantProducts;
    end//
delimiter ;

/*5*/
delimiter //
create function CR7GOAT5 (codeOficina int) returns int deterministic
begin
	declare cantClientes int default 0;
    select count(*) into cantClientes from customers	
    join employees on customers.salesRepEmployeeNumber = employees.employeeNumber
    where employees.officeCode = codeOficina;
	return cantClientes;
    end//
delimiter ;

/*6*/
delimiter //
create function pedidosxOficina (codeOficina int) returns int deterministic
begin
	declare cantClientes int default 0;
    select count(*) into cantClientes from customers	
    join employees on customers.salesRepEmployeeNumber = employees.employeeNumber
    join orders on orders.customerNumber=customers.customerNumber
    where employees.officeCode = codeOficina;
	return cantClientes;
    end//
delimiter ;

/*7*/
delimiter //
create function ordenpedidosya (nroOrden int, nroProd int) returns int deterministic
begin
	declare beneficio int default 0;
    select priceEach-buyPrice into beneficio from products	
    join orderdetails on products.productCode = orderdetails.productCode
    where nroOrden=orderdetails.orderNumber and nroProd=products.productCode;
	return beneficio;
    end//
delimiter ;

/*8*/
delimiter //
create function isCancelled (nroOrden int) returns int deterministic
begin
	declare stat text default "";
    select status into stat from orders where orderNumber=nroOrden;
    if stat="Cancelled" then
		return -1;
	else
		return 0;
	end if;
    end//
delimiter ;

/*9*/
delimiter //
create function primOrden(nroCliente int) returns DATE deterministic
begin
	declare fechaOrden DATE default null;
    select orderDate into fechaOrden from orders where customerNumber=nroCliente order by orderDate asc limit 1;
    return fechaOrden;
    end//
delimiter ;
select primOrden(175);

/*10*/
delimiter //
create function calcMSRP (nroProd text) returns int deterministic
begin
	declare abMSRP int default null;
    declare totVentas int default null;
    declare porcentaje int default null;
    select count(*) into abMSRP from products 
    join orderdetails on orderdetails.productCode = products.productCode
    where priceEach<MSRP;
    select count(*) into totVentas from products 
    join orderdetails on orderdetails.productCode = products.productCode;
    set porcentaje=100*(abMSRP/totVentas);
    return porcentaje;
    end//
delimiter ;

/*11*/
delimiter //
create function ultORD(nroORDENG int) returns DATE deterministic
begin
	declare numOrden DATE default null;
    select orderDate into fechaOrden from orders 
    where orders.orderDate = numOrden order by products.productCode desc limit 1;
    return numOrden;
    end//
delimiter ;

/*12*/
delimiter //
create function fechaORDif (desde date, hasta date, PRODcod text) returns int deterministic
begin
	declare aux int default 0;
    select count(*) into aux from orderdetails join orders on orderdetails.orderNumber=orders.orderNumber where productCode=PRODcod and orderDate between desde and hasta;
    return aux;
    end//
delimiter ;

/*13*/
delimiter //
create function clientesAtendidos (codEmp int) returns int deterministic
begin
	declare aux int default 0;
    select count(*) into aux from customers where salesRepEmployeeNumber=codEmp;
    return aux;
    end//
delimiter ;

/*14*/
delimiter //
create function repAp (codEmp int) returns text deterministic
begin
	declare aux int default 0;
    declare apellido text default "No hay";
    select reportsTo into aux from employees where employeeNumber=codEmp;
	select lastName into apellido from employees where employeeNumber=aux;
    return apellido;
    end//
delimiter ;

/*EJ extras*/

/*1*/
delimiter //
create function nivelEmp (codEmp int) returns text deterministic
begin
	declare aux int default 0;
    select count(*) into aux from employees where reportsTo=codEmp;
    if aux>20 then
		return "Nivel 3";
	elseif aux>10 then
		return "Nivel 2";
	else
		return "Nivel 1";
	end if;
    end//
delimiter ;

/*2*/
delimiter //
create function dias (orderDate DATE, shippedDate DATE) returns INT deterministic
begin
	declare aux int default 0;
    select DATEDIFF(say, orderDate, shippedDate) into aux;
    return aux;
    end//
delimiter ;

/*3*/
delimiter //
create function cancel () returns INT deterministic
begin
	declare aux int default 0;
    select count(*) into aux from orders where dias(orderDate, shippedDate)>10 and status!="Cancelled";
    update orders set status="Cancelled" where dias(orderDate, shippedDate)>10;
    return aux;
    end//
delimiter ;

/*4*/


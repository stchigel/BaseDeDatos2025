/*TEMA 1*/
/*1*/
delimiter //
create function clienteFrecuente (claientAIDI int) returns bool deterministic
begin
	declare frecuente bool default 0;
    declare total int default 0;
    declare total2 int default 0;
    declare aux float default 0;
    select count(idPedido) into total from pedido where Cliente_codCliente=claientAIDI and fecha between DATE_SUB(current_date(), INTERVAL 6 MONTH) and current_date();
    select count(idPedido) into total2 from pedido where fecha between DATE_SUB(current_date(), INTERVAL 6 MONTH) and current_date();
    return frecuente;
    set aux = (total/total2)*100;
    if aux>=5 then
		return 1;
	else
		return 0;
	end if;
    end//
delimiter ;
select clienteFrecuente(1);

/*2*/
delimiter //
create function cantpedidosPAGO(claientAIDI int) returns int deterministic
begin
	declare cantPEDIDOSpendientes int default 0;
    select count(*) into cantPEDIDOSpendientes from pedido where Cliente_codCliente=claientAIDI and
    Estado_idEstado in (select idEstado from estado where nombre="pendiente");
    return cantPEDIDOSpendientes;
end//
delimiter ;
select cantpedidosPAGO(1);

/*TEMA 2*/
/*1*/
delimiter //
create function provedorFrecuente (provaiderAIDI int) returns bool deterministic
begin
	declare frecuente bool default 0;
    declare total int default 0;
    declare total2 int default 0;
    declare aux float default 0;
    select count(idIngreso) into total from ingresostock where Proveedor_idProveedor=provaiderAIDI and fecha between DATE_SUB(current_date(), INTERVAL 2 MONTH) and current_date();
    select count(idIngreso) into total2 from ingresostock where fecha between DATE_SUB(current_date(), INTERVAL 2 MONTH) and current_date();
    return frecuente;
    set aux = (total/total2)*100;
    if aux>=5 then
		return 1;
	else
		return 0;
	end if;
    end//
delimiter ;
select provedorFrecuente(1);

/*2*/
delimiter //
create function precioPROMEDIOprovedor(productCODE int) returns float deterministic
begin
	declare promedio float default 0;
	declare total float default 0;
    select sum(producto_proveedor.precio) into total from producto_proveedor 
    where Producto_codProducto=productCODE;
    set promedio=total/count(Proveedor_idProveedor);
    return promedio;
end//
delimiter ;
select precioPROMEDIOprovedor(1);

/*TEMA 3*/
/*1*/
delimiter //
create function cantEntradas(codFunc int) returns int deterministic
begin
	declare cant int default 0;
	select sum(cantEntradas) into cant from compra where funcion_idFuncion=codFunc;
    return cant;
end//
delimiter ;

/*2*/
delimiter //
create function calcPuntos(codCliente int) returns float deterministic
begin
	declare cant float default 0;
	select sum(cantEntradas*valorEntrada) into cant from compra 
    join funcion on funcion_idFuncion=idFuncion where cliente_idCliente=codCliente
    and compra.fecha between DATE_SUB(current_date(), INTERVAL 1 MONTH) and current_date();
    return cant/4;
end//
delimiter ;

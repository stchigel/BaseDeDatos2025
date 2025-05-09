/*1*/
delimiter //
create procedure stock()
begin
	declare hayFilas boolean default 1;
    
    declare codigoProd int default 0;
    declare ingresoProd int default 0;
    
	declare productoCursor cursor for select codProducto, sum(cantidad) from producto 
    join ingresostock_producto on codProducto=Producto_codProducto join ingresostock on IngresoStock_idIngreso=idIngreso
    where datediff(current_date(), fecha)<=7 group by codProducto;
	declare continue handler for not found set hayFilas = 0;
	open productoCursor;
    bucle:loop
		fetch productoCursor into codigoProd, ingresoProd;
		if hayFilas = 0 then
			leave bucle;
		end if;
        update producto set stock = stock + ingresoProd where codProducto = codigoProd;
	end loop bucle;
    close productoCursor;
    end//
    delimiter ;
call stock();

/*2*/
delimiter //
create procedure bajarPrecio()
begin
	declare hayFilas boolean default 1;
    declare cantVentas int default 0;
    declare codigoProd int default 0;
    
	declare ventasCursor cursor for select codProducto, sum(cantidad) from pedido_producto
    join producto on Producto_codProducto = codProducto
    where datediff(current_date(), fecha)<=7 group by codProducto;
	declare continue handler for not found set hayFilas = 0;
	open ventasCursor;
    bucle:loop
		fetch ventasCursor into codigoProd, cantVentas;
		if hayFilas = 0 then
			leave bucle;
		end if;
        if cantVentas < 100 then 
			update producto set precio = (precio*0.9) where codProducto = codigoProd;
        end if;
	end loop bucle;
    close ventasCursor;
    end//
    delimiter ;
call bajarPrecio();
    
/*3*/
delimiter //
create procedure precioProovedor()
begin
	declare hayFilas boolean default 1;
    declare precioProvedor int default 0;
    declare codigoProd int default 0;
    
	declare precioProvepuerta cursor for select Producto_codProducto, max(producto_proveedor.precio) from producto_proveedor 
    group by Producto_codProducto;
	declare continue handler for not found set hayFilas = 0;
	open ventasCursor;
    bucle:loop
		fetch precioProvepuerta into codigoProd, precioProvedor;
		if hayFilas = 0 then
			leave bucle;
		end if;
		update producto set precio = (producto_proveedor.precio*1.10) where codProducto = codigoProd;
	end loop bucle;
    close precioProvepuerta;
    end//
    delimiter ;
call precioProovedor();

/*4*/
ALTER TABLE proveedor ADD nivel varchar(45);
delimiter //
create procedure nivel()
begin
	declare hayFilas boolean default 1;
    
    declare codigoProov int default 0;
    declare ingresoProov int default 0;
    
	declare proovedorCursor cursor for select Proveedor_idProveedor, count(*) from ingresostock
    where datediff(current_date(), fecha)<=60 group by Proveedor_idProveedor;
	declare continue handler for not found set hayFilas = 0;
	open proovedorCursor;
    bucle:loop
		fetch proovedorCursor into codigoProov, ingresoProov;
		if hayFilas = 0 then
			leave bucle;
		end if;
        if ingresoProov<=50 then
			update proveedor set nivel = "Bronce" where idProveedor=codigoProov;
		else if ingresoProov<=100 then
			update proveedor set nivel = "Plata" where idProveedor=codigoProov;
		else
			update proveedor set nivel = "Oro" where idProveedor=codigoProov;
		end if;
        end if;
	end loop bucle;
    close proovedorCursor;
    end//
delimiter ;
drop procedure nivel;
call nivel();

/*5*/
delimiter //
create procedure estadoPedidois()
begin
	declare hayFilas boolean default 1;
    
    declare codigoProd int default 0;
    declare precioProd int default 0;
    declare estate varchar(45) default "Null";
    
	declare pedidosCursor cursor for select codProducto, precio from producto 
    join pedido_producto on codProducto = Producto_codProducto
    join pedido on Pedido_idPedido = idPedido
    join estado on Estado_idEstado = idEstado
    where estado.nombre = "Por enviar"
    group by codProducto;
	declare continue handler for not found set hayFilas = 0;
	open pedidosCursor;
    bucle:loop
		fetch pedidosCursor into codigoProd, precioProd;
		if hayFilas = 0 then
			leave bucle;
		end if;
		update pedido_producto set precioUnitario = precioProd where Producto_codProducto = codigoProd;
    end loop bucle;
    close pedidosCursor;
    end//
    delimiter ;
drop procedure estadoPedidois;
call estadoPedidois();
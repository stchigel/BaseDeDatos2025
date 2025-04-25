/*me estoy meando, me estoy meando, a ver cual de ustedes abre la boca*/
/*1*/
delimiter //
create trigger moficica_ingreso after insert on pedido_producto for each row
begin
	update ingresostock_producto set cantidad = 
    (ingresostock_producto.cantidad - pedido_producto.cantidad); 
end//
delimiter ;

/*2*/
delimiter //
create trigger borra_ingreso before delete on ingresostock for each row
begin
	delete from ingresostock_producto;
end//
delimiter ;

/*3*/
delimiter //
create trigger moficica_prod after insert on pedido for each row
begin
	declare cant int;
	select sum(cantidad*precioUnitario) into cant from pedido_producto join pedido on Pedido_idPedido = idPedido
    where Cliente_codCliente=new.Cliente_codCliente;
    
end//
delimiter ;

/*4*/
delimiter //
create trigger moficica_prod after insert on ingresostock_producto for each row
begin
	update producto set stock = (producto.stock+ingresostock_producto.cantidad);
end//
delimiter ;
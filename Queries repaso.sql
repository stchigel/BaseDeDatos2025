/*1*/ select nombre from proveedor where ciudad = "La Plata";
/*2*/ delete from articulo where (select material_codigo from compuesto_por where articulo_codigo = codigo) is null;
/*3*/ select codigo, descripcion from articulo join compuesto_por on codigo=articulo_codigo join provisto_por on provisto_por.material_codigo = compuesto_por.material_codigo where proveedor_codigo = (select codigo from proveedor where nombre="Lopez SA");
/*4*/ select proveedor.codigo, proveedor.nombre from proveedor 
join provisto_por on proveedor.codigo=provisto_por.proveedor_codigo 
join material on provisto_por.material_codigo=material.codigo 
join compuesto_por on material.codigo=compuesto_por.material_codigo 
join articulo on compuesto_por.articulo_codigo=articulo.codigo 
where precio > 10000 group by proveedor.codigo;
/*5*/ select codigo from articulo where precio = (select max(precio) from articulo);
/*6*/ select descripcion from articulo order by (select sum(stock) from tiene where articulo_codigo=articulo.codigo) desc limit 1;
/*7*/ select almacen.codigo from almacen join tiene on almacen.codigo=tiene.almacen_codigo join compuesto_por on tiene.articulo_codigo = compuesto_por.articulo_codigo where compuesto_por.material_codigo = 2 group by almacen.codigo;
/*8*/ select descripcion from articulo
order by (select count(compuesto_por.material_codigo) from compuesto_por where articulo_codigo = articulo.codigo group by articulo_codigo) desc limit 1;
/*9 VER*/ update articulo set precio = precio*1.20 where (select sum(stock) from tiene where articulo_codigo=articulo.codigo)<20;
/*10*/ select avg(cant) as avgcant from (select count(compuesto_por.material_codigo) as cant from compuesto_por group by articulo_codigo) as tabla; 
/*11*/ select max(precio), min(precio), avg(precio), almacen_codigo from tiene join articulo on articulo_codigo=codigo group by almacen_codigo;
/*12*/ select sum(precio*stock) from articulo join tiene on articulo.codigo=articulo_codigo group by almacen_codigo;
/*13*/ select sum(precio*stock) from articulo join tiene on articulo.codigo=articulo_codigo group by articulo_codigo having sum(stock) > 100;
/*14*/ select * from articulo where precio>5000 having (select count(compuesto_por.material_codigo) as cant from compuesto_por where articulo_codigo=articulo.codigo)>3;
/*15*/ select material_codigo from compuesto_por join articulo on articulo_codigo=articulo.codigo where articulo.precio > (select avg(precio) from tiene join articulo on articulo_codigo=articulo.codigo where almacen_codigo=2);

/*prueba view*/
create view ej1 as select nombre from proveedor where ciudad = "La Plata";
select * from ej1;

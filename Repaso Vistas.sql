/*2*/
create view totalorden as select sum(priceEach*quantityOrdered)as total from orderdetails 
group by orderLineNumber order by total desc;
select * from totalorden;

/*3*/
create view mayorPromedio as select * from products 
where precio > (select avg(precio)from products) group by productCode;
select * from mayorPromedio;

/*6*/
create view custNoComp as select * from customers where customerNumber 
not in (select customerNumber from orders);

/*10*/
create view custCompCara as select customerNumber, phone, addressLine1, addressLine2 
from customers where customerNumber not in 
(select customerNumber from orders join orderdetails on orderdetails.orderNumber=orders.orderNumber
where sum(quantityOrdered*priceEach)>30000 and timediff(year, orderDate, current_date())>=2);

/*13*/
create view custmas as select customerNumber, sum(quantityOrdered) as sum from orders 
join orderdetails on orderdetails.orderNumber=orders.orderNumber group by customerNumber order by sum desc limit 1;
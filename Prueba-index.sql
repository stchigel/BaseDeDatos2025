EXPLAIN ANALYZE SELECT * FROM products where productName="2001 Ferrari Enzo";
/*OUTPUT: 11:46:53	EXPLAIN ANALYZE SELECT * FROM products where productName="2001 Ferrari Enzo"	1 row(s) returned	0,0035 sec / 0,000015 sec
*/
/*EXPLAIN: '-> Filter: (products.productName = \'2001 Ferrari Enzo\')  (cost=12 rows=11) (actual time=0.0743..0.337 rows=1 loops=1)\n    -> Table scan on products  (cost=12 rows=110) (actual time=0.0449..0.314 rows=110 loops=1)\n'
*/
CREATE INDEX index_productName ON products (productName);
/*OUTPUT: 11:47:36	EXPLAIN ANALYZE SELECT * FROM products where productName="2001 Ferrari Enzo"	1 row(s) returned	0,0017 sec / 0,000016 sec
*/
/*EXPLAIN: '-> Index lookup on products using index_productName (productName=\'2001 Ferrari Enzo\')  (cost=0.35 rows=1) (actual time=0.0512..0.0592 rows=1 loops=1)\n'
*/
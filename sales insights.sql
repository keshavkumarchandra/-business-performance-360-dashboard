# tables 
select * from sales.customers;
select * from sales.transactions;
select * from sales.products;
select * from sales.markets;

select count(*) from sales.transactions;
select * from sales.transactions where market_code="mark001" limit 10 ;

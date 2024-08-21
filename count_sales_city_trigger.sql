select * from sales order by order_line desc

select city from customer where customer_id = 'JM-15265'

select count(s.customer_id),count(s.product_id), sum(s.sales),
sum(s.quantity),sum(s.discount),sum(s.profit) from  sales as s
inner join customer as c
on s.customer_id = c.customer_id
where c.city = 'Jackson'

Create table report(
	city character varying(255),
	customer_count int,
	product_count int,
	total_sales double precision,
	total_quantity int,
	total_discount double precision,
	total_profit double precision 
)

select * from report

Create or Replace Function city_report_status()
Returns Trigger as $$
Declare 
	New_city varchar(255);
	status_customer int;
    status_product int;
    status_sales float;
    status_quantity int;
    status_discount float;
    status_profit float;
    status_report int;
Begin

	select city into New_city from customer 
	where customer_id = New.customer_id;
   
    select c.city, count(s.customer_id) as "customer_count", count(s.product_id) as "product_count", 
	sum(s.sales) as "total_sales", sum(s.quantity) as "total_quantity", sum(s.discount) as "total_discount",
	sum(s.profit) as "total_profit" into New_city, status_customer,status_product,status_sales,status_quantity,status_discount,     
    status_profit from  sales as s 
    inner join customer as c
    on s.customer_id = c.customer_id
    where c.city = New_city
    group by c.city;

	select count(*) into status_report from report where city = New_city;
	If status_report = 0 Then
	Insert into report (city,customer_count,product_count,total_sales,total_quantity,total_discount,total_profit)
	 values(New_city,status_customer,status_product,status_sales,status_quantity,status_discount,status_profit);  
	Else
	Update report set customer_count = status_customer, product_count = status_product,
	total_sales = status_sales, total_quantity = status_quantity, total_discount = status_discount,
	total_profit = status_profit where city = New_city;
    End if;
    Return New;
End
$$ Language plpgsql

Create Trigger count_sales_insert
After insert on sales
For each row
Execute Function city_report_status()

select * from sales order by order_line desc

insert into sales(order_line,order_id,order_date,ship_date,ship_mode,customer_id,product_id,sales,quantity,discount,profit)
values(10001,'US-2014-114377','2024-08-17','2024-08-24','Standard Class','JM-15265','FUR-CH-10004218',200.0,5,1.5,5.0)

select * from report

select c.city, count(s.customer_id),count(s.product_id), sum(s.sales),
sum(s.quantity),sum(s.discount),sum(s.profit) from  sales as s
inner join customer as c
on s.customer_id = c.customer_id
where c.city = 'New York City'
group by c.city
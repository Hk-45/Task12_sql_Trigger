Create table report_table(
	product_id character varying(255),
	total_sales double precision,
	total_profit double precision
)

select * from report_table

select count(*) from sales where product_id ='FUR-TA-10000577'	
	
update report_table set total_sales = 250.2 , total_profit= 5.452 where product_id = 'FUR-TA-10000577'	

Create or Replace Function update_sales_profit ()
Returns Trigger as $$
Declare 
      sales_status float;
      profit_status float;
      report_status int;
Begin
	select sum(sales),sum(profit) into sales_status, profit_status from sales 	
    where product_id = New.product_id;		
    select count(*) into report_status from report_table where product_id = New.product_id;

    If report_status = 0 Then 
   	insert into report_table values(New.product_id, sales_status, profit_status);   
    Else 
	update report_table set total_sales = sales_status, total_profit = profit_status
	where product_id = New.product_id;
    End If;
    Return New;
End;
$$ Language plpgsql


Create Trigger sales_insert
After insert on sales
For each row
Execute Function update_sales_profit ()

insert into sales(order_line,order_id,order_date,ship_date,ship_mode,customer_id,product_id,sales,quantity,discount,profit)
values(100011,'CA-2016-152156','2024-08-17','2024-08-24','Standard Class','CG-12520','NEW-PROD',100.50,2,0,5.11)

select * from sales order by order_line DESC
	
select  sum(sales), sum(profit) from sales where product_id = 'NEW-PROD'	

select * from report_table

select sum(sales) from sales where product_id = 'FUR-TA-10000577'
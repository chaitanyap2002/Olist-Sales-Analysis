-- 1. Weekday Vs Weekend Total Sales  --------------------------------------------------------------------------------------
Select Week_Name as Weekname,
round(sum(payment_value),2) as total_sales
from olist_orders_dataset as o left join olist_order_payments_dataset as p
on o.order_id = p.order_id
where order_purchase_timestamp is not null
group by Weekname


-- 2. Number of Orders with review score 5 and payment type as credit card.

select review_score as review_score,
count(distinct o.order_id) as number_of_Orders,
p.payment_type as payment_mode 
from olist_orders_dataset as o inner join olist_order_reviews_dataset as r
on o.order_id = r.order_id
inner join olist_order_payments_dataset as p
on o.order_id = p.order_id
where review_score = 5 and payment_type = 'credit_card';


-- 3. Average number of days taken for order_delivered_customer_date for pet_shop
-- Used STR_TO_DATE to convert date from text to date format & also to change the format from 'DD-MM-YYYY' to 'YYYY-MM-DD'

select round(avg(o.shipping_days),0) as avg_number_of_days
from 
(
		select *, DATEDIFF(
			STR_TO_DATE(order_delivered_customer_date, '%d-%m-%Y'),
			STR_TO_DATE(order_purchase_timestamp, '%d-%m-%Y')
		) as shipping_days from olist_orders_dataset
        where order_purchase_timestamp != "" and order_delivered_customer_date != ""
) 
as o inner join olist_order_items_dataset oid
on o.order_id = oid.order_id 
inner join olist_products_dataset as opd on oid.product_id = opd.product_id
where opd.Product_Category = "Pet_Shop";



-- 4. Average price and payment values from customers of sao paulo city

-- Average price
select round(avg(oid.price),2) as Average_Price
from olist_orders_dataset
as o inner join olist_order_items_dataset oid
on o.order_id = oid.order_id
inner join olist_customers_dataset as c
on c.customer_id = o.customer_id where c.customer_city_new = 'sao paulo';


-- Average payment value 
select round(avg(p.payment_value),2) as avg_payment_value_price
from olist_orders_dataset
as o inner join olist_order_payments_dataset as p
on o.order_id = p.order_id
inner join olist_customers_dataset as c
on o.customer_id = c.customer_id
where c.customer_city = 'sao paulo';

-- 5. Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores

select ord.review_score,
round(avg(DATEDIFF(STR_TO_DATE(o.order_delivered_customer_date, '%d-%m-%Y'), STR_TO_DATE(o.order_purchase_timestamp, '%d-%m-%Y'))),0)
as shipping_days
from olist_orders_dataset as o
inner join olist_order_reviews_dataset as ord
on o.order_id = ord.order_id
where ord.review_score is not null
group by ord.review_score
order by shipping_days desc






use pizza_sales;
select * from orders;

describe orders;

alter table orders 
modify column time Time;

alter table orders
modify column date DATE;

describe orders;

alter table orders
change column time order_time time ; 

describe orders;

alter table orders 
change column date order_date date;

select * from orders ;

alter table orders 
modify column order_id int not null,
modify column order_date date not null ,
modify column order_time time not null ;

describe orders;

select * from order_details;
select * from pizza_types;
select * from orders;
select * from pizzas;

alter table order_details
modify column order_id int not null;

/*this is to find whether it has unique values or not */
select case when count(*) = 0 then 'Duplicates not found' else 'Duplicates Exists' end as result 
from (select  order_details_id
from order_details
group by order_details_id
having count(*) > 1) as duplicates;


alter table orders 
add primary key(order_id) ;

alter table order_details
add primary key (order_details_id);

alter table pizzas 
modify pizza_id varchar(50); 

alter table pizzas 
add primary key(pizza_id);

alter table pizza_types 
modify pizza_type_id varchar(50);

alter table pizza_types
add primary key(pizza_type_id); 

alter table order_details 
add constraint fk_orders 
foreign key(order_id) 
references orders(order_id);

alter table order_details 
add constraint fk_pizzas
foreign key(pizza_id) 
references pizzas(pizza_id);

alter table pizzas 
add constraint fk_pizza_types
foreign key (pizza_type_id)
references pizza_types(pizza_type_id);

show keys from pizzas 
where key_name = 'Primary';

select * from order_details o 
join 
pizzas p 
on o.pizza_id = p.pizza_id;

create view master_dataset as
(select o.order_id ,  o.order_date , o.order_time , pt.name as pizza_name , pt.category , p.size , p.price ,od.quantity, (p.price*od.quantity) as total_price 
from orders o 
join 
order_details od 
on o.order_id = od.order_id
join 
pizzas p 
on od.pizza_id = p.pizza_id
join 
pizza_types pt 
on p.pizza_type_id = pt.pizza_type_id
);

select round(sum(total_price),2) as revenue from master_dataset;

select pizza_name,sum(quantity) as total_sold from master_dataset 
group by pizza_name 
order by total_sold desc ;

select count(distinct order_id) as total_orders 
from master_dataset;

select round(sum(total_price) / count(distinct order_id),2) as average_order_value 
from master_dataset;

#best selling pizza
select pizza_name , sum(quantity) as total_sold 
from master_dataset 
group by pizza_name 
order by total_sold desc 
limit 10 ;

#highest revenue pizza
select pizza_name , round(sum(total_price),2) as revenue 
from master_dataset 
group by pizza_name 
order by revenue desc 
limit 10;

#sales by category
select category , round(sum(total_price),2) as revenue 
from master_dataset 
group by category 
order by revenue desc;

#order per hour , per day 
select date(order_date)as date, hour(order_time) as hour , 
count(distinct order_id) as total_orders 
from master_dataset 
group by date , hour 
order by total_orders desc ;

select monthname(order_date) as month_name ,
round(sum(total_price),2) as revenue 
from master_dataset 
group by month_name 
order by revenue desc;

#percentage by category 
select category ,concat( round(sum(total_price)*100.00/(select sum(total_price)from master_dataset),2),'%') as revenue_percentage 
from master_dataset 
group by category 
order by revenue_percentage desc;

#top 3 pizzas in each category 
with cte as (select category , pizza_name , sum(quantity) as total_sold , dense_rank() over (partition by category order by Sum(quantity) desc) as rnk  
from master_dataset 
group by category , pizza_name)
select category , pizza_name , total_sold 
from cte 
where rnk<=3
order by category , total_sold desc ;

#Weekday vs Weekend analysis 

select 
	case 
		when dayname(order_date)
		in ('Saturday','Sunday')
		then 'Weekend'
		else 'Weekday'
	end as order_type,
	round(sum(total_price),2) as revenue,
	count(distinct(order_id)) as total_orders
from master_dataset
group by order_type ;

#Peak Hours on Weekdays 
select hour(order_time) as peak_hour_of_the_day , count(distinct order_id) as total_orders 
from master_dataset
where dayofweek(order_date) between 2 and 6 
group by peak_hour_of_the_day
order by total_orders desc ;

#Peak hours on Weekends
select hour(order_time) as peak_hour_of_the_day , count(distinct order_id) as total_orders 
from master_dataset
where dayofweek(order_date) in(1,7) 
group by peak_hour_of_the_day
order by total_orders desc ;

#combined query for peak Hours on Weekdays as well as on weekends 
select case when dayofweek(order_date) in (1,7) then 'Weekend' else 'Weekday' end as day_type , 
hour(order_time) as peak_hour ,
count(order_id)  as total_orders ,
sum(quantity) as total_pizza_sold , 
round(sum(total_price),2) as total_revenue ,
concat(100*(count(order_id)/sum(quantity)),'%') as fullfillment_rate
from master_dataset
group by day_type ,  peak_hour 
order by day_type , total_orders desc;

# On weekdays we can see mostly in the afternoon i.e 12 , 13 hour - there are max orders and has 95%+ fullfillment rate we need more staff to make the rate above 98%+  
# here we have the most demands as well revenue generation but can be increase with increase with staff 

# On Weekends evening has the highest orders hour 17,18 gives most of the revenue  

#This query gives the most_pizza_sold in peak hours(weekdays , weekends)
select case when dayofweek(order_date) in (1,7) then 'Weekend' else 'Weekday' end as day_type , 
hour(order_time) as peak_hour ,
pizza_name, 
sum(quantity) as total_pizza_sold , 
round(sum(total_price),2) as total_revenue ,
count(distinct order_id) as total_orders
from master_dataset
where (dayofweek(order_date)in(1,7) and hour(order_time) in (12,13)) 
or 
(dayofweek(order_date) between 2 and 6 and hour(order_time) in (17,18))
group by day_type , peak_hour , pizza_name 
order by total_pizza_sold ;

#This query gives you the ingredeints mostly used in peak hours but the ingredients are combined as per pizza so cant dont have seperate ingredient 
SELECT pi.ingredients as ingredient_combination,
SUM(md.quantity) AS total_quantity_sold
FROM master_dataset md
JOIN pizza_types pi
ON md.pizza_name = pi.name
WHERE 
    (
        DAYOFWEEK(md.order_date) BETWEEN 2 AND 6
        AND HOUR(md.order_time) IN (12,13)
    )
    OR
    (
        DAYOFWEEK(md.order_date) IN (1,7)
        AND HOUR(md.order_time) IN (19,20)
    )

GROUP BY pi.ingredients
ORDER BY total_ingredient_usage DESC;

#To get a single ingredient which is mostly required during peak Hours 
#We will use recursive cte to extract each ingredient and then sum it up 

WITH RECURSIVE ingredient_split AS (
    SELECT
        TRIM(SUBSTRING_INDEX(ingredients, ',', 1)) AS ingredient,
        SUBSTRING(
            ingredients,
            LENGTH(SUBSTRING_INDEX(ingredients, ',', 1)) + 2
        ) AS remaining_ingredients,quantity
    FROM master_dataset md
    JOIN pizza_types pt
    ON md.pizza_name = pt.name
    WHERE 
        (
            DAYOFWEEK(md.order_date) BETWEEN 2 AND 6
            AND HOUR(md.order_time) IN (12,13)
        )
        OR
        (
            DAYOFWEEK(md.order_date) IN (1,7)
            AND HOUR(md.order_time) IN (19,20)
        )

    UNION ALL

    SELECT
        TRIM(SUBSTRING_INDEX(remaining_ingredients, ',', 1)),

        CASE
            WHEN remaining_ingredients LIKE '%,%'
            THEN SUBSTRING(
                    remaining_ingredients,
                    LENGTH(SUBSTRING_INDEX(remaining_ingredients, ',', 1)) + 2
                 )
            ELSE ''
        END,
        quantity
    FROM ingredient_split
    WHERE remaining_ingredients <> ''
)
SELECT
    ingredient,
    SUM(quantity) AS total_usage
FROM ingredient_split
GROUP BY ingredient
ORDER BY total_usage DESC;




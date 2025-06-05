use Blinkit

select* from Blinkit_Data


--- cleaning data ---

update Blinkit_Data
set Item_Fat_Content = CASE
when Item_Fat_Content in ( 'LF' ,'low fat' ) then 'Low Fat'
when  Item_Fat_Content = 'reg' then 'Regular'
else Item_Fat_Content
end


 --- 1. Total sales in millions ---

 select cast(sum(Sales)/ 1000000 as decimal (10,2)) as total_sales_in_millions from Blinkit_Data

--- 2.Average sales ---

  select cast(avg(Sales)as decimal (10,0)) as Average_sales from Blinkit_Data

--- 3. No of Items ---

select count(*) as total_no_of_items from Blinkit_Data

--- 4. Total sales in lowfat content  ---

select cast(sum(sales)/ 1000000 as decimal (10,2)) as total_sales_in_lowfat from Blinkit_Data
where Item_Fat_Content = 'Low Fat'

--- 5. Total sales in regular content  ---

select cast(sum(sales)/ 1000000 as decimal (10,2)) as total_sales_in_Regular from Blinkit_Data
where Item_Fat_Content = 'Regular'

--- 6. Total sales per Year and contents  ---

select Outlet_Establishment_Year ,Item_Fat_Content , cast(sum(Sales)/ 1000000 as decimal (10,2)) as total_sales_in_millions from Blinkit_Data
group by Outlet_Establishment_Year , Item_Fat_Content
order by Outlet_Establishment_Year , Item_Fat_Content

--- 7. Average rating ---

select cast( avg(rating)as decimal (10,2)) as Average_rating from Blinkit_Data

--- 8. As per content = totale sales, average sales, no of items, average rating---

select Item_Fat_Content , 
                   cast(sum(Sales)as decimal (10,2)) as total_sales ,
				   cast(avg(Sales)as decimal (10,0)) as Average_sales,
				   count(*) as total_no_of_items,
				   cast( avg(rating)as decimal (10,2)) as Average_rating
				   from Blinkit_Data
group by Item_Fat_Content
order by total_sales desc

--- 9. As per item type = totale sales, average sales, no of items, average rating---

select Item_Type , 
                   cast(sum(Sales) as decimal (10,2)) as total_sales ,
				   cast(avg(Sales)as decimal (10,0)) as Average_sales,
				   count(*) as total_no_of_items,
				   cast( avg(rating)as decimal (10,2)) as Average_rating
				   from Blinkit_Data
group by Item_Type
order by total_sales desc

--- 10.  [TOP 5 ] As per item type = totale sales, average sales, no of items, average rating---


select top 5 Item_Type , 
                   cast(sum(Sales) as decimal (10,2)) as total_sales ,
				   cast(avg(Sales)as decimal (10,0)) as Average_sales,
				   count(*) as total_no_of_items,
				   cast( avg(rating)as decimal (10,2)) as Average_rating
				   from Blinkit_Data
group by Item_Type
order by total_sales desc


--- 11.  [BOTTOM 5 ] As per item type = totale sales, average sales, no of items, average rating---

select TOP 5 Item_Type , 
                   cast(sum(Sales) as decimal (10,2)) as total_sales ,
				   cast(avg(Sales)as decimal (10,0)) as Average_sales,
				   count(*) as total_no_of_items,
				   cast( avg(rating)as decimal (10,2)) as Average_rating
				   from Blinkit_Data
group by Item_Type
order by total_sales asc


--- 12. total sales by year---

select outlet_establishment_year , 
                    cast(sum(Sales) as decimal (10,2)) as total_sales ,
					cast(avg(Sales)as decimal (10,0)) as Average_sales,
					count(*) as total_no_of_items,
					cast( avg(rating)as decimal (10,2)) as Average_rating from Blinkit_Data
group by outlet_establishment_year
order by outlet_establishment_year asc

--- 13. total sales by tier 1 and tier 2---

select Outlet_location_type,
            isnull ([Low Fat],0) as Low_fat,
			 isnull ([Regular],0) as Regular
From
(
    select  Outlet_location_type, Item_fat_content,
	          cast(sum (sales) as decimal(10,2)) as sales
			  from Blinkit_Data
			  group by Outlet_location_type, Item_fat_content 
) as sourcetable
PIVOT
(
    sum(sales)
	for Item_fat_content in ([Low Fat],[Regular])
) as pivottable
order by 
Outlet_location_type;

--- 14. total sales by outlet size---

select
      Outlet_Size,
	  cast(sum(sales) as decimal (10,2)) as total_sales,
	  cast((sum(sales) * 100.0 / sum(sum(sales)) over ()) as decimal (10,2)) as sales_percentage
from Blinkit_Data
group by  outlet_size
order by  total_sales desc;



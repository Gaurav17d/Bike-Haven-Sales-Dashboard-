select * from customer 
select * from date 
select * from geography 
select * from internetsales
select * from product 
select * from productcategory
select * from productsubcategory 

alter table productsubcategory 
drop productsubcategoryalternatekey 

alter table productsubcategory 
rename englishproductsubcategoryname to subcategory

alter table productsubcategory 
rename productsubcategorykey to subcategorykey

alter table productsubcategory 
rename productcategorykey to categorykey

alter table productcategory 
rename productcategorykey to categorykey

alter table productcategory 
rename englishproductcategoryname to category

alter table productcategory 
drop productcategoryalternatekey 

select * from customer 
select * from date 
select * from geography 
select * from internetsales
select * from product 
select * from productcategory
select * from productsubcategory 

alter table product 
rename productsubcategorykey to subcategorykey

alter table product 
rename englishproductname  to productname

alter table product 
drop productalternatekey ,
drop color ,
drop safetystocklevel ,
drop reorderpoint ,
drop size ,
drop productline ,
drop daystomanufacture ,
drop modelname ,
drop englishdescription ;

select * from customer 
select * from date 
select * from geography 
select * from internetsales
select * from product 
select * from productcategory
select * from productsubcategory 

create table productinfo as (
select a.productkey, a.productname , b.* from 
product a 
full join (
select productsubcategory.* , productcategory.category  from 
productcategory 
full join 
productsubcategory 
on 
productcategory.categorykey= productsubcategory.categorykey) b
on 
a.subcategorykey = b.subcategorykey  ) ;

drop table product 
drop table productcategory
drop table productsubcategory

select * from productinfo
order by productkey

select * from customer 
where lastname like 'NULL'

alter table customer  add  fullname varchar 

UPDATE customer
SET fullname = (
    SELECT 
        CASE 
            WHEN gender = 'M' THEN 'Mr'
            WHEN gender = 'F' AND maritalstatus LIKE 'M' THEN 'Mrs'
            WHEN gender = 'F' AND maritalstatus LIKE 'S' THEN 'Ms'
            ELSE ''
        END || ' ' || firstname || ' '  || lastname
    FROM customer AS c
    WHERE c.customerkey = customer.customerkey 
);

alter table customer 
drop customeralternatekey ,
drop title ,
drop firstname ,
drop middlename ,
drop lastname , 
drop namestyle,
drop birthdate,
drop maritalstatus, 
drop suffix ,
drop gender,
drop emailaddress, 
drop totalchildren,
drop numberchildrenathome,
drop spanisheducation,
drop englisheducation,
drop frencheducation,
drop englishoccupation,
drop spanishoccupation,
drop frenchoccupation ,
drop houseownerflag,
drop numbercarsowned ,
drop addressline1,
drop addressline2,
drop phone ,
drop commutedistance ;




select * from customer 

select * from geography 


-- JOIN CUSTOMER AND GEOGRAPHY 
Create table customergeo as (
select  a.city, a.stateprovincename, a.englishcountryregionname , b.*
from geography a 
full join 
customer b
on 
a.geographykey = b.geographykey );

drop table geography
drop table customer 

select * from customergeo

alter table customergeo 
rename englishcountryregionname to country 

-- IMPORT SALES BUDGET TABLE 

create table salesbudget (
  date date ,
   budget  numeric    
  );

copy salesbudget 
  from 'C:\Program Files\PostgreSQL\16\data\Data-Resource\SalesBudget.csv ' delimiter ',' csv header ;
  
  SELECT * from salesbudget
  select * from customergeo
  select * from date
  select * from internetsales 
  select * from productinfo
  
  select date.* , internetsales.* 
  from date 
  inner join 
  internetsales 
  on date.datekey = internetsales.orderdatekey
  
  alter table internetsales 
  alter orderdate type date 
  using orderdate :: date
  
  alter table internetsales 
  alter shipdate type date 
  using shipdate :: date
  
  alter table date
  alter datekey type character varying
  
  select count (distinct orderdatekey) from internetsales --1123
  select count (distinct datekey) from date --6939 
  
  select * from customergeo 
  where extract (year from datefirstpurchase) < 2021 ;
  
  delete from customergeo 
  where extract (year from datefirstpurchase) < 2021 ;
  
  select count(distinct datefirstpurchase) from customergeo -- 1123
  select count(distinct datefirstpurchase) from customergeo-- 758 
  
  select count (distinct orderdate) from internetsales  -- 1123 / 758
  
 delete from internetsales 
  where extract (year from orderdate) < 2021 ;
  
  SELECT * from salesbudget
  select * from customergeo
  select * from date
  select * from internetsales 
  select * from productinfo
  
  -- sales  vs budget 
  -- product category vs sales amount 
  select a.category ,  
  sum (b.salesamount )  as total 
  from 
  productinfo a
  join 
  internetsales b
  on a.productkey = b.productkey 
  group  by a.category 
  order by total desc
  limit 10 
  
  
  -- reion wise sales 
  select customergeo.stateprovincename , sum(internetsales.salesamount) as total 
  from customergeo 
  join 
  internetsales 
  on
  customergeo.customerkey = internetsales.customerkey 
  group  by customergeo.stateprovincename 
  order by total desc 
  limit 10 
  
  
 -- top 10 customers 
  select a.fullname ,
  sum(b.salesamount) as total 
  from customergeo as a
  join 
  internetsales as b
  on a.customerkey = b.customerkey
  group by a.fullname 
  order by total desc
  limit 10
  
  -- top 10 product 
  select a.productname , 
  sum (b.salesamount ) as total
  from 
  productinfo as a 
  join 
  internetsales b
  on 
  a.productkey = b.productkey 
  group by a.productname
  order by total desc
  limit 10 
  
  
  select count (distinct datekey) from date -- 6939 // 1095
  select count (distinct orderdatekey ) from internetsales --758
  
  select count ( datekey) from date --1095
  select count ( orderdatekey ) from internetsales -- 58168
  
  delete from date 
  where calendaryear < 2021 ;
  
 create table internetsalesdate as  (
  select internetsales.* , date.* 
  from internetsales
  left join 
  date 
  on internetsales.orderdatekey = date.datekey ) 
create table dates as (  
  select datekey, 
  calendaryear from date )
  
  
  
  
 
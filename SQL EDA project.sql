

SQL EDA (Exploratory Data Analysis)

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    customer_id VARCHAR(50),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    company VARCHAR(100),
    city VARCHAR(100),
    country VARCHAR(100),
    phone1 VARCHAR(100),
    phone2 VARCHAR(100),
    email VARCHAR(100),
    subscription_date DATE,
    website VARCHAR(100)
);
select * from customers;

CREATE TABLE leads (
    id SERIAL PRIMARY KEY,
    account_id VARCHAR(50),
	lead_owner varchar(50),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    company VARCHAR(100),
    phone1 VARCHAR(100),
    phone2 VARCHAR(100),
    email_1 VARCHAR(100),
	email_2 varchar(100),
	Website varchar(100),
	Source varchar(50),
	Deal_stage varchar(50),
	Notes varchar(100)
);
select * from leads;

CREATE TABLE organizations (
    Index SERIAL PRIMARY KEY,
    organization_id VARCHAR(50),
	Name varchar(50),
    Website VARCHAR(100),
    Country VARCHAR(100),
    Description VARCHAR(100),
    Founded int,
    Industry VARCHAR(100),
    Number_of_employees int);

select * from organizations;	


create table people(
    Index SERIAL PRIMARY KEY,
    user_id VARCHAR(50),
	first_name VARCHAR(50),
    last_name VARCHAR(50),
	sex varchar(20),
	email VARCHAR(100),
    phone VARCHAR(100),
	date_of_birth DATE,
	job_title varchar(100)
);

select * from people;


create table products (
    index SERIAL PRIMARY KEY,
    name VARCHAR(100),
	description varchar(100),
    brand VARCHAR(50),
    category VARCHAR(50),
    price int,
    currency VARCHAR(20),
    stock int,
    ean varchar(50),
	color varchar(50),
	size varchar(50),
	availability varchar(50),
	internal_ID int);

select * from products;


EDA (Exploratory data analysis)
1)Basic data Overview -
- This step focuses on getting a clear first look at the dataset. It involves running simple queries like SELECT, LIMIT, COUNT, DISTINCT and DESCRIBE
to understand the size of the data, the structure of the tables, and the variety of values in key columns. Using commands such as DESCRIBE helps check column definitions and data types, while row counts and distinct checks highlight duplicates or gaps.
- The goal is to build a quick, reliable picture of the dataset before moving into deeper analysis.

1)using Describe command (using information.schema as postgresql dont support describe())
select column_name, data_type, is_nullable
from information_schema.columns
where table_name = 'customers';

2)leads table
select column_name, data_type, is_nullable
from information_schema.columns
where table_name = 'leads';

3)organizations table
select column_name, data_type, is_nullable
from information_schema.columns
where table_name = 'organizations';

4)people table
select column_name, data_type, is_nullable
from information_schema.columns
where table_name = 'people';

5)products table
select column_name, data_type, is_nullable
from information_schema.columns
where table_name = 'products';


2)using select() to preview full data of all tables
select * from customers;
select * from leads;
select * from organizations;
select * from people;
select * from products;


3)count() to count all number of rows from all tables
select count(*) from customers;
select count(*) from leads;
select count(*) from organizations;
select count(*) from people;
select count(*) from products;


4)Distinct() to identify unique values
select distinct country from customers;
select country, count(*) as total_count from customers group by country order by total_count desc;

Leads Table
select distinct company from leads;
select distinct source from leads;
select company, count(*) as total_count from leads group by company order by total_count desc;
select source, count(*) as total_count from leads group by source order by total_count desc;

Oraganizations Table
select distinct country from organizations;
select distinct founded from organizations;
select distinct industry from organizations;
select country, count(*) as total_count from organizations group by country order by total_count desc; 
select founded,count(*) as total_count from organizations group by founded order by total_count desc;
select industry, count(*) as total_count from organizations group by industry order by total_count desc;


People Table
select * from people;
select distinct sex from people;
select distinct date_of_birth from people;
select sex,count(*) as total_count from people group by sex order by total_count desc;
select date_of_birth, count(*) as total_count from people group by date_of_birth order by total_count desc;


Products Table
select * from products;
select distinct brand from products;
select distinct category from products;
select distinct color from products;
select distinct size from products;
select distinct availability from products;
select brand,count(*) as total_count from products group by brand order by total_count desc;
select category,count(*) as total_count from products group by category order by total_count desc;
select color, count(*) as total_count from products group by color order by total_count desc;
select size,count(*) as total_count from products group by size order by total_count desc;
select availability,count(*) as total_count from products group by availability order by total_count desc;



*AGGREGATIONS AND SUMMARIES
1)COUNT(DISTINCT) -
 a)select * from customers;
select count(distinct company) from customers;
select count(distinct country) from customers;
select count(distinct city) from customers;

b)select * from leads;
select count(distinct company) from leads;
select count(distinct source) from leads;
select count(distinct deal_stage) from leads;

c)select * from organizations;
select count(distinct country) from organizations;
select count(distinct founded) from organizations;
select count(distinct industry) from organizations;

d)select * from people;
select count(distinct sex) from people;

e)select * from products;
select count(distinct brand) from products;
select count(distinct category) from products;
select count(distinct color) from products;
select count(distinct size) from products;
select count(distinct availability) from products;


2)AVG()
a) select * from organizations;
select avg(founded)from organizations;

b)select * from products;
select avg(price) from products;
select avg(stock) from products;


3)SUM()
a)select * from products;
select sum(price) from products;
select sum(stock) from products;


4)min()
a)select * from organizations;
select min(founded) from organizations; 

b)select * from people;
select min(date_of_birth) from people;

c)select * from products;
select min(price) as min_price from products;
select min(stock)as min_stock from products;



5)group by()
a)select * from customers;
select city,first_name,last_name from customers group by city,first_name,last_name;

b)select * from leads;
select first_name,last_name,lead_owner,source,deal_stage,count(deal_stage) as total_leads from leads
group by first_name,last_name,source, deal_stage, company, lead_owner order by total_leads desc;

c)select * from organizations;
select country,industry, sum(number_of_employees) as total_employees from organizations group by country, industry
order by country, industry desc;

d)select * from products;
select brand,category,size,availability,sum(price) as total_price from products
group by size, availability,brand,category
order by size, availability,brand,category;



6)Having()
select * from organizations;
select country,industry,SUM(number_of_employees) AS total_employees from organizations
group by country, industry having sum(number_of_employees) > 5000 order by country, industry;



3)FILTERING AND SLICING DATA
1)where()
select *  from customers;
select * from customers where country='Norway';


2)AND()
select * from leads where source='Website Form' and deal_stage='Closed Won';


3)OR()
select * from organizations where country='Namibia' or country='Ecuador';


4)Between()
select * from people where date_of_birth between'1980-01-01' and '2000-01-01';

5)in()
select * from products where color in ('Blue');



4)WORKING WITH DATES
1)Year()
select extract(year from subscription_date) as year from customers;

2)Month()
select extract(month from subscription_date)as year from customers;

3)Day()
select extract(day from subscription_date)as day from customers;

4)Datediff()
select customer_id,(current_date - subscription_date) as days_since_subscription from customers;




5)CONDITIONAL LOGIC AND STRINGS
1)Case - 
select name,brand,stock,case when stock = 0 then 'Out of Stock' when stock < 10 then 'Low Stock'
else 'Available' end as stock_status from products;

2)CONCAT()
select customer_id,concat(first_name, ' ', last_name) as full_name,email from customers;

3)LENGTH()
select length(company) from leads;

4)SUBSTRING()
select substring(website,1,10)from leads;


6)JOINS AND RELATIONSHIPS
1)INNER JOIN ()-
select c.id,c.first_name,c.last_name,l.id,l.deal_stage 
from customers c inner join leads l on c.id = l.id;


2)LEFT JOIN() -
select c.id,c.first_name,c.last_name,l.deal_stage,l.source,l.company
from customers c left join leads l on c.id = l.id;

3)RIGHT JOIN() -
select p.index,p.first_name,p.last_name,p.job_title,o.country,o.industry,o.number_of_employees
from people p right join organizations o on p.index = o.index;

4)FULL OUTER JOIN() -
select p.index,p.first_name,p.last_name,p.sex,o.country,o.industry,o.number_of_employees
from  people p full outer join organizations o on p.index = o.index;


5)CROSS JOIN()-
select p.name as product_name,o.name as organization_name from products p cross join organizations o;


6)SELF JOIN()-
select p1.user_id,p1.first_name as person1,p2.first_name as person2,p1.job_title from people p1
inner join people p2 on p1.job_title = p2.job_title and p1.user_id <> p2.user_id;



7)SUBQUERIES AND ADVANCED EDA
1)subquery with where()-
select customer_id,first_name,last_name,country from customers where country in (select country
from organizations where number_of_employees > 5000);

2)SUBquery in select()-
select c.customer_id,c.first_name,c.last_name,(select count(*)from leads l 
where l.account_id = c.customer_id) as lead_count from customers c;

3)EXISTS()-
select o.organization_id,o.name,o.industry from organizations o where exists (select 1 from products p
where p.stock > 0);

4)ROLLUP()-
select source,deal_stage,count(*) as lead_count from leads group by rollup (source, deal_stage)
order by source, deal_stage;

5)GROUPING SETS()-
select category,brand,sum(price) as total_price from products group by grouping sets ((category, brand),
(category),(brand),())order by category, brand;

6)CTE()-
with avg_price as (select avg(price) as overall_avg from products) select p.name,p.brand,p.price
from products p, avg_price where p.price < avg_price.overall_avg;



8)WINDOW FUNCTIONS FOR EDA
1)OVER()-
select source,deal_stage,count(*) over (partition by source) as leads_per_source from leads;

2)PARTITION BY()-
select category,name,price,sum(price) over (partiton by category order by price) as running_total
from products;

3)RANK()-
select source,deal_stage,first_name,last_name,rank() over (partition by source order by deal_stage)
as stage_rank from leads;

4)DENSE_RANK()-
select organization_id,name,number_of_employees,dense_rank() over (order by number_of_employees desc)
as employee_dense_rank from organizations;

5)ROW_NUMBER()-
select source,deal_stage,first_name,last_name,row_number() over (partiton by source
order by deal_stage) as lead_num from leads;


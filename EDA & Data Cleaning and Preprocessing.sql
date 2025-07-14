-- Exploratory Data Analysis EDA
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

select * from categories --- ( category id PK , category name )
select * from cities --- ( city id PK , city name , zipcode , country id FK (the same country) )
select * from countries --- ( country id PK , country name ,country code )
select * from employees --- ( employee id PK , FN , MN , LS , Birth date , gender , city id FK , Hire date )
select * from customers --- ( customer id PK , FN , MN , LN , city id FK , address )
select * from products --- ( product id PK , product name , price , category id FK , class , modify date , resistant , is allergic , vitality days )
select * from sales --- ( sales person id FK emp , customer id FK , product id Fk , quantity , discount , total price , sales date , transaction number )
select Price from products --where Price >= 10.0

-----------------------------------------------------------------------------------------------------------------------------------------------------
--products table's columns are shifted to the right

select * from products where isDate( ModifyDate )=0 
select * from products

select * from products where isDate ( IsAllergic ) =1;

select ProductName , Price , CategoryID from products where isDate ( IsAllergic ) =1;
select ProductName from products

SELECT * FROM products WHERE ISNUMERIC ( Price )=0;

select * from products;
--------------------------------------------------------------------------------------
--EDA on products table
select column_name , data_type , is_nullable from information_schema.columns where table_name = 'products' ; --check datatypes and nullable 
select IsAllergic , count(*) from products group by IsAllergic ;
select Resistant , count(*) from products group by Resistant ;

select * from products where ProductName is null
-------------------------------------------------------------------------------------------------------------------------
--EDA on categories table
 select * from categories
 select column_name , data_type , is_nullable from information_schema.columns where table_name ='categories';  --check datatypes and nullable
 
 -----------------------------------------------------------------------------------------------------------------------------
 --EDA on cities table
 select * from cities
 select column_name , data_type , is_nullable from information_schema.columns where table_name = 'cities';  --check datatypes and nullable
 
 ------------------------------------------------------------------------------------------------------------------------------
 --EDA on countries table
 select * from countries

 select column_name, data_type , is_nullable from information_schema.columns where table_name ='countries' ;  --check datatypes and nullable
 ------------------------------------------------------------------------------------------------------------------------------
 --EDA on customers table
 select * from customers ;

 select column_name , data_type , is_nullable from information_schema.columns where table_name ='customers' ;  --check datatypes and nullable
 -------------------------------------------------------------------------------------------------------------------------------
 --EDA on employees table
 select * from employees ;
 select column_name , data_type , is_nullable from information_schema.columns where table_name ='employees' ;  --check datatypes and nullable

 select Gender , count(*) from employees group by Gender ;
 -------------------------------------------------------------------------------------------------------------------------------
 --EDA on sales table
 select * from sales;
 select column_name, data_type , is_nullable from information_schema.columns where table_name ='sales' ;  --check datatypes and nullable

 select TotalPrice , count (*) from sales group by TotalPrice ; --- all values are 0 then we will drop it and obtain price in power bi from measurable columns

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

 -- Data Cleaning and Preprocessing 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---products table issues (columns are shifted to the right )
alter table products 
add VitalityDaysL nvarchar(50) , VitalityDaysn nvarchar(50); -- adding to columns to handle shifhted values

update products 
set 
VitalityDaysl = left (VitalityDays , patindex ('%[0-9]%' , VitalityDays)-1 ),
VitalityDaysn = substring (VitalityDays , patindex ('%[0-9]%' , VitalityDays), len(VitalityDays))
where isDate( ModifyDate )=0;

update products set VitalityDays = null where isDate( ModifyDate )=0

update products set
VitalityDaysl = reverse (stuff (reverse( VitalityDaysl), charindex (',' , reverse (VitalityDaysl)),1,''))
where VitalityDaysl like '%,%' and isdate ( ModifyDate )=0;

select * from products where isDate( ModifyDate )=0 

update products set
Price = CategoryID , CategoryID = Class , Class =ModifyDate , 
ModifyDate = Resistant , Resistant =IsAllergic , 
IsAllergic = VitalityDaysl , VitalityDays = VitalityDaysn , 
VitalityDaysl = null , VitalityDaysn = null 
where isDate ( ModifyDate )=0 and isdate ( IsAllergic ) =0;

UPDATE products
SET VitalityDays = LEFT(VitalityDaysl, CHARINDEX(',', VitalityDaysl) - 1)
WHERE VitalityDaysl LIKE '%,%' and isDate ( IsAllergic ) =1;

select * from products where isDate ( IsAllergic ) =1;

update products set 
Price = Class , CategoryID = ModifyDate , Class = Resistant ,
ModifyDate = IsAllergic , Resistant = VitalityDays , VitalityDays = VitalityDaysn
WHERE ISNUMERIC ( Price )=0;

UPDATE products
SET IsAllergic = RIGHT(VitalityDaysl, LEN(VitalityDaysl) - CHARINDEX(',', VitalityDaysl))
WHERE VitalityDaysl LIKE '%,%' and isDate ( IsAllergic ) =1;


Alter table products drop column VitalityDaysl , VitalityDaysn;
SELECT * FROM products WHERE ISNUMERIC ( Price )=0;
----------------------------------------------------------------------------------------------------------------------------------------------
--data cleanning on products table
select * from products;

alter table products alter column ProductID int not null; -- handling data types
alter table products alter column Price float ;
alter table products alter column CategoryID int not null ;
alter table products alter column ModifyDate date ;
alter table products alter column VitalityDays int;

alter table products add constraint ProductID_PK primary key (ProductID); -- making primary and foreign key constraints 
alter table products add constraint CategoryID_FK foreign key (CategoryID) references categories (CategoryID); 
update products set ProductName =
upper(left(trim(ProductName),1)) + lower(substring(trim(ProductName),2,len(ProductName))); -- handling character's columns

update products set Class =
upper(left(trim(Class),1)) + lower(substring(trim(Class),2,len(Class)));

update products set Resistant =
upper(left(trim(Resistant),1)) + lower(substring(trim(Resistant),2,len(Resistant)));

update products set IsAllergic =
upper(left(trim(IsAllergic),1)) + lower(substring(trim(IsAllergic),2,len(IsAllergic)));


------------------------------------------------------------------------------------------------------------------------------------------------
--data cleaning on categories table
select * from Categories;

alter table categories alter column CategoryID int not null ; --handling data types
alter table categories add constraint CategoryID_PK primary key (CategoryID);

update categories set CategoryName =
 upper(left(trim(CategoryName),1)) + lower(substring(trim(CategoryName),2,len(CategoryName))) ; -- handling character's columns 
 ------------------------------------------------------------------------------------------------------------------------------------------------
 --data cleaning on cities table
 select * from cities
 alter table cities alter column CityID int not null; -- handling data types
 alter table cities alter column Zipcode int ;
 alter table cities alter column CountryID int not null;
 
 alter table cities add constraint CityID_PK primary key (CityID) ; -- making primary and foreign key constraints
 alter table cities add constraint CountryID_FK foreign key (CountryID) references countries (CountryID) ; 

 update cities set CityName =
 upper(left(trim(CityName),1)) + lower(substring(trim(CityName),2,len(CityName))) ; -- handling character's columns 

 -------------------------------------------------------------------------------------------------------------------------------------------------
 --data cleaning on countries table
 select * from countries;
 alter table countries alter column CountryID int not null ; -- handling data types
 alter table countries add constraint CountryID_PK primary key (CountryID) ;   -- making primary and foreign key constraints

 update countries set CountryName =
 upper(left(trim(CountryName),1)) + lower(substring(trim(CountryName),2,len(CountryName))) ;  -- handling character's columns

 update countries set CountryCode = upper(trim(CountryCode)) ;

 -------------------------------------------------------------------------------------------------------------------------------------------------
 --data cleaning on customers table
 
 select * from customers
 alter table customers alter column CustomerID int not null ; -- handling data types
 alter table Customers alter column CityID int not null ;
 alter table customers add constraint CustomerID_PK primary key (CustomerID);  -- making primary and foreign key constraints
 alter table customers add constraint CityId_FK foreign key (CityID) references cities(CityID);

 update customers set FirstName =
 upper(left(trim(FirstName),1)) + lower (substring(trim(FirstName),2,len(FirstName))) ; -- handling character's columns
 
 update customers set LastName =
 upper(left(trim(LastName),1)) + lower (substring(trim(LastName),2,len(LastName))) ;

 update customers set MiddleInitial = upper(trim(MiddleInitial));
 
 --------------------------------------------------------------------------------------------------------------------------------------------------
 --data cleaning on employees table
 
 select * from employees;

 alter table employees alter column EmployeeID int not null ; -- handling data types
 alter table employees alter column CityID int not null ;

 alter table employees alter column BirthDate datetime ;
 alter table employees alter column HireDate datetime ;
 alter table employees add constraint CheckDate check (BirthDate < HireDate ) ;

 alter table employees add constraint EmployeeID_PK primary key (EmployeeID);  -- making primary and foreign key constraints
 alter table employees add constraint City_ID_FK foreign key (CityID) references cities (CityID);

update employees set FirstName = 
upper(left(trim(FirstName),1)) + lower(substring(trim(FirstName),2,len(FirstName)));  -- handling character's columns

update employees set LastName = 
upper(left(trim(LastName),1)) + lower(substring(trim(LastName),2,len(LastName)));

update employees set MiddleInitial = upper(trim(MiddleInitial)) ;
update employees set Gender = upper(trim(Gender)) ;

---------------------------------------------------------------------------------------------------------------------------------------------------
--data cleaning on sales table

 alter table sales alter column SalesID int not null ; -- handling data types
 alter table sales alter column SalesPersonID int not null ;
 alter table sales alter column CustomerID int not null ;
 alter table sales alter column ProductID int not null ;
 alter table sales alter column Quantity int ;
 alter table sales alter column Discount float ;
 alter table sales alter column TotalPrice float ;
 alter table sales alter column SalesDate date ;

 alter table sales add constraint SalesID_PK primary key (SalesID) ;  -- making primary and foreign key constraints
 alter table sales add constraint SalesPersonID_FK foreign key (SalesPersonID) references employees (EmployeeID);
 alter table sales add constraint Customer_ID_FK foreign key (CustomerID) references customers (CustomerID) ;
 alter table sales add constraint Product_ID_FK foreign key (ProductID) references products (ProductID) ;

 alter table sales drop column TransactionNumber ; -- drop irrelevent columns
 select * from sales where SalesDate =' ' ;
 select * from sales where SalesDate is null; --check for null values
 
 select SalesDate , count(*) from sales group by SalesDate ; 

 update sales set SalesDate = dateadd ( day , abs ( checksum ( newid ( ))) % 365 , '2018-01-01' )  -- full missing values with dates
 where SalesDate = ' ';

 select TotalPrice , count (*) from sales group by TotalPrice ; --- all values are 0 then we will drop it and obtain price in power bi from measurable columns
 alter table sales drop column TotalPrice ;
 --------------------------------------------------------------------------------------------------------------------------------------------------------------

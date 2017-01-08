/********************************************************************/
/* Program Name: Import.sas 										*/
/* Author: Isaac Murray                                             */
/* Purpose: Imports csv files containing raw data and creates       */
/*          intermediate tables                                     */
/********************************************************************/

* Clean up tables from memory prior to recreating;
/*
%web_drop_table(CUSTS.CUSTOMERS);
%web_drop_table(CUSTS.ORDERS);
%web_drop_table(CUSTS.POSTCODES);
%web_drop_table(CUSTS.MERGED);
%web_drop_table(CUSTS.RAWCUSTOMERS);
*/
* Section below imports raw datafiles and generates tables for later analysis;
DATA _NULL_;
	FILENAME REFFILE "&path/CUSTOMERS.csv";
RUN;

PROC IMPORT DATAFILE=REFFILE DBMS=CSV OUT=CUSTS.RAWCUSTOMERS;
	GETNAMES=YES;
RUN;

DATA _NULL_;
	FILENAME REFFILE "&path/ORDERS.csv";
RUN;

PROC IMPORT DATAFILE=REFFILE DBMS=CSV OUT=CUSTS.RAWORDERS;
	GETNAMES=YES;
RUN;

DATA _NULL_;
	FILENAME REFFILE "&path/POSTCODES.csv";
RUN;

PROC IMPORT DATAFILE=REFFILE DBMS=CSV OUT=CUSTS.RAWPOSTCODES;
	GETNAMES=YES;
RUN;
/*
* Add columns to orders ;
PROC SQL;
	CREATE TABLE CUSTS.ORDERS AS 
	SELECT custno as Custno
	,actual_order as OrderAmount
	,Date as OrderDate
	,MONTH(Date) as OrderMonth
	,YEAR(Date) as OrderYear
	FROM CUSTS.RAWORDERS;
QUIT;

* Merge customer and location data, create age bins;
PROC SQL;
	CREATE TABLE CUSTS.CUSTOMERS AS 
	SELECT c.custno as Custno
	,CASE c.gender WHEN 1 THEN "Male" WHEN 2 THEN "Female" ELSE "Unknown" END as Gender
	,c.age as Age
	,CASE WHEN c.age BETWEEN 16 AND 20 THEN "16 - 20"
		  WHEN c.age BETWEEN 21 AND 25 THEN "21 - 25"
		  WHEN c.age BETWEEN 26 AND 30 THEN "26 - 30"
		  WHEN c.age BETWEEN 31 AND 35 THEN "31 - 35"
		  WHEN c.age BETWEEN 36 AND 40 THEN "36 - 40"
		  WHEN c.age BETWEEN 41 AND 45 THEN "41 - 45"
		  WHEN c.age BETWEEN 46 AND 50 THEN "46 - 50"
		  WHEN c.age BETWEEN 51 AND 55 THEN "51 - 55"
		  WHEN c.age BETWEEN 56 AND 60 THEN "56 - 60"
		  WHEN c.age BETWEEN 61 AND 65 THEN "61 - 65"
		  WHEN c.age BETWEEN 66 AND 70 THEN "66 - 70"
		  WHEN c.age BETWEEN 71 AND 75 THEN "71 - 75"
		  WHEN c.age BETWEEN 76 AND 80 THEN "76 - 80"
		  WHEN c.age > 80 THEN "Over 80"
		  END as AgeRange
	,c.postcode as Postcode
	,p.Region
	,CASE p.REGION WHEN "W" THEN "West" 
				   WHEN "N" THEN "North" 
				   WHEN "E" THEN "East" 
				   WHEN "S" THEN "South" 
				   ELSE "Unknown" 
				   END as RegionLong
	FROM CUSTS.RAWCUSTOMERS c
	INNER JOIN CUSTS.POSTCODES p
	ON p.POSTCODE = c.POSTCODE;
QUIT;

* Merge customer and order data;
PROC SQL ;
	CREATE TABLE CUSTS.MERGED AS 
	SELECT c.Custno
	,c.Gender
	,c.Age
	,c.AgeRange 
	,c.Postcode
	,o.OrderDate 
	,o.OrderMonth
	,o.OrderYear
	,o.OrderAmount
	,c.Region
	,c.RegionLong 
	FROM CUSTS.CUSTOMERS c
	INNER JOIN CUSTS.ORDERS o
	ON o.custno = c.custno;
QUIT;

proc summary data = CUSTS.MERGED;
class Custno;
var OrderAmount;
output out=CUSTS.OrderAmountByCustno sum=OrderTotal mean=OrderMean;
run;

proc summary data = CUSTS.MERGED;
class Custno OrderYear OrderMonth;
var OrderAmount;
output out=CUSTS.OrderAmountByCustnoYearMonth sum=OrderTotal mean=OrderMean;
run;
*/

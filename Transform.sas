/********************************************************************/
/* Program Name: Transform.sas 										*/
/* Author: Isaac Murray                                             */
/* Purpose: Transforms and merges raw data for later analyses       */
/********************************************************************/

* Formats used in transformations;
proc format;
value fmtgender 
   	1 = "Male"
	2 = "Female"
	;
value $fmtregion
	"W" = "West" 
	"N" = "North" 
	"E" = "East" 
	"S" = "South" 
	;
run;



* Add columns to orders ;
/*
PROC SQL;
	CREATE TABLE CUSTS.ORDERS AS 
	SELECT custno as Custno
	,actual_order as OrderAmount
	,Date as OrderDate
	,MONTH(Date) as OrderMonth
	,YEAR(Date) as OrderYear
	FROM CUSTS.RAWORDERS;
QUIT;
*/

DATA CUSTS.ORDERS;
	set CUSTS.RAWORDERS;
	format OrderDate ddmmyy10.;
	CustNo=custno;
	OrderAmount=actual_order;
	OrderDate=date;
	OrderMonth=MONTH(Date);
	OrderYear=YEAR(Date);
	drop actual_order Date;
RUN;

DATA CUSTS.TMPCUSTOMERS;
	set CUSTS.RAWCUSTOMERS;
	
	format gender fmtgender.;
	
	* Create age bins;
	if age >= 16 AND age <= 20 then AgeRange = "16 - 20";
	if age >= 21 AND age <= 25 then AgeRange = "21 - 25";
	if age >= 26 AND age <= 30 then AgeRange = "26 - 30";
	if age >= 31 AND age <= 35 then AgeRange = "31 - 35";
	if age >= 36 AND age <= 40 then AgeRange = "36 - 40";
	if age >= 41 AND age <= 45 then AgeRange = "41 - 45";
	if age >= 46 AND age <= 50 then AgeRange = "46 - 50";
	if age >= 51 AND age <= 55 then AgeRange = "51 - 55";
	if age >= 56 AND age <= 60 then AgeRange = "56 - 60";
	if age >= 61 AND age <= 65 then AgeRange = "61 - 65";
	if age >= 66 AND age <= 70 then AgeRange = "66 - 70";
	if age >= 71 AND age <= 75 then AgeRange = "71 - 75";
	if age >= 76 AND age <= 80 then AgeRange = "76 - 80";
	if age > 80 then AgeRange = "Over 80";
	
RUN;

PROC SORT DATA=CUSTS.TMPCUSTOMERS;
	by postcode;
RUN;

PROC SORT DATA=CUSTS.RAWPOSTCODES;
	by postcode;
RUN;

DATA CUSTS.CUSTOMERS;
	merge CUSTS.TMPCUSTOMERS (in=cno) CUSTS.RAWPOSTCODES;
	by postcode;
	if cno=1;
	format Region $fmtregion.;
RUN;

/*
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
	INNER JOIN CUSTS.RAWPOSTCODES p
	ON p.POSTCODE = c.POSTCODE;
QUIT;
*/

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
/********************************************************************/
/* Program Name: Transform.sas 										*/
/* Author: Isaac Murray                                             */
/* Purpose: Transforms and merges raw data for later analyses       */
/********************************************************************/

* Suppress printing output in this module;
ods exclude all;

* Formats used in transformations;
PROC FORMAT;
	value fmtgender 0="All" 1="Male" 2="Female";
	value $fmtregion "W"="West" "N"="North" "E"="East" "S"="South";
	value fmtmonth 1="Jan" 2="Feb" 3="Mar" 4="Apr" 5="May" 6="Jun" 
				   7="Jul" 8="Aug" 9="Sep" 10="Oct" 11="Nov" 12="Dec";
RUN;

* Format RAWORDERS dataset;
DATA CUSTS.ORDERS;
	set CUSTS.RAWORDERS;
	format OrderDate ddmmyy10.;
	format OrderMonth fmtmonth.;
	format OrderYearMonth YYMON.;
	format OrderAmount NLMNLGBP.;
	OrderAmount=actual_order;
	OrderDate=date;
	OrderMonth=MONTH(Date);
	OrderYear=YEAR(Date);
	OrderYearMonth=date;
	OrderDay=DAY(date);
	drop actual_order Date;
RUN;

* Format RAWCUSTOMERS dataset;
DATA CUSTS.CUSTOMERS;
	set CUSTS.RAWCUSTOMERS;
	format gender fmtgender.;
	* Create age bins;
	if age >=16 AND age <=20 then
		AgeRange="16 - 20";

	if age >=21 AND age <=25 then
		AgeRange="21 - 25";

	if age >=26 AND age <=30 then
		AgeRange="26 - 30";

	if age >=31 AND age <=35 then
		AgeRange="31 - 35";

	if age >=36 AND age <=40 then
		AgeRange="36 - 40";

	if age >=41 AND age <=45 then
		AgeRange="41 - 45";

	if age >=46 AND age <=50 then
		AgeRange="46 - 50";

	if age >=51 AND age <=55 then
		AgeRange="51 - 55";

	if age >=56 AND age <=60 then
		AgeRange="56 - 60";

	if age >=61 AND age <=65 then
		AgeRange="61 - 65";

	if age >=66 AND age <=70 then
		AgeRange="66 - 70";

	if age >=71 AND age <=75 then
		AgeRange="71 - 75";

	if age >=76 AND age <=80 then
		AgeRange="76 - 80";

	if age > 80 then
		AgeRange="Over 80";
RUN;

* Merge CUSTOMERS and RAWPOSTCODES datasets;
PROC SORT DATA=CUSTS.CUSTOMERS;
	by postcode;
RUN;

PROC SORT DATA=CUSTS.RAWPOSTCODES;
	by postcode;
RUN;

DATA CUSTS.CUSTOMERS;
	merge CUSTS.CUSTOMERS(in=cno) CUSTS.RAWPOSTCODES;
	by postcode;

	if cno=1;
	format Region $fmtregion.;
RUN;

* Merge CUSTOMERS and ORDERS datasets;
PROC SORT DATA=CUSTS.CUSTOMERS;
	by custno;
RUN;

PROC SORT DATA=CUSTS.ORDERS;
	by custno;
RUN;

DATA CUSTS.MERGED;
	merge CUSTS.ORDERS (in=cno) CUSTS.CUSTOMERS;
	by custno;

	if cno=1;
RUN;

* Create summary table for customer age by gender;
PROC SORT DATA=CUSTS.CUSTOMERS;
	by gender;
RUN;

PROC MEANS DATA=CUSTS.CUSTOMERS
	N mean median min max q1 q3;
	var age;
	by gender;
	output out=CUSTS.tmpCUSTS1 N=N mean=Mean median=Median min=Min max=Max q1=Q1 q3=Q3;
RUN;

PROC MEANS DATA=CUSTS.CUSTOMERS
	N mean median min max q1 q3;
	var age;
	output out=CUSTS.tmpCUSTS2 N=N mean=Mean median=Median min=Min max=Max q1=Q1 q3=Q3;
RUN;
 
DATA CUSTS.GENSTATS;
set CUSTS.tmpCUSTS1 CUSTS.tmpCUSTS2 ;
if gender = . then gender = 0;
format gender fmtgender.;
drop _TYPE_ _FREQ_;
RUN;

* Create summary table for customer age by region;
PROC SORT DATA=CUSTS.CUSTOMERS;
	by region;
RUN;

PROC MEANS DATA=CUSTS.CUSTOMERS
	N mean median min max q1 q3;
	var age;
	by region;
	output out=CUSTS.REGSTATS N=N mean=Mean median=Median min=Min max=Max q1=Q1 q3=Q3;
RUN;

DATA CUSTS.REGSTATS;
	set CUSTS.REGSTATS;
	drop _TYPE_ _FREQ_;
RUN;

* Create summary table of sales by gender;
PROC SORT DATA=CUSTS.MERGED;
	by gender;
RUN;

PROC MEANS DATA=CUSTS.MERGED
	N mean median min max q1 q3;
	var OrderAmount;
	by gender;
	output out=CUSTS.tmpCUSTS3 N=N mean=Mean median=Median min=Min max=Max q1=Q1 q3=Q3 sum=Sum;
RUN;

PROC MEANS DATA=CUSTS.MERGED
	N mean median min max q1 q3;
	var OrderAmount;
	output out=CUSTS.tmpCUSTS4 N=N mean=Mean median=Median min=Min max=Max q1=Q1 q3=Q3 sum=Sum;
RUN;
 
DATA CUSTS.GENSALESTATS;
set CUSTS.tmpCUSTS3 CUSTS.tmpCUSTS4 ;
if gender = . then gender = 0;
format gender fmtgender.;
drop _TYPE_ _FREQ_;
RUN;

* Create summary table of sales by region;
PROC SORT DATA=CUSTS.MERGED;
	by region;
RUN;

PROC MEANS DATA=CUSTS.MERGED
	N mean median min max q1 q3;
	var OrderAmount;
	by region;
	output out=CUSTS.REGSALESTATS N=N mean=Mean median=Median min=Min max=Max q1=Q1 q3=Q3 sum=Sum;
RUN;
 
DATA CUSTS.REGSALESTATS;
	set CUSTS.REGSALESTATS;
	drop _TYPE_ _FREQ_;
RUN;


* Re-enable printing of output;
ods exclude none;
run;

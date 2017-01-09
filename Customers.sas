/********************************************************************/
/* Program Name: Customers.sas 										*/
/* Author: Isaac Murray                                             */
/* Purpose: Generates stats and graphs for customer data            */
/********************************************************************/

* Sort to enable grouping by gender;
proc sort data=custs.customers;
	by gender;
run;

* Table of customer age by gender;
title 'Customers by age and gender';
proc means data=custs.customers maxdec=2
		   N mean median min max q1 q3;
	var age;
	by Gender;
run;
* Box plot of customer age by gender;
proc boxplot data=custs.customers;
	plot age*gender;
	insetgroup N;
run;

* Clustered bar chart of customers per age range by gender;
proc sgplot data=custs.customers;
	vbar AgeRange/ stat=freq group=gender nostatlabel groupdisplay=cluster;
	xaxis display=(nolabel);
	yaxis grid;
run;

* Sort to enable grouping by region;
proc sort data=custs.customers;
	by region;
run;

* Table of customer age by region;
title 'Customers by age and region';
proc means data=custs.customers maxdec=2
		   N mean median min max q1 q3;
	var age;
	by RegionLong ;
run;

* Box plot of customer age by region;
proc boxplot data=custs.customers;
	plot age*RegionLong;
	insetgroup N;
run;

* Stacked bar chart of customers per region by gender;
title 'Customers by gender and region';
proc sgplot data=custs.customers;
	vbar RegionLong / stat=freq group=gender nostatlabel groupdisplay=stack;
	xaxis display=(nolabel);
	yaxis grid;
run;


proc corr data=custs.customers;
*proc reg data=custs.customers;

  
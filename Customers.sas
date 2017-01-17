/********************************************************************/
/* Program Name: Customers.sas 										*/
/* Author: Isaac Murray                                             */
/* Purpose: Generates stats and graphs for customer data            */
/********************************************************************/

* Summary statistics of customer age;
proc sort data=custs.genstats;
by gender;
run;
title 'Age statistics of customer base by gender';
proc print data=custs.genstats noobs;
	format mean 10.1;
run;

* Box plot of customer age by gender;
proc sort data=custs.customers;
by gender;
run;

proc boxplot data=custs.customers;
	plot age*gender;
	insetgroup N;
run;

* Clustered bar chart of customers per age range by gender;
title 'Age range by gender';
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
title 'Age statistics of customer base by region';
proc print data=custs.regstats noobs;
	format mean 10.1;
run;

* Box plot of customer age by region;
proc boxplot data=custs.customers;
	plot age*region;
	insetgroup N;
run;

* Stacked bar chart of customers per region by gender;
title 'Customers by gender and region';
proc sgplot data=custs.customers;
	vbar region / stat=freq group=gender nostatlabel groupdisplay=stack;
	xaxis display=(nolabel);
	yaxis grid;
run;



  
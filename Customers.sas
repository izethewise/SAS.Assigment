* Sort to enable grouping by gender;
proc sort data=custs.customers;
	by gender;
run;

proc means data=custs.customers maxdec=2;
	var age;
	by Gender;
run;
* Box plot of customer age by gender;
proc boxplot data=custs.customers;
	plot age*gender;
	insetgroup N;
run;

* Stacked bar chart of customers per region by gender;
title 'Customers by gender and region';
proc sgplot data=custs.customers;
	vbar RegionLong / stat=freq group=gender nostatlabel groupdisplay=stack;
	xaxis display=(nolabel);
	yaxis grid;
run;

* Clustered bar chart of customers per age range by gender;
proc sgplot data=custs.customers;
	vbar AgeRange/ stat=freq group=gender nostatlabel groupdisplay=cluster;
	xaxis display=(nolabel);
	yaxis grid;
run;


  
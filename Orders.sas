/********************************************************************/
/* Program Name: Orders.sas 										*/
/* Author: Isaac Murray                                             */
/* Purpose: Generates stats and graphs for order data               */
/********************************************************************/

* Summary statistics of sales by gender;
proc sort data=CUSTS.GENSALESTATS;
by gender;
run;
title 'Order statistics of customer base by gender';
proc print data=CUSTS.GENSALESTATS noobs;
	format mean 10.1;
run;

* Box plot of orders by gender;
proc sort data=CUSTS.MERGED;
	by gender;
run;
proc boxplot data=CUSTS.MERGED;
	plot OrderAmount*gender;
	insetgroup N;
run;

* Bar chart of sales totals by gender;
title 'Order totals by gender';
proc sgplot data=CUSTS.MERGED;
	vbar Gender/ stat=sum response=OrderAmount;
	xaxis display=(nolabel);
	yaxis grid;
run;

title 'Order statistics of customer base by region';
proc print data=CUSTS.REGSALESTATS noobs;
	format mean 10.1;
run;
* Box plot of orders by region;
proc sort data=CUSTS.MERGED;
	by Region;
run;
proc boxplot data=CUSTS.MERGED;
	plot OrderAmount*Region;
	insetgroup N;
run;

* Bar chart of sales totals by gender;
title 'Order totals by region and gender';
proc sgplot data=CUSTS.MERGED;
	vbar Region/ stat=sum response=OrderAmount group=gender;
	xaxis display=(nolabel);
	yaxis grid;
run;

title 'Order totals by month and gender';
proc sgplot data=CUSTS.MERGED;
	vbar OrderYearMonth/ stat=sum response=OrderAmount group=gender ;
	xaxis display=(nolabel);
	yaxis grid;
run;

title 'Order totals by month and region';
proc sgplot data=CUSTS.MERGED;
	vbar OrderYearMonth/ stat=sum response=OrderAmount group=region groupdisplay=cluster;
	xaxis display=(nolabel);
	yaxis grid;
run;




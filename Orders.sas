/********************************************************************/
/* Program Name: Orders.sas 										*/
/* Author: Isaac Murray                                             */
/* Purpose: Generates stats and graphs for order data               */
/********************************************************************/

* Box plot of orders by gender;
proc sort data=CUSTS.MERGED;
	by gender;
run;
proc boxplot data=CUSTS.MERGED;
	plot OrderAmount*gender;
	insetgroup N;
run;

* Box plot of orders by region;
proc sort data=CUSTS.MERGED;
	by Region;
run;
proc boxplot data=CUSTS.MERGED;
	plot OrderAmount*Region;
	insetgroup N;
run;

* Box plot of orders by order month;
proc sort data=CUSTS.MERGED;
	by OrderMonth;
run;
proc boxplot data=CUSTS.MERGED;
	plot OrderAmount*OrderMonth;
	insetgroup N;
run;

* Box plot of orders by order month;
proc sort data=CUSTS.MERGED;
	by OrderYear;
run;
proc boxplot data=CUSTS.MERGED;
	plot OrderAmount*OrderYear;
	insetgroup N;
run;

* Box plot of orders by custno;
proc sort data=CUSTS.ORDERS;
	by custno;
run;

proc boxplot data=CUSTS.ORDERS ;
	plot OrderAmount*custno;
	insetgroup N;
run;

*t-test to compare order amount between gender2;
proc ttest data=custs.merged;
 	class Gender;
	var OrderAmount;
run;

*One-way anova with order amount as dependent and region independent;
proc anova data = custs.merged;
	class Region;
	model OrderAmount= Region;
run;

proc anova data=custs.merged;
  class Gender Region;
  model OrderAmount = Gender Region Gender*Region;
run;

proc glm data=custs.merged;
   class Gender Region;
   model OrderAmount = Gender Region Gender*Region;
run;

/*
proc sort data=CUSTS.ORDERS;
	by OrderMonth;
run;

proc tabulate data=CUSTS.MERGED out=CUSTS.ORDERSBYREGION;
  	class Region;
  	var OrderAmount;
  	tables Region, OrderAmount*(N sum mean max);
run;

proc sgplot data=CUSTS.MERGED;
	vbar OrderAmount / stat=mean group=custno nostatlabel;
	xaxis display=(nolabel);
	yaxis grid;
run;


proc sgpanel data=CUSTS.ORDERS;
	panelby OrderMonth/ layout=columnlattice onepanel colheaderpos=bottom rows=1 
		novarname noborder;
	vbar regionlong/ group=regionlong stat=mean group=regionlong nostatlabel;
	colaxis display=none;
	rowaxis grid;
run;
*/

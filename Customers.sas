*title 'Age and Gender distribution of customers';

/*
proc sgplot data=custs.customers;
vbar custno/  stat=freq group=gender nostatlabel;
xaxis display=(nolabel);
yaxis grid;
run;

proc univariate data=custs.customers;

run;

proc univariate data=custs.customers;
histogram;
run;

proc sgpanel data=custs.customers;
panelby gender / layout=columnlattice onepanel
colheaderpos=bottom rows=1 novarname noborder;
vbar custno/ group=gender ;
colaxis display=none;
rowaxis grid;
run;

proc sgplot data=custs.customers;
var age;
run;

*/
PROC SGPLOT DATA=custs.customers;
	VBAR age GROUP=gender midpoints=15 to 65 by 5;
RUN;

proc univariate data=custs.customers;
	histogram age / midpoints=15 to 65 by 5;
run;

proc boxplot data=custs.customers;
	plot age*gender;
run;


proc means data=custs.orders
	mean median min max sum
	 maxdec=2;
	var OrderAmount;
	by custno;
run;

proc sort data=custs.orders;
	by custno;
run;

proc boxplot data=custs.orders ;
	plot OrderAmount*custno;
	insetgroup N;
run;

proc sort data=custs.orders;
	by OrderMonth;
run;

/*
proc sgpanel data=custs.orders;
	panelby OrderMonth/ layout=columnlattice onepanel colheaderpos=bottom rows=1 
		novarname noborder;
	vbar regionlong/ group=regionlong stat=mean group=regionlong nostatlabel;
	colaxis display=none;
	rowaxis grid;
run;
*/

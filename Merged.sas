proc sort data=custs.merged;
	by Gender;
run;
proc means data=custs.merged maxdec=2;
	var OrderAmount;
	by Gender;
run; 
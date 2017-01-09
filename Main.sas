/********************************************************************/
/* Program Name: Main.sas 										    */
/* Author: Isaac Murray                                             */
/* Purpose: Sets environment info and executes sub-programs         */
/********************************************************************/

* path variable should be changed to the SAS path of deployment;
%let path = /folders/myshortcuts/Coursework/ProgAssessment;

* Clear log and set log path;
ods html close;
ods html path="&path";
run;


* Create library for referenced tables;
DATA _NULL_;
	LIBNAME CUSTS "&path";
RUN;

* Section below runs sub-programs for marketing analysis suite;
*ods text="Start Import.sas";
%include "&path/Import.sas";
*ods text="Finish Import.sas";
RUN;

*ods text="Start Transform.sas";
%include "&path/Transform.sas";
*ods text="Finish Transform.sas";
RUN;

ods text="Start Customers.sas";
%include "&path/Customers.sas";
ods text="Finish Customers.sas";
RUN;

ods text="Start Orders.sas";
%include "&path/Orders.sas";
ods text="Finish Orders.sas";
RUN;
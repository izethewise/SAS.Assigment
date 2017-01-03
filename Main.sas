/********************************************************************/
/* Program Name: Main.sas 										    */
/* Author: Isaac Murray                                             */
/* Purpose: Sets environment info and executes sub-programs         */
/********************************************************************/

* path variable should be changed to the SAS path of deployment;
%let path = /folders/myshortcuts/Coursework/ProgAssessment;

* Create library for referenced tables;
DATA _NULL_;
	LIBNAME CUSTS "&path";
RUN;

* Section below runs sub-programs for marketing analysis suite;
%include "&path/Import.sas";
RUN;
%include "&path/Customers.sas";
RUN;
%include "&path/Orders.sas";
RUN;
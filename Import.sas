/********************************************************************/
/* Program Name: Import.sas 										*/
/* Author: Isaac Murray                                             */
/* Purpose: Imports csv files containing raw data and creates       */
/*          intermediate tables                                     */
/********************************************************************/

* Clean up tables from memory prior to recreating;
/*
%web_drop_table(CUSTS.CUSTOMERS);
%web_drop_table(CUSTS.ORDERS);
%web_drop_table(CUSTS.POSTCODES);
%web_drop_table(CUSTS.MERGED);
%web_drop_table(CUSTS.RAWCUSTOMERS);
*/
* Section below imports raw datafiles and generates tables for later analysis;
DATA _NULL_;
	FILENAME REFFILE "&path/CUSTOMERS.csv";
RUN;

PROC IMPORT DATAFILE=REFFILE DBMS=CSV OUT=CUSTS.RAWCUSTOMERS;
	GETNAMES=YES;
RUN;

DATA _NULL_;
	FILENAME REFFILE "&path/ORDERS.csv";
RUN;

PROC IMPORT DATAFILE=REFFILE DBMS=CSV OUT=CUSTS.RAWORDERS;
	GETNAMES=YES;
RUN;

DATA _NULL_;
	FILENAME REFFILE "&path/POSTCODES.csv";
RUN;

PROC IMPORT DATAFILE=REFFILE DBMS=CSV OUT=CUSTS.RAWPOSTCODES;
	GETNAMES=YES;
RUN;


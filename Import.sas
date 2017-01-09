/********************************************************************/
/* Program Name: Import.sas 										*/
/* Author: Isaac Murray                                             */
/* Purpose: Imports csv files containing raw data and creates       */
/*          intermediate tables                                     */
/********************************************************************/


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


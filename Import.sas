/********************************************************************/
/* Program Name: Import.sas 										*/
/* Author: Isaac Murray                                             */
/* Purpose: Imports csv files containing raw data and creates       */
/*          intermediate tables                                     */
/********************************************************************/

* Clean up tables from memory prior to recreating;
%web_drop_table(CUSTS.CUSTOMERS);
%web_drop_table(CUSTS.ORDERS);
%web_drop_table(CUSTS.POSTCODES);
%web_drop_table(CUSTS.MERGED);
%web_drop_table(CUSTS.TMPCUSTOMERS);

* Section below imports raw datafiles and generates tables for later analysis;
DATA _NULL_;
	FILENAME REFFILE "&path/CUSTOMERS.csv";
RUN;

PROC IMPORT DATAFILE=REFFILE DBMS=CSV OUT=CUSTS.TMPCUSTOMERS;
	GETNAMES=YES;
RUN;

DATA _NULL_;
	FILENAME REFFILE "&path/ORDERS.csv";
RUN;

PROC IMPORT DATAFILE=REFFILE DBMS=CSV OUT=CUSTS.ORDERS;
	GETNAMES=YES;
RUN;

DATA _NULL_;
	FILENAME REFFILE "&path/POSTCODES.csv";
RUN;

PROC IMPORT DATAFILE=REFFILE DBMS=CSV OUT=CUSTS.POSTCODES;
	GETNAMES=YES;
RUN;

* PROC SQL used to transform gender column;
PROC SQL;
	CREATE TABLE CUSTS.CUSTOMERS AS 
	SELECT custno as Custno
	,CASE gender WHEN 1 THEN "Male" WHEN 2 THEN "Female" END as Gender
	,age as Age
	,postcode as Postcode
	FROM CUSTS.TMPCUSTOMERS;
RUN;

* PROC SQL used to create denomalised MERGED table for later analysis;
PROC SQL ;
	CREATE TABLE CUSTS.MERGED AS 
	SELECT c.Custno
	,c.Gender
	,c.Age 
	,c.Postcode
	,o.Date 
	,o.actual_order as ActualOrder
	,p.Region 
	FROM CUSTS.CUSTOMERS c
	INNER JOIN CUSTS.ORDERS o
	ON o.custno = c.custno
	INNER JOIN CUSTS.POSTCODES p
	ON p.Postcode = c.postcode;
QUIT;
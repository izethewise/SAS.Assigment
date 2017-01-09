/********************************************************************/
/* Program Name: Cleanup.sas 										*/
/* Author: Isaac Murray                                             */
/* Purpose: Cleans up tables and library created during processing  */
/********************************************************************/


* Clean up tables and library ;
%web_drop_table(CUSTS.MERGED);
%web_drop_table(CUSTS.CUSTOMERS);
%web_drop_table(CUSTS.ORDERS);
%web_drop_table(CUSTS.RAWORDERS);
%web_drop_table(CUSTS.RAWPOSTCODES);
%web_drop_table(CUSTS.RAWCUSTOMERS);
libname CUSTS clear;
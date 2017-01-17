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
%web_drop_table(CUSTS.REGSTATS);
%web_drop_table(CUSTS.GENSTATS);
%web_drop_table(CUSTS.tmpCUSTS1);
%web_drop_table(CUSTS.tmpCUSTS2);
%web_drop_table(CUSTS.tmpCUSTS3);
%web_drop_table(CUSTS.tmpCUSTS4);
%web_drop_table(CUSTS.gensalestats);
%web_drop_table(CUSTS.regsalestats);
libname CUSTS clear;
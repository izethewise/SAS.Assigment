%let path = /folders/myshortcuts/Coursework/ProgAssessment;

DATA _NULL_;
LIBNAME CUSTS "&path";
RUN;

%include "&path/Import.sas";
RUN;

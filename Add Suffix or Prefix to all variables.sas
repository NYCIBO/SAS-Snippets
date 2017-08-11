/**************************************************************************************
/* Created by Arash Farahani
/* Date: 7/25/2017
/* Usage: Add prefix or suffix to all variables in a dataset.
/* 
/***************************************************************************************/



%macro add_pre_suf(library=,dataset=,prefix=,suffix=);
/* Source:https://stackoverflow.com/questions/41083555/sas-create-a-macro-that-add-suffix-to-variables-in-a-dataset
	It should be modified to take in variable list -AF.
*/

* potentially use the next statement to create a new file (instead of replacing it).;
%let new_dataset=sysfunc(cats("&prefix","&dataset","&suffix"));

%local rename_list;
proc sql noprint;
  select catx('=',name,cats("&prefix",name,"&suffix"))
    into :rename_list separated by ' ' 
  from dictionary.columns
  where libname = %upcase("&library")
    and memname = %upcase("&dataset")
  ;
quit;

%if (&sqlobs) %then %do;
proc datasets library=&library nolist nodetails;
  modify &dataset;
    rename &rename_list;
  run;
quit;
%end;
%else %put WARNING: Did not find any variables for &library..&dataset..;
%mend add_pre_suf;

/* Example:
%add_pre_suf(library=WORK,dataset=RPAD01_OLD,suffix=_o);

*/

%macro remove_pre_suf(library=,dataset=,prefix=,suffix=);
/* Source:https://stackoverflow.com/questions/41083555/sas-create-a-macro-that-add-suffix-to-variables-in-a-dataset
	It should be modified to take in variable list -AF.
*/

* potentially use the next statement to create a new file (instead of replacing it).;
%let new_dataset=sysfunc(cats("no&prefix.","&dataset","no&suffix."));

%local rename_list;
proc sql noprint;
  select catx('=',tranwrd(tranwrd(name, "&suffix",""), "&prefix",""),name)
    into :rename_list separated by ' ' 
  from dictionary.columns
  where libname = %upcase("&library")
    and memname = %upcase("&dataset")
  ;
quit;

%if (&sqlobs) %then %do;
proc datasets library=&library nolist nodetails;
  modify &dataset;
    rename &rename_list;
  run;
quit;
%end;
%else %put WARNING: Did not find any variables for &library..&dataset..;
%mend remove_pre_suf;

/* Example:
%remove_pre_suf(library=WORK,dataset=RPAD01_OLD,suffix=BC);

*/
%macro drop_all_miss_vars(lib=work,data=class, outlib=work);
	%put =&data;
	* create a data set with variable names and number of non-null obs;
	proc sql  ;
		 select cat('n(',strip(name),') as ',name)     into : list separated by ','
		  from dictionary.columns
		      where libname = %upcase("&lib")
			    and memname = %upcase("&data");

		create table temp as 
		 select &list from &lib..&data;
	quit;
	
	* if number of non-null=0 add to drop list;
	data _null_;
	 set temp;
	 length drop $ 4000; 
	 array x{*} _numeric_;
	 do i=1 to dim(x);
	  if x{i}=0 then drop=catx(' ',drop,vname(x{i}));
	 end;
	 call symputx('drop',drop);
	run;
	
	*drop the null variables;
	data &outlib..&data;
	 set &lib..&data(drop= &drop );
	run;
%mend;

* Example;
/*data class;*/
/*set sashelp.class;*/
/*call missing(age,name);*/
/*run;*/
/**/
/*%drop_all_miss_vars(lib=work,data=class, outlib=work)*/
%macro BBL6(datalist=, in=M:\Large Agency Data\Property Tax\RPAD\,out= M:\Large Agency Data\Property Tax\RPAD\);
 libname inlib "&in";
 libname outlib "&out";
  %local i data;
  %let i=1;
  %let data=%scan(&datalist,&i,%str( ));
  %do %while(%superq(data) ne %str());
		DATA outlib.&data;
		set inlib.&data;
		length boro 6. block 6. lot 6.;
		RUN;

	 %let i=%eval(&i+1);
	 %let data=%scan(&datalist,&i,%str( ));
 %end;
%mend;

%macro ContentsAll(datalist=, in=M:\Large Agency Data\Property Tax\RPAD\,keepvars=);
	libname inlib "&in";
	libname outlib "&out";
  %local i data;
  %let i=1;
  %let data=%scan(&datalist,&i,%str( ));
  %do %while(%superq(data) ne %str());
    /* This option just gives warning on the missing vars in KEEP. It's reset after this step*/
	options dkricond=nowarn;
	ods select Variables;	/*only show variables*/
	footnote 'The file is: ' &data;
	proc contents data=inlib.&data(keep=&keepvars);
    run;
	ods select Default;
	options dkricond=error;
    %let i=%eval(&i+1);
    %let data=%scan(&datalist,&i,%str( ));
  %end;
%mend;


/* Example useage
%ContentsAll(datalist=RPADF17x RPADF16x, keepvars=CORNER);
*/

/*proc Qcew_geo.contents
     data = Qcew_geo.Qcew00mn
	 ;
run;

proc means 
	data=Rpad.rpadf17x;
	var PROPTYPE1;

run;

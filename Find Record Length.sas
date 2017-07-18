/***********************************************************************************************************************************************
Author: Arash Farahani
Date: 07-18-2017
Usage: The testlength macro loops over a base record length (baselrecl) +range for the correct record length.
		To find the correct file, it relies on BORO variable being a number for more than 6 out of 10 read observations.
		It will take some time to run, so I suggest running it over night.
		The final record length is printed via proc means in the results window and in the log file (search "Here is a possible record lenght:").
************************************************************************************************************************************************/

* Given that the loop is too long, normal log will fill up and you'll keep getting errors if the below is not in effect.;
proc printto log="Y:\CRT CEP Evaluation\Programs\findRL.log";
run;
proc printto;
run;
options nonotes nosource nosource2;
options notes source source2 errors=20;
%LET CUR=2001;
 /* NO NEED TO CHANGE THESE */
 %LET PRI=%EVAL(&CUR-1);
 %LET CYR = %SUBSTR(&CUR,3,2);
 %LET PYR = %SUBSTR(&PRI,3,2);
 %LET HISEND = %EVAL(&CUR-5);
 %LET SUMST = %EVAL(&CUR-4);

 /* THIS IDENTIFIES THE ROLL AS TENTATIVE OR FINAL. 301 FILES ARE FINAL. 101 ARE TENTATIVE */
 %LET TYPE = F;  

TITLE1 "NEW YORK CITY INDEPENDENT BUDGET OFFICE";
TITLE2 "READ FULL RPAD FILE FISCAL YEAR &PRI./&CUR ";
OPTIONS ERRORS=1 PS=100;
filename rpadfull "M:\Large Agency Data\Property Tax\Original DOF Files\Raw Files\RPAD\AVXPRODN.BKUP.AVX69301.S010102.D0102" lrecl=11560 recfm=F;
libname ebcdic "M:\Large Agency Data\Property Tax\Original DOF Files\Raw Files\RPAD";

%macro testlength(rpadfull="M:\Large Agency Data\Property Tax\Original DOF Files\Raw Files\RPAD\AVXPRODN.BKUP.AVX69301.S010102.D0102"
		,baselrecl=11500, range=2000, recfm=F);
	%DO i=1 %TO &range;
		%local l cou;
		%let l=%eval(&baselrecl+&i);
		DATA EBCDIC.RDRPAD&CYR.&TYPE._test;
		   LENGTH STCODE 6 DEFAULT = 5;

		   INFILE &rpadfull lrecl=&l recfm=&recfm obs=10;
		   INPUT 
			 @1    BORO        s370ff1.
	         @2    BLOCK       S370FPDU3.
	         @5    LOT         S370FPDU3.
	         @8    EASEMENT    $ebcdic1.
	         @10   SECVOL      S370FPDU3.;
			id=_N_;
			length=&l;
			if BORO ne . then output;
		run;
		
		proc sql noprint;
 			select  count(id) FORMAT 9. into:cou from EBCDIC.RDRPAD&CYR.&TYPE._test;
		quit;

		%if &cou ge 6 %then %do;
			proc means data=EBCDIC.RDRPAD&CYR.&TYPE._test;
		 		var BORO length;
			run;
			%put Here is a possible record lenght:;
			%put &=l;
		%end;
	%END;

	proc datasets lib=ebcdic nolist;
		delete RDRPAD&CYR.&TYPE._test;
		quit;
	run;
%mend;

%testlength(rpadfull="M:\Large Agency Data\Property Tax\Original DOF Files\Raw Files\RPAD\AVXPRODN.BKUP.AVX69301.S010102.D0102"
		,baselrecl=5649, range=5, recfm=F);
options notes source source2 errors=20;
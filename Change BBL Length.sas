/***********************************************************************************************************************************************
Author: Arash Farahani
Date: 07-18-2017
Usage: The BBL6 macro changes the lengths of boro block lot to 6. This ensures correct merges with other files with similar BBL length.
************************************************************************************************************************************************/

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

/* Change the length of BORO BLOCK LOT to 6 in newer files */

/* Example
%BBL6(datalist=rpadf17x_l rpadf18x_l rpadf16x_l rpadf17x rpadf18x rpadf16x);
*/


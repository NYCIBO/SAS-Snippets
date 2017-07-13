%macro PrintListWhile(datalist=,obs=5);
  %local i data;
  %let i=1;
  %let data=%scan(&datalist,&i,%str( ));
  %do %while(%superq(data) ne %str());
	ods select Variables;
	footnote 'The file is: ' &data;
	proc contents data=&data;
    run;
	ods select Default;
    %let i=%eval(&i+1);
    %let data=%scan(&datalist,&i,%str( ));
  %end;
%mend;



%PrintListWhile(datalist=Qcew_geo.qcew08si Qcew_geo.qcew09si Qcew_geo.qcew01bk Qcew_geo.qcew01mn Qcew_geo.qcew10bk Qcew_geo.qcew04si Qcew_geo.qcew06bk Qcew_geo.qcew02bk Qcew_geo.qcew12bk Qcew_geo.qcew13si Qcew_geo.qcew11bk Qcew_geo.qcew04bk Qcew_geo.qcew10si Qcew_geo.qcew06mn Qcew_geo.qcew08bk Qcew_geo.qcew15bk Qcew_geo.qcew03bk Qcew_geo.qcew14si Qcew_geo.qcew05si Qcew_geo.qcew02si Qcew_geo.qcew01si Qcew_geo.qcew00bk Qcew_geo.qcew14bk Qcew_geo.qcew05bk Qcew_geo.qcew06si Qcew_geo.qcew13bk Qcew_geo.qcew00mn Qcew_geo.qcew16si Qcew_geo.qcew07bk Qcew_geo.qcew11si Qcew_geo.qcew15si Qcew_geo.qcew15mn Qcew_geo.qcew09bk Qcew_geo.qcew03si Qcew_geo.qcew12si Qcew_geo.qcew05mn Qcew_geo.qcew02mn Qcew_geo.qcew00si Qcew_geo.qcew07si)
run;
/*proc Qcew_geo.contents
     data = Qcew_geo.Qcew00mn
	 ;
run;

proc means 
	data=Rpad.rpadf17x;
	var PROPTYPE1;

run;

data temp;

INPUT Obs Var1 Var2 Var3 Var4 Var5;
DATALINES;
1 1 1 0 . .
2 0 2 . . 0
3 1 3 0 . 1
4 0 2 2 . 2
5 1 1 3 . 3
6 0 2 5 . 4
7 1 3 . . 5
8 0 2 0 . 6
9 1 1 0 . 7
;
proc print;
run;


*makes macro variable called dropvars;

%Macro dropvs(dsn);
  %local ds;
  %global dropVars;
  %local rc;

  %let ds =%sysfunc(open(&dsn));
  %put &ds;
  %Do i=1 %to %Sysfunc(ATTRN(&ds,NVARS));
     %let dropvars =  %sysfunc(VARNAME(&ds,&i)) &dropvars ;
  %end;

  %let rc = %SYSFUNC(CLOSE(&ds));
%mend;


************************************************************;
*Make a dataset containing only the variables that are missing
*throughout the dataset. These variables will be dropped from
*the final product;

proc means data = temp noprint;
        output out= temp2 max=;

proc transpose	data= temp2 out= temp3;
run;

data temp4;
        set temp3;
                if COL1 = .;
run;

proc transpose data = temp4 out = temp5;

data dropset;
         set temp5 (drop= _name_);
run;

***********************************************************;

 %dropvs(dropset);

data tempfinal (drop= &dropvars);
set  temp;
run;

Proc print data= tempfinal; run;
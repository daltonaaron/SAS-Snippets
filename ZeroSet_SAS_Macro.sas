*This macro converts all numeric missing values to zero;

%Macro zeroset;
ARRAY x(*) _numeric_; 
  DO i = 1 to dim(X);  
      If X(i) = . Then Do; X(i)=0;  End;
  End;
%Mend;
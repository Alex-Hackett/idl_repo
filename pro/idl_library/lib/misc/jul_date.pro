function jul_date,time
;+
;			jul_date
;
; A function to calculate the Julian Date  - 2400000
;
; CALLING SEQUENCE:
;	result = jul_date(time)
;
; INPUTS:
;	time - string or string array giving times in form:
;			DD-MMM-YYYY HH:MM:SS.S
;
; OUTPUTS:
;	the julian date - 2400000 is returned as the function result
;
; HISTORY:
;
;  FROM SKY + TEL., APRIL 1981, PROGRAMMED BY S. PARSONS
;  redone into function and allow arrays by TBA
;  D. Lindler May, 1990 - converted to use time in form DD-MMM-YYYY HH:MM:SS.SS
;-
;------------------------------------------------------------------------------
;
; make input into an array if scalar supplied
;
	s = size(time) & ndim = s(0)
	n=n_elements(time)
;	if ndim eq 0 then begin
;	  dayarr=strarr(strlen(time),1)
;	  dayarr(0)=time 
;	end else dayarr=time
	dayarr=[time]
	jd=dblarr(n)
;
; convert each time to JD
;
	for j=0,n-1 do begin
	  ut = date_conv(dayarr(j),'V')
	  year = ut(0)
	  day = ut(1) + (ut(2) + (ut(3) + ut(4)/60d)/60d)/24
	  YEAR= FIX(YEAR)
	  IY= YEAR-1 &  M = 13
	  A= FIX(IY/100)
	  B= 2 - A + FIX(A/4)
	  RY= double(IY)
	  IF YEAR LT 1582 THEN B= 0
	  IF YEAR EQ 1582 THEN BEGIN
	    PRINT,' YEAR 1582 NOT COVERED'
	    RETURN,0  & END
	  jd(j)= long(RY*0.25) + 365.*(RY -1860.) + $
		 long(30.6001*(M+1.)) + B + DAY  - 105.5
	end
	if ndim eq 0 then return, jd(0) else return, jd
end

PRO ZE_CMFGEN_OBTAIN_ABUND_FROM_MOD_SUM,modsum,elemstr,elem,mass=mass
;assumes the abunance appears only once in MOD_SUM, w

ze_hgrep,modsum,elemstr,line_numbers,keepcase=1,result=resultline_quantity,/silent
size_resultline_quantity=(size(resultline_quantity))[1]
IF size_resultline_quantity LT 1 THEN print,'Species not found in MOD_SUM' ELSE BEGIN
   IF resultline_quantity EQ '-1000.0' THEN print,'Species not found in MOD_SUM' ELSE BEGIN
;    print,resultline_quantity
;    help,resultline_quantity
   ;IF size_resultline_quantity EQ 1 THEN  elem=(DOUBLE(strmid(resultline_quantity,strpos(resultline_quantity,elemstr)+strlen(elemstr))))[0] ELSE BEGIN
    IF KEYWORD_SET(MASS) THEN elem=double((strsplit(resultline_quantity,' ', /extract))[2])
   
   ENDELSE 
ENDELSE   
END
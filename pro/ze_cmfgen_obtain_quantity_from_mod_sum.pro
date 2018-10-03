PRO ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,quantitystr,quantity
;assumes the quantity appears only once in MOD_SUM, works only if the quantity is followed by an = sign i.e. does not work for ND, NCF that are in brackets
;putting = sign back , so now it works for R*, that appears multiple times in the search.
ze_hgrep,modsum,quantitystr,line_numbers,keepcase=1,result=resultline_quantity,/silent
size_resultline_quantity=(size(resultline_quantity))[1]
IF size_resultline_quantity LT 1 THEN print,'Variable not found in MOD_SUM' ELSE BEGIN
  IF size_resultline_quantity EQ 1 THEN  quantity=(DOUBLE(strmid(resultline_quantity,strpos(resultline_quantity,quantitystr)+strlen(quantitystr))))[0] ELSE BEGIN
   quantity=(DOUBLE(strmid(resultline_quantity,strpos(resultline_quantity,quantitystr)+strlen(quantitystr))))[0,*]
  ENDELSE 
ENDELSE   
   
END
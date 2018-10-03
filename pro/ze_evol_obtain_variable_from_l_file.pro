PRO ZE_EVOL_OBTAIN_VARIABLE_FROM_l_FILE,varname,data_lfile,variable,index_varname_lfile,return_val,verbose=verbose

ZE_EVOL_LOAD_LFILE_VARIABLE_NAMES, lfile_variables

index_varname_lfile=where(lfile_variables eq varname)
IF KEYWORD_SET(VERBOSE) THEN print,varname,index_varname_lfile
if (index_varname_lfile) EQ -1 then BEGIN
  return_val=-1
  RETURN
ENDIF ELSE BEGIN
  return_val=1
  variable=REFORM(data_lfile[*,index_varname_lfile])  
ENDELSE

END
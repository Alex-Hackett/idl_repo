PRO ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,varname,data_vfile,variable,index_varname_vfile,return_val,verbose=verbose

ZE_EVOL_LOAD_V_FILE_VARIABLE_NAMES, vfile_variables

index_varname_vfile=where(vfile_variables eq varname)
IF KEYWORD_SET(VERBOSE) THEN print,varname,index_varname_vfile
if (index_varname_vfile) EQ -1 then BEGIN
  return_val=-1
  RETURN
ENDIF ELSE BEGIN
  return_val=1
  variable=REFORM(data_vfile[index_varname_vfile,*])  
ENDELSE

END
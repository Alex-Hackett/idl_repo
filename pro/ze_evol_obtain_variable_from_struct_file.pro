PRO ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,varname,data_structfile,variable,index_varname_structfile,return_val,verbose=verbose

ZE_EVOL_LOAD_STRUCT_FILE_VARIABLE_NAMES, structfile_variables

index_varname_structfile=where(structfile_variables eq varname)
IF KEYWORD_SET(VERBOSE) THEN print,varname,index_varname_structfile
if (index_varname_structfile) EQ -1 then BEGIN
  return_val=-1
  RETURN
ENDIF ELSE BEGIN
  return_val=1
  variable=REFORM(data_structfile[index_varname_structfile,*])  
ENDELSE

END
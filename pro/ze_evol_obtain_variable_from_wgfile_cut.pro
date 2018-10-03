PRO ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,varname,data_wgfile_cut,variable,index_varname_wgfile,return_val,verbose=verbose

ncol_wg=(size(data_wgfile_cut))[1]

IF ncol_wg EQ 110 THEN ZE_EVOL_LOAD_WGFILE_VARIABLE_NAMES, wgfile_variables ELSE ZE_EVOL_LOAD_WGFILE_VARIABLE_NAMES_BINARY, wgfile_variables

index_varname_wgfile=where(wgfile_variables eq varname)
IF KEYWORD_SET(VERBOSE) THEN print,varname,index_varname_wgfile
if (index_varname_wgfile) EQ -1 then BEGIN
  return_val=-1
  print,'Variable '+varname+' not found in .wg file'
  RETURN
ENDIF ELSE BEGIN
  return_val=1
  variable=REFORM(data_wgfile_cut[index_varname_wgfile,*])  
ENDELSE

END
FUNCTION ZE_EVOL_VARIABLE_TO_WGFILE_FIELD001_INDEX,varname

ZE_EVOL_LOAD_WGFILE_VARIABLE_NAMES, wgfile_variables
;ze_hgrep,wgfile_variables,varname,index_varname_wgfile,/silent
index_varname_wgfile=where(wgfile_variables eq varname)
return,index_varname_wgfile

END
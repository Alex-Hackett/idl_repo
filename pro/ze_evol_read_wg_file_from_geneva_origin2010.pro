PRO ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010,wgfile,data_wgfile,data_wgfile_cut,$
                                                header_wgfile=header_wgfile,count_Wgfile=count_wgfile,nmodels=nmodels,$
                                                timestep_ini=timestep_ini,timestep_fin=timestep_fin,$
                                                wgfile_loaded=wgfile_loaded
                                                
;reads xxx.wg* files that are output from Geneva Stellar Evolution code, Origin2010
;NOT WORKING VERY WELL, KEPT as BACKUP -- USE V2

If N_elements(wgfile_loaded) GT 0 THEN print,'wg file that has been loaded is: ', wgfile_loaded ELSE print,'No wg file has been loaded'
                  
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
print,'wg file for this model should be: ', wgfile

should_continue=''
IF ((wgfile EQ wgfile_loaded) OR (n_elements(wgfile) LT 0)) THEN print, 'Correct .wg file, proceeding.' ELSE BEGIN
   read,should_continue,prompt='The .wg file is possibly wrong. Do you want to read the default .wg file (r), continue with this .wg file (c), or quit (q)?'
   IF should_continue eq 'q' THEN STOP
   IF should_continue eq 'r' THEN BEGIN 
       data_wgfile=READ_ASCII(wgfile,data_start=0,header=header_wgfile,count=count_wgfile)
       print,'Read the following .wg file:  ', wgfile
;       print,'From timesteps ', timestep_ini,' to ', timestep_fin
   ENDIF ELSE print,'Warning: continuing with the .wg file:  ', wgfile_loaded 
ENDELSE


ZE_EVOL_LOAD_WGFILE_VARIABLE_NAMES, wgfile_variables

zams_timestep=findel(data_wgfile.field001[21,0]*0.997D,REFORM(data_wgfile.field001[21,0:1000])) 

IF n_elements(timestep_ini) LT 0 THEN timestep_ini=zams_timestep
IF N_elements(timestep_fin) LT 0 THEN timestep_fin=n_elements(REFORM(data_wgfile.field001[21,*])) -1
data_wgfile_cut=data_wgfile.field001[*,timestep_ini:timestep_fin]
nmodels=timestep_fin-timestep_ini +1 


END
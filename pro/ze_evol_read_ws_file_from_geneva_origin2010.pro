PRO ZE_EVOL_READ_WS_FILE_FROM_GENEVA_ORIGIN2010,modeldir,model_name,timestep,data_wsfile,s_timestep,b_file_number,$
                                                nzmod=nzmod,pgplot=pgplot,write_input=write_input,plot_to_screen=plot_to_screen,reload=reload
;reads xxx.ws files that are output from Geneva Stellar Evolution code, Origin2010
;modeldir should not contain a trailing '/'
;timestep should be integer or float (IE NOT STRING) and last digit has to be 1 (for default evol settings) WORK MORE ON THIS FOR A GENERAL CASE

 
wsfile=modeldir+'/'+model_name+'.ws'
savedfile='/Users/jgroh/temp/'+model_name+'_ws.sav'

IF (FILE_EXIST(savedfile) eq 0) OR KEYWORD_SET(RELOAD) THEN BEGIN 
  nlines = 0L
  print,'Reading the following .ws file:  ', wsfile
  IF FILE_EXIST(wsfile+'.gz') THEN BEGIN
      OPENR,lun,wsfile+'.gz',/get_LUN,/COMPRESS 
      nlines=FILE_LINES(wsfile+'.gz',/COMPRESS)   
  ENDIF ELSE BEGIN 
      OPENR,lun,wsfile,/get_LUN
      nlines=FILE_LINES(wsfile)
  ENDELSE   
  data_wsfile=strarr(nlines)   
  readf,lun,data_wsfile
  CLOSE,lun
  free_lun,lun
  save,wsfile,data_wsfile,filename='/Users/jgroh/temp/'+model_name+'_ws.sav'
  
ENDIF ELSE BEGIN
  print,'A .sav corresponding to model '+ model_name+' has been found in /Users/jgroh/temp. Loading...'
  restore,savedfile
ENDELSE  

  timestep_str=ZE_EVOL_ADD_SPACE_TO_TIMESTEP_FORMAT(timestep)
  timestep_to_header=strcompress(string(timestep, format='(I07)')) 

;find where a certain timestep is located in the ws file
line_timestep=where(strpos(data_wsfile,'NWSEQ='+timestep_str) ne -1)

;print, timestep_str,line_timestep
s_timestep=data_wsfile[line_timestep[0]-1:line_timestep[0]+20]

b_file_number=float(strmid(s_timestep[0],strpos(s_timestep[0],'MODANF=')+7,7))

nzmod=float(strmid(s_timestep[1],strpos(s_timestep[1],'NZMOD=')+6,7))

;adds header
s_timestep=[model_name,timestep_to_header,s_timestep]

;adds pgplot variables at the last line of s file if requested
IF KEYWORD_SET(PGPLOT) THEN BEGIN 
 IF KEYWORD_SET(plot_to_screen) THEN s_timestep=[s_timestep,' PLOT=  T REFRESH=  T'] ELSE s_timestep=[s_timestep,' PLOT=  F REFRESH=  F']
ENDIF 


print,'Finished reading the following .ws file:  ', wsfile

IF KEYWORD_SET(WRITE_INPUT) THEN BEGIN 
  ZE_WRITE_STRING_TO_ASCII,modeldir+'/'+model_name+'.input',s_timestep
  print,modeldir+'/'+model_name+'.input has been (over)written'
ENDIF

END
PRO ZE_EVOL_READ_V_FILE_FROM_GENEVA_ORIGIN2010,modeldir,model_name,timestep,data_vfile,header_vfile,modnb,age,mtot,nbshell,deltat,compress=compress
;reads xxx.v* files that are output from Geneva Stellar Evolution code, Origin2010
;modeldir should not contain a trailing '/'
;assumes v file contains 93 columns

model=STRMID(modeldir,strpos(modeldir,'/',/REVERSE_SEARCH) +1)
vfile=modeldir+'/'+model_name+'.v'+strcompress(string(timestep, format='(I07)')) 

print,'Reading the following .v file:  ', vfile
header1=''
header_vfile=''
IF FILE_EXIST(vfile+'.gz') THEN OPENR,lun,vfile+'.gz',/get_LUN,/COMPRESS ELSE OPENR,lun,vfile,/get_LUN
readf,lun,header1
readf,lun,modnb,age,mtot,nbshell,deltat
;print,nbshell
readf,lun,header_vfile
a=strpos(header_vfile,'xobla') ;needs this because some v files have 92 columns, other have 93 with 93rd being xobla
IF a GT 0 then ncol=93 ELSE ncol=92
data_vfile=dblarr(ncol,nbshell) 
readf,lun,data_vfile
CLOSE,lun
free_lun,lun

print,'Finished reading the following .v file:  ', vfile

END
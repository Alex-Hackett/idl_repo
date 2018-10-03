PRO ZE_EVOL_READ_STRUCT_FILE_FROM_GENEVA_ORIGIN2010_V1,structfile,modeldir,model_name,timestep,data_structfile,header_structfile,modnb,age,mtot,nbshell,deltat,ncolumns,logteff,compress=compress, header1
;reads xxx.v* files that are output from Geneva Stellar Evolution code, Origin2010
;modeldir should not contain a trailing '/'
;computes number of columns

model=STRMID(modeldir,strpos(modeldir,'/',/REVERSE_SEARCH) +1)
;structfile=STRCOMPRESS(modeldir+'/'+model_name+'_StrucData_'+strcompress(string(timestep, format='(I07)'))+'.dat', /REMOVE_ALL)
;structfile=DIALOG_PICKFILE(PATH='/home/AHACKETT_Project/_PopIIIProject/geneva_models/P015z000S0d010',FILTER='*.dat')
;print,'Reading the following STRUCT file:  ', structfile

header1=strarr(12)
header_structfile=''
IF FILE_EXIST(structfile+'.gz') THEN BEGIN
    OPENR,lun,structfile+'.gz',/get_LUN,/COMPRESS
    ncolumns=ZE_Count_Columns(structfile+'.gz',skip=13,/compress) 
    nbshell=FILE_LINES(structfile+'.gz',/COMPRESS)-13
ENDIF ELSE BEGIN 
    OPENR,lun,structfile,/get_LUN
    ncolumns=ZE_Count_Columns(structfile,skip=13,/compress)
    nbshell=FILE_LINES(structfile)-13
ENDELSE   
readf,lun,header1
;print,header1
data_structfile=dblarr(ncolumns,nbshell) 
readf,lun,data_structfile
CLOSE,lun
free_lun,lun
;print,'Finished reading the following STRUCT file:  ', structfile
logteff=double(strmid(header1[4],13))
;print,'log teff ',double(strmid(header1[4],13))
close,/all
END

PRO AH_EVOL_READ_STRUCT_FILE_FROM_GENEVA_ORIGIN2010_V2,structfile,data_structfile,header_structfile,modnb,age,mtot,nbshell,deltat,ncolumns,logteff,compress=compress
  ;reads xxx.v* files that are output from Geneva Stellar Evolution code, Origin2010
  ;modeldir should not contain a trailing '/'
  ;computes number of columns

 
  ;print,'Reading the following STRUCT file:  ', structfile
  CATCH, errStat
  IF errStat NE 0 THEN BEGIN
    PRINT, !ERROR_STATE.MSG
    PRINT, '=============================='
    PRINT, '========MALFORMED FILE========'
    PRINT, '=============================='
    ;Skip this file, it's a dud
    GOTO, skip
  ENDIF
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
  age = double(strmid(header1[1],13))
  ;print, 'AGE', double(strmid(header1[1],13))
  ;print,'log teff ',double(strmid(header1[4],13))
  skip: 
  IF lun NE 0 THEN BEGIN
    CLOSE, lun
    free_lun, lun
  ENDIF
  close,/all
END

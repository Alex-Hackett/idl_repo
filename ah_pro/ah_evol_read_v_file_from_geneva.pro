PRO AH_EVOL_READ_V_FILE_FROM_GENEVA,vfilename, data_vfile,header_vfile,modnb,age,mtot,nbshell,deltat,compress=compress
  ;reads xxx.v* files that are output from Geneva Stellar Evolution code, Origin2010
  ;modeldir should not contain a trailing '/'
  ;assumes v file contains 93 columns
  
;  CATCH, errStat
;  IF errStat NE 0 THEN BEGIN
;    PRINT, !ERROR_STATE.MSG
;    PRINT, '=============================='
;    PRINT, '========MALFORMED FILE========'
;    PRINT, '=============================='
;    ;Skip this file, it's a dud
;    GOTO, skip
;  ENDIF

  gzipTracker = 0
  vfile = STRING(vfilename)

  ;print,'Reading the following .v file:  ', vfile
  header1=''
  header_vfile=''
  IF STRMID(vfile, 2, /REVERSE_OFFSET) EQ '.gz' THEN BEGIN
    gzipTracker = 1
    gunzipcmd = 'gunzip ' + STRTRIM(vfile, 2)
    SPAWN, gunzipcmd, /SH
    vifle = vfile.REMOVE(-3)
  ENDIF 
  
  OPENR,lun,vfile,/GET_LUN  
  readf,lun,header1
  readf,lun,modnb,age,mtot,nbshell,deltat
  ;print,nbshell
  readf,lun,header_vfile
  a=strpos(header_vfile,'xobla') ;needs this because some v files have 92 columns, other have 93 with 93rd being xobla
  IF a GT 0 then ncol=93 ELSE ncol=92
  data_vfile=dblarr(ncol,nbshell)
  readf,lun,data_vfile
  skip:
  IF lun NE 0 THEN BEGIN
    CLOSE, lun
    free_lun, lun
  ENDIF
  close,/all
  
  IF gzipTracker EQ 1 THEN BEGIN
    gzipcmd = 'gzip ' + STRTRIM(vfile, 2)
    SPAWN, gzipcmd, /SH
  ENDIF
END
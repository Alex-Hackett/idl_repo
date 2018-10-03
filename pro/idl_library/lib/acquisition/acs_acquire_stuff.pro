;+
; $Id: acs_acquire_stuff.pro,v 1.2 2000/09/26 16:19:39 mccannwj Exp $
;
; NAME:
;     ACS_ACQUIRE_STUFF
;
; PURPOSE:
;     Subroutine of ACS_ACQUIRE to acquire STUFF header information.
;
; CATEGORY:
;     ACS/Acquisition
;
; CALLING SEQUENCE:
;     ACS_ACQUIRE_STUFF, header
;
; INPUTS:
;     header - Data Header
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     ERROR - error status on exit (nonzero if an error occurred)
;
; OUTPUTS:
;     header - Data Header
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;	version 1  D. Lindler  Dec 14, 1998
;
;-
PRO acs_acquire_stuff, h, ERROR=error_flag

   error_flag = 0b
                    ; Get list of rascal files available
   list = list_with_path('*.stf','JSTUFF',COUNT=count) 
   IF count EQ 0 THEN BEGIN
      PRINT, 'WARNING: No STUFF Log files found'
      sxaddpar,h,'stffile','NONE','STUFF header file name'
      return
   ENDIF

                    ; determine mjds for the files
   mjds = dblarr(count)
   FOR i=0,count-1 DO BEGIN
      fdecomp,list(i),disk,dir,name
      year = 1900 + byte(strmid(name,0,1))
      date = long([year,strmid(name,1,3), $
                   strmid(name,4,2),strmid(name,6,2),0.0])
      mjds(i) = jul_date(date_conv(date,'S'))-0.5
   ENDFOR

                    ; sort by date
   sub = SORT(mjds)
   mjds = mjds(sub)

                    ; get observation starting time
   filename = sxpar(h,'filename')
   year = strmid(filename,4,2)
   if year lt 50 then year = year + 2000 else year = year + 1900
   day = strmid(filename,6,3)
   hour = strmid(filename,9,2)
   min = strmid(filename,11,2)
   sec = strmid(filename,13,2)
   mjd_obs = jul_date(date_conv([year,day,hour,min,sec],'S'))-0.5

                    ; find files with dates less than the observations
                    ; date and time 
   good = WHERE(mjds le mjd_obs,ngood)
   if ngood lt 1 then begin
      PRINT, 'WARNING: No STUFF file found '
      sxaddpar,h,'stffile','NONE','STUFF header file name'
      return
   ENDIF
   IF (mjd_obs - mjds(good(ngood-1))) gt 1.0 THEN BEGIN
      PRINT, 'WARNING: Last STUFF File > 1 day old, NOT USED'
      sxaddpar,h,'rcfile','NONE','RASCAL header file name'
      return
   ENDIF
   file = list(sub(good(ngood-1)))
   PRINT, 'STUFF Information taken from file '+file
   fdecomp,file,disk,dir,fname
   sxaddpar,h,'stffile',fname,'STUFF header file name'

                    ; read STUFF file
   hr = strarr(100)
   n = 0
   st = ''
   OPENR, unit, file, /GET_LUN, ERROR=open_error
   IF (open_error NE 0) THEN BEGIN
      PRINTF, -2, !ERR_STRING
      error_flag = 1b
      return
   ENDIF

   WHILE NOT EOF(unit) DO BEGIN
      READF, unit, st
      hr(n) = st
      n = n+1
   ENDWHILE
   hr = hr(0:n-1)
   FREE_LUN, unit

                    ; find position to add to main header
   lasth = WHERE(STRMID(h,0,8) eq 'END     ')
   lasth = lasth(0)
   h = [h(0:lasth-1),hr,'END     ']
   return
END

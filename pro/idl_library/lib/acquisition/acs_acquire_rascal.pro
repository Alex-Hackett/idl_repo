;+
; $Id: acs_acquire_rascal.pro,v 1.4 2000/09/26 17:24:59 mccannwj Exp $
;
; NAME:
;     ACS_ACQUIRE_RASCAL
;
; PURPOSE:
;     Subroutine of ACS_ACQUIRE to acquire RASCal header information.
;
; CATEGORY:
;     ACS/Acquisition
;
; CALLING SEQUENCE:
;     ACS_ACQUIRE_RASCAL, header
;
; INPUTS:
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
;     Looks for files of the form rclog[time].fits in the path defined by the
;     JRASCAL environment variable.  The file used is the most recent
;     file whose time is less than or equal to the science image dump
;     time.
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;     version 1  D. Lindler  Aug. 1998
;     version 2  D. Lindler, Dec 6, 1998, modified to use dump time
;               decoded from filename.
;
;-
PRO acs_acquire_rascal, h, ERROR=error_code

   error_code = 0b

                    ; Get list of rascal files available
   list = list_with_path('rclog*.fits','JRASCAL',count=count) 
   if count eq 0 then begin
      PRINT, 'WARNING: No RASCAL Log files found'
      sxaddpar,h,'rcfile','NONE','RASCAL header file name'
      return
   endif

                    ; determine mjds for the files
   mjds = dblarr(count)
   for i=0,count-1 do begin
      fdecomp,list(i),disk,dir,name
      date = long([strmid(name,5,4),strmid(name,9,3), $
                   strmid(name,12,2),strmid(name,14,2),strmid(name,16,2)])
      mjds(i) = jul_date(date_conv(date,'S'))-0.5
   endfor

                    ; sort by date
   sub = sort(mjds)
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
   good = where(mjds le mjd_obs,ngood)
   if ngood lt 1 then begin
      print,"WARNING: No Rascal file found "
      sxaddpar,h,'rcfile','NONE','RASCAL header file name'
      return
   endif
   if (mjd_obs - mjds(good(ngood-1))) gt 1.0 then begin
      print,'WARNING: Last Rascal File > 1 day old, NOT USED'
      sxaddpar,h,'rcfile','NONE','RASCAL header file name'
      return
   endif
   file = list(sub(good(ngood-1)))
   print,'RASCAL Information taken from file '+file
   fdecomp,file,disk,dir,fname
   sxaddpar,h,'rcfile',fname,'RASCAL header file name'

                    ; read rascal file
   fits_read, file, d, hr, EXTEN=0, /NO_ABORT, MESSAGE=message
   IF !ERR LT 0 THEN BEGIN
      IF N_ELEMENTS(message) GT 0 THEN MESSAGE, message, /CONTINUE
      error_code = 1b
      return
   ENDIF 

                    ; delete some keywords
   sxdelpar,hr,['SIMPLE','BITPIX','NAXIS','NAXIS1','NAXIS2','EXTEND']

                    ; find position to add to main header
   lasth = WHERE(STRMID(h,0,8) eq 'END     ')
   lasth = lasth(0)
   lasthr = WHERE(STRMID(hr,0,8) eq 'END     ',n)
   IF n LT 0 THEN BEGIN
      MESSAGE, 'ERROR: No END card in rascal file', /CONTINUE
      error_code = 1b
      return
   ENDIF
   lasthr = lasthr(0)
   if lasthr gt 1 then h = [h(0:lasth-1),hr(0:lasthr-1),'END     ']
   return
END

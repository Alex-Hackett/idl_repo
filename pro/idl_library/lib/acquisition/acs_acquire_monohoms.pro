;+
; $Id: acs_acquire_monohoms.pro,v 1.4 2001/02/24 05:40:48 mccannwj Exp $
;
; NAME:
;     ACS_ACQUIRE_MONOHOMS
;
; PURPOSE:
;     Subroutine of ACS_ACQUIRE to acquire HOMS + monochromator
;     header information.
;
; CATEGORY:
;     ACS/Acquisition
;
; CALLING SEQUENCE:
;     ACS_ACQUIRE_MONOHOMS, header
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
;     Looks for files of the form m[time].log in the path defined by the
;     JMONOHOMS environment variable.  The file used is the most recent
;     file whose time is less than or equal to the science image dump
;     time.
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;     version 1  McCann - adopted from acs_acquire_rascal
;-
PRO acs_acquire_monohoms, h, ERROR=error_code

   error_code = 0b

                    ; Get list of monochromator files available
   list = list_with_path('m*.log','JMONOHOMS',count=count) 
   if count eq 0 then begin
      PRINT, 'WARNING: No MONO/HOMS log files found'
      return
   endif

                    ; determine mjds for the files
   mjds = dblarr(count)
   for i=0,count-1 do BEGIN
      fdecomp,list(i),disk,dir,name
      date = long([strmid(name,1,4),strmid(name,5,3), $
                   strmid(name,8,2),strmid(name,10,2),strmid(name,12,2)])
      mjds(i) = jul_date(date_conv(date,'S'))-0.5
   endfor

                    ; sort by date
   sub = sort(mjds)
   mjds = mjds(sub)

                    ; get observation starting time
   IF N_ELEMENTS(h) GT 1 THEN BEGIN
      filename = sxpar(h,'filename')
      year = strmid(filename,4,2)
      if year lt 50 then year = year + 2000 else year = year + 1900
      day = strmid(filename,6,3)
      hour = strmid(filename,9,2)
      min = strmid(filename,11,2)
      sec = strmid(filename,13,2)
      mjd_obs = jul_date(date_conv([year,day,hour,min,sec],'S'))-0.5
   ENDIF ELSE mjd_obs = SYSTIME(/JULIAN) - DOUBLE(2.4e6) - 0.5d + (5/24.0)

                    ; find files with dates less than the observations
                    ; date and time
   good = where(mjds le mjd_obs,ngood)
   if ngood lt 1 then begin
      print,"WARNING: No MONO/HOMS file found "
      return
   endif
   if (mjd_obs - mjds(good(ngood-1))) gt 1.0 then begin
      print,'WARNING: Last MONO/HOMS file > 1 day old, NOT USED'
      return
   endif
   file = list(sub(good(ngood-1)))
   print,'MONO/HOMS information taken from file '+file
   fdecomp,file,disk,dir,fname

                    ; read MONO/HOMS file
   OPENR, lun, file, /GET_LUN, ERROR=open_error
                    ; If err is nonzero, something happened. Print the
                    ; error message to the standard error file
                    ; (logical unit -2):
   IF (open_error NE 0) THEN BEGIN
      PRINTF, -2, !ERROR_STATE.MSG
      error_code = 1b
      return
   ENDIF 
   log_contents = ['','']
   READF, lun, log_contents
   FREE_LUN, lun

; MONOWAVE=              6578.00 / Monochromator wavelength setting (Angstroms)   

   regex = '^([a-zA-Z]+)[ ]*=[ ]*([.0-9]+)[ ]*/(.*)'
   subs = STREGEX(log_contents[0],regex,/FOLD_CASE,/EXTRACT,/SUBEXPR)
   IF N_ELEMENTS(subs) EQ 4 THEN BEGIN
      wave_key = subs[1]
      wave_value = FLOAT(subs[2])
      wave_comment = STRTRIM(subs[3],2)
   ENDIF ELSE BEGIN
      wave_key = 'MONOWAVE'
      wave_value = 0.0
      wave_comment = ' Monochromator wavelength setting (Angstroms)'
   ENDELSE

   regex = "^([a-zA-Z]+)[ ]*=[ ]*'([a-zA-Z]+)'[ ]*/(.*)"
   subs = STREGEX(log_contents[1],regex,/FOLD_CASE,/EXTRACT,/SUBEXPR)
   IF N_ELEMENTS(subs) EQ 4 THEN BEGIN
      grtg_key = subs[1]
      grtg_value = STRTRIM(subs[2],2)
      grtg_comment = STRTRIM(subs[3],2)
   ENDIF ELSE BEGIN
      grtg_key = 'MONOGRTG'
      grtg_value = 'OUT'
      grtg_comment = ' Monochromator grating selection'
  ENDELSE

  HELP, wave_key, wave_value, wave_comment
  HELP, grtg_key, grtg_value, grtg_comment

   
   IF N_ELEMENTS(h) GT 1 THEN BEGIN
                    ; find position to add to main header
      lasth = WHERE(STRMID(h,0,8) eq 'END     ')
      lasth = lasth[0]
      sxaddpar, h, wave_key, wave_value, wave_comment
      sxaddpar, h, grtg_key, grtg_value, grtg_comment
   ENDIF 
   return
END

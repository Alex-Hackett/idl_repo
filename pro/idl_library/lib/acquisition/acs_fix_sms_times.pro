;+
; $Id: acs_fix_sms_times.pro,v 1.5 2001/05/30 16:35:48 mccannwj Exp $
;
; NAME:
;     ACS_FIX_SMS_TIMES
;
; PURPOSE:
;     Routine to fix observation time and date in database entry that used
;     SMS time rather than current time.
;
; CATEGORY:
;     ACS/Acquisition
;
; CALLING SEQUENCE:
;     ACS_FIX_SMS_TIMES, entry1, entry2 [, list, /REPORT_ONLY]
;
; INPUTS:
;     entry1 - first entry to fix
;     entry2 - last entry to fix
;     list   - list of entries that were/would be changed
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     /REPORT_ONLY - will only report the bad entries
;
; OUTPUTS:
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
;	version 1  D. Lindler  Feb. 5, 1999
;               2  McCann, 23 May 2000 - fixed Y2K bug parsing filename
;
;-
PRO acs_fix_sms_times, entry1, entry2, badlist, REPORT_ONLY=report_only

                    ; extract dates and times
   dbopen, 'acs_log'
   list = dbfind(STRTRIM(entry1,2)+'<entry<'+STRTRIM(entry2,2)+ $
                 ',expstart>1')
   IF list[0] EQ 0 THEN return
   dbext, list, 'date-obs,time-obs,expstart,filename', date, time, mjd, file
   dbclose

                    ; convert filenames to MJD
   n = N_ELEMENTS(list)
   mjdfile = DBLARR(n)
   FOR i=0,n-1 DO BEGIN
      filename = file[i]
      year_offset = STRMID(filename,4,2)
      IF year_offset GT 90 THEN year = 1900 + year_offset $
      ELSE year = 2000 + year_offset
      day = FIX( STRMID(filename,6,3) )
      hour = FIX( STRMID(filename,9,2) )
      min = FIX( STRMID(filename,11,2) )
      sec = FIX( STRMID(filename,13,2) )
      date = date_conv([year,day,hour,min,sec],'S')
      mjdfile[i] = jul_date(date)-0.5
   ENDFOR

                    ; find observations with times that need to be fixed
   bad = WHERE(ABS(mjdfile - mjd) GT 2,nbad)
   IF nbad EQ 0 THEN RETURN

                    ; process bad observations
   list = list[bad]
   badlist = list
   IF KEYWORD_SET(report_only) THEN RETURN
   date = date[bad]
   time = time[bad]
   mjd = mjd[bad]
   mjdfile = mjdfile[bad]

                    ; open db for update
   dbopen,'acs_log',1

                    ; loop on dump times
   dumptimes = mjdfile[rem_dup(mjdfile)]
   n_fix = N_ELEMENTS(dumptimes)
   PRINT, 'Fixing SMS times for '+STRTRIM(n_fix,2)+' dump files'
   FOR i=0,n_fix-1 DO BEGIN

                    ; extract information for this dump
      iobs = WHERE(mjdfile EQ dumptimes[i],nobs)
      list1 = list[iobs]
      date1 = date[iobs]
      time1 = time[iobs]
      mjd1 = mjd[iobs]
      mjdfile1 = mjdfile[iobs]

                    ; find exposure time of last observation in the dump
      last = list1[nobs-1]
      exptime = dbval(last,'exptime')/60.0/60.0/24

                    ; offset all times so that the last time is the
                    ; dumptime minus the exposure time.
      offset = (mjdfile1[nobs-1]-exptime) - mjd1[nobs-1]
      newmjd = mjd1 + offset

                    ; convert to dates and times
      CALDAT,newmjd+2400000.5d0,mon,day,year,hour,min,sec
      year = year - 1900
      year = year - (year GT 100)*100
      
      newdat = STRING(day,'(I2.2)')+'/'+STRING(mon,'(I2.2)') + $
       '/'+STRMID(STRING(year,'(I4.4)'),2,2)
      newtime = STRING(hour,'(I2.2)')+':'+STRING(min,'(I2.2)')+ $
       ':'+STRING(round(sec),'(I2.2)')+'.00'

                    ; update catalog
      FOR j=0,nobs-1 DO BEGIN
         dbrd,list1[j],e
         dbput,'expstart',newmjd[j],e
         dbput,'date-obs',newdat[j],e
         dbput,'time-obs',newtime[j],e
         dbwrt,e
      ENDFOR 
   ENDFOR
   dbclose
   return
END

;+
; $Id: acs_time.pro,v 1.3 2000/09/26 14:08:28 mccannwj Exp $
;
; NAME:
;     ACS_TIME
;
; PURPOSE:
;     Function to convert from ACS time to UTC.
;
; CATEGORY:
;     ACS/Acquisition
;
; CALLING SEQUENCE:
;     result = ACS_TIME(sctime,mie_time,csoffset,zero_time)
; 
; INPUTS:
;     sctime - three words of spacecraft time (total of 42 bits)
;               first word has upper 16 bits
;               second word has next 16 bits
;               last word has last 10 bits in upper 10 bit position.
;               units of sctime are in 1/8192. seconds
;     mie_time - MIE coarse time (in units of 32 ms)
;     csoffset - Time since the MIE coarse time update in units of
;               kernel ticks (approx 10 ms)
;     zero_time - spacecraft zero time (1 sec. intervals
;               since midnight, 17 Nov 1858)
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;     result - UTC time converted to string of with format
;          DD-MMM-YYYY HH:MM:SS.SSS
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
;	Version 1 D. Lindler May, 1998
;       version 1.1 McCann June 2000 - changed format code for time to I2.2
;
;-
FUNCTION acs_time, sctime, mie_time, csoffset, zero_time

                    ; check to see if time present
;;	if max(abs([sctime,mie_time,csoffset])) eq 0 then return,''


; CONVERT INPUT VECTOR TO FLOATING POINT
; AND CHECK TO SEE IF SIGN BIT WAS USED FOR ANY
; OF THE INTEGERS

                    ; Determine total number of secs since sc zerotime
   sc = LONG(sctime)
   sc = sc + (sc LT 0)*65536 ; get rid of neg. numbers
   sc[2] = sc[2]/64 ;only want 10 bits
   secs = sc[2]/8192d0 + sc[1]/8d0 + sc[0]*8192d0

                    ; add mie_time and csoffset
   secs = secs + mie_time*0.032 + csoffset*0.010

                    ; add sc zero time after subtracting number of
                    ; seconds to Jan 1, 1979 00:00:00
   SECS=SECS+(ZERO_TIME-3790713600D0)

                    ; determine julian date
   jd = JULDAY(1,1,1979,0,0,0) + secs/60.0/60.0/24.0

                    ; determine calendar date
   CALDAT,jd,mon,day,year,hour,min,sec

                    ; determine month and day of month
   months=['JAN','FEB','MAR','APR','MAY','JUN', $
           'JUL','AUG','SEP','OCT','NOV','DEC']

   seconds = STRING(FORMAT='(I2.2)',LONG(sec))
   fracts = STRMID(STRING(FORMAT='(F4.2)',sec - LONG(sec)),1,3)
   RETURN, STRING(day,'(i2.2)') + '-'+months[mon-1] + '-' + $
    STRING(year,'(i4)') + ' ' + $
    STRING(hour,'(i2.2)') + ':' + STRING(min,'(i2.2)') + ':' + seconds+fracts
END

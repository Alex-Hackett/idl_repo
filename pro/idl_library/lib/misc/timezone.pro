;+
; $Id: timezone.pro,v 1.1 2001/11/05 21:41:05 mccannwj Exp $
;
; NAME:
;     TIMEZONE
;
; PURPOSE:
;     Calculate the local time offset from UTC.
;
; CATEGORY:
;     Time/Date
;
; CALLING SEQUENCE:
;     Result = TIMEZONE()
; 
; INPUTS:
;     none.
;
; OPTIONAL INPUTS:
;     none.
;      
; KEYWORD PARAMETERS:
;     none.
;
; OUTPUTS:
;     Returns the local timezone.
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;     none.
;
; SIDE EFFECTS:
;     none.
;
; RESTRICTIONS:
;     none.
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;       Fri Jul 9 18:36:06 1999, William Jon McCann
;       <mccannwj@acs13.+ball.com>
;
;		written.
;
;-
FUNCTION timezone

   local_jd = SYSTIME(/JULIAN) & utc_sec = SYSTIME(/SECONDS)

   t0 = JULDAY( 1, 1, 1970, 0, 0, 0 )
   utc_jd = utc_sec / ( 3600d * 24d ) + t0
   
   diff_hours = (local_jd - utc_jd) * 24.0

   zone = FIX( diff_hours )

   return, zone
END 

;+
; $Id: rcs_date.pro,v 1.1 2001/11/05 21:39:26 mccannwj Exp $
;
; NAME:
;     RCS_DATE
;
; PURPOSE:
;     Extract a version number from an RCS $Date: 2001/11/05 21:39:26 $ tag
;
; CATEGORY:
;     ACS/Misc
;
; CALLING SEQUENCE:
;     result = RCS_DATE(rcs_tag)
; 
; INPUTS:
;     rcs_tag - (STRING) text of the RCS revision tag
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;     result - (STRING) date and time from RCS tag
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
;     strDate = RCS_DATE( ' $Date: 2001/11/05 21:39:26 $ ' )
;
; MODIFICATION HISTORY:
;
;       Thu Jun 15 21:26:27 2000, William Jon McCann
;       <mccannwj@acs13.+ball.com>
;-
FUNCTION rcs_date, strDate, DEBUG=debug
   COMPILE_OPT IDL2, HIDDEN

   IF N_ELEMENTS( strDate ) LE 0 THEN return, '1999/00/00 00:00:00'

   colon_pos = STRPOS( strDate, ':' )

   dollar_pos = STRPOS( strDate, '$', /REVERSE_SEARCH )

   IF KEYWORD_SET( debug ) THEN HELP, colon_pos, dollar_pos

   IF (colon_pos EQ -1) OR (dollar_pos EQ -1) OR (dollar_pos LE colon_pos) $
    THEN return, '1999/00/00 00:00:00'

   version_date = STRMID( strDate, colon_pos + 1, dollar_pos - colon_pos - 1 )

   return, version_date

END 

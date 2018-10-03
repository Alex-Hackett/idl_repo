;+
; $Id: rcs_revision.pro,v 1.1 2001/11/05 21:39:53 mccannwj Exp $
;
; NAME:
;     RCS_REVISION
;
; PURPOSE:
;     Extract a version number from an RCS $Revision: 1.1 $ tag
;
; CATEGORY:
;     ACS/Misc
;
; CALLING SEQUENCE:
;     result = RCS_REVISION(rcs_tag)
; 
; INPUTS:
;     rcs_tag - (STRING) text of the RCS revision tag
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;     result - (STRING) major.minor version number
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
;     strVersion = RCS_REVISION( ' $Revision: 1.1 $ ' )
;
; MODIFICATION HISTORY:
;
;       Thu Jun 15 21:25:14 2000, William Jon McCann
;       <mccannwj@acs13.+ball.com>
;-

FUNCTION rcs_revision, strRevision, DEBUG=debug
   COMPILE_OPT IDL2, HIDDEN

   IF N_ELEMENTS( strRevision ) LE 0 THEN return, '0.0'

   colon_pos = STRPOS( strRevision, ':' )

   dollar_pos = STRPOS( strRevision, '$', /REVERSE_SEARCH )

   IF KEYWORD_SET( debug ) THEN HELP, colon_pos, dollar_pos

   IF (colon_pos EQ -1) OR (dollar_pos EQ -1) OR (dollar_pos LE colon_pos) $
    THEN return, '0.0'

   version = STRTRIM(STRMID(strRevision, colon_pos+1, $
                              dollar_pos-colon_pos-1), 2)

   return, version
END 

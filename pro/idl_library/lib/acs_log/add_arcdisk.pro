;+
; $Id: add_arcdisk.pro,v 1.1 2001/11/05 20:42:08 mccannwj Exp $
;
; NAME:
;     ADD_ARCDISK
;
; PURPOSE:
;     Add an archive disk item to a range of entries.
;
; CATEGORY:
;     ACS
;
; CALLING SEQUENCE:
;     ADD_ARCDISK, diskname, id1, id2
; 
; INPUTS:
;     diskname - (STRING) archive disk name
;     id1      - (INTEGER) first database entry number
;     id2      - (INTEGER) last database entry number
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     VERBOSE  - (BOOLEAN) verbose
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;     Updates the ACS_LOG database
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;       Thu Dec 9 08:31:40 1999, William Jon McCann
;       <mccannwj@acs13.+ball.com>
;
;		written.
;
;-

PRO add_arcdisk, name, id1, id2, VERBOSE=verbose

   IF N_PARAMS() LT 3 THEN BEGIN
      PRINT, "Usage: add_arcdisk, name, id1, id2"
      return
   ENDIF 

   priv_saved = !PRIV
   !PRIV = 2
   dbopen, 'acs_log', 1

   IF KEYWORD_SET( verbose ) THEN $
    PRINT, FORMAT='("Adding ",A," to ",I,1H-,I)', name,id1,id2
   FOR i=LONG(id1), id2 DO BEGIN
      dbput, 'arcdisk', name, i
   ENDFOR 

   dbclose
   !PRIV = priv_saved

   return
END 

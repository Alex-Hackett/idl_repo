;+
; $Id: acs_tba.pro,v 1.1 2001/11/05 21:08:57 mccannwj Exp $
;
; NAME:
;     ACS_TBA
;
; PURPOSE:
;     Show amount of data left to be archived.
;
; CATEGORY:
;     ACS/Archive
;
; CALLING SEQUENCE:
;     ACS_TBA
; 
; INPUTS:
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
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
;     Uses ACS_GET_FILE.
;
; PROCEDURE:
;     Finds all files in the database that occur after the latest
;     ARCDISK entry.
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;       Wed Sep 8 10:23:24 1999, William Jon McCann
;-

PRO acs_tba

   DBOPEN, 'acs_log'
   DBEXT, -1, 'arcdisk', arcdisk
   first_entry = MAX(WHERE(arcdisk EQ MAX(arcdisk)))+1

   n_entries = DB_INFO( 'ENTRIES', 0 )
   IF (first_entry GE n_entries) OR (first_entry LE 0) THEN BEGIN
      strMessage = 'first entry must be > 0 < '+STRTRIM(n_entries,2)
      MESSAGE, strMessage, /INFO
      return      
   ENDIF 

   list = LINDGEN( n_entries - first_entry + 1 ) + first_entry

   cd_limit = 650.0
   ACS_GET_FILE, list, COUNT=count, /NO_COPY, $
    /SILENT, AMOUNT=total_amount, EXT='.fits.gz'

   last_entry = first_entry + count - 1
   PRINT, FORMAT='(I," files totalling ",F8.2," Mb since entry ",A)', $
    count, total_amount, STRTRIM(first_entry,2)

   return
END 

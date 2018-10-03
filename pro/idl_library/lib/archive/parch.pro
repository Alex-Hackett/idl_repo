;+
; $Id: parch.pro,v 1.2 2000/06/20 23:56:03 mccannwj Exp $
;
; NAME:
;     PARCH
;
; PURPOSE:
;     Gather data for a preflight archive cdrom.
;
; CATEGORY:
;     JHU/ACS
;
; CALLING SEQUENCE:
;     PARCH, first_entry [, /COPY]
; 
; INPUTS:
;     first_entry - (INTEGER) the first entry number for the new cdrom.
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     COPY - (BOOL) copy the collected files to the current directory.
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;     Files copied to the current directory.
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;     Uses ACS_GET_FILE.
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;       Wed Sep 8 10:23:24 1999, William Jon McCann
;       <mccannwj@acs13.+ball.com>
;
;		written.
;
;-

PRO parch, first_entry, COPY=copy, ARCHIVE_DIR=archive_dir

   IF N_PARAMS() LT 1 THEN BEGIN
      strMessage = 'usage: PARCH, first_entry'
      MESSAGE, strMessage, /INFO, /NONAME
      return
   ENDIF

   IF N_ELEMENTS( archive_dir ) LE 0 THEN archive_dir='/acs/data2/misc/archive'
   no_copy = KEYWORD_SET( copy ) NE 1

   CD, archive_dir, CURRENT=old_dir

   DBOPEN, 'acs_log'
   n_entries = DB_INFO( 'ENTRIES', 0 )
   IF (first_entry GE n_entries) OR (first_entry LE 0) THEN BEGIN
      strMessage = 'first entry must be > 0 < '+STRTRIM(n_entries,2)
      MESSAGE, strMessage, /INFO
      return      
   ENDIF 

   list = LINDGEN( n_entries - first_entry + 1 ) + first_entry

   cd_limit = 650.0
   ACS_GET_FILE, list, COUNT=count, LIMIT=cd_limit, NO_COPY=no_copy, $
    VERBOSE=0, AMOUNT=total_amount, EXT='.fits.gz'

   last_entry = first_entry + count - 1

   PRINT, FORMAT='("collected entries ",I0," - ",I0," total ",F6.2," Mb")', $
    first_entry, last_entry, total_amount

   CD, old_dir

   return
END 

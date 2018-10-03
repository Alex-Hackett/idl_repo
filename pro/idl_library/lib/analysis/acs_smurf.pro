;+
; $Id: acs_smurf.pro,v 1.4 2002/03/05 18:02:18 mccannwj Exp $
;
; NAME:
;     ACS_SMURF
;
; PURPOSE:
;     ACS Servicing mission uniform reduction of functional data
;
; CATEGORY:
;     ACS/analysis
;
; CALLING SEQUENCE:
;     ACS_SMURF, first_entry
; 
; INPUTS:
;     first_entry - first database entry number of functional test
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;     The only outputs are to the screen and printer.
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
;     The ACS SM functional test includes the following set of images:
;     - WFC full-frame bias using amps ABCD
;     - WFC full-frame tungsten lamp #1 using amps ABCD
;     - WFC 531x2087 tungsten lamp #1 using amp A
;     - WFC 531x2087 tungsten lamp #2 using amp D
;     - 3 HRC full-frame bias using amp C
;     - HRC full-frame bias using amp A
;     - HRC full-frame bias using amp B
;     - HRC full-frame bias using amp D
;     - HRC full-frame tungsten lamp #3 using amp A
;     - HRC full-frame tungsten lamp #4 using amp B
;     - HRC full-frame tungsten lamp #3 using amp C
;     - HRC full-frame tungsten lamp #4 using amp D
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;-

FUNCTION acs_smurf_entry_available, number
   
   exists = 0
   REPEAT BEGIN
                    ; check that entry exists in database
      unavailable = 0b
      DBOPEN, 'acs_log', UNAVAIL=unavailable
      IF unavailable[0] NE 0 THEN BEGIN
         exists = -1
         PRINT, 'Database is unavailable'
         return, exists
      ENDIF
      
      n_entries = LONG(db_info('entries'))
      IF number[0] GT n_entries[0] THEN BEGIN
         PRINT, FORMAT='(A,$)', $
          'Specified entry does not exist in the database.  Waiting...  (q to quit)' $
          +STRING(13b)
         key = GET_KBRD(0)
         IF STRUPCASE(STRTRIM(key,2)) EQ 'Q' THEN BEGIN
            exists=-1
            PRINT, ''
         ENDIF ELSE WAIT, 5
      ENDIF ELSE exists=1
   ENDREP UNTIL exists NE 0

   return, exists
END 

PRO acs_smurf, first_entry, ERROR=error_code, FORCE=force
   
   error_code = 0b
   IF N_PARAMS() LT 1 THEN BEGIN
      error_code = 1b
      MESSAGE, 'usage: smurf, first_entry', /CONTINUE
      return
   ENDIF 

   IF acs_smurf_entry_available(first_entry) LE 0 THEN BEGIN
      error_code = 1b
      return
   ENDIF 

   IF NOT KEYWORD_SET(force) THEN BEGIN
                    ; check that first_entry matches the SM rootname
      test_smft_rootname = 'J20LTJ01'
      orbit_smft_rootname = 'J83COJ01'
      first_rootname = STRTRIM(DBVAL(first_entry,'rootname'),2)
      IF (test_smft_rootname NE first_rootname) AND $
         (orbit_smft_rootname NE first_rootname) THEN BEGIN
         error_code = 1b
         PRINT, 'Specified entry does not match SM FT rootname, use the /FORCE keyword.'
         return
      ENDIF 
   ENDIF

                    ; Start up a DINO session
   dino

   n_smft_images=14
   FOR i=0,n_smft_images-1 DO BEGIN
      entry_number = first_entry[0]+i
      IF acs_smurf_entry_available(entry_number) LE 0 THEN BEGIN
         error_code = 1b
         return
      ENDIF 
      dbext, entry_number, 'detector,obstype,subarray', $
       detector, obstype, subarray
      obstype = STRUPCASE(STRTRIM(obstype[0],2))
      subarray = STRUPCASE(STRTRIM(subarray[0],2))
                    ; Print each image
      ;;rashoms_ps, entry_number, /PRINT
      CASE obstype OF
         'BIAS': BEGIN
                    ; Use DINO on all full-frame biases
            IF subarray EQ 'FULL' THEN dino_load, entry_number
         END
         'DARK': BEGIN
         END
         'INTERNAL': BEGIN
         END
         ELSE:
      ENDCASE
   ENDFOR 

                    ; done.
END 

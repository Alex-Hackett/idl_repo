;+
; $Id: dino_load.pro,v 1.3 2000/10/04 21:05:41 mccannwj Exp $
;
; NAME:
;     DINO_LOAD
;
; PURPOSE:
;     Load a new image into an already active DINO.
;
; CATEGORY:
;     ACS/Analysis
;
; CALLING SEQUENCE:
;     DINO_LOAD, value [, /ACS_SDI, /ACS_LOG, /FITS, /NO_PRINT]
; 
; INPUTS:
;     value - Data value interpreted according to type keywords specified.
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     /ACS_LOG - value is interpreted as an ACS_LOG database entry
;                number (this is the default).
;     /ACS_SDI - value is interpreted as an ACS SDI file name.
;     /FITS    - value is interpreted as a FITS format file name.
;     /NO_PRINT - by default DINO_LOAD will cause DINO to produce a
;                 summary page printout, setting this keyword will
;                 prevent this behavior.
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;     COMMON DINO, handler
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; PROCEDURE:
;     Sends a 'DINO_LOAD' event to an active DINO window.
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;    Wed Apr 28 11:38:07 1999, William Jon McCann
;    <mccannwj@acs13.+hst.nasa.gov>
;		written.
;
;-

PRO dino_load, entry, ACS_LOG=type_acs_log, ACS_SDI=type_acs_sdi, $
               FITS=type_fits, NO_PRINT=no_print, $
               NO_SAVE_LINES=no_save_lines

   COMMON DINO, handler

                    ; Add new types here
   type = 'ACS_LOG'
   IF KEYWORD_SET(type_acs_log) THEN BEGIN
      type='ACS_LOG'
      entry = LONG(entry)
   ENDIF 
   IF KEYWORD_SET(type_acs_sdi) THEN BEGIN
      type='ACS_SDI'
      entry = STRTRIM(entry,2)
   ENDIF 
   IF KEYWORD_SET(type_fits) THEN BEGIN
      type='FITS'
      entry = STRTRIM(entry,2)
   ENDIF

   print = 1b
   IF KEYWORD_SET(no_print) THEN print = 0b

   save_lines = 1b
   IF KEYWORD_SET(no_save_lines) THEN  save_lines = 0b

   IF N_ELEMENTS( handler ) LE 0 THEN BEGIN
      MESSAGE, "Oops can't find an active DINO.", /CONT
      return
   ENDIF

   IF NOT WIDGET_INFO( handler, /VALID ) THEN BEGIN
      MESSAGE, 'Oops no DINO active.', /CONT
      return
   ENDIF

   IF N_ELEMENTS(entry) LE 0 THEN BEGIN
      MESSAGE, "usage: dino_load, entry", /CONT, /NONAME
      return
   ENDIF

   sSendEvent = { ID: handler, $
                  TOP: handler, $
                  HANDLER: handler, $
                  TYPE: type, $
                  PRINT: print, $
                  SAVE_LINES: save_lines, $
                  UVALUE: 'DINO_LOAD', $
                  VALUE: entry }
   
   WIDGET_CONTROL, handler, SEND_EVENT=sSendEvent
END

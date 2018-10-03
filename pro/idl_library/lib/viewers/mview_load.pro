;+
; $Id: mview_load.pro,v 1.3 2000/03/02 18:15:22 mccannwj Exp $
;
; NAME:
;     MVIEW_LOAD
;
; PURPOSE:
;     Load a new image into an already active MVIEWer.
;
; CATEGORY:
;     ACS/JHU
;
; CALLING SEQUENCE:
;     MVIEW_LOAD, image
; 
; INPUTS:
;     image - (2D/3D ARRAY) the image(s) to load.
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     NO_COPY - (BOOLEAN) set to take the data away from the source
;                and attach it directly to the destination.
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;     COMMON MVIEW, handler
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; PROCEDURE:
;     Sends a 'MVIEW_LOAD' event to an active MVIEW window.
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;    Wed Apr 28 11:38:07 1999, William Jon McCann
;    <mccannwj@acs13.+hst.nasa.gov>
;
;		written.
;
;-

PRO mview_load, ims, header, LABELS=labels, NO_COPY = no_copy

   COMMON MVIEW, handler

   IF N_ELEMENTS( handler ) LE 0 THEN BEGIN
      MESSAGE, "Oops can't find a mviewer.", /CONT
      return
   ENDIF

   IF NOT WIDGET_INFO( handler, /VALID ) THEN BEGIN
      MESSAGE, 'Oops no mview active.', /CONT
      return
   ENDIF

   IF N_ELEMENTS( header ) LE 0 THEN header = ''
   IF N_ELEMENTS( labels ) LE 0 THEN labels = ''

   IF N_ELEMENTS( ims ) GT 0 THEN BEGIN
      ims_sz = SIZE( ims )

      CASE ims_sz[0] OF 

         0: BEGIN
                    ; ACS_LOG entry number
            type_flag = 1b
            image = ims
         END 

         1: BEGIN
                    ; Array of entry numbers
            type_flag = 1b
            image = ims
         END 
         
         ELSE: BEGIN
            IF KEYWORD_SET( no_copy ) THEN image = TEMPORARY( ims ) $
            ELSE image = ims
         END
      ENDCASE

   ENDIF ELSE BEGIN
      MESSAGE, "usage: mview_load, image [,header]", /CONT, /NONAME
      return
   ENDELSE

   IF N_ELEMENTS( type_flag ) LE 0 THEN type_flag = 0b

   sSendEvent = { ID: handler, $
                  TOP: handler, $
                  HANDLER: handler, $
                  TYPE: type_flag, $
                  UVALUE: 'MVIEW_LOAD', $
                  VALUE: image, $
                  HEADER: header, $
                  LABEL: labels }
   
   WIDGET_CONTROL, handler, SEND_EVENT=sSendEvent
   
END

;+
; $Id: x_trace.pro,v 1.1 2001/11/05 22:12:16 mccannwj Exp $
;
; NAME:
;     X_TRACE
;
; PURPOSE:
;
; CATEGORY:
;     ACS/Widgets
;
; CALLING SEQUENCE:
;     X_TRACE, wDraw, xsize, ysize, xpos, ypos, lastx, lasty, /ERASE_ONLY
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
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;       Thu Jun 15 21:24:08 2000, William Jon McCann
;       <mccannwj@acs13.+ball.com>
;-

PRO x_trace, wDraw, xpos, ypos, LASTX=lastx, LASTY=lasty, $
             XSIZE=xsize, YSIZE=ysize, ERASE_ONLY=erase, $
             ZOOM_FACTOR=zoom_factor
   COMPILE_OPT IDL2, HIDDEN

   IF N_ELEMENTS(lastx) LE 0 THEN lastx = -1
   IF N_ELEMENTS(lasty) LE 0 THEN lasty = -1

   saved_device = !D.NAME
   CASE STRUPCASE(!VERSION.OS_FAMILY) OF
      'WINDOWS': SET_PLOT, 'WIN'
      'MACOS': SET_PLOT, 'MAC'
      ELSE: SET_PLOT, 'X'
   ENDCASE
   WIDGET_CONTROL, wDraw, GET_VALUE=windex

   win_trace, xpos, ypos, windex, LASTX=lastx, LASTY=lasty, $
    XSIZE=xsize, YSIZE=ysize, ERASE_ONLY=erase, $
    ZOOM_FACTOR=zoom_factor

   SET_PLOT, saved_device
   return
END

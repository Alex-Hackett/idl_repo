;+
; $Id: x_draw_box.pro,v 1.1 2001/11/05 22:12:16 mccannwj Exp $
;
; NAME:
;     X_DRAW_BOX
;
; PURPOSE:
;     Draw a box on the graphical display
;
; CATEGORY:
;     ACS/Widgets
;
; CALLING SEQUENCE:
;     X_DRAW_BOX, wDraw, x0, y0, x1, y1
;
; INPUTS:
;     wDraw - (WIDGET) WIDGET_DRAW widget identifier
;     x0    - (INTEGER) initial x coordinate
;     y0    - (INTEGER) initial y coordinate
;     x1    - (INTEGER) final x coordinate
;     y1    - (INTEGER) final y coordinate
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
;     Requires win_draw_box
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;       Thu Jun 15 21:15:08 2000, William Jon McCann
;       <mccannwj@acs13.+ball.com>
;-
PRO x_draw_box, wDraw, x0, y0, x1, y1
   COMPILE_OPT IDL2, HIDDEN

   IF NOT WIDGET_INFO(wDraw,/VALID_ID) THEN BEGIN
      MESSAGE, 'Invalid widget identifier.', /CONT
      return
   ENDIF

   saved_device = !D.NAME
   CASE STRUPCASE(!VERSION.OS_FAMILY) OF
      'WINDOWS': SET_PLOT, 'WIN'
      'MACOS': SET_PLOT, 'MAC'
      ELSE: SET_PLOT, 'X'
   ENDCASE
   WIDGET_CONTROL, wDraw, GET_VALUE=windex

   win_draw_box, x0, y0, x1, y1, windex

   SET_PLOT, saved_device

   return
END 

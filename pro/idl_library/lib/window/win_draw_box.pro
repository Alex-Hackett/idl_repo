;+
; $Id: win_draw_box.pro,v 1.1 2001/11/05 22:16:03 mccannwj Exp $
;
; NAME:
;     WIN_DRAW_BOX
;
; PURPOSE:
;     Draw a box on the graphical display
;
; CATEGORY:
;     ACS/Windows
;
; CALLING SEQUENCE:
;     X_DRAW_BOX, x0, y0, x1, y1 [,windex]
;
; INPUTS:
;     x0    - (INTEGER) initial x coordinate
;     y0    - (INTEGER) initial y coordinate
;     x1    - (INTEGER) final x coordinate
;     y1    - (INTEGER) final y coordinate
;
; OPTIONAL INPUTS:
;     windex - window index on which to draw
;      
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;     writes to the screen
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
;       Fri Jun 16 14:40:38 2000, William Jon McCann
;       <mccannwj@acs13.+ball.com>
;-
PRO win_draw_box, x0, y0, x1, y1, windex

   IF N_PARAMS() LT 4 THEN BEGIN
      PRINT, 'usage: WIN_DRAW_BOX, x0, y0, x1, y1 [,windex]'
      return
   ENDIF 

   IF N_ELEMENTS(windex) THEN BEGIN
      saved_window = !D.WINDOW
      WSET, windex
   ENDIF
   
   DEVICE, GET_GRAPHICS=oldg, SET_GRAPHICS=6
   PLOTS, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], /DEVICE, COLOR=!D.N_COLORS-1
   DEVICE, SET_GRAPHICS=oldg
   IF N_ELEMENTS(windex) THEN WSET, saved_window
END

;+
; $Id: win_trace.pro,v 1.1 2001/11/05 22:16:03 mccannwj Exp $
;
; NAME:
;     WIN_TRACE
;
; PURPOSE:
;     Draw a cursor trace (crosshair) on the graphic device
;
; CATEGORY:
;     ACS/Windows
;
; CALLING SEQUENCE:
;     WIN_TRACE, x, y [, index, LASTX=lastx, LASTY=lasty, $
;                XSIZE=xsize, YSIZE=ysize, /ERASE_ONLY]
; 
; INPUTS:
;     x - (INTEGER) center x coordinate
;     y - (INTEGER) center y coordinate
;
; OPTIONAL INPUTS:
;     index - window index to draw to, defaults to the currently
;              active window
;      
; KEYWORD PARAMETERS:
;     ERASE - (BOOLEAN) set to only erase the previous trace specified
;              by LASTX, LASTY
;     LASTX - (INTEGER) the previous center x coordinate to erase
;     LASTY - (INTEGER) the previous center y coordinate to erase
;     XSIZE - (INTEGER) the x size of the display
;     YSIZE - (INTEGER) the y size of the display
;     ZOOM_FACTOR - (NUMBER) multiplicative factor from data to device
;             coordinates
; OUTPUTS:
;     Draws to graphic device
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
;       Fri Jun 16 16:56:06 2000, William Jon McCann
;       <mccannwj@acs13.+ball.com>
;-
PRO win_trace, xpos, ypos, windex, LASTX=lastx, LASTY=lasty, $
               XSIZE=xsize, YSIZE=ysize, ERASE_ONLY=erase, $
               ZOOM_FACTOR=zoom_factor

   IF N_ELEMENTS(xsize) LE 0 THEN xsize=!D.X_SIZE
   IF N_ELEMENTS(ysize) LE 0 THEN ysize=!D.Y_SIZE
   IF N_ELEMENTS(lastx) LE 0 THEN lastx = -1
   IF N_ELEMENTS(lasty) LE 0 THEN lasty = -1

   IF N_ELEMENTS(zoom_factor) LE 0 THEN zoom_factor = 1.0

   dxsize = (zoom_factor * xsize) < !D.X_SIZE
   dysize = (zoom_factor * ysize) < !D.Y_SIZE
   dlastx = (zoom_factor * lastx) < !D.X_SIZE
   dlasty = (zoom_factor * lasty) < !D.Y_SIZE

   IF N_ELEMENTS(windex) GT 0 THEN BEGIN
      saved_window = !D.WINDOW
      WSET, windex[0]
   ENDIF 

   IF KEYWORD_SET(erase) THEN BEGIN
      DEVICE, GET_GRAPHICS=oldg, SET_GRAPHICS=6
      IF lasty GE 0 THEN PLOTS, [0, dxsize-1], [dlasty, dlasty], $
       /DEVICE, COLOR=!D.N_COLORS-1
      IF dlastx GE 0 THEN PLOTS, [dlastx, dlastx], $
       [0, dysize], /DEVICE, COLOR=!D.N_COLORS-1
      DEVICE, SET_GRAPHICS=oldg
      GOTO, done
   ENDIF
   dxpos = (zoom_factor * xpos) < !D.X_SIZE
   dypos = (zoom_factor * ypos) < !D.Y_SIZE

   IF dypos NE dlasty THEN BEGIN
      DEVICE, GET_GRAPHICS=oldg, SET_GRAPHICS=6
      PLOTS, [0, dxsize-1], [dypos, dypos], /DEVICE, COLOR=!D.N_COLORS-1
      IF dlasty GE 0 THEN PLOTS, [0, dxsize-1], [dlasty, dlasty], $
       /DEVICE, COLOR = !D.N_COLORS-1
      DEVICE, SET_GRAPHICS=oldg
   ENDIF
 
   IF dxpos NE dlastx THEN BEGIN
      DEVICE, GET_GRAPHICS=oldg, SET_GRAPHICS=6
      PLOTS, [dxpos, dxpos], [0, dysize-1], /DEVICE, COLOR=!D.N_COLORS-1
      IF dlastx GE 0 THEN PLOTS, [dlastx, dlastx], $
       [0, dysize], /DEVICE, COLOR=!D.N_COLORS-1
      DEVICE, SET_GRAPHICS=oldg
   ENDIF 

done:
   IF N_ELEMENTS(windex) GT 0 THEN WSET, saved_window
END

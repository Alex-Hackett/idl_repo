;+
; $Id: x_select_box.pro,v 1.1 2001/11/05 22:12:16 mccannwj Exp $
;
; NAME:
;     X_SELECT_BOX
;
; PURPOSE:
;     Allow the user to interactively select a box on a draw widget.
;
; CATEGORY:
;     ACS/Widgets
;
; CALLING SEQUENCE:
;     region = X_SELECT_BOX( wDraw, x0, y0 [, /CORNERS, /KEEP, $
;                            STATUS=status, LIMIT_REGION=region] )
;
; INPUTS:
;     wDraw - (WIDGET) WIDGET_DRAW widget identifier
;     x0    - (INTEGER) initial x coordinate
;     y0    - (INTEGER) initial y coordinate
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:
;     CORNERS- (BOOLEAN) Set this keyword to return the box corner
;               coordinates in the form [x0,y0,x1,y1].  The default is
;               to return all the enclosed indices.
;     KEEP   - (BOOLEAN) Set this keyword to not erase the box
;     STATUS - (OUTPUT) Specify a named variable to get the exit status.
;               A non-zero exit status indicates an error.
;
; OUTPUTS:
;     region - A list of all the enclosed indices with the defined
;               box unless the /CORNERS keyword is set.
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
;       Thu Jun 15 21:17:05 2000, William Jon McCann
;       <mccannwj@acs13.+ball.com>
;-

FUNCTION x_select_box, wDraw, x0, y0, STATUS=exit_status, $
                       DEBUG=debug, KEEP=keep, CORNERS=corners, $
                       LIMIT_REGION=limit_region
   COMPILE_OPT IDL2, HIDDEN

   IF N_PARAMS() LT 1 THEN return, -1

   exit_status = 0b
   sEvent = WIDGET_EVENT( wDraw, BAD_ID=exit_status)

   IF exit_status GT 0 THEN BEGIN
      MESSAGE, 'Invalid widget identifier.', /CONT
      return, -1
   ENDIF

   saved_device = !D.NAME
   CASE STRUPCASE(!VERSION.OS_FAMILY) OF
      'WINDOWS': SET_PLOT, 'WIN'
      'MACOS': SET_PLOT, 'MAC'
      ELSE: SET_PLOT, 'X'
   ENDCASE
   WIDGET_CONTROL, wDraw, GET_VALUE=windex
   saved_window = !D.WINDOW
   WSET, windex

   sGeometry = WIDGET_INFO( wDraw, /GEOMETRY )
   draw_xsize = sGeometry.draw_xsize
   draw_ysize = sGeometry.draw_ysize

   IF N_ELEMENTS( x0 ) LE 0 THEN x0 = 0L
   IF N_ELEMENTS( y0 ) LE 0 THEN y0 = 0L

   lastx = -1L
   lasty = -1L
   
   IF N_ELEMENTS( limit_region ) EQ 4 THEN BEGIN
      limit_x0 = limit_region[0] > 0L < (draw_xsize-1)
      limit_y0 = limit_region[1] > 0L < (draw_ysize-1)
      limit_x1 = limit_region[2] > (limit_x0+1) < (draw_xsize-1)
      limit_y1 = limit_region[3] > (limit_y0+1) < (draw_ysize-1)
   ENDIF ELSE BEGIN
      limit_x0 = 0L
      limit_y0 = 0L
      limit_x1 = (draw_xsize-1)
      limit_y1 = (draw_ysize-1)
   ENDELSE

   x0 = x0 > limit_x0 < limit_x1
   y0 = y0 > limit_y0 < limit_y1

   WHILE sEvent.type NE 1 DO BEGIN

      thisx = sEvent.x > limit_x0 < limit_x1
      thisy = sEvent.y > limit_y0 < limit_y1

      IF (sGeometry.scr_xsize LT sGeometry.draw_xsize) OR $
       (sGeometry.scr_ysize LT sGeometry.draw_ysize) THEN BEGIN
                    ; only valid for scrollable widgets
         WIDGET_CONTROL, wDraw, GET_DRAW_VIEW=draw_view_corner
         dx = 0 & dy = 0
         IF thisx GT (draw_view_corner[0]+sGeometry.scr_xsize) THEN $
          dx = thisx - draw_view_corner[0] - sGeometry.scr_xsize + 50
         IF thisx LT draw_view_corner[0] THEN $
          dx = thisx - draw_view_corner[0]
         IF thisy GT (draw_view_corner[1]+sGeometry.scr_ysize) THEN $
          dy = thisy - draw_view_corner[1] - sGeometry.scr_ysize + 50
         IF thisy LT draw_view_corner[1] THEN $
          dy = thisy - draw_view_corner[1]

         IF (dx NE 0) OR (dy NE 0) THEN BEGIN
            draw_view_corner=[(draw_view_corner[0]+dx) > 0 < draw_xsize, $
                              (draw_view_corner[1]+dy) > 0 < draw_ysize ]
            WIDGET_CONTROL, wDraw, SET_DRAW_VIEW=draw_view_corner
         ENDIF 
      ENDIF 

      IF (ABS(thisx - x0) GT 1) AND (ABS(thisy - y0) GT 1) THEN BEGIN

         DEVICE, GET_GRAPHICS=oldg, SET_GRAPHICS=6

         IF thisx GT x0 THEN xoffset = 1 ELSE IF thisx LT x0 THEN $
          xoffset = -1 ELSE xoffset = 0
         IF lastx GT x0 THEN lxoffset = 1 ELSE IF lastx LT x0 THEN $
          lxoffset = -1 ELSE lxoffset = 0

         IF KEYWORD_SET( debug ) THEN BEGIN
            strDebug = STRING( FORMAT='("last: [",I0,",",I0,"] "," this: [",I0,",",I0,"] ")', lastx, lasty, thisx, thisy )
            PRINTF, -2, strDebug
         ENDIF
         
         IF (lastx GE 0) AND (lasty GE 0) THEN $
          PLOTS, [x0+lxoffset,lastx,lastx,x0,x0], $
          [y0,y0,lasty,lasty,y0], /DEVICE, COLOR=!D.N_COLORS-1
         
         PLOTS, [x0+xoffset,thisx,thisx,x0,x0], $
          [y0,y0,thisy,thisy,y0], /DEVICE, COLOR=!D.N_COLORS-1

         DEVICE, SET_GRAPHICS=oldg

         lastx = thisx
         lasty = thisy

      ENDIF 

      sEvent = WIDGET_EVENT(wDraw, BAD_ID=exit_status)
      
      IF exit_status GT 0 THEN BEGIN
         MESSAGE, 'Invalid widget identifier.', /CONT
         SET_PLOT, saved_device
         return, -1
      ENDIF

   ENDWHILE

   x1 = sEvent.x > limit_x0 < limit_x1
   y1 = sEvent.y > limit_y0 < limit_y1

   IF (x0 EQ x1) AND (y0 EQ y1) THEN return, 0

   IF NOT KEYWORD_SET( corners ) THEN BEGIN
      x_corners = [x0, x0, x1, x1 ]
      y_corners = [y0, y1, y1, y0 ]
      region = POLYFILLV( x_corners, y_corners, draw_xsize, draw_ysize )
   ENDIF ELSE BEGIN
      nx1 = x1
      nx0 = x0
      ny0 = y0
      ny1 = y1
      IF x1 LE x0 THEN BEGIN
         nx1=x0
         nx0=x1
      ENDIF
      IF y1 LE y0 THEN BEGIN
         ny1=y0
         ny0=y1
      ENDIF
      region = [nx0,ny0,nx1,ny1]
   ENDELSE

   WAIT, 0.5          ; for fast displays

   IF NOT KEYWORD_SET( keep ) THEN BEGIN
      IF KEYWORD_SET( debug ) THEN PRINTF, -2, 'Erase'

      DEVICE, GET_GRAPHICS=oldg, SET_GRAPHICS=6

      IF (lastx GE 0) AND (lasty GE 0) THEN $
       PLOTS, [x0+lxoffset,lastx,lastx,x0,x0], $
       [y0,y0,lasty,lasty,y0], /DEVICE, COLOR=!D.N_COLORS-1

      DEVICE, SET_GRAPHICS=oldg
   ENDIF

   SET_PLOT, saved_device
   WSET, saved_window

   return, region
END

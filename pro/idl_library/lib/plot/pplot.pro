;+
; $Id: pplot.pro,v 1.5 2001/11/05 21:43:08 mccannwj Exp $
;
; NAME:
;     PPLOT
;
; PURPOSE:
;     An interactive plot tool of sorts.
;
; CATEGORY:
;     plot
;
; CALLING SEQUENCE:
;     PPLOT, [xdata,] ydata
; 
; INPUTS:
;     xdata - independent variable array
;     ydata - dependent variable array
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     Any keyword allowed by the IDL PLOT routine plus the following:
;     
;     XSIZE     - (NUMERIC) horizontal size of plot window
;     YSIZE     - (NUMERIC) vertical size of plot window
;     XPOSITION - (NUMERIC) horizontal starting position of plot window
;                  on the display
;     YPOSITION - (NUMERIC) vertical starting position of plot window
;                  on the display
;     FILENAME  - (STRING) basename (ie. name without "dot" suffix) of
;                  hardcopy/ascii files
;     WTITLE    - (STRING) title to be displayed on the title bar of the widget
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;     Optionally creates a hardcopy of the plot window contents.
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
;       Fri Jun 25 12:54:49 1999, William Jon McCann <mccannwj@acs10>
;
;		written.
;
;-

;_____________________________________________________________________________

PRO pplot_exec, x, y, strExec
   retval = EXECUTE( strExec )
END 

;_____________________________________________________________________________

PRO write_ascii, strFilename, var1, var2

   IF N_PARAMS() NE 3 THEN BEGIN
      MESSAGE, 'usage: write_ascii, filename, var1, var2', /NONAME, /CONTINUE
      return
   ENDIF 

   n_lines = N_ELEMENTS( var1 )
   IF n_lines NE N_ELEMENTS( var2 ) THEN BEGIN
      MESSAGE, 'var1 and var2 must have same number of elements', $
       /NONAME, /CONTINUE
      return
   ENDIF 
   
   OPENW, lun, strFilename, /GET_LUN, ERROR=error_flag
   IF error_flag NE 0 THEN BEGIN
      MESSAGE, 'error opening file: '+!ERROR_STATE.SYS_MSG, /NONAME, /CONTINUE
      return
   ENDIF 

   var1_size = SIZE( var1 )
   var2_size = SIZE( var2 )
   var1_type = var1_size[ var1_size[0] + 1 ]
   var2_type = var2_size[ var2_size[0] + 1 ]

   CASE var1_type OF
      1: f_v1 = 'I'
      2: f_v1 = 'I'
      3: f_v1 = 'I'
      ELSE: f_v1 = 'D'
   ENDCASE

   CASE var2_type OF
      1: f_v2 = 'I'
      2: f_v2 = 'I'
      3: f_v2 = 'I'
      ELSE: f_v2 = 'D'
   ENDCASE
   
   strFormat = '('+f_v1+',1X,'+f_v2+')'
   FOR i=0l, n_lines-1 DO BEGIN
      PRINTF, lun, FORMAT=strFormat, var1[i], var2[i]
   ENDFOR 

   FREE_LUN, lun

   MESSAGE, 'Wrote '+strFilename, /INFO
   return
END 

;_____________________________________________________________________________

PRO pplot_draw_plot, sState

   sExtra = sState.plot_keywords

   IF sState.detail EQ 1 THEN BEGIN
                    ; check for [XY]RANGE keywords in _EXTRA

      IF N_TAGS( sExtra ) GT 0 THEN BEGIN
         tag_names = STRUPCASE(TAG_NAMES(sExtra))

         w_xr = WHERE( tag_names EQ 'XRANGE', xr_count )
         IF xr_count GT 0 THEN sExtra.xrange = sState.xrange $
         ELSE xrange=sState.xrange
         w_yr = WHERE( tag_names EQ 'YRANGE', yr_count )
         IF yr_count GT 0 THEN sExtra.yrange = sState.yrange $
         ELSE yrange=sState.yrange
         w_xs = WHERE( tag_names EQ 'XSTYLE', xs_count )
         IF xs_count GT 0 THEN sExtra.xstyle = 1 $
         ELSE xstyle=1
         w_ys = WHERE( tag_names EQ 'YSTYLE', ys_count )
         IF ys_count GT 0 THEN sExtra.ystyle = 1 $
         ELSE ystyle=1
      ENDIF

      PLOT, sState.xdata, sState.ydata, $
       XRANGE=xrange, YRANGE=yrange, $
       XSTYLE=xstyle, YSTYLE=ystyle, _EXTRA=sExtra
   ENDIF ELSE BEGIN
      PLOT, sState.xdata, sState.ydata, _EXTRA=sExtra
   ENDELSE

   return
END

;_____________________________________________________________________________

FUNCTION win_valid, windex
   
   saved_device = !D.NAME
   CASE STRUPCASE(!VERSION.OS_FAMILY) OF
      'WINDOWS': SET_PLOT, 'WIN'
      'MACOS': SET_PLOT, 'MAC'
      ELSE: SET_PLOT, 'X'
   ENDCASE
   DEVICE, WINDOW_STATE=windows
   SET_PLOT, saved_device

   IF N_ELEMENTS( windex ) LE 0 THEN return, 0
   IF windex LT 0 THEN return, 0
   IF N_ELEMENTS( windows ) LE windex THEN return, 0

   return, windows[windex]

END 
;_____________________________________________________________________________

FUNCTION pplot_select_box, wDraw, x0, y0, ERROR=error, $
                           DEBUG=debug, KEEP=keep, CORNERS=corners

   sEvent = WIDGET_EVENT( wDraw, BAD_ID=error)

   IF error GT 0 THEN BEGIN
      MESSAGE, 'Invalid widget identifier.', /CONTINUE
      return, -1
   ENDIF

   saved_device = !D.NAME
   CASE STRUPCASE(!VERSION.OS_FAMILY) OF
      'WINDOWS': SET_PLOT, 'WIN'
      'MACOS': SET_PLOT, 'MAC'
      ELSE: SET_PLOT, 'X'
   ENDCASE
   WIDGET_CONTROL, wDraw, GET_VALUE = windex
   saved_window = !D.WINDOW
   WSET, windex

   sGeometry = WIDGET_INFO( wDraw, /GEOMETRY )

   draw_xsize = sGeometry.scr_xsize
   draw_ysize = sGeometry.scr_ysize

   IF N_ELEMENTS( x0 ) LE 0 THEN x0 = 0L
   IF N_ELEMENTS( y0 ) LE 0 THEN y0 = 0L

   lastx = -1L
   lasty = -1L

   x0 = x0 > 0 < draw_xsize
   y0 = y0 > 0 < draw_ysize

   WHILE sEvent.type NE 1 DO BEGIN

      thisx = sEvent.x > 0L < (draw_xsize - 1)
      thisy = sEvent.y > 0L < (draw_ysize - 1)

      IF (ABS(thisx - x0) GT 1) AND (ABS(thisy - y0) GT 1) THEN BEGIN

         DEVICE, GET_GRAPHICS=oldg, SET_GRAPHICS=6

         IF thisx GT x0 THEN xoffset = 1 ELSE IF thisx LT x0 THEN $
          xoffset = -1 ELSE xoffset = 0
         IF lastx GT x0 THEN lxoffset = 1 ELSE IF lastx LT x0 THEN $
          lxoffset = -1 ELSE lxoffset = 0

;         IF KEYWORD_SET( debug ) THEN BEGIN
;            strDebug = STRING( FORMAT='("last: [",I0,",",I0,"] "," this: [",I0,",",I0,"] ")', lastx, lasty, thisx, thisy )
;            PRINTF, -2, strDebug
;         ENDIF
         
         IF (lastx GE 0) AND (lasty GE 0) THEN $
          PLOTS, [x0+lxoffset,lastx,lastx,x0,x0], $
          [y0,y0,lasty,lasty,y0], /DEVICE
         
         PLOTS, [x0+xoffset,thisx,thisx,x0,x0], $
          [y0,y0,thisy,thisy,y0], /DEVICE

         DEVICE, SET_GRAPHICS = oldg

         lastx = thisx
         lasty = thisy

      ENDIF 

      sEvent = WIDGET_EVENT( wDraw, BAD_ID = error)
      
      IF error GT 0 THEN BEGIN
         MESSAGE, 'Invalid widget identifier.', /CONTINUE
         SET_PLOT, saved_device
         return, -1
      ENDIF

   ENDWHILE

   x1 = sEvent.x > 0 < (draw_xsize - 1)
   y1 = sEvent.y > 0 < (draw_ysize - 1)

   IF (x0 EQ x1) AND (y0 EQ y1) THEN return, 0

   x_corners = [x0, x0, x1, x1 ]
   y_corners = [y0, y1, y1, y0 ]

   IF NOT KEYWORD_SET( corners ) THEN $
    region = POLYFILLV( x_corners, y_corners, imagex_sz, imagey_sz ) $
   ELSE region = [x0,y0,x1,y1]

   WAIT, 0.5          ; for fast displays

   IF NOT KEYWORD_SET( keep ) THEN BEGIN
      IF KEYWORD_SET( debug ) THEN PRINTF, -2, 'Erase'

      DEVICE, GET_GRAPHICS = oldg, SET_GRAPHICS = 6

      IF (lastx GE 0) AND (lasty GE 0) THEN $
       PLOTS, [x0+lxoffset,lastx,lastx,x0,x0], $
       [y0,y0,lasty,lasty,y0], /DEVICE

      DEVICE, SET_GRAPHICS=oldg
   ENDIF

   SET_PLOT, saved_device
   WSET, saved_window

   return, region
END

;_____________________________________________________________________________

PRO pplot_define_region, sState, x0, y0

   save_win = !D.WINDOW
   IF win_valid( sState.draw_index ) THEN WSET, sState.draw_index $
   ELSE MESSAGE, 'Invalid window selection.'

   box = pplot_select_box( sState.wDraw, x0, y0, /CORNERS, /KEEP )

   IF N_ELEMENTS( box ) GT 1 THEN BEGIN
      ; save box coords
      data_coord1 = CONVERT_COORD( box[0], box[1], /DEVICE, /TO_DATA )
      data_coord2 = CONVERT_COORD( box[2], box[3], /DEVICE, /TO_DATA )

      IF data_coord1[0] LE data_coord2[0] THEN $
       sState.xrange = DOUBLE( [data_coord1[0],data_coord2[0]] ) $
      ELSE sState.xrange = DOUBLE( [data_coord2[0],data_coord1[0]] )
      IF data_coord1[1] LE data_coord2[1] THEN $
       sState.yrange = DOUBLE( [data_coord1[1],data_coord2[1]] ) $
      ELSE sState.yrange = DOUBLE( [data_coord2[1],data_coord1[1]] )
   ENDIF

   IF win_valid( save_win ) THEN WSET, save_win

   WIDGET_CONTROL, sState.wRoot, /CLEAR_EVENTS

END

;_____________________________________________________________________________

PRO pplot_event, sEvent

   wStateHandler = WIDGET_INFO( sEvent.handler, /CHILD )
   WIDGET_CONTROL, wStateHandler, GET_UVALUE=sState, /NO_COPY

   struct_name = TAG_NAMES( sEvent, /STRUCTURE_NAME)

   CASE STRUPCASE( struct_name ) OF
      'WIDGET_BASE': BEGIN
         screen_size = GET_SCREEN_SIZE()
         newx = (sEvent.x-10) < (screen_size[0]-30)
         newy = (sEvent.y-10) < (screen_size[1]-30)
         
         WIDGET_CONTROL, sState.wDraw, XSIZE = newx, YSIZE = newy
         saved_window = !D.WINDOW
         WSET, sState.draw_index
         pplot_draw_plot, sState
         IF win_valid(saved_window) THEN WSET, saved_window
      END
      'WIDGET_KBRD_FOCUS': BEGIN
         IF sEvent.enter EQ 1 THEN BEGIN
            saved_window = !D.WINDOW
            WSET, sState.draw_index
            pplot_draw_plot, sState
            IF win_valid(saved_window) THEN WSET, saved_window
         ENDIF 
      END 
      ELSE: BEGIN

         WIDGET_CONTROL, sEvent.id, GET_UVALUE = event_uval

         CASE STRUPCASE( event_uval ) OF

            'PLOT_DRAW': BEGIN
               saved_window = !D.WINDOW
               WSET, sState.draw_index
               data_coord = CONVERT_COORD( sEvent.x, sEvent.y, $
                                           /DEVICE, /TO_DATA )
               strOut = STRING( FORMAT='(A,5X,"[",F9.3,",",F9.3,"]")', $
                                sState.title, data_coord[0], data_coord[1] )
               WIDGET_CONTROL, sState.wBase, TLB_SET_TITLE=strOut[0]
               IF win_valid(saved_window) THEN WSET, saved_window
               CASE sEvent.type OF
                  0: BEGIN
                    ; BUTTON PRESS

                     sState.button_down_x = LONG( sEvent.x )
                     sState.button_down_y = LONG( sEvent.y )
                     CASE sEvent.press OF
                        1: sState.button_down = sState.button_down + 1b
                        2: sState.button_down = sState.button_down + 2b
                        4: sState.button_down = sState.button_down + 4b
                        ELSE:
                     ENDCASE
                  END

                  1: BEGIN
                    ; BUTTON RELEASE
                     sState.button_down_x = -1L
                     sState.button_down_y = -1L
                     CASE sEvent.release OF
                        1: sState.button_down = (sState.button_down - 1b) > 0
                        2: sState.button_down = (sState.button_down - 2b) > 0
                        4: sState.button_down = (sState.button_down - 4b) > 0
                        ELSE:
                     ENDCASE
                  END

                  2: BEGIN
                    ; MOTION EVENT

                     CASE sState.button_down OF
                        1: BEGIN
                    ; Define a region
                           IF sState.button_down_x GE 0 THEN BEGIN
                              pplot_define_region, sState, sEvent.x, sEvent.y
                              sState.detail = 1b
                              pplot_draw_plot, sState
                              sState.button_down = (sState.button_down - 1b)>0
                           ENDIF 
                        END
                        ELSE:
                     ENDCASE
                  END
                  ELSE: 
               ENDCASE 
            END 

            'BUTTON_PRESS': BEGIN
               sState.button_down = 0b ; reset the button down flag
               CASE STRUPCASE( sEvent.value ) OF

                  'DISMISS_BUTTON': BEGIN
                     WIDGET_CONTROL, sEvent.top, /DESTROY
                  END 

                  'REDRAW_BUTTON': BEGIN
                     saved_window = !D.WINDOW
                     WSET, sState.draw_index
                     sState.detail = 0b
                     pplot_draw_plot, sState
                     IF win_valid(saved_window) THEN WSET, saved_window
                  END

                  'ASCII_BUTTON': BEGIN
                     write_ascii, sState.filename+'.txt', $
                      sState.xdata, sState.ydata
                  END 

                  'HARDCOPY_BUTTON': BEGIN
                     saved_device = !D.NAME
                     SET_PLOT, 'PS'
                     tempdir = GETENV('IDL_TMPDIR')
                     strPSfile = STRING(FORMAT='(A,A,".ps")', tempdir, $
                                        sState.filename)
                     DEVICE, FILENAME=strPSfile, /LANDSCAPE
                     pplot_draw_plot, sState
                     DEVICE, /CLOSE
                     SET_PLOT, saved_device
                     PRINT, 'Wrote '+strPSfile
                     IF STRUPCASE(!VERSION.OS_FAMILY) EQ 'UNIX' THEN BEGIN
                        strCmd = 'lp ' + strPSfile
                        SPAWN, strCmd
                     ENDIF
                  END 

                  ELSE:
               ENDCASE
            END 

            ELSE:
         ENDCASE
      END
   ENDCASE

   IF WIDGET_INFO( wStateHandler, /VALID_ID ) EQ 1 THEN BEGIN
      WIDGET_CONTROL, wStateHandler, SET_UVALUE=sState, /NO_COPY
   ENDIF

END

; _____________________________________________________________________________

PRO pplot, xinput, yinput, GROUP_LEADER=group_leader, $
           XSIZE=xsize, YSIZE=ysize, $
           WTITLE=strTitle, $
           XPOSITION=xposition, YPOSITION=yposition, _EXTRA=extra, $
           FILENAME=strFilename

   IF N_PARAMS() LT 1 THEN BEGIN
      MESSAGE, 'usage: PPLOT, [xdata,] ydata', /NONAME, /CONT
      return
   ENDIF
   IF N_PARAMS() EQ 1 THEN BEGIN
      ydata = xinput
      xdata = LINDGEN(N_ELEMENTS(ydata))
   ENDIF ELSE BEGIN
      xdata = xinput
      ydata = yinput
   ENDELSE

   xrange = DOUBLE( [MIN(xdata),MAX(xdata)] )
   yrange = DOUBLE( [MIN(ydata),MAX(ydata)] )

   IF N_ELEMENTS( strFilename ) LE 0 THEN strFilename = 'pplot'

   screen_size = GET_SCREEN_SIZE()
   IF N_ELEMENTS( xsize ) LE 0 THEN xsize = screen_size[0]/3
   IF N_ELEMENTS( ysize ) LE 0 THEN ysize = screen_size[1]/3

   IF N_ELEMENTS( strTitle ) LE 0 THEN strTitle = 'IDL'

   IF N_ELEMENTS( extra ) LE 0 THEN extra = { XTITLE: 'x', YTITLE: 'y' }

   IF (N_ELEMENTS(xposition) GT 0) THEN $
    xposition = xposition[0] $
   ELSE xposition = screen_size[0] / 3
   IF (N_ELEMENTS(yposition) GT 0) THEN $
    yposition = yposition[0] $
   ELSE yposition = screen_size[1] / 3

   wRoot = WIDGET_BASE(GROUP_LEADER=group_leader, /COLUMN, $
                       TITLE=strTitle, $
                       UVALUE='ROOT', $
                       /KBRD_FOCUS_EVENTS, $
                       /TLB_SIZE_EVENTS, XPAD=0, YPAD=0)
   
   wBase = WIDGET_BASE(wRoot, /COLUMN, /ALIGN_CENTER, XPAD=0, YPAD=0)

   wPlotBase = WIDGET_BASE(wBase, /COLUMN, XPAD=0, YPAD=0)
   wPlotDraw = WIDGET_DRAW(wPlotBase, XSIZE=xsize, YSIZE=ysize, $
                           /MOTION_EVENTS, /BUTTON_EVENTS, $
                           UVALUE='PLOT_DRAW', COLORS=-2, RETAIN=2)
   
   aButtons = [ 'Hardcopy', 'ASCII file', 'Redraw', 'Dismiss' ]
   aButtonUvals = [ 'HARDCOPY_BUTTON', 'ASCII_BUTTON', $
                    'REDRAW_BUTTON', 'DISMISS_BUTTON' ]
   wButtons = CW_BGROUP( wBase, aButtons, FONT='helvetica*12', $
                         BUTTON_UVALUE = aButtonUvals, $
                         /ROW, /NO_RELEASE, UVALUE='BUTTON_PRESS' )

   WIDGET_CONTROL, /REALIZE, wRoot
   WIDGET_CONTROL, wRoot, TLB_SET_XOFFSET=xposition, TLB_SET_YOFFSET=yposition
   WIDGET_CONTROL, GET_VALUE=draw_index, wPlotDraw
   CASE STRUPCASE(!VERSION.OS_FAMILY) OF
      'WINDOWS': gdevice = 'WIN'
      'MACOS': gdevice = 'MAC'
      ELSE: gdevice = 'X'
   ENDCASE
   SET_PLOT, gdevice
   WSHOW, draw_index

   sState = { wRoot: wRoot, $
              wBase: wBase, $
              wDraw: wPlotDraw, $
              wButtons: wButtons, $
              draw_index: draw_index, $
              xdata: xdata, $
              ydata: ydata, $
              xrange: xrange, $
              yrange: yrange, $
              button_down: 0b, $
              button_down_x: -1L, $
              button_down_y: -1L, $
              detail: 0b, $
              plot_keywords: extra, $
              filename: strFilename, $
              title: strTitle $
            }

   saved_window = !D.WINDOW
   WSET, sState.draw_index
   pplot_draw_plot, sState
   IF win_valid(saved_window) THEN WSET, saved_window

   WIDGET_CONTROL, wBase, SET_UVALUE=sState, /NO_COPY

   XMANAGER, 'pplot', wRoot, /NO_BLOCK
   
END

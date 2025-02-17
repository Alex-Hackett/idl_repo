; -----------------------------------------------------------------------------
;
;  Copyright (C) 2007-2008   J. P. Leahy
;
;
;  This file is part of Ximview and of HEALPix
;
;  Ximview and HEALPix are free software; you can redistribute them and/or modify
;  them under the terms of the GNU General Public License as published by
;  the Free Software Foundation; either version 2 of the License, or
;  (at your option) any later version.
;
;  Ximview and HEALPix are distributed in the hope that they will be useful,
;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;  GNU General Public License for more details.
;
;  You should have received a copy of the GNU General Public License
;  along with HEALPix; if not, write to the Free Software
;  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
;
;
; -----------------------------------------------------------------------------
; This is the initialisation routine for the gscroll subroutine package.
;
PRO gscroll_setup, nscreen, maxwin, ierr, PANEL_SIZE=panel_size, $
                   WINDOW = window, IMAGE = image, LUT = lut, $
                   REDRAW = redraw_in, HIDDEN = hidden
;
; J. P. Leahy 2008
;
; Sets up pixmap windows and common block. Many common block
; parameters are filled in later, by new_zoom, on first call to gscroll.
;
; Inputs:
;     nscreen:     Number of screens to allocate
;     panel_size:  Specify to get the panel size you want (must be an
;                  integer multiple of the zooms you plan to use.)
;                  Don't set unless necessary, default panel size
;                  (128x128) is quite good.
;     window:      Window index (or array of..) to use for visible
;                  window. If not set, creates a new one.
;     image:       array of pointers to byte-scaled image for each
;                  window
;     lut:         Optional array of pointers to LUT structures, one for
;                  each window
;     redraw_in:   True if we should update LUT before loading
;     hidden:      Only update active window, others are hidden
; Outputs
;     maxwin:      2-element array containing maximum size of the
;                  view window (in pixels).
;     ierr:        Non-zero value returned on error
;
; Changes:
;   Original version Nov 2007-Jan 2008
;   Version 2: Handles multiple screens: Feb 2008
;
COMPILE_OPT IDL2, HIDDEN

COMMON GRID_GSCROLL, started, $ ; control parameter
  xcen, ycen, $                 ; coords of FOV centre on pixmap
  old_zoomf, $                  ; last zoom factor set
  do_wrap, $                    ; true if wrapping at edge of map enabled
  top_only, $                   ; Only copy to current "active" viewwin
  rotation, $                   ; current rotation of view in focus panel
  xpanel, ypanel, $             ; size of pixmap/view window panels in pixels
  nx, ny, $                     ; number of panels on pixmap
  xwidth, ywidth, $             ; size of pixmap in pixels
  xp_image, yp_image, $         ; size of image panels in pixels
  nx_in, ny_in, $               ; number of panels on image (including border)
  nx_border, ny_border, $       ; number of border panels at each edge of image
  virtual_panel, $              ; index from virtual to pixmap panel coords
  focus, $                      ; 1-D virtual coord of focus panel
  blankwin, $                   ; window index for "blank" pixmap
  old_device, old_decomposed, old_window, $ ; previous graphics state
  redraw, $                     ; Need to update LUT before loading
  screens, $                    ; array of structures for each view window
  image_panel                   ; array of structures for each image panel

retain = 2
started = 0

; Parameters controlling display and panel sizes:
xpanel = 128L & ypanel = 128L
view_x = 512L & view_y = 512L
min_size = 50

IF N_PARAMS() LT 3 THEN BEGIN
    PRINT, 'Syntax:'
    PRINT, 'gscroll_setup, nscreen, maxwin, ierr, $'
    PRINT, '              [WINDOW=, IMAGE=, HIDDEN=, PANEL_SIZE=]'
    RETURN
ENDIF

IF nscreen LT 0 THEN MESSAGE, 'Request at least one screen'
nwind = N_ELEMENTS(window)
window_set = nwind GT 0
IF window_set THEN IF nwind NE nscreen THEN $
  MESSAGE, 'Supply window index for each screen requested'
nimage = N_ELEMENTS(image)
IF nimage NE nscreen THEN MESSAGE, $
  'Supply pointer to byte image for each screen requested'
nlut = N_ELEMENTS(lut)
lut_set = nlut GT 0

top_only = KEYWORD_SET(hidden)
redraw = KEYWORD_SET(redraw_in)

; Check to see if a specific panel size is requested, and if so if meaningful
np = N_ELEMENTS(panel_size)
IF np GT 0 THEN BEGIN
    IF np GT 2 || MIN(panel_size) LT min_size THEN BEGIN
        PRINT, 'GSCROLL_SETUP: PANEL should have <= 2 values, all >=', min_size
        ierr = 1
        GOTO, QUIT
    ENDIF
    IF np EQ 1 THEN panel_size = REPLICATE(panel_size,2)
    xpanel = panel_size[0] & ypanel = panel_size[1]
ENDIF

old_window = !D.window
old_device = !D.name
IF old_device NE 'X' && old_device NE 'WIN' THEN BEGIN
    ; Switch to windows
    system = STRUPCASE(!VERSION.os_family)
    SET_PLOT, STRCMP(system,'WINDOW',6) ? 'WIN' : 'X'
ENDIF 
IF window_set THEN BEGIN
    viewwin = window[0] 
    old_window = viewwin
ENDIF ELSE BEGIN
    DEVICE, RETAIN = retain
    WINDOW, /FREE, TITLE='GSCROLL 0', XSIZE=view_x, YSIZE=view_y
    viewwin = !D.window
ENDELSE
DEVICE, GET_DECOMPOSED = old_decomposed
DEVICE, DECOMPOSED = 0

DEVICE, GET_SCREEN_SIZE=screen
nx = divup(screen[0],xpanel)
ny = divup(screen[1],ypanel)

DEVICE, RETAIN = 0

CATCH, window_error
IF window_error NE 0 THEN BEGIN
                        ; Try one size smaller:
    nx -= 1 & ny -= 1
    IF nx LT 1 OR ny LT 1 THEN BEGIN
        CATCH,/CANCEL
        MESSAGE, "Cannot make pixmap of any size!"
    ENDIF
ENDIF

WINDOW, /FREE, XSIZE=nx*xpanel, YSIZE=ny*ypanel, /PIXMAP
pixwin = !D.window
; Check that worked:
IF (!D.x_vsize NE nx*xpanel || !D.y_vsize NE ny*ypanel) THEN $
  MESSAGE, "Cannot make pixmap larger than screen", /NOPRINT

CATCH, /CANCEL

started = 1 ; now we have something that might need tidying...

xwidth = nx*xpanel
ywidth = ny*ypanel

; Max size allowed is two panels less than the size of the pixmap:
maxwin = [xwidth - 2*xpanel, ywidth - 2*ypanel]

; Set up window for filling in blank spaces around the edge
WINDOW, /FREE, XSIZE=xpanel, YSIZE=ypanel, /PIXMAP
ERASE ; Fills window with !P.background
blankwin = !D.window


; Restore view window as current window:
WSET, viewwin

; Define structures for index data
pp = CREATE_STRUCT("idx", -1L, "xc", -1, "yc", -1, "rot", 0B)
ip = CREATE_STRUCT("x0", -1L, "x1", 0L, "y0", 0L, "y1", 0L, "dummy", 0B, $
                   "wrap",-1L, "wrap_rot", 0B)

; Placeholder for image_panel until we work out how this is divided up
image_panel   = ip
pixmap_panel  = REPLICATE(pp,nx,ny)
virtual_panel = REPLICATE(-1,nx,ny)

; Fill in corner coords of each panel in pixmap_panel
xcorn = LINDGEN(nx)*xpanel
FOR j=0,ny-1 DO BEGIN
    pixmap_panel[*,j].xc = xcorn
    pixmap_panel[*,j].yc = j*ypanel
ENDFOR
xcorn = 0

focus2 = [nx/2, ny/2]    ; define this panel as the "central" one.
focus = focus2[0] + focus2[1]*nx   

rotation = 0
old_zoomf = -1000 ; silly number

; Define structures for the screen
IF ~lut_set THEN BEGIN
    col = BYTARR(256)
    lut = PTR_NEW({r: col, g: col, b: col, line: 0B, absent: 0B})
ENDIF

screen0 = CREATE_STRUCT("pixwin", pixwin, "viewwin", viewwin, $
                        "pixmap_panel", pixmap_panel, "imptr", image[0], $
                        'rgb', REPLICATE(PTR_NEW(), 3), 'lut', lut[0], $
                        'lut_set', lut_set, 'is_rgb', 0B, "started", 1B)

screens = REPLICATE(screen0, nscreen)

DEVICE, RETAIN = retain

IF nscreen GT 1 THEN FOR i=1,nscreen-1 DO BEGIN
    screens[i].IMPTR = image[i]
    screens[i].LUT  = lut_set ? lut[i] : lut
    IF window_set THEN screens[i].viewwin = window[i] ELSE BEGIN
        title = STRING(i, FORMAT = "('GSCROLL',I2)")
        WINDOW, /FREE, TITLE=title, XSIZE=view_x, YSIZE=view_y
        screens[i].viewwin = !D.window
    ENDELSE
    WINDOW, /FREE, XSIZE=xwidth, YSIZE=ywidth, /PIXMAP
    screens[i].pixwin = !D.window
    screens[i].started = 1
ENDFOR

RETURN

QUIT:

END


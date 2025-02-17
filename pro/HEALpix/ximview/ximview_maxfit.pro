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
; Module XIMVIEW_MAXFIT
;
; J. P. Leahy February 2008
;
; Contains the event handlers that control calling of the MAXFIT routine.
;
PRO ximview_maxfit, event
;
; Widget front end for maxfit.
;
COMPILE_OPT IDL2, HIDDEN
ON_ERROR, 1

tagname = TAG_NAMES(event,/STRUCTURE_NAME)
WIDGET_CONTROL, event.TOP,   GET_UVALUE = state

ximview_resize, event.TOP, state

tagname = STRMID(tagname,0,12)
CASE tagname OF
    'WIDGET_BUTTO' : BEGIN
; Fit peak
        WIDGET_CONTROL, state.TABS,  GET_UVALUE = mode
        IF mode.XPT LT 0 THEN BEGIN
            MESSAGE, /INFORMATIONAL, $
              'Mark centre with middle mouse button first!'
            RETURN
        ENDIF
        log = state.LOGLUN  &  peak = state.PEAK
        astrom = state.IS_ASTROM ? *state.ASTROM : 0

        tabarr = state.TABARR
        str = (*tabarr)[0]
        im_ptr = str.IM_PTR  &  unit = str.UNIT
        xpt = FIX(mode.XPT)  &  ypt = FIX(mode.YPT)

        IF str.SCREEN NE state.LASTTAB THEN BEGIN
            WIDGET_CONTROL, str.BASE, GET_UVALUE = tname
            tname = 'Now on tab: ' + tname
            PRINT, tname
            PRINTF, log, tname
            state.LASTTAB = str.SCREEN
            WIDGET_CONTROL, event.TOP, SET_UVALUE = state
        ENDIF

        IF ~im_ptr THEN BEGIN
            WIDGET_CONTROL, state.LABEL, GET_UVALUE = image, /NO_COPY
            coord = maxfit(image, xpt, ypt, state.MAXBOX, ASTROM = astrom, $
                           LUN = log, UNIT = unit, EXTREMUM = peak)
            WIDGET_CONTROL, state.LABEL, SET_UVALUE = image, /NO_COPY
        ENDIF ELSE $
          coord = maxfit(*im_ptr, xpt, ypt, state.MAXBOX, ASTROM = astrom, $
                         LUN = log,  UNIT = unit, EXTREMUM = peak)

        mode.XPT = coord[0]  &  mode.YPT = coord[1]
        WIDGET_CONTROL, state.TABS,  SET_UVALUE = mode

;  Mark point with accurate position:
        IF ~mode.OVERVIEW THEN $
          marker, mode.XPT, mode.YPT, mode.X_CENTRE, mode.Y_CENTRE, $
                  mode.XHALF, mode.YHALF, mode.ZOOM, mode.ZFAC
    END
    ELSE: MESSAGE, 'Unrecognised event type: ' + tagname_full
ENDCASE

END

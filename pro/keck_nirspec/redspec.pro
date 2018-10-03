;;; REDSPEC, a GUI software package for reduction of spectrum data.
;;; Sungsoo S. Kim, UCLA Astronomy
;;; version 1.0 -- October, 2000
;;; version 2.0 -- December, 2000
;;; version 2.5 -- February, 2001
;;;
;;; A graphic interface routine that drives 'pipe.pro'.


;===============================================================================
PRO redspec_event, event

;;; Control widget events.

COMPILE_OPT idl2, hidden
COMMON redspeccom, cal, calflat, calfixpix, calfringe, calrmline, calbb, $
    tarflat, tarfixpix, tarfringe, no_caldata, no_calflat, no_calfixpix, $
    no_calfringe, no_calrmline, no_calbb, no_tarflat, no_tarfixpix, $
    no_tarfringe, check_sat, save_intermediate, use_interpol

WIDGET_CONTROL, event.id, GET_UVALUE = eventval

CASE eventval OF

"START": BEGIN
  WIDGET_CONTROL, event.top, /DESTROY
END

"CHECKSAT": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value
  check_sat=value
END

"INTERMEDIATE": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value
  save_intermediate=1-value
END

"INTERPOL": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value
  use_interpol=value
END

"CAL": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value
  no_caldata = 1-value
  if (no_caldata eq 1) then begin
    no_calflat = 1
    no_calfixpix = 1
    no_calfringe = 1
    no_calrmline = 1
    no_calbb = 1
    WIDGET_CONTROL, calflat, SET_VALUE = 0
    WIDGET_CONTROL, calfixpix, SET_VALUE = 0
    WIDGET_CONTROL, calfringe, SET_VALUE = 0
    WIDGET_CONTROL, calrmline, SET_VALUE = 0
    WIDGET_CONTROL, calbb, SET_VALUE = 0
  endif
END

"CALFLAT": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value
  if (no_caldata eq 1) then begin
    WIDGET_CONTROL, event.id, SET_VALUE = 0
  endif else begin
    no_calflat = 1-value
  endelse
END

"CALFIXPIX": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value
  if (no_caldata eq 1) then begin
    WIDGET_CONTROL, event.id, SET_VALUE = 0
  endif else begin
    no_calfixpix = 1-value
  endelse
END

"CALFRINGE": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value
  if (no_caldata eq 1) then begin
    WIDGET_CONTROL, event.id, SET_VALUE = 0
  endif else begin
    no_calfringe = 1-value
  endelse
END

"CALRMLINE": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value
  if (no_caldata eq 1) then begin
    WIDGET_CONTROL, event.id, SET_VALUE = 0
  endif else begin
    no_calrmline = 1-value
  endelse
END

"CALBB": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value
  if (no_caldata eq 1) then begin
    WIDGET_CONTROL, event.id, SET_VALUE = 0
  endif else begin
    no_calbb = 1-value
  endelse
END

"TAR": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value
  WIDGET_CONTROL, event.id, SET_VALUE = 1
END

"TARFLAT": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value
  no_tarflat = 1-value
END

"TARFIXPIX": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value
  no_tarfixpix = 1-value
END

"TARFRINGE": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value
  no_tarfringe = 1-value
END

ELSE:

ENDCASE

END


;===============================================================================
PRO redspec, low=low, vertical=vertical

;;; Prepare parameters and widgets.
;;;
;;; low		: flag for low resolution data
;;; vertical	: flag for vertically running spectrum (low resolution for
;;;		      NIRSPEC)

COMPILE_OPT idl2, hidden
COMMON redspeccom, cal, calflat, calfixpix, calfringe, calrmline, calbb, $
    tarflat, tarfixpix, tarfringe, no_caldata, no_calflat, no_calfixpix, $
    no_calfringe, no_calrmline, no_calbb, no_tarflat, no_tarfixpix, $
    no_tarfringe, check_sat, save_intermediate, use_interpol

check_sat=1
no_caldata=0
no_calflat=0
no_calfixpix=0
no_calfringe=0
no_calrmline=0
no_calfixpix=0
no_calbb=0
no_tarflat=0
no_tarfixpix=0
no_tarfringe=0
save_intermediate=0
use_interpol=1
spacestr='    '

if (n_elements(low) eq 0) then low=0
if (n_elements(vertical) eq 0) then vertical=0

;;; Prepare widgets.
redspecbase = WIDGET_BASE(TITLE = "REDSPEC", /COLUMN)

topbase = WIDGET_BASE(redspecbase, /ROW)
startbutton = WIDGET_BUTTON(topbase, VALUE=' Start ', UVALUE='START')

vspace = WIDGET_LABEL(redspecbase, VALUE=' ')

checksat = CW_BGROUP(redspecbase, 'Check Saturation', $
		SET_VALUE=check_sat, UVALUE='CHECKSAT', /NONEXCLUSIVE)
;intermediate = CW_BGROUP(redspecbase, 'Do Not Save Intermediate Data', $
;		SET_VALUE=1-save_intermediate, UVALUE='INTERMEDIATE', $
;		/NONEXCLUSIVE)
interpol = CW_BGROUP(redspecbase, 'Use Interpolation for Rectification', $
		SET_VALUE=use_interpol, UVALUE='INTERPOL', /NONEXCLUSIVE)

vspace = WIDGET_LABEL(redspecbase, VALUE=' ')

calbase = WIDGET_BASE(redspecbase, /COLUMN, FRAME=4)
cal = CW_BGROUP(calbase, 'C A L I B R A T O R', $
		SET_VALUE=1-no_caldata, UVALUE='CAL', /NONEXCLUSIVE)
cal1 = WIDGET_BASE(calbase, /ROW)
space = WIDGET_LABEL(cal1, VALUE=spacestr)
calflat = CW_BGROUP(cal1, 'Divide by Dark-Subtracted Flat', $
		SET_VALUE=1-no_calflat, UVALUE='CALFLAT', /NONEXCLUSIVE)
cal2 = WIDGET_BASE(calbase, /ROW)
space = WIDGET_LABEL(cal2, VALUE=spacestr)
calfixpix = CW_BGROUP(cal2, 'Remove Bad Pixels', $
		SET_VALUE=1-no_calfixpix, UVALUE='CALFIXPIX', /NONEXCLUSIVE)
cal3 = WIDGET_BASE(calbase, /ROW)
space = WIDGET_LABEL(cal3, VALUE=spacestr)
calfringe = CW_BGROUP(cal3, 'Remove Fringing', $
		SET_VALUE=1-no_calfringe, UVALUE='CALFRINGE', /NONEXCLUSIVE)
cal4 = WIDGET_BASE(calbase, /ROW)
space = WIDGET_LABEL(cal4, VALUE=spacestr)
calrmline = CW_BGROUP(cal4, 'Remove Intrinsic Calibrator Features', $
		SET_VALUE=1-no_calrmline, UVALUE='CALRMLINE', /NONEXCLUSIVE)
cal5 = WIDGET_BASE(calbase, /ROW)
space = WIDGET_LABEL(cal5, VALUE=spacestr)
calbb = CW_BGROUP(cal5, 'Divide by Planck Curve', $
		SET_VALUE=1-no_calbb, UVALUE='CALBB', /NONEXCLUSIVE)

vspace = WIDGET_LABEL(redspecbase, VALUE=' ')

tarbase = WIDGET_BASE(redspecbase, /COLUMN, FRAME=4)
tar = CW_BGROUP(tarbase, 'T A R G E T', $
		SET_VALUE=1, UVALUE='TAR', /NONEXCLUSIVE)
tar1 = WIDGET_BASE(tarbase, /ROW)
space = WIDGET_LABEL(tar1, VALUE=spacestr)
tarflat = CW_BGROUP(tar1, 'Divide by Dark-Subtracted Flat', $
		SET_VALUE=1-no_tarflat, UVALUE='TARFLAT', /NONEXCLUSIVE)
tar2 = WIDGET_BASE(tarbase, /ROW)
space = WIDGET_LABEL(tar2, VALUE=spacestr)
tarfixpix = CW_BGROUP(tar2, 'Remove Bad Pixels', $
		SET_VALUE=1-no_tarfixpix, UVALUE='TARFIXPIX', /NONEXCLUSIVE)
tar3 = WIDGET_BASE(tarbase, /ROW)
space = WIDGET_LABEL(tar3, VALUE=spacestr)
tarfringe = CW_BGROUP(tar3, 'Remove Fringing', $
		SET_VALUE=1-no_tarfringe, UVALUE='TARFRINGE', /NONEXCLUSIVE)

WIDGET_CONTROL, redspecbase, /REALIZE
 
XManager, "redspec", redspecbase

pipe, low=low, vertical=vertical, no_caldata=no_caldata, $
    no_calflat=no_calflat, no_calfixpix, no_calfringe=no_calfringe, $
    no_calrmline=no_calrmline, no_calbb=no_calbb, no_tarflat=no_tarflat, $
    no_tarfixpix, no_tarfringe=no_tarfringe, check_sat=check_sat, $
    save_intermediate=save_intermediate, use_interpol=use_interpol

END

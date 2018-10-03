;-------------------------------------------------------------
;+
; NAME:
;       XGETVALS
; PURPOSE:
;       General widget to get values.
; CATEGORY:
; CALLING SEQUENCE:
;       xgetvals
; INPUTS:
; KEYWORD PARAMETERS:
;       Keywords:
;         TITLE=txt Title string or string array (Def="Enter values:").
;         LABELS=lab Array of labels for each value to enter.
;           Each label is an element of a string array and has the text
;           for an item to enter.  A field size may also be given after
;           a separator (def="/", change with SEP=sep).  Example:
;           LABEL=['X min:/5','X max:/5','Y min:','Y max:']
;         SEP=sep  character used to separate label and field size (def=/).
;         DEF=def  Array of default values for each item.
;           If given must have a value for each item (def=blank).
;         ROWS=rows  Array of row numbers for each item.  Example:
;           ROWS=[1,1,2,2]  Just flags when to start next row.
;         VALS=vals Returned array of values in a string array.
;         EXIT=ex  Returned exit code: 0=ok, -1=canceled.
; OUTPUTS:
; COMMON BLOCKS:
; NOTES:
; MODIFICATION HISTORY:
;       R. Sterner, 2002 Sep 19
;       R. Sterner, 2003 Jul 10 --- Fixed defaults for byte values.
;       R. Sterner, 2003 Jul 10 --- Allowed non-numericdefault values.
;       R. Sterner, 2003 Jul 10 --- Set input focus toOK button.
;
; Copyright (C) 2002, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
	pro xgetvals_event, ev
 
	widget_control, ev.id, get_uval=uval
	widget_control, ev.top, get_uval=s
 
	if uval eq 'OK' then begin
	  n = n_elements(s.id_list)
	  vals = strarr(n)
	  for i=0,n-1 do begin
	    widget_control, s.id_list(i), get_val=t
	    vals(i) = t(0)
	  endfor
	  out = {vals:vals, ex:0}
	  widget_control, s.res, set_uval=out
	  widget_control, ev.top, /dest
	  return
	endif
 
	if uval eq 'CAN' then begin
	  out = {vals:'', ex:-1}
	  widget_control, s.res, set_uval=out
	  widget_control, ev.top, /dest
	  return
	endif
 
	end
 
 
	;------------------------------------------------------
	;  xgetvals = main routine
	;------------------------------------------------------
 
	pro xgetvals, title=tt, vals=val, labels=lab, rows=row, $
	  def=def, sep=sep, exit=ex, help=hlp
 
	if keyword_set(hlp) then begin
	  print,' General widget to get values.'
	  print,' xgetvals'
	  print,'   All args are keywords.'
	  print,' Keywords:'
	  print,'   TITLE=txt Title string or string array (Def="Enter values:").'
	  print,'   LABELS=lab Array of labels for each value to enter.'
	  print,'     Each label is an element of a string array and has the text'
	  print,'     for an item to enter.  A field size may also be given after'
	  print,'     a separator (def="/", change with SEP=sep).  Example:'
	  print,"     LABEL=['X min:/5','X max:/5','Y min:','Y max:']"
	  print,'   SEP=sep  character used to separate label and field size (def=/).'
	  print,'   DEF=def  Array of default values for each item.'
	  print,'     If given must have a value for each item (def=blank).'
	  print,'   ROWS=rows  Array of row numbers for each item.  Example:'
	  print,'     ROWS=[1,1,2,2]  Just flags when to start next row.'  
	  print,'   VALS=vals Returned array of values in a string array.'
	  print,'   EXIT=ex  Returned exit code: 0=ok, -1=canceled.'
	  return
	endif
 
	;--------  Set defaults  --------------------
	if n_elements(lab) eq 0 then begin
	  print,' Error in xgetvals: must give item labels.'
	  return
	endif
	if n_elements(tt) eq 0 then tt='Enter values:'
	if n_elements(row) eq 0 then row=indgen(n_elements(lab))
	if n_elements(def) eq 0 then begin
	  df = strarr(n_elements(lab))
	endif else begin
	  if datatype(def) eq 'BYT' then begin
	    df = strtrim(def+0,2)
	  endif else begin
	    df = strtrim(def,2)
	  endelse
	endelse
	if n_elements(lab) ne n_elements(row) then begin
	  print,' Error in xgetvals: must give a row number for each label.'
	  return
	endif
	if n_elements(lab) ne n_elements(df) then begin
	  print,' Error in xgetvals: must give a default value for each item.'
	  return
	endif
	if n_elements(sep) eq 0 then sep='/'
 
	;--------  Build widget  --------------
	top = widget_base(/col)
	;-----  Title text  -----------
	for i=0,n_elements(tt)-1 do id=widget_label(top,val=tt(i),/align_left)
	;-----  Entry fields  ---------
	id_list = lonarr(n_elements(lab))	; Field widget IDs.
	rlst = -1				; Last row number.
	for i=0,n_elements(lab)-1 do begin	; Loop through items.
	  r = row(i)				; Row number.
	  if r ne rlst then b=widget_base(top,/row)	; Start another row?
	  tmp = lab(i)				; Grab label text.
	  n = nwrds(tmp,del=sep)
	  if n eq 1 then begin			; Only 1 item in label, no field size.
	    txt = tmp
	    sz = 10
	  endif else begin			; Might have field size (if a number).
	    sz = getwrd(tmp,del=sep,/last)	; See if field size at end.
	    if isnumber(sz) then begin		; If a number pick off rest as label.
	      txt = getwrd(tmp,del=sep,-99,-1,/last)
	    endif else begin			; Not a number, assume all label.
	      txt = tmp
	      sz = 10
	    endelse
	  endelse
	  id = widget_label(b,val=txt)		; Add field label.
	  id_list(i) = widget_text(b,xsize=sz,$	; Add field entry area.
	    /edit,val=df(i),uval='')
	  rlst = r				; Remember row number.
	endfor
	;------  Exit buttons  ----------
	b = widget_base(top,/row)
	id_ok = widget_button(b,val='OK', uval='OK')
	id = widget_button(b,val='Cancel', uval='CAN')
 
	;------  Save info  --------------
	res = widget_base()
	s = {id_list:id_list, res:res}
	widget_control, top, set_uval=s
 
	;------  Activate widget  --------
	widget_control, top, /realize
	widget_control, id_ok, /input_focus
	xmanager, 'xgetvals', top, /modal
 
	;------  Get returned values  -----
	widget_control, res, get_uval=tmp
	val = tmp.vals
	ex = tmp.ex
	widget_control, res, /dest
	
 
	end	

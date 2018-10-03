;+
; NAME:
;	fields_popup.pro
;
; PURPOSE:
;	This function creates a popup window with a user-defined number of 
;	text widgets layed out in a column, plus an optional exclusive
;	button group. 
;
; CATEGORY:
;	widgets.
;
; CALLING SEQUENCE:
;	result = fields_popup(title, question, label_arr)
;
; INPUTS:
;	title: 	Title for the popup window.
;    question:	Question/statement to be printed at the top of the widget.
;   label_arr:	String array containing the label for each text widget. The
;		number of elements in the array determins the number of text
;		widgets.
;
; KEYWORD PARAMETERS:
;      switch:	Set this keyword to the string containing the name of the 
;		exclusive button group (used as the title label for the 
;		button group).
;sw_label_arr:	Set the keyword to the name of the string array containing
;		the label(s) for the each button in the button group. The 
;		number of elements in this array defines the number of buttons
;		in the button group. This keyword must be set if the 'switch'
;		keyword is set.
;      offset:	Two-element array specifying the location of the widget when
;		it arrears on the screen.
;
; OUTPUTS:
;	This function returns an anonymous data structure with the following
;	fields:
;      values:	Array of values entered into each of the text widgets. 
;      sw_num:  Integer containing the selected button number from the
;		exclusive button group. The button number corresponds to the
;		index of the sw_label_arr plus 1. This value is set to zero 
;		if the button group was not used, or if no button in the group
;		was pressed. 
;      cancel:	Value returned is zero if the cancel button was NOT pressed, 
;		value equals 1 if it was pressed.
;
; RESTRICTIONS:
;	None.
;
; PROCEDURE:
;	Creates the popup widget, makes all other widgets on the screen 
;	insensitive, returns the data structure defined above, destroys 
;	itself, then restores the original state of other widgets.
;
; EXAMPLE:
;	The following example creates a popup widget with four fields 
;	and a button group with 2 buttons:
;		q = 'Enter Size:'
;		t = 'Get Info'
;		label_arr = ['field1', 'field2', 'field3', 'field4']
;		sw = 'Which button?'
;		sw_label = ['this one', 'or this one']
;		output = fields_popup(t,q,label_arr, $
;		    switch=sw, sw_label_arr=sw_label)
;
; MODIFICATION HISTORY:
;	Written by: 	Terry Beck	ACC 	September 14, 1994
;	Modified so that hitting return key after editing a field, moves the
;	  keyboard focus to the next field. If editing the last field, pressing
;	  return is the same clicking 'OK'. Removed /integer, /floating, &
;	  /string keywords. TLB 8-9-96
;	Re-added /string keyword.  TLB  10-8-96
;	Added /def_sw keyword.  TLB  2-18-96
;	Ported to IDL V 5.0.  TLB  3-20-97
;
;_____________________________________________________________________________
;-
pro fields_popup_event, ev				;event handler

widget_control, ev.top, get_uvalue=info			;get info structure

widget_control, info.ptr, get_uvalue=output		;get output structure

widget_control, ev.id, get_uvalue=uval			;get user value of the
							;widget that generated
							;the event
nf = info.n_fields

if (uval eq nf+1) then begin				;bgroup event
    tmp = ev.value
    output.sw_num = tmp + 1
endif else $

if (uval eq nf+2) then begin				;cancel button pressed
    output.cancel = 1
    widget_control, ev.top, /destroy
endif else $

if (uval eq nf+3) then begin				;done button pressed
    for n = 1, nf do begin
    	widget_control, info.field_ids(n-1), get_value=tmp
    	output.values(n-1) = tmp
    endfor
    widget_control, ev.top, /destroy
endif else begin					;text widget events
    if (uval eq nf) then begin
    	for n = 1, nf do begin
    	    widget_control, info.field_ids(n-1), get_value=tmp
    	    output.values(n-1) = tmp
    	endfor
    	widget_control, ev.top, /destroy
    endif else begin
    	widget_control, ev.id, get_value=tmp
    	output.values(uval-1) = tmp
        widget_control, info.field_ids(uval), /input_focus
    endelse
endelse

widget_control, info.ptr, set_uvalue=output		;put output structure
							;back

if widget_info(ev.top, /valid) then $			;put info structure
    widget_control, ev.top, set_uvalue=info		;back if we didn't quit

end

;
;_____________________________________________________________________________
function fields_popup, title, question, label_arr, string=str, $
    switch=sw, sw_label_arr=sw_arr, def_sw=def_sw, offset=offset, grl=grl

on_error, 1

n_fields = n_elements(label_arr)
if (n_elements(offset) eq 0) then offset=[250,250]


type ='/integer'					;integer is the default
if keyword_set(float) then type ='/floating'
if keyword_set(str) then type = '/string'

release = float(strmid(!version.release,0,3))
if ( release ge 5.0 ) then begin
    base1 = widget_base(title=title, xoffset=offset(0), yoffset=offset(1), $
        /frame, /column, /modal, group_leader=grl)
endif else begin
    base1 = widget_base(title=title, xoffset=offset(0), yoffset=offset(1), $
        /frame, /column)
endelse

label = widget_label(base1, value=question)

for n = 1, n_fields do begin
    sn = strcompress(string(n), /remove_all)
    base = widget_base(base1, /row)
    label = widget_label(base, value=label_arr(n-1))
    com = 'field' + sn + ' = widget_text(base, uvalue=n, /editable)
    r = execute(com)
endfor

if keyword_set(sw) then $
    bgroup = cw_bgroup(base1, sw_arr, column=1, exclusive=1, label_left=sw, $
	uvalue=n_fields+1)
cancel = widget_button(base1, value='Cancel', uvalue=n_fields+2)
done = widget_button(base1, value='OK', uvalue=n_fields+3)

widget_control, base1, /realize
widget_control, field1, /input_focus
if (keyword_set(sw) and keyword_set(def_sw)) then $
    widget_control, bgroup, set_value=def_sw-1
ptr = widget_base()

if (type eq '/floating') then begin			;make output data struct
    output = {values:fltarr(n_fields), sw_num:0, cancel:0}
endif else $
if (type eq '/string') then begin
    output = {values:strarr(n_fields), sw_num:0, cancel:0}
endif else begin
    output = {values:intarr(n_fields), sw_num:0, cancel:0}
endelse

field_ids = lonarr(n_fields)
for n = 1, n_fields do begin
    sn = strcompress(string(long(n)), /remove_all)
    com ='field_ids(n-1) = field' + sn
    r = execute(com)
endfor

widget_control, ptr, set_uvalue=output			;set pointer to point
							;at output structure

info = {n_fields:n_fields, field_ids:field_ids, $	;stick the pointer in
   doneb:done, ptr:ptr}					;the info structure
							
widget_control, base1, set_uvalue=info			;stick info structure
							;in base's user value

if ( release ge 5.0 ) then begin
    xmanager, 'fields_popup', base1
endif else begin
    xmanager, 'fields_popup', base1, /modal
endelse

widget_control, ptr, get_uvalue=output				;get output 
widget_control, ptr, /destroy

return, output						;return it to caller
end

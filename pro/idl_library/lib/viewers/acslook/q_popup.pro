;+
; NAME:
;	q_popup.pro
;
; PURPOSE:
;	This function creates a pop-up widget that allows the calling program 
;	to ask the user a 'yes' or 'no' type question. The widget consists of
;	a label and two buttons.
;
; CATEGORY:
;	widgets (pop-up dialog).
;
; CALLING SEQUENCE:
;	result = q_popup(title, question)
;
; INPUTS:
;	title:	Title for the popup window.
;    question:	Question/statement to be printed at the top of the widget.
;
; KEYWORD PARAMETERS:
;     button1:	Name of the top button. Default = 'Yes'.
;     button2:	Name of the bottom button. Default = 'No'.
;	  grl:  Widget-ID of the group leader. This keyword must be set 
;		under IDL V5.0.
;
; OUTPUT:
;	The function returns a string equal to the button label pressed.
;
; RESTRICTIONS:
;	None.
;
; PROCEDURE:
;	Creates the popup widget, makes all other widgets on the screen 
;	insensitive, returns the string defined above, destroys 
;	itself, then restores the original state of other widgets.
;
; MODIFICATION HISTORY:
;	Written by: 	Terry Beck	ACC	September 14, 1994
;	11-28-94 Modified to return the label of the button pressed.  TLB
;	06-03-97 Ported to IDL V 5.0  TLB
;-
;_____________________________________________________________________________

pro q_popup_event, ev					;event handler

widget_control, ev.top, get_uvalue=info			;get info structure

if (ev.id eq info.b1id) then begin
    select = info.label1
endif else begin
    select = info.label2
endelse

widget_control, info.ptr, set_uvalue=select		;put result in pointer

widget_control, ev.top, /destroy

end

;_____________________________________________________________________________
function q_popup, title, question, button1=b1_label, button2=b2_label, $
    grl=grl

on_error, 1

if (n_elements(b1_label) eq 0) then b1_label='Yes'	;set defaults
if (n_elements(b2_label) eq 0) then b2_label='No'

release = float(strmid(!version.release,0,3))
if (release lt 5.0) then begin
    base1 = widget_base(title=title, xoffset=440, yoffset=400, $
    	ysize=100, /frame, /column)
endif else begin
    base1 = widget_base(title=title, xoffset=440, yoffset=400, $
    	ysize=100, /frame, /column, /modal, group_leader=grl)
endelse

label = widget_label(base1, value=question)
but1 = widget_button(base1, value=b1_label)
but2 = widget_button(base1, value=b2_label)

widget_control, base1, /realize			
ptr = widget_base()

info = {b1id:but1, b2id:but2, ptr:ptr, $
    label1:b1_label, label2:b2_label}			;create info structure

widget_control, base1, set_uvalue=info			;stick info structure
							;in base's user value
if (release lt 5.0) then begin							
    xmanager, 'q_popup', base1, /modal
endif else begin
    xmanager, 'q_popup', base1
endelse

widget_control, ptr, get_uvalue=select			;retrieve results
widget_control, ptr, /destroy

return, select						;return results to
							;caller
end

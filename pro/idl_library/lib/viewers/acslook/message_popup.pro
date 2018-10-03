;+
; NAME:
;	message_popup.pro
;
; PURPOSE:
;	This procedure creates a pop-up widget that allows the calling program 
;	to send the user a message. The widget consists of a user-defined 
;	number of labels laid out in column format, and a 'OK' button.
;
; CATEGORY:
;	widgets (pop-up dialog).
;
; CALLING SEQUENCE:
;	message_popup, message
;
; INPUTS:
;     message:	Message to be diplayed. String array, the number of elements
;		being the the number of columns
;
; KEYWORDS:
;       title:	Title of the message window. Default is 'Message:'.
;       group:	Widget ID of the group leader.
;      offset:	2-element array specifying the x and y position of the 
;		widget when it appears on the screen.
; OUTPUT:
;	none.
;
; RESTRICTIONS:
;	Each line can be a maximum of 50 characters.
;
; PROCEDURE:
;	Creates the popup widget, destroys itself when the 'DONE' button is
;	pressed.
;
; MODIFICATION HISTORY:
;	Written by: 	Terry Beck	ACC	September 20, 1994
;	11-25-94   Added multiple label & positioning capacity.  TLB
;	3-15-96	   Changed font.  TLB
;-
;_____________________________________________________________________________

pro message_popup_event, ev				;event handler

widget_control, ev.top, /destroy

end

;_____________________________________________________________________________
pro message_popup, message, title=title, group=group, offset=offset

on_error, 1

nr = n_elements(message)

if (n_elements(title) eq 0) then title = 'Message:'	;set default title
if (n_elements(group) eq 0) then group=0		;check for a group
if (n_elements(offset) eq 0) then offset=[100,100]

base1 = widget_base(title = title, xoffset=offset(0), yoffset=offset(1), $
  /frame, /column, ypad=10, group=group)

  for n = 0, nr-1 do begin
    base2 = widget_base(base1, /row)
    label = widget_label(base2, value=message(n), $
      FONT='-adobe-courier-medium-r-normal--18-180-75-75-m-110-iso8859-1')
  endfor

  but1 = widget_button(base1, value='DONE', $
    FONT='-adobe-courier-medium-r-normal--18-180-75-75-m-110-iso8859-1')

widget_control, base1, /realize			
xmanager, 'message_popup', base1

return
end

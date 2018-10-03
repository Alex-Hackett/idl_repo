;+
; NAME:
;	ACL_MKWIN
;
; PURPOSE:
;	Procedure creates a resizable image display window with 
;	coordinate display. This is a subroutine to ACSLOOK.
;
; CATEGORY:
;	Widgets.
;
; CALLING SEQUENCE:
;	ACL_MKWIN, Event_handler, Base_id, Win_id, Coord_labels
;
; INPUTS:
;  Ev_handler:	String containing the name of the event handler procedure.
;
; OUTPUTS:
;     Base_id:	Widget ID of the top-level-base.
;      Win_id:	Widget ID of the display window.
;    C_labels:	Three-element array containing the widget ID's of the 
;		coordinate labels
;
; KEYWORDS:
;	xsize:	Set this to the horizontal size of the window (default=512).
;	ysize:	Set this to the vertical size of window (default=512).
;	 xoff:	SetHorizontal offset (in pixels) from the left screen edge.
;	 yoff:	Vertical offset (in pixels) from the left screen edge.
;     gleader:	Group leader. The death of the group leader results in the
;		death of this widget.
;
; HISTORY:
;	Written By:	Terry Beck	ACC/GSFC	May 29 1995
;	-Added more digits to coord. display so that SCI notation
;		doesn't get cut off.	TLB	Nov 13, 1997
;-
;_____________________________________________________________________________

pro acl_mkwin, Ev_handler, Base_id, Win_id, C_labels, xsize=xsize, $
    ysize=ysize, xoff=xoff, yoff=yoff, gleader=gleader

if (n_elements(xsize) eq 0) then xsize=512
if (n_elements(ysize) eq 0) then ysize=512
if (n_elements(xoff) eq 0) then xoff=0
if (n_elements(yoff) eq 0) then yoff=0
if (n_elements(gleader) eq 0) then gleader=0

base_id = widget_base(yoffset = yoff, xoffset=xoff, group=gleader, column=1, $
  event_pro=ev_handler, uvalue=gleader, tlb_size_events=1)
 
  BASE1 = WIDGET_BASE(base_id, ROW=1, XPAD=40)

    LABEL1 = WIDGET_LABEL( BASE1, FRAME=2, VALUE='X:00000')
    LABEL2 = WIDGET_LABEL( BASE1, FRAME=2, VALUE='Y:00000')
    LABEL3 = WIDGET_LABEL( BASE1, FRAME=2, VALUE='Z:0000000000.0')

  draw = widget_draw(base_id, xsize=xsize, ysize=ysize, $
    retain=2, event_pro=ev_handler, /button_events, /motion_events)

c_labels= [LABEL1, LABEL2, LABEL3]
widget_control, base_id, /realize
widget_control, draw, get_value=win_id

wset,win_id

return
end


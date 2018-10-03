;+
; NAME:
;	ACL_BLINK
;
; PURPOSE:
;	This procedure produces a popup widget control panel for the image
;	blink functions in acslook. This is a subroutine to acslook.pro.
;
; CATEGORY:
;	Widgets.
;
; CALLING SEQUENCE:
;	ACL_BLINK, Im_pars, Fl_pars, Wid_pars
;
; INPUTS:
;    Im_pars:	Image parameters. Structure array from the stislook widget.
;    Fl_pars:	Flags. Another structure array from the stislook widget.
;   Wid_pars:	Widget parameters. Yet another structure array.
;
; KEYWORD PARAMETERS:
;      Group:	Widget ID of the group leader.
;
; OUTPUTS:
;	None.
;
; RESTRICTIONS:
;	IDL 3.6 or higher only. Designed to work exclusively with acslook.
;
; MODIFICATION HISTORY:
; 	Written by:	Terry Beck  ACC/GSFC  16 Mar 95.
;	Fixed font bug.	TLB	12-7-95.
;-
;______________________________________________________________________________

PRO Blink_Event, Event
 
WIDGET_CONTROL,Event.Id,GET_UVALUE=Ev
widget_control, event.top, get_uvalue=ptrs

widget_control, ptrs.im_ptr, get_uvalue=im_pars, /no_copy
widget_control, ptrs.fl_ptr, get_uvalue=fl_pars, /no_copy
widget_control, ptrs.wid_ptr, get_uvalue=wid_pars, /no_copy
widget_control, ptrs.bl_ptr, get_uvalue=blink_pars, /no_copy
 
  CASE Ev OF 
 
  '1': BEGIN						;start blinking
	switch, im_pars, fl_pars, wid_pars
	widget_control, blink_pars.timer, timer=blink_pars.rate
	blink_pars.stopped = 0
      	END

  '2': BEGIN						;change blink rate
	widget_control, event.id, get_value=inverse_rate
	blink_pars.rate = 1.0/inverse_rate
	widget_control, blink_pars.timer, timer=blink_pars.rate
       	END

  '3': BEGIN						;stop blinking
	blink_pars.stopped = 1
      	END

  '4': BEGIN						;increase rate X2
	blink_pars.rate = blink_pars.rate/2.0
        inverse_rate = 1.0/blink_pars.rate
	widget_control, blink_pars.rate_display, set_value=inverse_rate
	widget_control, blink_pars.timer, timer=blink_pars.rate
      	END

  '5': BEGIN						;decrease rate to 1/2
	blink_pars.rate = blink_pars.rate*2.0
        inverse_rate = 1.0/blink_pars.rate
	widget_control, blink_pars.rate_display, set_value=inverse_rate
	widget_control, blink_pars.timer, timer=blink_pars.rate
      	END

  'Timer': BEGIN					;blink again if we 
	if (blink_pars.stopped eq 0) then $		;haven't stopped.
	    switch, im_pars, fl_pars, wid_pars
	    widget_control, blink_pars.timer, timer=blink_pars.rate
	END

  '6': BEGIN						;quit - don't lose data
  	widget_control, ptrs.im_ptr, set_uvalue=im_pars, /no_copy
    	widget_control, ptrs.fl_ptr, set_uvalue=fl_pars, /no_copy
    	widget_control, ptrs.wid_ptr, set_uvalue=wid_pars, /no_copy
    	widget_control, ptrs.bl_ptr, set_uvalue=blink_pars
	widget_control, blink_pars.output_ptr, set_uvalue=ptrs
	widget_control, event.top, /destroy
      END
  ENDCASE

if widget_info(event.top, /valid) then begin		;put the pointers back
							;if we did not quit
    widget_control, ptrs.im_ptr, set_uvalue=im_pars, /no_copy
    widget_control, ptrs.fl_ptr, set_uvalue=fl_pars, /no_copy
    widget_control, ptrs.wid_ptr, set_uvalue=wid_pars, /no_copy
    widget_control, ptrs.bl_ptr, set_uvalue=blink_pars, /no_copy
    widget_control, event.top, set_uvalue=ptrs 		
endif

END

;
; ************************** SUPPORT PROCEDURES ******************************

pro switch, im_pars, fl_pars, wid_pars			;switch buffers

new_buffer = fix(cos(fl_pars.mapped*90/!radeg))		;compute new index

wset, wid_pars.im_win					;change display
device, copy=[0, 0, fl_pars.dwin_size(0), $
    fl_pars.dwin_size(1), 0, 0, im_pars.pixmaps(new_buffer)]

wset, wid_pars.zm_win					;change zoom window
device, copy=[0,0,256,256,0,0,im_pars.pixmaps(new_buffer+2)]

widget_control, wid_pars.displ_base, $			;update display title
    tlb_set_title=fl_pars.file(new_buffer)

widget_control, wid_pars.scale, $			;update scale Bgroup
    set_value=fl_pars.displ_scale(new_buffer)

widget_control, wid_pars.zoom_slider, $			;update zoom slider
    set_value=fl_pars.zoom_scale(new_buffer)

fl_pars.mapped = new_buffer
widget_control, wid_pars.frame, set_value=new_buffer	;update frame Bgroup

widget_control, wid_pars.im_min, $			;update Image MIN
    set_value=fl_pars.scalev(new_buffer,0)
widget_control, wid_pars.im_max, $			;update Image MAX
    set_value=fl_pars.scalev(new_buffer,1)	

return
end


; **************************		  ************************************
; ************************** MAIN PROGRAM ************************************
; **************************		  ************************************

PRO acl_blink, im_pars, fl_pars, wid_pars, GROUP=Group


; set variables **************************************************************

rate = fl_pars.blink_rate
inverse_rate = 1.0/rate
IF N_ELEMENTS(Group) EQ 0 THEN GROUP=0

; create widget **************************************************************

blink = WIDGET_BASE(GROUP_LEADER=Group, xoffset=600, COLUMN=1, $
  TITLE='Blink', /modal)

  BASE2 = WIDGET_BASE(blink, ROW=1, XPAD=20)

    BUTTON3 = WIDGET_BUTTON( BASE2, UVALUE='1', VALUE=' Start ')

    FIELD5 = CW_FIELD( BASE2, VALUE=inverse_rate, ROW=1, FLOAT=1, $
      RETURN_EVENTS=1, TITLE='  Blink Rate:', UVALUE='2')

    LABEL7 = WIDGET_LABEL( BASE2, VALUE='frames/sec')


  BASE9 = WIDGET_BASE(blink, ROW=1, XPAD=20)

    BUTTON10 = WIDGET_BUTTON( BASE9, UVALUE='3', VALUE=' Stop  ')

    BASE16 = WIDGET_BASE(BASE9, ROW=1, YPAD=18, XSIZE=90, uvalue='Timer')

    BUTTON14 = WIDGET_BUTTON( BASE9, UVALUE='4', VALUE=' Faster ')

    BUTTON18 = WIDGET_BUTTON( BASE9, UVALUE='5', VALUE=' Slower ')

  BASE20 = WIDGET_BASE(blink, COLUMN=1)

    fstr1 = '-adobe-helvetica-bold-r-normal'
    fstr2 = '--14-140-75-75-p-82-iso8859-1'
    fstr = fstr1 + fstr2
    BUTTON21 = WIDGET_BUTTON( BASE20, FONT=fstr, UVALUE='6', VALUE='DONE')


WIDGET_CONTROL, blink, /REALIZE

; create structures & handles ************************************************

output_ptr = widget_base()
blink_pars = {rate:rate, output_ptr:output_ptr, timer:base16, $
    rate_display:field5, stopped:1}

bl_ptr = widget_base()	;create pointers
im_ptr = widget_base(group_leader=bl_ptr)
fl_ptr = widget_base(group_leader=bl_ptr)
wid_ptr = widget_base(group_leader=bl_ptr)
widget_control, bl_ptr, set_uvalue=blink_pars, /no_copy
widget_control, im_ptr, set_uvalue=im_pars, /no_copy
widget_control, fl_ptr, set_uvalue=fl_pars, /no_copy
widget_control, wid_ptr , set_uvalue=wid_pars, /no_copy

pointers = {im_ptr:im_ptr, fl_ptr:fl_ptr, wid_ptr:wid_ptr, bl_ptr:bl_ptr}

widget_control, blink, set_uvalue=pointers

XMANAGER, 'Blink', blink

widget_control, output_ptr, get_uvalue=ptrs

widget_control, ptrs.im_ptr, get_uvalue=im_pars, /no_copy
widget_control, ptrs.fl_ptr, get_uvalue=fl_pars, /no_copy
widget_control, ptrs.wid_ptr, get_uvalue=wid_pars, /no_copy
widget_control, ptrs.bl_ptr, get_uvalue=blink_pars

fl_pars.blink_rate = blink_pars.rate

widget_control, bl_ptr, /destroy				;clean up
widget_control, output_ptr, /destroy

return
END

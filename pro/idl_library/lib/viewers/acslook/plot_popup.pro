;+
; NAME:
;	plot_popup
;
; PURPOSE:
;	This function creates a pop-up widget to display a plot.
;
; CATEGORY:
;	Widgets (pop-up)
;
; CALLING SEQUENCE:
;	result = plot_popup([X,] Y)
;
; INPUTS:
;	    X:	The x-axis vector. If not given y is plotted as a function
;		of point number.
;	    Y:	The y-axis vector, must be the same length as x.	
;
; KEYWORD PARAMETERS:
;  special_b1:  First special user-defined button. Set this keyword to the
;		string containing the button label. If this keyword is used,
;		you must also specify the keyword b1_pro.
;      b1_pro:	Set this keyword to a string containing the name of the
;		procedure or function (including the calling sequence) to be
;		executed when the first special button is pressed. See the
;		parameter list below for the names of variables that can be
;		passed to this routine. 
;     b1_text:  Set this keyword to a string variable containing any text to
;		be displayed the messages window when this button is pressed.
;  special_b2:	Second special user-defined button.
;      b2_pro:	Second user-defined routine.
;     b2_text:	Text to be displayed in messages window when b2 is pressed.
;  special_b3:	Third special user-defined button.
;      b3_pro:	Third user-defined routine.
;     b3_text:	Text to be displayed in messages window when b3 is pressed.
;   press_pro:	Set this keyword to a string containing the name of the
;		procedure or function (including the calling sequence) to be
;		executed when the mouse button is pressed while the cursor
;		is in the graphics window. If this keyword is not present, 
;		nothing happens when the mouse button is pressed.
;     userval:	user value. This parameter is not used by the widget in any
;		way. It is supplied for the convenience of the programmer.
;		It can be of any data type or organization.
;   xwin_size:	Set this keyword to specify the x size of the plot window 
;		in pixels. If this keyword is not set, a value of 700 is the
;		default. If this value is set larger than 700, the window
;		created will contain a scrollbar.
;   histogram:	Set this keyword for a histogram type plot.
;	See the description of plot for other accepted keywords.
;	  grl:	Set this keyword to widget ID# of the parent, this keyword
;		MUST be set in IDL V5.0.
;		
; OUTPUTS:
;	The variable that this function returns will contain a null string
;	unless one or both of the user-defined button is used and its output
;	variable is called 'output'.
;	This allows the programmer to retrieve the contents of any variable 
;	in those routines.
;
; PARAMETER LIST (partial):
;	event:	Widget event data structure.
;   data_pars:	Anonymous data structure containing:
;		    x:	The input x-vector.
;		    y:	The input y-vector.
;	      userval:	The user value.
;    wid_pars:  Anonymous data structure containing the parameters:
;		 mess:	Widget Id # of the message window. 
;		  xws:	x size of the plot window.
;	      printer:	Printer command. Example: "lpr -Plw"
;
; RESTRICTIONS:
;	None.
;
; EXAMPLES:
;	1)Suppose you wanted to perform a special procedure 'blow_up' on the
;	input x-vector. In this case the keyword 'special_b1' would be set
;	equal to the string 'blow up x' or something. The keyword 'b1_pro'
;	would be set to a string containing:
;		blow_up, data_pars.x
;
;	2) Suppose you wanted to return a value from the procedure 'blow_up'.
;	The keyword 'b1_pro' would look like:
;		blow_up, data_pars.x, output
;	When the 'Done' button is pressed the contents of the variable 'output'
;	will become the result of the plot_popup function.
;
; MODIFICATION HISTORY:
; 	Written by:	Terry Beck	ACC	September 29, 1994
;	
;	Added _extra keyword.	TLB	10-27-94.
;	Added third user-defined button.  TLB	3-9-95.
;	Added button group for plot type.  TLB	3-14-95.
;	Added text keywords for special user-defined buttons.  TLB  9-14-95
;	Added replot button.  TLB  9-20-95
;	Added ptitle keyword.  TLB  12-27-95
;	Added y-axis slider.  TLB  12-28-95
;   	User can now input PS filenames. Write perm. is checked. TLB 2/13/96
;	Ported to IDL V5.0.  TLB  6/4/97
;	Fixed log scale plotting problem, data less than 0.  TLB  4/14/98
;-
;_____________________________________________________________________________

PRO plot_popup_Event, Event

WIDGET_CONTROL,Event.Id,GET_UVALUE=uval
widget_control, event.top, get_uvalue=ptrs				;get pointers

							;get structures
widget_control, ptrs.data_ptr, get_uvalue=data_pars, /no_copy	
widget_control, ptrs.wid_ptr, get_uvalue=wid_pars, /no_copy

CASE uval OF 

   '1': BEGIN											;user-defined button 1
		widget_control, wid_pars.mess, set_value=data_pars.b1_text
    		com = data_pars.b1_pro
		r = execute(com)
		if (n_elements(output) eq 0) then output=''	;anything in output var?
		widget_control, data_pars.output_ptr, set_uvalue=output
		widget_control, wid_pars.mess, set_value='Ready'
     	END

   '2': BEGIN											;user-defined button 2
		widget_control, wid_pars.mess, set_value=data_pars.b2_text
    		com = data_pars.b2_pro
		r = execute(com)
		if (n_elements(output) eq 0) then output=''	;anything in output var?
		widget_control, data_pars.output_ptr, set_uvalue=output
		widget_control, wid_pars.mess, set_value='Ready'
      	END

   '2a': BEGIN											;user-defined button 3
		widget_control, wid_pars.mess, set_value=data_pars.b3_text
       		com = data_pars.b3_pro
		r = execute(com)
		if (n_elements(output) eq 0) then output=''	;anything in output var?
		widget_control, data_pars.output_ptr, set_uvalue=output
		widget_control, wid_pars.mess, set_value='Ready'
      	END

   '3': BEGIN											;select plot type
		data_pars.type=event.value
		if (data_pars.type ne 0) then begin
	    	widget_control, wid_pars.yslider, sensitive=0
		endif else begin
	    	if (data_pars.hist eq 0) then $
	    		widget_control, wid_pars.yslider, sensitive=1
		endelse
		plp_make_plot, data_pars
		END

   '3a': BEGIN											;replot
		plp_make_plot, data_pars
		END
		
   '3ab': BEGIN						; reset y-axis min
   		min = event.value
		data_pars.yrange(0)=min
		plp_make_plot, data_pars
		END
		
   '4': BEGIN											;plot to PS file.
   		title = ' Name the output postscript file '
		outfile = pickfile( title=title, file='idl.ps')

		goodfile = 0
		if (outfile ne '') then begin
			openw, unit, outfile, error=err, /get_lun
			if (err eq 0) then begin
				goodfile=1
				close, unit
			endif else begin
				goodfile=0
				message = ['Error opening output file:', $
					'No write permission - operation aborted.'] 
				junk = widget_message(message, /error)
			endelse
		endif

		if (outfile ne '' and goodfile eq 1) then begin
			widget_control, /hourglass
			message = 'Sending image to PS file ' + outfile
			widget_control, wid_pars.mess, set_value=message
			set_plot, 'ps'
			device, /landscape
			device, file=outfile
			plp_make_plot, data_pars
			device, /close
			set_plot, 'x'
			wait, 1.5 
			widget_control, wid_pars.mess, set_value='Ready.'
		endif
      	END

   '5': BEGIN											;quit
      	widget_control, event.top, /destroy
      	END

   '6': BEGIN											;draw window events

		if (event.type eq 0 and data_pars.press_pro ne '') then begin
	    	widget_control, /hourglass			;button press
	    	com = data_pars.press_pro
	    	r = execute(com)
		endif
      	END

   '7': BEGIN											;y-axis slider
		sld = event.value
		mult = (data_pars.pminmax(1) - data_pars.pminmax(0))/1000.0
		data_pars.yrange(1) = mult*sld + data_pars.pminmax(0)
		plp_make_plot, data_pars
		END

ENDCASE
							;put away structures
widget_control, ptrs.data_ptr, set_uvalue=data_pars, /no_copy	 
widget_control, ptrs.wid_ptr, set_uvalue=wid_pars, /no_copy

if widget_info(event.top, /valid) then $		;put away pointers if
    widget_control, event.top, set_uvalue=ptrs		;we did not quit

END

;
;_____________________________________________________________________________

pro plp_make_plot, data_pars

case data_pars.type of

    0:	begin						;linear plot
		plot, data_pars.x, data_pars.y, yrange=data_pars.yrange, $
	    	    _extra=data_pars.extra
		end

    1:  begin						;log plot
    		bad = where(data_pars.y le 0,ctb)
		py = data_pars.y
		if (ctb gt 0) then py(bad) = 0
		plot_io, data_pars.x, py, yrange=data_pars.yrange, $
		    _extra=data_pars.extra
		end

    2:  begin						;histogram type plot
		plot_iio, data_pars.x, data_pars.y, $
		    _extra=data_pars.extra
		end
endcase

return
end

;
;_____________________________________________________________________________

function plot_popup, xx, yy, special_b1=sb1, b1_pro=b1_pro, special_b2=sb2, $
    b2_pro=b2_pro, special_b3=sb3, b3_pro=b3_pro, press_pro=ppro, $
    userval=uval, xwin_size=xws, histogram=hist, log=log, _extra=extra, $
    b1_text=b1_text, b2_text=b2_text, b3_text=b3_text, ptitle=ptitle, $
    grl=grl


; set defaults ****************************************************************

set_viewport, 0.1, 0.95, 0.15, 0.9

case n_params() of
    1: begin
		y = xx
		x = indgen(n_elements(y))
		end
    2: begin
		y = yy & x = xx
		end
    else: begin
		print, "CALLING SEQUENCE:"
		print, "	result = plot_popup([x,] y)"
		retall
		end
endcase

if (n_elements(extra) eq 0) then extra = {title:''}

yrange = minmax(y)
yrange(0) = 1.0

if (n_elements(sb1) ne 0) then begin			;special button 1 used?
    b1map = 1
endif else begin
    b1map = 0
    sb1 = ''
    b1_pro = ''
endelse

if (n_elements(sb2) ne 0) then begin			;special button 2 used?
    b2map = 1
endif else begin
    b2map = 0
    sb2 = ''
    b2_pro = ''
endelse

if (n_elements(sb3) ne 0) then begin			;special button 3 used?
    b3map = 1
endif else begin
    b3map = 0
    sb3 = ''
    b3_pro = ''
endelse


if (n_elements(ppro) eq 0) then ppro=''			;button press procedure
if (n_elements(uval) eq 0) then uval = 0

if (n_elements(xws) eq 0 ) then xws = 700		;700 default window size		
							;set plot type:
type=0							;0->linear (default)
if (keyword_set(log)) then type = 1			;1->log plot
if (keyword_set(hist)) then type = 2			;2->histogram

if not keyword_set(b1_text) then b1_text =''
if not keyword_set(b2_text) then b2_text =''
if not keyword_set(b3_text) then b3_text =''

if not keyword_set(ptitle) then begin
    if keyword_set(hist) then begin
	ptitle='Histogram'
    endif else begin
	ptitle='Plot popup'
    endelse
endif

!x.style=1
!y.style=1

; create widget ***************************************************************

release = float(strmid(!version.release,0,3))

if (release lt 5.0) then begin
  base1 = WIDGET_BASE(COLUMN=1, TITLE=ptitle, xoffset=50, yoffset=50)
endif else begin
  base1 = WIDGET_BASE(COLUMN=1, TITLE=ptitle, xoffset=50, yoffset=50, $
    /modal, group_leader=grl)
endelse

  mess = cw_field(base1, title='Messages: ', xsize=90, /noedit)
  BASE2 = WIDGET_BASE(base1, ROW=1)
    BASE39 = WIDGET_BASE(BASE2, ROW=1, MAP=b1map)
      BUTTON41 = WIDGET_BUTTON(BASE39, UVALUE='1', VALUE=sb1, XOFFSET=10)
    BASE38 = WIDGET_BASE(BASE2, ROW=1, MAP=b2map)
      BUTTON43 = WIDGET_BUTTON(BASE38, UVALUE='2', VALUE=sb2, XOFFSET=10)
    BASE37 = WIDGET_BASE(BASE2, ROW=1, MAP=b3map)
      BUTTON45 = WIDGET_BUTTON(BASE37, UVALUE='2a', VALUE=sb3, XOFFSET=10)
  Base7 = widget_base(base1, row=1)
    btns1 = ['Linear', 'Log', 'Log->linear']
    bgroup1 = cw_bgroup(base7, btns1, row=1, exclusive=1, $
      label_left='Plot type: ', uvalue='3', frame=2, set_value=type)
    ymin = cw_field(base7, title='Y-MIN: ', frame=2, value=1.0, $
      xsize=12, uvalue='3ab', /floating, /return_events)
    BUTTON22 = widget_button(base7, uvalue='3a', value='Re-plot')
    BUTTON24 = WIDGET_BUTTON(BASE7, UVALUE='4', $
      VALUE=' Send Plot to PS File ')
    BUTTON26 = WIDGET_BUTTON(BASE7, UVALUE='5', VALUE=' Done ')
  BASE11 = WIDGET_BASE(base1, ROW=1)
    if (xws le 700) then begin				;scroll bar needed?
      yslider = widget_slider(BASE11, /suppress_value, YSIZE=300, $
	minimum=1, maximum=1000, value=1000, UVALUE='7', /vertical)
      DRAW12 = WIDGET_DRAW(BASE11, BUTTON_EVENTS=1, FRAME=2, MOTION_EVENTS=1, $
        RETAIN=2, UVALUE='6', XSIZE=xws, YSIZE=300, xoffset=100, yoffset=100)
    endif else begin					
      yslider = widget_slider(BASE11, /suppress_value, YSIZE=300, $
        minimum=1, maximum=1000, value=1000, UVALUE='7', /vertical)
      DRAW12 = WIDGET_DRAW(BASE11, BUTTON_EVENTS=1, FRAME=2, MOTION_EVENTS=1, $
        RETAIN=2, UVALUE='6', XSIZE=xws, X_SCROLL_SIZE=700, YSIZE=300, $
	xoffset=100, yoffset=100)
    endelse

WIDGET_CONTROL, base1, /REALIZE

if keyword_set(hist) then begin
    widget_control, yslider, sensitive=0
endif else begin
    hist = 0
endelse

WIDGET_CONTROL, DRAW12, GET_VALUE=DRAW12_Id		;get ID of draw widget
wset, DRAW12_Id

output_ptr = widget_base()				;data structures

data_pars = {x:x, y:y, userval:uval, b1_pro:b1_pro, b2_pro:b2_pro, $
    b3_pro:b3_pro, press_pro:ppro, output_ptr:output_ptr, yrange:yrange, $
    type:type, extra:extra, b1_text:b1_text, b2_text:b2_text, $
    b3_text:b3_text, pminmax:yrange, hist:hist}

wid_pars = {mess:mess, yslider:yslider, ymin:ymin}

plp_make_plot, data_pars

widget_control, mess, set_value='Ready.'

data_ptr = widget_base()				;create pointers
wid_ptr = widget_base()
widget_control, data_ptr, set_uvalue=data_pars, /no_copy
widget_control, wid_ptr, set_uvalue=wid_pars, /no_copy
pointers = {data_ptr:data_ptr, wid_ptr:wid_ptr}

widget_control, base1, set_uvalue=pointers		;stick pointers into
							;uservalue of base

if (release lt 5.0) then begin
    XMANAGER, 'plot_popup', base1, /modal
endif else begin
    XMANAGER, 'plot_popup', base1
endelse

widget_control, output_ptr, get_uvalue=output		;get output
if (n_elements(output) eq 0) then output=''		;anything in output var?
widget_control, data_ptr, /destroy
widget_control, output_ptr, /destroy

return, output						;return output to caller

!p.color = 256
!p.background = 0

END

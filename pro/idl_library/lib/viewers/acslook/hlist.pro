;+
;
;*NAME:
;	hlist.pro
;
;*PURPOSE:
;	This function is a header keyword selector GUI.
;
;*CATEGORY:
;	Widgets.
;
;*CALLING SEQUENCE:
;	result = hlist(header, title=title, group=group)	
;
;*INPUTS:
;	header - FITS image header.
;
;*OUTPUTS:
;	result - string containing the name of the selected keyword.
;
;*KEYWORD PARAMETERS:
;	title - string containing the title for the widget.
;	group - widget group leader.
;
;*RESTRICTIONS:
;	IDL Version 3.6 or higher.
;
;*EXAMPLES:
;	IDL> keyname = hlist(header, title='Select keyword')
;
;*HISTORY:
;	Version 1.0	T. Beck		ACC/GSFC	5 Dec 1995
;-
;_______________________________________________________________________


PRO hlist_Event, Event

  WIDGET_CONTROL, Event.Id, GET_UVALUE=uval
  widget_control, event.top, get_uvalue=ptr
  handle_value, ptr.data_ptr, data_pars
  

  CASE uval OF 

  '1': BEGIN						;list item selected
	data_pars.index = event.index

      END

  '2': BEGIN						;OK button pressed
	widget_control, event.top, /destroy
      END

  '3': BEGIN						;Cancel button pressed
	data_pars.index = 999
	widget_control, event.top, /destroy
      END

  ENDCASE

  handle_value, ptr.data_ptr, data_pars, /set

END

;
;__________________________________________________________________________
;

function hlist, header, title=title, GROUP=Group

  IF N_ELEMENTS(Group) EQ 0 THEN GROUP=0
  if n_elements(title) eq 0 then title=''
  n = n_elements(header)
  
  fstr1 = '-adobe-helvetica-bold-r-normal'
  fstr2 = '--14-140-75-75-p-82-iso8859-1'
  fstr = fstr1 + fstr2
;
; Create widget
;
  hbase = WIDGET_BASE(GROUP_LEADER=Group, COLUMN=1, xoffset=250, $
    yoffset=250, title=title, xpad=100) 

    LIST2 = WIDGET_LIST(hbase ,VALUE=header(0:n-2), UVALUE='1', $
      FONT=fstr, YSIZE=6)

    BASE4 = WIDGET_BASE(hbase, ROW=1, XPAD=10)

      BUTTON5 = WIDGET_BUTTON( BASE4, UVALUE='2', FONT=fstr, $
         VALUE='  OK  ')

      BUTTON8 = WIDGET_BUTTON( BASE4, UVALUE='3', FONT=fstr, $
         VALUE='  CANCEL  ')

  data_pars = {index:999}
  data_ptr = handle_create(value=data_pars)		;create pointer
  pointer = {data_ptr:data_ptr}
  widget_control, hbase, set_uvalue=pointer

  WIDGET_CONTROL, hbase, /REALIZE

  XMANAGER, 'HLIST', hbase, /modal

  handle_value, pointer.data_ptr, data_pars

  if (data_pars.index ne 999) then begin
      selected = header(data_pars.index)
      keyword = strtrim(gettok(selected, '='))
  endif else begin
      keyword = ''
  endelse

  handle_free, data_ptr

return, keyword
END

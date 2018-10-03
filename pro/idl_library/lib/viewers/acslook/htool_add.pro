;+
;*NAME:
;	htool_add
;
;*PURPOSE:
;	The procedure is a FITS header editor GUI interface to the 
;	sxaddpar routine.
;
;*CATEGORY:
;	Widgets, image processing.
;
;*CALLING SEQUENCE:
;	htool_add, header, [keyname, ] modify=modify, group=group
;
;*INPUTS:
;	header - string array containing heder to be modified.
;
;*OPTIONAL INPUTS:
;	keyname - string variable containing name of keyword to be
;		added/modified.
;
;*OUTPUTS:
;	Header array is modified in place.
;
;*KEYWORD PARAMETERS:
;	modify - set this keyword to modify an existing keyword. Keyword
;		name must be supplied. see OPTIONAL INPUTS above.
;
;	group - widget ID of the group leader.
;
;*NOTES:
;
;*EXAMPLES:
;	To add a keyword:
;		IDL> htool_add, header
;	To modify an existing keyword:
;		IDL> htool_add, header, 'KEYNAME', /modify
;
;*HISTORY:
;	Version 1.0 	T. Beck		ACC/GSFC	6 Dec 95
;-
;_______________________________________________________________________


PRO htool_add_Event, Event

  widget_control, event.top, get_uvalue=ptrs
  handle_value, ptrs.hd_ptr, hd_pars, /no_copy
  handle_value, ptrs.h_ptr, header, /no_copy
  handle_value, ptrs.wid_ptr, wid_pars, /no_copy
  
  WIDGET_CONTROL,Event.Id,GET_UVALUE=Ev

  CASE Ev OF 

  '1': BEGIN						;get keyword name
	widget_control, event.id, get_value=name
	hd_pars.name = name(0)
      END

  '2': BEGIN						;get keyword type
      	CASE Event.Value OF
      	    0: hd_pars.type='INT'			;integer
	    1: hd_pars.type='LON'			;long integer
      	    2: hd_pars.type='FLT'			;floating
      	    3: hd_pars.type='DBL'			;double precision
      	    4: hd_pars.type='STR'			;string
            5: hd_pars.type='LOG'			;logical (T or F)
        ENDCASE
      END

  '3': BEGIN						;get keyword value
	widget_control, event.id, get_value=value
	hd_pars.value = value(0)
      END

  '4': BEGIN						;toggle between basic
							;and advanced features
	if (wid_pars.opt_mapped eq 1) then begin
	    widget_control, wid_pars.opt_base, map=0
	    widget_control, wid_pars.opt_button, $
		set_value='ADVANCED OPTIONS'
	    wid_pars.opt_mapped = 0
	endif else begin
	    widget_control, wid_pars.opt_base, map=1
	    widget_control, wid_pars.opt_button, $
		set_value='BASIC OPTIONS'
	    wid_pars.opt_mapped = 1
	endelse
      END

  '5': BEGIN						;get comment
	widget_control, event.id, get_value=comment
	hd_pars.comment = comment(0)
      END

  '6': BEGIN						;get location
	hd_pars.place = Event.Value
	null = wid_pars.nullstr
	if (hd_pars.place gt 1) then begin		;before or after
	    key = hlist(header, title='Select keyword')
	    if (key ne '') then begin
		if (hd_pars.place eq 2) then begin	;before
		    hd_pars.before = key
		    widget_control, wid_pars.bef_key, set_value=key
		    widget_control, wid_pars.aft_key, set_value=null
		endif
		if (hd_pars.place eq 3) then begin	;after
		    hd_pars.after = key
		    widget_control, wid_pars.aft_key, set_value=key
		    widget_control, wid_pars.bef_key, set_value=null
		endif
	    endif else begin				;no keyword selected
		mess = ['You must select a keyword for this option.', $
		    '         Using default placement.']
		junk = widget_message(mess)
		hd_pars.place = 0
		widget_control, event.id, set_value=0
		widget_control, wid_pars.aft_key, set_value=null
		widget_control, wid_pars.bef_key, set_value=null
	    endelse
	endif else begin				;before=HIST or default
	    widget_control, wid_pars.aft_key, set_value=null
	    widget_control, wid_pars.bef_key, set_value=null
	endelse
      END

  '7': BEGIN						;get format
	widget_control, event.id, get_value=format
	hd_pars.format = format(0)
      END

  '8': BEGIN						;OK to add parameter

	abort=0
	on_ioerror, badv
	case hd_pars.type of				;check input value
	    'INT': begin
		value = fix(hd_pars.value)
	    end
	    'LON': begin
		value = long(hd_pars.value)
	    end
	    'FLT': begin
		value = float(hd_pars.value)
	    end
	    'DBL': begin
		value = double(hd_pars.value)
	    end
	    'STR': begin
		value = hd_pars.value
	    end
	    'LOG': begin
		value = hd_pars.value
		if (value ne 'T' and value ne 'F') then begin
		    mess = ['Invalid logical keyword value.', $
			'        Must be "T" or "F"', $
			'Check the value and try again.']
		    abort=1
		endif
	    end
	endcase

badv:	if (!err lt 0) then begin			;type conversion error
	    abort = 1
	    mess = ['Keyword value does not match variable type.', $
                ' Check the value and try again.']
	    !err = 0
	endif

	if (hd_pars.name eq '') then begin		;make sure a name was
	    mess = ['No keyword name given. ', $	;entered
		'Operation aborted.']
	    abort =1
	endif

	if (abort eq 0) then begin			;add the parameter
	    if (hd_pars.format eq '') then begin	;no special format
		case hd_pars.place of
		    0: sxaddpar, header, hd_pars.name, value, $
			hd_pars.comment
		    1: sxaddpar, header, hd_pars.name, value, $
			hd_pars.comment, before='HISTORY'
		    2: sxaddpar, header, hd_pars.name, value, $
			hd_pars.comment, before=hd_pars.before
		    3: sxaddpar, header, hd_pars.name, value, $
			hd_pars.comment, after=hd_pars.after
		endcase
	    endif else begin				;with special format
		case hd_pars.place of
		    0: sxaddpar, header, hd_pars.name, value, $
                        hd_pars.comment, format=hd_pars.format
		    1: sxaddpar, header, hd_pars.name, value, $
                        hd_pars.comment, before='HISTORY', $
			format=hd_pars.format
		    2: sxaddpar, header, hd_pars.name, value, $
                        hd_pars.comment, before=hd_pars.before, $
			format=hd_pars.format
		    3: sxaddpar, header, hd_pars.name, value, $
                        hd_pars.comment, after=hd_pars.after, $
			format=hd_pars.format
		endcase
	    endelse
	    if hd_pars.funct eq 'ADD' then begin
	    	mess = '  Keyword "' + hd_pars.name + '" added.  '
	    endif else begin
		mess = '  Keyword "' + hd_pars.name + '" modified.  '
	    endelse
	    junk = widget_message(mess, /inform, title='HTOOL')
	endif else begin
	    junk = widget_message(mess, /error) 
	endelse

      END

  '9': BEGIN						;cancel operation
	widget_control, event.top, /destroy
      END

  '10': BEGIN						;done
	widget_control, event.top, /destroy
      END

  ENDCASE

  handle_value, ptrs.hd_ptr, hd_pars, /set, /no_copy
  handle_value, ptrs.h_ptr, header, /set, /no_copy
  handle_value, ptrs.wid_ptr, wid_pars, /set, /no_copy

  if widget_info(event.top, /valid) then $
      widget_control, event.top, set_uvalue=ptrs, /no_copy
END

;
;________________________________________________________________________

PRO htool_add, header, keyname, modify=modify, GROUP=Group

  IF N_ELEMENTS(Group) EQ 0 THEN GROUP=0
  if n_elements(keyname) eq 0 then keyname=''

  if keyword_set(modify) then begin
    value = sxpar(header, keyname, comment=comment)
    title = 'MODIFY KEYWORD PARAMETER'
    funct = 'MOD'
    s = size(value)
    case s(1) of
      1: begin
	type = 5 & typestr = 'LOG'
	end
      2: begin
	type = 0 & typestr = 'INT'
	end
      3: begin
	type = 1 & typestr = 'LON'
	end
      4: begin
	type = 2 & typestr = 'FLT'
	end
      5: begin
	type = 3 & typestr = 'DBL'
	end
      7: begin
	type = 4 & typestr = 'STR'
	end
    endcase
    execute_button = '  CHANGE  '
  endif else begin
    title = 'ADD KEYWORD PARAMETER'
    funct = 'ADD'
    value = ''
    comment = ''
    type = 0
    execute_button = '  ADD  '
    typestr = 'INT'
  endelse
;
; create the widget
;
  base = WIDGET_BASE(GROUP_LEADER=Group, COLUMN=1, TITLE=title, /modal)

    FIELD2 = CW_FIELD( base, VALUE=keyname, ROW=1, STRING=1, ALL_EVENTS=1, $
      TITLE='Keyword name (8 chars. or less):', UVALUE='1', XSIZE=8)

    Btns211 = [ 'INT', 'LONG', 'FLT', 'DBL', 'STR', 'LOG' ] 
    BGROUP4 = CW_BGROUP( base, Btns211, ROW=1, EXCLUSIVE=1, $
      LABEL_LEFT='Type: ', UVALUE='2', set_value=type)

    FIELD6 = CW_FIELD( base, VALUE=value, ROW=1, STRING=1, ALL_EVENTS=1, $
      TITLE='Keyword value:', UVALUE='3')

    BUTTON16 = WIDGET_BUTTON( base, UVALUE='4', VALUE='ADVANCED OPTIONS', $
      /dynamic_resize)

    BASE8 = WIDGET_BASE( base, COLUMN=1, FRAME=2, MAP=0)

      FIELD11 = CW_FIELD( BASE8, VALUE=comment, ROW=1, STRING=1, $
        ALL_EVENTS=1, TITLE='Comment:', UVALUE='5', XSIZE=45)

      base10 = widget_base ( base8, ROW=1)

      	Btns1048 = [ 'At the end', 'Before HISTORY', 'Before KEYWORD:', $
    	  'After KEYWORD:' ]
      	BGROUP17 = CW_BGROUP( BASE10, Btns1048, COLUMN=1, EXCLUSIVE=1, $
          LABEL_LEFT='Placement: ', UVALUE='6', set_value=0)

	base12 = widget_base( base10, column=1, ypad=10, space=11)

	  nullstr = '                 '
	  label1 = widget_label( base12, value=nullstr)
	  label2 = widget_label( base12, value=nullstr)
	  bef_key = widget_label( base12, value=nullstr)
          aft_key = widget_label( base12, value=nullstr)

      FIELD19 = CW_FIELD( BASE8, VALUE='', ROW=1, STRING=1, ALL_EVENTS=1, $
        TITLE='Format: ', UVALUE='7', XSIZE=10)

      BASE21 = WIDGET_BASE( BASE, ROW=1, SPACE=130, XPAD=20, MAP=1)

  	BUTTON22 = WIDGET_BUTTON( BASE21, UVALUE='8', VALUE=execute_button)

  	BUTTON25 = WIDGET_BUTTON( BASE21, UVALUE='9', VALUE='  CANCEL  ')

  	BUTTON26 = WIDGET_BUTTON( BASE21, UVALUE='10', VALUE='  DONE  ')


  if keyword_set(modify) then $
    widget_control, BGROUP17, sensitive=0

  WIDGET_CONTROL, base, /REALIZE
  
  hd_pars = {name:keyname, type:typestr, value:value, comment:comment, $
    place:0, before:'', after:'', format:'', funct:funct}
  
  wid_pars = {opt_base:base8, opt_button:BUTTON16, opt_mapped:0, $
    bef_key:bef_key, aft_key:aft_key, nullstr:nullstr}

  hd_ptr = handle_create(value=hd_pars, /no_copy)
  h_ptr = handle_create(hd_ptr, value=header, /no_copy)
  wid_ptr = handle_create(hd_ptr, value=wid_pars, /no_copy)

  pointers = {hd_ptr:hd_ptr, h_ptr:h_ptr, wid_ptr:wid_ptr}

  widget_control, base, set_uvalue=pointers

  XMANAGER, 'HTOOL_ADD', base				;hand-off to xmanager

  handle_value, h_ptr, header, /no_copy

  handle_free, hd_ptr

END

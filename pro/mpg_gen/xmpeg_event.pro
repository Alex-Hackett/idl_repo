PRO xmpeg_event, event

widget_control, event.top, get_uvalue = state, /no_copy
 

if (event.id eq state.gbutton) then begin
	widget_control, state.label, set_value=''
	widget_control, state.prefix, get_value=prefix
	widget_control, state.suffix, get_value=suffix
	widget_control, state.n_start, get_value=n_start
	widget_control, state.n_end, get_value=n_end
	widget_control, state.digits, get_value=digits
	widget_control, state.xsize, get_value = xsize
	widget_control, state.ysize, get_value = ysize
	widget_control, state.mpeg_file, get_value=mpeg_file
	widget_control, state.tmp_dir, get_value=tmp_dir
	format = widget_info(state.format_id, /list_select)
	frame_rate = widget_info(state.frame_rate_id, /list_select)

	widget_control, /hourglass

	result  = mpg(prefix=prefix[0], suffix=suffix[0], n_start=n_start, n_end=n_end, digits=digits, format=format, frame_rate=frame_rate+1, mpeg_file=mpeg_file[0], xsize=xsize, ysize=ysize, tmp_dir=tmp_dir[0])

	if result eq 0 then begin
		widget_control, state.label, set_value='done'
	end
	widget_control, event.top, set_uvalue=state, /no_copy

	return
endif
if (event.id eq state.bgroup) then begin
	if (event.value eq 0) then begin
		widget_control, state.prefix, set_value=''
		widget_control, state.suffix, set_value=''
		widget_control, state.mpeg_file, set_value=''
		widget_control, state.n_start, set_value=0
		widget_control, state.n_end, set_value=0
		widget_control, state.digits, set_value=0
		widget_control, state.xsize, set_value=0
		widget_control, state.ysize, set_value=0
		widget_control, state.tmp_dir, set_value=''
		widget_control, state.mpeg_file, set_value=''
		widget_control, state.label, set_value=''
		widget_control, event.top, set_uvalue=state, /no_copy
		return
	end
	if (event.value eq 1) then begin
		widget_control, /destroy, event.top
		return
	end
end

 widget_control, event.top, set_uvalue=state, /no_copy 

END

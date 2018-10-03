PRO xmpeg,  group=group

base = widget_base(/column, title='Generate MEG', xsize=400, ysize=800)

prefix = cw_field(base,  /string, title='prefix     ')

suffix = cw_field(base, /string, title='suffix     ')

n_start = cw_field(base, /integer, title='start image')

n_end = cw_field(base, /integer, title='end image  ')

digits = cw_field(base, /integer, title='digits     ')

xsize = cw_field(base, /integer, title='x size     ')
ysize = cw_field(base, /integer, title='y size     ')

mpeg_file = cw_field(base, /string,title='mpeg file  ')

label_format= widget_label(base, value='format')
values= ['MPEG1', 'MPEG2']
format_id = widget_list (base,  value=values, ysize=2)
widget_control, format_id, set_list_select=0

label_format= widget_label(base, value='frame rate')
values=['23.976','24','25','29.97','30','50','59.94','60']
frame_rate_id = widget_list(base,  value=values,  ysize=8)
widget_control, frame_rate_id, set_list_select=4

tmp_dir = cw_field(base, /string, title='tmp dir   ')

gbutton = widget_button(base, value='make mpeg')

bgroup = cw_bgroup(base, ['clear', 'exit'],  /row, space=50)

label = widget_label(base, value='')

state = { prefix:prefix, suffix:suffix, n_start:n_start, n_end:n_end, digits:digits, $
	xsize:xsize, ysize:ysize, mpeg_file:mpeg_file, format_id:format_id,  $
	frame_rate_id:frame_rate_id,  tmp_dir:tmp_dir, gbutton:gbutton, $
	bgroup:bgroup, label:label }

widget_control, base, set_uvalue=state, /no_copy, /realize

xmanager, 'xmpeg', base, group=group

END

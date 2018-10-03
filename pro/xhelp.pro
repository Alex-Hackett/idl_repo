;-------------------------------------------------------------
;+
; NAME:
;       XHELP
; PURPOSE:
;       Widget to display given help text.
; CATEGORY:
; CALLING SEQUENCE:
;       xhelp, txt
; INPUTS:
;       txt = String array with help text to display.  in
; KEYWORD PARAMETERS:
;       Keywords:
;         TITLE=txt  title text or text array (def=none).
;         LINES=lns maximum number of lines to display
;           before added a scroll bar (def=30).
;         XSIZE=xs Width of text area in characters (def=max needed).
;         /SCROLL force scroll bars.  Useful if new text will
;           displayed later.
;         EXIT_TEXT=txt Exit button text (def=Quit help).
;         WID=id  returned widget ID of help widget.  This
;           allows the help widget to be automatically
;           destroyed after action occurs.
;         TID=tid returned widget ID of text area.  This
;           allows text to be updated from outside this routine.
;           widget_control,tid,set_val=new_text,xsize=xs,ysize=ys
;           New x and y sizes may optionally be set.
;         TTID=ttid returned widget ID of the title (-1 if no title).
;           Title may be changed: widget_control,ttid,set_val=new
;         /NOWAIT  means do not wait for exit button to be
;           pressed.  Use with WID for to display help.
;         /WAIT  means wait for OK button without using xmanager
;           to register xhelp.  Will not drop through if button
;           is not pressed as in default case.
;         SAVE=file  If a file name is given a SAVE button is
;           added and the contents may be saved.  Given name is
;           used as the default.
;         GROUP_LEADER=grp  Assign a group leader to this
;           widget.  When the widget with ID group is destroyed
;           this widget is also.
;         XOFFSET=xoff, YOFFSET=yoff Widget position.
; OUTPUTS:
; COMMON BLOCKS:
; NOTES:
; MODIFICATION HISTORY:
;       R. Sterner, 29 Sep, 1993
;       R. Sterner, 18 Oct, 1993 --- Added LINES and event handler.
;       R. Sterner, 1994 Feb 21 --- Changed title text.
;       R. Sterner, 1994 Sep  7 --- Added /WAIT keyword.
;       R. Sterner, 1998 Jun  4 --- Added /NO_BLOCK to xmanager.
;       R. Sterner, 1998 Jul 27 --- Added SAVE=sv option.
;       R. Sterner, 2002 Jun 12 --- Minor help text fix.
;       R. Sterner, 2002 Jun 28 --- Added XOFFSET, YOFFSET.
;       R. Sterner, 2002 Oct 28 --- Added TID=tid, TTID=ttid, & /SCROLL keywds.
;       R. Sterner, 2003 Sep 23 --- Changed help to drop use /wait with save=sv.
;       R. Sterner, 2003 Oct 28 --- Minor help text change.
;       R. Sterner, 2004 Jan 08 --- Added XSIZE=xs.
;
; Copyright (C) 1993, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
	pro xhelp_event, ev
 
	widget_control, ev.id, get_uval=uval
 
	;------  Dismiss text display widget  ---------
	if uval eq 'DONE' then begin
	  widget_control, /dest, ev.top
	  return
	endif
 
	;------  Save text in a file  ------------------
	file = ''
	xtxtin, file, def=uval, title=['Save this text',' ',$
	  'Filename:'], /wait
	if file eq '' then return
	widget_control, ev.top, get_uval=txt
	putfile, file, txt	
	xmess,'Text saved in '+file
 
	end
 
;=============================================================
 
	pro xhelp, txt, title=title, lines=lines, exit_text=texit, $
	  wid=b0, group_leader=grp, help=hlp, nowait=nowait, wait=wait, $
	  save=fsave, xoffset=xoff, yoffset=yoff, tid=tid, $
	  scroll=scroll0, ttid=ttid, xsize=xsize
 
	if (n_params(0) lt 1) or keyword_set(hlp) then begin
	  print,' Widget to display given help text.'
	  print,' xhelp, txt'
	  print,'   txt = String array with help text to display.  in'
	  print,' Keywords:'
          print,'   TITLE=txt  title text or text array (def=none).'
	  print,'   LINES=lns maximum number of lines to display'
	  print,'     before added a scroll bar (def=30).'
	  print,'   XSIZE=xs Width of text area in characters (def=max needed).'
	  print,'   /SCROLL force scroll bars.  Useful if new text will'
	  print,'     displayed later.'
	  print,'   EXIT_TEXT=txt Exit button text (def=Quit help).'
	  print,'   WID=id  returned widget ID of help widget.  This'
	  print,'     allows the help widget to be automatically'
	  print,'     destroyed after action occurs.'
	  print,'   TID=tid returned widget ID of text area.  This'
	  print,'     allows text to be updated from outside this routine.'
	  print,'     widget_control,tid,set_val=new_text,xsize=xs,ysize=ys'
	  print,'     New x and y sizes may optionally be set.'
	  print,'   TTID=ttid returned widget ID of the title (-1 if no title).'
	  print,'     Title may be changed: widget_control,ttid,set_val=new'
	  print,'   /NOWAIT  means do not wait for exit button to be'
	  print,'     pressed.  Use with WID for to display help.'
          print,'   /WAIT  means wait for OK button without using xmanager'
          print,'     to register xhelp.  Will not drop through if button'
          print,'     is not pressed as in default case.'
	  print,'   SAVE=file  If a file name is given a SAVE button is'
	  print,'     added and the contents may be saved.  Given name is'
	  print,'     used as the default.'
	  print,'   GROUP_LEADER=grp  Assign a group leader to this'
	  print,'     widget.  When the widget with ID group is destroyed'
	  print,'     this widget is also.'
	  print,'   XOFFSET=xoff, YOFFSET=yoff Widget position.'
	  return
	endif
 
	if n_elements(texit) eq 0 then texit = 'Quit help'
	if n_elements(xsize) eq 0 then xsize=999
 
	;-------  Set up and display widget  --------
	if n_elements(lines) eq 0 then lines = 30
	b0 = widget_base(title=' ',/column,xoff=xoff,yoff=yoff)
	if n_elements(grp) ne 0 then widget_control, b0, group=grp
	nx = max(strlen(txt))<xsize
	ny = n_elements(txt)
	if ny gt lines then begin
	  ny = lines
	  scroll = 1
	endif else scroll=0
	if keyword_set(scroll0) then scroll=1	; Force scroll bars.
	if n_elements(title) ne 0 then begin
          for i=0, n_elements(title)-1 do ttid = widget_label(b0,val=title(i),/dynamic)
	endif else ttid=-1
	tid = widget_text(b0,value=txt,xsize=nx,ysize=ny,scroll=scroll)
	if not keyword_set(nowait) then begin
	  b1 = widget_base(b0,/row)
	  b11 = widget_button(b1,value=texit, uval='DONE')
	  if n_elements(fsave) ne 0 then $
	    id=widget_button(b1,value='Save text',uval=fsave)
	endif
	widget_control,/real,b0, set_uval=txt
 
        ;-------  Forced wait  ----------
        if keyword_set(wait) then begin
          widget_control, b11, /input_focus
          tmp = widget_event(b0)
          widget_control, /dest, b0
          return
        endif
 
	;--------  No wait  -----------
	if keyword_set(nowait) then return
 
        widget_control, b11, /input_focus
 
	xmanager, 'xhelp', b0, /no_block
 
	return
	end

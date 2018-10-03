;-------------------------------------------------------------
;+
; NAME:
;       XLIST
; PURPOSE:
;       Pop-up list selection widget.
; CATEGORY:
; CALLING SEQUENCE:
;       out = xlist(list)
; INPUTS:
;       list = string array of possible selections.  in
; KEYWORD PARAMETERS:
;       Keywords:
;         TITLE=txt  title text or text array (def=Select item).
;         MAXSCROLL=n Max allowed lines before scrolling list used
;           (def=20).
;         HIGHLIGHT=i Line to highlight (def=none).
;         TOP=j       Line to make be the top of the list.
;         INDEX=indx  Returned index of selected item.
;         /MULTIPLE   Allow multiple selections.
;         /SEARCH     Add a search entry area.
;         /WAIT  means wait for a selection before returning.
;           Needed if called from another widget routine.
; OUTPUTS:
;       out = selected element.                      out
;         Null if Cancel button pressed.
; COMMON BLOCKS:
; NOTES:
; MODIFICATION HISTORY:
;       R. Sterner, 11 Nov, 1993
;       R. Sterner, 2003 Dec 11 --- Added /MULTIPLE.
;       R. Sterner, 2004 Jun 24 --- Fixed OK with no selection.
;       Robert Mallozzi's dialog_list had some key clues.
;       R. Sterner, 2004 Aug 02 --- Added /SEARCH.
;
; Copyright (C) 1993, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 
;---------------------------------------------------------------------------
;	Event handler for search
;	Only triggered when search text changed.
;---------------------------------------------------------------------------
	pro xlist_srch, ev
 
	;-----  Grab search text  -----
	widget_control, ev.id, get_val=stxt
	stxt = strlowcase(stxt(0))	; Case ignored.
	n = strlen(stxt)
 
	;------  Grab list  -----------
	widget_control, ev.top, get_uval=s ; Grab info structure.
	if stxt eq '' then begin	; Null string sets to top.
	  widget_control, s.id_list, set_list_top=0
	  return
	endif
 
	;------  Search list  ---------
	list = strlowcase(s.list)	; Grab list, ignore case.
	w = where(stxt eq strmid(list,0,n), cnt)
 
	;------  Position list  -------
	if cnt eq 0 then return		; Ignore non-matches.
	widget_control, s.id_list, set_list_top=w(0)
 
	end 
 
 
;---------------------------------------------------------------------------
;	Event handler for single item
;---------------------------------------------------------------------------
	pro xlist_event, ev
 
	widget_control, ev.id, get_uval=cmd	; Get command.
	widget_control, ev.top, get_uval=s	; Get info.
 
	if cmd eq 'CANCEL' then begin		; CANCEL button.
	  widget_control, s.res, set_uval={t:'',i:0}	; Return null string.
	  widget_control, ev.top, /dest		; Destroy widget.
	  return
	endif
 
	;-----  Returned selected item  ------
	txt = s.list(ev.index)			; Selected list entry.
	widget_control, s.res, set_uval={t:txt,i:ev.index}	; Return it.
	widget_control, ev.top, /dest		; Destroy widget.
	return
 
	end 
 
 
;---------------------------------------------------------------------------
;	Event handler for multiple items
;---------------------------------------------------------------------------
	pro xlist_m_event, ev
 
	widget_control, ev.id, get_uval=cmd		; Get command.
	widget_control, ev.top, get_uval=s		; Get info.
 
	if cmd eq 'OK' then begin			; OK button.
	  in = widget_info(s.id_list, /list_select)	; Get indices selected.
	  if in(0) lt 0 then begin			; Same as cancel.
	    widget_control, s.res, set_uval={t:'',i:0}	; Return null string.
	  endif else begin
	    txt = s.list(in)				; Selected list items.
	    widget_control,s.res,set_uval={t:txt,i:in}	; Return them.
	  endelse
	  widget_control, ev.top, /dest			; Destroy widget.
	  return
	endif
 
	if cmd eq 'CANCEL' then begin			; CANCEL button.
	  widget_control, s.res, set_uval={t:'',i:0}	; Return null string.
	  widget_control, ev.top, /dest			; Destroy widget.
	  return
	endif
 
	end 
 
 
;===================================================================
;	xlist.pro = Pop-up list selection widget.
;===================================================================
 
	function xlist, list, title=title, help=hlp, maxscroll=maxs, $
	  index=indx, wait=wait, highlight=hi, top=ltop, $
	  xoffset=xoff, yoffset=yoff,multiple=mult, search=search
 
	if (n_params(0) eq 0) or keyword_set(hlp) then begin
	  print,' Pop-up list selection widget.'
	  print,' out = xlist(list)'
	  print,'   list = string array of possible selections.  in'
	  print,'   out = selected element.                      out' 
	  print,'     Null if Cancel button pressed.'
	  print,' Keywords:'
	  print,'   TITLE=txt  title text or text array (def=Select item).'
	  print,'   MAXSCROLL=n Max allowed lines before scrolling list used'
	  print,'     (def=20).'
	  print,'   HIGHLIGHT=i Line to highlight (def=none).'
	  print,'   TOP=j       Line to make be the top of the list.'
	  print,'   INDEX=indx  Returned index of selected item.'
	  print,'   /MULTIPLE   Allow multiple selections.'
	  print,'   /SEARCH     Add a search entry area.'
	  print,'   /WAIT  means wait for a selection before returning.'
	  print,'     Needed if called from another widget routine.'
	  return,''
	endif
 
	;--------  Set defaults  ------------
	if n_elements(maxs) eq 0 then maxs=20
	if n_elements(title) eq 0 then title = 'Select item'
 
	;--------  Set up widget  ----------------
	res = widget_base()		; Unused base for returned result.
	widget_control, res, set_uval=''
 
	top = widget_base(/column, title=' ',xoffset=xoff,yoffset=yoff)
 
	for i=0, n_elements(title)-1 do t = widget_label(top,val=title(i))
 
	;------  Exit button(s) ----------
	b = widget_base(top, /row)
	if keyword_set(mult) then t = widget_button(b, val='OK', uval='OK')
	t = widget_button(b, val='Cancel', uval='CANCEL')
 
	;-------  Search area  -------------
	if keyword_set(search) then begin
	  b = widget_base(top, /row)
	  id = widget_label(b,val='Search:')
	  id_srch = widget_text(b,xsize=10,/all_events,/editable, $
	    event_pro="xlist_srch")
	endif
 
	;-------  List  ------------
	id_list = widget_list(top, val=list, uval='LIST', $
	  ysize=n_elements(list)<maxs, multiple=mult)
 
	s = {res:res, id_list:id_list, list:list}
	widget_control, top, /real, set_uval=s
 
	if n_elements(hi) ne 0 then widget_control,lst,set_list_select=hi
	if n_elements(ltop) ne 0 then widget_control,lst,set_list_top=ltop
 
	;--------- Register  ---------
	if n_elements(wait) eq 0 then wait=0
 
	if keyword_set(mult) then begin
	  xmanager, 'xlist_m', top, modal=wait	; Use multi-item event handler.
	endif else begin
	  xmanager, 'xlist', top, modal=wait	; Use single item event handler.
	endelse
 
	;-----  Get returned result  ----------
	widget_control, res, get_uvalue=out
	indx = out.i
	txt = out.t
 
	return, txt
	end

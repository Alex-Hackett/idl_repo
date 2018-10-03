;-------------------------------------------------------------
;+
; NAME:
;       SWSHAKE
; PURPOSE:
;       Shake an swindow.
; CATEGORY:
; CALLING SEQUENCE:
;       swshake, in
; INPUTS:
;       in = window number to shake (def=current).  in
; KEYWORD PARAMETERS:
;       Keywords:
;         /HARD shake hard.
;         /INSIDE shake inside.
; OUTPUTS:
; COMMON BLOCKS:
; NOTES:
; MODIFICATION HISTORY:
;       R. Sterner, 2002 Aug 14
;
; Copyright (C) 2002, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
	pro swshake, in, hard=hard, inside=inside, help=hlp
 
	if keyword_set(hlp) then begin
	  print,' Shake an swindow.'
	  print,' swshake, in'
	  print,'   in = window number to shake (def=current).  in'
	  print,' Keywords:'
	  print,'   /HARD shake hard.'
	  print,'   /INSIDE shake inside.'
	  return
	endif
 
	;------  Get window widget IDs  --------
	b = swinfo(in,/base)
	d = swinfo(in,/draw)
 
	;------  Get position  ------------
	g = widget_info(b,/geometry)
	x0 = g.xoffset
	y0 = g.yoffset
 
	;-------  Amount  -----------------
	if keyword_set(hard) then begin
	  a = 200
	  n = 200
	endif else begin
	  a = 10
	  n = 50
	endelse
	dx = randomu(k,n)*a
	dy = randomu(k,n)*a
 
	;-------  In or out?  ---------------
	if keyword_set(inside) then begin
	  for i=0,n-1 do begin
	    widget_control, d, set_draw_view=[dx(i),dy(i)]
	    wait,.01
	  endfor
	endif else begin
	  for i=0,n-1 do begin
	    widget_control, b, xoff=x0+dx(i),yoff=y0+dy(i)
	    wait,.01
	  endfor
;	  widget_control, b, xoff=x0,yoff=y0
	endelse
 
	end

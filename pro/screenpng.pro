;-------------------------------------------------------------
;+
; NAME:
;       SCREENPNG
; PURPOSE:
;       Display a PNG image in a screen window.
; CATEGORY:
; CALLING SEQUENCE:
;       screenpng, [file]
; INPUTS:
;       file = name of PNG file.   in
; KEYWORD PARAMETERS:
;       Keywords:
;         MAG=mag     Magnification factor (def=1).
;           May be a 2 element array: [magx,magy].
;         /PIXMAP use a pixmap window.  convert_coord needs actual
;           window size to handle conversions to/from /dev.
;         /IWIN use an iwindow object for display.
;         WINDOW=win  Returned index of display window.
;         /NOEXECUTE  Set map scale without using execute.
;         ERROR=err   Returned error flag: 0=ok, 1=not displayed.
; OUTPUTS:
; COMMON BLOCKS:
; NOTES:
;       Notes: Prompts for file if called with no args.
;         Trys to do a map_set_scale and a set_scale
;         (assumes map scaling info is in the blue channel.)
; MODIFICATION HISTORY:
;       R. Sterner, 2001 Mar 21
;       R. Sterner, 2002 Jan 09 --- Allowed for 8-bit images.
;       R. Sterner, 2002 Mar 04 --- Worked around v5.3 png bug.
;       R. Sterner, 2002 Mar 14 --- Added MAG=mag keyword.
;       R. Sterner, 2002 Apr 03 --- Still dealing with v5.3 png bug.
;       R. Sterner, 2002 Apr 05 --- Added /PIXMAP option.
;       R. Sterner, 2002 Oct 09 --- Made window fit screen.
;       R. Sterner, 2003 Sep 24 --- Added /IWIN option.
;       R. Sterner, 2004 Mar 11 --- Added /NOEXECUTE option.
;
; Copyright (C) 2001, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
	pro screenpng, file, window=outwin, error=err, image=img, help=hlp, $
	  mag=mag, pixmap=pixmap, iwin=iwin, noexecute=noex
 
	if keyword_set(hlp) then begin
	  print,' Display a PNG image in a screen window.'
	  print,' screenpng, [file]'
	  print,'   file = name of PNG file.   in'
	  print,' Keywords:'
	  print,'   MAG=mag     Magnification factor (def=1).'
	  print,'     May be a 2 element array: [magx,magy].'
	  print,'   /PIXMAP use a pixmap window.  convert_coord needs actual'
	  print,'     window size to handle conversions to/from /dev.'
	  print,'   /IWIN use an iwindow object for display.'
	  print,'   WINDOW=win  Returned index of display window.'
	  print,'   /NOEXECUTE  Set map scale without using execute.'
	  print,'   ERROR=err   Returned error flag: 0=ok, 1=not displayed.'
	  print,' Notes: Prompts for file if called with no args.'
	  print,'   Trys to do a map_set_scale and a set_scale'
	  print,'   (assumes map scaling info is in the blue channel.)'
	  return
	endif
 
	if n_elements(mag) eq 0 then mag=1.
 
	if n_elements(file) eq 0 then begin
	  print,' '
	  print,' Display a png image in a screen window.'
	  file = ''
	  read,' Enter name of PNG file: ',file
	  if file eq '' then return
	endif
 
	;---------  Handle file name  -------------
	filebreak,file,dir=dir,name=name,ext=ext
	if ext eq '' then begin
	  print,' Adding .png as the file extension.'
	  ext = 'png'
	endif
	if ext ne 'png' then begin
	  print,' Warning: non-standard extension: '+ext
	  print,' Standard extension is png.'
	endif
	name = name + '.' + ext
	fname = filename(dir,name,/nosym)
 
	;--------  Read PNG file  -------------
	f = findfile(fname,count=c)
	if c eq 0 then begin
	  print,' PNG image not found: '+fname
	  err=1
	  return
	endif
	print,' Reading '+fname
	img = read_png(fname,rr,gg,bb)
 
	;---------  Correct for IDL 5.3 read_png bug  -----------
	if !version.release lt 5.4 then img=img_rotate(img,7)
 
	;---------  Resize  ---------------------
	img = img_resize(img, mag=mag)
 
	;---------  Display  --------------------
	img_shape, img, nx=nx, ny=ny, true=tr
	tt = fname+'  ('+strtrim(nx,2)+','+strtrim(ny,2)+')'
 
	;---------  Display image in an iwindow  --------
	if keyword_set(iwin) then begin
 
	  a = obj_new('iwindow',/menu,img)
	  a->set,title=tt
 
	endif else begin
	  ;---------  Pixmap window  -----------------------
	  if keyword_set(pixmap) then begin
	    window,xs=nx,ys=ny,/pixmap,/free
	  ;---------  Visible window  ----------------------
	  endif else begin
	    device, get_screen_size=ssz
	    xmx = ssz(0)*2./3.
	    ymx = ssz(1)*2./3.
	    if (nx gt xmx) or (ny gt ymx) then begin
	      swindow,xs=nx,ys=ny,x_scr=nx<xmx,y_scr=ny<ymx,titl=tt
	    endif else begin
	      window,/free,xs=nx,ys=ny,titl=tt
	    endelse
	  endelse
   
  	  outwin = !d.window
 
	  ;-----  Display image  ----------------------
	  if tr eq 0 then begin		; 8-bit image.
	    device,get_decomp=decomp
	    device,decomp=0
	    tvlct,rr,gg,bb		; Load color table.
	    tv,img			; Load image.
	    device,decomp=decomp
	  endif else begin		; 24-bit image.
	    tv, img, true=1
	  endelse
  
  	endelse
 
	set_scale, image=img, /quiet  	     	; Set scale.
	img_split, img, r,g,b,nx=nx		; Want blue channel.
	if nx ge 160 then begin
	  info = b(0:159,0)			; Grab info if there.
	  if keyword_set(noex) then begin
	    map_set_scale2, info=info,col=0	; Try to set map scale from b.
	  endif else begin
	    map_set_scale, info=info,col=0	; Try to set map scale from b.
	  endelse
	endif
 
	err = 0
	return
 
	end

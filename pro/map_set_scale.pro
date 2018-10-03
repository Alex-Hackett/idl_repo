;-------------------------------------------------------------
;+
; NAME:
;       MAP_SET_SCALE
; PURPOSE:
;       Set map scaling from info embedded in a map image.
; CATEGORY:
; CALLING SEQUENCE:
;       map_set_scale
; INPUTS:
; KEYWORD PARAMETERS:
;       Keywords:
;         NEWPOS=pos2  Give a new position array, overrides
;           existing position.  Good for resizing maps.
;           pos2 must be in device coordinates (not normalized).
;         SCALE_FACTOR=fact Correction factor for map scale.
;         COLOR=clr Color to override border color if any.
;         IMAGE=img  Give image array instead of reading it from
;           the display.
;         INFO=info Give the embedded info byte array instead of
;           reading it from the display or image.
;         /NOSET Do not set scaling.  Not very useful now.
;           OUT and /LIST cannot be used with /NOSET.
;         OUT=out  Scaling info returned as a structure.
;         /LIST  List values.
;         ERROR=err  Error flag: 0=ok, 1=no scaling info found.
; OUTPUTS:
; COMMON BLOCKS:
; NOTES:
;       Notes: Uses info embedded on bottom image line by
;       map_put_scale, if available. Does not use execute.
; MODIFICATION HISTORY:
;       R. Sterner, 1999 Sep 21 --- Original version.
;       R. Sterner, 2002 Jan 18 --- complete rewrite to work with map_set2.
;       R. Sterner, 2002 Jan 29 --- Added clip=0 flag.
;       R. Sterner, 2002 Feb 08 --- Added COLOR=clr for border.
;       R. Sterner, 2002 Feb 10 --- Returned pixels/degree in structure.
;       R. Sterner, 2002 Apr 02 --- Return map_set2 command from embedded info.
;       R. Sterner, 2002 Apr 05 --- Fixed for IMAGE=img case.
;       R. Sterner, 2002 Jul 03 --- Added map pixel size to returned structure.
;       R. Sterner, 2002 Jul 31 --- Added map central lat,long to list & struct.
;       R. Sterner, 2003 Sep 16 --- Added ERROR keyword.
;       R. Sterner, 2003 Oct 17 --- Fixed pix error when image array given.
;       R. Sterner, 2003 Oct 17 --- Also added central pixel.
;       R. Sterner, 2003 Nov 24 --- Correct image size error detection.
;       R. Sterner, 2004 Jan 15 --- Restored incoming window.
;       R. Sterner, 2004 Mar 12 --- Rewrite: Avoids using the execute command.
;       R. Sterner, 2004 May 27 --- Split off map_proj_name into its own file.
;       R. Sterner, 2004 May 27 --- Added OUT=out and /NOSET.
;       R. Sterner, 2004 Jul 22 --- Added /LIST. Also Fixed to deal with endian.
;
; Copyright (C) 1999, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
	pro map_set_scale, list=list, image=t0, info=info, color=pclr, $
	  newpos=newpos, scale_factor=fact, help=hlp, $
	  error=err1, out=out, noset=noset
 
	if keyword_set(hlp) then begin
	  print,' Set map scaling from info embedded in a map image.'
	  print,' map_set_scale'
 	  print,'   No args.'
	  print,' Keywords:'
	  print,'   NEWPOS=pos2  Give a new position array, overrides'
	  print,'     existing position.  Good for resizing maps.'
	  print,'     pos2 must be in device coordinates (not normalized).'
	  print,'   SCALE_FACTOR=fact Correction factor for map scale.'
	  print,'   COLOR=clr Color to override border color if any.'
	  print,'   IMAGE=img  Give image array instead of reading it from'
	  print,'     the display.'
	  print,'   INFO=info Give the embedded info byte array instead of'
	  print,'     reading it from the display or image.'
	  print,'   /NOSET Do not set scaling.  Not very useful now.'
	  print,'     OUT and /LIST cannot be used with /NOSET.'
	  print,'   OUT=out  Scaling info returned as a structure.'
	  print,'   /LIST  List values.'
	  print,'   ERROR=err  Error flag: 0=ok, 1=no scaling info found.'
 	  print,' Notes: Uses info embedded on bottom image line by'
	  print,' map_put_scale, if available. Does not use execute.'
	  return
	endif
 
	;=============================================================
	;	Make sure map coordinate info is embedded in image
	;=============================================================
	err1 = 1
	if n_elements(info) eq 0 then begin	; Info array not given.
	  if n_elements(t0) eq 0 then begin	; Image not given.
	    if !d.x_size lt 160 then return	  ; Image too small.
	    t0 = tvrd(true=3)			  ; Read image.
	    d_x_size = !d.x_size		  ; Window size (=current).
	    d_y_size = !d.y_size
	    wintxt = strtrim(!d.window,2)
	  endif else begin			; Image was given.
	    img_shape, t0, nx=d_x_size, ny=d_y_size	; Window size (=image).
	    if d_x_size lt 160 then return	; Image too small.
	    wintxt = 'image'
	  endelse
	  img_split, t0, r, g, b		; Split image into RGB.
	  t = b(0:159)			  	; Grab info from B.
	endif else begin			; Info array given.
	  t = info				; Copy info from given array.
	  d_x_size = !d.x_size		  	; Window size (=current).
	  d_y_size = !d.y_size
	  wintxt = strtrim(!d.window,2)
	endelse
	if n_elements(t) lt 160 then return	; Check size of info array.
	m = string(t(0:9))			; Data available flag.
	if m ne '1234567891' then return	; No map scaling info in image.
	err1 = 0
 
	;=============================================================
	;	Pick info out of byte array
	;
	;	Detect endian and swap if needed.
	;=============================================================
	nlim = long(t,40)	; This value is always 4 or rarely 8.
 
	if nlim gt 8 then swap_flag=1 else swap_flag=0	; Detect endian.
	if swap_flag then nlim=swap_endian(nlim)
 
	tmp = float(t,10,3) & if swap_flag then tmp=swap_endian(tmp)
	lat=tmp(0) & lon=tmp(1) & ang=tmp(2)
	flag_noborder = t(22)
	flag_iso = t(23)
	flag_col = t(24)
	if flag_col then begin
	  clr = long(t,25) & if swap_flag then clr=swap_endian(clr)
	endif else clr=!p.color
	flag_scale = t(29)
	scale = float(t,30) & if swap_flag then scale=swap_endian(scale)
	flag_azi = t(34)
	azi = float(t,35) & if swap_flag then azi=swap_endian(azi)
	flag_lim = t(39)
	lim = float(t,44,8) & if swap_flag then lim=swap_endian(lim)
	lim = lim(0:nlim-1)
	flag_par = t(76)
	std_par=float(t,77,2) & if swap_flag then std_par=swap_endian(std_par)
	flag_sat = t(85)
	sat_p = float(t,86,3) & if swap_flag then sat_p=swap_endian(sat_p)
	flag_ell = t(98)
	ellip = float(t,99,3) & if swap_flag then ellip=swap_endian(ellip)
	pos = float(t,111,4) & if swap_flag then pos=swap_endian(pos)
	proj = long(t,127) & if swap_flag then proj=swap_endian(proj)
	flag_clip = t(131)
 
	;=============================================================
	;	Deal with new POSITION if any
	;=============================================================
	if n_elements(newpos) eq 4 then begin
	  pos = float(newpos)/[!d.x_size,!d.y_size,!d.x_size,!d.y_size]
	endif
 
	;=============================================================
	;	Deal with map scale change.
	;=============================================================
	if n_elements(fact) gt 0 then begin
	  if flag_scale eq 1 then begin
	    scale = fact*scale
	  endif
	endif
 
	;=============================================================
	;	Deal with new color if any
	;=============================================================
	if n_elements(pclr) ne 0 then clr=pclr
 
	;=============================================================
	;	Do map_set command?
	;=============================================================
	if keyword_set(noset) then return
 
	;****************************************************************
	;	Use extracted info to set up map_set _extra structure
	;****************************************************************
	extra = {tmp:0}
	if flag_iso eq 1 then $			; /ISO
	  extra = create_struct(extra,'iso',1)
	if flag_noborder eq 1 then $		; /NOBORDER
	  extra = create_struct(extra,'noborder',1)
	if flag_clip eq 1 then $		; CLIP=0
	  extra = create_struct(extra,'clip',0)
	if flag_lim then $			; LIMIT=[...]
	  extra = create_struct(extra,'limit',lim)
	if flag_scale then $			; SCALE
	  extra = create_struct(extra,'scale',scale)
	if flag_azi then $			; CENTRAL_AZI
	  extra = create_struct(extra,'central_azi',azi)
	if flag_par then $			; Standard Parallels
	  extra = create_struct(extra,'standard_par',std_par)
	if flag_sat then $			; Satellite
	  extra = create_struct(extra,'sat_p',sat_p)
	if flag_ell then $			; Ellipsoid
	  extra = create_struct(extra,'ellips',ellip)
 
	;=============================================================
	;	Execute the map_set command
	;=============================================================
	map_set2,/noerase,lat,lon,ang,proj=proj,pos=pos,col=clr, _extra=extra
 
	;=============================================================
	;	Find some extra values if needed
	;=============================================================
	if arg_present(out) or keyword_set(list) then begin
	  ;=======================================
          ;       Extract some values
          ;=======================================
	  ix1 = pos(0)*d_x_size
	  ix2 = pos(2)*d_x_size & idx=ix2+0-ix1
	  iy1 = pos(1)*d_y_size
	  iy2 = pos(3)*d_y_size & idy=iy2+0-iy1
	  ix1 = round(ix1)	; Not sure if this should
	  ix2 = round(ix2)	; be fix() instead.
	  iy1 = round(iy1)
	  iy2 = round(iy2)
          ;=======================================
	  ;	Central map scale (pixels/degree)
	  ;	Also true central long, lat
          ;=======================================
	  ixmd=(ix1+ix2)/2. & iymd=(iy1+iy2)/2. & iyy1=iymd-10 & iyy2=iymd+10
	  tmp=convert_coord([ixmd,ixmd],[iyy1,iyy2],/dev,/to_data)
	  x=tmp(0,*) & y=tmp(1,*)
	  d = sphdist(x(0),y(0),x(1),y(1),/deg)
	  pix = 20/d
	  tmp=convert_coord(ixmd,iymd,/dev,/to_data)	; Long, Lat at
	  lon_cen=tmp(0,*) & lat_cen=tmp(1,*)		;   map center.
	  lon_cen=lon_cen(0) & lat_cen=lat_cen(0)
	endif
 
	;=============================================================
	;	Build scaling info structure to return
	;=============================================================
	if arg_present(out) then begin
	  out = { projection:map_proj_name(proj), projection_code:proj, $
	    lat:lat, lon:lon, ang:ang, $
	    lon_cen:lon_cen, lat_cen:lat_cen, $
	    ixmd:ixmd, iymd:iymd, $
	    iso_used:flag_iso, clip_used:flag_clip, $
	    noborder_used:flag_noborder, color_used:flag_col, color:clr, $
	    scale_used:flag_scale, scale:scale, central_azi_used:flag_azi, $
	    azi:azi, limit_used:flag_lim, limit:lim, $
	    stand_par_used:flag_par, parallels:std_par, $
	    satellite_par_used:flag_sat, sat_p:sat_p, $
	    ellipsoid_used:flag_ell, ellipsoid:ellip, $
	    position:pos, pix_deg:pix, idx:fix(idx), idy:fix(idy), $
	    ix:fix(ix1), iy:fix(iy1), nx:d_x_size, ny:d_y_size } 
	endif
 
	;=======================================
	;	List
	;=======================================
	if keyword_set(list) then begin
	  print,' '
          print,' Values set from embedded scaling (window = '+wintxt+'):'
          print,' '
	  print,' Map projection = ',map_proj_name(proj),' ('+$
	    strtrim(proj,2)+')'
	  print,' Reference lat, long = ',strtrim(lat,2),', ',strtrim(lon,2), $
	  '    Map angle = ',strtrim(ang,2)
	  print,' Map center lat, long = ',strtrim(lat_cen,2),$
	    ', ',strtrim(lon_cen,2)
	  txt = ''
	  if flag_noborder eq 0 then begin
	    txt=' Map Border of color = '+strtrim(clr,2)
	  endif else begin
	    txt=' No Map Border'
	  endelse
	  if flag_iso eq 1 then txt=txt+',   /ISO used' else $
	    txt=txt+',   No /ISO used'
	  if flag_clip eq 1 then txt=txt+',   CLIP=0 used' else $
	    txt=txt+',   No CLIP=0'
	  print,txt
	  if max(abs(lim)) eq 0 then begin
	    print,' No LIMIT used'
	  endif else begin
	    print,' LIMIT = ',strtrim(lim,2)
	  endelse
	  if flag_scale then print,' Scale = ',strtrim(scale,2)
	  if flag_azi then print,' Central_azi = ',strtrim(azi,2)
	  if flag_par then begin
	    print,' Standard parallels = ',strtrim(std_par,2)
	  endif
	  if flag_sat then begin
	    print,' Satellite parameters = ',strtrim(sat_p,2)
	  endif
	  ;------  Screen position  -----------
	  six1 = strtrim(fix(ix1),2)
	  six2 = strtrim(fix(ix2),2) & sidx=strtrim(fix(idx),2)
	  siy1 = strtrim(fix(iy1),2)
	  siy2 = strtrim(fix(iy2),2) & sidy=strtrim(fix(idy),2)
	  print,' Screen window: '+$
	    'ix1, ix2, iy1, iy2: '+six1+','+ six2+','+ siy1+','+siy2
	  print,'   position format: '+$
            'pos=['+six1+','+siy1+','+ six2+','+siy2+'],/dev'
          print,'   tvrd format:     a=tvrd('+$
            six1+','+siy1+','+ sidx+','+sidy+')'
          print,'   plots format:    plots,['+$
            six1+','+six2+','+six2+','+ six1+','+six1+'],['+$
            siy1+','+siy1+','+siy2+','+ siy2+','+siy1+'],/dev' 
          print,'   crop image:      a=tvrd('+$
            six1+','+siy1+','+ sidx+','+sidy+')'
          print,'                    swindow,xs='+sidx+',ys='+sidy+' & tv,a'
	  ;------  Central map scale (pixels/degree)  -------
	  print,' Map scale at center = '+strtrim(pix,2)+' pixels/degree'
	endif
 
	return
	end

;+
; NAME:
;	cross_section.pro
;
; PURPOSE:
;	This procedure extracts and displays a cross section of an image.
;
; CATAGORY:
;	Image analysis.
;
; CALLING SEQUENCE:
;	cross_section, image, p1x, p1y, p2x, p2y [, width, title_text]
;
; INPUTS:
;	image:	Image from which cross_section is to be extracted.
;	  p1x:	X-position of first endpoint.
;	  p1y:  Y-position of first endpoint.
;	  p2x:	X-position of second endpoint.
;	  p2y:  Y-position of second endpoint.
;
; OPTIONAL INPUTS:
;    	width:	Extraction width (default=1 pixel).
;  title_text:  String containing tile text.
;
; KEYWORDS:
;	  grl:  Set this keyword to the widget-ID# of the parent widget,
;		if called from another widget program. This keyword must be
;		set in IDL V5.0.
; OUTPUTS:
;	Procedure displays the cross_section via widget routine:
;	plot_popup.pro.
;
; RESTRICTIONS:
;	IDL Version 3.5 or later.
;
; MODIFICATION HISTORY:
;	Written by:	Terry Beck  ACC  November 4, 1994
;	Added messages text for FWHM measurement.  TLB   Sept. 14 1995
;       Added title_text optinal input.  TLB Sept 20, 1995.
;	Added button for fwhm measurement- output to PS. TLB  Sept 20, 1995
;	Changed popup title to "Cross Section"  TLB  12-27-95
;	Added yrange to call to rpower.  TLB  12-28-95
;	Added extraction width variable.  TLB  12-29-95
;	Ported to IDL V5.0.  TLB 6-4-97
;	ACS Verison. TLB Aug 24, 1998
;-
;_____________________________________________________________________________

pro cross_section, image, p1x, p1y, p2x, p2y, width, title_text, grl=grl

if (n_params(0) eq 5) then begin 
    width = 1
    title_text = ''
endif else $
if (n_params(0) eq 6) then begin
    title_text = ''
endif else $
if (n_params(0) lt 5) then begin
    print, 'CALLING SEQUENCE:'
    print, '	cross_section, image, p1x, p1y, p2x, p2y'
    print, ''
    print, 'OPTIONAL INPUTS:'
    print, '	width, title_text'
    print, ''
    print, 'KEYWORDS:'
    print, '	grl - required for IDL V5.0'
    print, ''
    retall
endif

hwidth = fix(width/2)

dy = p2y - p1y			
dx = p2x - p1x

if (dx ne 0) then begin					;no infinite slope
    m = dy/dx
endif else begin
    m = 0
endelse

if (abs(dx) ge abs(dy)) then begin			;c-s in x-direction
    x = intarr(abs(dx)+1)
    y = fltarr(abs(dx)+1)
    for n = 0, abs(dx) do begin				;make x & y arrays

	if (dx gt 0) then begin				;convert from IDL coord.
	    nn = p1x + n				;to image-x coord.
	endif else begin
	    nn = p2x + n				;if p1x gt cenx
	endelse

	x(n) = nn			
	ycoord = fix(m*(nn - p1x) + p1y)
	y(n) = total(image(nn,ycoord-hwidth:ycoord+hwidth))
    endfor
    xl = 'X'

endif else begin					;c-s in y-direction
    x = intarr(abs(dy)+1)
    y = fltarr(abs(dy)+1)
    for n = 0, abs(dy) do begin

	if (dy gt 0) then begin				;convert from IDL coord.
	    nn = p1y + n				;to image-y coord.
	endif else begin
	    nn = p2y + n
	endelse

	x(n) = nn

	if (dx ne 0) then begin				;no infinite slope
	    xcoord = fix((1/m)*(nn - p1y) + p1x)
	endif else begin
	    xcoord = p1x
	endelse

	y(n) = total(image(xcoord-hwidth:xcoord+hwidth,nn))
    endfor
    xl = 'Y'
endelse

sp1x = strcompress(string(fix(p1x)), /remove_all)
sp1y = strcompress(string(fix(p1y)), /remove_all)
sp2x = strcompress(string(fix(p2x)), /remove_all)
sp2y = strcompress(string(fix(p2y)), /remove_all)
scoord = '('+sp1x+','+sp1y+') -> ('+sp2x+','+sp2y+')'

swidth = strcompress(string(width), /remove_all)
tt = title_text + ' Cross section: ' + scoord + ' width: ' + $
    swidth + ' pixel(s)'
sb2 = 'Measure FWHM'
sb2_pro = 'acl_rpower, data_pars.x, data_pars.y, data_pars.type,'
sb2_pro = sb2_pro + ' data_pars.yrange, title=data_pars.extra.title'
tmp_text = 'Place cursor on feature(s) to be measured & click left.'
sb2_text = tmp_text + ' Click right to stop.

sb3 = 'Measure FWHM - output to PS'
sb3_pro = sb2_pro + ', /ps'
sb3_text = sb2_text + ' File: fwhm.ps'


junk = plot_popup(x,y, xtitle=xl, ytitle='counts', title=tt, $
    special_b2=sb2, b2_pro=sb2_pro, b2_text=sb2_text, special_b3=sb3, $ 
    b3_pro=sb3_pro, b3_text=sb3_text, ptitle='Cross Section', grl=grl)

return 
end

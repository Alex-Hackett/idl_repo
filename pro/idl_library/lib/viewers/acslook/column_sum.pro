;+
; NAME:
;	column_sum.pro
;
; PURPOSE:
;	This procedure sums and displays image columns.
;
; CATAGORY:
;	Image analysis.
;
; CALLING SEQUENCE:
;	column_sum, image, column1, column2, title_text [,outvect], $
;	    no_gui=no_gui
;
; INPUTS:
;	image:	Image from which column sum is to be computed.
;     column1:	First column to be summed.
;     column2:	Last column to be summed.
;
; OPTIONAL INPUTS:
;  title_text:  String containing title text.
;
; OUTPUTS:
;	Procedure displays the column sum via widget routine:
;	plot_popup.pro, unless the /no_gui keyword is set.
;
; OPTIONAL OUTPUTS:
;     outvect:	output vector.
;
; KEYWORDS:
;      no_gui:	Set this keyword to suppress the popup GUI.
;	  grl:  Set this keyword to the widget-ID# of the parent widget,
;		if called from another widget program. This keyword must be
;		set in IDL V5.0.
;
; RESTRICTIONS:
;	IDL Version 3.5 or later.
;
; MODIFICATION HISTORY:
;	Written by:	Terry Beck  ACC  November 4, 1994
;	-added messages text for FWHM measurement.  TLB   Sept. 14 1995
;	Added title_text optinal input.  TLB Sept 20, 1995.
;	Added button for fwhm measurement- output to PS. TLB  Sept 20, 1995
;	Changed popup title to "Column Sum"  TLB  12-27-95
;	Added yrange to call to rpower.  TLB  12-28-95
;	Added optional output vector & no_gui keyword.  TLB  4-4-96.
;	Ported to IDL V5.0.  TLB  6-4-97
;	ACS version.  TLB  24 Aug 98
;
;-
;_____________________________________________________________________________

pro column_sum, image, column1, column2, title_text, outvect, no_gui=no_gui, $
    grl=grl
    
if (n_params(0) lt 3) then begin
    print, 'CALLING SEQUENCE:'
    print, '	column_sum, image, column1, column2'
    print, ''
    print, 'OPTIONAL INPUTS:'
    print, '	title_text'
    print, ''
    print, 'OPTIONAL OUTPUTS:'
    print, '	outvect'
    print, ''
    print, 'KEYWORDS:'
    print, '	grl - required for IDL V5.0'
    print, ''
    retall
endif

if (n_params(0) eq 3) then title_text = ''

r1str = strcompress(string(long(column1)), /remove_all)
r2str = strcompress(string(long(column2)), /remove_all)

s = size(image)
ny = s(2)
x = indgen(ny)						;make x-vector

y = fltarr(ny)
for yy = 0, ny-1 do begin
    if (column1 gt column2) then begin
	y(yy) = total(image(column2:column1,yy))
	title = title_text + '   Sum of columns ' + r2str + ' thru ' + r1str
    endif else begin
        y(yy) = total(image(column1:column2,yy))
	title = title_text + '   Sum of columns ' + r1str + ' thru ' + r2str
    endelse
endfor

xl = 'Row (pixels)'
outvect = y

if not(keyword_set(no_gui)) then begin

    sb2 = 'Measure FWHM'
    sb2_pro = 'acl_rpower, data_pars.x, data_pars.y, data_pars.type,'
    sb2_pro = sb2_pro + ' data_pars.yrange, title=data_pars.extra.title'
    tmp_text = 'Place cursor on feature(s) to be measured & click left.'
    sb2_text = tmp_text + ' Click right to stop.

    sb3 = 'Measure FWHM - output to PS'
    sb3_pro = 'acl_rpower, data_pars.x, data_pars.y, data_pars.type,'
    sb3_pro = sb3_pro + ' data_pars.yrange, title=data_pars.extra.title, /ps'
    sb3_text = sb2_text + ' File: fwhm.ps'

    junk = plot_popup(x,y, xtitle=xl, ytitle='counts', title=title, $
    	special_b2=sb2, b2_pro=sb2_pro, b2_text=sb2_text, special_b3=sb3, $
    	b3_pro=sb3_pro, b3_text=sb3_text, ptitle='Column Sum', grl=grl)
endif

return 
end

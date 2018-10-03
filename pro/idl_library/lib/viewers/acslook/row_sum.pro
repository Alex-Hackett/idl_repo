;+
; NAME:
;	row_sum.pro
;
; PURPOSE:
;	This procedure sums and displays image rows.
;
; CATAGORY:
;	Image analysis.
;
; CALLING SEQUENCE:
;	row_sum, image, row1, row2
;
; INPUTS:
;	image:	Image from which row sum is to be computed.
;	 row1:	First row to be summed.
;	 row2:	Last row to be summed.
;
; OPTIONAL INPUTS:
;  title_text:  String containing tile text.
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
;	-added messages text for FWHM measurement.  TLB   Sept 14, 1995
;	Added title_text optinal input.  TLB Sept 20, 1995.
;	Added button for fwhm measurement- output to PS. TLB  Sept 20, 1995
;	Changed popup title to "Row Sum"  TLB  12-27-95
;	Added yrange to call to rpower.  TLB  12-28-95
;	Added optional output vector & no_gui keyword.  TLB  4-4-96.
;	Ported to IDL V5.0.  TLB  6-4-97
;	ACS Version. TLB Aug 24, 1998
;
;-
;_____________________________________________________________________________

pro row_sum, image, row1, row2, title_text, outvect, no_gui=no_gui, grl=grl

if (n_params(0) lt 3) then begin
    print, 'CALLING SEQUENCE:'
    print, '	row_sum, image, row1, row2'
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

r1str = strcompress(string(long(row1)), /remove_all)
r2str = strcompress(string(long(row2)), /remove_all)

s = size(image)
nx = s(1)
x = indgen(nx)						;make x-vector

y = fltarr(nx)						;make y-vector
for xx = 0, nx-1 do begin
   if (row1 gt row2) then begin
	title = title_text + '   Sum of rows ' + r2str + ' thru ' + r1str
	y(xx) = total(image(xx,row2:row1))
   endif else begin
	title = title_text + '   Sum of rows ' + r1str + ' thru ' + r2str
   	y(xx) = total(image(xx,row1:row2))
   endelse
endfor

xl = 'Column (pixels)'
outvect = y

if not(keyword_set(no_gui)) then begin

    sb2 = 'Measure FWHM'
    sb2_pro = 'acl_rpower, data_pars.x, data_pars.y, data_pars.type,'
    sb2_pro = sb2_pro + ' data_pars.yrange, title=data_pars.extra.title'
    tmp_text = 'Place cursor on feature(s) to be measured & click left.'
    sb2_text = tmp_text + ' Click right to stop.'

    sb3 = 'Measure FWHM - output to PS'
    sb3_pro = 'acl_rpower, data_pars.x, data_pars.y, data_pars.type,'
    sb3_pro = sb3_pro + ' data_pars.yrange, title=data_pars.extra.title, /ps'
    sb3_text = sb2_text + ' File: fwhm.ps'
 
    junk = plot_popup(x,y, xtitle=xl, ytitle='counts', title=title, $
    	special_b2=sb2, b2_pro=sb2_pro, b2_text=sb2_text, special_b3=sb3, $
    	b3_pro=sb3_pro, b3_text=sb3_text, ptitle='Row Sum', grl=grl)

endif

return 
end

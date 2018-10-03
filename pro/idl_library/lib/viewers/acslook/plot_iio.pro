;+
; NAME:
;	plot_iio
;
; PURPOSE:
;	To create a semi-log plot with a y-axis range that extends down to zero.
;	Portion of y-axis from 10 to zero is linear. This is primarily intended
;	to plot histograms in which some bins may a zero value.
;
; CALLING SEQUENCE:
;	plot_iio, [x,] y
;
; INPUTS:
;	    x:	A vector argument. If x is not specified, y is plotted as a
;		function of point number.
;	    y:	The ordinate vector to be plotted.
;
; KEYWORD PARAMETERS:
;	   ps:	Set this keyword to send the output to a postscript file.
;	See description of plot for the list of other accepted keywords.
;
; OPERATIONAL NOTES:
;	Program breaks up the plot in two.
;
; RESTRICTIONS:
;	All values in the y vector must be non-negative.
;	Maximum value plotted is 10^11.
;
; MODIFICATION HISTORY:
;	Written by:	Terry Beck	ACC/GSFC	October 11, 1994
;	12-7-94  TLB  Fixed bug that doesn't allow a ytitle to be printed.
;	2-22-95  TLB  Fixed bug that crashes program if no keywords given.
;-
;_____________________________________________________________________________

pro plot_iio, xx, yy, _extra=extra, ps=ps

case n_params() of				;x-vector given?
    1: begin
	y = xx
	x = indgen(n_elements(y))
	end
    2: begin
	y = yy & x = xx
	end
    else: begin
	print, "CALLING SEQUENCE:"
	print, "	plot_iio, [x,] y"
	retall
	end
endcase

yn = ['0', '10!E1!x', '10!E2!x', '10!E3!x', '10!E4!x', '10!E5!x', '10!E6!x', $
    '10!E7!x', '10!E8!x', '10!E9!x', '10!E10!x', '10!E11!x']
blank = [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
set_viewport, 0.1, 0.95, 0.15, 0.9

gt10 = where(y gt 10)
ygt10 = y
ygt10(gt10) = alog10(y(gt10))*10		;take log of points > 10

if (keyword_set(ps)) then begin
    set_plot, 'ps'
    device, /landscape
endif
    
plot, x, ygt10, ystyle=4, ytick_get = ytck, xstyle=1, _extra=extra

; test for ytitle in the 'extra' structure because plot command above will not
; print it - (ystyle=4 suppresses the axis).

if (n_elements(extra) ne 0) then begin
    tags = tag_names(extra)				
    junk = where(tags eq 'YTITLE',ct)		;check for existance of tag
    if (ct ne 0) then $
   	xyouts, 0.05, 0.5, extra.ytitle, /normal, $
	    alignment=0.5, orientation=90
endif

nytck = max(ytck)/10
axis, yaxis=0, yticks=nytck, ytickname=yn
axis, yaxis=1, yticks=nytck, ytickname=blank

;make minor ticks for linear portion of the plot ******************************

cutoff =  0.75/float(nytck) +0.15			
spacing = (cutoff - 0.15)/5.0			
yinterval = findgen(5)*spacing + 0.15
for n = 0, 4 do begin
    plots, [0.1,0.108], [yinterval(n),yinterval(n)], /normal
    plots, [0.942, 0.95], [yinterval(n),yinterval(n)], /normal
endfor

;make minor ticks for logarithmic portion of the plot *************************

logticks = alog10(findgen(10) + 1.0)		
stepsize = 0.75/float(nytck)			;
steps = findgen(nytck-1)*stepsize + cutoff
for m = 0, nytck-2 do begin
    ylogtck = logticks*stepsize + steps(m)
    for n = 0, 9 do begin
        plots, [0.1,0.108], [ylogtck(n), ylogtck(n)], /normal
        plots, [0.942,0.95], [ylogtck(n), ylogtck(n)], /normal
    endfor
endfor

if (keyword_set(ps)) then begin
    device, /close
    set_plot, 'x'
endif

!x.range=0

return
end



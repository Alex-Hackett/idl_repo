pro lineplot_file,filename,no_offset=no_offset
;+
;				lineplot_file
;
; Routine to plot FITS file previously written by lineplot.
;
; CALLING SEQUENCE:
;	lineplot_file
;	    or
;	lineplot_file,filename
; INPUTS:
;	filename - name of the file.  If not supplied, use will be interactively
;		asked to select it.
;
; OPTIONAL KEYWORD INPUTS:
;	/no_offset - do not load x and y offsets and y scale factor.
;
; HISTORY:
;	version 1, D. Lindler, Nov 2005.
;-
;----------------------------------------------------------------------------------
;
; get file if not supplied
;
	if n_params(0) eq 0 then $
		filename = dialog_pickfile(/must_exist,filter='*.fits')
	if filename eq '' then return
;
; read first extension
;
	a = mrdfits(filename,1,h)
	n = sxpar(h,'nspectra')>1
	ptitle = sxpar(h,'ptitle')
	xtitle = sxpar(h,'xtitle')
	ytitle = sxpar(h,'ytitle')
	if keyword_set(no_offset) then begin
		xoffset = 0.0
		yoffset = 0.0
		yscale = 1.0
	end
;
; loop on extensions
;
	for i=1,n do begin
		a = mrdfits(filename,i)
		if not keyword_set(no_offset) then begin
			xoffset = a.xoffset
			yoffset = a.yoffset
			yscale = a.yscale
		end
		lineplot,a.x,a.y,ptitle=ptitle,xtitle=xtitle,ytitle=ytitle, $
			xoffset=xoffset,yoffset=yoffset,yscale=yscale, $
			title=a.title
	end
end
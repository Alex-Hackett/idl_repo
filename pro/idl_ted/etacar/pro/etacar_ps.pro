;+
;			etacar_ps
;
; Routine to make postcript image of an echelle etacar extended source
; extraction file.
;
; CALLING SEQUENCE:
;	etacar_ps,id
;
; INPUTS:
;	id - observation id number
;
; OPTIONAL KEYWORD INPUT:
;	colortab = color table number
;	/linear = log intensity scaling (default = log)
;	/hist = histogram equalization scaling (default = log)
;	dmax = maximum intensity displayed (default = max of data)
;	dmin = minimum value (default = 0.0 except for log where dmin=dmax/1e5)
;	/ESO - specifies processing of ESO data
; OUTPUTS:
;	creates postscript file <id>.ps
;
; HISTORY
; 	Version 1, D. Lindler, Sept. 16, 2003
;	Oct. 2004, added /ESO option
;-
;----------------------------------------------------------------
pro etacar_ps,id,colortab=colortab,linear=linear,dmax=dmax,hist_eq=hist_eq, $
	dmin=dmin,eso=eso, sqrt=sqrt

	if n_elements(colortab) eq 0 then colortab=3
	
	if keyword_set(ESO) then begin
		read_eso,id,h,w,f
		eso_split,m,w,f
		title = strtrim(id,2)+' '+strtrim(sxpar(h,'origin'),2)+' '+ $
			strtrim(sxpar(h,'date'),2)
	  end else begin
	    	read_extended,id,h,m,w,f
	    	title = strtrim(id,2)+' '+strtrim(sxpar(h,'targname'))+' '+ $
		    	strtrim(sxpar(h,'opt_elem'))+' '+ $
			strtrim(sxpar(h,'aperture'))+'  '+ $
			strtrim(sxpar(h,'tdateobs'))
	end
	n = n_elements(m)	;number of orders
;
; determine data range
;
	if n_elements(dmax) eq 0 then dmax = max(f)
	if n_elements(dmin) eq 0 then begin
		dmin = dmax/1e5
		if keyword_set(linear) then dmin = 0
		if keyword_set(hist_eq) then dmin = 0
		if keyword_set(sqrt) then dmin = 0
	end
;
; bin to lores in the dispersion direction
;
	s = size(f) & ny = s(2) & nx = s(1)/2
	w = rebin(w,nx,n)
	f = rebin(f,nx,ny,n)
;
; scale image
;
	if keyword_set(linear) then begin
		fscale = f
		fmin = dmin
		fmax = dmax
	end else if keyword_set(hist_eq) then begin
		fscale = hist_equal(f,minv=dmin,maxv=dmax)
		fmin = 0
		fmax = 255
	end else if keyword_set(sqrt) then begin
		fscale = sqrt(f>dmin<dmax)
		fmin = sqrt(dmin)
		fmax = sqrt(dmax)
	end else begin
		fscale = alog10(f>dmin<dmax)
		fmin = alog10(dmin)
		fmax = alog10(dmax)
	end
;
; set up postscript file
;
	nperpage = 10
	y_per_plot = 0.95/nperpage	;y inches per order
	set_plot,'ps'
	device,/land,/color,bits=8,xoff=0.5,yoff=10.5,xsize=10,ysize=7.5, $
		file=strtrim(id,2)+'.ps',/inches
	loadct,colortab
	!P.font = 0
	!p.title = ''
;
; loop on orders
;
	for i=0,n-1 do begin
;
; new page?
;
		if (i mod nperpage) eq 0 then begin
			if i ne 0 then erase
			xyouts,0.5,0.96,title,/norm,charsize=1.3,align=0.5
		end
;
; set plot position
;
		y2 = 0.95 - y_per_plot*(i mod nperpage)
		y1 = y2 - y_per_plot*0.65
		x1 = 0.05
		x2 = 1.0
		set_viewport,x1,x2,y1,y2
;
; display order
;
		image = bytscl(fscale(*,*,i),min=fmin,max=fmax)
		tv,image,x1,y1,xsize=(x2-x1),ysize=(y2-y1),/norm
;
; overplot x axis
;
		plot,w(*,i),w(*,i)*0,/nodata,xstyle=1,ystyle=5,xticklen=-0.06, $
				/noerase,xcharsize=0.7,xthick=3
		xyouts,0.025,y1+y_per_plot*0.3,strtrim(m(i),2),/norm,align=0.5
	end

	device,/close
	set_plot,'x'
	set_viewport
end

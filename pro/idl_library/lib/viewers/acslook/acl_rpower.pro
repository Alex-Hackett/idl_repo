pro acl_rpower, wave, flux, type, yrange, width=width, sigma=sigma, ps=ps, $
    title=title
;+
;		acl_rpower
;
;	Subroutine of ACSLOOK to compute spectral line widths.
;
; INPUTS:
;	wave
;	flux
;	type - type of plot, linear, log, or log down to 10, then linear
;	    from 10 to zero.
;	yrange - yrange of plot.
;	width = width of region to fit
;	sigma = intial guess for sigmas
;	ps = send little plots to postscript file
;
; HISTORY:
;	Modified to restore !p.font after completion 5-1-94 TLB
;	Special modified version for stislook.  9-20-95  TLB
;	Changed baseline computation technique.	10-4-95   TLB
;	Changed fit plotting to start at y=0.  10-8-95	TLB
;	Added yrange input.  12-28-95  TLB
;	Program now checks for sufficient data width before attempting
;	   to extract profile.  2-5-96  TLB
;	User can now input PS filenames. Write perm. is checked. TLB 2/14/96
;	Added /down keyword to cursor call to prevent repeats.  TLB  3/26/96
;	Added central position of feature(s) to output plots. TLB 5/29/97
;	Modified to handle very small flux values.  TLB  7/17/98
;	ACS version. TLB  24 Aug 98
;-
;------------------------------------------------------------------

font_tmp = !p.font

	if n_elements(width) eq 0 then width = 17
	if n_elements(sigma) eq 0 then sigma = 1.0
	if n_elements(ps) eq 0 then ps=0
	if n_elements(title) eq 0 then title=''
	hwidth = width/2
	width = hwidth*2+1
	x = findgen(width)
	x3 = findgen(width*3+1)/3.0
;
; arrays for results
;
	inum = intarr(100)
	sig = fltarr(100)		;sigmas of fit
	cenp = fltarr(100)
	base = fltarr(100)		;baseline of fit
	fits = fltarr(width*3+1,100)	;fits
	wsave = fltarr(width,100)	;wavelength vectors for each line
	fsave = fltarr(width,100)	;flux vectors for each line
	n = 0
;
; plot spectrum
;
	!p.multi=0
	set_viewport
	nspec = n_elements(flux)/n_elements(flux(*,0))
	case type of
	    0: plot,wave(*,0),flux(*,0), yrange=yrange, title=title
	    1: plot_io,wave(*,0),flux(*,0), title=title
	    2: begin
		plot_iio,wave(*,0),flux(*,0), title=title
		set_viewport
	       	end
	endcase
	ispec = 0
;
; loop on lines
;
start_loop:
	print,'ready'
	cursor,ww,yy,/down,/data		;read line position
	wait,0.1
print,!err,hwidth
	if !err ne 1 then goto,done_ispec
	tabinv,wave(*,ispec),ww,index		;determine index of line
	index = fix(index(0)+0.5)
;
; extract line profile
;
	i1 = index-hwidth
	i2 = index+hwidth
	ss = size(flux)
	if (i1 lt 0 or i2 ge ss(1)) then begin
	    print, 'Not enough data to extract profile.'
	    print, 'Extract a wider cross-section.'
	    goto, start_loop
	endif
	profile = flux(i1:i2,ispec)
	pmax = max(profile)
	if ( pmax lt 1e-5) then profile = profile/pmax
	wsave(*,n) = wave(i1:i2,ispec)
	fsave(*,n) = profile		
	inum(n) = ispec
;
; determine baseline
;
	sprofile = sort(profile)
	baseline = avg(profile(sprofile(0:3)))
	base(n) = baseline
;
; fit gaussian to profile minus baseline
;
	pmax = max(profile)
	coef = [pmax,!c,sigma]		;initial guess
	fit = curfit(x,profile-baseline,'funct_gauss',coef,[0,1,2])
	sig(n) = coef(2)
	cenp(n) = coef(1) + i1
	funct_gauss,x3,coef,sfit
	fits(*,n) = sfit + baseline
	n = n+1
	goto,start_loop
;
; go do next spectrum
;
done_ispec:
	ispec = ispec+1
	if ispec eq nspec then goto,done_loop
	plot,wave(*,ispec),flux(*,ispec)
	goto,start_loop
done_loop:
;
; plot fits
;
	if ps then begin
		picktitle = ' Name the output postscript file '
		outfile = pickfile( title=picktitle, file='fwhm.ps')

		goodfile = 0
		if (outfile ne '') then begin
			openw, unit, outfile, error=err, /get_lun
			if (err eq 0) then begin
				goodfile=1
				close, unit
			endif else begin
				goodfile=0
				message = ['Error opening output file:', $
					'No write permission - operation aborted.'] 
				junk = widget_message(message, /error)
			endelse
		endif
		
		if (goodfile eq 0) then goto, forget_it
		
		!x.thick=3
		!y.thick=3
		!p.thick=3
		set_plot,'ps'
		device,/land
		device, file=outfile
		!p.charsize=0
		!p.font=0
	end

	!p.multi=[0,3,3]
	set_xy
	for i=0,n-1 do begin
		if i mod 9 eq 0 then !mtitle=title else !mtitle=''
		w = wsave(*,i)
		w3 = interpol(w,x,x3)
		plot,w3,fits(*,i), yrange=[0,max(fits(*,i))]	;plot fit
		oplot,[w(0),w(width-1)],[base(i),base(i)],line=1
		oplot,w,fsave(*,i),psym=4		;overplot data
;
; print fwhm
;
		fwhm = strtrim(string(sig(i)*2.3548,'(F5.1)'),2)
		scenp = strtrim(string(cenp(i),'(F6.1)'),2)
		strr = fwhm + '  ' + scenp
		xpos = !x.crange(0) + (!x.crange(1)-!x.crange(0))/8
		ypos = !y.crange(1) - (!y.crange(1)-!y.crange(0))/8
		xyouts,xpos,ypos,strr,/data
	end
	
	if ps then begin
		!x.thick=0
		!y.thick=0
		!p.thick=0
		device,/close
		set_plot,'x'
	endif

forget_it:

!p.font=font_tmp
!p.multi = 0
return
end

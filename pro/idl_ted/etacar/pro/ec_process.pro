pro ec_process,id,idwave,yshift=yshift,theta=theta,no_calstis=no_calstis, $
	show_plots=show_plots
;
; Routine to perform echelle extended source extractions
;
;
; process observation in hires mode
;
	if keyword_set(show_plots) then begin
		trace = '1'
		noplot = 0
	    end else begin
	    	trace = '0'
		noplot = 1
	end
	if not keyword_set(no_calstis) then begin
		calstis,id,'hires=1,outimage=def,trace='+trace, $
			autowave=idwave,noplot=noplot
		echelle_scat,id,/model
	end
	
	if n_elements(yshift) eq 0 then yshift = 0.0
	if n_elements(theta) eq 0 then theta = 0.0
	xshifts = fltarr(35)+(findgen(35)-17)*tan(theta/!radeg)


	echelle_extended,id,xshifts,h,m,w,f,q,err,yshift=yshift

	fits_open,'extended_'+strtrim(id,2)+'.fits',fcb,/write
	fits_write,fcb,f,h,extname='FLUX'
	fits_write,fcb,q,h,extname='DQ'
	fits_write,fcb,err,h,extname='ERR'
	fits_write,fcb,w,h,extname='W'
	fits_write,fcb,m,h,extname='M'
	fits_close,fcb
end



;;;	readcol,'stislog.txt',ids,idw,format='L,L'
;;;	for i=0,n_elements(ids)-1 do process,ids(i),idw(i)
;;;	ids =  [100341]
;;;	for i=0,n_elements(ids)-1 do process,ids(i)
;;; end

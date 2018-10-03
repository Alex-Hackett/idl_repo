pro echelle_extended,id,xshifts,himage,m,w,f,eps,err,yshift=yshift
	if n_elements(yshift) eq 0 then yshift = 0.0
;
; read image
;
	st_id = strtrim(id,2)
	fits_read,'im_'+st_id+'.fits',image,himage
	fits_read,'im_'+st_id+'.fits',dq,exten=2
	fits_read,'im_'+st_id+'.fits',err,exten=3
	fits_read,'model_'+st_id+'.fits',scat,exten=2
	scat = rebin(scat,2048,2048)
	image = image-scat	;scattered light corrected image
;
; read calstis spectrum
;
	a = mrdfits('spec_'+st_id+'.fits',1,h)
	nm = n_elements(a)
	m = a.order
	w = a.wavelength
	sback = (a.gross-a.net)/sxpar(h,'gwidth') ;background per pixel
	y = a.position
;
; perform extended source extraction
;
	out = fltarr(2048,nm,35)
	qout = fltarr(2048,nm,35)
	eout = fltarr(2048,nm,35)
	x = findgen(2048,nm) mod 2048
	for i=0,34 do begin
		calstis_bilinear,image,dq,err,x+xshifts(i),y+(i-17)+yshift, $
				fout,eps_out,err_out,eps_missing=255
		out(*,*,i) = fout
		qout(*,*,i) = eps_out
		eout(*,*,i) = err_out
	end
;
; reorder
;
	f = fltarr(2048,35,nm)
	err = fltarr(2048,35,nm)
	eps = fltarr(2048,35,nm)
	
	for i=0,nm-1 do begin
		f(*,*,i) = reform(out(*,i,*),2048,35)
		err(*,*,i) = reform(eout(*,i,*),2048,35)
		eps(*,*,i) = reform(qout(*,i,*),2048,35)
	end
return
end

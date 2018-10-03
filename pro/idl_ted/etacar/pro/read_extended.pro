pro read_extended,id,h,m,w,f,eps,err
;
; routine to read echelle extended files made by process.pro
;
	file = (find_with_def('extended_'+strtrim(id,2)+'.fits', $
			'ETACAR_ECHELLE'))[0]
	if file eq '' then begin
		print,'extended extraction file not found in ETACAR_ECHELLE'
		retall
	end

	fits_open,file,fcb

	fits_read,fcb,f,h,extname='FLUX'
	fits_read,fcb,w,extname='W'
	fits_read,fcb,m,extname='M'
	if n_params(0) gt 5 then fits_read,fcb,eps,extname='DQ'
	if n_params(0) gt 6 then fits_read,fcb,err,extname='ERR'
	fits_close,fcb
	sxaddpar,h,'entry',id
return
end

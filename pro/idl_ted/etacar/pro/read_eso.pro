;
; Splits ESO data into Pseudo orders
;
pro eso_split,m,w,f

	s = size(f) & ns = s(1) & nl = s(2)
	nm = (ns + 999)/950
	m = indgen(nm)
	wsplit = dblarr(1000,nm)
	fsplit = fltarr(1000,nl,nm)
	for i=0L,nm-1 do begin
		i1 = i*950
		i2 = (i1 + 999) < (ns-1)
		if i2 gt i1 then begin
			wsplit(0,i) = w(i1:i2)
			fsplit(0,0,i) = f(i1:i2,*)
		end
	end
	f = temporary(fsplit)
	w = temporary(wsplit)
	bad = where(w le 0,nbad)
	if nbad gt 0 then w(bad) = (dindgen(nbad)+1)*(w(1)-w(0)) + max(w) 
end
;
; Reads Eso data
;
pro read_eso,id,h,w,f,xshift=xshift
	location = getenv('ETACAR_ESO')
	file = (findfile(location +'/*/' + id))[0]
	if file eq '' then begin
		print,'File '+id+' not found in ETACAR_ESO='+location
		retall
	end
	fits_read,file,f,h
	s = size(f) & ns = s(1) & nl = s(2)
	if n_elements(xshift) gt 0 then begin
		ishift = round(xshift)
		while ishift lt 0 do ishift=ishift+1000
		if ishift ne 0 then f = [fltarr(ishift,nl),f]
		ns = ns+ishift
	end else ishift = 0

	x = dindgen(ns)+1
	w = (x - sxpar(h,'CRPIX1')-ishift)*sxpar(h,'cdelt1') + sxpar(h,'crval1')
	
	print,file
	sxaddpar,h,'entry',id
end	

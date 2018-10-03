pro etacar_extract,id,line1,line2, eso=eso
;+
;			etacar_extract
;
; Routine to extract and flux calibrate spectra between selected spatial
; positions in Eta Carinae echelle extended source files created by
; process_etacar.pro
;
; CALLING SEQUENCE:
;	etacar_extract,id,line1,line2
;
; INPUTS:
;	id - observation id
;	line1 - first spatial position line number
;	line2 - second spatial position line number
;
; OUTPUTS:
;	FITS binary table ext_<id>_<line1>_<line2>.fits is created
;	with columns:
;		WAVELENGTH
;		FLUX
;		EPSF
;		ERRF
; KEYWORD INPUTS:
;	/ESO - set if reading ESO data files
;
; HISTORY
; 	version 1, D. Lindler, August 2003
;	Oct 2004, added ESO option
;-
;--------------------------------------------------------------------------

	if n_params(0) lt 1 then begin
		print,'CALLING SEQUENCE: etacar_extract,id,line1,line2'
		return
	end
;
; read input observation
;
	if keyword_set(eso) then begin
		read_eso,id,h,w,f
		s = size(f) & ns = s(1) & ny = s(2)
	    end else begin
		read_extended,id,h,m,w,f,eps,err
		s = size(f) & ns = s(1) & ny = s(2) & norders = s(3)
		filename = 'newspec_'+strtrim(id,2)+'.fits'
		file = (find_with_def(filename,'ETACAR_ECHELLE'))[0]
		if file eq '' then begin
			print,filename + ' not found in ETACAR_ECHELLE directory'
			retall
		endif
		a = mrdfits(file,1,h)
	end
;
; check range of lines
;
	if (line2 lt line1) then begin
	    print,'ERROR: etacar_compare - line2 must be greater then line1'
	    retall
	end
	
	if (line1 lt 0) then begin
	    print,'ERROR: etacar_compare - line1 must be greater then 0'
	    retall
	end
	
	if (line2 ge ny) then begin
	    print,'ERROR: etacar_compare - line2 must be less then '+ $
	    		strtrim(ny,2)
	    retall
	end
;
; extract spectrum, data quality, and errors 
;
	if keyword_set(eso) then begin
		wout = temporary(w)
		fout = total(f(*,line1:line2),2)
		errout = fout*0
		epsout = fix(errout)
	   end else begin
		net = total(f(*,line1:line2,*),2)
		var = err^2	
		errf = sqrt(total(var(*,line1:line2,*),2))
		epsf = bytarr(ns,norders)
		for i=line1,line2 do epsf = epsf > eps(*,i,*)
		epsf(0:20,*) = 155
		epsf(2027:*,*) = 155
;
; surface brightness units
;
		net = net/(line2-line1+1)
		errf = errf/(line2-line1+1)
;
; flux calibrate
;
	
		sxaddpar,h,'surfaceb',1
		sxaddpar,h,'extended',1
		calstis_abs,h,m,w,net,errf,epsf,flux,a.position
;
; merge data
;
		smerr = errf
		for i=0,norders-1 do smerr(0,i) = smooth(errf(*,i),11)
		bad = where(smerr eq 0,nbad)
		if nbad gt 0 then smerr(bad) = max(smerr)
		hrs_merge,w,flux,epsf,errf,badeps=150,wout,fout,epsout,errout, $
			weights = 1/smerr^2,/interp
		good = where(wout gt 1150)
		wout = wout(good)
		fout = fout(good)
		errout = errout(good)
		epsout = epsout(good)
	end
;
; write results
;
	sxaddpar,h,'id',id
	sxaddpar,h,'line1',line1
	sxaddpar,h,'line2',line2
	sxdelpar,h,'nextend'
	sxdelpar,h,'tform'+strtrim(indgen(30)+1,2)
	sxdelpar,h,'ttype'+strtrim(indgen(30)+1,2)
	sxdelpar,h,'tdim'+strtrim(indgen(30)+1,2)
	sxdelpar,h,'comment'

	idout = id
	if keyword_set(eso) then begin
		sxaddpar,h,'xtension','BINTABLE',after='SIMPLE'
		sxdelpar,h,'simple'
	end		
	if datatype(id) eq 'STR' then fdecomp,id,disk,dir,idout
	
	name = 'ext_'+strtrim(idout,2)+'_'+ $
			strtrim(line1,2)+'_'+strtrim(line2,2)+'.fits'

	mwrfits,{wavelength:wout,flux:fout,epsf:epsout,errf:errout},name,h, $
			/create
end

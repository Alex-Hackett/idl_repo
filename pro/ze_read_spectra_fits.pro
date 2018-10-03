PRO ZE_READ_SPECTRA_FITS,file,lambda,flux,header,nrec

;  If no file specified, use DIALOG_PICKFILE
;
if (n_elements(file) eq 0) then begin
  file = DIALOG_PICKFILE(/MUST_EXIST)
  ;if (file eq '') then RETURN, 0
endif

;le fits
flux=mrdfits(file,0,header)
crval1=fxpar(header,'CRVAL1')
cdelt1=fxpar(header,'CDELT1')
s=size(flux)
nrec=s[1]
lambda=dblarr(nrec) & fluxd=lambda & lambda2=lambda
for k=0., nrec-1 do begin
lambda[k]=crval1 + (k*cdelt1)
endfor

END
;--------------------------------------------------------------------------------------------------------------------------

;le fits
flux=mrdfits('/home/groh/espectros/agcar/291b_fuv_isabs2020.fits',0,header)
;obsflux=mrdfits('/home/groh/espectros/agcar/agc89dec23_swp37882_merge.fits',0,header2)
crval1=fxpar(header,'CRVAL1')
cdelt1=fxpar(header,'CDELT1')
;crval2=fxpar(header2,'CRVAL1')
;cdelt2=fxpar(header2,'CDELT1')
;t=size(obsflux)
s=size(flux)
lambda=dblarr(s[1]) & fluxd=lambda & lambda2=lambda
for k=0., s[1]-1 do begin
lambda[k]=crval1 + (k*cdelt1)
endfor

;for i=0., t[1]-1 do begin
;lambda2[i]=crval2 + (i*cdelt2)
;endfor

;scales the flux to 6 kpc (AG Car)
flux6=flux/(1.8*1.8)

;final redenning
minusebv=-0.63
a=3.0
fm_unred, lambda, flux6, minusebv, flux6dfin, R_V = a

mwrfits,flux6dfin,'/home/groh/espectros/agcar/291b_fuv_isabs2020e63r30.fits',header


end
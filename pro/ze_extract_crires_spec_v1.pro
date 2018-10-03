PRO ZE_EXTRACT_CRIRES_SPEC_V1,dataa2,sizelam,row,center,apradius,spec_ext=spec_ext
;sum flux from lmin to lmax lines centered at center

flux=dblarr(sizelam)
help,flux
help,dataa2
flux_sum=0.
for i=0, 2*apradius do begin
;remove NaN values and change to 0
flux[*]=dataa2[*,row+center-apradius+i]
dummy=where( finite(flux,/NAN),count)
IF count NE 0 THEN flux(dummy)=0.
flux_sum=flux+flux_sum
endfor
spec_ext=flux_sum
print,'Spectral aperture extraction of '+number_formatter(((apradius*2)+1)*0.086,decimals=2)+'x 0.20 arcsec'



END
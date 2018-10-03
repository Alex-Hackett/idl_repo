PRO ZE_EXTRACT_STIS_CCD_SPEC,dataa2,sizelam,center,apradius,spec_ext=spec_ext
;sum flux from lmin to lmax lines centered at center

fluxd=dblarr(sizelam)
help,fluxd
help,dataa2
flux_sum=0.
for i=0, 2*apradius do begin
;remove NaN values and change to 0
fluxd[*]=dataa2[*,center-apradius+i]
dummy=where( finite(fluxd,/NAN),count)
IF count NE 0 THEN fluxd(dummy)=0.
flux_sum=fluxd+flux_sum
endfor
spec_ext=flux_sum
print,'Spectral aperture extraction of '+number_formatter(((apradius*2)+1)*0.025,decimals=2)+'x 0.1 arcsec'



END
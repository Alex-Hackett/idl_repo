PRO ZE_STIS_MAMA_EXTRACT_1D_WAVELENGTH_INDIVIDUAL_ORDERS,dataa2,sizelam,center,lambda_ext,aver=aver
;sum flux from lmin to lmax lines centered at center

wave_vector_temp=dblarr(sizelam)
lambda_ext=dataa2[*,center]


;for i=0, 2*apradius do begin
;;remove NaN values and change to 0
;flux[*]=dataa2[*,center-apradius+i]
;dummy=where( finite(flux,/NAN),count)
;IF count NE 0 THEN flux(dummy)=0.
;flux_sum=flux+flux_sum
;endfor
;spec_ext=flux_sum
;print,'Spectral aperture extraction of '+number_formatter(((apradius*2)+1)*0.086,decimals=2)+'x 0.20 arcsec'



END
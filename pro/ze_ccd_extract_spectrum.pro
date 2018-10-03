PRO ZE_CCD_EXTRACT_SPECTRUM,image,star_center,center,apradius,flux

flux=0.
for i=0, 2*apradius do begin
  flux=REFORM(image[star_center+center-apradius+i,*]+flux)
endfor
print,'Spectral aperture extraction of '+number_formatter(((apradius*2)+1),decimals=0)+' pixels'

END
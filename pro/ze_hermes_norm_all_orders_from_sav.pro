;PRO ZE_HERMES_NORM_ALL_ORDERS_FROM_SAV

filesav='/Users/jgroh/espectros/hd168625/hd168625_hermes_2010sep15_allorders.sav'
restore,filesav

fluxnorm_array=flux_array

;
;ynodesfluxnorm_array=xnodesfluxnormt
FOR k=0, norder -1  DO BEGIN
;FOR k=0, 3  DO BEGIN
line_norm,REFORM(lambda_array[*,k]),REFORM(flux_array[*,k]),fluxnormt,norm_fluxval,xnodesfluxnormt,ynodesfluxnormt
fluxnorm_array[*,k]=fluxnormt
undefine,norm_fluxval,xnodesfluxnormt,ynodesfluxnormt
ENDFOR

save,lambda_array,fluxnorm_array,npix,norder,filename='/Users/jgroh/espectros/hd168625/hd168625_hermes_2010sep15_allorders_norm.sav'

END
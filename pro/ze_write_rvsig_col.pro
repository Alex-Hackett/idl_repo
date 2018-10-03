PRO ZE_WRITE_RVSIG_COL,rout,vout,sigmaout,i,rvsig


;defines file RVSIG_COL ;
;rvsig='/home/groh/ze_models/agcar/var_191regrid223_mdot8_222c/RVSIG_COL'
openw,6,rvsig     ; open file to write

;creates RVSIG_COL for input in CMFGEN
printf,6,'!**********************************************************************'
printf,6,'!**********************************************************************'
printf,6,'!'
printf,6,'! RVSIG_COL created by ZE_MDOTVAR_V5.PRO (IDL)'
printf,6,'!'
printf,6,'! Delta is either /\V or /\Tau (see type column)' 
printf,6,'!'
printf,6,'! Rstar (10^10 cm) = ',rout[i-1]  
printf,6,'! Rmax/ Rstar =   ',(rout[0]/rout[i-1]*1.0D)
printf,6,'!'
printf,6,'!**********************************************************************'
printf,6,'!**********************************************************************'
printf,6,'!'
printf,6,'! r (10^10 cm)    v (km/s)        r/v dv/dr - 1    /\v        log(/\v)     type
printf,6,'!'
printf,6,FORMAT='(I)',i,'  !Number of depth points'
for k=0, i-2 do begin
deltav=(vout[k]-vout[k+1])
printf,6,FORMAT='(E12.6,2x,E12.6,2x,E13.6,2x,E12.6,2x,E15.6)',rout[k],vout[k], sigmaout[k], deltav, alog10(deltav)
endfor
printf,6,FORMAT='(E12.6,2x,E12.6,2x,E13.6,2x,E12.6,2x,E15.6)',rout[i-1],vout[i-1], sigmaout[i-1], 0, 0
;if k eq (i-1)
;printf,6,FORMAT='(E12.6,2x,E12.6,2x,E13.6,2x,E12.6,2x,E15.6)',rout[k],vout[k], sigmaout[k], 0, 0
;endif

close,6

END

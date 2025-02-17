PRO ZE_WRITE_VM_FILE,rout,vout,sigmaout,denout,clumpout,i,vmfile

openw,5,vmfile     ; open file to write

;creates VM_FILE for input in CMFGEN
printf,5,'!**********************************************************************'
printf,5,'!**********************************************************************'
printf,5,'!'
printf,5,'! VM_FILE created by ZE_MDOTVAR_V4.PRO (IDL)'
printf,5,'!'
printf,5,'! Delta is either /\V or /\Tau (see type column)' 
printf,5,'!'
printf,5,'! Rstar (10^10 cm) = ',rout[i-1]  
printf,5,'! Rmax/ Rstar =   ',(rout[0]/rout[i-1]*1.0D)
printf,5,'!'
printf,5,'!**********************************************************************'
printf,5,'!**********************************************************************'
printf,5,'!'
printf,5,'! r (10^10 cm)    v (km/s)        r/v dv/dr - 1    rho        f'
printf,5,'!'
printf,5,FORMAT='(I,A)',i,'  !Number of depth points'
for k=0, i-1 do begin
printf,5,FORMAT='(E12.6,2x,E12.6,2x,E13.6,2x,E12.6,2x,E12.6)',rout[k],vout[k], sigmaout[k], denout[k], clumpout[k]
endfor
close,5

END

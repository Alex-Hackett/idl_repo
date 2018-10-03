PRO ZE_INDIE_WRITE_AUGMENTED_DEN_VEL_TEMP_TO_CHAEL,file,ND,Nangles,den,vx,vy,vz,temp
close,1
openw,1,file     ; open file to write
printf,1,FORMAT='(F12.4)',ND
printf,1,FORMAT='(F12.4)',Nangles
for k=0., n_elements(den)-1. do begin
printf,1,FORMAT='(E16.9,2x,E16.9,2x,E16.9,2x,E16.9,2x,E16.9,2x)',den[k],vx[k],vy[k],vz[k],temp[k]
endfor
close,1

END
;------
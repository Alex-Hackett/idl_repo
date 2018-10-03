flux=mrdfits('/home/groh/espectros/agcar/agc99jun23_35a90ncoxa.fits',0,header)
crval1=fxpar(header,'CRVAL1')
cdelt1=fxpar(header,'CDELT1')
s=size(flux)
lambda=dblarr(s[1]) & vel1=lambda & vel2=lambda & vel3=lambda & vel4=lambda & vel5=lambda
for k=0., s[1]-1 do begin
lambda[k]=crval1 + (k*cdelt1)
endfor

;set plotted lines, in air wavelengths
;l1=4713.14 & l2=6678.15166 & l3=7065.18 & l4=5875.62 & l5=4387.92910
l1=4713.14 & l2=6677.640 & l3=7065.18 & l4=5875.097 & l5=4387.92910

for k=0.,s[1]-1 do begin
vel1[k]=299972.*(lambda[k]-l1)/l1
vel2[k]=299972.*(lambda[k]-l2)/l2
vel3[k]=299972.*(lambda[k]-l3)/l3
vel4[k]=299972.*(lambda[k]-l4)/l4
vel5[k]=299972.*(lambda[k]-l5)/l5
endfor




; plot spectrum
window,0,xsize=900,ysize=400,retain=2
plot,vel1,flux,xstyle=1,ystyle=1,xrange=[-500,500],yrange=[0.9,1.8],xtitle='wavelength (Angstrom)', $ ;4713
ytitle='Flux Normalized'
plots,vel2,flux/1.05,color=255, noclip=0,clip=[-500,0,500,2]; 6678
plots,vel3,flux,color=130, noclip=0,clip=[-500,0,500,2];  7065
plots,vel4,flux/1.15,color=255, noclip=0,clip=[-500,0,500,2];  5876
plots,vel5,flux, noclip=0,clip=[-500,0,500,2];  4387
end

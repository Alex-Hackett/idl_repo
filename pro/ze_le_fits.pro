close,/all
;defines observed SWP file
obsiueswp='/home/groh/espectros/agcar/iue/swp38703c.txt'  
openu,2,obsiueswp     ; open file without writing

;defines observed LWP file
obsiuelwp='/home/groh/espectros/agcar/iue/lwp17836c.txt'  
openu,3,obsiuelwp     ; open file without writing

;defines observed photometry file
obsphot='/home/groh/espectros/agcar/agc90jun18_phot_ubvyVJHKL.txt'  
openu,1,obsphot     ; open file without writing

;finds the r number of depth points in input file
r=0
while not eof(1) do begin
readf,1,linha
if linha eq '' then begin
goto,skip1
endif
r=r+1
skip1:
endwhile
close,1

;finds the u number of depth points in input IUE SWP files
u=0
while not eof(2) do begin
readf,2,linha
if linha eq '' then begin
goto,skip2
endif
u=u+1
skip2:
endwhile
close,2

;finds the p number of depth points in input IUE LWP files
p=0
while not eof(3) do begin
readf,3,linha
if linha eq '' then begin
goto,skip3
endif
p=p+1
skip3:
endwhile
close,3

;declare arrays
lambdaobs=dblarr(r) & fluxobs=lambdaobs & b=lambdaobs
lambdaswp=dblarr(u) & fluxswp=lambdaswp
lambdalwp=dblarr(p) & fluxlwp=lambdalwp
red1=dblarr(10000) & red2=red1 & red3=red1

;reads obs phot
openu,1,obsphot
for k=0,r-1 do begin
readf,1,lambdaobs1,fluxobs1
lambdaobs[k]=lambdaobs1 & fluxobs[k]=fluxobs1
endfor
close,1

;reads IUE SWP
openu,2,obsiueswp
for j=0,u-1 do begin
readf,2,lambdaswp1,fluxswp1
lambdaswp[j]=lambdaswp1 & fluxswp[j]=fluxswp1
endfor
close,2

;reads IUE LWP
openu,3,obsiuelwp
for n=0,p-1 do begin
readf,3,lambdalwp1,fluxlwp1
lambdalwp[n]=lambdalwp1 & fluxlwp[n]=fluxlwp1
endfor
close,3

;le fits
flux=mrdfits('/home/groh/espectros/agcar/319_car.fits',0,header)
obsflux=mrdfits('/home/groh/espectros/agcar/agc89dec23_swp37882_merge.fits',0,header2)
crval1=fxpar(header,'CRVAL1')
cdelt1=fxpar(header,'CDELT1')
crval2=fxpar(header2,'CRVAL1')
cdelt2=fxpar(header2,'CDELT1')
t=size(obsflux)
s=size(flux)
lambda=dblarr(s[1]) & fluxd=lambda & lambda2=lambda
for k=0., s[1]-1 do begin
lambda[k]=crval1 + (k*cdelt1)
endfor

;for i=0., t[1]-1 do begin
;lambda2[i]=crval2 + (i*cdelt2)
;endfor

;scales the flux to 6 kpc (AG Car)
flux6=flux/36

;redden spectrum multiple times
o=0
for a=2.8, 5.0, 0.1 do begin
for minusebv=-0.40, -0.90, -0.01 do begin
fm_unred, lambda, flux6, minusebv, flux6d, R_V = a
;computes residuals
res=0.
for k=0, r-2 do begin
t=1
while (t le s[1]-2) do begin
dif=abs(lambdaobs[k]-lambda[t]) & difnext=abs(lambdaobs[k]-lambda[t+1]) & difprev=abs(lambdaobs[k]-lambda[t-1])
if ((dif lt difnext) and (dif lt difprev)) then begin
l=t
endif
t=t+1
endwhile
b[k]=(fluxobs[k]-(2*flux6d[l]))*(fluxobs[k]-(2*flux6d[l])); residuals squared
res=res+b[k] ;sum of residuals squared
;print,lambdaobs[k],fluxobs[k],flux6d[l],b[k],k
endfor
print,a,minusebv,res
red1[o]=a & red2[o]=minusebv & red3[o]=res
o=o+1
endfor
endfor

red1=red1(where(red1 gt 0.))
red2=red2(where(red1 gt 0.))
red3=red3(where(red1 gt 0.))

;finds the minimum residual
;d=red(where(red eq min(red[2,*])))
resultado=min(red3)
d=where(red3 eq min(red3))

;final redenning
minusebv=-0.7
a=3.6
fm_unred, lambda, flux6, minusebv, flux6dfin, R_V = a

mwrfits,flux6d,'/home/groh/espectros/agcar/319_car6r1.fits',header

; plot spectrum
window,0,xsize=400,ysize=400,retain=2
plot,alog10(lambda),alog10(2*flux6dfin),xtitle='wavelength (Angstrom)', ytitle='Flux (erg/s/cm^2/Angstrom)'
;plots,lambda2,obsflux,color=255
plots,alog10(lambdaobs),alog10(fluxobs),color=255,psym=1
plots,alog10(lambdaswp),alog10(fluxswp),color=255,psym=1
plots,alog10(lambdalwp),alog10(fluxlwp),color=255,psym=1
;plots,alog10(lambda),alog10(2*flux6dfin),color=255
end

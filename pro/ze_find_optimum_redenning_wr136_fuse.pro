close,/all
;defines observed FUSE file
obsfuse='/home/groh/espectros/wr136/wr136_fuse_med.txt'  
openu,2,obsfuse     ; open file without writing

;defines model file
model='/home/groh/espectros/wr136/wr136_mod18_isabs195205.txt'  
openu,1,model    ; open file without writing

;finds the r number of depth points in input file
z=0.
while not eof(1) do begin
readf,1,linha
if linha eq '' then begin
goto,skip1
endif
z=z+1.0
skip1:
endwhile
close,1

;finds the u number of depth points in input IUE FUSE files
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

;declare arrays
lambdamod=dblarr(r) & fluxmod=lambdamod & b=lambdamod
lambdafuse=dblarr(u) & fluxfuse=lambdafuse & c=lambdafuse
red1=dblarr(10000) & red2=red1 & red3=red1

;reads model
openu,1,model
r=0.
for k=0.,z-1 do begin
readf,1,lambdamod1,fluxmod1
if (lambdamod1 lt 1190.0) then begin 
lambdamod[k]=lambdamod1 & fluxmod[k]=fluxmod1
r=r+1.0
endif
endfor
close,1

;reads IUE SWP
openu,2,obsfuse
for j=0,u-1 do begin
readf,2,lambdafuse1,fluxfuse1
lambdafuse[j]=lambdafuse1 & fluxfuse[j]=fluxfuse1
endfor
close,2

;scales the model flux to 1.8 kpc (WR136)
fluxmodesc=fluxmod/(1.8*1.8)

;redden spectrum multiple times
o=0.
for a=3.4, 3.5, 0.1 do begin
for minusebv=-0.45, -0.55, -0.01 do begin
fm_unred, lambdamod1, fluxmodesc, minusebv, fluxmodd, R_V = a
;computes residuals
;res=0.
;for k=0., u-2 do begin
;t=1.
;while (t le r-2) do begin
;dif=abs(lambdafuse[k]-lambdamod[t]) & difnext=abs(lambdafuse[k]-lambdamod[t+1]) & difprev=abs(lambdafuse[k]-lambdamod[t-1])
;if ((dif lt difnext) and (dif lt difprev)) then begin
;l=t
;endif
;t=t+1
;endwhile
;b[k]=(fluxfuse[k]-(fluxmodd[l]))*(fluxfuse[k]-(fluxmodd[l])); residuals squared
;res=res+b[k] ;sum of residuals squared
;;print,lambdamod[k],fluxfuse[k],fluxmodd[l],b[k],k
;endfor


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
minusebv=-0.47
a=4.0
fm_unred, lambdamod, fluxmodesc, minusebv, flux6dfin, R_V = a
fm_unred,lambdamod, fluxmodesc, -0.47, flux6dfin_prevred, R_V = 3.1

;mwrfits,flux6dfin,'/home/groh/espectros/wr136/final.fits',header

; plot spectrum
window,0,xsize=600,ysize=600,retain=2
plot,lambdafuse,fluxfuse,xrange=[900,1200],xtitle='wavelength (Angstrom)', ytitle='Flux (erg/s/cm^2/Angstrom)'
plots,lambdamod,flux6dfin,color=255
;plots,lambdamod,flux6dfin_prevred,color=tarcl(0,255,0)
;plots,alog10(lambdaswp),alog10(fluxswp),color=255,psym=1
;plots,alog10(lambdalwp),alog10(fluxlwp),color=255,psym=1
;plots,alog10(lambda),alog10(2*flux6dfin),color=255
end

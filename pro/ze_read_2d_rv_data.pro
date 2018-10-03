close,/all

;OK, working and reading well RV_DATA!

;defines file RV_DATA
rv_data='/home/groh/ze_models/2D_models/takion/hd45166/106_copy/6/RV_DATA'
openu,2,rv_data     ; open file without writing

;set text string variables (scratch)
desc1=''
desc2=''

;find the values of ND and beta
readf,2,FORMAT='(1x,I,10x,A23)',ND,desc1
readf,2,FORMAT='(1x,I,10x,A22)',beta,desc2
N=ND*beta

;set vector sizes as ND
r1=dblarr(ND) & betaang=dblarr(beta) & radvel=dblarr(ND*beta) & azivel=radvel & betvel=radvel & dencon=radvel
denconbeta=dblarr(beta) & betadeg=betaang & denconrbeta=dblarr(ND,beta) & denconr=dblarr(ND)

;As long as the values of ND and beta are known, we can read out the rest of the file.
;Current format only valid for ND=40 and beta=11, will have to adjust the way to read RV_DATA
;        for other values of ND and beta.

readf,2,FORMAT='(A23)',desc1 ;those lines are reading blank or text values
readf,2,FORMAT='(A23)',desc1

;read values of r
l=ND
for j=0, 4 do begin
readf,2,FORMAT='(1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11)',r2t,r3t,r4t,r5t,r6t,r7t,r8t,r9t
r1[ND-l]=r2t
r1[ND-l+1]=r3t
r1[ND-l+2]=r4t
r1[ND-l+3]=r5t
r1[ND-l+4]=r6t
r1[ND-l+5]=r7t
r1[ND-l+6]=r8t
r1[ND-l+7]=r9t
l=l-8
endfor

readf,2,FORMAT='(A23)',desc1
readf,2,FORMAT='(A23)',desc1

;read values of beta (i.e. angles)
readf,2,FORMAT='(1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11)',r2t,r3t,r4t,r5t,r6t,r7t,r8t,r9t
readf,2,FORMAT='(1x,E13.11,1x,E13.11,1x,E13.11)',r10t,r11t,r12t
betaang[0]=r2t
betaang[1]=r3t
betaang[2]=r4t
betaang[3]=r5t
betaang[4]=r6t
betaang[5]=r7t
betaang[6]=r8t
betaang[7]=r9t
betaang[8]=r10t
betaang[9]=r11t
betaang[10]=r12t

readf,2,FORMAT='(A23)',desc1
readf,2,FORMAT='(A23)',desc1

;read values of the radial velocity as a function of r and beta
l=ND*beta
N=ND*beta
lim=1
lim=(ND*beta/8)-1
for j=0, lim do begin
readf,2,FORMAT='(1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11)',r2t,r3t,r4t,r5t,r6t,r7t,r8t,r9t
radvel[N-l]=r2t
radvel[N-l+1]=r3t
radvel[N-l+2]=r4t
radvel[N-l+3]=r5t
radvel[N-l+4]=r6t
radvel[N-l+5]=r7t
radvel[N-l+6]=r8t
radvel[N-l+7]=r9t
l=l-8
endfor

readf,2,FORMAT='(A23)',desc1
readf,2,FORMAT='(A23)',desc1

;read values of the azimuthal velocity as a function of r and beta
l=ND*beta
N=ND*beta
lim=1
lim=(ND*beta/8)-1
for j=0, lim do begin
readf,2,FORMAT='(1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11)',r2t,r3t,r4t,r5t,r6t,r7t,r8t,r9t
azivel[N-l]=r2t
azivel[N-l+1]=r3t
azivel[N-l+2]=r4t
azivel[N-l+3]=r5t
azivel[N-l+4]=r6t
azivel[N-l+5]=r7t
azivel[N-l+6]=r8t
azivel[N-l+7]=r9t
l=l-8
endfor

readf,2,FORMAT='(A23)',desc1
readf,2,FORMAT='(A23)',desc1

;read values of the beta velocity as a function of r and beta
l=ND*beta
N=ND*beta
lim=1
lim=(ND*beta/8)-1
for j=0, lim do begin
readf,2,FORMAT='(1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11)',r2t,r3t,r4t,r5t,r6t,r7t,r8t,r9t
betvel[N-l]=r2t
betvel[N-l+1]=r3t
betvel[N-l+2]=r4t
betvel[N-l+3]=r5t
betvel[N-l+4]=r6t
betvel[N-l+5]=r7t
betvel[N-l+6]=r8t
betvel[N-l+7]=r9t
l=l-8
endfor

readf,2,FORMAT='(A23)',desc1
readf,2,FORMAT='(A23)',desc1

;read values of the density contrast (in comparison with the spherical wind) as a function of r and beta
l=ND*beta
N=ND*beta
lim=1
lim=(ND*beta/8)-1
for j=0, lim do begin
readf,2,FORMAT='(1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11)',r2t,r3t,r4t,r5t,r6t,r7t,r8t,r9t
dencon[N-l]=r2t
dencon[N-l+1]=r3t
dencon[N-l+2]=r4t
dencon[N-l+3]=r5t
dencon[N-l+4]=r6t
dencon[N-l+5]=r7t
dencon[N-l+6]=r8t
dencon[N-l+7]=r9t
l=l-8
endfor

close,2

;at the end of the reading we have r1, betaang, radvel, azivel, betvel and dencon with the quantities.

;compute density contrast as a function of betaang
i=0
for j=0,beta-1 do begin
denconbeta[j]=dencon[i]
i=i+40
endfor

;compute density contrast as a function of r
i=0
for j=0,ND-1 do begin
denconr[j]=dencon[j]
i=i+11
endfor


;convert betaang to degrees, which is then stored in betadeg
betadeg=180*betaang/3.141593

;converting quantities to 2darrays to do surface plot

z=dblarr(ND,beta)
x2d=z
x2d = [[r1],[betaang]]
y2d=z
dencon2d=z 
for j=0,ND-1 do y2d(j,*)=betaang
for j=0,beta-1 do x2d(*,j)=r1
for j=0,ND-1 do dencon2d(j,*)=denconbeta ;this works!
;for  j=0,ND-1 do dencon2d(j,*)=denconbeta*(1+j)      ;test

A = dblarr(2, 4)
 for i = 0, 1 do begin
    for j = 0, 3 do begin 
      a(i, j) = 10 * i + j 
endfor
endfor 
print, A
; calculate z. 
;z=exp(-(x2d^2 +y2d^2)) + 0.6*exp(-((x2d+1.8)^2 +(y2d) ^2))
;general plots, mainly for checking 
;velocity plots
;window,0,xsize=400,ysize=400,retain=2
;plot,x2d,dencon,psym=2,symsize=0.5,xtitle='log r (CMFGEN units)', ytitle='velocity (km/s)'
;plots,alog10(r2),v2,psym=2,symsize=0.5
;plots,alog10(rout),vout,color=255,psym=4,symsize=1.5

;surface,dencon2d,alog10(x2d),(y2d*180/3.141593)

end

close,/all
;defines file rvdenclump1.txt
rvdenclump1='/home/groh/var_mdot/var_191_regrid_223_mdot5_var222/rvdenclump1.txt'  
openu,1,rvdenclump1     ; open file without writing

;defines file rvdenclump2.txt
rvdenclump2='/home/groh/var_mdot/var_191_regrid_223_mdot5_var222/rvdenclump2.txt'  
openu,2,rvdenclump2     ; open file without writing

;defines file rvdenclumpout.txt ;mainly for debugging
rvdenclumpout='/home/groh/var_mdot/var_191_regrid_223_mdot5_var222/rvdenclumpout.txt'  
openu,3,rvdenclumpout     ; open file without writing
close,3

;defines file output.txt ;
output='/home/groh/var_mdot/var_191_regrid_223_mdot5_var222/output.txt'  
openw,4,output     ; open file to write


linha=''

;finds the i number of depth points in model 1

i=0
while not eof(1) do begin
readf,1,linha
if linha eq '' then begin
goto,skip1
endif
i=i+1
skip1:
endwhile
close,1

;finds the j number of depth points in model 2

j=0
while not eof(2) do begin
readf,2,linha
if linha eq '' then begin
goto,skip2
endif
j=j+1
skip2:
endwhile
close,2


;declares the arrays

r1=dblarr(i) & r2=r1 & rout=r1 & v1=r1 & v2=r1 & vout=r1 & den1=r1 & &den1regrid=r1 & den2=r1 
denout=r1 & mdot1=r1 
mdot2=r1 & mdotout=r1 & vinf=r1 & rstart=r1 & flowtime=r1 & sigma1=r1 & sigma2=r1 & sigmaout=r1 
clump1=r1 & clump2=r1 & clumpout=r1

r3=r1 & v3=r1 & sigma3=r1 & den3=r1 & clump3=r1

;reads rvdenclump1.txt

openu,1,rvdenclump1
for k=0,i-1 do begin
readf,1,r1t,v1t,sigma1t,den1t,clump1t
r1[k]=r1t & v1[k]=v1t & sigma1[k]=sigma1t & den1[k]=den1t & clump1[k]=clump1t
endfor
close,1

;reads rvdenclump2.txt

openu,2,rvdenclump2
for k=0,i-1 do begin
readf,2,r2t,v2t,sigma2t,den2t,clump2t
r2[k]=r2t & v2[k]=v2t & sigma2[k]=sigma2t & den2[k]=den2t & clump2[k]=clump2t
endfor
close,2
den2=1*den2 ;re-scaling to increase Mdot by a factor of 3

;reads rvdenclumpout.txt

openu,3,rvdenclumpout
for k=0,i-1 do begin
readf,3,r3t,v3t,sigma3t,den3t,clump3t
r3[k]=r3t & v3[k]=v3t & sigma3[k]=sigma3t & den3[k]=den3t & clump3[k]=clump3t
endfor
close,3
;reads the time elapsed

read,deltat,prompt='Days elapsed between model 1 and model 2: '


;calculates the flow timescale just as r/v and writes to the 
; screen R, V, flow time, no header. I am assuming that the
;large flow times below the sonic point are artificial, and
;are due to the simplificate assumption that flowt=(r/v). 
;Thus I assume that, for v<20km/s, flowtime=0 . THERE IS SOME BUG IN COMPUTING THE FLOW TIMES HERE!!! 
;THEY ARE TOO LARGE! Compare to sumario_agcar.sxc and var_mdot_rho.c, which shown the correct value.
; Now it is FIXED. Apparently IDL wasn't handling 100000/(3600*24) =1.157407 !!!!

for k=0, i-1 do begin
flowtimet=(r2[k]-r2[i-1])*1.157407/(v2[k])
flowtime[k]=flowtimet
if v2[k] lt 10.0 then  begin
flowtime[k]=0
endif
endfor

;calculates the terminal velocity as a function of r. Assumes vinf proportional to t, and truncates where
;vinf is greater than vinf on epoch 1

for k=0, i-1 do begin
vinft= v1[0]+(v2[0]-v1[0])/deltat * (deltat-flowtime[k])
vinf[k]=vinft
if flowtime[k] gt deltat then begin
vinf[k]=v1[0]
endif
endfor

;calculates the stellar radius at each radius, assuming a linear variation along the time
; (R* proportional to t). Truncates where R* is lower than R* on epoch 1, and assumes this value for that
;radius and farther ones

for k=0, i-1 do begin
rstartt=r1[i-1]+(r2[i-1]-r1[i-1])/deltat * (deltat-flowtime[k])
rstart[k]=rstartt
if rstartt lt r1[i-1] then begin
rstart[k]=r1[i-1]
endif
endfor

; sets the output radial grid. Assumes that it is the same as model 2.

rout=r2

; Calculates the velocity field; has an option allowing, for v<30km/s, that the current 
; velocity field is kept (epoch2); for v>30km/s we assume a beta=1
; velocity law, with vphot=5, vcore=0.01 and vinf as the value
; calculated for that specific radius in the previous step.

for k=0, i-1 do begin
voutt=(5+(vinf[k]-5)*((1-(rstart[k]/r2[k]))^1.0))/(1+(5/0.01)*exp((rstart[k]-r2[k])/(0.004*rstart[k])))
vout[k]=voutt
if voutt lt 20.0 then begin
vout[k]=v2[k]
endif
endfor

; Evaluates sigma doing  (r deltav)/(v delta r) -1      (very crude!)

sigmaout[0]=-1
for k=1, i-1 do begin
sigmaoutt=(rout[k]*(vout[k-1]-vout[k])/(vout[k]*(rout[k-1]-rout[k])))-1
sigmaout[k]=sigmaoutt
endfor

; Evaluates the filling factors for clumping. Currently assumes vc=30 km/s and that finf is not changing (f=0.25).

f=0.25
vc=30
for k=0, i-1 do begin
clumpoutt=f + (1-f)*exp(-v2[k]/vc)
clumpout[k]=clumpoutt
endfor

; Interpolates the density structure of model 1 in the same grid of model 2. Fixes the bug found in 
; var_mdot_rho.c (on takion and agcar). Uses cspline.pro. Also extrapolates if the r grid goes farther in model 2
; than in model 1.

den1regrid=cspline(r1,den1,r2); interpolate to the same r grid of model 2
for k=0, i-1 do begin
if r2[k] gt r1[0] then begin
den1regrid[k]=(r1[k+1])^2*v1[k+1]*den1[k+1]/((r2[k])^2*v1[k]) ;extrapolates to larger radii
endif
endfor


; Derives the density variations, assuming that rho is proportional to t.

for k=0, i-1 do begin
denout[k] = den1regrid[k]+((den2[k]-den1regrid[k])/deltat)*(deltat-flowtime[k])
if flowtime[k] gt deltat then begin 
denout[k]=den1regrid[k]
endif
endfor


;general printing to the screen, mainly for debugging purposes
print,sigmaout
for k=0, i-1 do begin
printf,4,FORMAT='(E12.6,2x,E12.6,2x,E13.6,2x,E12.6,2x,E12.6)',rout[k],vout[k], sigmaout[k], denout[k], clumpout[k]
endfor
close,4

;general plots for debugging
plot,alog10(rout),vout,psym=1,symsize=1.5
plots,alog10(r2),v2,color=255,psym=2,symsize=1.5
plots,alog10(r1),v1,color=255,psym=5,symsize=1.5
;plots,alog10(rout),alog10(denout),color=255,psym=4,symsize=1.5
;plots,r2,v2,color=255,noclip=0,clip=[min(r1),min(v1),max(r1),max(v1)]



end

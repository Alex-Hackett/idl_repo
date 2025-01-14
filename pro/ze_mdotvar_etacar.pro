;implementing changes to allow for Mdot(t) instead of rho(t). Look at the Mdot plots in IDL 5 window 
;from ze_mdotvar_v2.pro. The changes in Mdot as a function of radius were not physical.
close,/all
;defines file rvdenclump1.txt
rvdenclump1='/home/groh/rvdenclump_hillier_orig.txt'  
openu,1,rvdenclump1     ; open file without writing

;defines file rvdenclump2.txt
rvdenclump2='/home/groh/rvdenclump_hillier_orig_copy.txt'  
openu,2,rvdenclump2     ; open file without writing

;defines file rvdenclumpout.txt ;mainly for debugging
;rvdenclumpout='/home/groh/var_mdot/var_191regrid223_mdot8_222/output_original.txt'  
;openu,3,rvdenclumpout     ; open file without writing
;close,3

;defines file output.txt ;
output='/home/groh/output_scratch.txt'  
openw,4,output     ; open file to write

;defines file mdotvinfflow.txt ; outputs Mdot, vinf and flowtime as a function of r
mdotvinfflow='/home/groh/mdotvinfflow_scratch.txt'  
openw,5,mdotvinfflow     ; open file to write

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
den2=den2 

;reads rvdenclumpout.txt
;openu,3,rvdenclumpout
;for k=0,i-1 do begin
;readf,3,r3t,v3t,sigma3t,den3t,clump3t
;r3[k]=r3t & v3[k]=v3t & sigma3[k]=sigma3t & den3[k]=den3t & clump3[k]=clump3t
;endfor
;close,3


;reads the elapsed time 
read,deltat,prompt='Days elapsed between model 1 and model 2: '


;computes Mdot as a function of r, using the read values of den and v, and the eq. of mass continuity.
;looking at what's happening with Mdot(r).
mdot1=4.*3.141592*((r1)^2)*den1*v1*(3600.*24*365.)*clump1/(1.99E+08)
mdot2=4.*3.141592*((r2)^2)*den2*v2*(3600.*24*365.)*clump2/(1.99E+08)
;scaling mdot2 by a factor of 4
mdot2=mdot2*4.
;Mdotout=4.*3.141592*((rout)^2)*denout*vout*(3600.*24*365.)*clumpout/(1.99E+08)


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
;vinf is greater than vinf on epoch 1. BUG=I am assuming that vinf1 is given by the last v point found in
;rvdenclump1.txt, which MAY BE NOT TRUE IF MODEL 1 is ALSO TIME-DEPENDENT! . 
; WRONG !!! vinf(r) for a given r is increasing as 
; a function of time! This is not physical, the opposite should happen instead. SOLUTION: sum delta t 
; with previous delta t? 
for k=0, i-1 do begin
vinft= v1[0]+(v2[0]-v1[0])/deltat * (deltat-flowtime[k])
;vinft= v1[0]+(v2[0]-v1[0])*exp(-(((deltat-flowtime[k])/deltat)-1))
vinf[k]=vinft
if flowtime[k] gt deltat then begin
vinf[k]=v1[0]
endif
endfor

;calculates the stellar radiusas a function of time at each radius, assuming a linear variation along the time
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
;rout=r2/(6.96*215.0)

; Calculates the velocity field; has an option allowing, for v<30km/s, that the current 
; velocity field is kept (epoch2); for v>30km/s we assume a beta=1
; velocity law, with vphot=5, vcore=0.01 and vinf as the value
; calculated for that specific radius in the previous step.
;for k=0, i-1 do begin
;voutt=(5+(vinf[k]-5)*((1-(rstart[k]/r2[k]))^1.0))/(1+(5/0.01)*exp((rstart[k]-r2[k])/(0.004*rstart[k])))
;vout[k]=voutt
;if voutt lt 20.0 then begin
;vout[k]=v2[k]
;endif
;endfor
vout=v1

; Evaluates sigma doing  (r deltav)/(v delta r) -1      (very crude!)
;sigmaout[0]=-1
;for k=1, i-1 do begin
;sigmaoutt=(rout[k]*(vout[k-1]-vout[k])/(vout[k]*(rout[k-1]-rout[k])))-1
;sigmaout[k]=sigmaoutt
;endfor
sigmaout=sigma1

; Evaluates the filling factors for clumping. Currently assumes vc=10 km/s and that finf is not changing
; (f=0.25). TRICKY: if vc is not equal to the value used for model 2, density enhancements/depletion can
; occur.
;f=0.25
;vc=10
;for k=0, i-1 do begin
;clumpoutt=f + (1-f)*exp(-vout[k]/vc)
;clumpout[k]=clumpoutt
;endfor
clumpout=clump1


; Interpolates the Mdot1(r) in the model 2 grid. More physical to be understood than interpolating
; densities. Uses cspline.pro . ASSUMES A CONSTANT VALUE for outer radii if the r grid goes farther in
; model 2 than in model 1.
mdot1regrid=cspline(r1,mdot1,r2) ;interpolate to the same r grid of model 2
for k=0, i-1 do begin
if r2[k] gt r1[0] then begin
mdot1regrid[k]=(mdot1[k+9]+mdot1[k+10])/2 ; crudely extrapolates to larger radii
endif
endfor

; Derives the Mdot changes, assuming that Mdot is proportional to t.
for k=0, i-1 do begin
mdotout[k] = mdot1regrid[k]+((mdot2[k]-mdot1regrid[k])/deltat)*(deltat-flowtime[k])
if flowtime[k] gt deltat then begin 
mdotout[k]=mdot1regrid[k]
endif
endfor

; NOT USED ANYMORE. Interpolates the density structure of model 1 in the same grid of model 2. Fixes the bug found in 
; var_mdot_rho.c (on takion and agcar). Uses cspline.pro. Also extrapolates if the r grid goes farther in model 2
; than in model 1.
;den1regrid=cspline(r1,den1,r2); interpolate to the same r grid of model 2
;for k=0, i-1 do begin
;if r2[k] gt r1[0] then begin
;den1regrid[k]=(r1[k+1])^2*v1[k+1]*den1[k+1]/((r2[k])^2*v1[k]) ; extrapolates to larger radii
;endif
;endfor


; Derives the density variations using the equation of mass continuity.
denout=mdotout/(4.*3.141592*((rout)^2)*vout*(3600.*24*365.)*clumpout/(1.99E+08))

;general printing routine to output.txt, mainly for debugging purposes.
for k=0, i-1 do begin
printf,4,FORMAT='(E12.6,2x,E12.6,2x,E13.6,2x,E12.6,2x,E12.6)',rout[k],vout[k], mdotout[k], denout[k], flowtime[k]
endfor
close,4

;printing routine to mdotvinfflow.txt, mainly for debugging purposes.
for k=0, i-1 do begin
printf,5,FORMAT='(E12.6,2x,E12.6,2x,E12.6,2x,E12.6)',rout[k],mdotout[k], vinf[k], flowtime[k]
endfor
close,5

r1=r1/(6.96*215.0)
r2=r2/(6.96*215.0)
rout=rout/(6.96*215.0)

;;general plots, mainly for checking 
;;velocity plots
window,0,xsize=400,ysize=400,retain=2
plot,alog10(r1),v1,psym=1,symsize=1.5,xtitle='log r (CMFGEN units)', ytitle='velocity (km/s)'
plots,alog10(r2),v2,psym=2,symsize=1.5
plots,alog10(rout),vout,color=255,psym=4,symsize=1.5
;;density plots
window,1,xsize=400,ysize=400,retain=2
plot,alog10(r1),alog10(den1),psym=1,symsize=1.5,xtitle='log r (CMFGEN units)', ytitle='log density (cm-3)'
plots,alog10(r2),alog10(den2),psym=2,symsize=1.5
plots,alog10(rout),alog10(denout),color=255,psym=4,symsize=1.5
;;flow timescale
window,2,xsize=400,ysize=400,retain=2
;plot,/ylog,yrange=[0.1,10000],alog10(rout/rout[i-1]),flowtime,psym=1,symsize=1.5,xtitle='log r (CMFGEN units)', ytitle='flow timescale (days)'
plot,/xlog,/ylog,yrange=[0.1,10000],rout,flowtime,psym=1,symsize=1.5,xtitle='log r (CMFGEN units)', ytitle='flow timescale (days)'
;;terminal velocity as a function of r
window,3,xsize=400,ysize=400,retain=2
plot,alog10(rout),vinf,psym=1,symsize=1.5,xtitle='log r (CMFGEN units)', ytitle='terminal velocity (km/s)'
;;plotting Mdot
window,4,xsize=800,ysize=600,retain=2
plot,alog10(r1),alog10(Mdot1),xrange=[2.8,5.3],yrange=[-3.5,-2.5],psym=1,symsize=1.5,xtitle='log r (CMFGEN units)', ytitle='Mdot (Msun/yr)'
plots,alog10(r2),alog10(Mdot2),psym=2,symsize=1.5
plots,alog10(rout),alog10(Mdotout),psym=4,symsize=1.5,color=255

;making psplots
set_plot,'ps'
device,filename='/home/groh/var_mdot/var_191_regrid_223_mdot5/output.ps',/encapsulated,/color,bit=8,xsize=6.48,ysize=10.02,/inches
!p.multi=[0, 1, 5, 0, 0]
;flowtime
plot,/ylog,yrange=[1,4000],alog10(rout),flowtime,xtitle='log r (CMFGEN units)', ytitle='flow timescale (days)',charsize=2,charthick=2
;vinf
plot,alog10(rout),vinf,xtitle='log r (CMFGEN units)', ytitle='terminal velocity (km/s)',charsize=2,charthick=2
;mdot
plot,alog10(r1),alog10(Mdot1),xrange=[2.5,5.5],yrange=[-3.5,-2.5],xtitle='log r (CMFGEN units)', ytitle='Mdot (Msun/yr)',charsize=2,charthick=2
plots,alog10(r2),alog10(Mdot2)
plots,alog10(rout),alog10(Mdotout)
;velocity plots
plot,alog10(r1),v1,xrange=[2.5,5.5],xtitle='log r (CMFGEN units)', ytitle='velocity (km/s)',charsize=2,charthick=2
plots,alog10(r2),v2
plots,alog10(rout),vout
;density plots
plot,alog10(r1),alog10(den1),xtitle='log r (CMFGEN units)', ytitle='log density (cm-3)',charsize=2,charthick=2
plots,alog10(r2),alog10(den2)
plots,alog10(rout),alog10(denout)
!p.multi=[0, 0, 0, 0, 0]
device,/close


set_plot,'x'

;write VM_FILE
;ZE_WRITE_VM_FILE,rout,vout,sigmaout,denout,clumpout,i

;write RVSIG_COL
;ZE_WRITE_RVSIG_COL,rout,vout,sigmaout,i

;trying to do numerical integration of the velocity law, to obtain a more precise flow timescale
;result = INT_TABULATED(r2, v2)

end

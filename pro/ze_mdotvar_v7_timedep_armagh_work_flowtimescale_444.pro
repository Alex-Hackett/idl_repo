;PRO ZE_MDOTVAR_V7_TIMEDEP_ARMAGH_WORK_FLOWTIMESCALE_444
;here we don't compute a timedep model, since 444 is steady state with teff =15.5 kK, mdot=9e-06 Msun/yr, vinf=70, beta=1
;goal here is to compute how much time one needs to obtain the vel and den structure of the steady state model
; compute tflow by integrating the inverse of the velocity law
;v7 tries to implement a non-continuous change in mass loss rate as a function of time (2010Oct19)
;implementing changes to allow for Mdot(t) instead of rho(t). Look at the Mdot plots in IDL 5 window 
;from ze_mdotvar_v2.pro. The changes in Mdot as a function of radius were not physical.
close,/all

modelin='442'
modelout='tes'

;defines file mdotvinfflow.txt ; outputs Mdot, vinf and flowtime as a function of r
mdotvinfflow='/Users/jgroh/ze_models/timedep_armagh/'+modelout+'/mdotvinfflow.txt'  
openw,5,mdotvinfflow     ; open file to write

;r and v values of model 1, with increased teff and vinf-150 km/s
READCOL,'/Users/jgroh/ze_models/timedep_armagh/'+modelin+'/RVSIG_COL_NEW',r1,v1,sigma1,depth1,COMMENT='!',F='D,D'

;r and v values of model 2
READCOL,'/Users/jgroh/ze_models/timedep_armagh/'+modelout+'/RVSIG_COL',r2,v2,sigma2,depth2,COMMENT='!',F='D,D'


i=n_elements(r1)

;declares the arrays
clump1=r1 & rout=r1 &vout=r1 & denout=r1 & mdotout=r1 & clumpout=r1 & sigmaout=r1
r3=r1 & v3=r1 & sigma3=r1 & den3=r1 & clump3=r1 & flowtime=r1 & vinf=r1 & rstart=r1

vout=v1
clumpout=r1
sigmaout=r1

;reads Mdot1
;read,mdot_val1,prompt='Mass loss rate of model 1: '
mdot_val1=9e-06
;reads clump1
;read,f1,prompt='Clumping filling factor of model 1: '
f1=0.25

; Evaluates the filling factors for clumping. Currently assumes vc=10 km/s and that finf is not changing
; (f=0.25). TRICKY: if vc is not equal to the value used for model 2, density enhancements/depletion can
; occur.

vc=10
for k=0, i-1 do begin
clump1[k]=f1 + (1-f1)*exp(-v1[k]/vc)
endfor

; Derives the density structure using the equation of mass continuity.
den1=mdot_val1/(4.*3.141592*((r1)^2)*v1*(3600.*24*365.)*clump1/(1.99E+08))

mdot1=4.*3.141592*((r1)^2)*den1*v1*(3600.*24*365.)*clump1/(1.99E+08)

den2=den1
mdot2=mdot1

;reads the elapsed time 
read,deltat,prompt='Days elapsed between model 1 and model 2: '

;velocity law for epoch 1:
;vinf1=150.
;beta1=1.0
;;v2mod=v2
;FOR k=0, i-1 do begin
;v1[k]=(5+(vinf1-5)*((1-(r1[i-1]/r1[k]))^beta1))/(1+(5/0.01)*exp((r1[i-1]-r1[k])/(0.04*r1[i-1])))
;endfor
;
;;velocity law for epoch 2:
;vinf2=70.
;beta2=1.0
;v2mod=v2
;FOR k=0, i-1 do begin
;v2[k]=(5+(vinf2-5)*((1-(r2[i-1]/r2[k]))^beta2))/(1+(5/0.01)*exp((r2[i-1]-r2[k])/(0.04*r2[i-1])))
;endfor
;computes Mdot as a function of r, using the read values of den and v, and the eq. of mass continuity.
;looking at what's happening with Mdot(r).
;mdot1=4.*3.141592*((r1)^2)*den1*v1*(3600.*24*365.)*clump1/(1.99E+08)
mdot2=mdot1
;mdot2=4.*3.141592*((r2)^2)*den2*v2*(3600.*24*365.)*clump2/(1.99E+08)
;60mdot2=4.*3.141592*((r1)^2)*den1*v1*(3600.*24*365.)*clump2/(1.99E+08)
;Mdotout=4.*3.141592*((rout)^2)*denout*vout*(3600.*24*365.)*clumpout/(1.99E+08)


;calculates the flow timescale just as (r-rstar)/v and writes to the 
; screen R, V, flow time, no header. I am assuming that the
;large flow times below the sonic point are artificial, and
;are due to the simplificate assumption that flowt=(r/v). 
;Thus I assume that, for v<20km/s, flowtime=0 . THERE IS SOME BUG IN COMPUTING THE FLOW TIMES HERE!!! 
;THEY ARE TOO LARGE! Compare to sumario_agcar.sxc and var_mdot_rho.c, which shown the correct value.
; Now it is FIXED. Apparently IDL wasn't handling 100000/(3600*24) =1.157407 !!!!
;2010Nov10 Major bug found -- flowtime was not being computed correctly -- should have added the flowtime for all previous depth -- 10-20 % difference tough
;rewrote to do interpolation for better accuracy
;do an integration of the velocity law, to obtain a more precise flow timescale; assume the flow timescale is 0 below the sonic point
vs=15.0

r2i=REBIN(r2,n_elements(r2)*10000)
v2i=cspline(r2,v2,r2i)

sonic=MIN(ABS(v2i-vs),indexsonic)
v2irev=REVERSE(v2i)
r2irev=REVERSE(r2i)
ndi=n_elements(r2irev)

dflowtimerev=dblarr(n_elements(r2irev))
flowtimerev=dblarr(n_elements(r2irev))
dflowtimerev[0:indexsonic-1]=0.0D
flowtimerev[0:indexsonic-1]=0.0D
S_TO_DAY=1.0d/(24.0D*3600.0D)
FOR l=indexsonic, ndi - 1.0D DO BEGIN
dflowtimerev[l]=S_TO_DAY*(r2irev[l]-r2irev[l-1])*1e5/v2irev[l] ;in days
flowtimerev[l]=flowtimerev[l-1]+dflowtimerev[l]
ENDFOR

;downsizing flowtimerev vector into r2 grid: find index of values of the interpolated r2i grid corresponding to the original r2 grid 
;neargrid=dblarr(i) & indexgrid=neargrid 
FOR k=0, i-1 DO BEGIN
neargridt=Min(Abs(r2[k] - r2i), indexgridt)
indexgridt=indexgridt*1.0D
print,k,neargridt,indexgridt,r2[k],flowtimerev[indexgridt]
;neargrid[i]=neargridt
;indexgrid[i]=index
flowtime[k]=flowtimerev[indexgridt]
ENDFOR

;reversing flowtime to be compatible with r2
flowtime=REVERSE(flowtime)


;linterp,REVERSE(r2i),REVERSE(flowtimerev),r2,flowtime3



vinft=0.
;calculates the terminal velocity as a function of r. Assumes vinf proportional to t, and truncates where
;vinf is greater than vinf on epoch 1. BUG=I am assuming that vinf1 is given by the last v point found in
;rvdenclump1.txt, which MAY BE NOT TRUE IF MODEL 1 is ALSO TIME-DEPENDENT! . 
; WRONG !!! vinf(r) for a given r is increasing as 
; a function of time! This is not physical, the opposite should happen instead. SOLUTION: sum delta t 
; with previous delta t? WRONG!! time variations does NOT match with previous model, i.e. inconsistent.
; apparently is ok now. 

vel_choice='abr'

CASE  vel_choice OF

'lin': BEGIN
for k=0, i-1 do begin
if flowtime[k] le deltat then begin
vinft= v1[0]+(v2[0]-v1[0])/deltat * (deltat-flowtime[k])
vinf[k]=vinft
endif else vinf[k]=v1[0]
endfor
      END

'abr': BEGIN
for k=0, i-1 do begin
if flowtime[k] le deltat then vinf[k]=v2[0] else vinf[k]=v1[0]
endfor
      END      
      
ENDCASE




rstartt=0.
;calculates the stellar radiusas a function of time at each radius, assuming a linear variation along the time
; (R* proportional to t). Truncates where R* is lower than R* on epoch 1, and assumes this value for that
;radius and farther ones
for k=0, i-1 do begin
if flowtime[k] lt deltat then begin
rstartt=r1[i-1]+(r2[i-1]-r1[i-1])/deltat * (deltat-flowtime[k])
rstart[k]=rstartt
endif else rstart[k]=r1[i-1]
endfor

; sets the output radial grid. Assumes that it is the same as model 2.
rout=r2

; Calculates the velocity field; has an option allowing, for v<30km/s, that the current 
; velocity field is kept (epoch2); for v>30km/s we assume a beta=1
; velocity law, with vphot=5, vcore=0.01 and vinf as the value
; calculated for that specific radius in the previouss step.
IF N_elements(beta2) EQ 0 THEN betaout=1.0 ELSE betaout=beta2
for k=0, i-1 do begin
voutt=(5+(vinf[k]-5)*((1-(rstart[k]/r2[k]))^betaout))/(1+(5/0.01)*exp((rstart[k]-r2[k])/(0.04*rstart[k])))
vout[k]=voutt
if voutt lt 20.0 then begin
vout[k]=v2[k]
endif
endfor

; Evaluates sigma doing  (r deltav)/(v delta r) -1      (very crude!)
sigmaout[0]=-0.9999
for k=1, i-1 do begin
sigmaoutt=(rout[k]*(vout[k-1]-vout[k])/(vout[k]*(rout[k-1]-rout[k])))-1
sigmaout[k]=sigmaoutt
endfor

; Evaluates the filling factors for clumping. Currently assumes vc=10 km/s and that finf is not changing
; (f=0.25). TRICKY: if vc is not equal to the value used for model 2, density enhancements/depletion can
; occur.
f=0.25
vc=10
for k=0, i-1 do begin
clumpoutt=f + (1-f)*exp(-vout[k]/vc)
clumpout[k]=clumpoutt
endfor

; Interpolates the Mdot1(r) in the model 2 grid. More physical to be understood than interpolating
; densities. Uses cspline.pro . ASSUMES A CONSTANT VALUE for outer radii if the r grid goes farther in
; model 2 than in model 1.
mdot1regrid=cspline(r1,mdot1,r2) ;interpolate to the same r grid of model 2
for k=0, i-1 do begin
if r2[k] gt r1[0] then begin
mdot1regrid[k]=(mdot1[k+9]+mdot1[k+10])/2.0 ; crudely extrapolates to larger radii
endif
endfor

; Derives the Mdot changes

mdot_choice='abr'

CASE  mdot_choice OF

;assuming that Mdot varies linearly with t
'lin': BEGIN
for k=0, i-1 do begin
if flowtime[k] lt deltat then begin
mdotout[k] = mdot1regrid[k]+((mdot2[k]-mdot1regrid[k])/deltat)*(deltat-flowtime[k])
endif else mdotout[k]=mdot1regrid[k]
endfor
      END

;assuming that Mdot varies abruptly
'abr': BEGIN
for k=0, i-1 do begin
if flowtime[k] le deltat then mdotout[k] =mdot2[k] else mdotout[k]=mdot1regrid[k]
endfor
      END      
      
ENDCASE




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


;printing routine to mdotvinfflow.txt, mainly for debugging purposes.
printf,5,'! Delta t= ',deltat, ' days'
for k=0, i-1 do begin
printf,5,FORMAT='(E12.6,2x,E12.6,2x,E12.6,2x,E12.6,2x,E12.6)',rout[k],vout[k],mdotout[k], vinf[k], flowtime[k]
endfor
close,5

;;general plots, mainly for checking 
;;velocity plots
!P.Background = fsc_color('black')

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
plot,/ylog,yrange=[0.1,1000],alog10(rout/rout[i-1]),flowtime,psym=1,symsize=1.5,xtitle='log r (CMFGEN units)', ytitle='flow timescale (days)'
;;terminal velocity as a function of r
window,3,xsize=400,ysize=400,retain=2
plot,alog10(rout/rout[i-1]),vinf,psym=1,symsize=1.5,xtitle='log r (CMFGEN units)', ytitle='terminal velocity (km/s)'
plots,alog10(rout/rout[i-1]),vout
plots,alog10(r1/r1[i-1]),v1,color=fsc_color('blue'),linestyle=2
plots,alog10(r2/r2[i-1]),v2,color=fsc_color('red'),linestyle=2
;;plotting Mdot
window,4,xsize=800,ysize=600,retain=2
plot,alog10(r1),alog10(Mdot1),xrange=[2.8,5.3],yrange=[-5.2,-3.5],psym=1,symsize=1.5,xtitle='log r (CMFGEN units)', ytitle='Mdot (Msun/yr)'
plots,alog10(r2),alog10(Mdot2),psym=2,symsize=1.5
plots,alog10(rout),alog10(Mdotout),psym=4,symsize=1.5,color=255

;making psplots
set_plot,'ps'
device,filename='/Users/jgroh/temp/output.eps',/encapsulated,/color,bit=8,xsize=6.48,ysize=10.02,/inches
!p.multi=[0, 1, 5, 0, 0]
;flowtime
plot,/ylog,yrange=[1,4000],alog10(rout),flowtime,xtitle='log r (CMFGEN units)', ytitle='flow timescale (days)',charsize=2,charthick=2
;vinf
plot,alog10(rout),vinf,xtitle='log r (CMFGEN units)', ytitle='terminal velocity (km/s)',charsize=2,charthick=2
;mdot
plot,alog10(r1),alog10(Mdot1),xrange=[2.5,5.5],yrange=[-5,-4],xtitle='log r (CMFGEN units)', ytitle='Mdot (Msun/yr)',charsize=2,charthick=2
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

;;write dummy VM_FILE
;ZE_WRITE_VM_FILE,rout,vout,sigmaout,denout,clumpout,i,'/Users/jgroh/ze_models/timedep_armagh/'+modelout+'/VM_FILE_SCRATCH' 
;
;;write dummy RVSIG_COL
;ZE_WRITE_RVSIG_COL,rout,vout,sigmaout,i,'/Users/jgroh/ze_models/timedep_armagh/'+modelout+'/RVSIG_COL_SCRATCH'  
;!P.Background = fsc_color('white')
;lineplot,rout,vout
;
;ZE_CMFGEN_REV_RVSIG,'/Users/jgroh/ze_models/timedep_armagh/'+modelout+'/RVSIG_COL_SCRATCH','NEWG',routrev,voutrev,sigmaoutrev,ndrev
;
;;write RVSIG_COL
;ZE_WRITE_RVSIG_COL,routrev,voutrev,sigmaoutrev,ndrev,'/Users/jgroh/ze_models/timedep_armagh/'+modelout+'/RVSIG_COL' 
;
;mdotoutrev=cspline(rout,mdotout,routrev) ;interpolate to the same r grid of model 2
;clumpoutrev=cspline(rout,clumpout,routrev) ;interpolate to the same r grid of model 2
;denoutrev=mdotoutrev/(4.D*3.141592*((routrev)^2)*voutrev*(3600.*24*365.)*clumpoutrev/(1.99E+08))
;
;;write VM_FILE
;ZE_WRITE_VM_FILE,routrev,voutrev,sigmaoutrev,denoutrev,clumpoutrev,ndrev,'/Users/jgroh/ze_models/timedep_armagh/'+modelout+'/VM_FILE' 

!P.Background = fsc_color('white')

END
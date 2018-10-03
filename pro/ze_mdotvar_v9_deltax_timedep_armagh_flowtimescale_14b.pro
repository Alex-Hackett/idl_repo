;PRO ZE_MDOTVAR_V9_DELTAX_TIMEDEP_ARMAGH_FLOWTIMESCALE_14b
;14b uses reduction=0.4
;v9 implements the vacuum between the fast and slow winds proposed by Stan Owocki
;velocity law now has v(r)=v1(r) for r <= x1 and v(r)=v2(r) for r >= x2, and a linear interpolation between x2 and x1
;density is set to a very low value between x2 and x1
;computes deltax=x1-x2 (size of the vacuum), x1 (position of the beginning of the old wind), x2 (position of the end of the slow wind, i.e. new wind) for a given deltat
;model numbers are the same as in ze_modtvar_v7 -- the idea is to recompute the models to probe the differences
;starting on 48 we have an option OLDV to keep old velocity structure (v2) for depths where flowtime < delta T 
; compute tflow by integrating the inverse of the velocity law using ZE_COMPUTE_FLOWTIMESCALE
;teff =15.5 kK, mdot=9e-06 Msun/yr
;here deltat=120 days
;v7 tries to implement a non-continuous change in mass loss rate as a function of time (2010Oct19)
;implementing changes to allow for Mdot(t) instead of rho(t). Look at the Mdot plots in IDL 5 window 
;from ze_mdotvar_v2.pro. The changes in Mdot as a function of radius were not physical.
close,/all

OLDV=1

dir_in='/Users/jgroh/ze_models/timedep_armagh/'
modelin='14'
dir_out='/Users/jgroh/ze_models/timedep_armagh/ze_mdotvar_v9_deltax/'
modelout='14b'

;defines file mdotvinfflow.txt ; outputs Mdot, vinf and flowtime as a function of r
mdotvinfflow=dir_out+modelout+'/mdotvinfflow.txt'  
openw,5,mdotvinfflow     ; open file to write

;r and v values of model 1, with increased teff and vinf-150 km/s
ZE_READ_SPECTRA_COL_VEC,dir_in+modelin+'/rv150.txt',r1,v1

;r and v values of model 2
READCOL,'/Users/jgroh/ze_models/timedep_armagh/12/RVSIG_COL',r2,v2,sigma1,depth1,COMMENT='!',F='D,D'

;this was used as input in timedep_Armagh/12/ but is not used here
;ZE_READ_SPECTRA_COL_VEC,dir_in+modelin+'/rv150.txt',r2,v2

nd1=n_elements(r1)
nd2=n_elements(r2)

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

vc=10.0
for k=0, nd1-1 do begin
clump1[k]=f1 + (1-f1)*exp(-v1[k]/vc)
endfor

; Derives the density structure using the equation of mass continuity.
den1=mdot_val1/(4.*3.141592*((r1)^2)*v1*(3600.*24*365.)*clump1/(1.99E+08))

mdot1=4.*3.141592*((r1)^2)*den1*v1*(3600.*24*365.)*clump1/(1.99E+08)

den2=den1
mdot2=mdot1

;reads the elapsed time 
;read,deltat,prompt='Days elapsed between model 1 and model 2: '
deltat=120.0


;rstar1=r1[nd1-1]
;;velocity law for epoch 1:
;vinf1=150.
;v0_1=1.0
;beta1=1.0
;sclht_1=0.04
;;;v2mod=v2
;FOR k=0, nd1-1 do begin
;v1[k]=(v0_1+(vinf1-v0_1)*((1-(r1[nd1-1]/r1[k]))^beta1))/(1.0+(v0_1/sclht_1)*exp((r1[nd1-1]-r1[k])/(sclht_1*r1[nd1-1])))
;endfor

;nd2=n_elements(r2)
;rstar2=r2[nd2-1]
;v2=dblarr(nd2)
;;velocity law for epoch 2:
;vinf2=70.
;v0_2=1.0
;beta2=1.0
;sclht_2=0.04
;;;v2mod=v2
;FOR k=0, nd1-1 do begin
;v2[k]=(v0_2+(vinf2-v0_2)*((1-(r2[nd2-1]/r2[k]))^beta2))/(1.0+(v0_2/sclht_2)*exp((r2[nd2-1]-r2[k])/(sclht_2*r1[nd2-1])))
;endfor

;computes Mdot as a function of r, using the read values of den and v, and the eq. of mass continuity.
;looking at what's happening with Mdot(r).
;mdot1=4.*3.141592*((r1)^2)*den1*v1*(3600.*24*365.)*clump1/(1.99E+08)
mdot2=mdot1
;mdot2=4.*3.141592*((r2)^2)*den2*v2*(3600.*24*365.)*clump2/(1.99E+08)
;60mdot2=4.*3.141592*((r1)^2)*den1*v1*(3600.*24*365.)*clump2/(1.99E+08)
;Mdotout=4.*3.141592*((rout)^2)*denout*vout*(3600.*24*365.)*clumpout/(1.99E+08)

;2010Dec8 Major bug found during Owocki's visit: vacuum should form between the two winds with a size delta x -- this was not being taken into account previously
;because the expansion of the old, fast wind was not being accounted
;now we have to compute flowtimescale1 (of the old wind) and flowtimescale2( of the new, slow wind).
;we do an integration of the inverse of the velocity law, to obtain a more precise flow timescale; assume the flow timescale is 0 below the sonic point
;now uses ZE_COMPUTE_FLOWTIMESCALE to compute flowtimescales
;2010Nov10 Major bug found -- flowtime was not being computed correctly -- should have added the flowtime for all previous depth -- 10-20 % difference though
;rewrote to do interpolation for better accuracy

vs1=15.0
ZE_COMPUTE_FLOWTIMESCALE,r1,v1,nd1,vs1,flowtime1,rirev1,virev1,flowtimerev1,dflowtimerev1

vs2=15.0
ZE_COMPUTE_FLOWTIMESCALE,r2,v2,nd2,vs2,flowtime2,rirev2,virev2,flowtimerev2,dflowtimerev2

;then compute delta_x,x1, x2 for a given deltat using ZE_COMPUTE_DISTANCE_TRAVELED_DELTAT
;for a given deltat after the change, computes:
;x1=position of the beginning of wind 1 (i.e., old wind) 
;x2=position of the end of wind 2 (i.e., new wind) 
;delta_x=x1-x2

ZE_COMPUTE_DISTANCE_TRAVELED_DELTAT,deltat,r1,v1,nd1,vs1,flowtime1,rirev1,virev1,flowtimerev1,dflowtimerev1,x1,x_r1,index_x_r1
ZE_COMPUTE_DISTANCE_TRAVELED_DELTAT,deltat,r2,v2,nd2,vs2,flowtime2,rirev2,virev2,flowtimerev2,dflowtimerev2,x2,x_r2,index_x_r2
delta_x=x1-x2

;change in approch 
;for 'abr', velocity law now has v(r)=v1(r) for r <= x1 and v(r)=v2(r) for r >= x2, and a linear interpolation between x2 and x1
;'lin' has not been implemented yet
;does not calculates the terminal velocity as a function of r anymore. 

vel_choice='abr'

CASE  vel_choice OF

'lin': BEGIN
for k=0, nd2-1 do begin
if flowtime[k] le deltat then begin
vinft= v1[0]+(v2[0]-v1[0])/deltat * (deltat-flowtime[k])
vinf[k]=vinft
endif else vinf[k]=v1[0]
endfor
      END

'abr': BEGIN
voutp=[v1[0:index_x_r1],v2[index_x_r2:nd2-1]]
; sets the output radial grid.
routp=[r1[0:index_x_r1],r2[index_x_r2:nd2-1]]
print,'Suggested Vmax: ', v1[index_x_r1]
print,'Suggested Vmin: ', v2[index_x_r2]
print,'Suggested Number of points in intercal: ', index_x_r2-index_x_r1-1
ZE_CMFGEN_REV_RV,routp,voutp,voutp,voutp,'NEWG',rout,vout,dummy,nddummy
ndout=n_elements(rout)
      END      
      
ENDCASE

rstartt=0.
;calculates the stellar radiusas a function of time at each radius, assuming a linear variation along the time
; (R* proportional to t). Truncates where R* is lower than R* on epoch 1, and assumes this value for that
;radius and farther ones
for k=0, nd2-1 do begin
if flowtime[k] lt deltat then begin
rstartt=r1[nd1-1]+(r2[nd2-1]-r1[nd1-1])/deltat * (deltat-flowtime[k])
rstart[k]=rstartt
endif else rstart[k]=r1[nd1-1]
endfor


; Evaluates sigma doing  (r deltav)/(v delta r) -1      (very crude!)
sigmaout[0]=-0.9999
for k=1, nd2-1 do begin
sigmaoutt=(rout[k]*(vout[k-1]-vout[k])/(vout[k]*(rout[k-1]-rout[k])))-1
sigmaout[k]=sigmaoutt
endfor

; Evaluates the filling factors for clumping. Currently assumes vc=10 km/s and that finf is not changing
; (f=0.25). TRICKY: if vc is not equal to the value used for model 2, density enhancements/depletion can
; occur.
f=0.25
vc=10
for k=0, nd2-1 do begin
clumpoutt=f + (1-f)*exp(-vout[k]/vc)
clumpout[k]=clumpoutt
endfor

; Interpolates the Mdot1(r) in the model 2 grid. More physical to be understood than interpolating
; densities. Uses cspline.pro . ASSUMES A CONSTANT VALUE for outer radii if the r grid goes farther in
; model 2 than in model 1.
mdot1regrid=cspline(r1,mdot1,r2) ;interpolate to the same r grid of model 2
for k=0, nd2-1 do begin
if r2[k] gt r1[0] then begin
mdot1regrid[k]=(mdot1[k+9]+mdot1[k+10])/2.0 ; crudely extrapolates to larger radii
endif
endfor

; Derives the Mdot changes
;not implemented yet -- mdotout has a different radial grid than mdot1 and mdot2
mdot_choice='abr'

CASE  mdot_choice OF

;assuming that Mdot varies linearly with t
'lin': BEGIN
for k=0, nd2-1 do begin
if flowtime[k] lt deltat then begin
mdotout[k] = mdot1regrid[k]+((mdot2[k]-mdot1regrid[k])/deltat)*(deltat-flowtime[k])
endif else mdotout[k]=mdot1regrid[k]
endfor
      END

;assuming that Mdot varies abruptly
'abr': BEGIN
for k=0, nd2-1 do begin
if flowtime[k] le deltat then mdotout[k] =mdot2[k] else mdotout[k]=mdot1regrid[k]
endfor
      END      
      
ENDCASE

; PUT A VERY LOW MDOT IN THE REGION BETWEEN X2 and X1, WHICH SHOULD BE A VACUUM BETWEEN the fast and slow winds, TO GET A LOWEr DENSITY
reduction=0.4
mdotout[index_x_r1:index_x_r2]=mdotout[index_x_r1:index_x_r2]*reduction

; Derives the density variations using the equation of mass continuity.
denout=mdotout/(4.*3.141592*((rout)^2)*vout*(3600.*24*365.)*clumpout/(1.99E+08))

;printing routine to mdotvinfflow.txt, mainly for debugging purposes.
printf,5,'! Delta t= ',deltat, ' days'
for k=0, nd2-1 do begin
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
plot,/ylog,yrange=[0.1,1000],alog10(rout/rout[nd2-1]),flowtime,psym=1,symsize=1.5,xtitle='log r (CMFGEN units)', ytitle='flow timescale (days)'
;;terminal velocity as a function of r
window,3,xsize=400,ysize=400,retain=2
plot,alog10(rout/rout[nd2-1]),vinf,psym=1,symsize=1.5,xtitle='log r (CMFGEN units)', ytitle='terminal velocity (km/s)'
plots,alog10(rout/rout[nd2-1]),vout
plots,alog10(r1/r1[nd2-1]),v1,color=fsc_color('blue'),linestyle=2
plots,alog10(r2/r2[nd2-1]),v2,color=fsc_color('red'),linestyle=2
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

;write dummy VM_FILE
ZE_WRITE_VM_FILE,rout,vout,sigmaout,denout,clumpout,nd2,dir_out+modelout+'/VM_FILE_SCRATCH' 

;write dummy RVSIG_COL
ZE_WRITE_RVSIG_COL,rout,vout,sigmaout,nd2,dir_out+modelout+'/RVSIG_COL_SCRATCH'  
!P.Background = fsc_color('white')

;looks fine -- now all that has to be done is to improve the sampling in the two edges of the vacuum which have indexes index_x_r1 and index_x_r2
;corrects first the inner edge (i.e. index_x_r2) otherwise we will have indexing problems with index_x_r1
print,'Suggested Vmax: ', vout[index_x_r2]
print,'Suggested Vmin: ', vout[index_x_r2+1]
ZE_CMFGEN_REV_RV,rout,vout,sigmaout,sigmaout,'NEWG',routrev1,voutrev1,sigmaoutrev1,ndoutrev1

print,'Suggested Vmax: ', vout[index_x_r1-1]
print,'Suggested Vmin: ', vout[index_x_r1]
ZE_CMFGEN_REV_RV,routrev1,voutrev1,sigmaoutrev1,sigmaoutrev1,'NEWG',routrev2,voutrev2,sigmaoutrev2,ndoutrev2


;write RVSIG_COL
ZE_WRITE_RVSIG_COL,routrev2,voutrev2,sigmaoutrev2,ndoutrev2,dir_out+modelout+'/RVSIG_COL' 

mdotoutrev2=cspline(rout,mdotout,routrev2) ;interpolate to the same r grid of model 2
clumpoutrev2=cspline(rout,clumpout,routrev2) ;interpolate to the same r grid of model 2
denoutrev2=mdotoutrev2/(4.D*3.141592*((routrev2)^2)*voutrev2*(3600.*24*365.)*clumpoutrev2/(1.99E+08))

;write VM_FILE
ZE_WRITE_VM_FILE,routrev2,voutrev2,sigmaoutrev2,denoutrev2,clumpoutrev2,ndoutrev2,dir_out+modelout+'/VM_FILE' 

!P.Background = fsc_color('white')

END
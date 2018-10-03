;PRO ZE_MDOTVAR_V7_TIMEDEP_ARMAGH_21
;trying to merge a hydro structure (model 20) to a time dependent model (model 14)
;timedep armagh_9 reads rv from a model which has ca Teff=15 kK ; mdot should be 7.98e-06 to maintain the Mdot scalling
;timedep_armagh_7 reads rv from a model which has a higher effective temperature of ca 16.6 kK 
;v7 tries to implement a non-continuous change in mass loss rate as a function of time (2010Oct19)
;implementing changes to allow for Mdot(t) instead of rho(t). Look at the Mdot plots in IDL 5 window 
;from ze_mdotvar_v2.pro. The changes in Mdot as a function of radius were not physical.
close,/all

modelout='21'


;defines file mdotvinfflow.txt ; outputs Mdot, vinf and flowtime as a function of r
mdotvinfflow='/Users/jgroh/ze_models/timedep_armagh/'+modelout+'/mdotvinfflow.txt'  
openw,5,mdotvinfflow     ; open file to write

;r and v values from merged rv file
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/ze_models/timedep_armagh/21/rv_merged.txt',r1,v1

;r and v values of model 2
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/ze_models/timedep_armagh/21/rv_merged.txt',r2,v2

i=n_elements(r1)

;declares the arrays
clump1=r1 & rout=r1 &vout=r1 & denout=r1 & mdotout=r1 & clumpout=r1 & sigmaout=r1
r3=r1 & v3=r1 & sigma3=r1 & den3=r1 & clump3=r1 & flowtime=r1 & vinf=r1 & rstart=r1

vout=v1
clumpout=r1
sigmaout=r1

;reads Mdot1
read,mdot_val1,prompt='Mass loss rate of model 1: '

;reads clump1
read,f1,prompt='Clumping filling factor of model 1: '

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

deltat=120d
denout=den1
mdotout=mdot1
vout=v1
rout=r1
clumpout=clump1


; Evaluates sigma doing  (r deltav)/(v delta r) -1      (very crude!)
sigmaout[0]=-0.9999
for k=1, i-1 do begin
sigmaoutt=(rout[k]*(vout[k-1]-vout[k])/(vout[k]*(rout[k-1]-rout[k])))-1
sigmaout[k]=sigmaoutt
endfor



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
;plots,alog10(r2),v2,psym=2,symsize=1.5
plots,alog10(rout),vout,color=255,psym=4,symsize=1.5
;;density plots
window,1,xsize=400,ysize=400,retain=2
plot,alog10(r1),alog10(den1),psym=1,symsize=1.5,xtitle='log r (CMFGEN units)', ytitle='log density (cm-3)'
;plots,alog10(r2),alog10(den2),psym=2,symsize=1.5
plots,alog10(rout),alog10(denout),color=255,psym=4,symsize=1.5
;;flow timescale
window,2,xsize=400,ysize=400,retain=2
plot,/ylog,yrange=[0.1,1000],alog10(rout/rout[i-1]),flowtime,psym=1,symsize=1.5,xtitle='log r (CMFGEN units)', ytitle='flow timescale (days)'
;;terminal velocity as a function of r
window,3,xsize=400,ysize=400,retain=2
plot,alog10(rout),vout,psym=1,symsize=1.5,xtitle='log r (CMFGEN units)', ytitle='velocity (km/s)'
plots,alog10(rout),vout
plots,alog10(r1),v1,color=fsc_color('blue'),linestyle=2
;;plotting Mdot
window,4,xsize=800,ysize=600,retain=2
plot,alog10(r1),alog10(Mdot1),xrange=[2.8,5.3],yrange=[-5.2,-3.5],psym=1,symsize=1.5,xtitle='log r (CMFGEN units)', ytitle='Mdot (Msun/yr)'
;plots,alog10(r2),alog10(Mdot2),psym=2,symsize=1.5
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
;plots,alog10(r2),alog10(Mdot2)
plots,alog10(rout),alog10(Mdotout)
;velocity plots
plot,alog10(r1),v1,xrange=[2.5,5.5],xtitle='log r (CMFGEN units)', ytitle='velocity (km/s)',charsize=2,charthick=2
;plots,alog10(r2),v2
plots,alog10(rout),vout
;density plots
plot,alog10(r1),alog10(den1),xtitle='log r (CMFGEN units)', ytitle='log density (cm-3)',charsize=2,charthick=2
;plots,alog10(r2),alog10(den2)
plots,alog10(rout),alog10(denout)
!p.multi=[0, 0, 0, 0, 0]
device,/close


set_plot,'x'

;write VM_FILE
ZE_WRITE_VM_FILE,rout,vout,sigmaout,denout,clumpout,i,'/Users/jgroh/ze_models/timedep_armagh/'+modelout+'/VM_FILE_NEW' 

;write RVSIG_COL
ZE_WRITE_RVSIG_COL,rout,vout,sigmaout,i,'/Users/jgroh/ze_models/timedep_armagh/'+modelout+'/RVSIG_COL_NEW'  


;change the radial grid?
;number of extra depth points between indexes ind1 and ind 2?
ndext=25
ind1=12
ind2=16
rval_array=dblarr(ndext)
rstep=(rout[ind1]-rout[ind2])/(ndext+1)
for j=0,ndext-1 do  rval_array[j]=rout[ind2]+(j+1)*rstep
rrev=[rout,rval_array]
rrev=rrev(reverse(sort(rrev)))


;;mdot1regrid=cspline(r1,mdot1,r2) ;interpolate to the same r grid of model 2
;
;
;ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/ze_models/timedep_armagh/17/rvnd75.txt',rrev,vrev
;;READCOL,'/Users/jgroh/ze_models/timedep_armagh/3/rvs.txt',rrev,vrev,sigmarev
;;ndrev=n_elements(rrev)
;;mdotoutrev=cspline(rout,mdotout,rrev) ;interpolate to the same r grid of model 2
;;clumpoutrev=cspline(rout,clumpout,rrev) ;interpolate to the same r grid of model 2
;;denoutrev=mdotoutrev/(4.*3.141592*((rrev)^2)*vrev*(3600.*24*365.)*clumpoutrev/(1.99E+08))
;
;;rrev=rout
;;vrev=vout
;
;;rrev[0:11]=rout[0:11]
;;vrev[0:11]=vout[0:11]
;
;;rrev[12:27]=r6[12:27]
;;vrev[12:27]=v6[12:27]
;
;;rrev[28:74]=rout[28:74]
;;vrev[28:74]=vout[28:74]
;
;ndrev=n_elements(rrev)
;sigmaoutrev=dblarr(ndrev)
;mdotoutrev=cspline(rout,mdotout,rrev) ;interpolate to the same r grid of model 2
;clumpoutrev=cspline(rout,clumpout,rrev) ;interpolate to the same r grid of model 2
;denoutrev=mdotoutrev/(4.*3.141592*((rrev)^2)*vrev*(3600.*24*365.)*clumpoutrev/(1.99E+08))
;
;; Evaluates sigma doing  (r deltav)/(v delta r) -1      (very crude!)
;sigmaoutrev[0]=-0.9999
;for k=1, i-1 do sigmaoutrev[k]=(rrev[k]*(vrev[k-1]-vrev[k])/(vrev[k]*(rrev[k-1]-rrev[k])))-1
;
;
;;;write VM_FILE
;ZE_WRITE_VM_FILE,rrev,vrev,sigmaoutrev,denoutrev,clumpoutrev,ndrev,'/Users/jgroh/ze_models/timedep_armagh/'+modelout+'/VM_FILE_NEW'  
;;
;;;write RVSIG_COL
;ZE_WRITE_RVSIG_COL,rrev,vrev,sigmaoutrev,ndrev,'/Users/jgroh/ze_models/timedep_armagh/'+modelout+'/RVSIG_COL_NEW'  

!P.Background = fsc_color('white')

end
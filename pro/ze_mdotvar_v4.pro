;implementing changes to allow for Mdot(t) instead of rho(t). Look at the Mdot plots in IDL 5 window 
;from ze_mdotvar_v2.pro. The changes in Mdot as a function of radius were not physical.
close,/all
;defines file rvdenclump1.txt
rvdenclump1='/aux/pc20072a/jgroh/jgroh/var_mdot/var_191_regrid_223_mdot8/rvdenclump_223.txt'  
openu,1,rvdenclump1     ; open file without writing

;defines file rvdenclump2.txt
rvdenclump2='/aux/pc20072a/jgroh/jgroh/var_mdot/var_191_regrid_223_mdot8/rvdenclump2.txt'
openu,2,rvdenclump2     ; open file without writing

;defines file rvdenclumpout.txt ;mainly for debugging
;rvdenclumpout='/aux/pc20072b/jgroh/temp/output_original.txt'  
;openu,3,rvdenclumpout     ; open file without writing
;close,3


;defines file output.txt ;
output='/aux/pc20072b/jgroh/temp/output_scratch.txt'  
openw,4,output     ; open file to write

;defines file mdotvinfflow.txt ; outputs Mdot, vinf and flowtime as a function of r
mdotvinfflow='/aux/pc20072b/jgroh/temp/mdotvinfflow_scratch.txt'  
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


rvtj='/aux/pc20072a/jgroh/cmfgen_models/agcar/397_red_maxr/RVTJ' 
;rvtj='/aux/pc20072a/jgroh/cmfgen_models/agcar/397/RVTJ'
;rvtj='/aux/pc20072a/jgroh/cmfgen_models/var_mdot/agcar/minimum/1_red_maxr_moredepth_bound/RVTJ'

ZE_READ_RVTJ,rvtj,r,v,sigma,ed,t,chiross,fluxross,atom,ionden,den,clump,ND,NC,NP,NCF,mdot,lstar,output_format_date,$
		completion_of_model,program_date,was_t_fixed,species_name_con

flowtime=dblarr(ND) & vinf=flowtime & rstart=flowtime & vout=flowtime & sigmaout=flowtime & clumpout=flowtime & mdotout=flowtime
denout=flowtime
r1=r & r2=r
v1=v & v2=v
sigma1=sigma & sigma2=sigma
den1=den & den2=den
clump1=clump & clump2=clump
i=ND

;reads the elapsed time 
read,deltat,prompt='Days elapsed between model 1 and model 2: '


;computes Mdot as a function of r, using the read values of den and v, and the eq. of mass continuity.
;looking at what's happening with Mdot(r).
mdot1=4.*3.141592*((r1)^2)*den1*v1*(3600.*24.*365.)*clump1/(1.99E+08)
mdot2=4.*3.141592*((r2)^2)*den2*v2*(3600.*24.*365.)*clump2/(1.99E+08)

;scale Mdot 2 to a different value?

mdot2=2.*mdot2
;updates the value of den2 for the scaled mdot
den2=den2*2.


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
if v2[k] lt 15.0 then  begin
flowtime[k]=0
endif
endfor

;doing numerical integration of the velocity law, to obtain a more precise flow timescale. Have to interpolate vectors to increase
;accuracy,It's working now! 

;trying a consistent flowtime for different models. currently assuming tflow=0 for v<17.

v2r=reverse(v2) ;reversing vector orders to do integral
r2r=reverse(r2) ; same
r2fl=r2r

factor=100. ;usually it's ok for a finer grid
v2i=interpol(v2r,ND*factor)
r2i=interpol(r2r,ND*factor)

flowt_finer=dblarr(ND*factor)
flowt_interp_finalr=dblarr(ND)

vmin=0.6 ;minimum velocity to start computing tflow
minfiner=min(where((v2i-vmin) gt 0.)) ;finding where v lt vmin in finer grid
minfinalr=min(where((v2r-vmin) gt 0.)) ;finding where v lt vmin in final grid

for w=0, ND - 1 do begin
	if w lt minfinalr then begin
	flowt_interp_finalr[w]=0.
	r2fl[w]=r2r[w]
	endif else begin
		maxfiner=min(where((r2i-r2r[w]) ge 0.))
		print,minfiner,maxfiner
		integ,r2i,1./v2i,minfiner,maxfiner,tap
		flowt_interp_finalr[w]=tap*1.157407 ;converting tflow to [days]
		r2fl[w]=r2i[maxfiner] ;output the correct r scale for tflow
		endelse
endfor		

flowtime_rev=REVERSE(flowt_interp_finalr) ;reversing order back again to CMFGEN style
r2flr=reverse(r2fl)    ;reversing order of finer r grid to CMFGEN style

;interpolating to the final r grid of model 2, which has ND depth points
flowtime=cspline(r2flr,flowtime_rev,r2)

;OK hereafter using the more precise flowtime from the integral of the inverse of the velocity law



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

; Interpolates the v1(r) into the model 2 grid.  Uses cspline.pro . ASSUMES A CONSTANT VALUE for outer radii if the r grid goes 
; farther in model 2 than in model 1.
v1regrid=cspline(r1,v1,r2) ;interpolate to the same r grid of model 2
for k=0, i-1 do begin
if r2[k] gt r1[0] then begin
v1regrid[k]=(v1[0]) ; crudely extrapolates to larger radii
endif
endfor

; Calculates the velocity field; has an option allowing, for v<30km/s, that the current 
; velocity field is kept (epoch2); for v>30km/s we assume a beta=1
; velocity law, with vphot=5, vcore=0.01 and vinf as the value
; calculated for that specific radius in the previous step.
for k=0, i-1 do begin
;beta=1
;voutt=(5+(vinf[k]-5)*((1-(rstart[k]/r2[k]))^1.0))/(1+(5/0.01)*exp((rstart[k]-r2[k])/(0.004*rstart[k])))
;beta=4
voutt=(5+(vinf[k]-5)*((1-(rstart[k]/r2[k]))^4.0))/(1+(5/0.01)*exp((rstart[k]-r2[k])/(0.004*rstart[k])))
vout[k]=voutt
;if voutt lt 30.0 then begin
;vout[k]=v2[k]
;endif
if flowtime[k] gt deltat then begin
vout[k]=v1regrid[k]
endif
endfor

;using same velocity field as input
vout=v1


; Evaluates sigma doing  (r deltav)/(v delta r) -1      (very crude!)
sigmaout[0]=-0.999999
for k=1, i-1 do begin
sigmaoutt=(rout[k]*(vout[k-1]-vout[k])/(vout[k]*(rout[k-1]-rout[k])))-1
sigmaout[k]=sigmaoutt
endfor

; Evaluates the filling factors for clumping. Currently assumes vc=10 km/s and that finf is not changing
; (f=0.25). TRICKY: if vc is not equal to the value used for model 2, density enhancements/depletion can
; occur.
f=0.1
vc=20
for k=0, i-1 do begin
clumpoutt=f + (1-f)*exp(-vout[k]/vc)
clumpout[k]=clumpoutt
endfor

clumpout=clump2
sigmout=sigma2
sigmaout[0]=-0.999999
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


; OBSOLETE, NOT USED ANYMORE. Interpolates the density structure of model 1 in the same grid of model 2. Fixes the bug found in 
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

;;general plots, mainly for checking 
;;velocity plots
window,0,xsize=400,ysize=400,retain=2
plot,alog10(r1),v1,psym=1,symsize=1.5,xtitle='log r (CMFGEN units)', ytitle='velocity (km/s)'
plots,alog10(r2),v2,psym=2,symsize=1.5
plots,alog10(rout),vout,color=255,psym=4,symsize=1.5
;;density plots
window,1,xsize=400,ysize=400,retain=2
plot,alog10(r1),alog10(den1),psym=1,symsize=0.5,xtitle='log r (CMFGEN units)', ytitle='log density (cm-3)',xstyle=1,ystyle=1,$
xrange=[2.5,3.5]
plots,alog10(r2),alog10(den2),psym=2,symsize=0.5,color=fsc_color('green')
plots,alog10(rout),alog10(denout),color=fsc_color('red'),psym=4,symsize=0.5
;;flow timescale
window,2,xsize=400,ysize=400,retain=2
plot,/ylog,yrange=[0.1,1000],alog10(rout),flowtime,psym=1,symsize=1.5,xtitle='log r (CMFGEN units)', ytitle='flow timescale (days)'
plots,alog10(r2flr),flowtime_rev,psym=1,symsize=0.5,color=255
;;terminal velocity as a function of r
window,3,xsize=400,ysize=400,retain=2
plot,alog10(rout),vinf,psym=1,symsize=1.5,xtitle='log r (CMFGEN units)', ytitle='terminal velocity (km/s)'
;;plotting Mdot
window,4,xsize=800,ysize=600,retain=2
plot,alog10(r1),alog10(Mdot1),xrange=[2.8,5.3],yrange=[-5.2,-4],psym=1,symsize=1.5,xtitle='log r (CMFGEN units)', ytitle='Mdot (Msun/yr)'
plots,alog10(r2),alog10(Mdot2),psym=2,symsize=1.5
plots,alog10(rout),alog10(Mdotout),psym=4,symsize=1.5,color=255

;making psplots
set_plot,'ps'
device,filename='/aux/pc20072b/jgroh/temp/output.ps',/encapsulated,/color,bit=8,xsize=6.48,ysize=10.02,/inches
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

frvsig='/aux/pc20072a/jgroh/cmfgen_models/var_mdot/agcar/minimum/1_red_maxr_moredepth_bound/RVSIG_COL'
ZE_READ_RVSIGCOL_V2,frvsig,rn,vn,sigman

ND=(size(rn))[1]
i=ND

;interpolating denout,clumpout to the new radii; have to interp in log log
linterp,alog10(rout),alog10(denout),alog10(rn),denout2
denout2=10.^denout2
linterp,alog10(rout),alog10(clumpout),alog10(rn),clumpout2
clumpout2=10.^clumpout2

;;write VM_FILE
;vmfile='/aux/pc20072a/jgroh/cmfgen_models/var_mdot/agcar/minimum/1_red_maxr_moredepth_bound/VM_FILE' 
;ZE_WRITE_VM_FILE,rout,vout,sigmaout,denout,clumpout,i,vmfile
;ZE_WRITE_VM_FILE,rn,vn,sigman,denout2,clumpout2,i,vmfile
;
;;write RVSIG_COL
;rvsig='/aux/pc20072a/jgroh/cmfgen_models/var_mdot/agcar/minimum/1/RVSIG_COL' 
;ZE_WRITE_RVSIG_COL,rout,vout,sigmaout,i,rvsig


end

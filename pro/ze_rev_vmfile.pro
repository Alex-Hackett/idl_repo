;comes from ze_mdotvar_v8.pro; changes mdot in a VMFILE
;v8 reduces the mdot of a given model, keeping the same velocity structure
;v7 tries to implement a non-continuous change in mass loss rate as a function of time (2010Oct19)
;implementing changes to allow for Mdot(t) instead of rho(t). Look at the Mdot plots in IDL 5 window 
;from ze_mdotvar_v2.pro. The changes in Mdot as a function of radius were not physical.
close,/all

modelin='52'
modelout='53'
mdotfactor=3.0

vmfile='/Users/jgroh/ze_models/timedep_armagh/'+modelin+'/VM_FILE'
;rvdenclump1='/Users/jgroh/ze_models/timedep_armagh/1/rvdenclump.txt'  
READCOL,vmfile,r1,v1,sigma1,den1,clump1,SKIPLINE=16
i=n_elements(r1)

;defines file output.txt ;
output='/Users/jgroh/temp/output_scratch.txt'  
openw,4,output     ; open file to write

;defines file mdotvinfflow.txt ; outputs Mdot, vinf and flowtime as a function of r
mdotvinfflow='/Users/jgroh/ze_models/timedep_armagh/'+modelout+'/mdotvinfflow_scratch.txt'  
openw,5,mdotvinfflow     ; open file to write


;declares the arrays
rout=r1 &vout=r1 & denout=r1 & mdotout=r1 & clumpout=r1 & sigmaout=r1
r3=r1 & v3=r1 & sigma3=r1 & den3=r1 & clump3=r1

vout=v1
clumpout=clump1
sigmaout=sigma1

mdot1=4.*3.141592*((r1)^2)*den1*v1*(3600.*24*365.)*clump1/(1.99E+08)
mdotout=mdot1*mdotfactor
; Derives the density variations using the equation of mass continuity.
denout=mdotout/(4.*3.141592*((rout)^2)*vout*(3600.*24*365.)*clumpout/(1.99E+08))

;general printing routine to output.txt, mainly for debugging purposes.
for k=0, i-1 do begin
printf,4,FORMAT='(E12.6,2x,E12.6,2x,E13.6,2x,E12.6,2x,E12.6)',rout[k],vout[k], sigmaout[k], denout[k], clumpout[k]
endfor
close,4

;printing routine to mdotvinfflow.txt, mainly for debugging purposes.
for k=0, i-1 do begin
printf,5,FORMAT='(E12.6,2x,E12.6)',rout[k],mdotout[k]
endfor
close,5

;;general plots, mainly for checking 
;;velocity plots
!P.Background = fsc_color('black')

window,0,xsize=400,ysize=400,retain=2
plot,alog10(r1),v1,psym=1,symsize=1.5,xtitle='log r (CMFGEN units)', ytitle='velocity (km/s)'
plots,alog10(rout),vout,color=255,psym=4,symsize=1.5
;;density plots
window,1,xsize=400,ysize=400,retain=2
plot,alog10(r1),alog10(den1),psym=1,symsize=1.5,xtitle='log r (CMFGEN units)', ytitle='log density (cm-3)'
plots,alog10(rout),alog10(denout),color=255,psym=4,symsize=1.5
;;flow timescale
window,2,xsize=400,ysize=400,retain=2
plot,alog10(rout),vout
plots,alog10(r1),v1,color=fsc_color('blue'),linestyle=2
;;plotting Mdot
window,3,xsize=800,ysize=600,retain=2
plot,alog10(r1),alog10(Mdot1),xrange=[2.8,5.3],yrange=[-5.7,-4],psym=1,symsize=1.5,xtitle='log r (CMFGEN units)', ytitle='Mdot (Msun/yr)'
plots,alog10(rout),alog10(Mdotout),psym=4,symsize=1.5,color=255



;write VM_FILE
ZE_WRITE_VM_FILE,rout,vout,sigmaout,denout,clumpout,i,'/Users/jgroh/ze_models/timedep_armagh/'+modelout+'/VM_FILE'  

;write RVSIG_COL
ZE_WRITE_RVSIG_COL,rout,vout,sigmaout,i,'/Users/jgroh/ze_models/timedep_armagh/'+modelout+'/RVSIG_COL'  

print,mdot1,mdotout

!P.Background = fsc_color('white')

end

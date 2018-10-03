PRO ZE_MDOTVAR_CREATE_VM_FILE_FROM_RVSIG_COL_FILE_AND_FIXED_MDOT_F,modelout,rvsig_file,deltat
;modelout='23'
;deltat=120d
READCOL,'/Users/jgroh/ze_models/timedep_armagh/'+modelout+'/'+rvsig_file,rout,vout,sigmaout,depthout,COMMENT='!'

ND=n_elements(rout)
clumpout=dblarr(nd)
;reads Mdot1
read,mdot_valout,prompt='Mass loss rate of model 1: '

;reads clump1
read,fout,prompt='Clumping filling factor of model 1: '

; Evaluates the filling factors for clumping. Currently assumes vc=10 km/s and that finf is not changing
; (f=0.25). TRICKY: if vc is not equal to the value used for model 2, density enhancements/depletion can
; occur.

vc=10
for k=0, nd-1 do begin
clumpout[k]=fout + (1-fout)*exp(-vout[k]/vc)
endfor

; Derives the density structure using the equation of mass continuity.
denout=mdot_valout/(4.*3.141592*((rout)^2)*vout*(3600.*24*365.)*clumpout/(1.99E+08))

mdotout=4.*3.141592*((rout)^2)*denout*vout*(3600.*24*365.)*clumpout/(1.99E+08)
ZE_WRITE_VM_FILE,rout,vout,sigmaout,denout,clumpout,nd,'/Users/jgroh/ze_models/timedep_armagh/'+modelout+'/VM_FILE_REV'  
ZE_WRITE_RVSIG_COL,rout,vout,sigmaout,nd,'/Users/jgroh/ze_models/timedep_armagh/'+modelout+'/RVSIG_COL_REV'  

;defines file mdotvinfflow.txt ; outputs Mdot, vinf and flowtime as a function of r
mdotvinfflow='/Users/jgroh/ze_models/timedep_armagh/'+modelout+'/mdotvinfflow.txt'  
openw,5,mdotvinfflow     ; open file to write
;printing routine to mdotvinfflow.txt, mainly for debugging purposes.
printf,5,'! Delta t= ',deltat, ' days'
for k=0, nd-1 do begin
printf,5,FORMAT='(E15.8,2x,E15.8,2x,E15.8)',rout[k],vout[k],mdotout[k]
endfor
close,5


END
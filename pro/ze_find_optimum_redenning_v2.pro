;PRO ze_find_optimum_redenning_v2
;has to work here 
mag=[-6.25,-6.4,-7.33]
lambda_all=[3660,4380,5450,6410,7980]
lambda=[4380,5450,7980]

model_array_rot=['P020z14S4_model049869_T020358_L0191044_logg2.200','P025z14S4_model042063_T024625_L0318560_logg2.439','P032z14S4_model075198_T181508_L0337150_logg5.904','P040z14S4_model085774_T211679_L0438412_logg6.142','P060z14S4_model054963_T247137_L0784953_logg6.322',$
 'P085z14S4_model045758_T266698_L1310829_logg6.399','P120z14S4_model064569_T252831_L0856258_logg6.349']  

lstar_array_rot=dblarr(n_elements(model_array_rot)) & tstar_array_rot=lstaR_array_rot &  Mv_array_rot=lstaR_array_rot & Mbol_array_rot=lstaR_array_rot & BC_array_rot=lstaR_array_rot & mstar_array_rot=lstaR_array_rot
teff_Array_rot=[1.954E+04,2.000E+04,1.541E+05,1.611E+05,1.745E+05,1.684E+05,1.745E+05]

model_array_norot=['P025z14S0_model030888_T027115_L0239316_logg2.663','P032z14S0_model029922_T045794_L0367647_logg3.507','P040z14S0new_model106339_T048183_L0482467_logg3.576','P060z14S0_model23950_T224855_L483178_logg6d211_vinf5000','P085z14S0_model024500_T236325_L0899663_logg6.201',$
'P120z14S0_model025926_T167648_L1784201_logg5.527'];,'P150z14S0_model133387_T255016_L0905517_logg6.366']
 
lstar_array_norot=dblarr(n_elements(model_array_norot)) & tstar_array_norot=lstaR_array_norot &  Mv_array_norot=lstaR_array_norot & Mbol_array_norot=lstaR_array_norot & BC_array_norot=lstaR_array_norot & mstar_array_norot=lstaR_array_norot
teff_Array_norot=[2.633E+04,4.048E+04,4.048E+04,1.646E+05,1.669E+05,1.684E+05];,1.672e+05]

dirmod='/Users/jgroh/ze_models/SN_progenitor_grid/'
band='V' 
minusebv=-0.0
av=3.1
ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,dirmod,model_array_rot[0],band,Mstart,Lstart,tstart,absolute_magb,Mbolb,BCv,minusebv=minusebv,av=av

;
;flux6=(flux/36.)/1.03
;
;;redden spectrum multiple times
;o=0
;for a=3.3, 3.8, 0.1 do begin
;for minusebv=-0.50, -0.70, -0.01 do begin
;fm_unred, lambda, flux6, minusebv, flux6d, R_V = a
;;computes residuals
;res=0.
;for k=0, r-2 do begin
;t=1
;while (t le s[1]-2) do begin
;dif=abs(lambdaobs[k]-lambda[t]) & difnext=abs(lambdaobs[k]-lambda[t+1]) & difprev=abs(lambdaobs[k]-lambda[t-1])
;if ((dif lt difnext) and (dif lt difprev)) then begin
;l=t
;endif
;t=t+1
;endwhile
;b[k]=(fluxobs[k]-(flux6d[l]))*(fluxobs[k]-(flux6d[l])); residuals squared
;res=res+b[k] ;sum of residuals squared
;;print,lambdaobs[k],fluxobs[k],flux6d[l],b[k],k
;endfor
;
;;for k=0, u-2 do begin
;;t=1
;;while (t le s[1]-2) do begin
;;dif=abs(lambdaswp[k]-lambda[t]) & difnext=abs(lambdaswp[k]-lambda[t+1]) & difprev=abs(lambdaswp[k]-lambda[t-1])
;;if ((dif lt difnext) and (dif lt difprev)) then begin
;;l=t
;;endif
;;t=t+1
;;endwhile
;;c[k]=(fluxswp[k]-(2*flux6d[l]))*(fluxswp[k]-(2*flux6d[l])); residuals squared
;;res=res+c[k] ;sum of residuals squared
;;print,lambdaswp[k],fluxswp[k],flux6d[l],c[k],k
;;endfor
;
;print,a,minusebv,res
;red1[o]=a & red2[o]=minusebv & red3[o]=res
;o=o+1
;endfor
;endfor
;
;red1=red1(where(red1 gt 0.))
;red2=red2(where(red1 gt 0.))
;red3=red3(where(red1 gt 0.))
;
;;finds the minimum residual
;;d=red(where(red eq min(red[2,*])))
;resultado=min(red3)
;d=where(red3 eq min(red3))
;print,red1[d],red2[d]
;
;;final redenning
;minusebv=-0.65
;a=3.4
;;fm_unred, lambda, flux6, minusebv, flux6dfin, R_V = a
;;fm_unred,lambda, flux6, -0.58, flux6dfin_prevred, R_V = 4.0
;
;
;; plot spectrum
;window,0,xsize=600,ysize=600,retain=2
;plot,alog10(lambda),alog10(flux6dfin),yrange=[-14,-10],xrange=[3,5],xtitle='wavelength (Angstrom)', ytitle='Flux (erg/s/cm^2/Angstrom)'
;;plots,lambda2,obsflux,color=255
;plots,alog10(lambdaobs),alog10(fluxobs),color=255,psym=1
;;plots,alog10(lambda),alog10(flux6dfin_prevred),color=255
;;plots,alog10(lambdaswp),alog10(fluxswp),color=255,psym=1
;;plots,alog10(lambdalwp),alog10(fluxlwp),color=255,psym=1
;;plots,alog10(lambda),alog10(2*flux6dfin),color=255
end
;PRO ZE_WORK_SN_SPECTRA_FLASH_CSM_PREDICTION_WITH_TAKASHI

readcol,'/Users/jgroh/papers_in_preparation_groh/sn_flash_spectra_prediction_takashi/Model2t02.dat',r02,v02,den02,tau02,t02,l02,skipline=1

tau02c=tau02[where(tau02 lt 30.0)]
r02c=r02[where(tau02 lt 30.0)]
v02c=v02[where(tau02 lt 30.0)]
den02c=den02[where(tau02 lt 30.0)]
t02c=t02[where(tau02 lt 30.0)]

readcol,'/Users/jgroh/papers_in_preparation_groh/sn_flash_spectra_prediction_takashi/Model2t05.dat',r05,v05,den05,tau05,t05,l05,skipline=1

tau05c=tau05[where(tau05 lt 30.0)]
r05c=r05[where(tau05 lt 30.0)]
v05c=v05[where(tau05 lt 30.0)]
den05c=den05[where(tau05 lt 30.0)]
t05c=t05[where(tau05 lt 30.0)]

readcol,'/Users/jgroh/papers_in_preparation_groh/sn_flash_spectra_prediction_takashi/Model2t10.dat',r10,v10,den10,tau10,t10,l10,skipline=1

tau10c=tau10[where(tau10 lt 30.0)]
r10c=r10[where(tau10 lt 30.0)]
v10c=v10[where(tau10 lt 30.0)]
den10c=den10[where(tau10 lt 30.0)]
t10c=t10[where(tau10 lt 30.0)]


readcol,'/Users/jgroh/papers_in_preparation_groh/sn_flash_spectra_prediction_takashi/Model2t15.dat',r15,v15,den15,tau15,t15,l15,skipline=1

tau15c=tau15[where(tau15 lt 30.0)]
r15c=r15[where(tau15 lt 30.0)]
v15c=v15[where(tau15 lt 30.0)]
den15c=den15[where(tau15 lt 30.0)]
t15c=t15[where(tau15 lt 30.0)]


;###### 1e-3 Msun/yr
readcol,'/Users/jgroh/papers_in_preparation_groh/sn_flash_spectra_prediction_takashi/Model2p5t03.dat',rb3,vb3,denb3,taub3,tb3,lb3,skipline=1

taub3c=taub3[where(taub3 lt 30.0)]
rb3c=rb3[where(taub3 lt 30.0)]
vb3c=vb3[where(taub3 lt 30.0)]
denb3c=denb3[where(taub3 lt 30.0)]
tb3c=tb3[where(taub3 lt 30.0)]


rvtj='/Users/jgroh/ze_models/prog13ast/2//RVTJ'
ZE_READ_RVTJ,rvtj,r,v,sigma,ed,t,chiross,fluxross,atom,ionden,den,clump,ND,NC,NP,NCF,mdot,lstar,output_format_date,$
    completion_of_model,program_date,was_t_fixed,species_name_con,greyt,heating_rad_decay

ZE_CMFGEN_COMPUTE_OPTICAL_DEPTH_TORSCL,CHIross,R,tauross

ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/SN_flash_prediction_takashi/model2/obs/obs_fin',l2,f2,/FLAM,lmin=1000,lmax=9000;,/AIR

ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/prog13ast/2/obs/obs_fin',lprog,fprog,/FLAM,lmin=1150,lmax=9000 ; this is for L=5e6; appropriate for t=2d and t=5d

ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/98s/23/obs/obs_fin',l10,f10,/FLAM,lmin=1150,lmax=9000 ; this is for L=3e10 ;  this roughly OK for t=10d

;quantities from Takashi model 2:
;t=2d : L=40.149 (3.67e6 Lsun) R_front=1.06e14 ; R(tau=30)=1.8e14  ;T(tau=30)=4.97e3
;t=5d : L=41.568 (9.63e7 Lsun) R_front=2.36e14 ; R(tau=30)=3.9e14  ;T(tau=30)=7.64e3
;t=10d : L=43.089 (3.63e9 Lsun) R_front=4.38e14 ; R(tau=30)=5.05e14 ;T(tau=30)=16.73e3
;t=15d : L=43.540 (9.02e9 Lsun) R_front=6.28e14 ; R(tau=30)=6.28e14 ;T(tau=30)=18.75e3

;quantities from Takashi model 2b:
;t=3d : L=41.965 (2.4e8 Lsun) R_front=1.66e14 ; R(tau=30)=1.66e14  ;T(tau=30)=15.0e3

;t=5d : L=41.568 (9.63e7 Lsun) R_front=2.36e14 ; R(tau=30)=3.9e14  ;T(tau=30)=7.64e3
;t=10d : L=43.089 (3.63e9 Lsun) R_front=4.38e14 ; R(tau=30)=5.05e14 ;T(tau=30)=16.73e3
;t=15d : L=43.540 (9.02e9 Lsun) R_front=6.28e14 ; R(tau=30)=6.28e14 ;T(tau=30)=18.75e3

ZE_COMPUTE_T_FROM_R_L,1.8e14/(6.96e10),3.67e6,tstar

ZE_COMPUTE_T_FROM_R_L,3.9e14/(6.96e10),9.63e7,tstar

ZE_COMPUTE_T_FROM_R_L,5.0e14/(6.96e10),3.63e9,tstar

ZE_COMPUTE_T_FROM_R_L,6.28e14/(6.96e10),9.02e9,tstar

ZE_COMPUTE_T_FROM_R_L,1.6e14/(6.96e10),2.4e8,tstar

ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,lprog,fprog*3.67/5.0,'Wavelength (Angstrom)', 'Flux (erg/s/cm2/Angstrom)','',/ylog,$
                          x2=lprog,y2=fprog*96.3/5.0,linestyle2=0,$
                          x3=l10,y3=f10*3.63/30.0,linestyle3=0,$
                          x4=l10,y4=f10*9.02/30.0,linestyle4=0,$
;                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
;                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
;                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
;                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
;                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
;                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
                          pthick=6,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=800,bb=500,$
                          xrange=[3000,6700],yrange=[1.0e-9,4e-5],POSITION=[0.14,0.10,0.98,0.98],filename='model2_with_takashi_shifted';,/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.05,id_ypos=10.5,size_id_text=1.0,elem=elem





END
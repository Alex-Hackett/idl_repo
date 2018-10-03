;PRO ZE_WORK_ARMAGH
!P.Background = fsc_color('white')
mdotsym= '!3!sM!r!u^!n'
;rvtj='/Volumes/Toshiba/ze_models/agcar/415/RVTJ'
;
;ZE_READ_RVTJ,rvtj,r,v,sigma,ed,t,chiross,fluxross,atom,ionden,denclump,clump,ND,NC,NP,NCF,mdot,lstar,output_format_date,$
;    completion_of_model,program_date,was_t_fixed,species_name_con
;
;vmfile='/Users/jgroh/temp/VM_FILE'
;ZE_WRITE_VM_FILE,r,v,sigma,denclump,clump,ND,vmfile

;
;;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/timedep_armagh/411timedep/obs_halpha/obs_fin',l1,f1,nrec1,/FLAM
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/411timedep/obs/obs_fin','/Users/jgroh/ze_models/timedep_armagh/411timedep/obscont/obs_fin',l1,f1n,/AIR ;30% increase in rho in the velocity range 144-178 km/s
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/411timedep2/obs/obs_fin','/Users/jgroh/ze_models/timedep_armagh/411timedep2/obscont/obs_fin',l2,f2n,/AIR ;80% increase in rho in the velocity range 144-178 km/s
;;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/timedep_armagh/411timedep2/obs_halpha/obs_fin',l2,f2,nrec2,/FLAM
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Volumes/Toshiba/cmfgen_models/agcar/411/obs/obs_fin','/Volumes/Toshiba/cmfgen_models/agcar/411/obscont/obs_fin',lorig,forign,/AIR
;
;;lineplot,l1,f1n
;;lineplot,l2,f2n
;;lineplot,lorig,forign
;
;
;ZE_READ_RVTJ,'/Users/jgroh/ze_models/timedep_armagh/411timedep/RVTJ',r1,v1,sigma1,ed,t,chiross,fluxross,atom,ionden,denclump1,clump1,ND,NC,NP,NCF,mdot,lstar,output_format_date,$
;    completion_of_model,program_date,was_t_fixed,species_name_con
;
;ZE_READ_RVTJ,'/Users/jgroh/ze_models/timedep_armagh/411timedep2/RVTJ',r2,v2,sigma2,ed,t,chiross,fluxross,atom,ionden,denclump2,clump2,ND,NC,NP,NCF,mdot,lstar,output_format_date,$
;    completion_of_model,program_date,was_t_fixed,species_name_con
;
;ZE_READ_RVTJ,'/Volumes/Toshiba/cmfgen_models/agcar/411/RVTJ',rorig,vorig,sigmaorig,ed,t,chiross,fluxross,atom,ionden,denclumporig,clumporig,ND,NC,NP,NCF,mdot,lstar,output_format_date,$
;    completion_of_model,program_date,was_t_fixed,species_name_con
;    
;lineplot,r1,denclump1
;lineplot,r2,denclump2
;lineplot,rorig,denclumporig
;

;plots of mdot as a function of teff for the AG Car models
;ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/espectros/agcar/teff_variatons.txt',year,teff
;;ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/espectros/agcar/mdot_variatons.txt',year2,mdot
;ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/espectros/agcar/mdot_timedep_24oct10_armagh.txt',year2,mdottd
;teff_rise1=teff[0:11]
;mdottd_rise1=mdottd[0:11]
;teff_decline1=teff[11:18]
;mdottd_decline1=mdottd[11:18]
;teff_rise2=teff[18:24]
;mdottd_rise2=mdottd[18:24]



ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/1/obs/obs_fin','/Users/jgroh/ze_models/timedep_armagh/1/obscont/obs_fin',l1,f1n,/AIR
f1n=f1n[577:59717]
l1=l1[577:59717]

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/2/obs/obs_fin','/Users/jgroh/ze_models/timedep_armagh/2/obscont/obs_fin',l2,f2n,/AIR
f2n=f2n[577:59717]
l2=l2[577:59717]

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/3/obs/obs_fin','/Users/jgroh/ze_models/timedep_armagh/3/obscont/obs_fin',l3,f3n,/AIR
f3n=f3n[577:59717]
l3=l3[577:59717]

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/4/obs/obs_fin','/Users/jgroh/ze_models/timedep_armagh/4/obscont/obs_fin',l4,f4n,/AIR
f4n=f4n[577:59717]
l4=l4[577:59717]

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/5/obs/obs_fin','/Users/jgroh/ze_models/timedep_armagh/5/obscont/obs_fin',l5,f5n,/AIR
f5n=f5n[577:59717]
l5=l5[577:59717]
ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/5/obs_halpha_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/5/obscont/obs_fin',l5v10,f5v10n,/AIR

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/6/obs/obs_fin','/Users/jgroh/ze_models/timedep_armagh/6/obscont/obs_fin',l6,f6n,/AIR
f6n=f6n[577:59717]
l6=l6[577:59717]
ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/6/obs_halpha_v5/obs_fin','/Users/jgroh/ze_models/timedep_armagh/6/obscont/obs_fin',l6v5,f6v5n,/AIR
ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/6/obs_halpha_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/6/obscont/obs_fin',l6v10,f6v10n,/AIR


ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/10/obs/obs_fin','/Users/jgroh/ze_models/timedep_armagh/10/obscont/obs_fin',l10,f10n,/AIR
f10n=f10n[577:59717]
l10=l10[577:59717]

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/12/obs/obs_fin','/Users/jgroh/ze_models/timedep_armagh/12/obscont/obs_fin',l12,f12n,/AIR
f12n=f12n[577:59717]
l12=l12[577:59717]
ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/12/obs_halpha_v5/obs_fin','/Users/jgroh/ze_models/timedep_armagh/12/obscont/obs_fin',l12v5,f12v5n,/AIR
ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/12/obs_halpha_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/12/obscont/obs_fin',l12v10,f12v10n,/AIR


ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/13/obs/obs_fin','/Users/jgroh/ze_models/timedep_armagh/13/obscont/obs_fin',l13,f13n,/AIR
f13n=f13n[577:59717]
l13=l13[577:59717]

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/14/obs/obs_fin','/Users/jgroh/ze_models/timedep_armagh/14/obscont/obs_fin',l14,f14n,/AIR
f14n=f14n[577:59717]
l14=l14[577:59717]

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/14/obs_halpha_v5/obs_fin','/Users/jgroh/ze_models/timedep_armagh/14/obscont/obs_fin',l14v5,f14v5n,/AIR
ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/14/obs_halpha_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/14/obscont/obs_fin',l14v10,f14v10n,/AIR

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/15/obs/obs_fin','/Users/jgroh/ze_models/timedep_armagh/15/obscont/obs_fin',l15,f15n,/AIR
f15n=f15n[577:59717]
l15=l15[577:59717]
ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/15/obs_halpha_v5/obs_fin','/Users/jgroh/ze_models/timedep_armagh/15/obscont/obs_fin',l15v5,f15v5n,/AIR
ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/15/obs_halpha_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/15/obscont/obs_fin',l15v10,f15v10n,/AIR



ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/16/obs_halpha/obs_fin','/Users/jgroh/ze_models/timedep_armagh/16/obscont/obs_fin',l16,f16n,/AIR
;f16n=f16n[577:59717]
;l16=l16[577:59717]

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/agcar/415/obs/obs_fin','/Users/jgroh/ze_models/agcar/415/obscont/obs_fin',l415,f415n,/AIR
f415n=f415n[577:59717]
l415=l415[577:59717]

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/20/obs_halpha_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/20/obscont/obs_fin',l20v10,f20v10n,/AIR

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/22/obs/obs_fin','/Users/jgroh/ze_models/timedep_armagh/22/obscont/obs_fin',l22,f22n,/AIR
f22n=f22n[577:59717]
l22=l22[577:59717]

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/22/obs_halpha_v5/obs_fin','/Users/jgroh/ze_models/timedep_armagh/22/obscont/obs_fin',l22v5,f22v5n,/AIR
ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/22/obs_halpha_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/22/obscont/obs_fin',l22v10,f22v10n,/AIR

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/23/obs/obs_fin','/Users/jgroh/ze_models/timedep_armagh/23/obscont/obs_fin',l23,f23n,/AIR
f23n=f23n[577:59717]
l23=l23[577:59717]

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/24/obs_halpha/obs_fin','/Users/jgroh/ze_models/timedep_armagh/24/obscont/obs_fin',l24,f24n,/AIR
ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/24/obs_halpha_v5/obs_fin','/Users/jgroh/ze_models/timedep_armagh/24/obscont/obs_fin',l24v5,f24v5n,/AIR
ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/24/obs_halpha_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/24/obscont/obs_fin',l24v10,f24v10n,/AIR
;f24n=f24n[577:59717]
;l24=l24[577:59717]

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/25/obs/obs_fin','/Users/jgroh/ze_models/timedep_armagh/25/obscont/obs_fin',l25,f25n,/AIR
f25n=f25n[577:59717]
l25=l25[577:59717]
ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/25/obs_halpha_v5/obs_fin','/Users/jgroh/ze_models/timedep_armagh/25/obscont/obs_fin',l25v5,f25v5n,/AIR
ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/25/obs_halpha_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/25/obscont/obs_fin',l25v10,f25v10n,/AIR

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/34/obs_halpha/obs_fin','/Users/jgroh/ze_models/timedep_armagh/34/obscont/obs_fin',l34,f34n,/AIR

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/35/obs_halpha/obs_fin','/Users/jgroh/ze_models/timedep_armagh/35/obscont/obs_fin',l35,f35n,/AIR

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/36/obs_halpha/obs_fin','/Users/jgroh/ze_models/timedep_armagh/36/obscont/obs_fin',l36,f36n,/AIR

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/37/obs_halpha/obs_fin','/Users/jgroh/ze_models/timedep_armagh/37/obscont/obs_fin',l37,f37n,/AIR

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/40/obs/obs_fin','/Users/jgroh/ze_models/timedep_armagh/40/obscont/obs_fin',l40,f40n,/AIR
f40n=f40n[577:59717]
l40=l40[577:59717]
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/40/obs_halpha_v5/obs_fin','/Users/jgroh/ze_models/timedep_armagh/40/obscont/obs_fin',l40v5,f40v5n,/AIR
ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/40/obs_halpha_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/40/obscont/obs_fin',l40v10,f40v10n,/AIR

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/42/obs_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/42/obscont/obs_fin',l42v10,f42v10n,/AIR
;f42v10n=f42v10n[577:59717]
;l42v10=l42v10[577:59717]
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/42/obs_halpha_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/42/obscont/obs_fin',l42v10,f42v10n,/AIR

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/43/obs_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/43/obscont/obs_fin',l43v10,f43v10n,/AIR
;f43v10n=f43v10n[577:59717]
;l43v10=l43v10[577:59717]
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/43/obs_halpha_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/43/obscont/obs_fin',l43v10,f43v10n,/AIR

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/44/obs_halpha_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/44/obscont/obs_fin',l44v10,f44v10n,/AIR

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/45/obs_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/45/obscont/obs_fin',l45v10,f45v10n,/AIR

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/48/obsip_halpha_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/48/obscont/obs_fin',l48v10,f48v10n,/AIR

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/50/obs_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/50/obscont/obs_fin',l50v10,f50v10n,/AIR

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/51/obs_halpha_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/51/obscont/obs_fin',l51v10,f51v10n,/AIR

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/52/obs_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/52/obscont/obs_fin',l52v10,f52v10n,/AIR

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/442/obs_halpha/obs_fin','/Users/jgroh/ze_models/timedep_armagh/442/obscont/obs_fin',l442,f442n,/AIR

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/444/obs_halpha_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/444/obscont/obs_fin',l444v10,f444v10n,/AIR

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/446/obs_halpha_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/446/obscont/obs_fin',l446v10,f446v10n,/AIR

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/447/obs_halpha_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/447/obscont/obs_fin',l447v10,f447v10n,/AIR

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/449/obs_halpha_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/449/obscont/obs_fin',l449v10,f449v10n,/AIR

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/451/obs_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/451/obscont/obs_fin',l451v10,f451v10n,/AIR

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/452/obs_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/452/obscont/obs_fin',l452v10,f452v10n,/AIR

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/454/obs_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/454/obscont/obs_fin',l454v10,f454v10n,/AIR


;new models with delta_x and vacuum implemented
ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/ze_mdotvar_v9_deltax/14c/obs_halpha_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/14/obscont/obs_fin',l14cnewv10,f14cnewv10n,/AIR ;has deltax but reduction=1.0 (i.e no vacuum)

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/timedep_armagh/ze_mdotvar_v9_deltax/15/obs_halpha_v10/obs_fin','/Users/jgroh/ze_models/timedep_armagh/15/obscont/obs_fin',l15cnewv10,f15cnewv10n,/AIR ;has deltax but reduction=1.0 (i.e no vacuum)



;lineplot,l1,f1n
;lineplot,l2,f2n
;lineplot,l4,f4n
;lineplot,l415,f415n

lambda0=4340.464 ;for Hgamma
;lineplot,l1,f1n,title='timedep 1: vinf1=150, vinf2=70, deltat=120d,Mdot=6e-05' 
;lineplot,l2,f2n,title='timedep 2: vinf1=150, vinf2=70, deltat=120d,Mdot=1.8e-05' 
;lineplot,l3,f3n,title='timedep 3: vinf1=150, vinf2=70, deltat=120d,Mdot=3e-05' 
;lineplot,l4,f4n,title='timedep 4: vinf1=150, vinf2=70, deltat=120d,Mdot1=6e-05, Mdot2=1.2e-04' 
;lineplot,l5,f5n,title='timedep 5: vinf1=150, vinf2=70, deltat=120d,Mdot=5.4e-06' 
;lineplot,l6,f6n,title='timedep 6: vinf1=150, vinf2=70, deltat=120d,Mdot=9e-06,vturb=20km/s'
;lineplot,l6v5,f6v5n,title='timedep 6: vinf1=150, vinf2=70, deltat=120d,Mdot=9e-06,vturb=5km/s'
;lineplot,l6v10,f6v10n,title='timedep 6: vinf1=150, vinf2=70, deltat=120d,Mdot=9e-06,vturb=10km/s'
;lineplot,l10,f10n,title='timedep 10: vinf1=150, vinf2=70, deltat=120d,Mdot=1.3e-05,vturb=20km/s'
;lineplot,l12,f12n,title='timedep 12: vinf1=150, vinf2=70, deltat=120d,Mdot=7.3e-06,vturb=20km/s, Teff=15.5kK'
;lineplot,l13,f13n,title='timedep 13: vinf1=150, vinf2=70, deltat=120d,Mdot=5.8e-06,vturb=20km/s, Teff=15.5kK'
;lineplot,l14,f14n,title='timedep 14: vinf1=150, vinf2=70, deltat=120d,Mdot=9.5e-06,vturb=20km/s, Teff=15.5kK'
;lineplot,l15,f15n,title='timedep 15: vinf1=150, vinf2=70, deltat=120d,Mdot=1.17e-05,vturb=20km/s, Teff=15.5kK'
;lineplot,l16,f16n,title='timedep 16: vinf1=150, vinf2=70,continuous, deltat=120d,Mdot=9e-06,vturb=20km/s', Teff=15.5kK'
;lineplot,l22,f22n,title='timedep 22: vinf1=150, vinf2=70, deltat=120d,Mdot=9.0e-06,vturb=20km/s, Teff=16.4kK'
;lineplot,l23,f23n,title='timedep 23: vinf1=150, vinf2=70, deltat=120d,Mdot=9.0e-06,vturb=20km/s, Teff=17.0kK'
;lineplot,l24,f24n,title='timedep 24: vinf1=150, vinf2=70, deltat=120d,Mdot=6.3e-06,vturb=20km/s, Teff=16.4kK'
;lineplot,l25,f25n,title='timedep 25: vinf1=150, vinf2=70, deltat=120d,Mdot=1.17e-05,vturb=20km/s, Teff=16.4kK'
;lineplot,l40,f40n,title='timedep 40: vinf1=150, vinf2=70, deltat=120d,Mdot=1.17e-05,vturb=20km/s, Teff=13.4kK'
;lineplot,l20v10,f20v10n,title='timedep 13: vinf1=150, vinf2=70, deltat=0d (ie steady state),Mdot=9e-06,vturb=10km/s, Teff=15.5kK'
;lineplot,l42v10,f42v10n,title='timedep 42: vinf1=150, vinf2=70, deltat=60d,Mdot=9e-06,vturb=10km/s, Teff=15.5kK'
;lineplot,l14v10,f14v10n,title='timedep 14: vinf1=150, vinf2=70, deltat=120d,Mdot=9.5e-06,vturb=10km/s, Teff=15.5kK'
;lineplot,l43v10,f43v10n,title='timedep 43: vinf1=150, vinf2=70, deltat=240d,Mdot=9e-06,vturb=10km/s, Teff=15.5kK'
;lineplot,l44v10,f44v10n,title='timedep 44: vinf1=150, vinf2=70, deltat=480d,Mdot=9e-06,vturb=10km/s, Teff=15.5kK'
;lineplot,l45v10,f45v10n,title='timedep 45: vinf1=150, vinf2=70, deltat=960d,Mdot=9e-06,vturb=10km/s, Teff=15.5kK'

;lineplot,l2,f2n,        title='timedep 2:  vinf1=150, vinf2=70, deltat=120d,Mdot=1.8e-05,vturb=20 m/s Teff=13.0kK'
;lineplot,l48v10,f48v10n,title='timedep 48: vinf1=150, vinf2=70, deltat=240d,Mdot=.02e-05,vturb=10km/s, Teff=13.0kK'

;lineplot,l44v10,f44v10n,title='timedep 44: vinf1=150, vinf2=70, deltat=480d,Mdot=9e-06,vturb=10km/s, Teff=15.5kK'
;lineplot,l50v10,f50v10n,title='timedep 50: vinf1=150, vinf2=70, deltat=480d,Mdot=1.17e-05,vturb=10km/s, Teff=15.5kK'
;lineplot,l52v10,f52v10n,title='timedep 52: vinf1=150, vinf2=70, deltat=480d,Mdot=1.8e-05,vturb=10km/s, Teff=15.5kK'

;lineplot,l415,f415n,title='steady state'
;lineplot,l444v10,f444v10n,title='steady state:vinf1=70, L*=1e6, Mdot=9e-06,vturb=10 km/s, Teff=13.0kK'
;lineplot,l446v10,f446v10n,title='steady state:vinf1=70, L*=5e6, Mdot=3e-05,vturb=10 km/s, Teff=13.0kK'
;lineplot,l447v10,f447v10n,title='steady state:vinf1=70, L*=2.5e6, Mdot=1.8e-05,vturb=10 km/s, Teff=13.0kK'
;lineplot,l449v10,f449v10n,title='steady state:vinf1=70, L*=1e7, Mdot=5e-05,vturb=10 km/s, Teff=13.0kK'
;lineplot,l452v10,f452v10n,title='steady state:vinf1=70, L*=2.5e7, Mdot=1.0e-04,vturb=10 km/s, Teff=13.0kK'
;lineplot,l451v10,f451v10n,title='steady state:vinf1=70, L*=5e7, Mdot=1.67e-04,vturb=10 km/s, Teff=13.0kK'


rvtj='/Users/jgroh/ze_models/timedep_armagh/6/RVTJ'
ZE_READ_RVTJ,rvtj,r6,v6,sigma,ed,t,chiross,fluxross,atom,ionden,denclump6,clump,ND,NC,NP,NCF,mdot,lstar,output_format_date,$
    completion_of_model,program_date,was_t_fixed,species_name_con

r6_to_rstar=alog10(r6/r6[nd-1])

rvtj='/Users/jgroh/ze_models/timedep_armagh/16/RVTJ'
ZE_READ_RVTJ,rvtj,r16,v16,sigma,ed,t,chiross,fluxross,atom,ionden,denclump16,clump,ND,NC,NP,NCF,mdot,lstar,output_format_date,$
    completion_of_model,program_date,was_t_fixed,species_name_con
r16_to_rstar=alog10(r16/r16[nd-1])

rvtj='/Users/jgroh/ze_models/agcar/415/RVTJ'
ZE_READ_RVTJ,rvtj,r415,v415,sigma,ed,t,chiross,fluxross,atom,ionden,denclump415,clump,ND,NC,NP,NCF,mdot,lstar,output_format_date,$
    completion_of_model,program_date,was_t_fixed,species_name_con
r415_to_rstar=alog10(r415/r415[nd-1])


;observations
spec_dir='/Users/jgroh/espectros/agcar/'
file='ag_car.03jan92'
ZE_READ_SPECTRA_COL_VEC,spec_dir+file,l92,f92
file='ag_car.21jan91'
ZE_READ_SPECTRA_COL_VEC,spec_dir+file,l91,f91
ZE_READ_SPECTRA_FITS,'/Users/jgroh/espectros/agcar_stahl/ls97/r/f0020.fits',l97,f97
;;lineplot,l92,f92
;
;file='ag_car.may93'
;ZE_READ_SPECTRA_COL_VEC,spec_dir+file,l93,f93
;;lineplot,l93,f93
;
;file='ag_car.25dec94'
;ZE_READ_SPECTRA_COL_VEC,spec_dir+file,l94d,f94d
;;lineplot,l94d,f94d
;
;;file='agcar_uves_03jan11n.txt'
;;ZE_READ_SPECTRA_COL_VEC,spec_dir+file,l03,f03
;;lineplot,l03,f03
;
;
;spec_dir='/Users/jgroh/espectros/wra751/'
;file='wra751_08apr18_66n_hel.fits'
;ZE_READ_SPECTRA_FITS,spec_dir+file,lw2,fw2
;lineplot,lw2,fw2
;
;ZE_READ_SPECTRA_FITS,'/Users/jgroh/espectros/feros_publicos/agc98nov18n.fits',l98n,f98n
;ZE_READ_SPECTRA_FITS,'/Users/jgroh/espectros/agcar/agc98dec24n.fits',l98d,f98d ;good one with barely splitted abs line profile
;ZE_READ_SPECTRA_FITS,'/Users/jgroh/espectros/feros_publicos/hrcar_98nov18.fits',l98h,f98h ;good one with barely splitted abs line profileh
;ZE_READ_SPECTRA_FITS,'/Users/jgroh/data/eso_3d6m/harps/Advanced_Data_Products/agcar/ADP.HARPS.2008-02-17T05:15:03.863_03_S1D_A.fits',la08,fa08
;;ZE_READ_SPECTRA_FITS,'/Users/jgroh/data/eso_3d6m/harps/Advanced_Data_Products/agcar/ADP.HARPS.2009-02-09T08:00:13.433_03_S1D_A.fits',la09,fa09

;lineplot,la08,fa08
;;line_norm,la09,fa09,fa09n,norm09a,xnodes,ynodes
;ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/espectros/agcar/agc_2009feb09_harps_n.txt',la09,fa09n
;lineplot,la09,fa09n



;compute tstar from rstar and l
rstar=(758.60/6.96)
lstar=1E+06
tstar1=5.780*(lstar^0.25/(rstar^0.5) )
print,tstar1


;FIGURE 1a OF THE LETTER WITH JORICK: montage of observed multiple P-cygni absoprtion compoenents in LBVs 
;plotting to PS file
aa=700
bb=700
ps_ysize=10.
ps_xsize=ps_ysize*aa/bb
ps_filename='/Users/jgroh/temp/timedep_armagh_fig1a.eps'
set_plot,'ps'
device,filename=ps_filename,/encapsulated,/color,bit=8,xsize=ps_xsize,ysize=ps_ysize,/inches
!P.THICK=12
!X.THICK=12
!Y.THICK=12
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=2
!P.CHARTHICK=12
ticklen = 25.
!x.ticklen = ticklen/bb
!y.ticklen = ticklen/aa
LOADCT,0,/SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

c1=fsc_color('black')
c2=fsc_color('red')
plot, ZE_LAMBDA_TO_VEL(l97,6562.8), f97, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(I5)',XTICKFORMAT='(I4)',xtickinterval=100,ytickinterval=10.0, $
yrange=[0.0,60.77],$ ;used in the letter
xrange=[-215,200],xstyle=1,ystyle=1, xtitle='Velocity (km/s)', $
ytitle='Normalized flux', /NODATA, Position=[0.12, 0.10, 0.92, 0.96], title=title
plots,ZE_LAMBDA_TO_VEL(l97,6562.8), f97,color=fsc_color('black'),noclip=0,linestyle=0
plots,ZE_LAMBDA_TO_VEL(l97,6562.8), f97*6,color=fsc_color('black'),noclip=0,linestyle=2
xyouts,-170,21,'x 6'
xyouts,-190,53,TEXTOIDL('H\alpha '),charsize=3.3
xyouts,-190,48,TEXTOIDL('AG Car'),charsize=2.6
xyouts,-190,43,TEXTOIDL('1997 Feb 28'),charsize=2.6
device,/close_file

ps_filename='/Users/jgroh/temp/timedep_armagh_fig1b.eps'
device,filename=ps_filename,/encapsulated,/color,bit=8,xsize=ps_xsize,ysize=ps_ysize,/inches
!P.THICK=12
!X.THICK=12
!Y.THICK=12
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=2
!P.CHARTHICK=12
ticklen = 25.
!x.ticklen = ticklen/bb
!y.ticklen = ticklen/aa
LOADCT,0,/SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

c1=fsc_color('black')
c2=fsc_color('red')
plot, ZE_LAMBDA_TO_VEL(l92,6562.8), f92, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(I5)',XTICKFORMAT='(I4)',xtickinterval=200,ytickinterval=5.0, $
yrange=[0.0,22.77],$ ;used in the letter
xrange=[-215,200],xstyle=1,ystyle=1, xtitle='Velocity (km/s)', $
ytitle='Normalized flux', /NODATA, Position=[0.12, 0.10, 0.92, 0.96], title=title
plots,ZE_LAMBDA_TO_VEL(l92,6562.8), f92,color=fsc_color('black'),noclip=0,linestyle=0
plots,ZE_LAMBDA_TO_VEL(l92,6562.8), f92*6,color=fsc_color('black'),noclip=0,linestyle=2
xyouts,-170,12,'x 6'
device,/close_file

;FIGURE 2 OF THE LETTER WITH JORICK: left: comparison of velocity law from models with abrupt x gradual changes in vinf(t); right: comparison of Halpha line profiles from models with abrupt x gradual changes in vinf(t).  
;plotting to PS file
aa=1400
bb=700
ps_ysize=10.
ps_xsize=ps_ysize*aa/bb
ps_filename='/Users/jgroh/temp/timedep_armagh_fig2.eps'
set_plot,'ps'
device,filename=ps_filename,/encapsulated,/color,bit=8,xsize=ps_xsize,ysize=ps_ysize,/inches
!p.multi=[0, 2, 1, 0, 0]
!P.THICK=12
!X.THICK=12
!Y.THICK=12
!X.CHARSIZE=1.8
!Y.CHARSIZE=1.8
!P.CHARSIZE=2
!P.CHARTHICK=12
!X.OMARGIN=[-1,3]
ticklen = 35.
!x.ticklen = ticklen/bb/2.
!y.ticklen = ticklen/aa
LOADCT,0,/SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

c1=fsc_color('black')
c2=fsc_color('red')
plot, r16_to_rstar,v16,YTICKFORMAT='(I5)',XTICKFORMAT='(F5.1)', $
yrange=[0,177],$ ;used in the letter
xrange=[0,1.8],xstyle=1,ystyle=1, xtitle='log (r/Rstar)', $
ytitle='Velocity (km/s)', /NODATA,YMARGIN=[1.5,0.],XMARGIN=[13,0]
plots,r415_to_rstar,v415,color=fsc_color('blue'),noclip=0,linestyle=3
plots,r16_to_rstar,v16,color=c1,noclip=0,linestyle=0
plots,r6_to_rstar,v6,color=c2,noclip=0,linestyle=2
;xyouts,0.7,20,TEXTOIDL('\Deltat=120 days'),/DATA,charthick=10.0,charsize=3.5
xyouts,0.2,160,TEXTOIDL('(a) \Deltat=120 days'),/DATA,charthick=10.0,charsize=3.5

linit=0.4
lfin=0.65
plots,[linit,lfin],[10,10],color=fsc_color('blue'),noclip=0,linestyle=3
xyouts,lfin+0.05,8,TEXTOIDL('stationary'),color=fsc_color('blue'),/DATA,charthick=10.0,charsize=3.0
plots,[linit,lfin],[20,20],color=fsc_color('black'),noclip=0,linestyle=0
xyouts,lfin+0.05,18,TEXTOIDL('time-dep gradual'),color=fsc_color('black'),/DATA,charthick=10.0,charsize=3.0
plots,[linit,lfin],[30,30],color=fsc_color('red'),noclip=0,linestyle=2
xyouts,lfin+0.05,28,TEXTOIDL('time-dep abrupt'),color=fsc_color('red'),/DATA,charthick=10.0,charsize=3.0


c1=fsc_color('black')
c2=fsc_color('red')
plot, ZE_LAMBDA_TO_VEL(l16,6562.8), f16n,YTICKFORMAT='(F5.1)',XTICKFORMAT='(I4)',ytickinterval=0.4, $
yrange=[0.1,1.77],$ ;used in the letter
xrange=[-200,200],xstyle=1,ystyle=1, xtitle='Velocity (km/s)', $
ytitle='Normalized flux', /NODATA,YMARGIN=[1.5,0.],XMARGIN=[13,0]
plots,ZE_LAMBDA_TO_VEL(l442,6562.8), f442n,color=fsc_color('blue'),noclip=0,linestyle=3
plots,ZE_LAMBDA_TO_VEL(l16,6562.8), f16n,color=c1,noclip=0,linestyle=0
plots,ZE_LAMBDA_TO_VEL(l14v10,6562.8), f14v10n,color=c2,noclip=0,linestyle=2
xyouts,-160,1.60,TEXTOIDL('(b)'),/DATA,charthick=10.0,charsize=3.5

linit=-80.
lfin=-35.
plots,[linit,lfin],[0.18,0.18],color=fsc_color('blue'),noclip=0,linestyle=3
xyouts,lfin+8.,0.16,TEXTOIDL('stationary'),color=fsc_color('blue'),/DATA,charthick=10.0,charsize=3.0
plots,[linit,lfin],[0.28,0.28],color=fsc_color('black'),noclip=0,linestyle=0
xyouts,lfin+8,0.26,TEXTOIDL('time-dep gradual'),color=fsc_color('black'),/DATA,charthick=10.0,charsize=3.0
plots,[linit,lfin],[0.38,0.38],color=fsc_color('red'),noclip=0,linestyle=2
xyouts,lfin+8,0.36,TEXTOIDL('time-dep abrupt'),color=fsc_color('red'),/DATA,charthick=10.0,charsize=3.0

device,/close_file

!X.OMARGIN=0
;FIGURE 2a OF THE LETTER WITH JORICK: comparison of velocity law from models with abrupt x gradual changes in vinf(t).  
;plotting to PS file
aa=700
bb=700
ps_ysize=10.
ps_xsize=ps_ysize*aa/bb
ps_filename='/Users/jgroh/temp/timedep_armagh_fig2a.eps'
set_plot,'ps'
device,filename=ps_filename,/encapsulated,/color,bit=8,xsize=ps_xsize,ysize=ps_ysize,/inches
!P.THICK=12
!X.THICK=12
!Y.THICK=12
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=2
!P.CHARTHICK=12
ticklen = 25.
!x.ticklen = ticklen/bb
!y.ticklen = ticklen/aa
LOADCT,0,/SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

c1=fsc_color('black')
c2=fsc_color('red')
plot, r16_to_rstar,v16, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(I5)',XTICKFORMAT='(F5.1)', $
yrange=[0,177],$ ;used in the letter
xrange=[0,2],xstyle=1,ystyle=1, xtitle='log (r/Rstar)', $
ytitle='Velocity (km/s)', /NODATA, Position=[0.12, 0.10, 0.92, 0.96], title=title
plots,r415_to_rstar,v415,color=fsc_color('blue'),noclip=0,linestyle=3
plots,r16_to_rstar,v16,color=c1,noclip=0,linestyle=0
plots,r6_to_rstar,v6,color=c2,noclip=0,linestyle=2
xyouts,0.7,20,TEXTOIDL('\Deltat=120 days'),/DATA,charthick=10.0,charsize=3.5

device,/close_file

;FIGURE 2b OF THE LETTER WITH JORICK: comparison of Halpha line profiles from models with abrupt x gradual changes in vinf(t).  
;plotting to PS file
aa=700
bb=700
ps_ysize=10.
ps_xsize=ps_ysize*aa/bb
ps_filename='/Users/jgroh/temp/timedep_armagh_fig2b.eps'
set_plot,'ps'
device,filename=ps_filename,/encapsulated,/color,bit=8,xsize=ps_xsize,ysize=ps_ysize,/inches
!P.THICK=12
!X.THICK=12
!Y.THICK=12
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=2
!P.CHARTHICK=12
ticklen = 25.
!x.ticklen = ticklen/bb
!y.ticklen = ticklen/aa
LOADCT,0,/SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

c1=fsc_color('black')
c2=fsc_color('red')
plot, ZE_LAMBDA_TO_VEL(l16,6562.8), f16n, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(F5.1)',XTICKFORMAT='(I4)',ytickinterval=0.4, $
yrange=[0.2,1.77],$ ;used in the letter
xrange=[-200,200],xstyle=1,ystyle=1, xtitle='Velocity (km/s)', $
ytitle='Normalized flux', /NODATA, Position=[0.12, 0.10, 0.92, 0.96], title=title
plots,ZE_LAMBDA_TO_VEL(l442,6562.8), f442n,color=fsc_color('blue'),noclip=0,linestyle=0
plots,ZE_LAMBDA_TO_VEL(l16,6562.8), f16n,color=c1,noclip=0,linestyle=0
plots,ZE_LAMBDA_TO_VEL(l14v10,6562.8), f14v10n,color=c2,noclip=0,linestyle=2


device,/close_file

;FIGURE 3 OF THE LETTER WITH JORICK: exploring the parameter space of model Halpha line profiles for different Mdot, Teff 
;plotting to PS file
aa=700
bb=700
ps_ysize=10.
ps_xsize=ps_ysize*aa/bb
ps_filename='/Users/jgroh/temp/timedep_armagh_fig3.eps'
set_plot,'ps'
device,filename=ps_filename,/encapsulated,/color,bit=8,xsize=ps_xsize,ysize=ps_ysize,/inches
!P.THICK=9
!X.THICK=9
!Y.THICK=9
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=2
!P.CHARTHICK=6
!X.MARGIN=[0,0]
!X.OMARGIN=[10,1]
!Y.MARGIN=[0,0]
!Y.OMARGIN=[5,1]
ticklen = 25.
!x.ticklen = ticklen/bb
!y.ticklen = ticklen/aa
LOADCT,0,/SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

!P.MULTI=[0,3,4]
c1=fsc_color('black')
c2=fsc_color('red')

;*************
; Teff=13 kK
;*************
plot, ZE_LAMBDA_TO_VEL(l16,6562.8), f16n, charsize=2.7,ycharsize=1.2,xcharsize=1.4,YTICKFORMAT='(F5.1)',XTICKFORMAT='(A2)',xtickinterval=200,ytickinterval=0.5, $
yrange=[0.0,1.77],$ ;used in the letter
xrange=[-220,199],xstyle=1,ystyle=1, $
ytitle='Normalized flux', /NODATA;, Position=[0.20, 0.24, 0.92, 0.96], title=title
;plots,ZE_LAMBDA_TO_VEL(l2,6562.8), f2n,color=c1,noclip=0,linestyle=0
plots,ZE_LAMBDA_TO_VEL(l40v10,6562.8), f40v10n,color=c1,noclip=0,linestyle=0
xyouts,-50,0.5,TEXTOIDL('T_{eff}=13kK'),/DATA;,charthick=10.0,charsize=3.5
xyouts,-50,0.2,TEXTOIDL('Mdot_5=1.17'),/DATA;,charthick=10.0,charsize=3.5

plot, ZE_LAMBDA_TO_VEL(l2,6562.8), f2n, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(A2)',XTICKFORMAT='(A2)',xtickinterval=200,ytickinterval=0.5, $
yrange=[0.0,1.77],$ ;used in the letter
xrange=[-200,199],xstyle=1,ystyle=1, /NODATA;, Position=[0.20, 0.24, 0.92, 0.96], title=title
plots,ZE_LAMBDA_TO_VEL(l6v10,6562.8), f6v10n,color=c2,noclip=0,linestyle=0
xyouts,-50,0.5,TEXTOIDL('T_{eff}=13kK'),/DATA;,charthick=10.0,charsize=3.5
xyouts,-50,0.2,TEXTOIDL('Mdot_5=0.9'),/DATA;,charthick=10.0,charsize=3.5

plot, ZE_LAMBDA_TO_VEL(l5,6562.8), f5n, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(A2)',XTICKFORMAT='(A2)',xtickinterval=200,ytickinterval=0.5, $
yrange=[0.0,1.77],$ ;used in the letter
xrange=[-200,199],xstyle=1,ystyle=1, /NODATA;, Position=[0.20, 0.24, 0.92, 0.96], title=title
;plots,ZE_LAMBDA_TO_VEL(l5,6562.8), f5n,color=fsc_color('blue'),noclip=0,linestyle=0
plots,ZE_LAMBDA_TO_VEL(l5v10,6562.8), f5v10n,color=fsc_color('blue'),noclip=0,linestyle=0
xyouts,-50,0.5,TEXTOIDL('T_{eff}=13kK'),/DATA;,charthick=10.0,charsize=3.5
xyouts,-50,0.2,TEXTOIDL('Mdot_5=0.54'),/DATA;,charthick=10.0,charsize=3.5

;*************
; Teff=15.5 kK
;*************
plot, ZE_LAMBDA_TO_VEL(l16,6562.8), f16n, charsize=2.7,ycharsize=1.2,xcharsize=1.4,YTICKFORMAT='(F5.1)',XTICKFORMAT='(A2)',xtickinterval=200,ytickinterval=0.5, $
yrange=[0.0,1.77],$ ;used in the letter
xrange=[-220,199],xstyle=1,ystyle=1, $
ytitle='Normalized flux', /NODATA;, Position=[0.20, 0.24, 0.92, 0.96], title=title
plots,ZE_LAMBDA_TO_VEL(l15v10,6562.8), f15v10n,color=c1,noclip=0,linestyle=0
xyouts,-50,0.5,TEXTOIDL('T_{eff}=15.5kK'),/DATA;,charthick=10.0,charsize=3.5
xyouts,-50,0.2,TEXTOIDL('Mdot_5=1.17'),/DATA;,charthick=10.0,charsize=3.5

plot, ZE_LAMBDA_TO_VEL(l2,6562.8), f2n, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(A2)',XTICKFORMAT='(A2)',xtickinterval=200,ytickinterval=0.5, $
yrange=[0.0,1.77],$ ;used in the letter
xrange=[-200,199],xstyle=1,ystyle=1, /NODATA;, Position=[0.20, 0.24, 0.92, 0.96], title=title
plots,ZE_LAMBDA_TO_VEL(l14v10,6562.8), f14v10n,color=c2,noclip=0,linestyle=0
xyouts,-50,0.5,TEXTOIDL('T_{eff}=15.5kK'),/DATA;,charthick=10.0,charsize=3.5
xyouts,-50,0.2,TEXTOIDL('Mdot_5=0.9'),/DATA;,charthick=10.0,charsize=3.5

plot, ZE_LAMBDA_TO_VEL(l5,6562.8), f5n, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(A2)',XTICKFORMAT='(A2)',xtickinterval=200,ytickinterval=0.5, $
yrange=[0.0,1.77],$ ;used in the letter
xrange=[-200,199],xstyle=1,ystyle=1, /NODATA;, Position=[0.20, 0.24, 0.92, 0.96], title=title
plots,ZE_LAMBDA_TO_VEL(l12v10,6562.8), f12v10n,color=fsc_color('blue'),noclip=0,linestyle=0
xyouts,-50,0.5,TEXTOIDL('T_{eff}=15.5kK'),/DATA;,charthick=10.0,charsize=3.5
xyouts,-50,0.2,TEXTOIDL('Mdot_5=0.54'),/DATA;,charthick=10.0,charsize=3.5


;*************
; Teff=16.4 kK
;*************
plot, ZE_LAMBDA_TO_VEL(l16,6562.8), f16n, charsize=2.7,ycharsize=1.2,xcharsize=1.4,YTICKFORMAT='(F5.1)',XTICKFORMAT='(A2)',xtickinterval=200,ytickinterval=0.5, $
yrange=[0.0,1.77],$ ;used in the letter
xrange=[-220,199],xstyle=1,ystyle=1, $
ytitle='Normalized flux', /NODATA;, Position=[0.20, 0.24, 0.92, 0.96], title=title
plots,ZE_LAMBDA_TO_VEL(l25v10,6562.8), f25v10n,color=c1,noclip=0,linestyle=0
xyouts,-50,0.5,TEXTOIDL('T_{eff}=16.4kK'),/DATA;,charthick=10.0,charsize=3.5
xyouts,-50,0.2,TEXTOIDL('Mdot_5=1.17'),/DATA;,charthick=10.0,charsize=3.5

plot, ZE_LAMBDA_TO_VEL(l2,6562.8), f2n, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(A2)',XTICKFORMAT='(A2)',xtickinterval=200,ytickinterval=0.5, $
yrange=[0.0,1.77],$ ;used in the letter
xrange=[-200,199],xstyle=1,ystyle=1, /NODATA;, Position=[0.20, 0.24, 0.92, 0.96], title=title
plots,ZE_LAMBDA_TO_VEL(l22v10,6562.8), f22v10n,color=c2,noclip=0,linestyle=0
xyouts,-50,0.5,TEXTOIDL('T_{eff}=16.4kK'),/DATA;,charthick=10.0,charsize=3.5
xyouts,-50,0.2,TEXTOIDL('Mdot_5=0.9'),/DATA;,charthick=10.0,charsize=3.5

plot, ZE_LAMBDA_TO_VEL(l5,6562.8), f5n, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(A2)',XTICKFORMAT='(A2)',xtickinterval=200,ytickinterval=0.5, $
yrange=[0.0,1.77],$ ;used in the letter
xrange=[-200,199],xstyle=1,ystyle=1, /NODATA;, Position=[0.20, 0.24, 0.92, 0.96], title=title
plots,ZE_LAMBDA_TO_VEL(l24v10,6562.8), f24v10n,color=fsc_color('blue'),noclip=0,linestyle=0
xyouts,-50,0.5,TEXTOIDL('T_{eff}=16.4kK'),/DATA;,charthick=10.0,charsize=3.5
xyouts,-50,0.2,TEXTOIDL('Mdot_5=0.63'),/DATA;,charthick=10.0,charsize=3.5

;*************
; Teff=18.4 kK
;*************
plot, ZE_LAMBDA_TO_VEL(l16,6562.8), f16n, charsize=2.7,ycharsize=1.2,xcharsize=1.4,YTICKFORMAT='(F5.1)',XTICKFORMAT='(I4)',xtickinterval=100,ytickinterval=0.5, $
yrange=[0.0,1.77],$ ;used in the letter
xrange=[-200,199],xstyle=1,ystyle=1, $
ytitle='Normalized flux',  xtitle='Velocity (km/s)', /NODATA;, Position=[0.20, 0.24, 0.92, 0.96], title=title
plots,ZE_LAMBDA_TO_VEL(l34,6562.8), f34n,color=c1,noclip=0,linestyle=0
xyouts,-50,0.5,TEXTOIDL('T_{eff}=18.4kK'),/DATA;,charthick=10.0,charsize=3.5
xyouts,-50,0.2,TEXTOIDL('Mdot_5=1.2'),/DATA;,charthick=10.0,charsize=3.5

plot, ZE_LAMBDA_TO_VEL(l2,6562.8), f2n, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(A2)',XTICKFORMAT='(I4)',xtickinterval=100,ytickinterval=0.5, $
yrange=[0.0,1.77],$ ;used in the letter
xrange=[-200,199],xstyle=1,ystyle=1, xtitle='Velocity (km/s)',  /NODATA;, Position=[0.20, 0.24, 0.92, 0.96], title=title
plots,ZE_LAMBDA_TO_VEL(l35,6562.8), f35n,color=c2,noclip=0,linestyle=0
xyouts,-50,0.5,TEXTOIDL('T_{eff}=18.4kK'),/DATA;,charthick=10.0,charsize=3.5
xyouts,-50,0.2,TEXTOIDL('Mdot_5=0.9'),/DATA;,charthick=10.0,charsize=3.5

;PLACEHOLDER ; REMEMBER TO RUN A MODEL WITH MDOT5=5
plot, ZE_LAMBDA_TO_VEL(l2,6562.8), f2n, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(A2)',XTICKFORMAT='(I4)',xtickinterval=100,ytickinterval=0.5, $
yrange=[0.0,1.77],$ ;used in the letter
xrange=[-200,199],xstyle=1,ystyle=1, xtitle='Velocity (km/s)',  /NODATA;, Position=[0.20, 0.24, 0.92, 0.96], title=title
plots,ZE_LAMBDA_TO_VEL(l35,6562.8), f35n,color=c2,noclip=0,linestyle=0
xyouts,-50,0.5,TEXTOIDL('T_{eff}=18.4kK'),/DATA;,charthick=10.0,charsize=3.5
xyouts,-50,0.2,TEXTOIDL('Mdot_5=0.5'),/DATA;,charthick=10.0,charsize=3.5

;plot, ZE_LAMBDA_TO_VEL(l5,6562.8), f5n, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(A2)',XTICKFORMAT='(I4)',xtickinterval=200,ytickinterval=0.5, $
;yrange=[0.0,1.77],$ ;used in the letter
;xrange=[-200,200],xstyle=1,ystyle=1, /NODATA, xtitle='Velocity (km/s)';, Position=[0.20, 0.24, 0.92, 0.96], title=title
;plots,ZE_LAMBDA_TO_VEL(l36,6562.8), f36n,color=fsc_color('blue'),noclip=0,linestyle=0
;xyouts,-50,0.5,TEXTOIDL('T_{eff}=18.4kK'),/DATA;,charthick=10.0,charsize=3.5
;xyouts,-50,0.2,TEXTOIDL('Mdot_5=1.6'),/DATA;,charthick=10.0,charsize=3.5


device,/close_file

;FIGURE 3b OF THE LETTER WITH JORICK: exploring the parameter space of model Halpha line profiles for different Delta t
;plotting to PS file
aa=700
bb=700
ps_ysize=10.
ps_xsize=ps_ysize*aa/bb
ps_filename='/Users/jgroh/temp/timedep_armagh_fig3b.eps'
set_plot,'ps'
device,filename=ps_filename,/encapsulated,/color,bit=8,xsize=ps_xsize,ysize=ps_ysize,/inches
!P.THICK=9
!X.THICK=9
!Y.THICK=9
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=2
!P.CHARTHICK=6
!X.MARGIN=[0,0]
!X.OMARGIN=[10,1]
!Y.MARGIN=[0,0]
!Y.OMARGIN=[5,1]
ticklen = 25.
!x.ticklen = ticklen/bb
!y.ticklen = ticklen/aa
LOADCT,0,/SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

!P.MULTI=[0,3,2]
c1=fsc_color('black')
c2=fsc_color('red')

;*************
; Teff=15.5 kK
;*************
plot, ZE_LAMBDA_TO_VEL(l16,6562.8), f16n, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(F5.1)',XTICKFORMAT='(A2)',xtickinterval=100,ytickinterval=0.5, $
yrange=[0.0,1.77],$ ;used in the letter
xrange=[-200,199],xstyle=1,ystyle=1, $
ytitle='Normalized flux', /NODATA;, Position=[0.20, 0.24, 0.92, 0.96], title=title
;plots,ZE_LAMBDA_TO_VEL(l2,6562.8), f2n,color=c1,noclip=0,linestyle=0
plots,ZE_LAMBDA_TO_VEL(l442,6562.8), f442n,color=c1,noclip=0,linestyle=0
xyouts,-50,0.5,TEXTOIDL('T_{eff}=15.5kK'),/DATA;,charthick=10.0,charsize=3.5
xyouts,-50,0.2,TEXTOIDL('\Deltat=10d'),/DATA;,charthick=10.0,charsize=3.5
xyouts,-160,1.60,TEXTOIDL('(a)'),/DATA

plot, ZE_LAMBDA_TO_VEL(l2,6562.8), f2n, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(A2)',XTICKFORMAT='(A2)',xtickinterval=100,ytickinterval=0.5, $
yrange=[0.0,1.77],$ ;used in the letter
xrange=[-200,199],xstyle=1,ystyle=1, /NODATA;, Position=[0.20, 0.24, 0.92, 0.96], title=title
plots,ZE_LAMBDA_TO_VEL(l42v10,6562.8), f42v10n,color=c1,noclip=0,linestyle=0
xyouts,-50,0.5,TEXTOIDL('T_{eff}=15.5kK'),/DATA;,charthick=10.0,charsize=3.5
xyouts,-50,0.2,TEXTOIDL('\Deltat=60d'),/DATA;,charthick=10.0,charsize=3.5
xyouts,-160,1.60,TEXTOIDL('(b)'),/DATA

plot, ZE_LAMBDA_TO_VEL(l2,6562.8), f2n, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(A2)',XTICKFORMAT='(A2)',xtickinterval=100,ytickinterval=0.5, $
yrange=[0.0,1.77],$ ;used in the letter
xrange=[-200,199],xstyle=1,ystyle=1, /NODATA;, Position=[0.20, 0.24, 0.92, 0.96], title=title
plots,ZE_LAMBDA_TO_VEL(l14v10,6562.8), f14v10n,color=c1,noclip=0,linestyle=0
xyouts,-50,0.5,TEXTOIDL('T_{eff}=15.5kK'),/DATA;,charthick=10.0,charsize=3.5
xyouts,-50,0.2,TEXTOIDL('\Deltat=120d'),/DATA;,charthick=10.0,charsize=3.5
xyouts,-160,1.60,TEXTOIDL('(c)'),/DATA

plot, ZE_LAMBDA_TO_VEL(l5,6562.8), f5n, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(F5.1)',XTICKFORMAT='(I4)',xtickinterval=100,ytickinterval=0.5, $
yrange=[0.0,1.77],$ ;used in the letter
xrange=[-200,199],xstyle=1,ystyle=1, /NODATA, ytitle='Normalized flux', xtitle='Velocity (km/s)';, Position=[0.20, 0.24, 0.92, 0.96], title=title
;plots,ZE_LAMBDA_TO_VEL(l5,6562.8), f5n,color=fsc_color('blue'),noclip=0,linestyle=0
plots,ZE_LAMBDA_TO_VEL(l43v10,6562.8), f43v10n,color=c1,noclip=0,linestyle=0
xyouts,-50,0.5,TEXTOIDL('T_{eff}=15.5kK'),/DATA;,charthick=10.0,charsize=3.5
xyouts,-50,0.2,TEXTOIDL('\Deltat=240d'),/DATA;,charthick=10.0,charsize=3.5
xyouts,-160,1.60,TEXTOIDL('(d)'),/DATA

plot, ZE_LAMBDA_TO_VEL(l5,6562.8), f5n, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(A2)',XTICKFORMAT='(I4)',xtickinterval=100,ytickinterval=0.5, $
yrange=[0.0,1.77],$ ;used in the letter
xrange=[-200,199],xstyle=1,ystyle=1, /NODATA, xtitle='Velocity (km/s)';, Position=[0.20, 0.24, 0.92, 0.96], title=title
;plots,ZE_LAMBDA_TO_VEL(l5,6562.8), f5n,color=fsc_color('blue'),noclip=0,linestyle=0
plots,ZE_LAMBDA_TO_VEL(l44v10,6562.8), f44v10n,color=c1,noclip=0,linestyle=0
xyouts,-50,0.5,TEXTOIDL('T_{eff}=15.5kK'),/DATA;,charthick=10.0,charsize=3.5
xyouts,-50,0.2,TEXTOIDL('\Deltat=480d'),/DATA;,charthick=10.0,charsize=3.5
xyouts,-160,1.60,TEXTOIDL('(e)'),/DATA

plot, ZE_LAMBDA_TO_VEL(l5,6562.8), f5n, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(A2)',XTICKFORMAT='(I4)',xtickinterval=100,ytickinterval=0.5, $
yrange=[0.0,1.77],$ ;used in the letter
xrange=[-200,199],xstyle=1,ystyle=1, /NODATA, xtitle='Velocity (km/s)';, Position=[0.20, 0.24, 0.92, 0.96], title=title
;plots,ZE_LAMBDA_TO_VEL(l5,6562.8), f5n,color=fsc_color('blue'),noclip=0,linestyle=0
plots,ZE_LAMBDA_TO_VEL(l45v10,6562.8), f45v10n,color=c1,noclip=0,linestyle=0
plots,ZE_LAMBDA_TO_VEL(l20v10,6562.8), f20v10n,color=c2,noclip=0,linestyle=2
xyouts,-50,0.5,TEXTOIDL('T_{eff}=15.5kK'),/DATA;,charthick=10.0,charsize=3.5
xyouts,-50,0.2,TEXTOIDL('\Deltat=960d'),/DATA;,charthick=10.0,charsize=3.5
xyouts,-160,1.60,TEXTOIDL('(f)'),/DATA

device,/close_file

;FIGURE 4 OF THE LETTER WITH JORICK:X,Y plot of  Teff x Mdot (scaled by L, vinf) showing when double P Cygni abs occur.  
;plotting to PS file
aa=700
bb=700
ps_ysize=10.
ps_xsize=ps_ysize*aa/bb
ps_filename='/Users/jgroh/temp/timedep_armagh_fig4.eps'
set_plot,'ps'
device,filename=ps_filename,/encapsulated,/color,bit=8,xsize=ps_xsize,ysize=ps_ysize,/inches
!P.THICK=12
!X.THICK=12
!Y.THICK=12
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=2
!P.CHARTHICK=12
ticklen = 25.
!x.ticklen = ticklen/bb
!y.ticklen = ticklen/aa
LOADCT,0,/SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

s1=4
s2=6
s3=2
ssize=2.5
c1=fsc_color('black')
c2=fsc_color('red')
c3=fsc_color('blue')

fillcolordouble=fsc_color('yellow')
fillcoloronlylow=fsc_color('red')
fillcoloronlyhigh=fsc_color('blue')
fillcolorno=fsc_color('grey')

ymin=0.2
ymax=2.0
yminplotvals=[ymin,ymin,ymin,ymin]
ymaxplotvals=[ymax,ymax,ymax,ymax]

xfilldouble=[12,15.5,16.4,18]
yfilldouble=[0.9,0.9,0.9,0.9]

factormin=0.7
factormax=1.3

xfillonlylow=[12,15.5,16.4,18]
yfillonlylow=yfilldouble*factormin
yminabsvals=[0.3,0.3,0.3,0.3] ;PRELIMINARY PLACEHOLDER, WILL HAVE TO COMPUTE MODELS

xfillonlyhigh=[12,15.5,16.4,18]
yfillonlyhigh=yfilldouble*factormax

xfillno1=[18,22]
yfillno1=[ymin,ymax]

xfillno2=[12,15.5,16.4,18]
yfillno2=yminabsvals

plot,[12,22],[ymin,ymax], charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(F5.1)',XTICKFORMAT='(I5)', $
yrange=[ymin,ymax],$ ;used in the letter
xrange=[12,22],xstyle=1,ystyle=1, xtitle='Teff (kK)', $
ytitle=TEXTOIDL('Mdot (10^{-5} Msun/yr)'), /NODATA, Position=[0.12, 0.10, 0.92, 0.96], title=title
;plots,13,1.17,psym=s1,symsize=ssize,color=fsc_color('black')
ze_colorfill_v2,low=12,high=18,ymin=yfilldouble*factormin, ymax=yfilldouble*factormax, x=xfilldouble,yvals=yfilldouble,fillColor=fillcolordouble
xyouts,12.5,0.9,'double P-Cygni abs',charsize=2.0

ze_colorfill_v2,low=12,high=18,ymin=yminabsvals, ymax=yfilldouble*factormin, x=xfillonlylow,yvals=yfillonlylow,fillColor=fillcoloronlylow
xyouts,12.5,0.4,'only slow wind P-Cygni abs',charsize=2.0

ze_colorfill_v2,low=12,high=18,ymin=yfilldouble*factormax, ymax=ymaxplotvals, x=xfillonlyhigh,yvals=yfillonlyhigh,fillColor=fillcoloronlyhigh
xyouts,12.5,1.5,'only fast wind P-Cygni abs',charsize=2.0

ze_colorfill_v2,low=18,high=22,ymin=[ymin,ymin], ymax=[ymax,ymax], x=xfillno1,yvals=yfillno1,fillColor=fillcolorno
ze_colorfill_v2,low=12,high=18,ymin=yminplotvals, ymax=yminabsvals, x=xfillno2,yvals=yfillno2,fillColor=fillcolorno
xyouts,18.5,0.9,'no P-Cygni abs',charsize=2.0,orientation=45

plot,[12,22],[0.2,2.0], charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(F5.1)',XTICKFORMAT='(I5)', $
yrange=[0.2,2.0],$ ;used in the letter
xrange=[12,22],xstyle=1,ystyle=1, xtitle='Teff (kK)', $
ytitle=TEXTOIDL('Mdot (10^{-5} Msun/yr)'), /NODATA, Position=[0.12, 0.10, 0.92, 0.96], title=title,/NOERASE

device,/close_file
;FIGURE 7b OF THE LETTER WITH JORICK: comparison of Halpha line profiles from old models (no rarefied region) versus new models (with rarefied region).  
;plotting to PS file
aa=700
bb=700
ps_ysize=10.
ps_xsize=ps_ysize*aa/bb
ps_filename='/Users/jgroh/temp/timedep_armagh_fig7b.eps'
set_plot,'ps'
device,filename=ps_filename,/encapsulated,/color,bit=8,xsize=ps_xsize,ysize=ps_ysize,/inches
!P.THICK=12
!X.THICK=12
!Y.THICK=12
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=2
!P.CHARTHICK=12
ticklen = 25.
!x.ticklen = ticklen/bb
!y.ticklen = ticklen/aa
LOADCT,0,/SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

c1=fsc_color('black')
c2=fsc_color('red')
plot, ZE_LAMBDA_TO_VEL(l16,6562.8), f16n, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(F5.1)',XTICKFORMAT='(I4)',ytickinterval=0.4, $
yrange=[0.2,1.77],$ ;used in the letter
xrange=[-200,200],xstyle=1,ystyle=1, xtitle='Velocity (km/s)', $
ytitle='Normalized flux', /NODATA, Position=[0.20, 0.24, 0.92, 0.96], title=title
plots,ZE_LAMBDA_TO_VEL(l14,6562.8), f14n,color=fsc_color('blue'),noclip=0,linestyle=0
plots,ZE_LAMBDA_TO_VEL(l14cnewv10,6562.8),f14cnewv10n,color=c1,noclip=0,linestyle=0
plots,ZE_LAMBDA_TO_VEL(l15cnewv10,6562.8),f15cnewv10n,color=c2,noclip=0,linestyle=2

device,/close_file



set_plot,'x'
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
!X.THICK=0
!Y.THICK=0
!P.THICK=0
!X.CHARSIZE=0
!Y.CHARSIZE=0
!P.CHARSIZE=0
!P.CHARTHICK=0

;lineplot,l14v10,f14v10n

END
;PRO ZE_CMFGEN_COMPARE_SPECTRA_DIAGNOSTICS_WITH_ANDREA_MEHNER


dirhrcmod='/Users/jgroh/ze_models/hrcar/'

ZE_CMFGEN_CREATE_OBSNORM,dirhrcmod+'3'+'/obsopt/obs_fin',dirhrcmod+'3'+'/obscont/obs_fin',l3,f3,/AIR,lmin=3150,lmax=9000 ;Teff=17630, Mdot=1.0e-05, vinf=100
ZE_CMFGEN_CREATE_OBSNORM,dirhrcmod+'4'+'/obs2d/obs_fin',dirhrcmod+'4'+'/obscont/obs_fin',l4,f4,/AIR,lmin=1150,lmax=9000 ;Teff=17630, Mdot=1.4e-05, vinf=100
;ZE_CMFGEN_CREATE_OBSNORM,dirhrcmod+'5'+'/obs2d/obs_fin',dirhrcmod+'5'+'/obscont/obs_fin',l5,f5,/AIR,lmin=1150,lmax=9000 ;Teff=17630, Mdot=1.2e-05, vinf=120


ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,l3,f3,'Wavelength (Angstrom)', 'Scaled Flux','',$
                          x2=l4,y2=f4,linestyle2=0,$
;                          x3=l4,y3=f4,linestyle3=0,$
;                          x4=all_lambda[12,0:all_nlambda_read[12]-1],y4=6.0+((all_fluxnorm[12,0:all_nlambda_read[12]-1] - 1.0)/12.0 + 1.0),linestyle4=0,$
;                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
;                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
;                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
;                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
;                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
;                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
                          pthick=7,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=800,bb=500,$
                          xrange=[4400,4500],yrange=[0,5],POSITION=[0.10,0.10,0.98,0.98],filename='hrcar_mdot';,/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.05,id_ypos=10.5,size_id_text=1.0,elem=elem





END

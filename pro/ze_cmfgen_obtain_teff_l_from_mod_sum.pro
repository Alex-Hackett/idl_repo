;PRO ZE_CMFGEN_OBTAIN_TEFF_L_FROM_MOD_SUM,modsum_file,lstar,tstar,teff,rstar,rphot,v_tau_23,mdot,vinf1,beta1,maxcorr,mu
modsum_file='/Users/jgroh/ze_models/grid_P060z14S0/model5500_T30783_L941860_logg2d78/MOD_SUM'

ZE_CMFGEN_READ_MOD_SUM,modsum_file,modsum

ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'L*=',lstar
ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'Mdot=',Mdot
ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'R*/Rsun=',rstar
ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'RMAX/R*',rmax_on_rstar
ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'T*=',tstar
ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'Vinf1=',vinf1
ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'Beta1=',beta1
ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'Maximum correcion (%) on last iteration:',maxcorr
ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'Mean atomic mass (amu) is:',mu

;starting here, quantitites that likely will be found more than once in MOD_SUM, and will be arrays. 
ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'Teff=',teff_array
ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'Log g=',logg_array
ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'R /Rsun=',r_array
ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'V(km/s)=',v_array

;sorting into doubles, taking into account that some models don't go as deep as Tau=100, or Tau=20
IF n_elements(logg_array) EQ 4 THEN BEGIN ;goes ~ Tau=100 
  logg_phot=logg_array[n_elements(logg_array)-1]
  logg_tau10=logg_array[n_elements(logg_array)-2]
  logg_tau20=logg_array[n_elements(logg_array)-3]
  logg_rstar=logg_array[n_elements(logg_array)-4]

  teff=teff_array[n_elements(teff_array)-1]
  t_tau10=teff_array[n_elements(teff_array)-2]
  t_tau20=teff_array[n_elements(teff_array)-3]

  rphot=r_array[n_elements(r_array)-1]
  r_tau10=r_array[n_elements(r_array)-2]
  r_tau20=r_array[n_elements(r_array)-3]
  
  v_tau2d3=v_array[n_elements(v_array)-1]
  v_tau10=v_array[n_elements(v_array)-2]
  v_tau20=v_array[n_elements(v_array)-3]
  v_rstar=v_array[n_elements(v_array)-4]  
ENDIF

IF n_elements(logg_array) EQ 3 THEN BEGIN ;goes ~Tau=20
  logg_phot=logg_array[n_elements(logg_array)-1]
  logg_tau10=logg_array[n_elements(logg_array)-2]
  logg_tau20=logg_array[n_elements(logg_array)-3]

  teff=teff_array[n_elements(teff_array)-1]
  t_tau10=teff_array[n_elements(teff_array)-2]

  rphot=r_array[n_elements(r_array)-1]
  r_tau10=r_array[n_elements(r_array)-2]
  
  v_tau2d3=v_array[n_elements(v_array)-1]
  v_tau10=v_array[n_elements(v_array)-2]
  v_tau20=v_array[n_elements(v_array)-3]  
ENDIF 

IF n_elements(logg_array) EQ 2 THEN BEGIN ;goes ~Tau=10
  logg_phot=logg_array[n_elements(logg_array)-1]
  logg_tau10=logg_array[n_elements(logg_array)-2]

  teff=teff_array[n_elements(teff_array)-1]

  rphot=r_array[n_elements(r_array)-1]
  
  v_tau2d3=v_array[n_elements(v_array)-1]
  v_tau10=v_array[n_elements(v_array)-2]
ENDIF 

END

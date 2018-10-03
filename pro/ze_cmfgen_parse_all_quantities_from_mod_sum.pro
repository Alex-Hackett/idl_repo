PRO ZE_CMFGEN_PARSE_ALL_QUANTITIES_FROM_MOD_SUM,modsum_file,lstar,tstar,teff,rstar,rphot,v_tau23,mdot,vinf1,beta1,maxcorr,mu,habund,heabund,cabund,nabund,oabund,$
                                            feabund,t_tau20,r_tau20,logg_phot,logg_tau20,finf,vstclump,flabund,neabund,naabund,mgabund,alabund,siabund,pabund,$
                                            sabund,clabund,arabund,kabund,caabund,scabund,tiabund,vaabund,crabund,mnabund,coabund,niiabund,babund

ZE_CMFGEN_READ_MOD_SUM,modsum_file,modsum

ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'L*=',lstar
ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'Mdot=',Mdot
ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'R*/Rsun=',rstar
ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'RMAX/R*=',rmax_on_rstar
ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'T*=',tstar
    if tstar eq 0.000 THEN ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'T*(K)=',tstar ;to accomodate changes in MOD_SUM done by John 10-Jan-2012
ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'Vinf1=',vinf1
ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'Beta1=',beta1
ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'Beta1=',beta1
ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'Maximum correcion (%) on last iteration:',maxcorr
ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'Mean atomic mass (amu) is:',mu
ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'CL_P_1=',finf
ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'CL_P_2=',vstclump


;starting here, quantitites that likely will be found more than once in MOD_SUM, and will be arrays. 
ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'Teff=',teff_array
  if min(teff_array) eq 0.000 THEN ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'Teff(K)=',teff_array ;to accomodate changes in MOD_SUM done by John 10-Jan-2012
ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'Log g=',logg_array
ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'R /Rsun=',r_array
ZE_CMFGEN_OBTAIN_QUANTITY_FROM_MOD_SUM,modsum,'V(km/s)=',v_array
ZE_CMFGEN_OBTAIN_ABUND_FROM_MOD_SUM,modsum,'HYD ',habund,/mass
ZE_CMFGEN_OBTAIN_ABUND_FROM_MOD_SUM,modsum,'HE ',heabund,/mass
ZE_CMFGEN_OBTAIN_ABUND_FROM_MOD_SUM,modsum,'CARB ',cabund,/mass
ZE_CMFGEN_OBTAIN_ABUND_FROM_MOD_SUM,modsum,'NIT ',nabund,/mass
ZE_CMFGEN_OBTAIN_ABUND_FROM_MOD_SUM,modsum,'OXY ',oabund,/mass
ZE_CMFGEN_OBTAIN_ABUND_FROM_MOD_SUM,modsum,'FLU ',flabund,/mass
ZE_CMFGEN_OBTAIN_ABUND_FROM_MOD_SUM,modsum,'NEON',neabund,/mass
ZE_CMFGEN_OBTAIN_ABUND_FROM_MOD_SUM,modsum,'SOD ',naabund,/mass
ZE_CMFGEN_OBTAIN_ABUND_FROM_MOD_SUM,modsum,'MAG ',mgabund,/mass
ZE_CMFGEN_OBTAIN_ABUND_FROM_MOD_SUM,modsum,'ALUM',alabund,/mass
ZE_CMFGEN_OBTAIN_ABUND_FROM_MOD_SUM,modsum,'SIL ',siabund,/mass
ZE_CMFGEN_OBTAIN_ABUND_FROM_MOD_SUM,modsum,'PHOS',pabund,/mass
ZE_CMFGEN_OBTAIN_ABUND_FROM_MOD_SUM,modsum,'SUL ',sabund,/mass
ZE_CMFGEN_OBTAIN_ABUND_FROM_MOD_SUM,modsum,'CHL ',clabund,/mass
ZE_CMFGEN_OBTAIN_ABUND_FROM_MOD_SUM,modsum,'ARG ',arabund,/mass
ZE_CMFGEN_OBTAIN_ABUND_FROM_MOD_SUM,modsum,'POT ',kabund,/mass
ZE_CMFGEN_OBTAIN_ABUND_FROM_MOD_SUM,modsum,'CAL ',caabund,/mass
ZE_CMFGEN_OBTAIN_ABUND_FROM_MOD_SUM,modsum,'SCAN',scabund,/mass
ZE_CMFGEN_OBTAIN_ABUND_FROM_MOD_SUM,modsum,'TIT ',tiabund,/mass
ZE_CMFGEN_OBTAIN_ABUND_FROM_MOD_SUM,modsum,'VAN ',vaabund,/mass
ZE_CMFGEN_OBTAIN_ABUND_FROM_MOD_SUM,modsum,'CHRO',crabund,/mass
ZE_CMFGEN_OBTAIN_ABUND_FROM_MOD_SUM,modsum,'MAN ',mnabund,/mass
ZE_CMFGEN_OBTAIN_ABUND_FROM_MOD_SUM,modsum,'IRON',feabund,/mass
ZE_CMFGEN_OBTAIN_ABUND_FROM_MOD_SUM,modsum,'COB ',coabund,/mass
ZE_CMFGEN_OBTAIN_ABUND_FROM_MOD_SUM,modsum,'NICK',niiabund,/mass
ZE_CMFGEN_OBTAIN_ABUND_FROM_MOD_SUM,modsum,'BAR ',babund,/mass

;sorting into doubles, taking into account that some models don't go as deep as Tau=100, or Tau=20
IF n_elements(v_array) EQ 4 THEN BEGIN ;goes ~ Tau=100 
  teff=teff_array[n_elements(teff_array)-1]
  t_tau10=teff_array[n_elements(teff_array)-2]
  t_tau20=teff_array[n_elements(teff_array)-3]

  rphot=r_array[n_elements(r_array)-1]
  r_tau10=r_array[n_elements(r_array)-2]
  r_tau20=r_array[n_elements(r_array)-3]
  
  v_tau23=v_array[n_elements(v_array)-1]
  v_tau10=v_array[n_elements(v_array)-2]
  v_tau20=v_array[n_elements(v_array)-3]
  v_rstar=v_array[n_elements(v_array)-4]  
  
  IF n_elements(logg_array) EQ 4 THEN BEGIN  
    logg_phot=logg_array[n_elements(logg_array)-1]
    logg_tau10=logg_array[n_elements(logg_array)-2]
    logg_tau20=logg_array[n_elements(logg_array)-3]
    logg_rstar=logg_array[n_elements(logg_array)-4]
  ENDIF ELSE logg_array=[-1,-1,-1,-1]  
  
ENDIF

IF n_elements(v_array) EQ 3 THEN BEGIN ;goes ~Tau=20
  teff=teff_array[n_elements(teff_array)-1]
  t_tau10=teff_array[n_elements(teff_array)-2]

  rphot=r_array[n_elements(r_array)-1]
  r_tau10=r_array[n_elements(r_array)-2]
  
  v_tau2d3=v_array[n_elements(v_array)-1]
  v_tau10=v_array[n_elements(v_array)-2]
  v_rstar=v_array[n_elements(v_array)-3]  
  
    IF n_elements(logg_array) EQ 3 THEN BEGIN  
    logg_phot=logg_array[n_elements(logg_array)-1]
    logg_tau10=logg_array[n_elements(logg_array)-2]
    logg_rstar=logg_array[n_elements(logg_array)-3]
    ENDIF ELSE logg_array=[-1,-1,-1] 
  
ENDIF 

IF n_elements(v_array) EQ 2 THEN BEGIN ;goes ~Tau=10

  teff=teff_array[n_elements(teff_array)-1]

  rphot=r_array[n_elements(r_array)-1]
  
  v_tau2d3=v_array[n_elements(v_array)-1]
  v_tau10=v_array[n_elements(v_array)-2]
  
    IF n_elements(logg_array) EQ 2 THEN BEGIN  
    logg_phot=logg_array[n_elements(logg_array)-1]
    logg_rstar=logg_array[n_elements(logg_array)-2]
    ENDIF ELSE logg_array=[-1,-1,-1] 
ENDIF 

if n_elements(t_tau20) eq 0 then t_tau20=-99.0
if n_elements(r_tau20) eq 0 then r_tau20=-99.0
if n_elements(logg_tau20) eq 0 then logg_tau20=-99.0
if n_elements(logg_phot) eq 0 then logg_phot=-99.0

END

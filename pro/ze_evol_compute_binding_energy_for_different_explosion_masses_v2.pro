PRO ZE_EVOL_COMPUTE_BINDING_ENERGY_FOR_DIFFERENT_EXPLOSION_MASSES_V2,model_name,massstr,modeldir=modeldir
;computes energy needed for unbinding a certain amount of mass 
;v2 reads .sav Structfile to save time
;
ZE_EVOL_CONST,pi,cst_c,cst_G,cs,t_h,cst_k,cst_a,rgaz,cst_sigma,cst_me,cst_avo,cst_u,cst_mh,cst_thomson,cst_e,cst_ecgs,qapicg,cst_K1, $
                  lgpi,cstlg_c,cstlg_G,cstlg_h,cstlg_k,cstlg_a,rgazlg,cstlg_sigma,cstlg_me,cstlg_avo,cstlg_u,cstlg_mh,cstlg_thomson,cstlg_e, $
                  lgqapicg,cstlg_K1,Msol,Rsol,Lsol,xlsomo,uastr,year,lgMsol,lgRsol,lgLsol,Q_H,Q_He,Q_C,convMeVerg

;model_name='P060z14S0'
;modeldir='/Users/jgroh/evol_models/tes/P060z14S0/'

if n_Elements(modeldir) eq 0 then modeldir='/Users/jgroh/evol_models/Z014/'+model_name
modelstr=string(model_name,format='(A9)')

;ZE_EVOL_FIND_AVAILABLE_TIMESTEPS,modelstr,'_StrucData_',timesteps_available,dirmod=modeldir ;finds which timesteps are available in dir -- useful in case only selected .v. files are there.

ZE_EVOL_READ_ALL_TIMESTEPS_STRUCT_FILE_FROM_GENEVA_ORIGIN2010,modelstr,timesteps_available,$     
array_n,array_logr,array_Mint,array_logT,array_logrho,array_logptot,array_cv,array_dlnP_over_dlnrho_T,$
array_nabla_e,array_nabla_ad,array_Lrad,array_ltot,array_logkappa,array_X_H1,array_X_He4,array_mu,$
array_epsilon,array_logprad,array_logpgas,array_prad_over_ptot,array_pgas_over_ptot,array_logpturb,$
array_ledd,array_gammafull_rad,array_gammafull_tot,array_nablarad,array_ebind,array_Mstar,array_Mext,modeldir=modeldir,reload=reload

ebind_for_mass=dblarr(n_elements(timesteps_available))
Mint_at_mass=dblarr(n_elements(timesteps_available))
Mext_at_mass=dblarr(n_elements(timesteps_available))
logr_at_mass=dblarr(n_elements(timesteps_available))
Mstar=dblarr(n_elements(timesteps_available))
logrstar=dblarr(n_elements(timesteps_available))

;massstr='10' ;no dots,special characters
mass=double(massstr)
savedfile='/Users/jgroh/temp/'+model_name+'_ebind_for_mass_'+massstr+'.sav'

IF (FILE_EXIST(savedfile) eq 0) OR KEYWORD_SET(RELOAD) THEN BEGIN 

 for i=0, n_elements(timesteps_available) -1d0 DO BEGIN 
  s=findel(mass,array_Mext[*,i]/Msol)

  ebind_for_mass[i]=array_ebind[s,i]
  Mint_at_mass[i]=array_Mint[s,i]/Msol ;in solar masses
  Mext_at_mass[i]=array_Mext[s,i]/Msol ;in solar masses
  logr_at_mass[i]=array_logr[s,i]      ;log
  logrstar[i]=array_logr[(size(array_logr))[1]-1,i]
  
 endfor
save,ebind_for_mass,Mint_at_mass,Mext_at_mass,logr_at_mass,Mstar,logrstar,timesteps_available,filename=savedfile

ENDIF ELSE BEGIN
  print,'A .sav corresponding to model '+ savedfile+' has been found in /Users/jgroh/temp. Loading...'
  restore,savedfile
ENDELSE


END
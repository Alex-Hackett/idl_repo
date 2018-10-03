PRO ZE_EVOL_COMPUTE_H_HE_MASS_ALL_TIMESTEPS,model_name,h1_mass,he4_mass,timesteps_available,modeldir=modeldir,struct_all_reload=struct_all_reload
ZE_EVOL_CONST,pi,cst_c,cst_G,cs,t_h,cst_k,cst_a,rgaz,cst_sigma,cst_me,cst_avo,cst_u,cst_mh,cst_thomson,cst_e,cst_ecgs,qapicg,cst_K1, $
                  lgpi,cstlg_c,cstlg_G,cstlg_h,cstlg_k,cstlg_a,rgazlg,cstlg_sigma,cstlg_me,cstlg_avo,cstlg_u,cstlg_mh,cstlg_thomson,cstlg_e, $
                  lgqapicg,cstlg_K1,Msol,Rsol,Lsol,xlsomo,uastr,year,lgMsol,lgRsol,lgLsol,Q_H,Q_He,Q_C,convMeVerg

if n_Elements(modeldir) eq 0 then modeldir='/Users/jgroh/evol_models/Z014/'+model_name

;obtain modelstr from modeldir and NOT model_name, i.e. ignores model_name
modelstr=strmid(modeldir,strpos(modeldir,'/',/reverse_search)+1)

ZE_EVOL_READ_ALL_TIMESTEPS_STRUCT_FILE_FROM_GENEVA_ORIGIN2010,modelstr,timesteps_available,$     
array_n,array_logr,array_Mint,array_logT,array_logrho,array_logptot,array_cv,array_dlnP_over_dlnrho_T,$
array_nabla_e,array_nabla_ad,array_Lrad,array_ltot,array_logkappa,array_X_H1,array_X_He4,array_mu,$
array_epsilon,array_logprad,array_logpgas,array_prad_over_ptot,array_pgas_over_ptot,array_logpturb,$
array_ledd,array_gammafull_rad,array_gammafull_tot,array_nablarad,array_ebind,array_Mstar,array_Mext,modeldir=modeldir,reload=struct_all_reload

h1_mass=dblarr(n_elements(timesteps_available))
he4_mass=dblarr(n_elements(timesteps_available))

;massstr='10' ;no dots,special characters
savedfile='/Users/jgroh/temp/'+model_name+'_total_H_He_mass.sav'

;IF (FILE_EXIST(savedfile) eq 0) OR KEYWORD_SET(RELOAD) THEN BEGIN 

 for i=0, n_elements(timesteps_available) -1d0 DO BEGIN 
  h1_mass[i]=TOTAL(array_X_H1[*,i]*(array_Mint[*,i]-shift(array_Mint[*,i],1)))/Msol
  he4_mass[i]=TOTAL(array_X_He4[*,i]*(array_Mint[*,i]-shift(array_Mint[*,i],1)))/Msol
 endfor
;save,h1_mass,he_mass,timesteps_available,filename=savedfile

;ENDIF ELSE BEGIN
;  print,'A .sav corresponding to model '+ savedfile+' has been found in /Users/jgroh/temp. Loading...'
;  restore,savedfile
;ENDELSE


END
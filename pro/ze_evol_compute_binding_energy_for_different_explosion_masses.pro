PRO ZE_EVOL_COMPUTE_BINDING_ENERGY_FOR_DIFFERENT_EXPLOSION_MASSES,model_name,massstr,modeldir=modeldir
;computes energy needed for unbinding a certain amount of mass 

ZE_EVOL_CONST,pi,cst_c,cst_G,cs,t_h,cst_k,cst_a,rgaz,cst_sigma,cst_me,cst_avo,cst_u,cst_mh,cst_thomson,cst_e,cst_ecgs,qapicg,cst_K1, $
                  lgpi,cstlg_c,cstlg_G,cstlg_h,cstlg_k,cstlg_a,rgazlg,cstlg_sigma,cstlg_me,cstlg_avo,cstlg_u,cstlg_mh,cstlg_thomson,cstlg_e, $
                  lgqapicg,cstlg_K1,Msol,Rsol,Lsol,xlsomo,uastr,year,lgMsol,lgRsol,lgLsol,Q_H,Q_He,Q_C,convMeVerg

;model_name='P060z14S0'
;modeldir='/Users/jgroh/evol_models/tes/P060z14S0/'
if n_Elements(modeldir) eq 0 then modeldir='/Users/jgroh/evol_models/Z014/'+model_name
modelstr=string(model_name,format='(A9)')
ZE_EVOL_FIND_AVAILABLE_TIMESTEPS,modelstr,'_StrucData_',timesteps_available,dirmod=modeldir ;finds which timesteps are available in dir -- useful in case only selected .v. files are there.

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

for i=0, n_elements(timesteps_available) -1 DO BEGIN

  timestep=timesteps_available[i]
  timestepstr=string(timestep)
  struct_file=modeldir+'/'+modelstr+'_StrucData_'+strcompress(string(timestep, format='(I07)'))+'.dat'

  print,struct_file
  ZE_EVOL_READ_STRUCT_FILE_FROM_GENEVA_ORIGIN2010,modeldir,modelstr,timestep,data_struct_file,header_struct_file,modnb,age,mtot,nbshell,deltat,/compress

  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'n',data_struct_file,n,index_varnamex_struct_file,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'logr',data_struct_file,logr,index_varnamex_struct_file,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'Mint',data_struct_file,Mint,index_varnamex_struct_file,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'logT',data_struct_file,logT,index_varnamex_struct_file,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'logrho',data_struct_file,logrho,index_varnamex_struct_file,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'logP',data_struct_file,logp,index_varnamex_struct_file,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'Cv',data_struct_file,cv,index_varnamex_struct_file,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'dlnP_over_dlnrho_T',data_struct_file,dlnP_over_dlnrho_T,index_varnamex_struct_file1,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'nabla_e',data_struct_file,nabla_e,index_varnamex_struct_file1,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'nabla_ad',data_struct_file,nabla_ad,index_varnamex_struct_file1,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'Lrad',data_struct_file,Lrad,index_varnamex_struct_file,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'Ltot',data_struct_file,Ltot,index_varnamex_struct_file,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'logkappa',data_struct_file,logkappa,index_varnamex_struct_file,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'X_H1',data_struct_file,X_H1,index_varnamex_struct_file,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'X_He4',data_struct_file,X_He4,index_varnamex_struct_file,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'mu',data_struct_file,mu,index_varnamex_struct_file,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'epsilon',data_struct_file,epsilon,index_varnamex_struct_file,return_valx

  ZE_EVOL_COMPUTE_QUANTITIES_FROM_STRUCTFILE,data_struct_file,logprad,logpgas,prad_over_ptot,pgas_over_ptot,logpturb,ledd,gammafull_rad,gammafull_tot,nablarad,ebind=ebind
  Mstar=Mint[n_elements(Mint)-1]
  Mext=(Mstar-Mint)
  s=findel(mass,Mext/Msol)

  ebind_for_mass[i]=ebind[s]
  Mint_at_mass[i]=Mint[s]/Msol ;in solar masses
  Mext_at_mass[i]=Mext[s]/Msol ;in solar masses
  logr_at_mass[i]=logr[s]      ;log
  logrstar[i]=logr[n_elements(logr)-1]
  
ENDFOR
save,ebind_for_mass,Mint_at_mass,Mext_at_mass,logr_at_mass,Mstar,logrstar,timesteps_available,filename=savedfile

ENDIF ELSE BEGIN
  print,'A .sav corresponding to model '+ savedfile+' has been found in /Users/jgroh/temp. Loading...'
  restore,savedfile
ENDELSE


END
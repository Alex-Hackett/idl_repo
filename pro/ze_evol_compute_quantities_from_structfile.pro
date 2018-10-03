PRO ZE_EVOL_COMPUTE_QUANTITIES_FROM_STRUCTFILE,data_struct_file,logprad,logpgas,prad_over_ptot,pgas_over_ptot,logpturb,ledd,gammafull_rad,gammafull_tot,nablarad,$
                                                ekin=ekin,erad=erad,eint=eint,ebind=ebind

ZE_EVOL_CONST,pi,cst_c,cst_G,cs,t_h,cst_k,cst_a,rgaz,cst_sigma,cst_me,cst_avo,cst_u,cst_mh,cst_thomson,cst_e,cst_ecgs,qapicg,cst_K1, $
                  lgpi,cstlg_c,cstlg_G,cstlg_h,cstlg_k,cstlg_a,rgazlg,cstlg_sigma,cstlg_me,cstlg_avo,cstlg_u,cstlg_mh,cstlg_thomson,cstlg_e, $
                  lgqapicg,cstlg_K1,Msol,Rsol,Lsol,xlsomo,uastr,year,lgMsol,lgRsol,lgLsol,Q_H,Q_He,Q_C,convMeVerg
                  
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

nbshell=dblarr(n_elements(n))

logprad=alog10(cst_a*(10^logt)^4)   ;Prad=(a/3)T^4
logpgas=alog10(rgaz*10^logrho*10^logT/mu)   ;Pgas
prad_over_ptot=10^logprad/10^logp
pgas_over_ptot=10^logpgas/10^logp
logpturb=alog10(10^logp-10^logprad-10^logpgas)  ;WARNING HERE DOES NOT READ PTURB FROM FILE, COMPUTES FROM the difference remaining to achieve PTOT
ledd=(4d0*!PI*29979245800*6.67e-8*Mint/10^logkappa)/3.839e33
gammafull_rad=1D0*lrad*10^logkappa/(4d0*!PI*29979245800*6.67e-8*Mint)
gammafull_tot=1D0*ltot*10^logkappa/(4d0*!PI*29979245800*6.67e-8*Mint)
nablarad=(3D0*(10^logkappa)*ltot*10^logp)/(16D0*!PI*cst_a*cst_c*cst_G*mint*(10^logt)^4)

;REMEMBER: Mint is not the shell mass Mr!!!!!!!!
Mr=Mint-shift(Mint,1)
mr[0]=0

;issues here
IF KEYWORD_SET(ekin) THEN ekin=ZE_EVOL_COMPUTE_EKIN_GAS(Mr,10^logT, mu,integrated=1)
IF KEYWORD_SET(erad) THEN erad=ZE_EVOL_COMPUTE_ERAD(10^logT,10^logr,integrated=1)
IF KEYWORD_SET(eint) THEN  eint=ekin+erad
;this isfine
ZE_COMPUTE_BINDING_ENERGY_ALL,logr,Mint,logT,mu,ebind,deltaebind=deltaebind,eint=eint


END
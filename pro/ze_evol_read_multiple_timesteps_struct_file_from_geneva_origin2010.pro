PRO ZE_EVOL_READ_MULTIPLE_TIMESTEPS_STRUCT_FILE_FROM_GENEVA_ORIGIN2010,modelstr,modeldir,timesteps_available

ncolumns_all=30
nbshell_all=1500
ntimesteps=n_elements(timesteps_available)
savedfile='/Users/jgroh/temp/'+modelstr+'_Structfile_all.sav'


array_data_struct_file=dblarr(ncolumns_all,nbshell_all,ntimesteps)

;array_header_struct_file=strarr(nbshell_all,ntimesteps)
;array_modnb=dblarr(ncolumns_all,nbshell_all,ntimesteps)
;array_age=dblarr(ncolumns_all,nbshell_all,ntimesteps)
;array_mtot=dblarr(ncolumns_all,nbshell_all,ntimesteps)
array_nbshell=dblarr(nbshell_all,ntimesteps)
;array_deltat=dblarr(ncolumns_all,nbshell_all,ntimesteps)

array_n=dblarr(nbshell_all,ntimesteps)
array_logr=dblarr(nbshell_all,ntimesteps)
array_Mint=dblarr(nbshell_all,ntimesteps)
array_logT=dblarr(nbshell_all,ntimesteps)
array_logrho=dblarr(nbshell_all,ntimesteps)
array_logp=dblarr(nbshell_all,ntimesteps)
array_cv=dblarr(nbshell_all,ntimesteps)
array_dlnP_over_dlnrho_T=dblarr(nbshell_all,ntimesteps)
array_nabla_e=dblarr(nbshell_all,ntimesteps)
array_nabala_ad=dblarr(nbshell_all,ntimesteps)
array_Lrad=dblarr(nbshell_all,ntimesteps)
array_ltot=dblarr(nbshell_all,ntimesteps)
array_logkappa=dblarr(nbshell_all,ntimesteps)
array_X_H1=dblarr(nbshell_all,ntimesteps)
array_X_He4=dblarr(nbshell_all,ntimesteps)
array_mu=dblarr(nbshell_all,ntimesteps)
array_epsilon=dblarr(nbshell_all,ntimesteps)

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

 
array_n[0:nbshell-1,i]=n
array_logr[0:nbshell-1,i]=logr
array_Mint[0:nbshell-1,i]=Mint
array_logT[0:nbshell-1,i]=logT
array_logrho[0:nbshell-1,i]=logrho
array_logp[0:nbshell-1,i]=logp
array_cv[0:nbshell-1,i]=cv
array_dlnP_over_dlnrho_T[0:nbshell-1,i]=dlnP_over_dlnrho_T
array_nabla_e[0:nbshell-1,i]=nabla_e
array_nabla_ad[0:nbshell-1,i]=nabla_ad
array_Lrad[0:nbshell-1,i]=lrad
array_ltot[0:nbshell-1,i]=ltot
array_logkappa[0:nbshell-1,i]=logkappa
array_X_H1[0:nbshell-1,i]=x_h1
array_X_He4[0:nbshell-1,i]=x_he4
array_mu[0:nbshell-1,i]=mu
array_epsilon[0:nbshell-1,i]=epsilon
array_logprad[0:nbshell-1,i]=logprad
array_logpgas[0:nbshell-1,i]=logpgas
array_prad_over_ptot[0:nbshell-1,i]=prad_over_ptot
array_pgas_over_ptot[0:nbshell-1,i]=pgas_over_ptot
array_logpturb[0:nbshell-1,i]=logpturb
array_ledd[0:nbshell-1,i]=ledd
array_gammafull_rad[0:nbshell-1,i]=gammafull_rad
array_gammafull_tot[0:nbshell-1,i]=gammafull_tot
array_nablarad[0:nbshell-1,i]=nablarad
IF N_elements(ebind) GT 2 THEN array_ebind[0:nbshell-1,i]=ebind
array_Mstar[0:nbshell-1,i]=Mstar
array_Mext[0:nbshell-1,i]=Mext

save,/all,filename=savedfile


ENDFOR

END
PRO AH_CONVECTIVE_ZONES
dummyplot = SCATTERPLOT([0,0],[0,0],xrange = [0,2],XTITLE = this_age,YTITLE = '$cm$')
structfiles = FILE_SEARCH('/home/AHACKETT_Project/_PopIIIProject/geneva_models/P015z000S0d050', '*Struc*') 
FOREACH strucfile, structfiles DO BEGIN
;Analyzes the convective zones in the P015z000S0d010 Model
;ROUND(ARRGEN(1,N_ELEMENTS(structfiles),1.1,/LOG))]
tempdir='/home/AHACKETT_Project/_PopIIIProject/geneva_models/P015z000S0d010_Convection'

;Reading in the 10% overshooting model
modeldir='/home/AHACKETT_Project/_PopIIIProject/geneva_models/P015z000S0d030'
modelstr='P015d030'
wgfile=modeldir+'/'+modelstr+'.wg'

;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut,timestep_ini=timestep
;
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar10,logg10,vesc10,vinf10,eta_star10,Bmin10,Jdot10,logg_rphot10,rphot10,beq10,beta10,ekin10,teffjump110,teffjump210,model=model,logtcollapse=logtcollapse10
;
;
;;Timestep #
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'nm',data_wgfile_cut,nm10,index_varnamex_wgfile,return_valx
;
;;Age yrs
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT, 'u1',data_wgfile_cut,u110,index_varnamex_wgfile,return_valx
;
;fullage = u110[-1]
;PRINT, 'Model Ran for', fullage, 'Years'
;READ, PROMPT = 'Enter Age in Yrs to Analyze Structure', sel_age
;
;;Find the closest timestep to the chosen age in yrs
;timestep = nm10[WHERE(u110 EQ NEAREST_ELEMENT(sel_age, u110))]
;timestep = STRING(timestep)
;struct_file=modeldir+'/'+modelstr+'_StrucData_'+strcompress(string(timestep, format='(I07)'))+'.dat'
;print,struct_file

ZE_EVOL_READ_STRUCT_FILE_FROM_GENEVA_ORIGIN2010_V1,strucfile,modeldir,modelstr,timestep,data_struct_file,header_struct_file,modnb,age,mtot,nbshell,deltat,ncolumns,logteff,/compress,header1
;print,logteff
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
radius = 10^logr
ZE_EVOL_COMPUTE_QUANTITIES_FROM_STRUCTFILE,data_struct_file,logprad,logpgas,prad_over_ptot,pgas_over_ptot,logpturb,ledd,gammafull_rad,gammafull_tot,nablarad,ebind=ebind
this_age=string(((header1[1])))
con_zones = n[WHERE(nabla_e GE nabla_ad)]
non_con_zones = n[WHERE(nabla_e LT nabla_ad)]
con_zones_mass = Mint[WHERE(nabla_e GE nabla_ad)]
non_con_zones_mass = Mint[WHERE(nabla_e LT nabla_ad)]
con_zones_r = radius[WHERE(nabla_e GE nabla_ad)]
non_con_zones_r = radius[WHERE(nabla_e LT nabla_ad)]
CZ = SCATTERPLOT(MAKE_ARRAY(N_ELEMENTS(con_zones_r),value =1),con_zones_r/(1),/OVERPLOT,xrange = [0,2],XTITLE = this_age,YTITLE = '$cm$',/SYM_FILLED, SYM_COLOR = 'red', NAME = 'Unstable Against Convection (Schwarzschild)')
NCZ = SCATTERPLOT(MAKE_ARRAY(N_ELEMENTS(non_con_zones_r),value =1),non_con_zones_r/(1),/OVERPLOT, /SYM_FILLED, SYM_COLOR = 'black',NAME= 'Stable Against Convection')
;leg1 = LEGEND(TARGET = [CZ, NCZ], SHADOW = 0)
ENDFOREACH
END
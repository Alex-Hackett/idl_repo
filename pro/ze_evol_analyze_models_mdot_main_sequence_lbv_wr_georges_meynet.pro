;PRO ZE_EVOL_ANALYZE_MODELS_MDOT_MAIN_SEQUENCE_LBV_WR_GEORGES_MEYNET

;MS 1/4, LBV 1/20 ends up as LBV, so no need for WR models with different Mdot
dir='/Users/jgroh/evol_models/tes/P060z14S0_ms_mdot4/'
model='P060z14S0_ms_mdot4'
wgfile=dir+model+'.wg' ;assumes model is in wg directory
timestep_ini=49
ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload,timestep_ini=timestep_ini
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60_ms_mdot4,logg60_ms_mdot4,vesc60_ms_mdot4,vinf60_ms_mdot4,eta_star60_ms_mdot4,Bmin60_ms_mdot4,Jdot60_ms_mdot4,logg_rphot60_ms_mdot4,rphot60_ms_mdot4,beq60_ms_mdot4,beta60_ms_mdot4,ekin60_ms_mdot4,model=model,logtcollapse=logtcollapse60_ms_mdot4
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'nm',data_wgfile_cut,nm60_ms_mdot4,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u160_ms_mdot4,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u2',data_wgfile_cut,u260_ms_mdot4,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt60_ms_mdot4,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl60_ms_mdot4,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u560_ms_mdot4,return_valz    ;X surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u7',data_wgfile_cut,u760_ms_mdot4,return_valz    ;Y surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u860_ms_mdot4,return_valz    ;C surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1060_ms_mdot4,return_valz  ; N surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u1260_ms_mdot4,return_valz   ; O surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u6',data_wgfile_cut,u660_ms_mdot4,return_valz   ; Ne surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u15',data_wgfile_cut,u1560_ms_mdot4,return_valz    ;X center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u17',data_wgfile_cut,u1760_ms_mdot4,return_valz    ;Y center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,u1860_ms_mdot4,return_valz    ;C center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u20',data_wgfile_cut,u2060_ms_mdot4,return_valz  ; N center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u22',data_wgfile_cut,u2260_ms_mdot4,return_valz   ; O center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u16',data_wgfile_cut,u1660_ms_mdot4,return_valz   ; Ne center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot60_ms_mdot4,return_valz  
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte60_ms_mdot4,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesm',data_wgfile_cut,eddesm60_ms_mdot4,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc60_ms_mdot4,index_varnamex_wgfile,return_valx

ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth_ms_mdot4,tendh=tendh_ms_mdot4,modelnumber_starth=modelnumber_starth_ms_mdot4,modelnumber_endh=modelnumber_endh_ms_mdot4,tauh=tauh_ms_mdot4,$
                                    tstart_he=tstart_he_ms_mdot4,tend_he=tend_he_ms_mdot4,modelnumber_start_he=modelnumber_start_he_ms_mdot4,modelnumber_end_he=modelnumber_end_he_ms_mdot4,tau_he=tau_he_ms_mdot4,$
                                    tstartc=tstartc_ms_mdot4,tendc=tendc_ms_mdot4,modelnumber_startc=modelnumber_startc_ms_mdot4,modelnumber_endc=modelnumber_endc_ms_mdot4,tauc=tauc_ms_mdot4,$
                                    tstarto=tstarto_ms_mdot4,tendo=tendo_ms_mdot4,modelnumber_starto=modelnumber_starto_ms_mdot4,modelnumber_endo=modelnumber_endo_ms_mdot4,tauo=tauo_ms_mdot4,$
                                    tstartne=tstartne_ms_mdot4,tendne=tendne_ms_mdot4,modelnumber_startne=modelnumber_startne_ms_mdot4,modelnumber_endne=modelnumber_endne_ms_mdot4,taune=taune_ms_mdot4

;MS 1/4, LBV 1, WR 1/2
dir='/Users/jgroh/evol_models/tes/P060z14S0_ms_mdot4_lbvstd_wr_0.5x/'
model='P060z14S0_ms_mdot4_lbvstd_wr_0.5x'
wgfile=dir+model+'.wg' ;assumes model is in wg directory
timestep_ini=49
ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload,timestep_ini=timestep_ini
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60_ms_mdot4_lbvstd_wr_0d5x,logg60_ms_mdot4_lbvstd_wr_0d5x,vesc60_ms_mdot4_lbvstd_wr_0d5x,vinf60_ms_mdot4_lbvstd_wr_0d5x,eta_star60_ms_mdot4_lbvstd_wr_0d5x,Bmin60_ms_mdot4_lbvstd_wr_0d5x,Jdot60_ms_mdot4_lbvstd_wr_0d5x,logg_rphot60_ms_mdot4_lbvstd_wr_0d5x,rphot60_ms_mdot4_lbvstd_wr_0d5x,beq60_ms_mdot4_lbvstd_wr_0d5x,beta60_ms_mdot4_lbvstd_wr_0d5x,ekin60_ms_mdot4_lbvstd_wr_0d5x,model=model,logtcollapse=logtcollapse60_ms_mdot4_lbvstd_wr_0d5x
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'nm',data_wgfile_cut,nm60_ms_mdot4_lbvstd_wr_0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u160_ms_mdot4_lbvstd_wr_0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u2',data_wgfile_cut,u260_ms_mdot4_lbvstd_wr_0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt60_ms_mdot4_lbvstd_wr_0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl60_ms_mdot4_lbvstd_wr_0d5x,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u560_ms_mdot4_lbvstd_wr_0d5x,return_valz    ;X surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u7',data_wgfile_cut,u760_ms_mdot4_lbvstd_wr_0d5x,return_valz    ;Y surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u860_ms_mdot4_lbvstd_wr_0d5x,return_valz    ;C surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1060_ms_mdot4_lbvstd_wr_0d5x,return_valz  ; N surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u1260_ms_mdot4_lbvstd_wr_0d5x,return_valz   ; O surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u6',data_wgfile_cut,u660_ms_mdot4_lbvstd_wr_0d5x,return_valz   ; Ne surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u15',data_wgfile_cut,u1560_ms_mdot4_lbvstd_wr_0d5x,return_valz    ;X center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u17',data_wgfile_cut,u1760_ms_mdot4_lbvstd_wr_0d5x,return_valz    ;Y center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,u1860_ms_mdot4_lbvstd_wr_0d5x,return_valz    ;C center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u20',data_wgfile_cut,u2060_ms_mdot4_lbvstd_wr_0d5x,return_valz  ; N center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u22',data_wgfile_cut,u2260_ms_mdot4_lbvstd_wr_0d5x,return_valz   ; O center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u16',data_wgfile_cut,u1660_ms_mdot4_lbvstd_wr_0d5x,return_valz   ; Ne center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot60_ms_mdot4_lbvstd_wr_0d5x,return_valz  
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte60_ms_mdot4_lbvstd_wr_0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesm',data_wgfile_cut,eddesm60_ms_mdot4_lbvstd_wr_0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc60_ms_mdot4_lbvstd_wr_0d5x,index_varnamex_wgfile,return_valx

ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth_ms_mdot4_lbvstd_wr_0d5x,tendh=tendh_ms_mdot4_lbvstd_wr_0d5x,modelnumber_starth=modelnumber_starth_ms_mdot4_lbvstd_wr_0d5x,modelnumber_endh=modelnumber_endh_ms_mdot4_lbvstd_wr_0d5x,tauh=tauh_ms_mdot4_lbvstd_wr_0d5x,$
                                    tstart_he=tstart_he_ms_mdot4_lbvstd_wr_0d5x,tend_he=tend_he_ms_mdot4_lbvstd_wr_0d5x,modelnumber_start_he=modelnumber_start_he_ms_mdot4_lbvstd_wr_0d5x,modelnumber_end_he=modelnumber_end_he_ms_mdot4_lbvstd_wr_0d5x,tau_he=tau_he_ms_mdot4_lbvstd_wr_0d5x,$
                                    tstartc=tstartc_ms_mdot4_lbvstd_wr_0d5x,tendc=tendc_ms_mdot4_lbvstd_wr_0d5x,modelnumber_startc=modelnumber_startc_ms_mdot4_lbvstd_wr_0d5x,modelnumber_endc=modelnumber_endc_ms_mdot4_lbvstd_wr_0d5x,tauc=tauc_ms_mdot4_lbvstd_wr_0d5x,$
                                    tstarto=tstarto_ms_mdot4_lbvstd_wr_0d5x,tendo=tendo_ms_mdot4_lbvstd_wr_0d5x,modelnumber_starto=modelnumber_starto_ms_mdot4_lbvstd_wr_0d5x,modelnumber_endo=modelnumber_endo_ms_mdot4_lbvstd_wr_0d5x,tauo=tauo_ms_mdot4_lbvstd_wr_0d5x,$
                                    tstartne=tstartne_ms_mdot4_lbvstd_wr_0d5x,tendne=tendne_ms_mdot4_lbvstd_wr_0d5x,modelnumber_startne=modelnumber_startne_ms_mdot4_lbvstd_wr_0d5x,modelnumber_endne=modelnumber_endne_ms_mdot4_lbvstd_wr_0d5x,taune=taune_ms_mdot4_lbvstd_wr_0d5x

;MS 1/4, LBV 1, WR 1
dir='/Users/jgroh/evol_models/tes/P060z14S0_ms_mdot4_lbvstd/'
model='P060z14S0_ms_mdot4_lbvstd'
wgfile=dir+model+'.wg' ;assumes model is in wg directory
timestep_ini=49
ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload,timestep_ini=timestep_ini
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60_ms_mdot4_lbvstd,logg60_ms_mdot4_lbvstd,vesc60_ms_mdot4_lbvstd,vinf60_ms_mdot4_lbvstd,eta_star60_ms_mdot4_lbvstd,Bmin60_ms_mdot4_lbvstd,Jdot60_ms_mdot4_lbvstd,logg_rphot60_ms_mdot4_lbvstd,rphot60_ms_mdot4_lbvstd,beq60_ms_mdot4_lbvstd,beta60_ms_mdot4_lbvstd,ekin60_ms_mdot4_lbvstd,model=model,logtcollapse=logtcollapse60_ms_mdot4_lbvstd
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'nm',data_wgfile_cut,nm60_ms_mdot4_lbvstd,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u160_ms_mdot4_lbvstd,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u2',data_wgfile_cut,u260_ms_mdot4_lbvstd,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt60_ms_mdot4_lbvstd,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl60_ms_mdot4_lbvstd,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u560_ms_mdot4_lbvstd,return_valz    ;X surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u7',data_wgfile_cut,u760_ms_mdot4_lbvstd,return_valz    ;Y surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u860_ms_mdot4_lbvstd,return_valz    ;C surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1060_ms_mdot4_lbvstd,return_valz  ; N surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u1260_ms_mdot4_lbvstd,return_valz   ; O surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u6',data_wgfile_cut,u660_ms_mdot4_lbvstd,return_valz   ; Ne surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u15',data_wgfile_cut,u1560_ms_mdot4_lbvstd,return_valz    ;X center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u17',data_wgfile_cut,u1760_ms_mdot4_lbvstd,return_valz    ;Y center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,u1860_ms_mdot4_lbvstd,return_valz    ;C center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u20',data_wgfile_cut,u2060_ms_mdot4_lbvstd,return_valz  ; N center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u22',data_wgfile_cut,u2260_ms_mdot4_lbvstd,return_valz   ; O center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u16',data_wgfile_cut,u1660_ms_mdot4_lbvstd,return_valz   ; Ne center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot60_ms_mdot4_lbvstd,return_valz  
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte60_ms_mdot4_lbvstd,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesm',data_wgfile_cut,eddesm60_ms_mdot4_lbvstd,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc60_ms_mdot4_lbvstd,index_varnamex_wgfile,return_valx

ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth_ms_mdot4_lbvstd,tendh=tendh_ms_mdot4_lbvstd,modelnumber_starth=modelnumber_starth_ms_mdot4_lbvstd,modelnumber_endh=modelnumber_endh_ms_mdot4_lbvstd,tauh=tauh_ms_mdot4_lbvstd,$
                                    tstart_he=tstart_he_ms_mdot4_lbvstd,tend_he=tend_he_ms_mdot4_lbvstd,modelnumber_start_he=modelnumber_start_he_ms_mdot4_lbvstd,modelnumber_end_he=modelnumber_end_he_ms_mdot4_lbvstd,tau_he=tau_he_ms_mdot4_lbvstd,$
                                    tstartc=tstartc_ms_mdot4_lbvstd,tendc=tendc_ms_mdot4_lbvstd,modelnumber_startc=modelnumber_startc_ms_mdot4_lbvstd,modelnumber_endc=modelnumber_endc_ms_mdot4_lbvstd,tauc=tauc_ms_mdot4_lbvstd,$
                                    tstarto=tstarto_ms_mdot4_lbvstd,tendo=tendo_ms_mdot4_lbvstd,modelnumber_starto=modelnumber_starto_ms_mdot4_lbvstd,modelnumber_endo=modelnumber_endo_ms_mdot4_lbvstd,tauo=tauo_ms_mdot4_lbvstd,$
                                    tstartne=tstartne_ms_mdot4_lbvstd,tendne=tendne_ms_mdot4_lbvstd,modelnumber_startne=modelnumber_startne_ms_mdot4_lbvstd,modelnumber_endne=modelnumber_endne_ms_mdot4_lbvstd,taune=taune
;ZE_EVOL_COMPUTE_H_HE_MASS_ALL_TIMESTEPS,model,h1_mass_ms_mdot4_lbvstd,he4_mass_ms_mdot4_lbvstd,timesteps_available_ms_mdot4_lbvstd,modeldir=dir

;MS 1/4, LBV 1, WR 2
dir='/Users/jgroh/evol_models/tes/P060z14S0_ms_mdot4_lbvstd_wr_2x/'
model='P060z14S0_ms_mdot4_lbvstd_wr_2x'
wgfile=dir+model+'.wg' ;assumes model is in wg directory
timestep_ini=49
ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload,timestep_ini=timestep_ini
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60_ms_mdot4_lbvstd_wr_2x,logg60_ms_mdot4_lbvstd_wr_2x,vesc60_ms_mdot4_lbvstd_wr_2x,vinf60_ms_mdot4_lbvstd_wr_2x,eta_star60_ms_mdot4_lbvstd_wr_2x,Bmin60_ms_mdot4_lbvstd_wr_2x,Jdot60_ms_mdot4_lbvstd_wr_2x,logg_rphot60_ms_mdot4_lbvstd_wr_2x,rphot60_ms_mdot4_lbvstd_wr_2x,beq60_ms_mdot4_lbvstd_wr_2x,beta60_ms_mdot4_lbvstd_wr_2x,ekin60_ms_mdot4_lbvstd_wr_2x,model=model,logtcollapse=logtcollapse60_ms_mdot4_lbvstd_wr_2x
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'nm',data_wgfile_cut,nm60_ms_mdot4_lbvstd_wr_2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u160_ms_mdot4_lbvstd_wr_2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u2',data_wgfile_cut,u260_ms_mdot4_lbvstd_wr_2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt60_ms_mdot4_lbvstd_wr_2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl60_ms_mdot4_lbvstd_wr_2x,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u560_ms_mdot4_lbvstd_wr_2x,return_valz    ;X surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u7',data_wgfile_cut,u760_ms_mdot4_lbvstd_wr_2x,return_valz    ;Y surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u860_ms_mdot4_lbvstd_wr_2x,return_valz    ;C surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1060_ms_mdot4_lbvstd_wr_2x,return_valz  ; N surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u1260_ms_mdot4_lbvstd_wr_2x,return_valz   ; O surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u6',data_wgfile_cut,u660_ms_mdot4_lbvstd_wr_2x,return_valz   ; Ne surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u15',data_wgfile_cut,u1560_ms_mdot4_lbvstd_wr_2x,return_valz    ;X center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u17',data_wgfile_cut,u1760_ms_mdot4_lbvstd_wr_2x,return_valz    ;Y center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,u1860_ms_mdot4_lbvstd_wr_2x,return_valz    ;C center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u20',data_wgfile_cut,u2060_ms_mdot4_lbvstd_wr_2x,return_valz  ; N center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u22',data_wgfile_cut,u2260_ms_mdot4_lbvstd_wr_2x,return_valz   ; O center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u16',data_wgfile_cut,u1660_ms_mdot4_lbvstd_wr_2x,return_valz   ; Ne center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot60_ms_mdot4_lbvstd_wr_2x,return_valz  
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte60_ms_mdot4_lbvstd_wr_2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesm',data_wgfile_cut,eddesm60_ms_mdot4_lbvstd_wr_2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc60_ms_mdot4_lbvstd_wr_2x,index_varnamex_wgfile,return_valx

ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth_ms_mdot4_lbvstd_wr_2x,tendh=tendh_ms_mdot4_lbvstd_wr_2x,modelnumber_starth=modelnumber_starth_ms_mdot4_lbvstd_wr_2x,modelnumber_endh=modelnumber_endh_ms_mdot4_lbvstd_wr_2x,tauh=tauh_ms_mdot4_lbvstd_wr_2x,$
                                    tstart_he=tstart_he_ms_mdot4_lbvstd_wr_2x,tend_he=tend_he_ms_mdot4_lbvstd_wr_2x,modelnumber_start_he=modelnumber_start_he_ms_mdot4_lbvstd_wr_2x,modelnumber_end_he=modelnumber_end_he_ms_mdot4_lbvstd_wr_2x,tau_he=tau_he_ms_mdot4_lbvstd_wr_2x,$
                                    tstartc=tstartc_ms_mdot4_lbvstd_wr_2x,tendc=tendc_ms_mdot4_lbvstd_wr_2x,modelnumber_startc=modelnumber_startc_ms_mdot4_lbvstd_wr_2x,modelnumber_endc=modelnumber_endc_ms_mdot4_lbvstd_wr_2x,tauc=tauc_ms_mdot4_lbvstd_wr_2x,$
                                    tstarto=tstarto_ms_mdot4_lbvstd_wr_2x,tendo=tendo_ms_mdot4_lbvstd_wr_2x,modelnumber_starto=modelnumber_starto_ms_mdot4_lbvstd_wr_2x,modelnumber_endo=modelnumber_endo_ms_mdot4_lbvstd_wr_2x,tauo=tauo_ms_mdot4_lbvstd_wr_2x,$
                                    tstartne=tstartne_ms_mdot4_lbvstd_wr_2x,tendne=tendne_ms_mdot4_lbvstd_wr_2x,modelnumber_startne=modelnumber_startne_ms_mdot4_lbvstd_wr_2x,modelnumber_endne=modelnumber_endne_ms_mdot4_lbvstd_wr_2x,taune=taune

;MS 1/4, LBV 10, WR 1/2
dir='/Users/jgroh/evol_models/tes/P060z14S0_ms_mdot4_LBV10_wr0.5x/'
model='P060z14S0_ms_mdot4_LBV10_wr0.5x'
wgfile=dir+model+'.wg' ;assumes model is in wg directory
timestep_ini=49
ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload,timestep_ini=timestep_ini
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60_ms_mdot4_LBV10_wr0d5x,logg60_ms_mdot4_LBV10_wr0d5x,vesc60_ms_mdot4_LBV10_wr0d5x,vinf60_ms_mdot4_LBV10_wr0d5x,eta_star60_ms_mdot4_LBV10_wr0d5x,Bmin60_ms_mdot4_LBV10_wr0d5x,Jdot60_ms_mdot4_LBV10_wr0d5x,logg_rphot60_ms_mdot4_LBV10_wr0d5x,rphot60_ms_mdot4_LBV10_wr0d5x,beq60_ms_mdot4_LBV10_wr0d5x,beta60_ms_mdot4_LBV10_wr0d5x,ekin60_ms_mdot4_LBV10_wr0d5x,model=model,logtcollapse=logtcollapse60_ms_mdot4_LBV10_wr0d5x
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'nm',data_wgfile_cut,nm60_ms_mdot4_LBV10_wr0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u160_ms_mdot4_LBV10_wr0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u2',data_wgfile_cut,u260_ms_mdot4_LBV10_wr0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt60_ms_mdot4_LBV10_wr0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl60_ms_mdot4_LBV10_wr0d5x,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u560_ms_mdot4_LBV10_wr0d5x,return_valz    ;X surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u7',data_wgfile_cut,u760_ms_mdot4_LBV10_wr0d5x,return_valz    ;Y surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u860_ms_mdot4_LBV10_wr0d5x,return_valz    ;C surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1060_ms_mdot4_LBV10_wr0d5x,return_valz  ; N surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u1260_ms_mdot4_LBV10_wr0d5x,return_valz   ; O surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u6',data_wgfile_cut,u660_ms_mdot4_LBV10_wr0d5x,return_valz   ; Ne surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u15',data_wgfile_cut,u1560_ms_mdot4_LBV10_wr0d5x,return_valz    ;X center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u17',data_wgfile_cut,u1760_ms_mdot4_LBV10_wr0d5x,return_valz    ;Y center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,u1860_ms_mdot4_LBV10_wr0d5x,return_valz    ;C center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u20',data_wgfile_cut,u2060_ms_mdot4_LBV10_wr0d5x,return_valz  ; N center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u22',data_wgfile_cut,u2260_ms_mdot4_LBV10_wr0d5x,return_valz   ; O center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u16',data_wgfile_cut,u1660_ms_mdot4_LBV10_wr0d5x,return_valz   ; Ne center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot60_ms_mdot4_LBV10_wr0d5x,return_valz  
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte60_ms_mdot4_LBV10_wr0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesm',data_wgfile_cut,eddesm60_ms_mdot4_LBV10_wr0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc60_ms_mdot4_LBV10_wr0d5x,index_varnamex_wgfile,return_valx

ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth_ms_mdot4_LBV10_wr0d5x,tendh=tendh_ms_mdot4_LBV10_wr0d5x,modelnumber_starth=modelnumber_starth_ms_mdot4_LBV10_wr0d5x,modelnumber_endh=modelnumber_endh_ms_mdot4_LBV10_wr0d5x,tauh=tauh_ms_mdot4_LBV10_wr0d5x,$
                                    tstart_he=tstart_he_ms_mdot4_LBV10_wr0d5x,tend_he=tend_he_ms_mdot4_LBV10_wr0d5x,modelnumber_start_he=modelnumber_start_he_ms_mdot4_LBV10_wr0d5x,modelnumber_end_he=modelnumber_end_he_ms_mdot4_LBV10_wr0d5x,tau_he=tau_he_ms_mdot4_LBV10_wr0d5x,$
                                    tstartc=tstartc_ms_mdot4_LBV10_wr0d5x,tendc=tendc_ms_mdot4_LBV10_wr0d5x,modelnumber_startc=modelnumber_startc_ms_mdot4_LBV10_wr0d5x,modelnumber_endc=modelnumber_endc_ms_mdot4_LBV10_wr0d5x,tauc=tauc_ms_mdot4_LBV10_wr0d5x,$
                                    tstarto=tstarto_ms_mdot4_LBV10_wr0d5x,tendo=tendo_ms_mdot4_LBV10_wr0d5x,modelnumber_starto=modelnumber_starto_ms_mdot4_LBV10_wr0d5x,modelnumber_endo=modelnumber_endo_ms_mdot4_LBV10_wr0d5x,tauo=tauo_ms_mdot4_LBV10_wr0d5x,$
                                    tstartne=tstartne_ms_mdot4_LBV10_wr0d5x,tendne=tendne_ms_mdot4_LBV10_wr0d5x,modelnumber_startne=modelnumber_startne_ms_mdot4_LBV10_wr0d5x,modelnumber_endne=modelnumber_endne_ms_mdot4_LBV10_wr0d5x,taune=taune

;MS 1/4, LBV 10, WR 1
dir='/Users/jgroh/evol_models/tes/P060z14S0_ms_mdot4_LBV10_wr1x/'
model='P060z14S0_ms_mdot4_LBV10_wr1x'
wgfile=dir+model+'.wg' ;assumes model is in wg directory
timestep_ini=49
ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload,timestep_ini=timestep_ini
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60_ms_mdot4_LBV10_wr1x,logg60_ms_mdot4_LBV10_wr1x,vesc60_ms_mdot4_LBV10_wr1x,vinf60_ms_mdot4_LBV10_wr1x,eta_star60_ms_mdot4_LBV10_wr1x,Bmin60_ms_mdot4_LBV10_wr1x,Jdot60_ms_mdot4_LBV10_wr1x,logg_rphot60_ms_mdot4_LBV10_wr1x,rphot60_ms_mdot4_LBV10_wr1x,beq60_ms_mdot4_LBV10_wr1x,beta60_ms_mdot4_LBV10_wr1x,ekin60_ms_mdot4_LBV10_wr1x,model=model,logtcollapse=logtcollapse60_ms_mdot4_LBV10_wr1x
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'nm',data_wgfile_cut,nm60_ms_mdot4_LBV10_wr1x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u160_ms_mdot4_LBV10_wr1x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u2',data_wgfile_cut,u260_ms_mdot4_LBV10_wr1x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt60_ms_mdot4_LBV10_wr1x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl60_ms_mdot4_LBV10_wr1x,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u560_ms_mdot4_LBV10_wr1x,return_valz    ;X surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u7',data_wgfile_cut,u760_ms_mdot4_LBV10_wr1x,return_valz    ;Y surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u860_ms_mdot4_LBV10_wr1x,return_valz    ;C surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1060_ms_mdot4_LBV10_wr1x,return_valz  ; N surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u1260_ms_mdot4_LBV10_wr1x,return_valz   ; O surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u6',data_wgfile_cut,u660_ms_mdot4_LBV10_wr1x,return_valz   ; Ne surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u15',data_wgfile_cut,u1560_ms_mdot4_LBV10_wr1x,return_valz    ;X center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u17',data_wgfile_cut,u1760_ms_mdot4_LBV10_wr1x,return_valz    ;Y center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,u1860_ms_mdot4_LBV10_wr1x,return_valz    ;C center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u20',data_wgfile_cut,u2060_ms_mdot4_LBV10_wr1x,return_valz  ; N center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u22',data_wgfile_cut,u2260_ms_mdot4_LBV10_wr1x,return_valz   ; O center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u16',data_wgfile_cut,u1660_ms_mdot4_LBV10_wr1x,return_valz   ; Ne center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot60_ms_mdot4_LBV10_wr1x,return_valz  
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte60_ms_mdot4_LBV10_wr1x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesm',data_wgfile_cut,eddesm60_ms_mdot4_LBV10_wr1x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc60_ms_mdot4_LBV10_wr1x,index_varnamex_wgfile,return_valx

ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth_ms_mdot4_LBV10_wr1x,tendh=tendh_ms_mdot4_LBV10_wr1x,modelnumber_starth=modelnumber_starth_ms_mdot4_LBV10_wr1x,modelnumber_endh=modelnumber_endh_ms_mdot4_LBV10_wr1x,tauh=tauh_ms_mdot4_LBV10_wr1x,$
                                    tstart_he=tstart_he_ms_mdot4_LBV10_wr1x,tend_he=tend_he_ms_mdot4_LBV10_wr1x,modelnumber_start_he=modelnumber_start_he_ms_mdot4_LBV10_wr1x,modelnumber_end_he=modelnumber_end_he_ms_mdot4_LBV10_wr1x,tau_he=tau_he_ms_mdot4_LBV10_wr1x,$
                                    tstartc=tstartc_ms_mdot4_LBV10_wr1x,tendc=tendc_ms_mdot4_LBV10_wr1x,modelnumber_startc=modelnumber_startc_ms_mdot4_LBV10_wr1x,modelnumber_endc=modelnumber_endc_ms_mdot4_LBV10_wr1x,tauc=tauc_ms_mdot4_LBV10_wr1x,$
                                    tstarto=tstarto_ms_mdot4_LBV10_wr1x,tendo=tendo_ms_mdot4_LBV10_wr1x,modelnumber_starto=modelnumber_starto_ms_mdot4_LBV10_wr1x,modelnumber_endo=modelnumber_endo_ms_mdot4_LBV10_wr1x,tauo=tauo_ms_mdot4_LBV10_wr1x,$
                                    tstartne=tstartne_ms_mdot4_LBV10_wr1x,tendne=tendne_ms_mdot4_LBV10_wr1x,modelnumber_startne=modelnumber_startne_ms_mdot4_LBV10_wr1x,modelnumber_endne=modelnumber_endne_ms_mdot4_LBV10_wr1x,taune=taune

;MS 1, LBV 10, WR 2
dir='/Users/jgroh/evol_models/tes/P060z14S0_ms_mdot4_LBV10_wr2x/'
model='P060z14S0_ms_mdot4_LBV10_wr2x'
wgfile=dir+model+'.wg' ;assumes model is in wg directory
timestep_ini=49
ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload,timestep_ini=timestep_ini
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60_ms_mdot4_LBV10_wr2x,logg60_ms_mdot4_LBV10_wr2x,vesc60_ms_mdot4_LBV10_wr2x,vinf60_ms_mdot4_LBV10_wr2x,eta_star60_ms_mdot4_LBV10_wr2x,Bmin60_ms_mdot4_LBV10_wr2x,Jdot60_ms_mdot4_LBV10_wr2x,logg_rphot60_ms_mdot4_LBV10_wr2x,rphot60_ms_mdot4_LBV10_wr2x,beq60_ms_mdot4_LBV10_wr2x,beta60_ms_mdot4_LBV10_wr2x,ekin60_ms_mdot4_LBV10_wr2x,model=model,logtcollapse=logtcollapse60_ms_mdot4_LBV10_wr2x
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'nm',data_wgfile_cut,nm60_ms_mdot4_LBV10_wr2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u160_ms_mdot4_LBV10_wr2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u2',data_wgfile_cut,u260_ms_mdot4_LBV10_wr2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt60_ms_mdot4_LBV10_wr2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl60_ms_mdot4_LBV10_wr2x,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u560_ms_mdot4_LBV10_wr2x,return_valz    ;X surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u7',data_wgfile_cut,u760_ms_mdot4_LBV10_wr2x,return_valz    ;Y surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u860_ms_mdot4_LBV10_wr2x,return_valz    ;C surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1060_ms_mdot4_LBV10_wr2x,return_valz  ; N surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u1260_ms_mdot4_LBV10_wr2x,return_valz   ; O surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u6',data_wgfile_cut,u660_ms_mdot4_LBV10_wr2x,return_valz   ; Ne surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u15',data_wgfile_cut,u1560_ms_mdot4_LBV10_wr2x,return_valz    ;X center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u17',data_wgfile_cut,u1760_ms_mdot4_LBV10_wr2x,return_valz    ;Y center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,u1860_ms_mdot4_LBV10_wr2x,return_valz    ;C center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u20',data_wgfile_cut,u2060_ms_mdot4_LBV10_wr2x,return_valz  ; N center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u22',data_wgfile_cut,u2260_ms_mdot4_LBV10_wr2x,return_valz   ; O center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u16',data_wgfile_cut,u1660_ms_mdot4_LBV10_wr2x,return_valz   ; Ne center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot60_ms_mdot4_LBV10_wr2x,return_valz  
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte60_ms_mdot4_LBV10_wr2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesm',data_wgfile_cut,eddesm60_ms_mdot4_LBV10_wr2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc60_ms_mdot4_LBV10_wr2x,index_varnamex_wgfile,return_valx

ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth_ms_mdot4_LBV10_wr2x,tendh=tendh_ms_mdot4_LBV10_wr2x,modelnumber_starth=modelnumber_starth_ms_mdot4_LBV10_wr2x,modelnumber_endh=modelnumber_endh_ms_mdot4_LBV10_wr2x,tauh=tauh_ms_mdot4_LBV10_wr2x,$
                                    tstart_he=tstart_he_ms_mdot4_LBV10_wr2x,tend_he=tend_he_ms_mdot4_LBV10_wr2x,modelnumber_start_he=modelnumber_start_he_ms_mdot4_LBV10_wr2x,modelnumber_end_he=modelnumber_end_he_ms_mdot4_LBV10_wr2x,tau_he=tau_he_ms_mdot4_LBV10_wr2x,$
                                    tstartc=tstartc_ms_mdot4_LBV10_wr2x,tendc=tendc_ms_mdot4_LBV10_wr2x,modelnumber_startc=modelnumber_startc_ms_mdot4_LBV10_wr2x,modelnumber_endc=modelnumber_endc_ms_mdot4_LBV10_wr2x,tauc=tauc_ms_mdot4_LBV10_wr2x,$
                                    tstarto=tstarto_ms_mdot4_LBV10_wr2x,tendo=tendo_ms_mdot4_LBV10_wr2x,modelnumber_starto=modelnumber_starto_ms_mdot4_LBV10_wr2x,modelnumber_endo=modelnumber_endo_ms_mdot4_LBV10_wr2x,tauo=tauo_ms_mdot4_LBV10_wr2x,$
                                    tstartne=tstartne_ms_mdot4_LBV10_wr2x,tendne=tendne_ms_mdot4_LBV10_wr2x,modelnumber_startne=modelnumber_startne_ms_mdot4_LBV10_wr2x,modelnumber_endne=modelnumber_endne_ms_mdot4_LBV10_wr2x,taune=taune

;MS 1, LBV 1/20, WR 1/2
dir='/Users/jgroh/evol_models/tes/P060z14S0_postms_5em5_wr0.5x/'
model='P060z14S0_postms_5em5_wr0.5x'
wgfile=dir+model+'.wg' ;assumes model is in wg directory
timestep_ini=49
ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload,timestep_ini=timestep_ini
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60_postms_5em5_wr0d5x,logg60_postms_5em5_wr0d5x,vesc60_postms_5em5_wr0d5x,vinf60_postms_5em5_wr0d5x,eta_star60_postms_5em5_wr0d5x,Bmin60_postms_5em5_wr0d5x,Jdot60_postms_5em5_wr0d5x,logg_rphot60_postms_5em5_wr0d5x,rphot60_postms_5em5_wr0d5x,beq60_postms_5em5_wr0d5x,beta60_postms_5em5_wr0d5x,ekin60_postms_5em5_wr0d5x,model=model,logtcollapse=logtcollapse60_postms_5em5_wr0d5x
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'nm',data_wgfile_cut,nm60_postms_5em5_wr0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u160_postms_5em5_wr0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u2',data_wgfile_cut,u260_postms_5em5_wr0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt60_postms_5em5_wr0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl60_postms_5em5_wr0d5x,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u560_postms_5em5_wr0d5x,return_valz    ;X surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u7',data_wgfile_cut,u760_postms_5em5_wr0d5x,return_valz    ;Y surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u860_postms_5em5_wr0d5x,return_valz    ;C surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1060_postms_5em5_wr0d5x,return_valz  ; N surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u1260_postms_5em5_wr0d5x,return_valz   ; O surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u6',data_wgfile_cut,u660_postms_5em5_wr0d5x,return_valz   ; Ne surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u15',data_wgfile_cut,u1560_postms_5em5_wr0d5x,return_valz    ;X center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u17',data_wgfile_cut,u1760_postms_5em5_wr0d5x,return_valz    ;Y center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,u1860_postms_5em5_wr0d5x,return_valz    ;C center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u20',data_wgfile_cut,u2060_postms_5em5_wr0d5x,return_valz  ; N center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u22',data_wgfile_cut,u2260_postms_5em5_wr0d5x,return_valz   ; O center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u16',data_wgfile_cut,u1660_postms_5em5_wr0d5x,return_valz   ; Ne center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot60_postms_5em5_wr0d5x,return_valz  
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte60_postms_5em5_wr0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesm',data_wgfile_cut,eddesm60_postms_5em5_wr0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc60_postms_5em5_wr0d5x,index_varnamex_wgfile,return_valx

ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth_postms_5em5_wr0d5x,tendh=tendh_postms_5em5_wr0d5x,modelnumber_starth=modelnumber_starth_postms_5em5_wr0d5x,modelnumber_endh=modelnumber_endh_postms_5em5_wr0d5x,tauh=tauh_postms_5em5_wr0d5x,$
                                    tstart_he=tstart_he_postms_5em5_wr0d5x,tend_he=tend_he_postms_5em5_wr0d5x,modelnumber_start_he=modelnumber_start_he_postms_5em5_wr0d5x,modelnumber_end_he=modelnumber_end_he_postms_5em5_wr0d5x,tau_he=tau_he_postms_5em5_wr0d5x,$
                                    tstartc=tstartc_postms_5em5_wr0d5x,tendc=tendc_postms_5em5_wr0d5x,modelnumber_startc=modelnumber_startc_postms_5em5_wr0d5x,modelnumber_endc=modelnumber_endc_postms_5em5_wr0d5x,tauc=tauc_postms_5em5_wr0d5x,$
                                    tstarto=tstarto_postms_5em5_wr0d5x,tendo=tendo_postms_5em5_wr0d5x,modelnumber_starto=modelnumber_starto_postms_5em5_wr0d5x,modelnumber_endo=modelnumber_endo_postms_5em5_wr0d5x,tauo=tauo_postms_5em5_wr0d5x,$
                                    tstartne=tstartne_postms_5em5_wr0d5x,tendne=tendne_postms_5em5_wr0d5x,modelnumber_startne=modelnumber_startne_postms_5em5_wr0d5x,modelnumber_endne=modelnumber_endne_postms_5em5_wr0d5x,taune=taune

;MS 1, LBV 1/20, WR 1
dir='/Users/jgroh/evol_models/tes/P060z14S0_postms_5em5_wr1x/'
model='P060z14S0_postms_5em5_wr1x'
wgfile=dir+model+'.wg' ;assumes model is in wg directory
timestep_ini=49
ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload,timestep_ini=timestep_ini
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60_postms_5em5_wr1x,logg60_postms_5em5_wr1x,vesc60_postms_5em5_wr1x,vinf60_postms_5em5_wr1x,eta_star60_postms_5em5_wr1x,Bmin60_postms_5em5_wr1x,Jdot60_postms_5em5_wr1x,logg_rphot60_postms_5em5_wr1x,rphot60_postms_5em5_wr1x,beq60_postms_5em5_wr1x,beta60_postms_5em5_wr1x,ekin60_postms_5em5_wr1x,model=model,logtcollapse=logtcollapse60_postms_5em5_wr1x
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'nm',data_wgfile_cut,nm60_postms_5em5_wr1x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u160_postms_5em5_wr1x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u2',data_wgfile_cut,u260_postms_5em5_wr1x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt60_postms_5em5_wr1x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl60_postms_5em5_wr1x,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u560_postms_5em5_wr1x,return_valz    ;X surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u7',data_wgfile_cut,u760_postms_5em5_wr1x,return_valz    ;Y surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u860_postms_5em5_wr1x,return_valz    ;C surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1060_postms_5em5_wr1x,return_valz  ; N surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u1260_postms_5em5_wr1x,return_valz   ; O surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u6',data_wgfile_cut,u660_postms_5em5_wr1x,return_valz   ; Ne surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u15',data_wgfile_cut,u1560_postms_5em5_wr1x,return_valz    ;X center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u17',data_wgfile_cut,u1760_postms_5em5_wr1x,return_valz    ;Y center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,u1860_postms_5em5_wr1x,return_valz    ;C center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u20',data_wgfile_cut,u2060_postms_5em5_wr1x,return_valz  ; N center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u22',data_wgfile_cut,u2260_postms_5em5_wr1x,return_valz   ; O center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u16',data_wgfile_cut,u1660_postms_5em5_wr1x,return_valz   ; Ne center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot60_postms_5em5_wr1x,return_valz  
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte60_postms_5em5_wr1x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesm',data_wgfile_cut,eddesm60_postms_5em5_wr1x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc60_postms_5em5_wr1x,index_varnamex_wgfile,return_valx

ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth_postms_5em5_wr1x,tendh=tendh_postms_5em5_wr1x,modelnumber_starth=modelnumber_starth_postms_5em5_wr1x,modelnumber_endh=modelnumber_endh_postms_5em5_wr1x,tauh=tauh_postms_5em5_wr1x,$
                                    tstart_he=tstart_he_postms_5em5_wr1x,tend_he=tend_he_postms_5em5_wr1x,modelnumber_start_he=modelnumber_start_he_postms_5em5_wr1x,modelnumber_end_he=modelnumber_end_he_postms_5em5_wr1x,tau_he=tau_he_postms_5em5_wr1x,$
                                    tstartc=tstartc_postms_5em5_wr1x,tendc=tendc_postms_5em5_wr1x,modelnumber_startc=modelnumber_startc_postms_5em5_wr1x,modelnumber_endc=modelnumber_endc_postms_5em5_wr1x,tauc=tauc_postms_5em5_wr1x,$
                                    tstarto=tstarto_postms_5em5_wr1x,tendo=tendo_postms_5em5_wr1x,modelnumber_starto=modelnumber_starto_postms_5em5_wr1x,modelnumber_endo=modelnumber_endo_postms_5em5_wr1x,tauo=tauo_postms_5em5_wr1x,$
                                    tstartne=tstartne_postms_5em5_wr1x,tendne=tendne_postms_5em5_wr1x,modelnumber_startne=modelnumber_startne_postms_5em5_wr1x,modelnumber_endne=modelnumber_endne_postms_5em5_wr1x,taune=taune

;MS 1, LBV 1/20, WR 2
dir='/Users/jgroh/evol_models/tes/P060z14S0_postms_5em5_wr2x/'
model='P060z14S0_postms_5em5_wr2x'
wgfile=dir+model+'.wg' ;assumes model is in wg directory
timestep_ini=49
ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload,timestep_ini=timestep_ini
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60_postms_5em5_wr2x,logg60_postms_5em5_wr2x,vesc60_postms_5em5_wr2x,vinf60_postms_5em5_wr2x,eta_star60_postms_5em5_wr2x,Bmin60_postms_5em5_wr2x,Jdot60_postms_5em5_wr2x,logg_rphot60_postms_5em5_wr2x,rphot60_postms_5em5_wr2x,beq60_postms_5em5_wr2x,beta60_postms_5em5_wr2x,ekin60_postms_5em5_wr2x,model=model,logtcollapse=logtcollapse60_postms_5em5_wr2x
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'nm',data_wgfile_cut,nm60_postms_5em5_wr2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u160_postms_5em5_wr2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u2',data_wgfile_cut,u260_postms_5em5_wr2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt60_postms_5em5_wr2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl60_postms_5em5_wr2x,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u560_postms_5em5_wr2x,return_valz    ;X surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u7',data_wgfile_cut,u760_postms_5em5_wr2x,return_valz    ;Y surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u860_postms_5em5_wr2x,return_valz    ;C surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1060_postms_5em5_wr2x,return_valz  ; N surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u1260_postms_5em5_wr2x,return_valz   ; O surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u6',data_wgfile_cut,u660_postms_5em5_wr2x,return_valz   ; Ne surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u15',data_wgfile_cut,u1560_postms_5em5_wr2x,return_valz    ;X center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u17',data_wgfile_cut,u1760_postms_5em5_wr2x,return_valz    ;Y center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,u1860_postms_5em5_wr2x,return_valz    ;C center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u20',data_wgfile_cut,u2060_postms_5em5_wr2x,return_valz  ; N center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u22',data_wgfile_cut,u2260_postms_5em5_wr2x,return_valz   ; O center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u16',data_wgfile_cut,u1660_postms_5em5_wr2x,return_valz   ; Ne center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot60_postms_5em5_wr2x,return_valz  
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte60_postms_5em5_wr2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesm',data_wgfile_cut,eddesm60_postms_5em5_wr2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc60_postms_5em5_wr2x,index_varnamex_wgfile,return_valx

ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth_postms_5em5_wr2x,tendh=tendh_postms_5em5_wr2x,modelnumber_starth=modelnumber_starth_postms_5em5_wr2x,modelnumber_endh=modelnumber_endh_postms_5em5_wr2x,tauh=tauh_postms_5em5_wr2x,$
                                    tstart_he=tstart_he_postms_5em5_wr2x,tend_he=tend_he_postms_5em5_wr2x,modelnumber_start_he=modelnumber_start_he_postms_5em5_wr2x,modelnumber_end_he=modelnumber_end_he_postms_5em5_wr2x,tau_he=tau_he_postms_5em5_wr2x,$
                                    tstartc=tstartc_postms_5em5_wr2x,tendc=tendc_postms_5em5_wr2x,modelnumber_startc=modelnumber_startc_postms_5em5_wr2x,modelnumber_endc=modelnumber_endc_postms_5em5_wr2x,tauc=tauc_postms_5em5_wr2x,$
                                    tstarto=tstarto_postms_5em5_wr2x,tendo=tendo_postms_5em5_wr2x,modelnumber_starto=modelnumber_starto_postms_5em5_wr2x,modelnumber_endo=modelnumber_endo_postms_5em5_wr2x,tauo=tauo_postms_5em5_wr2x,$
                                    tstartne=tstartne_postms_5em5_wr2x,tendne=tendne_postms_5em5_wr2x,modelnumber_startne=modelnumber_startne_postms_5em5_wr2x,modelnumber_endne=modelnumber_endne_postms_5em5_wr2x,taune=taune

;MS 1, LBV 1, WR 1/2
dir='/Users/jgroh/evol_models/tes/P060z14S0_LBV1_wr0.5x/'
model='P060z14S0_LBV1_wr0.5x'
wgfile=dir+model+'.wg' ;assumes model is in wg directory
timestep_ini=49
ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload,timestep_ini=timestep_ini
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60_LBV1_wr0d5x,logg60_LBV1_wr0d5x,vesc60_LBV1_wr0d5x,vinf60_LBV1_wr0d5x,eta_star60_LBV1_wr0d5x,Bmin60_LBV1_wr0d5x,Jdot60_LBV1_wr0d5x,logg_rphot60_LBV1_wr0d5x,rphot60_LBV1_wr0d5x,beq60_LBV1_wr0d5x,beta60_LBV1_wr0d5x,ekin60_LBV1_wr0d5x,model=model,logtcollapse=logtcollapse60_LBV1_wr0d5x
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'nm',data_wgfile_cut,nm60_LBV1_wr0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u160_LBV1_wr0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u2',data_wgfile_cut,u260_LBV1_wr0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt60_LBV1_wr0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl60_LBV1_wr0d5x,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u560_LBV1_wr0d5x,return_valz    ;X surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u7',data_wgfile_cut,u760_LBV1_wr0d5x,return_valz    ;Y surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u860_LBV1_wr0d5x,return_valz    ;C surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1060_LBV1_wr0d5x,return_valz  ; N surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u1260_LBV1_wr0d5x,return_valz   ; O surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u6',data_wgfile_cut,u660_LBV1_wr0d5x,return_valz   ; Ne surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u15',data_wgfile_cut,u1560_LBV1_wr0d5x,return_valz    ;X center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u17',data_wgfile_cut,u1760_LBV1_wr0d5x,return_valz    ;Y center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,u1860_LBV1_wr0d5x,return_valz    ;C center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u20',data_wgfile_cut,u2060_LBV1_wr0d5x,return_valz  ; N center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u22',data_wgfile_cut,u2260_LBV1_wr0d5x,return_valz   ; O center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u16',data_wgfile_cut,u1660_LBV1_wr0d5x,return_valz   ; Ne center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot60_LBV1_wr0d5x,return_valz  
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte60_LBV1_wr0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesm',data_wgfile_cut,eddesm60_LBV1_wr0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc60_LBV1_wr0d5x,index_varnamex_wgfile,return_valx

ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth_LBV1_wr0d5x,tendh=tendh_LBV1_wr0d5x,modelnumber_starth=modelnumber_starth_LBV1_wr0d5x,modelnumber_endh=modelnumber_endh_LBV1_wr0d5x,tauh=tauh_LBV1_wr0d5x,$
                                    tstart_he=tstart_he_LBV1_wr0d5x,tend_he=tend_he_LBV1_wr0d5x,modelnumber_start_he=modelnumber_start_he_LBV1_wr0d5x,modelnumber_end_he=modelnumber_end_he_LBV1_wr0d5x,tau_he=tau_he_LBV1_wr0d5x,$
                                    tstartc=tstartc_LBV1_wr0d5x,tendc=tendc_LBV1_wr0d5x,modelnumber_startc=modelnumber_startc_LBV1_wr0d5x,modelnumber_endc=modelnumber_endc_LBV1_wr0d5x,tauc=tauc_LBV1_wr0d5x,$
                                    tstarto=tstarto_LBV1_wr0d5x,tendo=tendo_LBV1_wr0d5x,modelnumber_starto=modelnumber_starto_LBV1_wr0d5x,modelnumber_endo=modelnumber_endo_LBV1_wr0d5x,tauo=tauo_LBV1_wr0d5x,$
                                    tstartne=tstartne_LBV1_wr0d5x,tendne=tendne_LBV1_wr0d5x,modelnumber_startne=modelnumber_startne_LBV1_wr0d5x,modelnumber_endne=modelnumber_endne_LBV1_wr0d5x,taune=taune


;MS1, LBV1, WR1 standard 60 Msun model from 2012 grid
dir='/Users/jgroh/evol_models/Grids2010/wg/'
model='P060z14S0'
wgfile=dir+model+'.wg' ;assumes model is in wg directory
timestep_ini=49
ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload,timestep_ini=timestep_ini
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60,logg60,vesc60,vinf60,eta_star60,Bmin60,Jdot60,logg_rphot60,rphot60,beq60,beta60,ekin60,model=model,logtcollapse=logtcollapse60
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'nm',data_wgfile_cut,nm60,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u160,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u2',data_wgfile_cut,u260,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt60,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl60,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u560,return_valz    ;X surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u7',data_wgfile_cut,u760,return_valz    ;Y surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u860,return_valz    ;C surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1060,return_valz  ; N surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u1260,return_valz   ; O surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u6',data_wgfile_cut,u660,return_valz   ; Ne surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u15',data_wgfile_cut,u1560,return_valz    ;X center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u17',data_wgfile_cut,u1760,return_valz    ;Y center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,u1860,return_valz    ;C center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u20',data_wgfile_cut,u2060,return_valz  ; N center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u22',data_wgfile_cut,u2260,return_valz   ; O center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u16',data_wgfile_cut,u1660,return_valz   ; Ne center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot60,return_valz  
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte60,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesm',data_wgfile_cut,eddesm60,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc60,index_varnamex_wgfile,return_valx

ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth60,tendh=tendh60,modelnumber_starth=modelnumber_starth60,modelnumber_endh=modelnumber_endh60,tauh=tauh60,$
                                    tstart_he=tstart_he60,tend_he=tend_he60,modelnumber_start_he=modelnumber_start_he60,modelnumber_end_he=modelnumber_end_he60,tau_he=tau_he60,$
                                    tstartc=tstartc60,tendc=tendc60,modelnumber_startc=modelnumber_startc60,modelnumber_endc=modelnumber_endc60,tauc=tauc60,$
                                    tstarto=tstarto60,tendo=tendo60,modelnumber_starto=modelnumber_starto60,modelnumber_endo=modelnumber_endo60,tauo=tauo60,$
                                    tstartne=tstartne60,tendne=tendne60,modelnumber_startne=modelnumber_startne60,modelnumber_endne=modelnumber_endne60,taune=taune

;MS 1, LBV 1, WR 2
dir='/Users/jgroh/evol_models/tes/P060z14S0_LBV1_wr2x/'
model='P060z14S0_LBV1_wr2x'
wgfile=dir+model+'.wg' ;assumes model is in wg directory
timestep_ini=49
ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload,timestep_ini=timestep_ini
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60_LBV1_wr2x,logg60_LBV1_wr2x,vesc60_LBV1_wr2x,vinf60_LBV1_wr2x,eta_star60_LBV1_wr2x,Bmin60_LBV1_wr2x,Jdot60_LBV1_wr2x,logg_rphot60_LBV1_wr2x,rphot60_LBV1_wr2x,beq60_LBV1_wr2x,beta60_LBV1_wr2x,ekin60_LBV1_wr2x,model=model,logtcollapse=logtcollapse60_LBV1_wr2x
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'nm',data_wgfile_cut,nm60_LBV1_wr2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u160_LBV1_wr2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u2',data_wgfile_cut,u260_LBV1_wr2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt60_LBV1_wr2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl60_LBV1_wr2x,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u560_LBV1_wr2x,return_valz    ;X surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u7',data_wgfile_cut,u760_LBV1_wr2x,return_valz    ;Y surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u860_LBV1_wr2x,return_valz    ;C surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1060_LBV1_wr2x,return_valz  ; N surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u1260_LBV1_wr2x,return_valz   ; O surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u6',data_wgfile_cut,u660_LBV1_wr2x,return_valz   ; Ne surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u15',data_wgfile_cut,u1560_LBV1_wr2x,return_valz    ;X center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u17',data_wgfile_cut,u1760_LBV1_wr2x,return_valz    ;Y center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,u1860_LBV1_wr2x,return_valz    ;C center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u20',data_wgfile_cut,u2060_LBV1_wr2x,return_valz  ; N center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u22',data_wgfile_cut,u2260_LBV1_wr2x,return_valz   ; O center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u16',data_wgfile_cut,u1660_LBV1_wr2x,return_valz   ; Ne center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot60_LBV1_wr2x,return_valz  
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte60_LBV1_wr2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesm',data_wgfile_cut,eddesm60_LBV1_wr2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc60_LBV1_wr2x,index_varnamex_wgfile,return_valx

ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth_LBV1_wr2x,tendh=tendh_LBV1_wr2x,modelnumber_starth=modelnumber_starth_LBV1_wr2x,modelnumber_endh=modelnumber_endh_LBV1_wr2x,tauh=tauh_LBV1_wr2x,$
                                    tstart_he=tstart_he_LBV1_wr2x,tend_he=tend_he_LBV1_wr2x,modelnumber_start_he=modelnumber_start_he_LBV1_wr2x,modelnumber_end_he=modelnumber_end_he_LBV1_wr2x,tau_he=tau_he_LBV1_wr2x,$
                                    tstartc=tstartc_LBV1_wr2x,tendc=tendc_LBV1_wr2x,modelnumber_startc=modelnumber_startc_LBV1_wr2x,modelnumber_endc=modelnumber_endc_LBV1_wr2x,tauc=tauc_LBV1_wr2x,$
                                    tstarto=tstarto_LBV1_wr2x,tendo=tendo_LBV1_wr2x,modelnumber_starto=modelnumber_starto_LBV1_wr2x,modelnumber_endo=modelnumber_endo_LBV1_wr2x,tauo=tauo_LBV1_wr2x,$
                                    tstartne=tstartne_LBV1_wr2x,tendne=tendne_LBV1_wr2x,modelnumber_startne=modelnumber_startne_LBV1_wr2x,modelnumber_endne=modelnumber_endne_LBV1_wr2x,taune=taune

;MS 1, LBV 10, WR 1/2
dir='/Users/jgroh/evol_models/tes/P060z14S0_LBV10_wr0.5x/'
model='P060z14S0_LBV10_wr0.5x'
wgfile=dir+model+'.wg' ;assumes model is in wg directory
timestep_ini=49
ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload,timestep_ini=timestep_ini
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60_LBV10_wr0d5x,logg60_LBV10_wr0d5x,vesc60_LBV10_wr0d5x,vinf60_LBV10_wr0d5x,eta_star60_LBV10_wr0d5x,Bmin60_LBV10_wr0d5x,Jdot60_LBV10_wr0d5x,logg_rphot60_LBV10_wr0d5x,rphot60_LBV10_wr0d5x,beq60_LBV10_wr0d5x,beta60_LBV10_wr0d5x,ekin60_LBV10_wr0d5x,model=model,logtcollapse=logtcollapse60_LBV10_wr0d5x
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'nm',data_wgfile_cut,nm60_LBV10_wr0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u160_LBV10_wr0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u2',data_wgfile_cut,u260_LBV10_wr0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt60_LBV10_wr0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl60_LBV10_wr0d5x,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u560_LBV10_wr0d5x,return_valz    ;X surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u7',data_wgfile_cut,u760_LBV10_wr0d5x,return_valz    ;Y surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u860_LBV10_wr0d5x,return_valz    ;C surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1060_LBV10_wr0d5x,return_valz  ; N surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u1260_LBV10_wr0d5x,return_valz   ; O surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u6',data_wgfile_cut,u660_LBV10_wr0d5x,return_valz   ; Ne surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u15',data_wgfile_cut,u1560_LBV10_wr0d5x,return_valz    ;X center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u17',data_wgfile_cut,u1760_LBV10_wr0d5x,return_valz    ;Y center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,u1860_LBV10_wr0d5x,return_valz    ;C center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u20',data_wgfile_cut,u2060_LBV10_wr0d5x,return_valz  ; N center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u22',data_wgfile_cut,u2260_LBV10_wr0d5x,return_valz   ; O center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u16',data_wgfile_cut,u1660_LBV10_wr0d5x,return_valz   ; Ne center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot60_LBV10_wr0d5x,return_valz  
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte60_LBV10_wr0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesm',data_wgfile_cut,eddesm60_LBV10_wr0d5x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc60_LBV10_wr0d5x,index_varnamex_wgfile,return_valx

ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth_LBV10_wr0d5x,tendh=tendh_LBV10_wr0d5x,modelnumber_starth=modelnumber_starth_LBV10_wr0d5x,modelnumber_endh=modelnumber_endh_LBV10_wr0d5x,tauh=tauh_LBV10_wr0d5x,$
                                    tstart_he=tstart_he_LBV10_wr0d5x,tend_he=tend_he_LBV10_wr0d5x,modelnumber_start_he=modelnumber_start_he_LBV10_wr0d5x,modelnumber_end_he=modelnumber_end_he_LBV10_wr0d5x,tau_he=tau_he_LBV10_wr0d5x,$
                                    tstartc=tstartc_LBV10_wr0d5x,tendc=tendc_LBV10_wr0d5x,modelnumber_startc=modelnumber_startc_LBV10_wr0d5x,modelnumber_endc=modelnumber_endc_LBV10_wr0d5x,tauc=tauc_LBV10_wr0d5x,$
                                    tstarto=tstarto_LBV10_wr0d5x,tendo=tendo_LBV10_wr0d5x,modelnumber_starto=modelnumber_starto_LBV10_wr0d5x,modelnumber_endo=modelnumber_endo_LBV10_wr0d5x,tauo=tauo_LBV10_wr0d5x,$
                                    tstartne=tstartne_LBV10_wr0d5x,tendne=tendne_LBV10_wr0d5x,modelnumber_startne=modelnumber_startne_LBV10_wr0d5x,modelnumber_endne=modelnumber_endne_LBV10_wr0d5x,taune=taune

;MS 1, LBV 10, WR 1
dir='/Users/jgroh/evol_models/tes/P060z14S0_LBV10_wr1x/'
model='P060z14S0_LBV10_wr1x'
wgfile=dir+model+'.wg' ;assumes model is in wg directory
timestep_ini=49
ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload,timestep_ini=timestep_ini
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60_LBV10_wr1x,logg60_LBV10_wr1x,vesc60_LBV10_wr1x,vinf60_LBV10_wr1x,eta_star60_LBV10_wr1x,Bmin60_LBV10_wr1x,Jdot60_LBV10_wr1x,logg_rphot60_LBV10_wr1x,rphot60_LBV10_wr1x,beq60_LBV10_wr1x,beta60_LBV10_wr1x,ekin60_LBV10_wr1x,model=model,logtcollapse=logtcollapse60_LBV10_wr1x
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'nm',data_wgfile_cut,nm60_LBV10_wr1x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u160_LBV10_wr1x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u2',data_wgfile_cut,u260_LBV10_wr1x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt60_LBV10_wr1x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl60_LBV10_wr1x,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u560_LBV10_wr1x,return_valz    ;X surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u7',data_wgfile_cut,u760_LBV10_wr1x,return_valz    ;Y surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u860_LBV10_wr1x,return_valz    ;C surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1060_LBV10_wr1x,return_valz  ; N surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u1260_LBV10_wr1x,return_valz   ; O surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u6',data_wgfile_cut,u660_LBV10_wr1x,return_valz   ; Ne surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u15',data_wgfile_cut,u1560_LBV10_wr1x,return_valz    ;X center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u17',data_wgfile_cut,u1760_LBV10_wr1x,return_valz    ;Y center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,u1860_LBV10_wr1x,return_valz    ;C center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u20',data_wgfile_cut,u2060_LBV10_wr1x,return_valz  ; N center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u22',data_wgfile_cut,u2260_LBV10_wr1x,return_valz   ; O center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u16',data_wgfile_cut,u1660_LBV10_wr1x,return_valz   ; Ne center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot60_LBV10_wr1x,return_valz  
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte60_LBV10_wr1x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesm',data_wgfile_cut,eddesm60_LBV10_wr1x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc60_LBV10_wr1x,index_varnamex_wgfile,return_valx

ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth_LBV10_wr1x,tendh=tendh_LBV10_wr1x,modelnumber_starth=modelnumber_starth_LBV10_wr1x,modelnumber_endh=modelnumber_endh_LBV10_wr1x,tauh=tauh_LBV10_wr1x,$
                                    tstart_he=tstart_he_LBV10_wr1x,tend_he=tend_he_LBV10_wr1x,modelnumber_start_he=modelnumber_start_he_LBV10_wr1x,modelnumber_end_he=modelnumber_end_he_LBV10_wr1x,tau_he=tau_he_LBV10_wr1x,$
                                    tstartc=tstartc_LBV10_wr1x,tendc=tendc_LBV10_wr1x,modelnumber_startc=modelnumber_startc_LBV10_wr1x,modelnumber_endc=modelnumber_endc_LBV10_wr1x,tauc=tauc_LBV10_wr1x,$
                                    tstarto=tstarto_LBV10_wr1x,tendo=tendo_LBV10_wr1x,modelnumber_starto=modelnumber_starto_LBV10_wr1x,modelnumber_endo=modelnumber_endo_LBV10_wr1x,tauo=tauo_LBV10_wr1x,$
                                    tstartne=tstartne_LBV10_wr1x,tendne=tendne_LBV10_wr1x,modelnumber_startne=modelnumber_startne_LBV10_wr1x,modelnumber_endne=modelnumber_endne_LBV10_wr1x,taune=taune

;MS 1, LBV 10, WR 2
dir='/Users/jgroh/evol_models/tes/P060z14S0_LBV10_wr2x/'
model='P060z14S0_LBV10_wr2x'
wgfile=dir+model+'.wg' ;assumes model is in wg directory
timestep_ini=49
ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload,timestep_ini=timestep_ini
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60_LBV10_wr2x,logg60_LBV10_wr2x,vesc60_LBV10_wr2x,vinf60_LBV10_wr2x,eta_star60_LBV10_wr2x,Bmin60_LBV10_wr2x,Jdot60_LBV10_wr2x,logg_rphot60_LBV10_wr2x,rphot60_LBV10_wr2x,beq60_LBV10_wr2x,beta60_LBV10_wr2x,ekin60_LBV10_wr2x,model=model,logtcollapse=logtcollapse60_LBV10_wr2x
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'nm',data_wgfile_cut,nm60_LBV10_wr2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u160_LBV10_wr2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u2',data_wgfile_cut,u260_LBV10_wr2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt60_LBV10_wr2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl60_LBV10_wr2x,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u560_LBV10_wr2x,return_valz    ;X surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u7',data_wgfile_cut,u760_LBV10_wr2x,return_valz    ;Y surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u860_LBV10_wr2x,return_valz    ;C surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1060_LBV10_wr2x,return_valz  ; N surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u1260_LBV10_wr2x,return_valz   ; O surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u6',data_wgfile_cut,u660_LBV10_wr2x,return_valz   ; Ne surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u15',data_wgfile_cut,u1560_LBV10_wr2x,return_valz    ;X center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u17',data_wgfile_cut,u1760_LBV10_wr2x,return_valz    ;Y center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,u1860_LBV10_wr2x,return_valz    ;C center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u20',data_wgfile_cut,u2060_LBV10_wr2x,return_valz  ; N center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u22',data_wgfile_cut,u2260_LBV10_wr2x,return_valz   ; O center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u16',data_wgfile_cut,u1660_LBV10_wr2x,return_valz   ; Ne center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot60_LBV10_wr2x,return_valz  
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte60_LBV10_wr2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesm',data_wgfile_cut,eddesm60_LBV10_wr2x,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc60_LBV10_wr2x,index_varnamex_wgfile,return_valx

ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth_LBV10_wr2x,tendh=tendh_LBV10_wr2x,modelnumber_starth=modelnumber_starth_LBV10_wr2x,modelnumber_endh=modelnumber_endh_LBV10_wr2x,tauh=tauh_LBV10_wr2x,$
                                    tstart_he=tstart_he_LBV10_wr2x,tend_he=tend_he_LBV10_wr2x,modelnumber_start_he=modelnumber_start_he_LBV10_wr2x,modelnumber_end_he=modelnumber_end_he_LBV10_wr2x,tau_he=tau_he_LBV10_wr2x,$
                                    tstartc=tstartc_LBV10_wr2x,tendc=tendc_LBV10_wr2x,modelnumber_startc=modelnumber_startc_LBV10_wr2x,modelnumber_endc=modelnumber_endc_LBV10_wr2x,tauc=tauc_LBV10_wr2x,$
                                    tstarto=tstarto_LBV10_wr2x,tendo=tendo_LBV10_wr2x,modelnumber_starto=modelnumber_starto_LBV10_wr2x,modelnumber_endo=modelnumber_endo_LBV10_wr2x,tauo=tauo_LBV10_wr2x,$
                                    tstartne=tstartne_LBV10_wr2x,tendne=tendne_LBV10_wr2x,modelnumber_startne=modelnumber_startne_LBV10_wr2x,modelnumber_endne=modelnumber_endne_LBV10_wr2x,taune=taune

;models with different MS mdot
;MS 1/1.5 i.e x0.6666
dir='/Users/jgroh/evol_models/tes/P060z14S0_ms_mdot1d5/'
model='P060z14S0_ms_mdot1d5'
wgfile=dir+model+'.wg' ;assumes model is in wg directory
timestep_ini=49
ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload,timestep_ini=timestep_ini
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60_ms_mdot1d5,logg60_ms_mdot1d5,vesc60_ms_mdot1d5,vinf60_ms_mdot1d5,eta_star60_ms_mdot1d5,Bmin60_ms_mdot1d5,Jdot60_ms_mdot1d5,logg_rphot60_ms_mdot1d5,rphot60_ms_mdot1d5,beq60_ms_mdot1d5,beta60_ms_mdot1d5,ekin60_ms_mdot1d5,model=model,logtcollapse=logtcollapse60_ms_mdot1d5
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'nm',data_wgfile_cut,nm60_ms_mdot1d5,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u160_ms_mdot1d5,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u2',data_wgfile_cut,u260_ms_mdot1d5,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt60_ms_mdot1d5,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl60_ms_mdot1d5,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u560_ms_mdot1d5,return_valz    ;X surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u7',data_wgfile_cut,u760_ms_mdot1d5,return_valz    ;Y surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u860_ms_mdot1d5,return_valz    ;C surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1060_ms_mdot1d5,return_valz  ; N surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u1260_ms_mdot1d5,return_valz   ; O surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u6',data_wgfile_cut,u660_ms_mdot1d5,return_valz   ; Ne surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u15',data_wgfile_cut,u1560_ms_mdot1d5,return_valz    ;X center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u17',data_wgfile_cut,u1760_ms_mdot1d5,return_valz    ;Y center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,u1860_ms_mdot1d5,return_valz    ;C center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u20',data_wgfile_cut,u2060_ms_mdot1d5,return_valz  ; N center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u22',data_wgfile_cut,u2260_ms_mdot1d5,return_valz   ; O center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u16',data_wgfile_cut,u1660_ms_mdot1d5,return_valz   ; Ne center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot60_ms_mdot1d5,return_valz  
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte60_ms_mdot1d5,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesm',data_wgfile_cut,eddesm60_ms_mdot1d5,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc60_ms_mdot1d5,index_varnamex_wgfile,return_valx

ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth_ms_mdot1d5,tendh=tendh_ms_mdot1d5,modelnumber_starth=modelnumber_starth_ms_mdot1d5,modelnumber_endh=modelnumber_endh_ms_mdot1d5,tauh=tauh_ms_mdot1d5,$
                                    tstart_he=tstart_he_ms_mdot1d5,tend_he=tend_he_ms_mdot1d5,modelnumber_start_he=modelnumber_start_he_ms_mdot1d5,modelnumber_end_he=modelnumber_end_he_ms_mdot1d5,tau_he=tau_he_ms_mdot1d5,$
                                    tstartc=tstartc_ms_mdot1d5,tendc=tendc_ms_mdot1d5,modelnumber_startc=modelnumber_startc_ms_mdot1d5,modelnumber_endc=modelnumber_endc_ms_mdot1d5,tauc=tauc_ms_mdot1d5,$
                                    tstarto=tstarto_ms_mdot1d5,tendo=tendo_ms_mdot1d5,modelnumber_starto=modelnumber_starto_ms_mdot1d5,modelnumber_endo=modelnumber_endo_ms_mdot1d5,tauo=tauo_ms_mdot1d5,$
                                    tstartne=tstartne_ms_mdot1d5,tendne=tendne_ms_mdot1d5,modelnumber_startne=modelnumber_startne_ms_mdot1d5,modelnumber_endne=modelnumber_endne_ms_mdot1d5,taune=taune_ms_mdot1d5

;MS 1/1.5 i.e x0.6666
dir='/Users/jgroh/evol_models/tes/P060z14S0_ms_mdot10_LBV1_WR1/'
model='P060z14S0_ms_mdot10_LBV1_WR1'
wgfile=dir+model+'.wg' ;assumes model is in wg directory
timestep_ini=49
ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload,timestep_ini=timestep_ini
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60_ms_mdot10_LBV1_WR1,logg60_ms_mdot10_LBV1_WR1,vesc60_ms_mdot10_LBV1_WR1,vinf60_ms_mdot10_LBV1_WR1,eta_star60_ms_mdot10_LBV1_WR1,Bmin60_ms_mdot10_LBV1_WR1,Jdot60_ms_mdot10_LBV1_WR1,logg_rphot60_ms_mdot10_LBV1_WR1,rphot60_ms_mdot10_LBV1_WR1,beq60_ms_mdot10_LBV1_WR1,beta60_ms_mdot10_LBV1_WR1,ekin60_ms_mdot10_LBV1_WR1,model=model,logtcollapse=logtcollapse60_ms_mdot10_LBV1_WR1
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'nm',data_wgfile_cut,nm60_ms_mdot10_LBV1_WR1,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u160_ms_mdot10_LBV1_WR1,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u2',data_wgfile_cut,u260_ms_mdot10_LBV1_WR1,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt60_ms_mdot10_LBV1_WR1,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl60_ms_mdot10_LBV1_WR1,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u560_ms_mdot10_LBV1_WR1,return_valz    ;X surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u7',data_wgfile_cut,u760_ms_mdot10_LBV1_WR1,return_valz    ;Y surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u860_ms_mdot10_LBV1_WR1,return_valz    ;C surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1060_ms_mdot10_LBV1_WR1,return_valz  ; N surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u1260_ms_mdot10_LBV1_WR1,return_valz   ; O surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u6',data_wgfile_cut,u660_ms_mdot10_LBV1_WR1,return_valz   ; Ne surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u15',data_wgfile_cut,u1560_ms_mdot10_LBV1_WR1,return_valz    ;X center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u17',data_wgfile_cut,u1760_ms_mdot10_LBV1_WR1,return_valz    ;Y center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,u1860_ms_mdot10_LBV1_WR1,return_valz    ;C center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u20',data_wgfile_cut,u2060_ms_mdot10_LBV1_WR1,return_valz  ; N center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u22',data_wgfile_cut,u2260_ms_mdot10_LBV1_WR1,return_valz   ; O center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u16',data_wgfile_cut,u1660_ms_mdot10_LBV1_WR1,return_valz   ; Ne center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot60_ms_mdot10_LBV1_WR1,return_valz  
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte60_ms_mdot10_LBV1_WR1,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesm',data_wgfile_cut,eddesm60_ms_mdot10_LBV1_WR1,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc60_ms_mdot10_LBV1_WR1,index_varnamex_wgfile,return_valx

ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth_ms_mdot10_LBV1_WR1,tendh=tendh_ms_mdot10_LBV1_WR1,modelnumber_starth=modelnumber_starth_ms_mdot10_LBV1_WR1,modelnumber_endh=modelnumber_endh_ms_mdot10_LBV1_WR1,tauh=tauh_ms_mdot10_LBV1_WR1,$
                                    tstart_he=tstart_he_ms_mdot10_LBV1_WR1,tend_he=tend_he_ms_mdot10_LBV1_WR1,modelnumber_start_he=modelnumber_start_he_ms_mdot10_LBV1_WR1,modelnumber_end_he=modelnumber_end_he_ms_mdot10_LBV1_WR1,tau_he=tau_he_ms_mdot10_LBV1_WR1,$
                                    tstartc=tstartc_ms_mdot10_LBV1_WR1,tendc=tendc_ms_mdot10_LBV1_WR1,modelnumber_startc=modelnumber_startc_ms_mdot10_LBV1_WR1,modelnumber_endc=modelnumber_endc_ms_mdot10_LBV1_WR1,tauc=tauc_ms_mdot10_LBV1_WR1,$
                                    tstarto=tstarto_ms_mdot10_LBV1_WR1,tendo=tendo_ms_mdot10_LBV1_WR1,modelnumber_starto=modelnumber_starto_ms_mdot10_LBV1_WR1,modelnumber_endo=modelnumber_endo_ms_mdot10_LBV1_WR1,tauo=tauo_ms_mdot10_LBV1_WR1,$
                                    tstartne=tstartne_ms_mdot10_LBV1_WR1,tendne=tendne_ms_mdot10_LBV1_WR1,modelnumber_startne=modelnumber_startne_ms_mdot10_LBV1_WR1,modelnumber_endne=modelnumber_endne_ms_mdot10_LBV1_WR1,taune=taune_ms_mdot10_LBV1_WR1

;MS 1/1.5 i.e x0.6666
dir='/Users/jgroh/evol_models/tes/P060z14S0_ms_mdot2_LBV_5em5/'
model='P060z14S0_ms_mdot2_LBV_5em5'
wgfile=dir+model+'.wg' ;assumes model is in wg directory
timestep_ini=49
ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload,timestep_ini=timestep_ini
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60_ms_mdot2_LBV_5em5,logg60_ms_mdot2_LBV_5em5,vesc60_ms_mdot2_LBV_5em5,vinf60_ms_mdot2_LBV_5em5,eta_star60_ms_mdot2_LBV_5em5,Bmin60_ms_mdot2_LBV_5em5,Jdot60_ms_mdot2_LBV_5em5,logg_rphot60_ms_mdot2_LBV_5em5,rphot60_ms_mdot2_LBV_5em5,beq60_ms_mdot2_LBV_5em5,beta60_ms_mdot2_LBV_5em5,ekin60_ms_mdot2_LBV_5em5,model=model,logtcollapse=logtcollapse60_ms_mdot2_LBV_5em5
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'nm',data_wgfile_cut,nm60_ms_mdot2_LBV_5em5,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u160_ms_mdot2_LBV_5em5,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u2',data_wgfile_cut,u260_ms_mdot2_LBV_5em5,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt60_ms_mdot2_LBV_5em5,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl60_ms_mdot2_LBV_5em5,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u560_ms_mdot2_LBV_5em5,return_valz    ;X surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u7',data_wgfile_cut,u760_ms_mdot2_LBV_5em5,return_valz    ;Y surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u860_ms_mdot2_LBV_5em5,return_valz    ;C surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1060_ms_mdot2_LBV_5em5,return_valz  ; N surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u1260_ms_mdot2_LBV_5em5,return_valz   ; O surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u6',data_wgfile_cut,u660_ms_mdot2_LBV_5em5,return_valz   ; Ne surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u15',data_wgfile_cut,u1560_ms_mdot2_LBV_5em5,return_valz    ;X center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u17',data_wgfile_cut,u1760_ms_mdot2_LBV_5em5,return_valz    ;Y center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,u1860_ms_mdot2_LBV_5em5,return_valz    ;C center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u20',data_wgfile_cut,u2060_ms_mdot2_LBV_5em5,return_valz  ; N center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u22',data_wgfile_cut,u2260_ms_mdot2_LBV_5em5,return_valz   ; O center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u16',data_wgfile_cut,u1660_ms_mdot2_LBV_5em5,return_valz   ; Ne center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot60_ms_mdot2_LBV_5em5,return_valz  
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte60_ms_mdot2_LBV_5em5,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesm',data_wgfile_cut,eddesm60_ms_mdot2_LBV_5em5,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc60_ms_mdot2_LBV_5em5,index_varnamex_wgfile,return_valx

ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth_ms_mdot2_LBV_5em5,tendh=tendh_ms_mdot2_LBV_5em5,modelnumber_starth=modelnumber_starth_ms_mdot2_LBV_5em5,modelnumber_endh=modelnumber_endh_ms_mdot2_LBV_5em5,tauh=tauh_ms_mdot2_LBV_5em5,$
                                    tstart_he=tstart_he_ms_mdot2_LBV_5em5,tend_he=tend_he_ms_mdot2_LBV_5em5,modelnumber_start_he=modelnumber_start_he_ms_mdot2_LBV_5em5,modelnumber_end_he=modelnumber_end_he_ms_mdot2_LBV_5em5,tau_he=tau_he_ms_mdot2_LBV_5em5,$
                                    tstartc=tstartc_ms_mdot2_LBV_5em5,tendc=tendc_ms_mdot2_LBV_5em5,modelnumber_startc=modelnumber_startc_ms_mdot2_LBV_5em5,modelnumber_endc=modelnumber_endc_ms_mdot2_LBV_5em5,tauc=tauc_ms_mdot2_LBV_5em5,$
                                    tstarto=tstarto_ms_mdot2_LBV_5em5,tendo=tendo_ms_mdot2_LBV_5em5,modelnumber_starto=modelnumber_starto_ms_mdot2_LBV_5em5,modelnumber_endo=modelnumber_endo_ms_mdot2_LBV_5em5,tauo=tauo_ms_mdot2_LBV_5em5,$
                                    tstartne=tstartne_ms_mdot2_LBV_5em5,tendne=tendne_ms_mdot2_LBV_5em5,modelnumber_startne=modelnumber_startne_ms_mdot2_LBV_5em5,modelnumber_endne=modelnumber_endne_ms_mdot2_LBV_5em5,taune=taune_ms_mdot2_LBV_5em5


;HR diagram
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xte60_ms_mdot4,xl60_ms_mdot4,color1='black',linestyle1=2,'Log (Teff,GVA / K)','Log (L/Lsun)','',xrange=[5.85,3.70],yrange=[5.0,6.1],/nolabel,filename='all_hrd1',ystyle=1,$
                              POSITION=[0.15,0.15,0.96,0.96],pthick=10,DOUBLE_YAXIS=1,alty_min=5.0,alty_max=6.1,alty_tickformat='(A2)',$
                              x2=xte60_ms_mdot4_lbvstd_wr_0d5x,y2=xl60_ms_mdot4_lbvstd_wr_0d5x,linestyle2=2,color2='dark green',$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x3=xte60_ms_mdot4_lbvstd,y3=xl60_ms_mdot4_lbvstd,linestyle3=2,color3='blue',$
                              x4=xte60_ms_mdot4_lbvstd_wr_2x,y4=xl60_ms_mdot4_lbvstd_wr_2x,linestyle4=2,color4='orange',$
                              x5=xte60_postms_5em5_wr0d5x,y5=xl60_postms_5em5_wr0d5x,linestyle5=0,color5='magenta',$
                              x6=xte60_postms_5em5_wr1x,y6=xl60_postms_5em5_wr1x,linestyle6=0,color6='green',$                           
                              x7=xte60_postms_5em5_wr2x,y7=xl60_postms_5em5_wr2x,linestyle7=0,color7='brown',$
                              x8=xte60_LBV1_wr0d5x,y8=xl60_LBV1_wr0d5x,linestyle8=0,color8='dark grey',$
                              x9=xte60,y9=xl60,linestyle9=0,color9='red',$
                              x10=xte60_LBV1_wr2x,y10=xl60_LBV1_wr2x,linestyle_10=0,color_10='yellow',$
                              x11=xte60_LBV10_wr0d5x,y11=xl60_LBV10_wr0d5x,linestyle_11=0,color_11='cyan',$
                              x12=xte60_LBV10_wr1x,y12=xl60_LBV10_wr1x,linestyle_12=0,color_12='grey',$
                              x13=xte60_LBV10_wr2x,y13=xl60_LBV10_wr2x,linestyle_13=0,color_13='purple',$    
                              alt_x2=xte60_ms_mdot4_LBV10_wr0d5x,alt_y2=xl60_ms_mdot4_LBV10_wr0d5x,alt_linestyle2=2,alt_color2='dark green',$
                              alt_x3=xte60_ms_mdot4_LBV10_wr1x,alt_y3=xl60_ms_mdot4_LBV10_wr1x,alt_linestyle3=2,alt_color3='blue',$
                              alt_x4=xte60_ms_mdot4_LBV10_wr2x,alt_y4=xl60_ms_mdot4_LBV10_wr2x,alt_linestyle4=2,alt_color4='orange'                                                                                    

;HR diagram color-coded with same WR Mdot, linestyle same MS Mdot 
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xte60_ms_mdot4,xl60_ms_mdot4,color1='black',linestyle1=2,'Log (Teff,GVA / K)','Log (L/Lsun)','',xrange=[5.85,3.70],yrange=[5.0,6.1],/nolabel,filename='all_hrd2',ystyle=1,$
                              POSITION=[0.15,0.15,0.96,0.96],pthick=10,DOUBLE_YAXIS=1,alty_min=5.0,alty_max=6.1,alty_tickformat='(A2)',$
                              x2=xte60_ms_mdot4_lbvstd_wr_0d5x,y2=xl60_ms_mdot4_lbvstd_wr_0d5x,linestyle2=2,color2='green',$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x3=xte60_ms_mdot4_lbvstd,y3=xl60_ms_mdot4_lbvstd,linestyle3=2,color3='magenta',$
                              x4=xte60_ms_mdot4_lbvstd_wr_2x,y4=xl60_ms_mdot4_lbvstd_wr_2x,linestyle4=2,color4='orange',$
                              x5=xte60_postms_5em5_wr0d5x,y5=xl60_postms_5em5_wr0d5x,linestyle5=0,color5='green',$
                              x6=xte60_postms_5em5_wr1x,y6=xl60_postms_5em5_wr1x,linestyle6=0,color6='magenta',$                           
                              x7=xte60_postms_5em5_wr2x,y7=xl60_postms_5em5_wr2x,linestyle7=0,color7='orange',$
                              x8=xte60_LBV1_wr0d5x,y8=xl60_LBV1_wr0d5x,linestyle8=0,color8='green',$
                              x9=xte60,y9=xl60,linestyle9=0,color9='magenta',$
                              x10=xte60_LBV1_wr2x,y10=xl60_LBV1_wr2x,linestyle_10=0,color_10='orange',$
                              x11=xte60_LBV10_wr0d5x,y11=xl60_LBV10_wr0d5x,linestyle_11=0,color_11='green',$
                              x12=xte60_LBV10_wr1x,y12=xl60_LBV10_wr1x,linestyle_12=0,color_12='magenta',$
                              x13=xte60_LBV10_wr2x,y13=xl60_LBV10_wr2x,linestyle_13=0,color_13='orange',$    
                              alt_x2=xte60_ms_mdot4_LBV10_wr0d5x,alt_y2=xl60_ms_mdot4_LBV10_wr0d5x,alt_linestyle2=2,alt_color2='green',$
                              alt_x3=xte60_ms_mdot4_LBV10_wr1x,alt_y3=xl60_ms_mdot4_LBV10_wr1x,alt_linestyle3=2,alt_color3='magenta',$
                              alt_x4=xte60_ms_mdot4_LBV10_wr2x,alt_y4=xl60_ms_mdot4_LBV10_wr2x,alt_linestyle4=2,alt_color4='orange'             

;HR diagram color coded with different WR Mdot, linestyle=different LBV Mdot, for MS=1
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xte60,xl60,color1='green',linestyle1=0,'Log (Teff,GVA / K)','Log (L/Lsun)','',xrange=[5.85,3.70],yrange=[5.0,6.1],/nolabel,filename='all_hrd_ms1',ystyle=1,$
                              POSITION=[0.15,0.15,0.96,0.96],pthick=10,DOUBLE_YAXIS=1,alty_min=5.0,alty_max=6.1,alty_tickformat='(A2)',$
               ;               x2=xte60_ms_mdot4_lbvstd_wr_0d5x,y2=xl60_ms_mdot4_lbvstd_wr_0d5x,linestyle2=2,color2='dark green',$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                ;              x3=xte60_ms_mdot4_lbvstd,y3=xl60_ms_mdot4_lbvstd,linestyle3=2,color3='blue',$
                 ;             x4=xte60_ms_mdot4_lbvstd_wr_2x,y4=xl60_ms_mdot4_lbvstd_wr_2x,linestyle4=2,color4='orange',$
                              x5=xte60_postms_5em5_wr0d5x,y5=xl60_postms_5em5_wr0d5x,linestyle5=3,color5='magenta',$
                              x6=xte60_postms_5em5_wr1x,y6=xl60_postms_5em5_wr1x,linestyle6=3,color6='green',$                           
                              x7=xte60_postms_5em5_wr2x,y7=xl60_postms_5em5_wr2x,linestyle7=3,color7='cyan',$
                              x8=xte60_LBV1_wr0d5x,y8=xl60_LBV1_wr0d5x,linestyle8=0,color8='magenta',$
                   ;           x9=xte60,y9=xl60,linestyle9=0,color9='green',$
                              x10=xte60_LBV1_wr2x,y10=xl60_LBV1_wr2x,linestyle_10=0,color_10='cyan',$
                              x11=xte60_LBV10_wr0d5x,y11=xl60_LBV10_wr0d5x,linestyle_11=2,color_11='magenta',$
                              x12=xte60_LBV10_wr1x,y12=xl60_LBV10_wr1x,linestyle_12=2,color_12='green',$
                              x13=xte60_LBV10_wr2x,y13=xl60_LBV10_wr2x,linestyle_13=2,color_13='cyan';,$    
                 ;             alt_x2=xte60_ms_mdot4_LBV10_wr0d5x,alt_y2=xl60_ms_mdot4_LBV10_wr0d5x,alt_linestyle2=2,alt_color2='dark green',$
                  ;            alt_x3=xte60_ms_mdot4_LBV10_wr1x,alt_y3=xl60_ms_mdot4_LBV10_wr1x,alt_linestyle3=2,alt_color3='blue',$
                 ;             alt_x4=xte60_ms_mdot4_LBV10_wr2x,alt_y4=xl60_ms_mdot4_LBV10_wr2x,alt_linestyle4=2,alt_color4='orange' 

;HR diagram color coded with different WR Mdot, linestyle=different LBV Mdot, for MS=1/4
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xte60_ms_mdot4,xl60_ms_mdot4,color1='green',linestyle1=3,'Log (Teff,GVA / K)','Log (L/Lsun)','',xrange=[5.85,3.70],yrange=[5.0,6.1],/nolabel,filename='all_hrd_ms0d25',ystyle=1,$
                              POSITION=[0.15,0.15,0.96,0.96],pthick=10,DOUBLE_YAXIS=1,alty_min=5.0,alty_max=6.1,alty_tickformat='(A2)',$
                              x2=xte60_ms_mdot4_lbvstd_wr_0d5x,y2=xl60_ms_mdot4_lbvstd_wr_0d5x,linestyle2=0,color2='magenta',$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x3=xte60_ms_mdot4_lbvstd,y3=xl60_ms_mdot4_lbvstd,linestyle3=0,color3='green',$
                              x4=xte60_ms_mdot4_lbvstd_wr_2x,y4=xl60_ms_mdot4_lbvstd_wr_2x,linestyle4=0,color4='cyan',$
                   ;           x5=xte60_postms_5em5_wr0d5x,y5=xl60_postms_5em5_wr0d5x,linestyle5=3,color5='magenta',$
                  ;            x6=xte60_postms_5em5_wr1x,y6=xl60_postms_5em5_wr1x,linestyle6=0,color6='green',$                           
                   ;           x7=xte60_postms_5em5_wr2x,y7=xl60_postms_5em5_wr2x,linestyle7=2,color7='blue',$
                  ;            x8=xte60_LBV1_wr0d5x,y8=xl60_LBV1_wr0d5x,linestyle8=3,color8='magenta',$
                              x9=xte60,y9=xl60,linestyle9=0,color9='grey',$
                   ;           x10=xte60_LBV1_wr2x,y10=xl60_LBV1_wr2x,linestyle_10=2,color_10='blue',$
                   ;           x11=xte60_LBV10_wr0d5x,y11=xl60_LBV10_wr0d5x,linestyle_11=3,color_11='magenta',$
                   ;           x12=xte60_LBV10_wr1x,y12=xl60_LBV10_wr1x,linestyle_12=0,color_12='green',$
                   ;           x13=xte60_LBV10_wr2x,y13=xl60_LBV10_wr2x,linestyle_13=2,color_13='blue',$    
                              alt_x2=xte60_ms_mdot4_LBV10_wr0d5x,alt_y2=xl60_ms_mdot4_LBV10_wr0d5x,alt_linestyle2=2,alt_color2='magenta',$
                              alt_x3=xte60_ms_mdot4_LBV10_wr1x,alt_y3=xl60_ms_mdot4_LBV10_wr1x,alt_linestyle3=2,alt_color3='green',$
                              alt_x4=xte60_ms_mdot4_LBV10_wr2x,alt_y4=xl60_ms_mdot4_LBV10_wr2x,alt_linestyle4=2,alt_color4='cyan'

;mass x time diagram
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160_ms_mdot4,u260_ms_mdot4,color1='black',linestyle1=2,'Age (Myr)','Mass (Msun)','',xrange=[3.4e6,4.2e6],yrange=[0,65.],/nolabel,filename='all_mass1',ystyle=1,$
                              POSITION=[0.15,0.15,0.96,0.96],pthick=10,DOUBLE_YAXIS=1,alty_min=0.0,alty_max=65.0,alty_tickformat='(A2)',$
                              x2=u160_ms_mdot4_lbvstd_wr_0d5x,y2=u260_ms_mdot4_lbvstd_wr_0d5x,linestyle2=2,color2='dark green',$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x3=u160_ms_mdot4_lbvstd,y3=u260_ms_mdot4_lbvstd,linestyle3=2,color3='blue',$
                              x4=u160_ms_mdot4_lbvstd_wr_2x,y4=u260_ms_mdot4_lbvstd_wr_2x,linestyle4=2,color4='orange',$
                              x5=u160_postms_5em5_wr0d5x,y5=u260_postms_5em5_wr0d5x,linestyle5=0,color5='magenta',$
                              x6=u160_postms_5em5_wr1x,y6=u260_postms_5em5_wr1x,linestyle6=0,color6='green',$                           
                              x7=u160_postms_5em5_wr2x,y7=u260_postms_5em5_wr2x,linestyle7=0,color7='brown',$
                              x8=u160_LBV1_wr0d5x,y8=u260_LBV1_wr0d5x,linestyle8=0,color8='dark grey',$
                              x9=u160,y9=u260,linestyle9=0,color9='red',$
                              x10=u160_LBV1_wr2x,y10=u260_LBV1_wr2x,linestyle_10=0,color_10='yellow',$
                              x11=u160_LBV10_wr0d5x,y11=u260_LBV10_wr0d5x,linestyle_11=0,color_11='cyan',$
                              x12=u160_LBV10_wr1x,y12=u260_LBV10_wr1x,linestyle_12=0,color_12='grey',$
                              x13=u160_LBV10_wr2x,y13=u260_LBV10_wr2x,linestyle_13=0,color_13='purple',$    
                              alt_x2=u160_ms_mdot4_LBV10_wr0d5x,alt_y2=u260_ms_mdot4_LBV10_wr0d5x,alt_linestyle2=2,alt_color2='dark green',$
                              alt_x3=u160_ms_mdot4_LBV10_wr1x,alt_y3=u260_ms_mdot4_LBV10_wr1x,alt_linestyle3=2,alt_color3='blue',$
                              alt_x4=u160_ms_mdot4_LBV10_wr2x,alt_y4=u260_ms_mdot4_LBV10_wr2x,alt_linestyle4=2,alt_color4='orange'        

;HR diagram for MS0.25, LBV1, WR1 and MS1, LBV1, WR1 
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xte60,xl60,color1='black',linestyle1=0,'Log (Teff,GVA / K)','Log (L/Lsun)','',xrange=[5.45,3.70],yrange=[5.45,6.1],/nolabel,filename='all_hrd_diffmsmdot',ystyle=1,$
                              POSITION=[0.15,0.15,0.96,0.96],pthick=10,DOUBLE_YAXIS=1,alty_min=5.45,alty_max=6.1,alty_tickformat='(A2)',$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x3=xte60_ms_mdot4_lbvstd,y3=xl60_ms_mdot4_lbvstd,linestyle3=2,color3='red',cmyk=0,$
                              x5=xte60_ms_mdot10_LBV1_WR1,y5=xl60_ms_mdot10_LBV1_WR1,linestyle5=0,color5='green';,$

;mass x time diagram for MS0.25, LBV1, WR1 and MS1, LBV1, WR1 
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160,u260,color1='black',linestyle1=0,'Age (Myr)','Mass (Msun)','',xrange=[0.0e6,4.2e6],yrange=[0,65.],/nolabel,filename='all_mass3_diffmsmdot',ystyle=1,$
                              POSITION=[0.15,0.15,0.96,0.96],pthick=10,DOUBLE_YAXIS=1,alty_min=0.0,alty_max=65.0,alty_tickformat='(A2)',$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x3=u160_ms_mdot4_lbvstd,y3=u260_ms_mdot4_lbvstd,linestyle3=2,color3='red';,$

  
;mass x age diagram for different MS Mdot
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160[modelnumber_starth60:modelnumber_endh60],u260[modelnumber_starth60:modelnumber_endh60],color1='black',linestyle1=0,'Age (Myr)','Mass (Msun)','',xrange=[0.0e6,4.2e6],yrange=[35,62.],/nolabel,filename='all_mass3',ystyle=1,$
                              POSITION=[0.15,0.15,0.96,0.96],pthick=10,DOUBLE_YAXIS=1,alty_min=35.0,alty_max=62.0,alty_tickformat='(A2)',$
                              x2=u160_ms_mdot1d5[modelnumber_starth_ms_mdot1d5:modelnumber_endh_ms_mdot1d5],y2=u260_ms_mdot1d5[modelnumber_starth_ms_mdot1d5:modelnumber_endh_ms_mdot1d5],linestyle2=2,color2='blue',$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x3=u160_ms_mdot4_lbvstd[modelnumber_starth_ms_mdot4_lbvstd:modelnumber_endh_ms_mdot4_lbvstd],y3=u260_ms_mdot4_lbvstd[modelnumber_starth_ms_mdot4_lbvstd:modelnumber_endh_ms_mdot4_lbvstd],linestyle3=2,color3='red',$
                              x4=u160_ms_mdot2_LBV_5em5[modelnumber_starth_ms_mdot2_LBV_5em5:modelnumber_endh_ms_mdot2_LBV_5em5],y4=u260_ms_mdot2_LBV_5em5[modelnumber_starth_ms_mdot2_LBV_5em5:modelnumber_endh_ms_mdot2_LBV_5em5],linestyle4=2,color4='orange',$
                              x5=u160_ms_mdot10_LBV1_WR1[modelnumber_starth_ms_mdot10_LBV1_WR1:modelnumber_endh_ms_mdot10_LBV1_WR1],y5=u260_ms_mdot10_LBV1_WR1[modelnumber_starth_ms_mdot1d5:modelnumber_endh_ms_mdot10_LBV1_WR1],linestyle5=0,color5='green';,$
  
;mass x teff diagram for different MS Mdot
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,10^xte60[modelnumber_starth60:modelnumber_endh60],u260[modelnumber_starth60:modelnumber_endh60],color1='black',linestyle1=0,'Teff,GVA (K)','Mass (Msun)','',xrange=[50000.,10000.],yrange=[35,62.],/nolabel,filename='all_mass_teff3',ystyle=1,$
                              POSITION=[0.15,0.15,0.96,0.96],pthick=10,DOUBLE_YAXIS=1,alty_min=35.0,alty_max=62.0,alty_tickformat='(A2)',$
                              x2=10^xte60_ms_mdot1d5[modelnumber_starth_ms_mdot1d5:modelnumber_endh_ms_mdot1d5],y2=u260_ms_mdot1d5[modelnumber_starth_ms_mdot1d5:modelnumber_endh_ms_mdot1d5],linestyle2=2,color2='blue',$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x3=10^xte60_ms_mdot4_lbvstd[modelnumber_starth_ms_mdot4_lbvstd:modelnumber_endh_ms_mdot4_lbvstd],y3=u260_ms_mdot4_lbvstd[modelnumber_starth_ms_mdot4_lbvstd:modelnumber_endh_ms_mdot4_lbvstd],linestyle3=2,color3='red',$
                              x4=10^xte60_ms_mdot2_LBV_5em5[modelnumber_starth_ms_mdot2_LBV_5em5:modelnumber_endh_ms_mdot2_LBV_5em5],y4=u260_ms_mdot2_LBV_5em5[modelnumber_starth_ms_mdot2_LBV_5em5:modelnumber_endh_ms_mdot2_LBV_5em5],linestyle4=2,color4='orange',$
                              x5=10^xte60_ms_mdot10_LBV1_WR1[modelnumber_starth_ms_mdot10_LBV1_WR1:modelnumber_endh_ms_mdot10_LBV1_WR1],y5=u260_ms_mdot10_LBV1_WR1[modelnumber_starth_ms_mdot1d5:modelnumber_endh_ms_mdot10_LBV1_WR1],linestyle5=0,color5='green';,$

;mdot x teff diagram for different MS Mdot, for MS 
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,10^xte60[modelnumber_starth60:modelnumber_endh60],10^xmdot60[modelnumber_starth60:modelnumber_endh60],color1='black',linestyle1=0,'Teff,GVA (K)','Mdot (Msun/yr)','',xrange=[50000.,6000.],yrange=[1e-7,4e-4],/nolabel,filename='all_mdot_teff3',ystyle=1,$
                              POSITION=[0.15,0.15,0.96,0.96],pthick=10,/ylog,DOUBLE_YAXIS=0,alty_min=35.0,alty_max=62.0,alty_tickformat='(A2)',$
                              x2=10^xte60_ms_mdot1d5[modelnumber_starth_ms_mdot1d5:modelnumber_endh_ms_mdot1d5],y2=10^xmdot60_ms_mdot1d5[modelnumber_starth_ms_mdot1d5:modelnumber_endh_ms_mdot1d5],linestyle2=2,color2='blue',$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x3=10^xte60_ms_mdot4_lbvstd[modelnumber_starth_ms_mdot4_lbvstd:modelnumber_endh_ms_mdot4_lbvstd],y3=10^xmdot60_ms_mdot4_lbvstd[modelnumber_starth_ms_mdot4_lbvstd:modelnumber_endh_ms_mdot4_lbvstd],linestyle3=2,color3='red',$
                              x4=10^xte60_ms_mdot2_LBV_5em5[modelnumber_starth_ms_mdot2_LBV_5em5:modelnumber_endh_ms_mdot2_LBV_5em5],y4=10^xmdot60_ms_mdot2_LBV_5em5[modelnumber_starth_ms_mdot2_LBV_5em5:modelnumber_endh_ms_mdot2_LBV_5em5],linestyle4=2,color4='orange',$
                              x5=10^xte60_ms_mdot10_LBV1_WR1[modelnumber_starth_ms_mdot10_LBV1_WR1:modelnumber_endh_ms_mdot10_LBV1_WR1],y5=10^xmdot60_ms_mdot10_LBV1_WR1[modelnumber_starth_ms_mdot1d5:modelnumber_endh_ms_mdot10_LBV1_WR1],linestyle5=0,color5='green',$
                              x6=10^xte60_ms_mdot4_lbvstd[modelnumber_endh_ms_mdot4_lbvstd:modelnumber_endc_ms_mdot4_lbvstd],y6=10^xmdot60_ms_mdot4_lbvstd[modelnumber_endh_ms_mdot4_lbvstd:modelnumber_endc_ms_mdot4_lbvstd],color6='red',linestyle6=1,$
                              x7=10^xte60[modelnumber_endh60:modelnumber_endc60],y7=10^xmdot60[modelnumber_endh60:modelnumber_endc60],color7='black',linestyle7=1


;mdot x teff diagram for different MS Mdot, for POST MS
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,10^xte60[modelnumber_endh60:modelnumber_endc60],10^xmdot60[modelnumber_endh60:modelnumber_endc60],color1='black',linestyle1=0,'Teff,GVA (K)','Mdot (Msun/yr)','',xrange=[50000.,6000.],yrange=[1e-7,4e-4],/nolabel,filename='postms_mdot_teff3',ystyle=1,$
                              POSITION=[0.15,0.15,0.96,0.96],pthick=10,/ylog,DOUBLE_YAXIS=0,alty_min=35.0,alty_max=62.0,alty_tickformat='(A2)',$
  ;                            x2=10^xte60_ms_mdot1d5[modelnumber_endh_ms_mdot1d5:modelnumber_endc_ms_mdot1d5],y2=10^xmdot60_ms_mdot1d5[modelnumber_endh_ms_mdot1d5:modelnumber_endc_ms_mdot1d5],linestyle2=2,color2='blue',$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x3=10^xte60_ms_mdot4_lbvstd[modelnumber_endh_ms_mdot4_lbvstd:modelnumber_endc_ms_mdot4_lbvstd],y3=10^xmdot60_ms_mdot4_lbvstd[modelnumber_endh_ms_mdot4_lbvstd:modelnumber_endc_ms_mdot4_lbvstd],linestyle3=2,color3='red',$
  ;                            x4=10^xte60_ms_mdot2_LBV_5em5[modelnumber_endh_ms_mdot2_LBV_5em5:modelnumber_endc_ms_mdot2_LBV_5em5],y4=10^xmdot60_ms_mdot2_LBV_5em5[modelnumber_endh_ms_mdot2_LBV_5em5:modelnumber_endc_ms_mdot2_LBV_5em5],linestyle4=2,color4='orange',$
                              x5=10^xte60_ms_mdot10_LBV1_WR1[modelnumber_endh_ms_mdot10_LBV1_WR1:modelnumber_endc_ms_mdot10_LBV1_WR1],y5=10^xmdot60_ms_mdot10_LBV1_WR1[modelnumber_endh_ms_mdot1d5:modelnumber_endc_ms_mdot10_LBV1_WR1],linestyle5=0,color5='green';,$
  ;                            x6=10^xte60_ms_mdot4_lbvstd[modelnumber_endc_ms_mdot4_lbvstd:modelnumber_endc_ms_mdot4_lbvstd],y6=10^xmdot60_ms_mdot4_lbvstd[modelnumber_endc_ms_mdot4_lbvstd:modelnumber_endc_ms_mdot4_lbvstd],color6='red',linestyle6=1,$
  ;                            x7=10^xte60[modelnumber_endc60:modelnumber_endc60],y7=10^xmdot60[modelnumber_endc60:modelnumber_endc60],color7='black',linestyle7=1


;teff x age diagram for different MS Mdot, post MS
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160/1e6,10^xte60,ylog=1,color1='black',linestyle1=0,'Age (Myr)','Teff,GVA (K)','',xrange=[3,4.2],yrange=[6000,250000],/nolabel,filename='all_age_teff3',ystyle=1,$
                              POSITION=[0.15,0.15,0.96,0.96],pthick=10,DOUBLE_YAXIS=0,alty_min=6000,alty_max=150000,alty_tickformat='(A2)',$
                      ;        x2=u160_ms_mdot1d5/1e6,y2=10^xte60_ms_mdot1d5,linestyle2=2,color2='blue',$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x3=u160_ms_mdot4_lbvstd/1e6,y3=10^xte60_ms_mdot4_lbvstd,linestyle3=2,color3='red',$
                         ;     x4=u160_ms_mdot2_LBV_5em5/1e6,y4=10^xte60_ms_mdot2_LBV_5em5,linestyle4=2,color4='orange',$
                              x5=u160_ms_mdot10_LBV1_WR1/1e6,y5=10^xte60_ms_mdot10_LBV1_WR1,linestyle5=0,color5='green';,$


;He surface mass fraction x time diagram for different MS Mdot
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160[modelnumber_starth60:modelnumber_endh60],u760[modelnumber_starth60:modelnumber_endh60],color1='black',linestyle1=0,'Age (Myr)','Y','',xrange=[0.0e6,4.2e6],yrange=[0.2,0.5],/nolabel,filename='all_abund3',ystyle=1,$
                              POSITION=[0.15,0.15,0.96,0.96],pthick=10,DOUBLE_YAXIS=1,alty_min=0.2,alty_max=0.5,alty_tickformat='(A2)',$
                              x2=u160_ms_mdot1d5[modelnumber_starth_ms_mdot1d5:modelnumber_endh_ms_mdot1d5],y2=u760_ms_mdot1d5[modelnumber_starth_ms_mdot1d5:modelnumber_endh_ms_mdot1d5],linestyle2=2,color2='blue',$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x3=u160_ms_mdot4_lbvstd[modelnumber_starth_ms_mdot4_lbvstd:modelnumber_endh_ms_mdot4_lbvstd],y3=u760_ms_mdot4_lbvstd[modelnumber_starth_ms_mdot4_lbvstd:modelnumber_endh_ms_mdot4_lbvstd],linestyle3=2,color3='red',$
                              x4=u160_ms_mdot2_LBV_5em5[modelnumber_starth_ms_mdot2_LBV_5em5:modelnumber_endh_ms_mdot2_LBV_5em5],y4=u760_ms_mdot2_LBV_5em5[modelnumber_starth_ms_mdot2_LBV_5em5:modelnumber_endh_ms_mdot2_LBV_5em5],linestyle4=2,color4='orange',$
                              x5=u160_ms_mdot10_LBV1_WR1[modelnumber_starth_ms_mdot10_LBV1_WR1:modelnumber_endh_ms_mdot10_LBV1_WR1],y5=u760_ms_mdot10_LBV1_WR1[modelnumber_starth_ms_mdot1d5:modelnumber_endh_ms_mdot10_LBV1_WR1],linestyle5=0,color5='green';,$
  

;HR diagram color-coded for different LBV Mdot, linestyle diff MS Mdot
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xte60_ms_mdot4,xl60_ms_mdot4,color1='dark grey',linestyle1=2,'Log (Teff,GVA / K)','Log (L/Lsun)','',xrange=[5.85,3.70],yrange=[5.5,6.1],/nolabel,filename='all_hrd_LBVmdot',ystyle=1,$
                              POSITION=[0.15,0.15,0.96,0.96],pthick=10,DOUBLE_YAXIS=1,alty_min=5.5,alty_max=6.1,alty_tickformat='(A2)',$
                              rebin=1,factor=5,xreverse=0,_EXTRA=extra,$
                              x3=xte60_ms_mdot4_lbvstd,y3=xl60_ms_mdot4_lbvstd,linestyle3=2,color3='red',$
                              alt_x3=xte60_ms_mdot4_LBV10_wr1x,alt_y3=xl60_ms_mdot4_LBV10_wr1x,alt_linestyle3=2,alt_color3='purple',$
                              x6=xte60_postms_5em5_wr1x,y6=xl60_postms_5em5_wr1x,linestyle6=0,color6='cyan',$                           
                              x9=xte60,y9=xl60,linestyle9=0,color9='black',$
                              x12=xte60_LBV10_wr1x,y12=xl60_LBV10_wr1x,linestyle_12=0,color_12='yellow',cmyk=1

;Mass x age color-coded for different LBV Mdot, linestyle diff MS Mdot
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160_ms_mdot4,u260_ms_mdot4,color1='dark grey',linestyle1=2,'Age (Myr)','Mass (Msun)','',xrange=[0.0e6,4.2e6],yrange=[10,62.],/nolabel,filename='all_mass_age_LBVmdot',ystyle=1,$
                              POSITION=[0.15,0.15,0.96,0.96],pthick=10,DOUBLE_YAXIS=1,alty_min=10,alty_max=62,alty_tickformat='(A2)',$
                              rebin=1,factor=5,xreverse=0,_EXTRA=extra,$
                              x3=u160_ms_mdot4_lbvstd,y3=u260_ms_mdot4_lbvstd,linestyle3=2,color3='red',$
                              alt_x3=u160_ms_mdot4_LBV10_wr1x,alt_y3=u260_ms_mdot4_LBV10_wr1x,alt_linestyle3=2,alt_color3='purple',$
                              x6=u160_postms_5em5_wr1x,y6=u260_postms_5em5_wr1x,linestyle6=0,color6='cyan',$                           
                              x9=u160,y9=u260,linestyle9=0,color9='black',$
                              x12=u160_LBV10_wr1x,y12=u260_LBV10_wr1x,linestyle_12=0,color_12='yellow',cmyk=1


;HR diagram for different WR Mdot, same MS and LBV mdot 
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xte60,xl60,color1='black',linestyle1=0,'Log (Teff,GVA / K)','Log (L/Lsun)','',xrange=[5.45,3.70],yrange=[5.10,6.05],/nolabel,filename='wr_hrd_diffwrmdot',ystyle=1,$
                              POSITION=[0.15,0.15,0.96,0.96],pthick=10,DOUBLE_YAXIS=0,alty_min=5.45,alty_max=6.1,alty_tickformat='(A2)',/nodata,$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,cmyk=1,$
                              x8=xte60_LBV1_wr0d5x,y8=xl60_LBV1_wr0d5x,linestyle8=0,color8='orange',$
                              x10=xte60_LBV1_wr2x,y10=xl60_LBV1_wr2x,linestyle_10=0,color_10='lime green',$
                              x9=xte60,y9=xl60,linestyle9=0,color9='black'


                                                              
;lineplot,xl,xl60_wr1
;lineplot,xtt60_wr1,xl60_wr1
mass_fin=[last(u260_ms_mdot4),last(u260_ms_mdot4_lbvstd_wr_0d5x),last(u260_ms_mdot4_lbvstd),last(u260_ms_mdot4_lbvstd_wr_2x),last(u260_ms_mdot4_LBV10_wr0d5x),last(u260_ms_mdot4_LBV10_wr1x),last(u260_ms_mdot4_LBV10_wr2x),last(u260_postms_5em5_wr0d5x),last(u260_postms_5em5_wr1x),last(u260_postms_5em5_wr2x),last(u260_LBV1_wr0d5x),last(u260),last(u260_LBV1_wr2x),last(u260_LBV10_wr0d5x),last(u260_LBV10_wr1x),last(u260_LBV10_wr2x)]

he_surface_fin=[last(u760_ms_mdot4),last(u760_ms_mdot4_lbvstd_wr_0d5x),last(u760_ms_mdot4_lbvstd),last(u760_ms_mdot4_lbvstd_wr_2x),last(u760_ms_mdot4_LBV10_wr0d5x),last(u760_ms_mdot4_LBV10_wr1x),last(u760_ms_mdot4_LBV10_wr2x),last(u760_postms_5em5_wr0d5x),last(u760_postms_5em5_wr1x),last(u760_postms_5em5_wr2x),last(u760_LBV1_wr0d5x),last(u760),last(u760_LBV1_wr2x),last(u760_LBV10_wr0d5x),last(u760_LBV10_wr1x),last(u760_LBV10_wr2x)]
c_surface_fin=[last(u860_ms_mdot4),last(u860_ms_mdot4_lbvstd_wr_0d5x),last(u860_ms_mdot4_lbvstd),last(u860_ms_mdot4_lbvstd_wr_2x),last(u860_ms_mdot4_LBV10_wr0d5x),last(u860_ms_mdot4_LBV10_wr1x),last(u860_ms_mdot4_LBV10_wr2x),last(u860_postms_5em5_wr0d5x),last(u860_postms_5em5_wr1x),last(u860_postms_5em5_wr2x),last(u860_LBV1_wr0d5x),last(u860),last(u860_LBV1_wr2x),last(u860_LBV10_wr0d5x),last(u860_LBV10_wr1x),last(u860_LBV10_wr2x)]
o_surface_fin=[last(u1260_ms_mdot4),last(u1260_ms_mdot4_lbvstd_wr_0d5x),last(u1260_ms_mdot4_lbvstd),last(u1260_ms_mdot4_lbvstd_wr_2x),last(u1260_ms_mdot4_LBV10_wr0d5x),last(u1260_ms_mdot4_LBV10_wr1x),last(u1260_ms_mdot4_LBV10_wr2x),last(u1260_postms_5em5_wr0d5x),last(u1260_postms_5em5_wr1x),last(u1260_postms_5em5_wr2x),last(u1260_LBV1_wr0d5x),last(u1260),last(u1260_LBV1_wr2x),last(u1260_LBV10_wr0d5x),last(u1260_LBV10_wr1x),last(u1260_LBV10_wr2x)]

tau_ms=[tauh_ms_mdot4,tauh_ms_mdot4_lbvstd_wr_0d5x,tauh_ms_mdot4_lbvstd,tauh_ms_mdot4_lbvstd_wr_2x,tauh_ms_mdot4_LBV10_wr0d5x,tauh_ms_mdot4_LBV10_wr1x,tauh_ms_mdot4_LBV10_wr2x,tauh_postms_5em5_wr0d5x,tauh_postms_5em5_wr1x,tauh_postms_5em5_wr2x,tauh_LBV1_wr0d5x,tauh60,tauh_LBV1_wr2x,tauh_LBV10_wr0d5x,tauh_LBV10_wr1x,tauh_LBV10_wr2x]
;tau_he=[tauhe_ms_mdot4,tauhe_ms_mdot4_lbvstd_wr_0d5x,tauhe_ms_mdot4_lbvstd,tauhe_ms_mdot4_lbvstd_wr_2x,tauhe_ms_mdot4_LBV10_wr0d5x,tauhe_ms_mdot4_LBV10_wr1x,tauhe_ms_mdot4_LBV10_wr2x,tauhe_postms_5em5_wr0d5x,tauhe_postms_5em5_wr1x,tauhe_postms_5em5_wr2x,tauhe_LBV1_wr0d5x,tauhe60,tauhe_LBV1_wr2x,tauhe_LBV10_wr0d5x,tauhe_LBV10_wr1x,tauhe_LBV10_wr2x]


print,(c_surface_fin+o_surface_fin)/he_surface_fin

;remnant and ejecta mass: 
; 1) Use last v file
; 2) strucData program
; 3) Use M_CO 75%
;remnant_mass=[

;at end of MS
;MS1    N= 4697 T*= 25903 L*= 811800 logg*= 2.694 R*= 44.86 R*(cmfgen)= 312.00 Mdot= 3.6E-05 vinf= 541 X= 0.49 Y= 0.49 C= 5.6E-05 N= 8.2E-03 O= 1.3E-04 Age= 3.5586615E+06 Mass= 36.22 R_t= 32.09 beta =2.5 Teffevol= 25903
;MS1/4  N= 4595 T*= 25138 L*= 968117 logg*= 2.760 R*= 52.02 R*(cmfgen)= 361.77 Mdot= 7.1E-06 vinf= 668 X= 0.72 Y= 0.27 C= 2.3E-03 N= 6.6E-04 O= 5.7E-03 Age= 3.4600110E+06 Mass= 56.73 R_t= 126.18 beta =1.0 Teffevol= 25138

;available  mass of H-rich layer; this owuld be the maximum amount of mass that could be lost in an LBV phase via winds+eruptions
h_mass_layer=[11.08,19.56,27.29,31.37,32.50]

msmodels=[1.,1.5,2.,4.,10.]

;max average LBV mdot, assuming tau_LBV=3.5e5
max_average_LBV_mdot=h_mass_layer/3.5e5
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,1/msmodels,h_mass_layer,color1='black',linestyle1=0,'Multiplicative factor Vink MS Mdot','H Mass at end of MS (Msun)','',xrange=[0.0,1.1],yrange=[8.75,35.],/nolabel,filename='h_mass_ms_mdot_max_lbvmdot',$
                              POSITION=[0.15,0.15,0.86,0.96],pthick=10,DOUBLE_YAXIS=1,alty_min=2.5e-5,alty_max=1e-4,$
                              rebin=1,factor=1,xreverse=0,_EXTRA=extra,cmyk=0
                              ;alt_x3=1/msmodels,alt_y3=max_average_LBV_mdot,linestyle3=2,color3='red'



END
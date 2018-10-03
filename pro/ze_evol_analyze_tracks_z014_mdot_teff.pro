;PRO ZE_EVOL_ANALYZE_TRACKS_Z014_Mdot_teff
;analyze and plot tracks for metalicity Z=0.0004, suitable for IZw18

dir='/Users/jgroh/evol_models/Grids2010/wg'
;

;model='P009z14S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar9,logg9,xmdot9,vinf9,eta_star9,Bmin9,Jdot9
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte9,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl9,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u59,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot9,return_valz
;nh9=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(xmdot9,u59,'N')
;ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth9,tendh=tendh9,modelnumber_starth=modelnumber_starth9,modelnumber_endh=modelnumber_endh9,tauh=tauh9,$
;                                    tstart_he=tstart_he9,tend_he=tend_he9,modelnumber_start_he=modelnumber_start_he9,modelnumber_end_he=modelnumber_end_he9,tau_he=tau_he9,$
;                                    tstartc=tstartc9,tendc=tendc9,modelnumber_startc=modelnumber_startc9,modelnumber_endc=modelnumber_endc9,tauc=tauc9,$
;                                    tstarto=tstarto9,tendo=tendo9,modelnumber_starto=modelnumber_starto9,modelnumber_endo=modelnumber_endo9,tauo=tauo9,$
;                                    tstartne=tstartne9,tendne=tendne9,modelnumber_startne=modelnumber_startne9,modelnumber_endne=modelnumber_endne9,taune=taune9
;
;
;model='P012z14S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar12,logg12,xmdot12,vinf12,eta_star12,Bmin12,Jdot12
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte12,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl12,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u512,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot12,return_valz
;nh12=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(xmdot12,u512,'N')
;ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth12,tendh=tendh12,modelnumber_starth=modelnumber_starth12,modelnumber_endh=modelnumber_endh12,tauh=tauh12,$
;                                    tstart_he=tstart_he12,tend_he=tend_he12,modelnumber_start_he=modelnumber_start_he12,modelnumber_end_he=modelnumber_end_he12,tau_he=tau_he12,$
;                                    tstartc=tstartc12,tendc=tendc12,modelnumber_startc=modelnumber_startc12,modelnumber_endc=modelnumber_endc12,tauc=tauc12,$
;                                    tstarto=tstarto12,tendo=tendo12,modelnumber_starto=modelnumber_starto12,modelnumber_endo=modelnumber_endo12,tauo=tauo12,$
;                                    tstartne=tstartne12,tendne=tendne12,modelnumber_startne=modelnumber_startne12,modelnumber_endne=modelnumber_endne12,taune=taune12
;                                    
;model='P015z14S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar15,logg15,xmdot15,vinf15,eta_star15,Bmin15,Jdot15
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte15,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl15,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u515,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot15,return_valz
;nh15=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(xmdot15,u515,'N')
;ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth15,tendh=tendh15,modelnumber_starth=modelnumber_starth15,modelnumber_endh=modelnumber_endh15,tauh=tauh15,$
;                                    tstart_he=tstart_he15,tend_he=tend_he15,modelnumber_start_he=modelnumber_start_he15,modelnumber_end_he=modelnumber_end_he15,tau_he=tau_he15,$
;                                    tstartc=tstartc15,tendc=tendc15,modelnumber_startc=modelnumber_startc15,modelnumber_endc=modelnumber_endc15,tauc=tauc15,$
;                                    tstarto=tstarto15,tendo=tendo15,modelnumber_starto=modelnumber_starto15,modelnumber_endo=modelnumber_endo15,tauo=tauo15,$
;                                    tstartne=tstartne15,tendne=tendne15,modelnumber_startne=modelnumber_startne15,modelnumber_endne=modelnumber_endne15,taune=taune15
;
;model='P020z14S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar20,logg20,xmdot20,vinf20,eta_star20,Bmin20,Jdot20
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte20,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl20,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u520,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u820,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot20,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u1220,return_valz
;ch20=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u820,u520,'C')
;nh20=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(xmdot20,u520,'N')
;oh20=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u1220,u520,'O')
;ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth20,tendh=tendh20,modelnumber_starth=modelnumber_starth20,modelnumber_endh=modelnumber_endh20,tauh=tauh20,$
;                                    tstart_he=tstart_he20,tend_he=tend_he20,modelnumber_start_he=modelnumber_start_he20,modelnumber_end_he=modelnumber_end_he20,tau_he=tau_he20,$
;                                    tstartc=tstartc20,tendc=tendc20,modelnumber_startc=modelnumber_startc20,modelnumber_endc=modelnumber_endc20,tauc=tauc20,$
;                                    tstarto=tstarto20,tendo=tendo20,modelnumber_starto=modelnumber_starto20,modelnumber_endo=modelnumber_endo20,tauo=tauo20,$
;                                    tstartne=tstartne20,tendne=tendne20,modelnumber_startne=modelnumber_startne20,modelnumber_endne=modelnumber_endne20,taune=taune20
;
;
;model='P023z14S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar23,logg23,xmdot23,vinf23,eta_star23,Bmin23,Jdot23
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte23,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl23,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u523,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u823,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot23,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u1223,return_valz
;ch23=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u823,u523,'C')
;nh23=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(xmdot23,u523,'N')
;oh23=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u1223,u523,'O')
;ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth23,tendh=tendh23,modelnumber_starth=modelnumber_starth23,modelnumber_endh=modelnumber_endh23,tauh=tauh23,$
;                                    tstart_he=tstart_he23,tend_he=tend_he23,modelnumber_start_he=modelnumber_start_he23,modelnumber_end_he=modelnumber_end_he23,tau_he=tau_he23,$
;                                    tstartc=tstartc23,tendc=tendc23,modelnumber_startc=modelnumber_startc23,modelnumber_endc=modelnumber_endc23,tauc=tauc23,$
;                                    tstarto=tstarto23,tendo=tendo23,modelnumber_starto=modelnumber_starto23,modelnumber_endo=modelnumber_endo23,tauo=tauo23,$
;                                    tstartne=tstartne23,tendne=tendne23,modelnumber_startne=modelnumber_startne23,modelnumber_endne=modelnumber_endne23,taune=taune23
;
;
;model='P025z14S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar25,logg25,xmdot25,vinf25,eta_star25,Bmin25,Jdot25
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte25,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl25,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u525,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot25,return_valz
;nh25=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(xmdot25,u525,'N')
;ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth25,tendh=tendh25,modelnumber_starth=modelnumber_starth25,modelnumber_endh=modelnumber_endh25,tauh=tauh25,$
;                                    tstart_he=tstart_he25,tend_he=tend_he25,modelnumber_start_he=modelnumber_start_he25,modelnumber_end_he=modelnumber_end_he25,tau_he=tau_he25,$
;                                    tstartc=tstartc25,tendc=tendc25,modelnumber_startc=modelnumber_startc25,modelnumber_endc=modelnumber_endc25,tauc=tauc25,$
;                                    tstarto=tstarto25,tendo=tendo25,modelnumber_starto=modelnumber_starto25,modelnumber_endo=modelnumber_endo25,tauo=tauo25,$
;                                    tstartne=tstartne25,tendne=tendne25,modelnumber_startne=modelnumber_startne25,modelnumber_endne=modelnumber_endne25,taune=taune25
;
;
;model='P032z14S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar32,logg32,xmdot32,vinf32,eta_star32,Bmin32,Jdot32
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte32,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl32,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u532,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot32,return_valz
;nh32=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(xmdot32,u532,'N')
;ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth32,tendh=tendh32,modelnumber_starth=modelnumber_starth32,modelnumber_endh=modelnumber_endh32,tauh=tauh32,$
;                                    tstart_he=tstart_he32,tend_he=tend_he32,modelnumber_start_he=modelnumber_start_he32,modelnumber_end_he=modelnumber_end_he32,tau_he=tau_he32,$
;                                    tstartc=tstartc32,tendc=tendc32,modelnumber_startc=modelnumber_startc32,modelnumber_endc=modelnumber_endc32,tauc=tauc32,$
;                                    tstarto=tstarto32,tendo=tendo32,modelnumber_starto=modelnumber_starto32,modelnumber_endo=modelnumber_endo32,tauo=tauo32,$
;                                    tstartne=tstartne32,tendne=tendne32,modelnumber_startne=modelnumber_startne32,modelnumber_endne=modelnumber_endne32,taune=taune32
;
;model='P040z14S0_new'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar40,logg40,xmdot40,vinf40,eta_star40,Bmin40,Jdot40
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte40,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl40,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u540,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot40,return_valz
;nh40=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(xmdot40,u540,'N')
;ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth40,tendh=tendh40,modelnumber_starth=modelnumber_starth40,modelnumber_endh=modelnumber_endh40,tauh=tauh40,$
;                                    tstart_he=tstart_he40,tend_he=tend_he40,modelnumber_start_he=modelnumber_start_he40,modelnumber_end_he=modelnumber_end_he40,tau_he=tau_he40,$
;                                    tstartc=tstartc40,tendc=tendc40,modelnumber_startc=modelnumber_startc40,modelnumber_endc=modelnumber_endc40,tauc=tauc40,$
;                                    tstarto=tstarto40,tendo=tendo40,modelnumber_starto=modelnumber_starto40,modelnumber_endo=modelnumber_endo40,tauo=tauo40,$
;                                    tstartne=tstartne40,tendne=tendne40,modelnumber_startne=modelnumber_startne40,modelnumber_endne=modelnumber_endne40,taune=taune40
;
;
;model='P050z14S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar50,logg50,xmdot50,vinf50,eta_star50,Bmin50,Jdot50
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte50,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl50,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u550,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot50,return_valz
;nh50=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(xmdot50,u550,'N')
;ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth50,tendh=tendh50,modelnumber_starth=modelnumber_starth50,modelnumber_endh=modelnumber_endh50,tauh=tauh50,$
;                                    tstart_he=tstart_he50,tend_he=tend_he50,modelnumber_start_he=modelnumber_start_he50,modelnumber_end_he=modelnumber_end_he50,tau_he=tau_he50,$
;                                    tstartc=tstartc50,tendc=tendc50,modelnumber_startc=modelnumber_startc50,modelnumber_endc=modelnumber_endc50,tauc=tauc50,$
;                                    tstarto=tstarto50,tendo=tendo50,modelnumber_starto=modelnumber_starto50,modelnumber_endo=modelnumber_endo50,tauo=tauo50,$
;                                    tstartne=tstartne50,tendne=tendne50,modelnumber_startne=modelnumber_startne50,modelnumber_endne=modelnumber_endne50,taune=taune50
;
;model='P060z14S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload 
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60,logg60,xmdot60,vinf60,eta_star60,Bmin60,Jdot60
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte60,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl60,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u560,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot60,return_valz
;nh60=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(xmdot60,u560,'N')
;ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth60,tendh=tendh60,modelnumber_starth=modelnumber_starth60,modelnumber_endh=modelnumber_endh60,tauh=tauh60,$
;                                    tstart_he=tstart_he60,tend_he=tend_he60,modelnumber_start_he=modelnumber_start_he60,modelnumber_end_he=modelnumber_end_he60,tau_he=tau_he60,$
;                                    tstartc=tstartc60,tendc=tendc60,modelnumber_startc=modelnumber_startc60,modelnumber_endc=modelnumber_endc60,tauc=tauc60,$
;                                    tstarto=tstarto60,tendo=tendo60,modelnumber_starto=modelnumber_starto60,modelnumber_endo=modelnumber_endo60,tauo=tauo60,$
;                                    tstartne=tstartne60,tendne=tendne60,modelnumber_startne=modelnumber_startne60,modelnumber_endne=modelnumber_endne60,taune=taune60
;
;
;model='P085z14S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar85,logg85,xmdot85,vinf85,eta_star85,Bmin85,Jdot85
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte85,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl85,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u585,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot85,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc85,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'rapomm',data_wgfile_cut,rapomm85,return_valz
;nh85=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(xmdot85,u585,'N')
;ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth85,tendh=tendh85,modelnumber_starth=modelnumber_starth85,modelnumber_endh=modelnumber_endh85,tauh=tauh85,$
;                                    tstart_he=tstart_he85,tend_he=tend_he85,modelnumber_start_he=modelnumber_start_he85,modelnumber_end_he=modelnumber_end_he85,tau_he=tau_he85,$
;                                    tstartc=tstartc85,tendc=tendc85,modelnumber_startc=modelnumber_startc85,modelnumber_endc=modelnumber_endc85,tauc=tauc85,$
;                                    tstarto=tstarto85,tendo=tendo85,modelnumber_starto=modelnumber_starto85,modelnumber_endo=modelnumber_endo85,tauo=tauo85,$
;                                    tstartne=tstartne85,tendne=tendne85,modelnumber_startne=modelnumber_startne85,modelnumber_endne=modelnumber_endne85,taune=taune85
;                                    
;model='P120z14S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar120,logg120,xmdot120,vinf120,eta_star120,Bmin120,Jdot120
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte120,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl120,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5120,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot120,return_valz   
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc120,return_valz 
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'rapomm',data_wgfile_cut,rapomm120,return_valz
;nh120=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(xmdot120,u5120,'N')
;ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth120,tendh=tendh120,modelnumber_starth=modelnumber_starth120,modelnumber_endh=modelnumber_endh120,tauh=tauh120,$
;                                    tstart_he=tstart_he120,tend_he=tend_he120,modelnumber_start_he=modelnumber_start_he120,modelnumber_end_he=modelnumber_end_he120,tau_he=tau_he120,$
;                                    tstartc=tstartc120,tendc=tendc120,modelnumber_startc=modelnumber_startc120,modelnumber_endc=modelnumber_endc120,tauc=tauc120,$
;                                    tstarto=tstarto120,tendo=tendo120,modelnumber_starto=modelnumber_starto120,modelnumber_endo=modelnumber_endo120,tauo=tauo120,$
;                                    tstartne=tstartne120,tendne=tendne120,modelnumber_startne=modelnumber_startne120,modelnumber_endne=modelnumber_endne120,taune=taune120
;
;model='P009z14S4'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar94,logg94,xmdot94,vinf94,eta_star94,Bmin94,Jdot94
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte94,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl94,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u594,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot94,return_valz
;nh94=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(xmdot94,u594,'N')
;ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth94,tendh=tendh94,modelnumber_starth=modelnumber_starth94,modelnumber_endh=modelnumber_endh94,tauh=tauh94,$
;                                    tstart_he=tstart_he94,tend_he=tend_he94,modelnumber_start_he=modelnumber_start_he94,modelnumber_end_he=modelnumber_end_he94,tau_he=tau_he94,$
;                                    tstartc=tstartc94,tendc=tendc94,modelnumber_startc=modelnumber_startc94,modelnumber_endc=modelnumber_endc94,tauc=tauc94,$
;                                    tstarto=tstarto94,tendo=tendo94,modelnumber_starto=modelnumber_starto94,modelnumber_endo=modelnumber_endo94,tauo=tauo94,$
;                                    tstartne=tstartne94,tendne=tendne94,modelnumber_startne=modelnumber_startne94,modelnumber_endne=modelnumber_endne94,taune=taune94
;
;
;model='P012z14S4'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar124,logg124,xmdot124,vinf124,eta_star124,Bmin124,Jdot124
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte124,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl124,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5124,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot124,return_valz
;nh124=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(xmdot124,u5124,'N')
;ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth124,tendh=tendh124,modelnumber_starth=modelnumber_starth124,modelnumber_endh=modelnumber_endh124,tauh=tauh124,$
;                                    tstart_he=tstart_he124,tend_he=tend_he124,modelnumber_start_he=modelnumber_start_he124,modelnumber_end_he=modelnumber_end_he124,tau_he=tau_he124,$
;                                    tstartc=tstartc124,tendc=tendc124,modelnumber_startc=modelnumber_startc124,modelnumber_endc=modelnumber_endc124,tauc=tauc124,$
;                                    tstarto=tstarto124,tendo=tendo124,modelnumber_starto=modelnumber_starto124,modelnumber_endo=modelnumber_endo124,tauo=tauo124,$
;                                    tstartne=tstartne124,tendne=tendne124,modelnumber_startne=modelnumber_startne124,modelnumber_endne=modelnumber_endne124,taune=taune124
;                                    
;model='P015z14S4'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar154,logg154,xmdot154,vinf154,eta_star154,Bmin154,Jdot154
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte154,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl154,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5154,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot154,return_valz
;nh154=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(xmdot154,u5154,'N')
;ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth154,tendh=tendh154,modelnumber_starth=modelnumber_starth154,modelnumber_endh=modelnumber_endh154,tauh=tauh154,$
;                                    tstart_he=tstart_he154,tend_he=tend_he154,modelnumber_start_he=modelnumber_start_he154,modelnumber_end_he=modelnumber_end_he154,tau_he=tau_he154,$
;                                    tstartc=tstartc154,tendc=tendc154,modelnumber_startc=modelnumber_startc154,modelnumber_endc=modelnumber_endc154,tauc=tauc154,$
;                                    tstarto=tstarto154,tendo=tendo154,modelnumber_starto=modelnumber_starto154,modelnumber_endo=modelnumber_endo154,tauo=tauo154,$
;                                    tstartne=tstartne154,tendne=tendne154,modelnumber_startne=modelnumber_startne154,modelnumber_endne=modelnumber_endne154,taune=taune154
;
;model='P020z14S4'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar204,logg204,xmdot204,vinf204,eta_star204,Bmin204,Jdot204
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte204,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl204,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5204,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot204,return_valz
;nh204=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(xmdot204,u5204,'N')
;ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth204,tendh=tendh204,modelnumber_starth=modelnumber_starth204,modelnumber_endh=modelnumber_endh204,tauh=tauh204,$
;                                    tstart_he=tstart_he204,tend_he=tend_he204,modelnumber_start_he=modelnumber_start_he204,modelnumber_end_he=modelnumber_end_he204,tau_he=tau_he204,$
;                                    tstartc=tstartc204,tendc=tendc204,modelnumber_startc=modelnumber_startc204,modelnumber_endc=modelnumber_endc204,tauc=tauc204,$
;                                    tstarto=tstarto204,tendo=tendo204,modelnumber_starto=modelnumber_starto204,modelnumber_endo=modelnumber_endo204,tauo=tauo204,$
;                                    tstartne=tstartne204,tendne=tendne204,modelnumber_startne=modelnumber_startne204,modelnumber_endne=modelnumber_endne204,taune=taune204
;
;model='P018z14S4'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar184,logg184,xmdot184,vinf184,eta_star184,Bmin184,Jdot184
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte184,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl184,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5184,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot184,return_valz
;nh184=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(xmdot184,u5184,'N')
;ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth184,tendh=tendh184,modelnumber_starth=modelnumber_starth184,modelnumber_endh=modelnumber_endh184,tauh=tauh184,$
;                                    tstart_he=tstart_he184,tend_he=tend_he184,modelnumber_start_he=modelnumber_start_he184,modelnumber_end_he=modelnumber_end_he184,tau_he=tau_he184,$
;                                    tstartc=tstartc184,tendc=tendc184,modelnumber_startc=modelnumber_startc184,modelnumber_endc=modelnumber_endc184,tauc=tauc184,$
;                                    tstarto=tstarto184,tendo=tendo184,modelnumber_starto=modelnumber_starto184,modelnumber_endo=modelnumber_endo184,tauo=tauo184,$
;                                    tstartne=tstartne184,tendne=tendne184,modelnumber_startne=modelnumber_startne184,modelnumber_endne=modelnumber_endne184,taune=taune184
;
;model='P025z14S4'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar254,logg254,xmdot254,vinf254,eta_star254,Bmin254,Jdot254
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte254,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl254,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5254,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot254,return_valz
;nh254=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(xmdot254,u5254,'N')
;ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth254,tendh=tendh254,modelnumber_starth=modelnumber_starth254,modelnumber_endh=modelnumber_endh254,tauh=tauh254,$
;                                    tstart_he=tstart_he254,tend_he=tend_he254,modelnumber_start_he=modelnumber_start_he254,modelnumber_end_he=modelnumber_end_he254,tau_he=tau_he254,$
;                                    tstartc=tstartc254,tendc=tendc254,modelnumber_startc=modelnumber_startc254,modelnumber_endc=modelnumber_endc254,tauc=tauc254,$
;                                    tstarto=tstarto254,tendo=tendo254,modelnumber_starto=modelnumber_starto254,modelnumber_endo=modelnumber_endo254,tauo=tauo254,$
;                                    tstartne=tstartne254,tendne=tendne254,modelnumber_startne=modelnumber_startne254,modelnumber_endne=modelnumber_endne254,taune=taune254
;
;model='P028z14S4'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar284,logg284,xmdot284,vinf284,eta_star284,Bmin284,Jdot284
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte284,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl284,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5284,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot284,return_valz
;nh284=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(xmdot284,u5284,'N')
;ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth284,tendh=tendh284,modelnumber_starth=modelnumber_starth284,modelnumber_endh=modelnumber_endh284,tauh=tauh284,$
;                                    tstart_he=tstart_he284,tend_he=tend_he284,modelnumber_start_he=modelnumber_start_he284,modelnumber_end_he=modelnumber_end_he284,tau_he=tau_he284,$
;                                    tstartc=tstartc284,tendc=tendc284,modelnumber_startc=modelnumber_startc284,modelnumber_endc=modelnumber_endc284,tauc=tauc284,$
;                                    tstarto=tstarto284,tendo=tendo284,modelnumber_starto=modelnumber_starto284,modelnumber_endo=modelnumber_endo284,tauo=tauo284,$
;                                    tstartne=tstartne284,tendne=tendne284,modelnumber_startne=modelnumber_startne284,modelnumber_endne=modelnumber_endne284,taune=taune284
;
;model='P032z14S4'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar324,logg324,xmdot324,vinf324,eta_star324,Bmin324,Jdot324
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte324,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl324,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5324,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot324,return_valz
;nh324=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(xmdot324,u5324,'N')
;ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth324,tendh=tendh324,modelnumber_starth=modelnumber_starth324,modelnumber_endh=modelnumber_endh324,tauh=tauh324,$
;                                    tstart_he=tstart_he324,tend_he=tend_he324,modelnumber_start_he=modelnumber_start_he324,modelnumber_end_he=modelnumber_end_he324,tau_he=tau_he324,$
;                                    tstartc=tstartc324,tendc=tendc324,modelnumber_startc=modelnumber_startc324,modelnumber_endc=modelnumber_endc324,tauc=tauc324,$
;                                    tstarto=tstarto324,tendo=tendo324,modelnumber_starto=modelnumber_starto324,modelnumber_endo=modelnumber_endo324,tauo=tauo324,$
;                                    tstartne=tstartne324,tendne=tendne324,modelnumber_startne=modelnumber_startne324,modelnumber_endne=modelnumber_endne324,taune=taune324
;                                    
;model='P040z14S4'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar404,logg404,xmdot404,vinf404,eta_star404,Bmin404,Jdot404
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte404,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl404,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5404,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot404,return_valz
;nh404=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(xmdot404,u5404,'N')
;ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth404,tendh=tendh404,modelnumber_starth=modelnumber_starth404,modelnumber_endh=modelnumber_endh404,tauh=tauh404,$
;                                    tstart_he=tstart_he404,tend_he=tend_he404,modelnumber_start_he=modelnumber_start_he404,modelnumber_end_he=modelnumber_end_he404,tau_he=tau_he404,$
;                                    tstartc=tstartc404,tendc=tendc404,modelnumber_startc=modelnumber_startc404,modelnumber_endc=modelnumber_endc404,tauc=tauc404,$
;                                    tstarto=tstarto404,tendo=tendo404,modelnumber_starto=modelnumber_starto404,modelnumber_endo=modelnumber_endo404,tauo=tauo404,$
;                                    tstartne=tstartne404,tendne=tendne404,modelnumber_startne=modelnumber_startne404,modelnumber_endne=modelnumber_endne404,taune=taune404
;                                    
;model='P060z14S4'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload 
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar604,logg604,xmdot604,vinf604,eta_star604,Bmin604,Jdot604
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte604,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl604,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5604,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot604,return_valz
;nh604=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(xmdot604,u5604,'N')
;ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth604,tendh=tendh604,modelnumber_starth=modelnumber_starth604,modelnumber_endh=modelnumber_endh604,tauh=tauh604,$
;                                    tstart_he=tstart_he604,tend_he=tend_he604,modelnumber_start_he=modelnumber_start_he604,modelnumber_end_he=modelnumber_end_he604,tau_he=tau_he604,$
;                                    tstartc=tstartc604,tendc=tendc604,modelnumber_startc=modelnumber_startc604,modelnumber_endc=modelnumber_endc604,tauc=tauc604,$
;                                    tstarto=tstarto604,tendo=tendo604,modelnumber_starto=modelnumber_starto604,modelnumber_endo=modelnumber_endo604,tauo=tauo604,$
;                                    tstartne=tstartne604,tendne=tendne604,modelnumber_startne=modelnumber_startne604,modelnumber_endne=modelnumber_endne604,taune=taune604
;                                    
;model='P085z14S4'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar854,logg854,xmdot854,vinf854,eta_star854,Bmin854,Jdot854
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte854,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl854,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5854,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot854,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc854,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'rapomm',data_wgfile_cut,rapomm854,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'vequam',data_wgfile_cut,vequam854,return_valz
;;nh854=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(xmdot854,u5854,'N')
;ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth854,tendh=tendh854,modelnumber_starth=modelnumber_starth854,modelnumber_endh=modelnumber_endh854,tauh=tauh854,$
;                                    tstart_he=tstart_he854,tend_he=tend_he854,modelnumber_start_he=modelnumber_start_he854,modelnumber_end_he=modelnumber_end_he854,tau_he=tau_he854,$
;                                    tstartc=tstartc854,tendc=tendc854,modelnumber_startc=modelnumber_startc854,modelnumber_endc=modelnumber_endc854,tauc=tauc854,$
;                                    tstarto=tstarto854,tendo=tendo854,modelnumber_starto=modelnumber_starto854,modelnumber_endo=modelnumber_endo854,tauo=tauo854,$
;                                    tstartne=tstartne854,tendne=tendne854,modelnumber_startne=modelnumber_startne854,modelnumber_endne=modelnumber_endne854,taune=taune854
;
;model='P120z14S4'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar1204,logg1204,xmdot1204,vinf1204,eta_star1204,Bmin1204,Jdot1204
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte1204,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl1204,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u51204,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot1204,return_valz  
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc1204,return_valz  
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'rapomm',data_wgfile_cut,rapomm1204,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'vequam',data_wgfile_cut,vequam1204,return_valz
;;nh1204=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(xmdot1204,u51204,'N')
;ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth124,tendh=tendh124,modelnumber_starth=modelnumber_starth124,modelnumber_endh=modelnumber_endh124,tauh=tauh124,$
;                                    tstart_he=tstart_he124,tend_he=tend_he124,modelnumber_start_he=modelnumber_start_he124,modelnumber_end_he=modelnumber_end_he124,tau_he=tau_he124,$
;                                    tstartc=tstartc124,tendc=tendc124,modelnumber_startc=modelnumber_startc124,modelnumber_endc=modelnumber_endc124,tauc=tauc124,$
;                                    tstarto=tstarto124,tendo=tendo124,modelnumber_starto=modelnumber_starto124,modelnumber_endo=modelnumber_endo124,tauo=tauo124,$
;                                    tstartne=tstartne124,tendne=tendne124,modelnumber_startne=modelnumber_startne124,modelnumber_endne=modelnumber_endne124,taune=taune124
;
;save,/all,filename='/Users/jgroh/temp/ze_evol_analyze_tracks_z014_for_mdot_teff.sav'
;STOP
restore,'/Users/jgroh/temp/ze_evol_analyze_tracks_z014_for_mdot_teff.sav'


            
;Mdot x Teff for non rotating models between 12 and 150 Msun, all lifetime
symcolorpoints2=['black','red','blue','charcoal','dark green','orange','cyan','chocolate','purple','magenta','green','dark grey']
symcolorpoints3=['black','red','blue','charcoal','dark green','orange','cyan','chocolate','purple','magenta','green','dark grey']
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,10^xte120,10^xmdot120,'Effective Temperature (K)','Mass-loss rate (Msun/yr)','',filename='all_mdot_teff3',$
                                x2=10^xte85,y2=10^xmdot85,x3=10^xte60,y3=10^xmdot60,x4=10^xte40,y4=10^xmdot40,x5=10^xte32,y5=10^xmdot32,x6=10^xte25,y6=10^xmdot25,$
                                x7=10^xte20,y7=10^xmdot20,x8=10^xte15,y8=10^xmdot15,x9=10^xte12,y9=10^xmdot12,x10=10^xte9,y10=10^xmdot9,$
                                x11=10^xte50,y11=10^xmdot50,x12=10^xte23,y12=10^xmdot23,/ylog,/xlog,xrange=[250000.,3000.],yrange=[1e-10,2e-2],xreverse=0,_EXTRA=extra,rebin=1,factor=5.0,$
                                linestyle2=1,linestyle3=2,linestyle4=3,linestyle5=0,linestyle6=1,linestyle7=2,linestyle8=3,linestyle9=0,linestyle_10=1,linestyle_11=2,linestyle_12=3

;Mdot x Teff for non rotating models between 12 and 150 Msun, ONLY MS all models
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,10^xte120[modelnumber_starth120:modelnumber_endh120],10^xmdot120[modelnumber_starth120:modelnumber_endh120],'Effective Temperature (K)','Mass-loss rate (Msun/yr)','',filename='ms_mdot_teff3',$
                                x2=10^xte85[modelnumber_starth85:modelnumber_endh85],y2=10^xmdot85[modelnumber_starth85:modelnumber_endh85],$
                                x3=10^xte60[modelnumber_starth60:modelnumber_endh60],y3=10^xmdot60[modelnumber_starth60:modelnumber_endh60],$
                                x4=10^xte40[modelnumber_starth40:modelnumber_endh40],y4=10^xmdot40[modelnumber_starth40:modelnumber_endh40],$
                                x5=10^xte32[modelnumber_starth32:modelnumber_endh32],y5=10^xmdot32[modelnumber_starth32:modelnumber_endh32],$
                                x6=10^xte25[modelnumber_starth25:modelnumber_endh25],y6=10^xmdot25[modelnumber_starth25:modelnumber_endh25],$
                                x7=10^xte20[modelnumber_starth20:modelnumber_endh20],y7=10^xmdot20[modelnumber_starth20:modelnumber_endh20],$
                                x8=10^xte15[modelnumber_starth15:modelnumber_endh15],y8=10^xmdot15[modelnumber_starth15:modelnumber_endh15],$
                                x9=10^xte12[modelnumber_starth12:modelnumber_endh12],y9=10^xmdot12[modelnumber_starth12:modelnumber_endh12],$
                                x10=10^xte9[modelnumber_starth9:modelnumber_endh9],y10=10^xmdot9[modelnumber_starth9:modelnumber_endh9],$
                                x11=10^xte50[modelnumber_starth50:modelnumber_endh50],y11=10^xmdot50[modelnumber_starth50:modelnumber_endh50],$
                                x12=10^xte23[modelnumber_starth23:modelnumber_endh23],y12=10^xmdot23[modelnumber_starth23:modelnumber_endh23],$
                                /ylog,/xlog,xrange=[250000.,3000.],yrange=[1e-10,2e-2],xreverse=0,_EXTRA=extra,rebin=1,factor=5.0,$
                                linestyle2=1,linestyle3=2,linestyle4=3,linestyle5=0,linestyle6=1,linestyle7=2,linestyle8=3,linestyle9=0,linestyle_10=1,linestyle_11=2,linestyle_12=3

;Mdot x Teff for non rotating models between 12 and 150 Msun, ONLY MS massive star models
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,10^xte120,10^xmdot120,'Effective Temperature (K)','Mass-loss rate (Msun/yr)','',filename='ms_mdot_teff3',$
                                x2=10^xte85[modelnumber_starth85:modelnumber_endh85],y2=10^xmdot85[modelnumber_starth85:modelnumber_endh85],$
                                x3=10^xte60[modelnumber_starth60:modelnumber_endh60],y3=10^xmdot60[modelnumber_starth60:modelnumber_endh60],$
                                x4=10^xte40[modelnumber_starth40:modelnumber_endh40],y4=10^xmdot40[modelnumber_starth40:modelnumber_endh40],$
                                x5=10^xte32[modelnumber_starth32:modelnumber_endh32],y5=10^xmdot32[modelnumber_starth32:modelnumber_endh32],$
                                x6=10^xte25[modelnumber_starth25:modelnumber_endh25],y6=10^xmdot25[modelnumber_starth25:modelnumber_endh25],$
                                x7=10^xte20[modelnumber_starth20:modelnumber_endh20],y7=10^xmdot20[modelnumber_starth20:modelnumber_endh20],$
                                x8=10^xte15,y8=10^xmdot15,$
                                x9=10^xte12,y9=10^xmdot12,$
                                x10=10^xte9,y10=10^xmdot9,$
                                x11=10^xte50[modelnumber_starth50:modelnumber_endh50],y11=10^xmdot50[modelnumber_starth50:modelnumber_endh50],$
                                x12=10^xte23[modelnumber_starth23:modelnumber_endh23],y12=10^xmdot23[modelnumber_starth23:modelnumber_endh23],$
                                /ylog,/xlog,xrange=[250000.,3000.],yrange=[1e-10,2e-2],xreverse=0,_EXTRA=extra,rebin=1,factor=25.0,pthick=9,$
                                linestyle2=0,linestyle3=0,linestyle4=0,linestyle5=0,linestyle6=0,linestyle7=0,linestyle8=0,linestyle9=0,linestyle_10=0,linestyle_11=0,linestyle_12=0


END
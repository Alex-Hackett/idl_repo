;PRO ZE_EVOL_ANALYZE_TRACKS_Z014
;analyze and plot tracks for metalicity Z=0.0004, suitable for IZw18

dir='/Users/jgroh/evol_models/Grids2010/wg'
;

;model='P009z14S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar9,logg9,u109,vinf9,eta_star9,Bmin9,Jdot9
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte9,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl9,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u59,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u109,return_valz
;nh9=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u109,u59,'N')
;
;model='P012z14S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar12,logg12,u1012,vinf12,eta_star12,Bmin12,Jdot12
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte12,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl12,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u512,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1012,return_valz
;nh12=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u1012,u512,'N')
;
;model='P015z14S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar15,logg15,u1015,vinf15,eta_star15,Bmin15,Jdot15
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte15,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl15,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u515,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1015,return_valz
;nh15=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u1015,u515,'N')

;
;model='P020z14S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar20,logg20,u1020,vinf20,eta_star20,Bmin20,Jdot20
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte20,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl20,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u520,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u820,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1020,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u1220,return_valz
;ch20=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u820,u520,'C')
;nh20=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u1020,u520,'N')
;oh20=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u1220,u520,'O')
;;
;
;
;model='P023z14S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar23,logg23,u1023,vinf23,eta_star23,Bmin23,Jdot23
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte23,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl23,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u523,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u823,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1023,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u1223,return_valz
;ch23=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u823,u523,'C')
;nh23=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u1023,u523,'N')
;oh23=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u1223,u523,'O')
;;
;
;
;model='P025z14S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar25,logg25,u1025,vinf25,eta_star25,Bmin25,Jdot25
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte25,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl25,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u525,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1025,return_valz
;nh25=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u1025,u525,'N')
;
;model='P032z14S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar32,logg32,u1032,vinf32,eta_star32,Bmin32,Jdot32
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte32,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl32,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u532,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1032,return_valz
;nh32=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u1032,u532,'N')
;
;model='P040z14S0_new'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar40,logg40,u1040,vinf40,eta_star40,Bmin40,Jdot40
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte40,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl40,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u540,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1040,return_valz
;nh40=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u1040,u540,'N')
;
;model='P050z14S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar50,logg50,u1050,vinf50,eta_star50,Bmin50,Jdot50
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte50,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl50,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u550,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1050,return_valz
;nh50=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u1050,u550,'N')
;
;model='P060z14S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload 
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60,logg60,u1060,vinf60,eta_star60,Bmin60,Jdot60
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte60,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl60,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u560,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1060,return_valz
;nh60=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u1060,u560,'N')
;
;model='P085z14S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar85,logg85,u1085,vinf85,eta_star85,Bmin85,Jdot85
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte85,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl85,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u585,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1085,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc85,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'rapomm',data_wgfile_cut,rapomm85,return_valz
;nh85=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u1085,u585,'N')
;
;model='P120z14S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar120,logg120,u10120,vinf120,eta_star120,Bmin120,Jdot120
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte120,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl120,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5120,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10120,return_valz   
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc120,return_valz 
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'rapomm',data_wgfile_cut,rapomm120,return_valz
;nh120=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u10120,u5120,'N')
;
;
;model='P009z14S4'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar94,logg94,u1094,vinf94,eta_star94,Bmin94,Jdot94
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte94,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl94,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u594,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1094,return_valz
;nh94=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u1094,u594,'N')
;
;model='P012z14S4'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar124,logg124,u10124,vinf124,eta_star124,Bmin124,Jdot124
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte124,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl124,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5124,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10124,return_valz
;nh124=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u10124,u5124,'N')
;
;model='P015z14S4'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar154,logg154,u10154,vinf154,eta_star154,Bmin154,Jdot154
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte154,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl154,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5154,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10154,return_valz
;nh154=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u10154,u5154,'N')
;
;
;model='P020z14S4'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar204,logg204,u10204,vinf204,eta_star204,Bmin204,Jdot204
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte204,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl204,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5204,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10204,return_valz
;nh204=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u10204,u5204,'N')
;
;
;model='P018z14S4'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar184,logg184,u10184,vinf184,eta_star184,Bmin184,Jdot184
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte184,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl184,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5184,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10184,return_valz
;nh184=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u10184,u5184,'N')
;
;model='P025z14S4'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar254,logg254,u10254,vinf254,eta_star254,Bmin254,Jdot254
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte254,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl254,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5254,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10254,return_valz
;nh254=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u10254,u5254,'N')
;
;
;model='P028z14S4'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar284,logg284,u10284,vinf284,eta_star284,Bmin284,Jdot284
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte284,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl284,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5284,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10284,return_valz
;nh284=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u10284,u5284,'N')
;
;
;model='P032z14S4'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar324,logg324,u10324,vinf324,eta_star324,Bmin324,Jdot324
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte324,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl324,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5324,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10324,return_valz
;nh324=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u10324,u5324,'N')
;
;model='P040z14S4'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar404,logg404,u10404,vinf404,eta_star404,Bmin404,Jdot404
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte404,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl404,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5404,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10404,return_valz
;nh404=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u10404,u5404,'N')
;
;model='P060z14S4'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload 
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar604,logg604,u10604,vinf604,eta_star604,Bmin604,Jdot604
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte604,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl604,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5604,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10604,return_valz
;nh604=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u10604,u5604,'N')
;
;model='P085z14S4'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar854,logg854,u10854,vinf854,eta_star854,Bmin854,Jdot854
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte854,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl854,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5854,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10854,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc854,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'rapomm',data_wgfile_cut,rapomm854,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'vequam',data_wgfile_cut,vequam854,return_valz
;;nh854=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u10854,u5854,'N')
;
;model='P120z14S4'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar1204,logg1204,u101204,vinf1204,eta_star1204,Bmin1204,Jdot1204
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte1204,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl1204,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u51204,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u101204,return_valz  
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc1204,return_valz  
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'rapomm',data_wgfile_cut,rapomm1204,return_valz
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'vequam',data_wgfile_cut,vequam1204,return_valz
;;nh1204=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u101204,u51204,'N')

restore,'/Users/jgroh/temp/ze_evol_analyze_tracks_z014_for_sn_prog_paper_all.sav'


label='Z=0.014'    
;HR diagram for non rotating models between 12 and 150 Msun, color coded with [N/H]
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xtt120,xl120,'xtt','xl',label,z1=nh120,labelz='N_H',x2=xtt85,y2=xl85,z2=nh85,x3=xtt40,y3=xl40,z3=nh40,x4=xtt32,y4=xl32,z4=nh32,x5=xtt25,y5=xl25,z5=nh25,x6=xtt20,y6=xl20,z6=nh20,x7=xtt12,y7=xl12,z7=nh12,x8=xtt60,y8=xl60,z8=nh60,x9=xtt15,y9=xl15,z9=nh15,x10=xtt150,y10=xl150,z_10=nh150,$
;                              minz=6.25,maxz=7.75,rebin=1,xrange=[4.93,3.58],yrange=[3.78,6.83],xreverse=0,_EXTRA=extra

;HR diagram for rotating and non rotating models of 20, 85, 120 Msun, color coded with [N/H]
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xtt120,xl120,'xtt','xl',label,z1=nh120,labelz='N_H',x2=xtt85,y2=xl85,z2=nh85,x3=xtt1204,y3=xl1204,z3=nh1204,x4=xtt854,y4=xl854,z4=nh854,x5=xtt204,y5=xl204,z5=nh204,x6=xtt20,y6=xl20,z6=nh20,$
;                              minz=6.25,maxz=7.75,rebin=1,xrange=[4.93,3.58],yrange=[3.78,6.83],xreverse=0,_EXTRA=extra

;HR diagram for rotating and non rotating models of 85 and 120 Msun, color coded with [N/H]
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xtt120,xl120,'xtt','xl',label,z1=nh120,labelz='N_H',x2=xtt85,y2=xl85,z2=nh85,x3=xtt1204,y3=xl1204,z3=nh1204,x4=xtt854,y4=xl854,z4=nh854,$
                              ;minz=6.25,maxz=7.75,rebin=1,xreverse=1,_EXTRA=extra
                              
;HR diagram for rotating and non rotating models of 85 and 120 Msun, color coded with qmnc (mass fraction of the convective core)
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xtt120,xl120,'xtt','xl',label,z1=qmnc120,labelz='qmnc',x2=xtt85,y2=xl85,z2=qmnc85,x3=xtt1204,y3=xl1204,z3=qmnc1204,x4=xtt854,y4=xl854,z4=qmnc854,$
;                              minz=0,maxz=0.8,rebin=1,xreverse=1,_EXTRA=extra

;HR diagram for rotating and non rotating models of 85 and 120 Msun, color coded with qmnc (mass fraction of the convective core)
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xtt120,xl120,'xtt','xl',label,z1=rapomm120,labelz='rapomm',x2=xtt85,y2=xl85,z2=rapomm85,x3=xtt1204,y3=xl1204,z3=rapomm1204,x4=xtt854,y4=xl854,z4=rapomm854,$
 ;                             minz=0,maxz=1.0,rebin=1,xreverse=1,_EXTRA=extra
                              
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xtt85,qmnc85,'xtt','qmnc',label,x2=xtt854,y2=qmnc854,xrange=[4.8,4.5],rebin=1
;


xtefinnorot=[xte120[n_elements(xte120)-1],xte85[n_elements(xte85)-1],xte60[n_elements(xte60)-1],xte50[n_elements(xte50)-1],xte40[n_elements(xte40)-1],xte32[n_elements(xte32)-1],$
            xte25[n_elements(xte25)-1],xte23[n_elements(xte23)-1],xte20[n_elements(xte20)-1],xte15[n_elements(xte15)-1],xte12[n_elements(xte12)-1],xte9[n_elements(xte9)-1]]
            
tcmfgenfinnorot=[3480,3556,3571,3741,4410,26330,40480,40006,161200,164600,166900,145100]          
tcmfgenfinnorot=reverse(tcmfgenfinnorot)
            
xlfinnorot=[xl120[n_elements(xl120)-1],xl85[n_elements(xl85)-1],xl60[n_elements(xl60)-1],xl50[n_elements(xl50)-1],xl40[n_elements(xl40)-1],xl32[n_elements(xl32)-1],$
            xl25[n_elements(xl25)-1],xl23[n_elements(xl23)-1],xl20[n_elements(xl20)-1],xl15[n_elements(xl15)-1],xl12[n_elements(xl12)-1],xl9[n_elements(xl9)-1]]

xtefinrot=[xte1204[n_elements(xte1204)-1],xte854[n_elements(xte854)-1],xte604[n_elements(xte604)-1],xte404[n_elements(xte404)-1],xte324[n_elements(xte324)-1],$
            xte284[n_elements(xte284)-1],xte254[n_elements(xte254)-1],xte204[n_elements(xte204)-1],xte184[n_elements(xte184)-1],xte154[n_elements(xte154)-1],xte124[n_elements(xte124)-1],xte94[n_elements(xte94)-1]]

tcmfgenfinrot=[3528,3550,3623,5382,19540,20000,26823.,154100,161100,174500,168400,174500]      
tcmfgenfinrot=reverse(tcmfgenfinrot) 
       
xlfinrot=[xl1204[n_elements(xl1204)-1],xl854[n_elements(xl854)-1],xl604[n_elements(xl604)-1],xl404[n_elements(xl404)-1],xl324[n_elements(xl324)-1],$
            xl284[n_elements(xl284)-1],xl254[n_elements(xl254)-1],xl204[n_elements(xl204)-1],xl184[n_elements(xl184)-1],xl154[n_elements(xl154)-1],xl124[n_elements(xl124)-1],xl94[n_elements(xl94)-1]]            
            
            
;HR diagram for non rotating models between 12 and 150 Msun, color coded with [N/H]
symcolorpoints2=['black','red','blue','charcoal','dark green','orange','cyan','chocolate','purple','magenta','green','dark grey']
symcolorpoints3=['black','red','blue','charcoal','dark green','orange','cyan','chocolate','purple','magenta','green','dark grey']
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xte120,xl120,'Log Temperature (K)','Log Luminosity (Lsun)',label+', vrot/vcrit=0.0',x2=xte85,y2=xl85,x3=xte60,y3=xl60,x4=xte40,y4=xl40,x5=xte32,y5=xl32,x6=xte25,y6=xl25,x7=xte20,y7=xl20,x8=xte15,y8=xl15,x9=xte12,y9=xl12,x10=xte9,y10=xl9,$
                                x11=xte50,y11=xl50,x12=xte23,y12=xl23,xrange=[5.5,3.40],yrange=[3.5,6.83],xreverse=0,_EXTRA=extra,rebin=1,factor=25.0, pointsx2=xtefinnorot,pointsy2=xlfinnorot,pointsx3=alog10(tcmfgenfinnorot),pointsy3=xlfinnorot,$
                                psympoints2=14,symcolorpoints2=symcolorpoints2,symsizepoints2=3,psympoints3=15,symcolorpoints3=symcolorpoints3,symsizepoints3=2,$
                                linestyle2=1,linestyle3=2,linestyle4=3,linestyle5=0,linestyle6=1,linestyle7=2,linestyle8=3,linestyle9=0,linestyle_10=1,linestyle_11=2,linestyle_12=3

symcolorpoints2=['black','red','blue','dark green','orange','chocolate','cyan','purple','charcoal','magenta','green','dark grey']
symcolorpoints3=['black','red','blue','dark green','orange','chocolate','cyan','purple','charcoal','magenta','green','dark grey']
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xte1204,xl1204,'Log Temperature (K)','Log Luminosity (Lsun)',label+', vrot/vcrit=0.4',x2=xte854,y2=xl854,x3=xte604,y3=xl604,x4=xte404,y4=xl404,x5=xte324,y5=xl324,x6=xte254,y6=xl254,x7=xte204,y7=xl204,x8=xte154,y8=xl154,x9=xte124,y9=xl124,x10=xte94,y10=xl94,$
                                x11=xte184,y11=xl184,x12=xte284,y12=xl284,xrange=[5.5,3.40],yrange=[3.5,6.83],xreverse=0,_EXTRA=extra,rebin=1,factor=25.0, pointsx2=xtefinrot,pointsy2=xlfinrot,pointsx3=alog10(tcmfgenfinrot),pointsy3=xlfinrot,$
                                psympoints2=14,symcolorpoints2=symcolorpoints2,symsizepoints2=3,psympoints3=15,symcolorpoints3=symcolorpoints3,symsizepoints3=2,$
                                linestyle2=1,linestyle3=2,linestyle4=3,linestyle5=0,linestyle6=1,linestyle7=2,linestyle8=3,linestyle9=0,linestyle_10=1,linestyle_11=2,linestyle_12=3

;only RSGs and 120 Msun model
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xte1204,xl1204,'Log Temperature (K)','Log Luminosity (Lsun)',label+', vrot/vcrit=0.4',x8=xte154,y8=xl154,x9=xte124,y9=xl124,x10=xte94,y10=xl94,$
;                                xrange=[5.5,3.40],yrange=[3.5,6.83],xreverse=0,_EXTRA=extra,rebin=1,factor=25.0, pointsx2=xtefinrot,pointsy2=xlfinrot;,pointsx3=alog10(tcmfgenfinrot),pointsy3=xlfinrot

;;only WO progenitors
;;observed WO Stars from Sander+12
;tstarobswo=[alog10(200e3),alog10(200e3)]
;lstarobswo=[5.68,5.70]
;;read sander wc stars data
;READCOL,'/Users/jgroh/temp/galactic_wc_sander_data.txt',F='F,F,F,A,I',idobswc,tstarobswc,loglstarobswc,sptypeobswc,distflagobswc
;
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xte1204,xl1204,'Log Temperature (K)','Log Luminosity (Lsun)',label+', vrot/vcrit=0.4',x2=xte854,y2=xl854,x3=xte604,y3=xl604,x4=xte404,y4=xl404,x5=xte324,y5=xl324,$
;                                xrange=[5.5,3.60],yrange=[5.0,6.5],xreverse=0,_EXTRA=extra,rebin=1,factor=25.0, pointsx2=xtefinrot[0:4],pointsy2=xlfinrot[0:4],psympoints2=14,symcolorpoints2='green',symsizepoints2=3,$
;                                pointsx3=tstarobswo,pointsy3=lstarobswo,psympoints3=16,symcolorpoints3='blue',symsizepoints3=1.5,$
;                                pointsx4=alog10(1e3*tstarobswc(where(distflagobswc EQ 1))),pointsy4=loglstarobswc(where(distflagobswc EQ 1)),psympoints4=6,symcolorpoints4='orange',symsizepoints4=1.5
;
;
;
;only LBV progenitors
;observed LBVs compiled by Groh 2013; same as Clark+09, plus HR Car with parameters from Groh+2009 ApjL, Tstar values have +1000K degree added to Teff when Tstar was not given
;read  data
READCOL,'/Users/jgroh/temp/lbv_observed_parameters.txt',F='A,F,F,F,A',idobslbv,tstarobslbv,teffobslbv,lstarobslbv,reflbv
;remove duplicate stars; we are only plotting maximum and minimum teff
remove,[2,5,10,11,12,13,14],idobslbv,tstarobslbv,teffobslbv,lstarobslbv,reflbv
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xte1204,xl1204,'Log Temperature (K)','Log Luminosity (Lsun)',label+', vrot/vcrit=0.4',x2=xte854,y2=xl854,x3=xte604,y3=xl604,x4=xte404,y4=xl404,x5=xte324,y5=xl324,x6=xte254,y6=xl254,x7=xte204,y7=xl204,$
                                x12=xte284,y12=xl284,linestyle2=1,linestyle3=2,linestyle4=3,linestyle5=0,linestyle6=1,linestyle7=2,linestyle8=3,linestyle9=0,linestyle_10=1,linestyle_11=2,linestyle_12=3,$
                                xrange=[5.0,3.40],yrange=[4.4,6.95],xreverse=0,_EXTRA=extra,rebin=1,factor=25.0, pointsx2=xtefinrot[6:7],pointsy2=xlfinrot[6:7],psympoints2=14,symcolorpoints2='green',symsizepoints2=3,$
                                pointsx3=alog10(1e3*tstarobslbv),pointsy3=alog10(lstarobslbv),psympoints3=15,symcolorpoints3='red',symsizepoints3=1.5
                                
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xte120,xl120,'Log Temperature (K)','Log Luminosity (Lsun)',label+', vrot/vcrit=0.0',x2=xte85,y2=xl85,x3=xte60,y3=xl60,x4=xte40,y4=xl40,x5=xte32,y5=xl32,x6=xte25,y6=xl25,x7=xte20,y7=xl20,$
                                linestyle2=1,linestyle3=2,linestyle4=3,linestyle5=0,linestyle6=1,linestyle7=2,linestyle8=3,linestyle9=0,linestyle_10=1,linestyle_11=2,linestyle_12=3,$
                                xrange=[5.0,3.40],yrange=[4.4,6.95],xreverse=0,_EXTRA=extra,rebin=1,factor=25.0, pointsx2=xtefinnorot[6:7],pointsy2=xlfinnorot[6:7],psympoints2=14,symcolorpoints2='green',symsizepoints2=3,$
                                pointsx3=alog10(1e3*tstarobslbv),pointsy3=alog10(lstarobslbv),psympoints3=15,symcolorpoints3='red',symsizepoints3=1.5
                                

;;HR diagram for non rotating models between 12 and 150 Msun, color coded with [N/H]
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xte1204,xl1204,'xte','xl',label+'rot',x2=xte854,y2=xl854,x3=xte604,y3=xl604,x4=xte404,y4=xl404,x5=xte324,y5=xl324,x6=xte254,y6=xl254,xrange=[5.5,3.50],yrange=[4.7,6.83],xreverse=0,_EXTRA=extra,/rebin,factor=100


END
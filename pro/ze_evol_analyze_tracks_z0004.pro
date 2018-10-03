;PRO ZE_EVOL_ANALYZE_TRACKS_Z0004
;analyze and plot tracks for metalicity Z=0.0004, suitable for IZw18

dir='/Users/jgroh/evol_models/Z0004'

model='P007zm4S0'
wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar07,logg07,u1007,vinf07,eta_star07,Bmin07,Jdot07
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt07,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl07,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u507,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1007,return_valz
nh07=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u1007,u507,'N')

model='P009zm4S0'
wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar09,logg09,u1009,vinf09,eta_star09,Bmin09,Jdot09
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt09,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl09,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u509,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1009,return_valz
nh09=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u1009,u509,'N')

model='P012zm4S0'
wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar12,logg12,u1012,vinf12,eta_star12,Bmin12,Jdot12
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt12,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl12,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u512,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1012,return_valz
nh12=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u1012,u512,'N')

model='P015zm4S0'
wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar15,logg15,u1015,vinf15,eta_star15,Bmin15,Jdot15
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt15,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl15,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u515,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1015,return_valz
nh15=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u1015,u515,'N')

model='P020zm4S0'
wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar20,logg20,u1020,vinf20,eta_star20,Bmin20,Jdot20
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt20,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl20,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u520,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u820,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1020,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u1220,return_valz
ch20=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u820,u520,'C')
nh20=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u1020,u520,'N')
oh20=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u1220,u520,'O')

model='P020zm4S4'
wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar204,logg204,u10204,vinf204,eta_star204,Bmin204,Jdot204
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt204,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl204,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5204,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10204,return_valz
nh204=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u10204,u5204,'N')

model='P025zm4S0'
wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar25,logg25,u1025,vinf25,eta_star25,Bmin25,Jdot25
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt25,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl25,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u525,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1025,return_valz
nh25=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u1025,u525,'N')

model='P032zm4S0'
wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar32,logg32,u1032,vinf32,eta_star32,Bmin32,Jdot32
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt32,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl32,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u532,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1032,return_valz
nh32=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u1032,u532,'N')

model='P040zm4S0'
wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar40,logg40,u1040,vinf40,eta_star40,Bmin40,Jdot40
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt40,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl40,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u540,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1040,return_valz
nh40=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u1040,u540,'N')

model='P060zm4S0'
wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload 
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60,logg60,u1060,vinf60,eta_star60,Bmin60,Jdot60
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt60,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl60,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u560,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1060,return_valz
nh60=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u1060,u560,'N')

model='P085zm4S0'
wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar85,logg85,u1085,vinf85,eta_star85,Bmin85,Jdot85
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt85,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl85,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u585,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1085,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc85,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'rapomm',data_wgfile_cut,rapomm85,return_valz
nh85=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u1085,u585,'N')

model='P085zm4S4'
wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar854,logg854,u10854,vinf854,eta_star854,Bmin854,Jdot854
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt854,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl854,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5854,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10854,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc854,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'rapomm',data_wgfile_cut,rapomm854,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'vequam',data_wgfile_cut,vequam854,return_valz
nh854=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u10854,u5854,'N')


model='P120zm4S0'
wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar120,logg120,u10120,vinf120,eta_star120,Bmin120,Jdot120
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt120,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl120,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5120,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10120,return_valz   
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc120,return_valz 
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'rapomm',data_wgfile_cut,rapomm120,return_valz
nh120=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u10120,u5120,'N')

model='P120zm4S4'
wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar1204,logg1204,u101204,vinf1204,eta_star1204,Bmin1204,Jdot1204
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt1204,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl1204,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u51204,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u101204,return_valz  
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc1204,return_valz  
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'rapomm',data_wgfile_cut,rapomm1204,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'vequam',data_wgfile_cut,vequam1204,return_valz
nh1204=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u101204,u51204,'N')

model='P150zm4S0'
wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar150,logg150,u10150,vinf150,eta_star150,Bmin150,Jdot150
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt150,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl150,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5150,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10150,return_valz  

nh150=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u10150,u5150,'N')

dir='/Users/jgroh/evol_models/Grids2010/wg'

model='P007zm4S4'
wgfile=dir+'/'+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar074,logg074,u10074,vinf074,eta_star074,Bmin074,Jdot074
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt074,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl074,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5074,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10074,return_valz
nh074=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u10074,u5074,'N')


model='P009zm4S4'
wgfile=dir+'/'+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar094,logg094,u10094,vinf094,eta_star094,Bmin094,Jdot094
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt094,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl094,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5094,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10094,return_valz
nh094=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u10094,u5094,'N')


model='P012zm4S4'
wgfile=dir+'/'+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar124,logg124,u10124,vinf124,eta_star124,Bmin124,Jdot124
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt124,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl124,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5124,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10124,return_valz
nh124=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u10124,u5124,'N')

model='P015zm4S4'
wgfile=dir+'/'+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar154,logg154,u10154,vinf154,eta_star154,Bmin154,Jdot154
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt154,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl154,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5154,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10154,return_valz
nh154=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u10154,u5154,'N')

model='P020zm4S4'
wgfile=dir+'/'+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar204,logg204,u10204,vinf204,eta_star204,Bmin204,Jdot204
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt204,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl204,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5204,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10204,return_valz
nh204=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u10204,u5204,'N')

model='P025zm4S4'
wgfile=dir+'/'+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar254,logg254,u10254,vinf254,eta_star254,Bmin254,Jdot254
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt254,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl254,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5254,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10254,return_valz
nh254=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u10254,u5254,'N')

model='P032zm4S4'
wgfile=dir+'/'+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar324,logg324,u10324,vinf324,eta_star324,Bmin324,Jdot324
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt324,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl324,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5324,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10324,return_valz
nh324=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u10324,u5324,'N')

model='P040zm4S4'
wgfile=dir+'/'+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload 
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar404,logg404,u10404,vinf404,eta_star404,Bmin404,Jdot404
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt404,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl404,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5404,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10404,return_valz
nh404=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u10404,u5404,'N')

model='P060zm4S4'
wgfile=dir+'/'+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload 
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar604,logg604,u10604,vinf604,eta_star604,Bmin604,Jdot604
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt604,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl604,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5604,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10604,return_valz
nh604=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u10604,u5604,'N')


label='Z=0.0004'    
;HR diagram for non rotating models between 12 and 150 Msun, color coded with [N/H]
ZE_EVOL_PLOT_XY_GENERAL_EPS_V4,xtt120,xl120,'Log Temperature (K) ','Log Luminosity (Lsun)','Z=0.0004, no rot.',z1=nh120,x2=xtt85,y2=xl85,z2=nh85,x3=xtt40,y3=xl40,z3=nh40,x4=xtt32,y4=xl32,z4=nh32,x5=xtt25,y5=xl25,z5=nh25,x6=xtt20,y6=xl20,z6=nh20,x7=xtt12,y7=xl12,z7=nh12,x8=xtt60,y8=xl60,z8=nh60,$
                              x9=xtt15,y9=xl15,z9=nh15,x10=xtt09,y10=xl09,z_10=nh09 ,x11=xtt07,y11=xl07,z_11=nh07,$
                              minz=6.25,maxz=7.75,rebin=1,xrange=[4.93,3.58],yrange=[3.21,6.83],xreverse=0,_EXTRA=extra,ct=33,$
                              factor1=4,factor2=4,factor_10=1,factor_11=1
;                             minz=6.25,maxz=7.75,rebin=1,xrange=[4.93,3.58],yrange=[3.58,6.83],xreverse=0,_EXTRA=extra,ct=43,axiscolor=0

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
;HR diagram for  rotating models between 9and 120 Msun, color coded with [N/H]
;for talk
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xtt1204,xl1204,'Log Temperature (K) ','Luminosity (Lsun)',label,z1=nh1204,x2=xtt854,y2=xl854,z2=nh854,x3=xtt404,y3=xl404,z3=nh404,x4=xtt324,y4=xl324,z4=nh324,x5=xtt254,y5=xl254,z5=nh254,x6=xtt204,y6=xl204,z6=nh204,$
;                              x7=xtt124,y7=xl124,z7=nh124,x8=xtt604,y8=xl604,z8=nh604,x9=xtt154,y9=xl154,z9=nh154,x10=xtt094,y10=xl094,z_10=nh094,$
;                              minz=6.25,maxz=7.75,rebin=1,xrange=[4.93,3.58],yrange=[3.58,6.83],xreverse=0,_EXTRA=extra,ct=43,axiscolor=0

;for paper
ZE_EVOL_PLOT_XY_GENERAL_EPS_V4,xtt1204,xl1204,'Log Temperature (K) ','Log Luminosity (Lsun)','Z=0.0004,rot.',z1=nh1204,x2=xtt854,y2=xl854,z2=nh854,x3=xtt404,y3=xl404,z3=nh404,x4=xtt324,y4=xl324,z4=nh324,x5=xtt254,y5=xl254,z5=nh254,x6=xtt204,y6=xl204,z6=nh204,$
                              x7=xtt124,y7=xl124,z7=nh124,x8=xtt604,y8=xl604,z8=nh604,x9=xtt154,y9=xl154,z9=nh154,x10=xtt094,y10=xl094,z_10=nh094,$;x11=xtt074,y11=xl074,z_11=nh074,$
                              minz=6.25,maxz=7.75,rebin=1,xrange=[4.93,3.58],yrange=[3.51,6.83],xreverse=0,_EXTRA=extra,ct=33,$
                              factor1=4,factor2=4,factor_10=1,factor_11=1

;for talk without Zscaling with N abundances
ZE_EVOL_PLOT_XY_GENERAL_EPS_V4,xtt1204,xl1204,'Log Temperature (K) ','Log Luminosity (Lsun)','Z=0.0004,rot.',x2=xtt854,y2=xl854,x3=xtt404,y3=xl404,x4=xtt324,y4=xl324,x5=xtt254,y5=xl254,x6=xtt204,y6=xl204,$
                              x7=xtt124,y7=xl124,x8=xtt604,y8=xl604,x9=xtt154,y9=xl154,x10=xtt094,y10=xl094,$;x11=xtt074,y11=xl074,z_11=nh074,$
                              minz=6.25,maxz=7.75,rebin=1,xrange=[4.98,3.51],yrange=[3.41,6.83],xreverse=0,_EXTRA=extra,ct=33,$
                              factor1=4,factor2=4,factor_10=1,factor_11=1


END
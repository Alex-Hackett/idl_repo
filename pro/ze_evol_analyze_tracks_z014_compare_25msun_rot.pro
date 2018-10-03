;PRO ZE_EVOL_ANALYZE_TRACKS_Z014_COMPARE_25MSUN_ROT
;analyze and plot tracks for metalicity Z=0.0004, suitable for IZw18

dir='/Users/jgroh/evol_models/Grids2010/wg'

model='P025z14S4'
wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar254,logg254,u10254,vinf254,eta_star254,Bmin254,Jdot254
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte254,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl254,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5254,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10254,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot254,return_valz
nh254=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u10254,u5254,'N')

model='P025z14S4_end'
wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar254e,logg254e,u10254e,vinf254e,eta_star254e,Bmin254e,Jdot254e
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte254e,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl254e,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5254e,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10254e,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot254e,return_valz
nh254e=ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HYD_12(u10254e,u5254e,'N')

label='Z0d014'    
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

;HR diagram for non rotating models between 12 and 150 Msun, color coded with [N/H]
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xte254,xl254,'xte','xl',label+'nonrot',z1=xmdot254,labelz='xmdot',x2=xte254e,y2=xl254e,z2=xmdot254e,xreverse=1,_EXTRA=extra,/rebin,factor=100.0

;;HR diagram for non rotating models between 12 and 150 Msun, color coded with [N/H]
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xte1204,xl1204,'xte','xl',label+'rot',x2=xte854,y2=xl854,x3=xte604,y3=xl604,x4=xte404,y4=xl404,x5=xte324,y5=xl324,x6=xte254,y6=xl254,xrange=[5.5,3.50],yrange=[4.7,6.83],xreverse=0,_EXTRA=extra,/rebin,factor=100


END
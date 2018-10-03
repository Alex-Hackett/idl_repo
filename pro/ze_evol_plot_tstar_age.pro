;PRO ZE_EVOL_PLOT_TSTAR_AGE
dir='/Users/jgroh/evol_models/Grids2010/wg'
model='P012zm4S4'
wgfile=dir+'/'+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar124,logg124,u10124,vinf124,eta_star124,Bmin124,Jdot124
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt124,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl124,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u1124,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,u18124,return_valz


model='P012z14S4'
wgfile=dir+'/'+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar124zsun,logg124zsun,u10124zsun,vinf124zsun,eta_star124zsun,Bmin124zsun,Jdot124zsun
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt124zsun,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl124zsun,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u1124zsun,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,u18124zsun,return_valz


ZE_EVOL_COMPUTE_BURNING_PHASES,'P012zm4S4',modelnumber_starth=modelnumber_starth12zm4,modelnumber_endh=modelnumber_endh12zm4,modelnumber_start_he=modelnumber_starthe12zm4,modelnumber_end_he=modelnumber_endhe12zm4,modelnumber_startc=modelnumber_startc12zm4,modelnumber_endc=modelnumber_endc12zm4
ZE_EVOL_COMPUTE_BURNING_PHASES,'P012z14S4',modelnumber_starth=modelnumber_starth12z14,modelnumber_endh=modelnumber_endh12z14,modelnumber_start_he=modelnumber_starthe12z14,modelnumber_end_he=modelnumber_endhe12z14,modelnumber_startc=modelnumber_startc12z14,modelnumber_endc=modelnumber_endc12z14



colorhydburning='black'
colorheburning='red'
colorcburning='blue'
colorinterm='grey'

ZE_EVOL_PLOT_XY_GENERAL_EPS_V4,u1124,xtt124,color1=colorinterm,'Age (years)','Log Effective Temperature (K)',label,$
                              x2=u1124zsun[modelnumber_endh12z14:modelnumber_starthe12z14],y2=xtt124zsun[modelnumber_endh12z14:modelnumber_starthe12z14],linestyle2=2,color2=colorinterm,$
                              minz=6.25,maxz=7.75,rebin=1,factor1=100,factor2=4,xreverse=0,_EXTRA=extra,ct=43,POSITION=[0.16,0.4,0.98,0.98],YRANGE=[3.43,4.75],XRANGE=[0,2.25e7],$
                              x3=u1124[modelnumber_starth12zm4:modelnumber_endh12zm4],y3=xtt124[modelnumber_starth12zm4:modelnumber_endh12zm4],linestyle3=0,color3=colorhydburning,$
                              x4=u1124[modelnumber_starthe12zm4:modelnumber_endhe12zm4],y4=xtt124[modelnumber_starthe12zm4:modelnumber_endhe12zm4],linestyle4=0,color4=colorheburning,$
                              x5=u1124[modelnumber_startc12zm4:modelnumber_endc12zm4],y5=xtt124[modelnumber_startc12zm4:modelnumber_endc12zm4],linestyle5=0,color5=colorcburning,$
                              x6=u1124zsun[modelnumber_starth12z14:modelnumber_endh12z14],y6=xtt124zsun[modelnumber_starth12z14:modelnumber_endh12z14],linestyle6=2,color6=colorhydburning,$
                              x7=u1124zsun[modelnumber_starthe12z14:modelnumber_endhe12z14],y7=xtt124zsun[modelnumber_starthe12z14:modelnumber_endhe12z14],linestyle7=2,color7=colorheburning,$
                              x8=u1124zsun[modelnumber_startc12z14:modelnumber_endc12z14],y8=xtt124zsun[modelnumber_startc12z14:modelnumber_endc12z14],linestyle8=2,color8=colorcburning,$
                              x9=u1124zsun[modelnumber_endhe12z14:modelnumber_startc12z14],y9=xtt124zsun[modelnumber_endhe12z14:modelnumber_startc12z14],linestyle9=2,color9=colorinterm
END
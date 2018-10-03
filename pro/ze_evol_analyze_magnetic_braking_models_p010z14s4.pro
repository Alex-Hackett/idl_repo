;PRO ZE_EVOL_ANALYZE_MAGNETIC_BRAKING_MODELS_P010z14S4
;analyze and plot tracks for models with mag breaking

dir='/Users/jgroh/evol_models/Z014'

model='P010z14S4nomagbreaking'
wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar10nobrake,logg10nobrake,vesc10nobrake,vinf10nobrake,eta_star10nobrake,Bmin10nobrake,Jdot10nobrake,0.0
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt10nobrake,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl10nobrake,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'btotatm',data_wgfile_cut,btotatm10nobrake,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u110nobrake,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'rot1',data_wgfile_cut,rot110nobrake,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'rotm',data_wgfile_cut,rotm10nobrake,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xjspe1',data_wgfile_cut,xjspe110nobrake,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xjspe2',data_wgfile_cut,xjspe210nobrake,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u7',data_wgfile_cut,qcc10nobrake,index_varnamey_wgfile,return_valy

model='P010z14S4magbreaking200G'
wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar10brake200,logg10brake200,vesc10brake200,vinf10brake200,eta_star10brake200,Bmin10brake200,Jdot10brake200,200.
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt10brake200,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl10brake200,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'btotatm',data_wgfile_cut,btotatm10brake200,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u110brake200,return_valz
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'rot1',data_wgfile_cut,rot110brake200,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'rotm',data_wgfile_cut,rotm10brake200,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xjspe1',data_wgfile_cut,xjspe110brake200,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xjspe2',data_wgfile_cut,xjspe210brake200,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u7',data_wgfile_cut,qcc10brake200,index_varnamey_wgfile,return_valy

;output from evolData code to find model numbers corresponding to end of core H, He, and C burning phases

;FOR P010z14S4 no magnetic breaking
;tstarth= 2.290980E+05,  X_H(max)= 0.716979,  modelnumber=     186
;tendh= 2.512917E+07, xh= 0.000014,   modelnumber=    4001
;X_He(max)= 0.986326
;tstarthe= 2.523391E+07,  xhe= 0.983374,   modelnumber=    4232
;tendhe= 2.802998E+07, xhe= 0.000021,   modelnumber=   23693
;X_C12(max)= 0.326263
;tstartc= 2.810873E+07,  xc= 0.323648,   modelnumber=   24108
;tendc= 2.811697E+07, xc= 0.000010,   modelnumber=   53999
;X_Ne20(max)= 0.481696
;tstartne= 2.811703E+07,  xne= 0.481699,   modelnumber=   60720
;tendne= 2.811703E+07, xne= 0.481699,   modelnumber=   60720
;X_O16(max)= 0.463756
;tstarto= 2.811703E+07,  xo= 0.463756,   modelnumber=   60720
;tendo= 2.811703E+07, xo= 0.463756,   modelnumber=   60720
;-------------------------------------------------
; age= 0.000000E+00
; t_H= 2.490007E+07
;t_He= 2.796073E+06
; t_C= 8.245274E+03
;t_Ne= 0.000000E+00
; t_O= 0.000000E+00

;output from structure code applied at timespet 54001 (end of C burning) to find the remnant mass and angular momentum
;------------------
;MCO_int =   1.8591
;------------------
;------------------
;M_rem:    1.3564
;M_grav:    1.2481
;------------------
;
; 1H mass in star    :    4.3517086582921536     
; 4He mass in star   :    3.3022188948540561     
; N mass in star     :   2.94282389652101954E-002
; C mass in star     :   0.13452824374279504     
; O mass in star     :   0.28561735407598687     
; Heavy elem in star :   0.12596885951081993     
; He Core mass       :    2.9085216536669996     
; CO Core mass       :    1.6636312293789999     
; total stellar mass :    9.5911899999999992     
; remnant grav. mass :    1.2480480864174750     
; ejected mass       :    8.2294702494410217     
;
; Total angular momentum of the remnant :   7.42267366926585292E+049
; Angular velocity of the remnant       :    59325.566646992564     
; Remnant period                        :   1.05910243342252484E-004


;for P010z14S4magbreaking200G
;tstarth= 2.290980E+05,  X_H(max)= 0.716979,  modelnumber=     186
;tendh= 2.807051E+07, xh= 0.000016,   modelnumber=   14997
;X_He(max)= 0.986325
;tstarthe= 2.815635E+07,  xhe= 0.983348,   modelnumber=   15263
;tendhe= 3.048382E+07, xhe= 0.000017,   modelnumber=   34356
;X_C12(max)= 0.333790
;tstartc= 3.054568E+07,  xc= 0.331175,   modelnumber=   34696
;tendc= 3.055377E+07, xc= 0.000010,   modelnumber=   66437
;X_Ne20(max)= 0.490987
;tstartne= 3.055377E+07,  xne= 0.488146,   modelnumber=   68380
;tendne= 3.055377E+07, xne= 0.476417,   modelnumber=   75730
;X_O16(max)= 0.458324
;tstarto= 3.055377E+07,  xo= 0.458324,   modelnumber=   75730
;tendo= 3.055377E+07, xo= 0.458324,   modelnumber=   75730
;-------------------------------------------------
; age= 0.000000E+00
; t_H= 2.784142E+07
;t_He= 2.327472E+06
; t_C= 8.089187E+03
;t_Ne= 4.045400E+00
; t_O= 0.000000E+00

;MCO_int =   1.9926
;------------------
;------------------
;M_rem:    1.3917
;M_grav:    1.2770
;------------------
;
; 1H mass in star    :    3.8293102206067573     
; 4He mass in star   :    3.4976717105223449     
; N mass in star     :   3.15937355203197226E-002
; C mass in star     :   0.15793784011639128     
; O mass in star     :   0.31272669623135535     
; Heavy elem in star :   0.16038583700286257     
; He Core mass       :    3.2106137738400000     
; CO Core mass       :    1.8405186254400001     
; total stellar mass :    9.3818999999999999     
; remnant grav. mass :    1.2769854969490624     
; ejected mass       :    7.9896260400000312     
;
; Total angular momentum of the remnant :   3.27830374773378945E+049
; Angular velocity of the remnant       :    25608.024194345922     
; Remnant period                        :   2.45360014982619551E-004




;model='P020zm4S4'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar204,logg204,btotatm204,vinf204,eta_star204,Bmin204,Jdot204
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt204,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl204,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'btotatm',data_wgfile_cut,btotatm204,return_valz
;
;model='P025zm4S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar25,logg25,btotatm25,vinf25,eta_star25,Bmin25,Jdot25
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt25,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl25,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'btotatm',data_wgfile_cut,btotatm25,return_valz
;
;
;model='P032zm4S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar32,logg32,btotatm32,vinf32,eta_star32,Bmin32,Jdot32
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt32,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl32,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'btotatm',data_wgfile_cut,btotatm32,return_valz
;
;model='P040zm4S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar40,logg40,btotatm40,vinf40,eta_star40,Bmin40,Jdot40
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt40,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl40,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'btotatm',data_wgfile_cut,btotatm40,return_valz
;
;model='P060zm4S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload 
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60,logg60,btotatm60,vinf60,eta_star60,Bmin60,Jdot60
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt60,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl60,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'btotatm',data_wgfile_cut,btotatm60,return_valz
;
;
;model='P085zm4S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar85,logg85,btotatm85,vinf85,eta_star85,Bmin85,Jdot85
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt85,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl85,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'btotatm',data_wgfile_cut,btotatm85,return_valz
;
;model='P085zm4S4'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar854,logg854,btotatm854,vinf854,eta_star854,Bmin854,Jdot854
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt854,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl854,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'btotatm',data_wgfile_cut,btotatm854,return_valz
;
;model='P120zm4S0'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar120,logg120,btotatm120,vinf120,eta_star120,Bmin120,Jdot120
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt120,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl120,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'btotatm',data_wgfile_cut,btotatm120,return_valz    
;
;model='P120zm4S4'
;wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar1204,logg1204,btotatm1204,vinf1204,eta_star1204,Bmin1204,Jdot1204
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt1204,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl1204,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'btotatm',data_wgfile_cut,btotatm1204,return_valz  

label='Z=0.014'    
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xtt10nobrake,xl10nobrake,'xtt','xl',label,z1=btotatm10nobrake,labelz='btotatm',x2=xtt10brake200,y2=xl10brake200,z2=btotatm10brake200,rebin=1,xreverse=1,_EXTRA=extra
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u110nobrake,xjspe210nobrake,'u1','xjspe1',label,x2=u110brake200,y2=xjspe210brake200

;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xtt120,xl120,'xtt','xl',label,z1=btotatm120,labelz='btotatm',x2=xtt85,y2=xl85,z2=btotatm85,x3=xtt40,y3=xl40,z3=btotatm40,x4=xtt32,y4=xl32,z4=btotatm32,x5=xtt25,y5=xl25,z5=btotatm25,x6=xtt20,y6=xl20,z6=btotatm20,x7=xtt12,y7=xl12,z7=btotatm12,x8=xtt60,y8=xl60,z8=btotatm60,x9=xtt204,y9=xl204,z9=btotatm204,x10=xtt854,y10=xl854,z_10=btotatm854,minz=20,maxz=1000,rebin=1,xreverse=1,_EXTRA=extra

END
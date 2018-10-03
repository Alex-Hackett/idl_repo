;PRO ZE_EVOL_WORK_ENVELOPE_BINDING_ENERGY
;computes mass above a certain binding energy threshold

ZE_EVOL_CONST,pi,cst_c,cst_G,cs,t_h,cst_k,cst_a,rgaz,cst_sigma,cst_me,cst_avo,cst_u,cst_mh,cst_thomson,cst_e,cst_ecgs,qapicg,cst_K1, $
                  lgpi,cstlg_c,cstlg_G,cstlg_h,cstlg_k,cstlg_a,rgazlg,cstlg_sigma,cstlg_me,cstlg_avo,cstlg_u,cstlg_mh,cstlg_thomson,cstlg_e, $
                  lgqapicg,cstlg_K1,Msol,Rsol,Lsol,xlsomo,uastr,year,lgMsol,lgRsol,lgLsol,Q_H,Q_He,Q_C,convMeVerg

model_name='P060z14S0'
modeldir='/Users/jgroh/evol_models/tes/P060z14S0/'
if n_Elements(modeldir) eq 0 then modeldir='/Users/jgroh/evol_models/Z014/'+model_name
modelstr=string(model_name,format='(A9)')
ZE_EVOL_FIND_AVAILABLE_TIMESTEPS,modelstr,'_StrucData_',timesteps_available,dirmod=modeldir ;finds which timesteps are available in dir -- useful in case only selected .v. files are there.

wgfile=modeldir+model_name+'.wg' ;assumes model is in wg directory
timestep_ini=49
ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload,timestep_ini=timestep_ini
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar,logg,vesc,vinf,eta_star,Bmin,Jdot,logg_rphot,rphot,beq,beta,ekin,model=model,logtcollapse=logtcollapse60
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'nm',data_wgfile_cut,nm,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u1,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u2',data_wgfile_cut,u2,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5,return_valz    ;X surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u7',data_wgfile_cut,u7,return_valz    ;Y surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u8,return_valz    ;C surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10,return_valz  ; N surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u12,return_valz   ; O surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u6',data_wgfile_cut,u6,return_valz   ; Ne surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u15',data_wgfile_cut,u15,return_valz    ;X center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u17',data_wgfile_cut,u17,return_valz    ;Y center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,u18,return_valz    ;C center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u20',data_wgfile_cut,u20,return_valz  ; N center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u22',data_wgfile_cut,u22,return_valz   ; O center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u16',data_wgfile_cut,u16,return_valz   ; Ne center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot,return_valz  
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesm',data_wgfile_cut,eddesm,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc,index_varnamex_wgfile,return_valx

restore,'/Users/jgroh/temp/P060z14S0_ebind_thresh_1d45.sav'
age6045=u1[timesteps_available] & Mext_at_threshold6045=Mext_at_threshold 

restore,'/Users/jgroh/temp/P060z14S0_ebind_thresh_1d46.sav'
age6046=u1[timesteps_available] & Mext_at_threshold6046=Mext_at_threshold 

restore,'/Users/jgroh/temp/P060z14S0_ebind_thresh_1d47.sav'
age6047=u1[timesteps_available] & Mext_at_threshold6047=Mext_at_threshold 

restore,'/Users/jgroh/temp/P060z14S0_ebind_thresh_1d48.sav'
age6048=u1[timesteps_available] & Mext_at_threshold6048=Mext_at_threshold 

restore,'/Users/jgroh/temp/P060z14S0_ebind_thresh_1d49.sav'
age6049=u1[timesteps_available] & Mext_at_threshold6049=Mext_at_threshold 

restore,'/Users/jgroh/temp/P060z14S0_ebind_thresh_1d50.sav'
age6050=u1[timesteps_available] & Mext_at_threshold6050=Mext_at_threshold 

restore,'/Users/jgroh/temp/P060z14S0_ebind_thresh_1d51.sav'
age6051=u1[timesteps_available] & Mext_at_threshold6051=Mext_at_threshold 

;Y surface diff eruption total mass 
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,age6045/1e6,Mext_at_threshold6045,color1='red','Age (Myr)','Mass (Msun)','',pthick=10,filename='ebind_evol',$
                              /ylog,xrange=[0.0,4.01],yrange=[1e-5,40.0],/nolabel,ystyle=1,$
                              POSITION=[0.15,0.15,0.96,0.96],linestyle1=2,$
                              x3=age6046/1e6,y3=Mext_at_threshold6046,linestyle3=3,color3='green',$
;                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x4=age6047/1e6,y4=Mext_at_threshold6047,linestyle4=0,color4='black',$
                              x2=age6048/1e6,y2=Mext_at_threshold6048,linestyle2=0,color2='blue',$
                              x5=age6049/1e6,y5=Mext_at_threshold6049,linestyle5=0,color5='orange',$
                              x6=age6050/1e6,y6=Mext_at_threshold6050,linestyle6=0,color6='cyan';,$
;                              x5=u160[modelnumber_startc:modelnumber_endc],y5=xmdot60[modelnumber_startc:modelnumber_endc],linestyle5=0,color5=colorcburning,$

;Y surface diff eruption total mass ZOOM FOR INSET
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,age6045/1e6,Mext_at_threshold6045,color1='red','Age (Myr)','Mass (Msun)','',pthick=10,filename='ebind_evol_zoom',$
                              /ylog,xrange=[3.4,3.7],yrange=[1e-5,12.0],/nolabel,ystyle=1,$
                              POSITION=[0.15,0.15,0.96,0.96],linestyle1=2,$
                              x3=age6046/1e6,y3=Mext_at_threshold6046,linestyle3=3,color3='green',$
;                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x4=age6047/1e6,y4=Mext_at_threshold6047,linestyle4=0,color4='black',$
                              x2=age6048/1e6,y2=Mext_at_threshold6048,linestyle2=0,color2='blue',$
                              x5=age6049/1e6,y5=Mext_at_threshold6049,linestyle5=0,color5='orange',$
                              x6=age6050/1e6,y6=Mext_at_threshold6050,linestyle6=0,color6='cyan';,$
;                              x5=u160[modelnumber_startc:modelnumber_endc],y5=xmdot60[modelnumber_startc:modelnumber_endc],linestyle5=0,color5=colorcburning,$

restore,'/Users/jgroh/temp/P060z14S0_ebind_for_mass_0.1.sav'
age=u1[timesteps_available] & ebind_for_mass0d1=ebind_for_mass 

restore,'/Users/jgroh/temp/P060z14S0_ebind_for_mass_1.sav'
age6046=u1[timesteps_available] & ebind_for_mass1=ebind_for_mass 

restore,'/Users/jgroh/temp/P060z14S0_ebind_for_mass_5.sav'
age6047=u1[timesteps_available] & ebind_for_mass5=ebind_for_mass 

restore,'/Users/jgroh/temp/P060z14S0_ebind_for_mass_10.sav'
age6048=u1[timesteps_available] & ebind_for_mass10=ebind_for_mass 

;Y surface diff eruption total mass 
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,age/1e6,ebind_for_mass0d1,color1='red','Age (Myr)','Binding energy (erg)','',pthick=10,filename='mass_ebind_evol',$
                              /ylog,xrange=[0.0,4.01],yrange=[1d46,2d51],/nolabel,ystyle=1,$
                              POSITION=[0.15,0.15,0.96,0.96],linestyle1=2,$
                              x3=age/1e6,y3=ebind_for_mass1,linestyle3=3,color3='green',$
;                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x4=age/1e6,y4=ebind_for_mass5,linestyle4=0,color4='black',$
                              x2=age/1e6,y2=ebind_for_mass10,linestyle2=0,color2='blue';,$
;                              x5=age/1e6,y5=ebind_for_mass6049,linestyle5=0,color5='orange',$
;                              x6=age/1e6,y6=ebind_for_mass6050,linestyle6=0,color6='cyan';,$

;Y surface diff eruption total mass ZOOM
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,age/1e6,ebind_for_mass0d1,color1='red','Age (Myr)','Binding energy (erg)','',pthick=10,filename='mass_ebind_evol_zoom',$
                              /ylog,xrange=[3.4,3.7],yrange=[1d46,2d51],/nolabel,ystyle=1,$
                              POSITION=[0.15,0.15,0.96,0.96],linestyle1=2,$
                              x3=age/1e6,y3=ebind_for_mass1,linestyle3=3,color3='green',$
;                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x4=age/1e6,y4=ebind_for_mass5,linestyle4=0,color4='black',$
                              x2=age/1e6,y2=ebind_for_mass10,linestyle2=0,color2='blue';,$
;                              x5=age/1e6,y5=ebind_for_mass6049,linestyle5=0,color5='orange',$
;                              x6=age/1e6,y6=ebind_for_mass6050,linestyle6=0,color6='cyan';,$


restore,'/Users/jgroh/temp/P060z14S0_ms_mdot4_ebind_for_mass_0.1.sav'
age=u1[timesteps_available] & ebind_for_mass0d1=ebind_for_mass 

restore,'/Users/jgroh/temp/P060z14S0_ms_mdot4_ebind_for_mass_1.sav'
age6046=u1[timesteps_available] & ebind_for_mass1=ebind_for_mass 

restore,'/Users/jgroh/temp/P060z14S0_ms_mdot4_ebind_for_mass_5.sav'
age6047=u1[timesteps_available] & ebind_for_mass5=ebind_for_mass 

restore,'/Users/jgroh/temp/P060z14S0_ms_mdot4_ebind_for_mass_10.sav'
age6048=u1[timesteps_available] & ebind_for_mass10=ebind_for_mass 

;Y surface diff eruption total mass 
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,age/1e6,ebind_for_mass0d1,color1='red','Age (Myr)','Binding energy (erg)','',pthick=10,filename='mass_ebind_evol_ms_mdot4',$
                              /ylog,xrange=[0.0,4.01],yrange=[1d46,2d51],/nolabel,ystyle=1,$
                              POSITION=[0.15,0.15,0.96,0.96],linestyle1=2,$
                              x3=age/1e6,y3=ebind_for_mass1,linestyle3=3,color3='green',$
;                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x4=age/1e6,y4=ebind_for_mass5,linestyle4=0,color4='black',$
                              x2=age/1e6,y2=ebind_for_mass10,linestyle2=0,color2='blue';,$
;                              x5=age/1e6,y5=ebind_for_mass6049,linestyle5=0,color5='orange',$
;                              x6=age/1e6,y6=ebind_for_mass6050,linestyle6=0,color6='cyan';,$

;1 and 10 have not been run yet
restore,'/Users/jgroh/temp/P060z14S4_ms1_post_ms_5em5_ebind_for_mass_0.1.sav'
age=u1[timesteps_available] & ebind_for_mass0d1=ebind_for_mass 

restore,'/Users/jgroh/temp/P060z14S4_ms1_post_ms_5em5_ebind_for_mass_1.sav'
age6046=u1[timesteps_available] & ebind_for_mass1=ebind_for_mass 

restore,'/Users/jgroh/temp/P060z14S4_ms1_post_ms_5em5_ebind_for_mass_5.sav'
age6047=u1[timesteps_available] & ebind_for_mass5=ebind_for_mass 

restore,'/Users/jgroh/temp/P060z14S4_ms1_post_ms_5em5_ebind_for_mass_10.sav'
age6048=u1[timesteps_available] & ebind_for_mass10=ebind_for_mass 

;Y surface diff eruption total mass 
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,age/1e6,ebind_for_mass0d1,color1='red','Age (Myr)','Binding energy (erg)','',pthick=10,filename='mass_ebind_evol_P060z14S4_ms1_post_ms_5em5',$
                              /ylog,xrange=[3.8,4.11],yrange=[1d46,2d51],/nolabel,ystyle=1,$
                              POSITION=[0.15,0.15,0.96,0.96],linestyle1=2,$
                              x3=age/1e6,y3=ebind_for_mass1,linestyle3=3,color3='green',$
;                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x4=age/1e6,y4=ebind_for_mass5,linestyle4=0,color4='black',$
                              x2=age/1e6,y2=ebind_for_mass10,linestyle2=0,color2='blue';,$
;                              x5=age/1e6,y5=ebind_for_mass6049,linestyle5=0,color5='orange',$
;                              x6=age/1e6,y6=ebind_for_mass6050,linestyle6=0,color6='cyan';,$

restore,'/Users/jgroh/temp/P018z14S4_ebind_for_mass_0.1.sav'
age=u1[timesteps_available] & ebind_for_mass0d1=ebind_for_mass 

restore,'/Users/jgroh/temp/P018z14S4_ebind_for_mass_1.sav'
age6046=u1[timesteps_available] & ebind_for_mass1=ebind_for_mass 

restore,'/Users/jgroh/temp/P018z14S4_ebind_for_mass_5.sav'
age6047=u1[timesteps_available] & ebind_for_mass5=ebind_for_mass 

restore,'/Users/jgroh/temp/P018z14S4_ebind_for_mass_10.sav'
age6048=u1[timesteps_available] & ebind_for_mass10=ebind_for_mass 

;Y surface diff eruption total mass 
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,age/1e6,ebind_for_mass0d1,color1='red','Age (Myr)','Binding energy (erg)','',pthick=10,filename='P018z14S4_mass_ebind_evol',$
                              /ylog,xrange=[0.0,10.01],yrange=[1d46,2d51],/nolabel,ystyle=1,$
                              POSITION=[0.15,0.15,0.96,0.96],linestyle1=2,$
                              x3=age/1e6,y3=ebind_for_mass1,linestyle3=3,color3='green',$
;                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x4=age/1e6,y4=ebind_for_mass5,linestyle4=0,color4='black',$
                              x2=age/1e6,y2=ebind_for_mass10,linestyle2=0,color2='blue';,$
;                              x5=age/1e6,y5=ebind_for_mass6049,linestyle5=0,color5='orange',$
;                              x6=age/1e6,y6=ebind_for_mass6050,linestyle6=0,color6='cyan';,$

END
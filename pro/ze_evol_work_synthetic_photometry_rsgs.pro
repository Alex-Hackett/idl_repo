;PRO ZE_EVOL_WORK_SYNTHETIC_PHOTOMETRY_RSGS
model_array_rot=['s3400_g+0.0_m5.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00','s3400_g+0.0_m5.0_t05_st_z+0.00_a+0.00_c+0.00_n+0.00_o+0.00_r+0.00_s+0.00','s3400_g+0.0_m15._t05_st_z+0.00_a+0.00_c+0.00_n+0.00_o+0.00_r+0.00_s+0.00']
;model_array_rot=['s3400_g+0.0_m5.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00','s3600_g+0.0_m5.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00','s3800_g+0.0_m5.0_t05_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00']
;model_Array_rot=['s3400_g+0.0_m5.0_t05_st_z+0.00_a+0.00_c+0.00_n+0.00_o+0.00_r+0.00_s+0.00','s3400_g+0.0_m15._t05_st_z+0.00_a+0.00_c+0.00_n+0.00_o+0.00_r+0.00_s+0.00','s3400_g-0.5_m15._t05_st_z+0.00_a+0.00_c+0.00_n+0.00_o+0.00_r+0.00_s+0.00']
model_array_rot=['s3400_g+0.0_m5.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00','s3600_g+0.0_m5.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00']
evolmass_array_rot=[1,2]
evollstar_array_rot=[42780.,72655.]
norm_factor_array_rot=[1,1] ;obtained by dividing lstar_array_rot[*,0] by evollstar_array_rot ;this ensures that the luminosity of the models is scaled

;model_array_rot=['P020z14S4_model049869_T020358_L0191044_logg2.200','P025z14S4_model042063_T024625_L0318560_logg2.439','P032z14S4_model075198_T181508_L0337150_logg5.904','P040z14S4_model085774_T211679_L0438412_logg6.142','P060z14S4_model054963_T247137_L0784953_logg6.322',$
; 'P085z14S4_model045758_T266698_L1310829_logg6.399','P120z14S4_model064569_T252831_L0856258_logg6.349']  
;
;lstar_array_rot=dblarr(n_elements(model_array_rot)) & tstar_array_rot=lstaR_array_rot &  Mv_array_rot=lstaR_array_rot & Mbol_array_rot=lstaR_array_rot & BC_array_rot=lstaR_array_rot & mstar_array_rot=lstaR_array_rot
;teff_Array_rot=[1.954E+04,2.000E+04,1.541E+05,1.611E+05,1.745E+05,1.684E+05,1.745E+05]
;
model_array_norot=['s3400_g+0.0_m5.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00']
evolmass_array_norot=[9,12,15,20]
evollstar_array_norot=[39441.,46259.,79999.,152236.]
norm_factor_array_norot=[1,1,1,1] ;obtained by dividing lstar_array_norot[*,0] by evollstar_array_norot ;this ensures that the luminosity of the models is scaled

;model_array_norot=['P025z14S0_model030888_T027115_L0239316_logg2.663','P032z14S0_model029922_T045794_L0367647_logg3.507','P040z14S0new_model106339_T048183_L0482467_logg3.576','P060z14S0_model23950_T224855_L483178_logg6d211_vinf5000','P085z14S0_model024500_T236325_L0899663_logg6.201',$
;'P120z14S0_model025926_T167648_L1784201_logg5.527'];,'P150z14S0_model133387_T255016_L0905517_logg6.366']
; 
;lstar_array_norot=dblarr(n_elements(model_array_norot)) & tstar_array_norot=lstaR_array_norot &  Mv_array_norot=lstaR_array_norot & Mbol_array_norot=lstaR_array_norot & BC_array_norot=lstaR_array_norot & mstar_array_norot=lstaR_array_norot
;teff_Array_norot=[2.633E+04,4.048E+04,4.048E+04,1.646E+05,1.669E+05,1.684E+05];,1.672e+05]
;
;dirmod='/Users/jgroh/ze_models/SN_progenitor_grid/'
;dirmod='/Users/jgroh/marcs_models/MARCS_website/' 
;band='B' 
;for i=0, n_elements(model_array_rot) -1 DO begin 
;  ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,dirmod,model_array_rot[i],band,Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt,/MARCSWEB
;  mstar_array_rot[i]=mstart 
;  lstar_array_rot[i]=lstart
;  tstar_array_rot[i]=tstart
;  Mv_array_rot[i]=absolute_magt
;  Mbol_array_rot[i]=Mbolt
;  BC_array_rot[i]=BCt    
;endfor  
;
;for i=0, n_elements(model_array_norot) -1 DO begin 
;  ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,dirmod,model_array_norot[i],band,Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt
;  mstar_array_norot[i]=mstart 
;  lstar_array_norot[i]=lstart
;  tstar_array_norot[i]=tstart
;  Mv_array_norot[i]=absolute_magt
;  Mbol_array_norot[i]=Mbolt
;  BC_array_norot[i]=BCt    
;endfor  
;
;;produce table for paper
;for i=0, n_elements(mv_array_norot) - 1 do print,mstar_array_norot[i], ' & ', lstar_array_norot[i], ' & ',tstar_array_norot[i], ' & ',teff_array_norot[i], ' & ', mv_array_norot[i], ' & ', bc_array_norot[i],FORMAT='(I,A,F7,A,F6,A,F6,A,F5.2,A,F5.2)'
;
;for i=0, n_elements(mv_array_norot) - 1 do print,' & ', mv_array_norot[i], ' & ', bc_array_norot[i],FORMAT='(A,F5.2,A,F5.2)'
;
;;produce table for paper
;for i=0, n_elements(mv_array_rot) - 1 do print,mstar_array_rot[i], ' & ', lstar_array_rot[i], ' & ',tstar_array_rot[i], ' & ',teff_array_rot[i], ' & ', mv_array_rot[i], ' & ', bc_array_rot[i],FORMAT='(I,A,F7,A,F6,A,F6,A,F5.2,A,F5.2)'
;
;for i=0, n_elements(mv_array_rot) - 1 do print,' & ', mv_array_rot[i], ' & ', bc_array_rot[i],FORMAT='(A,F5.2,A,F5.2)'
;
;;bands=['U','B','V','R','I']
;;
;;for i=0, n_elements(model_array_norot) -1 DO begin
;; for j=0, n_elements(bands) - 1 do begin 
;;  ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES,dirmod,model_array_norot[i],bands[j],Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt
;;  mstar_array_norot[i]=mstart 
;;  lstar_array_norot[i]=lstart
;;  tstar_array_norot[i]=tstart
;;  Mv_array_norot[i]=absolute_magt
;;  Mbol_array_norot[i]=Mbolt
;;  BC_array_norot[i]=BCt    
;; endfor 
;;endfor  
;;
;
;;BC x Tstar calibration from Yoon
;
;logtstar_yoon=[4.3,4.5,4.7,4.9,5.1,5.3,5.5]
;BC_yoon = 22.053 - 5.306*logtstar_yoon

bands=['U','B','V','R','I']
mstar_array_norot=dblarr(n_elements(model_array_norot),n_elements(bands))
lstar_array_norot=dblarr(n_elements(model_array_norot),n_elements(bands))
tstar_array_norot=dblarr(n_elements(model_array_norot),n_elements(bands))
teff_array_norot=dblarr(n_elements(model_array_norot),n_elements(bands))
Mv_array_norot=dblarr(n_elements(model_array_norot),n_elements(bands))
Mbol_array_norot=dblarr(n_elements(model_array_norot),n_elements(bands))
BC_array_norot=dblarr(n_elements(model_array_norot),n_elements(bands))

for i=0, n_elements(model_array_norot) -1 DO begin
 for j=0, n_elements(bands) - 1 do begin 
  ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,dirmod,model_array_norot[i],bands[j],Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt,/MARCSWEB,norm_factor=norm_factor_array_norot[i]
  mstar_array_norot[i,j]=evolmass_array_rot[i] 
  lstar_array_norot[i,j]=lstart
  tstar_array_norot[i,j]=tstart
   teff_array_norot[i,j]=tstart
  Mv_array_norot[i,j]=absolute_magt
  Mbol_array_norot[i,j]=Mbolt
  BC_array_norot[i,j]=BCt    
 endfor 
endfor  

                               
uminusb_norot=dblarr(n_elements(model_array_norot)) & bminusv_norot=dblarr(n_elements(model_array_norot)) & vminusi_norot=dblarr(n_elements(model_array_norot))

for i=0, n_elements(uminusb_norot) -1 DO begin 
  uminusb_norot[i]=Mv_array_norot[i,0]-Mv_array_norot[i,1]
  bminusv_norot[i]=Mv_array_norot[i,1]-Mv_array_norot[i,2]
  vminusi_norot[i]=Mv_array_norot[i,2]-Mv_array_norot[i,4]  
endfor  

mstar_array_rot=dblarr(n_elements(model_array_rot),n_elements(bands))
lstar_array_rot=dblarr(n_elements(model_array_rot),n_elements(bands))
tstar_array_rot=dblarr(n_elements(model_array_rot),n_elements(bands))
teff_array_rot=dblarr(n_elements(model_array_rot),n_elements(bands))
Mv_array_rot=dblarr(n_elements(model_array_rot),n_elements(bands))
Mbol_array_rot=dblarr(n_elements(model_array_rot),n_elements(bands))
BC_array_rot=dblarr(n_elements(model_array_rot),n_elements(bands))

for i=0, n_elements(model_array_rot) -1 DO begin
 for j=0, n_elements(bands) - 1 do begin 
  ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,dirmod,model_array_rot[i],bands[j],Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt,/MARCSWEB,norm_factor=norm_factor_array_rot[i]
  mstar_array_rot[i,j]=evolmass_array_rot[i] 
  lstar_array_rot[i,j]=lstart
  tstar_array_rot[i,j]=tstart
   teff_array_rot[i,j]=tstart
  Mv_array_rot[i,j]=absolute_magt
  Mbol_array_rot[i,j]=Mbolt
  BC_array_rot[i,j]=BCt    
 endfor 
endfor  

                               
uminusb_rot=dblarr(n_elements(model_array_rot)) & bminusv_rot=dblarr(n_elements(model_array_rot)) & vminusi_rot=dblarr(n_elements(model_array_rot))

for i=0, n_elements(uminusb_rot) -1 DO begin 
  uminusb_rot[i]=Mv_array_rot[i,0]-Mv_array_rot[i,1]
  bminusv_rot[i]=Mv_array_rot[i,1]-Mv_array_rot[i,2]
  vminusi_rot[i]=Mv_array_rot[i,2]-Mv_array_rot[i,4]  
endfor  


;Mv and BCs ARRAY key for non-rot: 
;(for rot models, add 20 msun model as the first row)

; [ Mu25  Mu32  Mu40 ... Mu120 
;   Mb25  Mb32  Mb40 ... Mb120 
;   Mv25  Mv32  Mv40 ... Mv120 
;    .
;   Mi25  Mi32  Mi40 ... Mi120] 

  
;
;restore,'/Users/jgroh/temp/ze_cmfgen_evol_sn_progenitors_mag_bcs_all.sav'
;
;sntype_array_rot=dblarr(n_elements(model_array_rot))
;sntype_array_rot=['II-L/b','II-L/b','Ic','Ic','Ic','Ib','Ic']  
;  
;sntype_array_norot=dblarr(n_elements(model_array_norot))
;sntype_array_norot=['II-L/b','Ib','Ib','Ic','Ic','Ib']   
;
;
sntype_array_rot=['II-L/b','II-L/b']  
sntype_array_rot=3
sntype_array_norot=['II-L/b','II-L/b','II-L/b','II-L/b']  
sntype_array_rot=4
;!P.Background = fsc_color('white')
;;lineplot,tstar_array,Mv_array
;
for j=0, n_elements(bands) - 1 do begin 

ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,mstar_array_rot[*,j],Mv_array_rot[*,j],'Mini','M_'+bands[j],'',_EXTRA=extra,psym1=sntype_array_rot,symsize1=3,symcolor1='red',/yreverse, $
                               x2=mstar_array_norot[*,j],y2=Mv_array_norot[*,j],psym2=sntype_array_norot,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21
                              
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,mstar_array_rot[*,j],BC_array_rot[*,j],'Mini','BC_'+bands[j],'',_EXTRA=extra,psym1=sntype_array_rot,symsize1=3,symcolor1='red', $
                               x2=mstar_array_norot[*,j],y2=BC_array_norot[*,j],psym2=sntype_array_norot,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21                         
                               
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,alog10(tstar_array_rot[*,j]),Mv_array_rot[*,j],'log_Tstar','M_'+bands[j],'',_EXTRA=extra,psym1=sntype_array_rot,symsize1=3,symcolor1='red',/yreverse,/xreverse, $
                               x2=alog10(tstar_array_norot[*,j]),y2=Mv_array_norot[*,j],psym2=sntype_array_norot,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21
                               
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,alog10(teff_array_rot[*,j]),Mv_array_rot[*,j],'log_Teff','M_'+bands[j],'',_EXTRA=extra,psym1=sntype_array_rot,symsize1=3,symcolor1='red',/yreverse, /xreverse,$
;                               x2=alog10(teff_array_norot[*,j]),y2=Mv_array_norot[*,j],psym2=sntype_array_norot,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21                                                           
;
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,alog10(tstar_array_rot[*,j]),BC_array_rot[*,j],'log_Tstar','BC_'+bands[j],'',_EXTRA=extra,psym1=sntype_array_rot,symsize1=3,symcolor1='red',/xreverse, $
                               x2=alog10(tstar_array_norot[*,j]),y2=BC_array_norot[*,j],psym2=sntype_array_norot,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21;,x3=logtstar_yoon,y3=BC_yoon  
                               
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,alog10(teff_array_rot[*,j]),BC_array_rot[*,j],'log_Teff','BC_'+bands[j],'',_EXTRA=extra,psym1=sntype_array_rot,symsize1=3,symcolor1='red',/xreverse, $
;                               x2=alog10(teff_array_norot[*,j]),y2=BC_array_norot[*,j],psym2=sntype_array_norot,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21                                      
;
endfor
;
;
j=2 ; V band
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,bminusv_rot,Mv_array_rot[*,j],'B-V','M_'+bands[j],'',_EXTRA=extra,psym1=sntype_array_rot,symsize1=3,symcolor1='red',/yreverse,                                x2=bminusv_norot,y2=Mv_array_norot[*,j],psym2=sntype_array_norot,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.20,0.97,0.97],charthick=17,xthick=17,ythick=17          
;
;
;for i=0, n_elements(model_array_norot) - 1 do begin
;    print,mstar_array_norot[i,0], ' & ', lstar_array_norot[i,0], ' & ',tstar_array_norot[i,0], ' & ',teff_array_norot[i,0], ' & ', mv_array_norot[i,0], ' & ', mv_array_norot[i,1], ' & ', $
;          mv_array_norot[i,2], ' & ', mv_array_norot[i,3], ' & ',mv_array_norot[i,4], ' & ', bc_array_norot[i,0], ' & ',$
;           bc_array_norot[i,1], ' & ', bc_array_norot[i,2],' & ', bc_array_norot[i,3],' & ', bc_array_norot[i,4],' \\',$
;          FORMAT='(I,A,F7,A,F6,A,F6,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2, A)'
;endfor
;
;for i=0, n_elements(model_array_rot) - 1 do begin
;    print,mstar_array_rot[i,0], ' & ', lstar_array_rot[i,0], ' & ',tstar_array_rot[i,0], ' & ',teff_array_rot[i,0], ' & ', mv_array_rot[i,0], ' & ', mv_array_rot[i,1], ' & ', $
;          mv_array_rot[i,2], ' & ', mv_array_rot[i,3], ' & ',mv_array_rot[i,4], ' & ', bc_array_rot[i,0], ' & ',$
;           bc_array_rot[i,1], ' & ', bc_array_rot[i,2],' & ', bc_array_rot[i,3],' & ', bc_array_rot[i,4],' \\',$
;          FORMAT='(I,A,F7,A,F6,A,F6,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2, A)'
;endfor
END
;PRO ZE_CMFGEN_EVOL_WORK_SUPERNOVA_PROGENITORS_RSG_V3
;interpolates between two MARCS models for paper 
;v3 does YHG model at 18 Msun rot and K0 model at 23 Msun norot

bands=['U','B','V','R','I','WFPC2_F336W','WFPC2_F450W','WFPC2_F606W','WFPC2_F814W','WFPC2_F170W','WFPC2_F555W','J','H','Ks','ACS_WFCF435W','ACS_WFCF555W','ACS_WFCF814W']

model_array_rot_rsgl=['s3400_g+0.0_m5.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00','s3400_g+0.0_m5.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00','s3600_g+0.0_m5.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00','s3600_g+0.0_m5.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00','s5250_g+0.5_m1.0_t05_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00']
model_array_rot_rsgu=['s3600_g+0.0_m5.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00','s3600_g+0.0_m5.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00','s3800_g+0.0_m5.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00','s3800_g+0.0_m5.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00','s5750_g+0.5_m1.0_t05_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00']

evolmass_array_rot_rsg=[9,12,15,16.5,18]
evollstar_array_rot_rsg=[42780.,72655.,121441.,126610., 153052.];;actual values that we want to find interpolated magnitudes and bcs
evoltstar_array_rot_rsg=[3528.,3550.,3623.,3645.,5382.] ;actual values that we want to find interpolated magnitudes and bcs
evolteff_array_rot_rsg=evoltstar_array_rot_rsg

mstar_array_rot_rsgl=dblarr(n_elements(model_array_rot_rsgl),n_elements(bands))
lstar_array_rot_rsgl=dblarr(n_elements(model_array_rot_rsgl),n_elements(bands))
tstar_array_rot_rsgl=dblarr(n_elements(model_array_rot_rsgl),n_elements(bands))
teff_array_rot_rsgl=dblarr(n_elements(model_array_rot_rsgl),n_elements(bands))
absmag_array_rot_rsgl=dblarr(n_elements(model_array_rot_rsgl),n_elements(bands))
Mbol_array_rot_rsgl=dblarr(n_elements(model_array_rot_rsgl),n_elements(bands))
BC_array_rot_rsgl=dblarr(n_elements(model_array_rot_rsgl),n_elements(bands))

for i=0, n_elements(model_array_rot_rsgl) -1 DO begin
 for j=0, n_elements(bands) - 1 do begin 
  ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,dirmod,model_array_rot_rsgl[i],bands[j],Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt,/MARCSWEB;,norm_factor=norm_factor_array_rot_rsgl[i]
  mstar_array_rot_rsgl[i,j]=mstart 
  lstar_array_rot_rsgl[i,j]=lstart
  tstar_array_rot_rsgl[i,j]=tstart
  teff_array_rot_rsgl[i,j]=tstart
  absmag_array_rot_rsgl[i,j]=absolute_magt
  Mbol_array_rot_rsgl[i,j]=Mbolt
  BC_array_rot_rsgl[i,j]=BCt    
 endfor 
endfor  

mstar_array_rot_rsgu=dblarr(n_elements(model_array_rot_rsgu),n_elements(bands))
lstar_array_rot_rsgu=dblarr(n_elements(model_array_rot_rsgu),n_elements(bands))
tstar_array_rot_rsgu=dblarr(n_elements(model_array_rot_rsgu),n_elements(bands))
teff_array_rot_rsgu=dblarr(n_elements(model_array_rot_rsgu),n_elements(bands))
absmag_array_rot_rsgu=dblarr(n_elements(model_array_rot_rsgu),n_elements(bands))
Mbol_array_rot_rsgu=dblarr(n_elements(model_array_rot_rsgu),n_elements(bands))
BC_array_rot_rsgu=dblarr(n_elements(model_array_rot_rsgu),n_elements(bands))

absmag_array_rot_rsg=dblarr(n_elements(model_array_rot_rsgu),n_elements(bands))
bc_array_rot_rsg=dblarr(n_elements(model_array_rot_rsgu),n_elements(bands))

for i=0, n_elements(model_array_rot_rsgu) -1 DO begin
 for j=0, n_elements(bands) - 1 do begin 
  ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,dirmod,model_array_rot_rsgu[i],bands[j],Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt,/MARCSWEB;,norm_factor=norm_factor_array_rot_rsgu[i]
  mstar_array_rot_rsgu[i,j]=mstart 
  lstar_array_rot_rsgu[i,j]=lstart
  tstar_array_rot_rsgu[i,j]=tstart
  teff_array_rot_rsgu[i,j]=tstart
  absmag_array_rot_rsgu[i,j]=absolute_magt
  Mbol_array_rot_rsgu[i,j]=Mbolt
  BC_array_rot_rsgu[i,j]=BCt    
 endfor 
endfor  

;compute magnitudes of model u scaled to the same luminosity as model_l; thus luminosity of model l has to be used later to scale luminosities to those of the evol models
absmag_array_rot_rsgu_scl=dblarr(n_elements(model_array_rot_rsgu),n_elements(bands))
for i=0, n_elements(model_array_rot_rsgl) -1 DO BEGIN
  absmag_array_rot_rsgu_scl[i,*]=ZE_SCALE_MAG_FROM_L(absmag_array_rot_rsgu[i,*],lstar_array_rot_rsgl[i,0]/lstar_array_rot_rsgu[i,0])
endfor

;linear fit between model l and model u_scl for absolute magnitudes and bolometric corrections as a function of log (lstar)
 for i=0,  n_elements(model_array_rot_rsgl) -1 DO BEGIN
  for j=0, n_elements(bands) -1 DO BEGIN
    linterp,alog10([tstar_array_rot_rsgl[i,j],tstar_array_rot_rsgu[i,j]]),[absmag_array_rot_rsgl[i,j],absmag_array_rot_rsgu_scl[i,j]],alog10(evoltstar_array_rot_rsg[i]),maginter
    absmag_array_rot_rsg[i,j]=maginter
    linterp,alog10([tstar_array_rot_rsgl[i,j],tstar_array_rot_rsgu[i,j]]),[bc_array_rot_rsgl[i,j],bc_array_rot_rsgu[i,j]],alog10(evoltstar_array_rot_rsg[i]),bcinter
    bc_array_rot_rsg[i,j]=bcinter   
  endfor
 endfor    

;scales interpolated luminosity to luminosity of evol model
absmag_array_rot_rsg_scl_to_evol=dblarr(n_elements(model_array_rot_rsgu),n_elements(bands))
for i=0, n_elements(evollstar_array_rot_rsg) -1 DO BEGIN
  absmag_array_rot_rsg_scl_to_evol[i,*]=ZE_SCALE_MAG_FROM_L(absmag_array_rot_rsg[i,*],evollstar_array_rot_rsg[i]/lstar_array_rot_rsgl[i,0])
endfor

uminusb_rot_rsg=dblarr(n_elements(model_array_rot_rsgl)) & bminusv_rot_rsg=dblarr(n_elements(model_array_rot_rsgl)) & vminusi_rot_rsg=dblarr(n_elements(model_array_rot_rsgl))

for i=0, n_elements(uminusb_rot_rsg) -1 DO begin 
  uminusb_rot_rsg[i]=absmag_Array_rot_rsg[i,0]-absmag_Array_rot_rsg[i,1]
  bminusv_rot_rsg[i]=absmag_Array_rot_rsg[i,1]-absmag_Array_rot_rsg[i,2]
  vminusi_rot_rsg[i]=absmag_Array_rot_rsg[i,2]-absmag_Array_rot_rsg[i,4]  
endfor  


model_array_norot_rsgl=['s3400_g+0.0_m5.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00','s3400_g+0.0_m5.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00','s3400_g+0.0_m5.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00','s3600_g+0.0_m5.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00','s4250_g+0.0_m1.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00']
model_array_norot_rsgu=['s3600_g+0.0_m5.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00','s3600_g+0.0_m5.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00','s3600_g+0.0_m5.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00','s3800_g+0.0_m5.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00','s4500_g+0.0_m1.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00']

evolmass_array_norot_rsg=[9,12,15,20,23]
evollstar_array_norot_rsg=[39441.,46259.,79999.,152236.,195030.];actual values that we want to find interpolated magnitudes and bcs
evoltstar_array_norot_rsg=[3480.,3556.,3571.,3741.,4410.] ;actual values that we want to find interpolated magnitudes and bcs
evolteff_array_norot_rsg=evoltstar_array_norot_rsg

mstar_array_norot_rsgl=dblarr(n_elements(model_array_norot_rsgl),n_elements(bands))
lstar_array_norot_rsgl=dblarr(n_elements(model_array_norot_rsgl),n_elements(bands))
tstar_array_norot_rsgl=dblarr(n_elements(model_array_norot_rsgl),n_elements(bands))
teff_array_norot_rsgl=dblarr(n_elements(model_array_norot_rsgl),n_elements(bands))
absmag_array_norot_rsgl=dblarr(n_elements(model_array_norot_rsgl),n_elements(bands))
Mbol_array_norot_rsgl=dblarr(n_elements(model_array_norot_rsgl),n_elements(bands))
BC_array_norot_rsgl=dblarr(n_elements(model_array_norot_rsgl),n_elements(bands))

for i=0, n_elements(model_array_norot_rsgl) -1 DO begin
 for j=0, n_elements(bands) - 1 do begin 
  ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,dirmod,model_array_norot_rsgl[i],bands[j],Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt,/MARCSWEB;,norm_factor=norm_factor_array_norot_rsgl[i]
  mstar_array_norot_rsgl[i,j]=mstart 
  lstar_array_norot_rsgl[i,j]=lstart
  tstar_array_norot_rsgl[i,j]=tstart
  teff_array_norot_rsgl[i,j]=tstart
  absmag_array_norot_rsgl[i,j]=absolute_magt
  Mbol_array_norot_rsgl[i,j]=Mbolt
  BC_array_norot_rsgl[i,j]=BCt    
 endfor 
endfor  

mstar_array_norot_rsgu=dblarr(n_elements(model_array_norot_rsgu),n_elements(bands))
lstar_array_norot_rsgu=dblarr(n_elements(model_array_norot_rsgu),n_elements(bands))
tstar_array_norot_rsgu=dblarr(n_elements(model_array_norot_rsgu),n_elements(bands))
teff_array_norot_rsgu=dblarr(n_elements(model_array_norot_rsgu),n_elements(bands))
absmag_array_norot_rsgu=dblarr(n_elements(model_array_norot_rsgu),n_elements(bands))
Mbol_array_norot_rsgu=dblarr(n_elements(model_array_norot_rsgu),n_elements(bands))
BC_array_norot_rsgu=dblarr(n_elements(model_array_norot_rsgu),n_elements(bands))

absmag_array_norot_rsg=dblarr(n_elements(model_array_norot_rsgu),n_elements(bands))
BC_array_norot_rsg=dblarr(n_elements(model_array_norot_rsgu),n_elements(bands))

for i=0, n_elements(model_array_norot_rsgu) -1 DO begin
 for j=0, n_elements(bands) - 1 do begin 
  ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,dirmod,model_array_norot_rsgu[i],bands[j],Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt,/MARCSWEB;,norm_factor=norm_factor_array_norot_rsgu[i]
  mstar_array_norot_rsgu[i,j]=mstart 
  lstar_array_norot_rsgu[i,j]=lstart
  tstar_array_norot_rsgu[i,j]=tstart
  teff_array_norot_rsgu[i,j]=tstart
  absmag_array_norot_rsgu[i,j]=absolute_magt
  Mbol_array_norot_rsgu[i,j]=Mbolt
  BC_array_norot_rsgu[i,j]=BCt    
 endfor 
endfor  

;compute magnitudes of model u scaled to the same luminosity as model_l; thus luminosity of model l has to be used later to scale luminosities to those of the evol models
absmag_array_norot_rsgu_scl=dblarr(n_elements(model_array_norot_rsgu),n_elements(bands))
for i=0, n_elements(model_array_norot_rsgl) -1 DO BEGIN
  absmag_array_norot_rsgu_scl[i,*]=ZE_SCALE_MAG_FROM_L(absmag_array_norot_rsgu[i,*],lstar_array_norot_rsgl[i,0]/lstar_array_norot_rsgu[i,0])
endfor

;linear fit between model l and model u_scl for absolute magnitudes and bolometric corrections as a function of log (lstar)
 for i=0,  n_elements(model_array_norot_rsgl) -1 DO BEGIN
  for j=0, n_elements(bands) -1 DO BEGIN
    linterp,alog10([tstar_array_norot_rsgl[i,j],tstar_array_norot_rsgu[i,j]]),[absmag_array_norot_rsgl[i,j],absmag_array_norot_rsgu_scl[i,j]],alog10(evoltstar_array_norot_rsg[i]),maginter
    absmag_array_norot_rsg[i,j]=maginter
    linterp,alog10([tstar_array_norot_rsgl[i,j],tstar_array_norot_rsgu[i,j]]),[bc_array_norot_rsgl[i,j],bc_array_norot_rsgu[i,j]],alog10(evoltstar_array_norot_rsg[i]),bcinter
    bc_array_norot_rsg[i,j]=bcinter    
  endfor
 endfor    

;scales interpolated luminosity to luminosity of evol model
absmag_array_norot_rsg_scl_to_evol=dblarr(n_elements(model_array_norot_rsgu),n_elements(bands))
for i=0, n_elements(evollstar_array_norot_rsg) -1 DO BEGIN
  absmag_array_norot_rsg_scl_to_evol[i,*]=ZE_SCALE_MAG_FROM_L(absmag_array_norot_rsg[i,*],evollstar_array_norot_rsg[i]/lstar_array_norot_rsgl[i,0])
endfor

uminusb_norot_rsg=dblarr(n_elements(model_array_norot_rsgl)) & bminusv_norot_rsg=dblarr(n_elements(model_array_norot_rsgl)) & vminusi_norot_rsg=dblarr(n_elements(model_array_norot_rsgl))

for i=0, n_elements(uminusb_norot_rsg) -1 DO begin 
  uminusb_norot_rsg[i]=absmag_Array_norot_rsg[i,0]-absmag_Array_norot_rsg[i,1]
  bminusv_norot_rsg[i]=absmag_Array_norot_rsg[i,1]-absmag_Array_norot_rsg[i,2]
  vminusi_norot_rsg[i]=absmag_Array_norot_rsg[i,2]-absmag_Array_norot_rsg[i,4]  
endfor  





;Mv and BCs ARRAY key for non-rot_rsg: 
;(for rot_rsg models, add 20 msun model as the first row)

; [ Mu25  Mu32  Mu40 ... Mu120 
;   Mb25  Mb32  Mb40 ... Mb120 
;   Mv25  Mv32  Mv40 ... Mv120 
;    .
;   Mi25  Mi32  Mi40 ... Mi120] 

  
;;save,filename='/Users/jgroh/temp/ze_cmfgen_evol_sn_progenitors_rsgs_mag_bcs_all.sav',/all
;;STOP
restore,'/Users/jgroh/temp/ze_cmfgen_evol_sn_progenitors_rsgs_mag_bcs_all.sav'


sntype_array_rot_rsg=['II-P','II-P','II-P','II-L/b']  
sntype_array_norot_rsg=['II-P','II-P','II-P','II-L/b','II-L/b']  
;!P.Background = fsc_color('white')
;;lineplot,tstar_array,Mv_array
;
;for j=0, n_elements(bands) - 1 do begin 
;
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V3,mstar_array_rot_rsg[*,j],Mv_array_rot_rsg[*,j],'Mini','M_'+bands[j],'',_EXTRA=extra,psym1=sntype_array_rot_rsg,symsize1=3,symcolor1='red',/yreverse, $
;                               x2=mstar_array_norot_rsg[*,j],y2=Mv_array_norot_rsg[*,j],psym2=sntype_array_norot_rsg,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21
;                              
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V3,mstar_array_rot_rsg[*,j],BC_array_rot_rsg[*,j],'Mini','BC_'+bands[j],'',_EXTRA=extra,psym1=sntype_array_rot_rsg,symsize1=3,symcolor1='red', $
;                               x2=mstar_array_norot_rsg[*,j],y2=BC_array_norot_rsg[*,j],psym2=sntype_array_norot_rsg,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21                         
;                               
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V3,alog10(tstar_array_rot_rsg[*,j]),Mv_array_rot_rsg[*,j],'log_Tstar','M_'+bands[j],'',_EXTRA=extra,psym1=sntype_array_rot_rsg,symsize1=3,symcolor1='red',/yreverse,/xreverse, $
;                               x2=alog10(tstar_array_norot_rsg[*,j]),y2=Mv_array_norot_rsg[*,j],psym2=sntype_array_norot_rsg,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21
;                               
;;ZE_EVOL_PLOT_XY_GENERAL_EPS_V3,alog10(teff_array_rot_rsg[*,j]),Mv_array_rot_rsg[*,j],'log_Teff','M_'+bands[j],'',_EXTRA=extra,psym1=sntype_array_rot_rsg,symsize1=3,symcolor1='red',/yreverse, /xreverse,$
;;                               x2=alog10(teff_array_norot_rsg[*,j]),y2=Mv_array_norot_rsg[*,j],psym2=sntype_array_norot_rsg,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21                                                           
;;
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V3,alog10(tstar_array_rot_rsg[*,j]),BC_array_rot_rsg[*,j],'log_Tstar','BC_'+bands[j],'',_EXTRA=extra,psym1=sntype_array_rot_rsg,symsize1=3,symcolor1='red',/xreverse, $
;                               x2=alog10(tstar_array_norot_rsg[*,j]),y2=BC_array_norot_rsg[*,j],psym2=sntype_array_norot_rsg,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21;,x3=logtstar_yoon,y3=BC_yoon  
;                               
;;ZE_EVOL_PLOT_XY_GENERAL_EPS_V3,alog10(teff_array_rot_rsg[*,j]),BC_array_rot_rsg[*,j],'log_Teff','BC_'+bands[j],'',_EXTRA=extra,psym1=sntype_array_rot_rsg,symsize1=3,symcolor1='red',/xreverse, $
;;                               x2=alog10(teff_array_norot_rsg[*,j]),y2=BC_array_norot_rsg[*,j],psym2=sntype_array_norot_rsg,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21                                      
;;
;endfor
;;
;
;j=2 ; V band
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V3,bminusv_rot_rsg,Mv_array_rot_rsg[*,j],'B-V','M_'+bands[j],'',_EXTRA=extra,psym1=sntype_array_rot_rsg,symsize1=3,symcolor1='red',/yreverse,                                x2=bminusv_norot_rsg,y2=Mv_array_norot_rsg[*,j],psym2=sntype_array_norot_rsg,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.20,0.97,0.97],charthick=17,xthick=17,ythick=17          
;
;
;for i=0, n_elements(model_array_norot_rsg) - 1 do begin
;    print,mstar_array_norot_rsg[i,0], ' & ', lstar_array_norot_rsg[i,0], ' & ',tstar_array_norot_rsg[i,0], ' & ',teff_array_norot_rsg[i,0], ' & ', mv_array_norot_rsg[i,0], ' & ', mv_array_norot_rsg[i,1], ' & ', $
;          mv_array_norot_rsg[i,2], ' & ', mv_array_norot_rsg[i,3], ' & ',mv_array_norot_rsg[i,4], ' & ', bc_array_norot_rsg[i,0], ' & ',$
;           bc_array_norot_rsg[i,1], ' & ', bc_array_norot_rsg[i,2],' & ', bc_array_norot_rsg[i,3],' & ', bc_array_norot_rsg[i,4],' \\',$
;          FORMAT='(I,A,F7,A,F6,A,F6,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2, A)'
;endfor
;
;for i=0, n_elements(model_array_rot_rsg) - 1 do begin
;    print,mstar_array_rot_rsg[i,0], ' & ', lstar_array_rot_rsg[i,0], ' & ',tstar_array_rot_rsg[i,0], ' & ',teff_array_rot_rsg[i,0], ' & ', mv_array_rot_rsg[i,0], ' & ', mv_array_rot_rsg[i,1], ' & ', $
;          mv_array_rot_rsg[i,2], ' & ', mv_array_rot_rsg[i,3], ' & ',mv_array_rot_rsg[i,4], ' & ', bc_array_rot_rsg[i,0], ' & ',$
;           bc_array_rot_rsg[i,1], ' & ', bc_array_rot_rsg[i,2],' & ', bc_array_rot_rsg[i,3],' & ', bc_array_rot_rsg[i,4],' \\',$
;          FORMAT='(I,A,F7,A,F6,A,F6,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2, A)'
;endfor
END
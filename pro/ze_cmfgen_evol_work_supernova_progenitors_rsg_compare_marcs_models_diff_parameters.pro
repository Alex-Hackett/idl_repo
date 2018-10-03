;;PRO ZE_CMFGEN_EVOL_WORK_SUPERNOVA_PROGENITORS_RSG_COMPARE_MARCS_MODELS_DIFF_PARAMETERS
;;comparing marcs models with different parameters, e.g. log g, cno abundance, mass
;
;bands=['U','B','V','R','I','WFPC2_F300W','WFPC2_F450W','WFPC2_F606W','WFPC2_F814W']
;
;model_array_rot=['s3400_g+0.0_m5.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00','s3400_g+0.0_m5.0_t02_st_z+0.00_a+0.00_c+0.00_n+0.00_o+0.00_r+0.00_s+0.00','s3400_g+0.0_m5.0_t05_st_z+0.00_a+0.00_c+0.00_n+0.00_o+0.00_r+0.00_s+0.00','s3400_g+0.0_m15._t05_st_z+0.00_a+0.00_c+0.00_n+0.00_o+0.00_r+0.00_s+0.00']
;evolmass_array_rot=[1,2,3,4]
;
;model_array_norot=['s3600_g+0.0_m5.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00','s3600_g+0.0_m5.0_t02_st_z+0.00_a+0.00_c+0.00_n+0.00_o+0.00_r+0.00_s+0.00','s3600_g+0.0_m5.0_t05_st_z+0.00_a+0.00_c+0.00_n+0.00_o+0.00_r+0.00_s+0.00','s3600_g+0.0_m15._t05_st_z+0.00_a+0.00_c+0.00_n+0.00_o+0.00_r+0.00_s+0.00']
;evolmass_array_norot=[1,2,3,4]
;
;bands=['U','B','V','R','I']
;mstar_array_norot=dblarr(n_elements(model_array_norot),n_elements(bands))
;lstar_array_norot=dblarr(n_elements(model_array_norot),n_elements(bands))
;tstar_array_norot=dblarr(n_elements(model_array_norot),n_elements(bands))
;teff_array_norot=dblarr(n_elements(model_array_norot),n_elements(bands))
;Mv_array_norot=dblarr(n_elements(model_array_norot),n_elements(bands))
;Mbol_array_norot=dblarr(n_elements(model_array_norot),n_elements(bands))
;BC_array_norot=dblarr(n_elements(model_array_norot),n_elements(bands))
;
;for i=0, n_elements(model_array_norot) -1 DO begin
; for j=0, n_elements(bands) - 1 do begin 
;  ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,dirmod,model_array_norot[i],bands[j],Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt,/MARCSWEB;,norm_factor=norm_factor_array_norot[i]
;  mstar_array_norot[i,j]=evolmass_array_rot[i] 
;  lstar_array_norot[i,j]=lstart
;  tstar_array_norot[i,j]=tstart
;   teff_array_norot[i,j]=tstart
;  Mv_array_norot[i,j]=absolute_magt
;  Mbol_array_norot[i,j]=Mbolt
;  BC_array_norot[i,j]=BCt    
; endfor 
;endfor  
;                               
;uminusb_norot=dblarr(n_elements(model_array_norot)) & bminusv_norot=dblarr(n_elements(model_array_norot)) & vminusi_norot=dblarr(n_elements(model_array_norot))
;
;for i=0, n_elements(uminusb_norot) -1 DO begin 
;  uminusb_norot[i]=Mv_array_norot[i,0]-Mv_array_norot[i,1]
;  bminusv_norot[i]=Mv_array_norot[i,1]-Mv_array_norot[i,2]
;  vminusi_norot[i]=Mv_array_norot[i,2]-Mv_array_norot[i,4]  
;endfor  
;
;mstar_array_rot=dblarr(n_elements(model_array_rot),n_elements(bands))
;lstar_array_rot=dblarr(n_elements(model_array_rot),n_elements(bands))
;tstar_array_rot=dblarr(n_elements(model_array_rot),n_elements(bands))
;teff_array_rot=dblarr(n_elements(model_array_rot),n_elements(bands))
;Mv_array_rot=dblarr(n_elements(model_array_rot),n_elements(bands))
;Mbol_array_rot=dblarr(n_elements(model_array_rot),n_elements(bands))
;BC_array_rot=dblarr(n_elements(model_array_rot),n_elements(bands))
;
;for i=0, n_elements(model_array_rot) -1 DO begin
; for j=0, n_elements(bands) - 1 do begin 
;  ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,dirmod,model_array_rot[i],bands[j],Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt,/MARCSWEB;,norm_factor=norm_factor_array_rot[i]
;  mstar_array_rot[i,j]=evolmass_array_rot[i] 
;  lstar_array_rot[i,j]=lstart
;  tstar_array_rot[i,j]=tstart
;   teff_array_rot[i,j]=tstart
;  Mv_array_rot[i,j]=absolute_magt
;  Mbol_array_rot[i,j]=Mbolt
;  BC_array_rot[i,j]=BCt    
; endfor 
;endfor  
;
;                               
;uminusb_rot=dblarr(n_elements(model_array_rot)) & bminusv_rot=dblarr(n_elements(model_array_rot)) & vminusi_rot=dblarr(n_elements(model_array_rot))
;
;for i=0, n_elements(uminusb_rot) -1 DO begin 
;  uminusb_rot[i]=Mv_array_rot[i,0]-Mv_array_rot[i,1]
;  bminusv_rot[i]=Mv_array_rot[i,1]-Mv_array_rot[i,2]
;  vminusi_rot[i]=Mv_array_rot[i,2]-Mv_array_rot[i,4]  
;endfor  

restore,'/Users/jgroh/temp/ze_cmfgen_evol_marcs_mag_bcs_compare.sav'

;Mv and BCs ARRAY key for non-rot: 
;(for rot models, add 20 msun model as the first row)

; [ Mu25  Mu32  Mu40 ... Mu120 
;   Mb25  Mb32  Mb40 ... Mb120 
;   Mv25  Mv32  Mv40 ... Mv120 
;    .
;   Mi25  Mi32  Mi40 ... Mi120] 

  
;
for l=0, n_elements(bands) - 1 do begin 
print,l

ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,reform(mstar_array_rot[*,l]),reform(Mv_array_rot[*,l]),'Mini','M_'+bands[l],'',_EXTRA=extra,psym1=3,symsize1=3,symcolor1='red',/yreverse, $
                               x2=reform(mstar_array_norot[*,l]),y2=reform(Mv_array_norot[*,l]),psym2=4,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21,ct=0
;                              
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,reform(mstar_array_rot[*,l]),reform(BC_array_rot[*,l]),'Mini','BC_'+bands[l],'',_EXTRA=extra,psym1=4,symsize1=3,symcolor1='red', $
                               x2=reform(mstar_array_norot[*,l]),y2=reform(BC_array_norot[*,l]),psym2=5,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21                         
                               
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,alog10(tstar_array_rot[*,j]),Mv_array_rot[*,j],'log_Tstar','M_'+bands[j],'',_EXTRA=extra,psym1=sntype_array_rot,symsize1=3,symcolor1='red',/yreverse,/xreverse, $
;                               x2=alog10(tstar_array_norot[*,j]),y2=Mv_array_norot[*,j],psym2=sntype_array_norot,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21
                               
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,alog10(teff_array_rot[*,j]),Mv_array_rot[*,j],'log_Teff','M_'+bands[j],'',_EXTRA=extra,psym1=sntype_array_rot,symsize1=3,symcolor1='red',/yreverse, /xreverse,$
;                               x2=alog10(teff_array_norot[*,j]),y2=Mv_array_norot[*,j],psym2=sntype_array_norot,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21                                                           
;
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,alog10(tstar_array_rot[*,j]),BC_array_rot[*,j],'log_Tstar','BC_'+bands[j],'',_EXTRA=extra,psym1=sntype_array_rot,symsize1=3,symcolor1='red',/xreverse, $
;                               x2=alog10(tstar_array_norot[*,j]),y2=BC_array_norot[*,j],psym2=sntype_array_norot,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21;,x3=logtstar_yoon,y3=BC_yoon  
                               
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,alog10(teff_array_rot[*,j]),BC_array_rot[*,j],'log_Teff','BC_'+bands[j],'',_EXTRA=extra,psym1=sntype_array_rot,symsize1=3,symcolor1='red',/xreverse, $
;                               x2=alog10(teff_array_norot[*,j]),y2=BC_array_norot[*,j],psym2=sntype_array_norot,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21                                      
;
endfor
;
;
j=2 ; V band
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,bminusv_rot,Mv_array_rot[*,j],'B-V','M_'+bands[j],'',_EXTRA=extra,psym1=4,symsize1=3,symcolor1='red',/yreverse,$
                                x2=bminusv_norot,y2=Mv_array_norot[*,j],psym2=5,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.20,0.97,0.97],charthick=17,xthick=17,ythick=17          
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
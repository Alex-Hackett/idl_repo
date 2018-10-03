;PRO ZE_CMFGEN_EVOL_WORK_SUPERNOVA_PROGENITORS

;model_array=['P025z14S0_model042063_T024625_L0318560_logg2.439','P025z14S4_model030888_T027115_L0239316_logg2.663','P032z14S0_model029922_T045794_L0367647_logg3.507','P032z14S4_model075198_T181508_L0337150_logg5.904',$
;'P040z14S0_model025890_T022443_L0471804_logg2.229','P040z14S4_model085774_T211679_L0438412_logg6.142','P060z14S0_model23950_T224855_L483178_logg6d211_vinf5000','model23950_T224855_L483178_logg6d211_2',$
;'P085z14S0_model024500_T236325_L0899663_logg6.201', 'P085z14S4_model045758_T266698_L1310829_logg6.399','P120z14S0_model025926_T167648_L1784201_logg5.527','P120z14S4_model064569_T252831_L0856258_logg6.349']


;model_array=['P025z14S4_model030888_T027115_L0239316_logg2.663','P032z14S4_model075198_T181508_L0337150_logg5.904',$
;'P040z14S4_model085774_T211679_L0438412_logg6.142','P060z14S0_model23950_T224855_L483178_logg6d211_vinf5000','P060z14S0_model23950_T224855_L483178_logg6d211_2','P060z14S4_model054963_T247137_L0784953_logg6.322',$
;'P085z14S0_model024500_T236325_L0899663_logg6.201', 'P085z14S4_model045758_T266698_L1310829_logg6.399','P120z14S0_model025926_T167648_L1784201_logg5.527','P120z14S4_model064569_T252831_L0856258_logg6.349']          
;
;lstar_array=dblarr(n_elements(model_Array)) & tstar_array=lstaR_array &  Mv_array=lstaR_array & Mbol_array=lstaR_array & BC_array=lstaR_array & mstar_array=lstaR_array
;teff_Array=[2.633E+04,1.541E+05,1.611E+05,1.646E+05,1.274E+05,1.745E+05,1.669E+05,1.684E+05,1.745E+05]
;
model_array_rot=['P020z14S4_model049869_T020358_L0191044_logg2.200','P025z14S4_model042063_T024625_L0318560_logg2.439','P032z14S4_model075198_T181508_L0337150_logg5.904','P040z14S4_model085774_T211679_L0438412_logg6.142','P060z14S4_model054963_T247137_L0784953_logg6.322',$
 'P085z14S4_model045758_T266698_L1310829_logg6.399','P120z14S4_model064569_T252831_L0856258_logg6.349']  

lstar_array_rot=dblarr(n_elements(model_array_rot)) & tstar_array_rot=lstaR_array_rot &  Mv_array_rot=lstaR_array_rot & Mbol_array_rot=lstaR_array_rot & BC_array_rot=lstaR_array_rot & mstar_array_rot=lstaR_array_rot
teff_Array_rot=[1.954E+04,2.000E+04,1.541E+05,1.611E+05,1.745E+05,1.684E+05,1.745E+05]

model_array_norot=['P025z14S0_model030888_T027115_L0239316_logg2.663','P032z14S0_model029922_T045794_L0367647_logg3.507','P040z14S0new_model106339_T048183_L0482467_logg3.576','P050z14S0_model025417_T235060_L0743448_logg6.222','P060z14S0_model23950_T224855_L483178_logg6d211_vinf5000','P085z14S0_model024500_T236325_L0899663_logg6.201',$
'P120z14S0_model025926_T167648_L1784201_logg5.527'];,'P150z14S0_model133387_T255016_L0905517_logg6.366']
 
lstar_array_norot=dblarr(n_elements(model_array_norot)) & tstar_array_norot=lstaR_array_norot &  Mv_array_norot=lstaR_array_norot & Mbol_array_norot=lstaR_array_norot & BC_array_norot=lstaR_array_norot & mstar_array_norot=lstaR_array_norot
teff_Array_norot=[2.633E+04,4.048E+04,4.048E+04,1.612E+05 ,1.646E+05,1.669E+05,1.684E+05];,1.672e+05]

dirmod='/Users/jgroh/ze_models/SN_progenitor_grid/'

;
;;BC x Tstar calibration from Yoon
;
;logtstar_yoon=[4.3,4.5,4.7,4.9,5.1,5.3,5.5]
;BC_yoon = 22.053 - 5.306*logtstar_yoon
;
;;ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES,dirmod,'s3700_g-0.5_m1.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00',band,Mstart,Lstart,tstart,Mvt,Mbolt,BCt,/marcs
;
;
;bands=['U','B','V','R','I','WFPC2_F300W','WFPC2_F450W','WFPC2_F606W','WFPC2_F814W']
;
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
;  ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,dirmod,model_array_norot[i],bands[j],Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt
;  mstar_array_norot[i,j]=mstart 
;  lstar_array_norot[i,j]=lstart
;  tstar_array_norot[i,j]=tstart
;   teff_array_norot[i,j]=tstart
;  Mv_array_norot[i,j]=absolute_magt
;  Mbol_array_norot[i,j]=Mbolt
;  BC_array_norot[i,j]=BCt    
; endfor 
;endfor  
;
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
;  ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,dirmod,model_array_rot[i],bands[j],Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt
;  mstar_array_rot[i,j]=mstart 
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
;
;
;;Mv and BCs ARRAY key for non-rot: 
;;(for rot models, add 20 msun model as the first row)
;
;; [ Mu25  Mu32  Mu40 ... Mu120 
;;   Mb25  Mb32  Mb40 ... Mb120 
;;   Mv25  Mv32  Mv40 ... Mv120 
;;    .
;;   Mi25  Mi32  Mi40 ... Mi120] 
;
;restore,'/Users/jgroh/temp/ze_cmfgen_evol_sn_progenitors_rsgs_mag_bcs_all.sav'
;
;
;
;sntype_array_rot=dblarr(n_elements(model_array_rot))
;sntype_array_rot=['II-L/b','II-L/b','Ic','Ic','Ic','Ib','Ic']  
;   
;sntype_array_norot=dblarr(n_elements(model_array_norot))
;sntype_array_norot=['II-L/b','Ib','Ib','Ic','Ic','Ic','Ib']; assuming 50 is Ic, check this   
;
;;merge arrays of RGSs
;
;model_array_rot=[model_array_rot_rsgl,model_array_rot]
;mstar_array_rot=[cmreplicate(evolmass_array_rot_rsg,n_elements(bands)),mstar_array_rot]
;Mv_array_rot=[absmag_array_rot_rsg_scl_to_evol,Mv_array_rot]
;sntype_array_rot=[sntype_array_rot_rsg,sntype_array_rot]
;uminusb_rot=[uminusb_rot_rsg,uminusb_rot]
;bminusv_rot=[bminusv_rot_rsg,bminusv_rot]
;vminusi_rot=[vminusi_rot_rsg,vminusi_rot]
;BC_array_rot=[BC_array_rot_rsg,BC_array_rot]
;lstar_array_rot=[cmreplicate(evollstar_array_rot_rsg,n_elements(bands)),lstar_array_rot]
;tstar_array_rot=[cmreplicate(evoltstar_array_rot_rsg,n_elements(bands)),tstar_array_rot]
;teff_array_rot=[cmreplicate(evolteff_array_rot_rsg,n_elements(bands)),teff_array_rot]
;
;model_array_norot=[model_array_norot_rsgl,model_array_norot]
;mstar_array_norot=[cmreplicate(evolmass_array_norot_rsg,n_elements(bands)),mstar_array_norot]
;Mv_array_norot=[absmag_array_norot_rsg_scl_to_evol,Mv_array_norot]
;sntype_array_norot=[sntype_array_norot_rsg,sntype_array_norot]
;uminusb_norot=[uminusb_norot_rsg,uminusb_norot]
;bminusv_norot=[bminusv_norot_rsg,bminusv_norot]
;vminusi_norot=[vminusi_norot_rsg,vminusi_norot]
;BC_array_norot=[BC_array_norot_rsg,BC_array_norot]
;lstar_array_norot=[cmreplicate(evollstar_array_norot_rsg,n_elements(bands)),lstar_array_norot]
;tstar_array_norot=[cmreplicate(evoltstar_array_norot_rsg,n_elements(bands)),tstar_array_norot]
;teff_array_norot=[cmreplicate(evolteff_array_norot_rsg,n_elements(bands)),teff_array_norot]

restore,'/Users/jgroh/temp/ze_cmfgen_evol_sn_progenitors_mag_bcs_all.sav'

!P.Background = fsc_color('white')
;lineplot,tstar_array,Mv_array

for j=0, n_elements(bands) - 1 do begin 

ZE_EVOL_PLOT_XY_GENERAL_EPS_V3,mstar_array_rot[*,j],Mv_array_rot[*,j],'Mini','M_'+bands[j],'',_EXTRA=extra,psym1=sntype_array_rot,symsize1=3,symcolor1='red',/yreverse, $
                               x2=mstar_array_norot[*,j],y2=Mv_array_norot[*,j],psym2=sntype_array_norot,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21
                              
ZE_EVOL_PLOT_XY_GENERAL_EPS_V3,mstar_array_rot[*,j],BC_array_rot[*,j],'Mini','BC_'+bands[j],'',_EXTRA=extra,psym1=sntype_array_rot,symsize1=3,symcolor1='red', $
                               x2=mstar_array_norot[*,j],y2=BC_array_norot[*,j],psym2=sntype_array_norot,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21                         
;                               
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V3,alog10(tstar_array_rot[*,j]),Mv_array_rot[*,j],'log_Tstar','M_'+bands[j],'',_EXTRA=extra,psym1=sntype_array_rot,symsize1=3,symcolor1='red',/yreverse,/xreverse, $
;                               x2=alog10(tstar_array_norot[*,j]),y2=Mv_array_norot[*,j],psym2=sntype_array_norot,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21
;                               
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V3,alog10(teff_array_rot[*,j]),Mv_array_rot[*,j],'log_Teff','M_'+bands[j],'',_EXTRA=extra,psym1=sntype_array_rot,symsize1=3,symcolor1='red',/yreverse, /xreverse,$
;                               x2=alog10(teff_array_norot[*,j]),y2=Mv_array_norot[*,j],psym2=sntype_array_norot,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21                                                           
;
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V3,alog10(tstar_array_rot[*,j]),BC_array_rot[*,j],'log_Tstar','BC_'+bands[j],'',_EXTRA=extra,psym1=sntype_array_rot,symsize1=3,symcolor1='red',/xreverse, $
;                               x2=alog10(tstar_array_norot[*,j]),y2=BC_array_norot[*,j],psym2=sntype_array_norot,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21;,x3=logtstar_yoon,y3=BC_yoon  
;                               
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V3,alog10(teff_array_rot[*,j]),BC_array_rot[*,j],'log_Teff','BC_'+bands[j],'',_EXTRA=extra,psym1=sntype_array_rot,symsize1=3,symcolor1='red',/xreverse, $
;                               x2=alog10(teff_array_norot[*,j]),y2=BC_array_norot[*,j],psym2=sntype_array_norot,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21                                      

endfor

;HAVE TO DO SEPARATE PLOTS BECAUSE RSG PROGENITORS ARE DETECTED IN DIFFERENT BANDS

;only for RSGs with fit Mini x absmag
j=3 ;R band
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
print,'rot ', massfitrot
massfitnorot = linfit(Mv_array_norot[0:3,j],mstar_array_norot[0:3,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
print,'norot ', massfitnorot

result = linfit(mstar_array_rot[0:2,j],Mv_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
print,'rot ', result
result = linfit(mstar_array_norot[0:3,j],Mv_array_norot[0:3,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
print,'norot ', result
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,mstar_array_rot[0:2,j],Mv_array_rot[0:2,j],'Mini','M_'+bands[j],'RSG',_EXTRA=extra,psym1=4,symsize1=3,symcolor1='red',/yreverse, $
                               x2=mstar_array_norot[0:3,j],y2=Mv_array_norot[0:3,j],psym2=5,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21,ct=0,$
                               x3=mstar_array_rot[0:2,j],y3=yfitrot,linestyle3=2,color3='red',x4=mstar_array_norot[0:3,j],y4=yfitnorot,linestyle4=2,color4='blue',$
                               x5=[massrot03gdr,massrot03ie],y5=[absmagr03gd,absmagr03ie],psym5=6,symsize5=3,symcolor5='dark grey',$
                               x6=[massnorot03gdr,massnorot03ie],y6=[absmagr03gd,absmagr03ie],psym6=6,symsize6=3,symcolor6='orange'

;only for RSGs with fit Mini x absmag
j=4 ;I band
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
print,'rot ', massfitrot
massfitnorot = linfit(Mv_array_norot[0:3,j],mstar_array_norot[0:3,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
print,'norot ', massfitnorot

result = linfit(mstar_array_rot[0:2,j],Mv_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
print,'rot ', result
result = linfit(mstar_array_norot[0:3,j],Mv_array_norot[0:3,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
print,'norot ', result
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,mstar_array_rot[0:2,j],Mv_array_rot[0:2,j],'Mini','M_'+bands[j],'RSG',_EXTRA=extra,psym1=4,symsize1=3,symcolor1='red',/yreverse, $
                               x2=mstar_array_norot[0:3,j],y2=Mv_array_norot[0:3,j],psym2=5,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21,ct=0,$
                               x3=mstar_array_rot[0:2,j],y3=yfitrot,linestyle3=2,color3='red',x4=mstar_array_norot[0:3,j],y4=yfitnorot,linestyle4=2,color4='blue',$
                               x5=[massrot99em,massrot02hh,massrot03gdi],y5=[absmagi99em,absmagi02hh,absmagi03gd],psym5=6,symsize5=3,symcolor5='dark grey',$
                               x6=[massnorot99em,massnorot02hh,massnorot03gdi],y6=[absmagi99em,absmagi02hh,absmagi03gd],psym6=6,symsize6=3,symcolor6='orange'
                               

;only for RSGs with fit Mini x absmag
j=7 ;F606W
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
print,'rot ', massfitrot
massfitnorot = linfit(Mv_array_norot[0:3,j],mstar_array_norot[0:3,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
print,'norot ', massfitnorot

result = linfit(mstar_array_rot[0:2,j],Mv_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
print,'rot ', result
result = linfit(mstar_array_norot[0:3,j],Mv_array_norot[0:3,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
print,'norot ', result
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,mstar_array_rot[0:2,j],Mv_array_rot[0:2,j],'Mini','M_'+bands[j],'RSG',_EXTRA=extra,psym1=4,symsize1=3,symcolor1='red',/yreverse, $
                               x2=mstar_array_norot[0:3,j],y2=Mv_array_norot[0:3,j],psym2=5,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21,ct=0,$
                               x3=mstar_array_rot[0:2,j],y3=yfitrot,linestyle3=2,color3='red',x4=mstar_array_norot[0:3,j],y4=yfitnorot,linestyle4=2,color4='blue',$
                               x5=[massrot99br,massrot99gi,massrot09md],y5=[absmagf606w99br,absmagf606w99gi,absmagf606w09md],psym5=6,symsize5=3,symcolor5='dark grey',$
                               x6=[massnorot99br,massnorot99gi,massnorot09md],y6=[absmagf606w99br,absmagf606w99gi,absmagf606w09md],psym6=6,symsize6=3,symcolor6='orange'
                               
;only for RSGs with fit Mini x absmag
j=8 ;F814W
massfitrot = linfit(Mv_array_rot[0:2,j],mstar_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
print,'rot ', massfitrot
massfitnorot = linfit(Mv_array_norot[0:3,j],mstar_array_norot[0:3,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
print,'norot ', massfitnorot

result = linfit(mstar_array_rot[0:2,j],Mv_array_rot[0:2,j], chisq = chisqrot, prob = probrot, yfit=yfitrot, sigma=sigmarot)
print,'rot ', result
result = linfit(mstar_array_norot[0:3,j],Mv_array_norot[0:3,j], chisq = chisqnorot, prob = probnorot, yfit=yfitnorot, sigma=sigmanorot)
print,'norot ', result
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,mstar_array_rot[0:2,j],Mv_array_rot[0:2,j],'Mini','M_'+bands[j],'RSG',_EXTRA=extra,psym1=4,symsize1=3,symcolor1='red',/yreverse, $
                               x2=mstar_array_norot[0:3,j],y2=Mv_array_norot[0:3,j],psym2=5,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21,ct=0,$
                               x3=mstar_array_rot[0:2,j],y3=yfitrot,linestyle3=2,color3='red',x4=mstar_array_norot[0:3,j],y4=yfitnorot,linestyle4=2,color4='blue',$
                            ;has all   x5=[massrot01du,massrot04dg,massrot05cs,massrot06bc,massrot06my,massrot06ov,massrot07aa,massrot09hd,massrot09md,massrot12aw],$
                            ;has all  y5=[absmagf814w01du,absmagf814w04dg,absmagf814w05cs,absmagf814w06bc,absmagf814w06my,absmagf814w06ov,absmagf814w07aa,absmagf814w09hd,absmagf814w09md,absmagf814w12aw],psym5=6,symsize5=3,symcolor5='dark grey',$
                            ;has all   x6=[massnorot01du,massnorot04dg,massnorot05cs,massnorot06bc,massnorot06my,massnorot06ov,massnorot07aa,massnorot09hd,massnorot09md,massnorot12aw],$
                            ;has all   y6=[absmagf814w01du,absmagf814w04dg,absmagf814w05cs,absmagf814w06bc,absmagf814w06my,absmagf814w06ov,absmagf814w07aa,absmagf814w09hd,absmagf814w09md,absmagf814w12aw],psym6=6,symsize6=3,symcolor6='orange',$
                               x5=[massrot01du,massrot04dg,massrot06bc,massrot06my,massrot06ov,massrot07aa],$
                               y5=[absmagf814w01du,absmagf814w04dg,absmagf814w06bc,absmagf814w06my,absmagf814w06ov,absmagf814w07aa],psym5=13,symsize5=3,symcolor5='dark grey',$
                               x6=[massnorot01du,massnorot04dg,massnorot06bc,massnorot06my,massnorot06ov,massnorot07aa],$
                               y6=[absmagf814w01du,absmagf814w04dg,absmagf814w06bc,absmagf814w06my,absmagf814w06ov,absmagf814w07aa],psym6=13,symsize6=3,symcolor6='orange',$                                                            
                               x7=[massrot05cs,massrot09hd,massrot09md,massrot12aw],y7=[absmagf814w05cs,absmagf814w09hd,absmagf814w09md,absmagf814w12aw],psym7=16,symsize7=3,symcolor7='dark grey',$
                               x8=[massnorot05cs,massnorot09hd,massnorot09md,massnorot12aw],y8=[absmagf814w05cs,absmagf814w09hd,absmagf814w09md,absmagf814w12aw],psym8=16,symsize8=3,symcolor8='orange'


                               
    
j=2 ; V band x B - V
ZE_EVOL_PLOT_XY_GENERAL_EPS_V3,bminusv_rot,Mv_array_rot[*,j],'B-V','M_'+bands[j],'',_EXTRA=extra,psym1=sntype_array_rot,symsize1=3,symcolor1='red',/yreverse, $
                               x2=bminusv_norot,y2=Mv_array_norot[*,j],psym2=sntype_array_norot,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.20,0.97,0.97],charthick=17,xthick=17,ythick=17          

j=0 ; U band x U - B
ZE_EVOL_PLOT_XY_GENERAL_EPS_V3,uminusb_rot,Mv_array_rot[*,j],'U-B','M_'+bands[j],'',_EXTRA=extra,psym1=sntype_array_rot,symsize1=3,symcolor1='red',/yreverse, $
                               x2=uminusb_norot,y2=Mv_array_norot[*,j],psym2=sntype_array_norot,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.20,0.97,0.97],charthick=17,xthick=17,ythick=17          

j=2 ; V band x V - I
ZE_EVOL_PLOT_XY_GENERAL_EPS_V3,vminusi_rot,Mv_array_rot[*,j],'V-I','M_'+bands[j],'',_EXTRA=extra,psym1=sntype_array_rot,symsize1=3,symcolor1='red',/yreverse, $
                               x2=vminusi_norot,y2=Mv_array_norot[*,j],psym2=sntype_array_norot,symsize2=3,symcolor2='blue',xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.20,0.97,0.97],charthick=17,xthick=17,ythick=17        

for i=0, n_elements(model_array_norot) - 1 do begin
    print,mstar_array_norot[i,0], ' & ', lstar_array_norot[i,0], ' & ',tstar_array_norot[i,0], ' & ', mv_array_norot[i,0], ' & ', mv_array_norot[i,1], ' & ', $
          mv_array_norot[i,2], ' & ', mv_array_norot[i,3], ' & ',mv_array_norot[i,4], ' & ', bc_array_norot[i,0], ' & ',$
           bc_array_norot[i,1], ' & ', bc_array_norot[i,2],' & ', bc_array_norot[i,3],' & ', bc_array_norot[i,4],' \\',$
          FORMAT='(I,A,I7,A,I6,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2, A)'
endfor

for i=0, n_elements(model_array_rot) - 1 do begin
    print,mstar_array_rot[i,0], ' & ', lstar_array_rot[i,0], ' & ',tstar_array_rot[i,0],' & ', mv_array_rot[i,0], ' & ', mv_array_rot[i,1], ' & ', $
          mv_array_rot[i,2], ' & ', mv_array_rot[i,3], ' & ',mv_array_rot[i,4], ' & ', bc_array_rot[i,0], ' & ',$
           bc_array_rot[i,1], ' & ', bc_array_rot[i,2],' & ', bc_array_rot[i,3],' & ', bc_array_rot[i,4],' \\',$
          FORMAT='(I,A,I7,A,I6,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2,A,F5.2, A)'
endfor
END
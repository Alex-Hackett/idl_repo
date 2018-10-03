;PRO ZE_EVOL_CMFGEN_WORK_ATMOSPHERIC_MODELS_GRID_P060z14S0_SED_NON_NORMALIZED


restore,'/Users/jgroh/temp/ze_evol_cmfgen_work_atmospheric_modeling_variables_sed_non_normalized.sav'
;dirmod='/Users/jgroh/ze_models/grid_P060z14S0/'
;model='ZAMS_model57_T48386_L507016_logg_4d2015_Fe_OK'
;ZE_CMFGEN_READ_OBS,dirmod+model+'/obs/obs_fin_10',l1,f1,/FLAM
;
;model='model500_T47031_L52831_logg_4d1278_newabund'
;ZE_CMFGEN_READ_OBS,dirmod+model+'/obs/obs_fin_10',l2,f2,/FLAM
;
;model='model1000_T45796_L555083_logg_4d0519_newabund'
;ZE_CMFGEN_READ_OBS,dirmod+model+'/obs/obs_fin_10',l3,f3,/FLAM
;
;model='midH_model2500_T39375_L645563_logg_3d6925_newabund'
;ZE_CMFGEN_READ_OBS,dirmod+model+'/obs/obs_fin_10',l4,f4,/FLAM
;;
;model='model3500_T31088_L719179_logg_3d22'
;ZE_CMFGEN_READ_OBS,dirmod+model+'/obs/obs_fin_10',l5,f5,/FLAM
;;
;model='model3800_T27864_L743098_logg3d01'
;ZE_CMFGEN_READ_OBS,dirmod+model+'/obs/obs_fin_10',l6,f6,/FLAM
;;
;model='model5500_T30783_L941860_logg2d78'
;ZE_CMFGEN_READ_OBS,dirmod+model+'/obs/obs_fin_10',l7,f7,/FLAM
;
;model='model4301_T18573_l772592_logg2d267'
;ZE_CMFGEN_READ_OBS,dirmod+model+'/obs/obs_fin',l8,f8,/FLAM
;
;model='model4717_T20457_L818840_logg2d279'
;ZE_CMFGEN_READ_OBS,dirmod+model+'/obs/obs_fin',l9,f9,/FLAM
;
;model='model5500_T30783_L941860_logg_2d787'
;ZE_CMFGEN_READ_OBS,dirmod+model+'/obs/obs_fin_10',l10,f10,/FLAM
;
;model='model8201_T122874_L682455_logg5d294'
;ZE_CMFGEN_READ_OBS,dirmod+model+'/obs/obs_fin',l11,f11,/FLAM
;
;model='model18950_T140543_L350244_logg_5d580_hydro'
;ZE_CMFGEN_READ_OBS,dirmod+model+'/obs/obs_fin',l12,f12,/FLAM
;
;model='model23950_T224855_L483178_logg6d211_2'
;ZE_CMFGEN_READ_OBS,dirmod+model+'/obs/obs_fin',l13,f13,/FLAM

!P.Background = fsc_color('white')
timesteps=[56,500,1000,2500,3500,3800,5500]
;lineplot,l1,f1,title=string(timesteps[0],FORMAT='(I4)')
;lineplot,l2,f2,title=string(timesteps[1],FORMAT='(I4)')
;lineplot,l3,f3,title=string(timesteps[2],FORMAT='(I4)')
;lineplot,l4,f4,title=string(timesteps[3],FORMAT='(I4)')
;lineplot,l5,f5,title=string(timesteps[4],FORMAT='(I4)')
;lineplot,l6,f6,title=string(timesteps[5],FORMAT='(I4)')
;lineplot,l7,f7,title=string(timesteps[6],FORMAT='(I4)')


;EW measurements
;model   4471 4512, 4686   
meas=[[56,500,1000,2500,3500,3800],[0.0352,0.0403,0.0515,0.1670,0.4401,0.4912],[0.8429,0.8207,0.7988,0.6837,0.3183,0.1812],[0.4944,0.4349,0.3952,0.2434,-0.1313,0.1318],$
      [-0.0210,-0.0186,-0.0104,0.0132,0.1810,0.3379],[-0.00156,-0.00172,-0.00190,-0.00373,-0.0325,0.00169]]
logWprime=alog10(meas[*,1]/meas[*,2]) ;= log (EW(He I 4471)/EW(He II 4512)) 
log4686=alog10(meas[*,3]) ;=log EW(He II 4686)
logWdoubleprime=alog10(meas[*,4]/meas[*,5]) ;= log (EW(Si IV 4089)/EW(He II 4143)) 
;spectral type classification following mathis 1988
nmodels=n_elements(logWprime)
SpTYPE=strarr(nmodels)
for i=0, nmodels -1 DO BEGIN 
    IF (logWprime[i] LT 1.00 AND logWprime[i] GT 0.65) THEN SpType[i]='O9.7'
    IF (logWprime[i] LT 0.65 AND logWprime[i] GT 0.45) THEN SpType[i]='O9.5'
    IF (logWprime[i] LT 0.45 AND logWprime[i] GT 0.30) THEN SpType[i]='O9'    
    IF (logWprime[i] LT 0.30 AND logWprime[i] GT 0.20) THEN SpType[i]='O8.5'
    IF (logWprime[i] LT 0.20 AND logWprime[i] GT 0.10) THEN SpType[i]='O8'
    IF (logWprime[i] LT 0.10 AND logWprime[i] GT 0.00) THEN SpType[i]='O7.5'
    IF (logWprime[i] LT 0.00 AND logWprime[i] GT -0.10) THEN SpType[i]='O7'
    IF (logWprime[i] LT -0.10 AND logWprime[i] GT -0.20) THEN SpType[i]='O6.5'        
    IF (logWprime[i] LT -0.20 AND logWprime[i] GT -0.30) THEN SpType[i]='O6' 
    IF (logWprime[i] LT -0.30 AND logWprime[i] GT -0.45) THEN SpType[i]='O5.5' 
    IF (logWprime[i] LT -0.45 AND logWprime[i] GT -0.60) THEN SpType[i]='O5' 
    IF (logWprime[i] LT -0.60 AND logWprime[i] GT -0.90) THEN SpType[i]='O4' 
    IF (logWprime[i] LT -0.90) THEN SpType[i]='O3'    
ENDFOR

;luminosity classification following mathis 1988, markova+11
LumClass=strarr(nmodels)
for i=0, nmodels -1 DO BEGIN 
    IF (logWprime[i] LT -0.10) THEN BEGIN ;these are SpType < O7
      IF (log4686[i] GT -0.25) THEN LumClass[i]='V' ELSE LumClass[i]='III'
    ENDIF ELSE BEGIN ;these are SPType > 07, using the classification of Conti & Alschuler 1971
      IF (logWdoubleprime[i] LT 0.10 AND logWdoubleprime[i] GT -0.20) THEN LumClass[i]='V'
      IF (logWdoubleprime[i] LT 0.30 AND logWdoubleprime[i] GT 0.10) THEN LumClass[i]='III'
      IF (logWdoubleprime[i] GT 0.30) THEN LumClass[i]='I'    
;      IF (logWdoubleprime[i] GT 5.35) THEN LumClass[i]='V'
;      IF (logWdoubleprime[i] LT 5.35 AND logWdoubleprime[i] GT 5.05) THEN LumClass[i]='III'
;      IF (logWdoubleprime[i] LT 5.05) THEN LumClass[i]='I'
    ENDELSE
ENDFOR

print,SpTYpe
print,LumClass

l1=alog10(l1)
l6=alog10(l6)
l9=alog10(l9)
l10=alog10(l10)
l11=alog10(l11)
l12=alog10(l12)
l13=alog10(l13)
f1=alog10(f1)
f6=alog10(f6)
f9=alog10(f9)
f10=alog10(f10)
f11=alog10(f11)
f12=alog10(f12)
f13=alog10(f13)

ZE_CMFGEN_PLOT_SPECTRA_GENERAL_EPS,l1,f1,'Wavelength (Angstrom)', 'Normalized Flux','optical',x2=l6,y2=f6,$
                          x3=l9,y3=f9,x4=l10,y4=f10,x5=l11,y5=f11,x6=l12,y6=f12,x7=l13,y7=f13,xrange=[alog10(50),alog10(50000)],yrange=[-14,-6]
                          

  
                          
END
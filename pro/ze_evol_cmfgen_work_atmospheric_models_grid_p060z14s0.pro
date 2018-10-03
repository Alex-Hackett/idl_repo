;PRO ZE_EVOL_CMFGEN_WORK_ATMOSPHERIC_MODELS_GRID_P060z14S0


restore,'/Users/jgroh/temp/ze_evol_cmfgen_work_atmospheric_modeling_variables_to_george.sav'
;dirmod='/Users/jgroh/ze_models/grid_P060z14S0/'
;model='ZAMS_model57_T48386_L507016_logg_4d2015_Fe_OK'
;ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin_10',dirmod+model+'/obscont/obs_cont',l1,f1,LMIN=1200,LMAX=50000
;
;model='model500_T47031_L52831_logg_4d1278_newabund'
;ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin_10',dirmod+model+'/obscont/obs_cont',l2,f2,LMIN=1200,LMAX=50000
;
;model='model1000_T45796_L555083_logg_4d0519_newabund'
;ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin_10',dirmod+model+'/obscont/obs_cont',l3,f3,LMIN=1200,LMAX=50000
;
model='model001750_T043261_L0597948_logg3.907'
ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin_10',dirmod+model+'/obscont/obs_cont',l1750,f1750,LMIN=1200,LMAX=50000


;;model='midH_model2500_T39375_L645563_logg_3d6925_newabund'
;;ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin_10',dirmod+model+'/obscont/obs_cont',l4,f4,LMIN=1200,LMAX=50000
;;
;;model='model3500_T31088_L719179_logg_3d22'
;;ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin_10',dirmod+model+'/obscont/obs_cont',l5,f5,LMIN=1200,LMAX=50000
;;
;model='model3800_T27864_L743098_logg3d01'
;ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin_10',dirmod+model+'/obscont/obs_cont',l6,f6,LMIN=1200,LMAX=50000
;;

model='model004200_T021072_L0766547_logg2.497'
ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin',dirmod+model+'/obscont/obs_cont',l4200,f4200,LMIN=1200,LMAX=50000
;

;model='model4301_T18573_l772592_logg2d267'
;ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin',dirmod+model+'/obscont/obs_cont',l8,f8,LMIN=1200,LMAX=50000
;

model='model4379_T12105_L755429_logg1d491_with_lowion'
ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin',dirmod+model+'/obscont/obs_fin',l4379,f4379,LMIN=1200,LMAX=50000
;
model='model4701_T25875_L814798_logg2d684'
ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin',dirmod+model+'/obscont/obs_cont',l4701,f4701,LMIN=1200,LMAX=50000
;

;;model='model5500_T30783_L941860_logg2d78'
;;ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin_10',dirmod+model+'/obscont/obs_cont',l7,f7,LMIN=1200,LMAX=50000
;

;model='model4717_T20457_L818840_logg2d279'
;ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin',dirmod+model+'/obscont/obs_cont',l9,f9,LMIN=1200,LMAX=50000
;
;model='model5500_T30783_L941860_logg_2d787'
;ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin_10',dirmod+model+'/obscont/obs_cont',l10,f10,LMIN=1200,LMAX=50000
;
;model='model8201_T122874_L682455_logg5d294'
;ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin',dirmod+model+'/obscont/obs_cont',l11,f11,LMIN=1200,LMAX=50000
;
;model='model18950_T140543_L350244_logg_5d580_hydro'
;ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin',dirmod+model+'/obscont/obs_cont',l12,f12,LMIN=1200,LMAX=50000
;
model='model22271_T182276_L390823_logg5d94'
ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin',dirmod+model+'/obscont/obs_cont',l22271,f22271,LMIN=1200,LMAX=50000

;model='model23950_T224855_L483178_logg6d211_2'
;ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin',dirmod+model+'/obscont/obs_cont',l13,f13,LMIN=1200,LMAX=50000


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
;model   4471 4542, 4686 ,4089, 4143  
meas=[[56,500,1000,1750,2500,3500,3800],[0.0352,0.0403,0.0515,0.1061,0.1670,0.4401,0.4912],[0.8429,0.8207,0.7988,0.7336,0.6837,0.3183,0.1812],[0.4944,0.4349,0.3952,0.5201,0.2434,-0.1313,0.1318],$
      [-0.0210,-0.0186,-0.0104, -0.0149,0.0132,0.1810,0.3379],[-0.00156,-0.00172,-0.00190,0.000169,-0.00373,-0.0325,0.00169]]
logWprime=alog10(meas[*,1]/meas[*,2]) ;= log (EW(He I 4471)/EW(He II 4542)) 
log4686=alog10(meas[*,3]) ;=log EW(He II 4686)
logWdoubleprime=alog10(meas[*,4]/meas[*,5]) ;= log (EW(Si IV 4089)/EW(He I 4143)) 
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
print,meas[*,0]
print,SpTYpe
print,LumClass

ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS,l1,f1,'Wavelength (Angstrom)', 'Normalized Flux','optical',x2=l6,y2=f6,$
                          x3=l9,y3=f9,x4=l10,y4=f10,x5=l11,y5=f11,x6=l12,y6=f12,x7=l13,y7=f13,xrange=[5000,9000],yrange=[0,16]
                          
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS,l1,f1,'Wavelength (Angstrom)', 'Normalized Flux','Y band',x2=l6,y2=f6,$
                          x3=l9,y3=f9,x4=l10,y4=f10,x5=l11,y5=f11,x6=l12,y6=f12,x7=l13,y7=f13,xrange=[9000,11000],yrange=[0,16]
                          

ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS,l1,f1,'Wavelength (Angstrom)', 'Normalized Flux','J band',x2=l6,y2=f6,$
                          x3=l9,y3=f9,x4=l10,y4=f10,x5=l11,y5=f11,x6=l12,y6=f12,x7=l13,y7=f13,xrange=[11000,13000],yrange=[0,16]
                          
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS,l1,f1,'Wavelength (Angstrom)', 'Normalized Flux','H band',x2=l6,y2=f6,$
                          x3=l9,y3=f9,x4=l10,y4=f10,x5=l11,y5=f11,x6=l12,y6=f12,x7=l13,y7=f13,xrange=[14500,17200],yrange=[0,16]
                          

ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS,l1,f1,'Wavelength (Angstrom)', 'Normalized Flux','K band',x2=l6,y2=f6,$
                          x3=l9,y3=f9,x4=l10,y4=f10,x5=l11,y5=f11,x6=l12,y6=f12,x7=l13,y7=f13,xrange=[20000,24000],yrange=[0,16]
                          
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS,l1,f1,'Wavelength (Angstrom)', 'Normalized Flux','blue',x2=l6,y2=f6,$
                          x3=l9,y3=f9,x4=l10,y4=f10,x5=l11,y5=f11,x6=l12,y6=f12,x7=l13,y7=f13,xrange=[3600,5000],yrange=[0,16]

ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS,l1,f1,'Wavelength (Angstrom)', 'Normalized Flux','NUV',x2=l6,y2=f6,$
                          x3=l9,y3=f9,x4=l10,y4=f10,x5=l11,y5=f11,x6=l12,y6=f12,x7=l13,y7=f13,xrange=[2000,3600],yrange=[0,16]

ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS,l1,f1,'Wavelength (Angstrom)', 'Normalized Flux','UV',x2=l6,y2=f6,$
                          x3=l9,y3=f9,x4=l10,y4=f10,x5=l11,y5=f11,x6=l12,y6=f12,x7=l13,y7=f13,xrange=[1200,2000],yrange=[0,16]
   
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS,l1,f1,'Wavelength (Angstrom)', 'Normalized Flux','FUV',x2=l6,y2=f6,$
                          x3=l9,y3=f9,x4=l10,y4=f10,x5=l11,y5=f11,x6=l12,y6=f12,x7=l13,y7=f13,xrange=[900,1200],yrange=[0,16]
  
                          
END
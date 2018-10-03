;PRO ZE_EVOL_CMFGEN_WORK_ATMOSPHERIC_MODELS_SN_PROGENITOR_LBVS


;restore,'/Users/jgroh/temp/ze_evol_cmfgen_work_atmospheric_modeling_variables_to_george.sav'

obsdir='/Users/jgroh/espectros/agcar/'
;ZE_READ_SPECTRA_COL_VEC,obsdir+'agc01apr12_35a90.txt',l01apr,f01apr,nrec
ZE_READ_SPECTRA_COL_VEC,obsdir+'agc02jul04_36a92n.txt',l02jul,f02jul,nrec
;ZE_READ_SPECTRA_COL_VEC,obsdir+'agc02mar17.txt',l02mar,f02mar,nrec
ze_evol_rebin_xyz,l02jul,f02jul,l02julr,f02julr,factor=20.0

dirmod='/Users/jgroh/ze_models/SN_progenitor_grid/'

model='P120z14S4_model064569_T252831_L0856258_logg6.349'
ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin',dirmod+model+'/obscont/obs_cont',l1,f1,LMIN=1200,LMAX=50000

model='P120z14S0_model025926_T167648_L1784201_logg5.527'
ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin',dirmod+model+'/obscont/obs_cont',l2,f2,LMIN=1200,LMAX=50000

model='P085z14S4_model045758_T266698_L1310829_logg6.399'
ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin',dirmod+model+'/obscont/obs_cont',l3,f3,LMIN=1200,LMAX=50000

model='P085z14S0_model024500_T236325_L0899663_logg6.201'
ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin',dirmod+model+'/obscont/obs_cont',l4,f4,LMIN=1200,LMAX=50000
;
;model='model23950_T224855_L483178_logg6d211_2'
model='P060z14S4_model054963_T247137_L0784953_logg6.322'
ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin',dirmod+model+'/obscont/obs_cont',l5,f5,LMIN=1200,LMAX=50000
;;
model='P060z14S0_model23950_T224855_L483178_logg6d211_vinf5000'
ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin',dirmod+model+'/obscont/obs_cont',l6,f6,LMIN=1200,LMAX=50000
;;
model='P040z14S4_model085774_T211679_L0438412_logg6.142'
ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin',dirmod+model+'/obscont/obs_cont',l7,f7,LMIN=1200,LMAX=50000
;
model='P040z14S0new_model106339_T048183_L0482467_logg3.576'
ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin',dirmod+model+'/obscont/obs_cont',l8,f8,LMIN=1200,LMAX=50000
;
model='P032z14S4_model075198_T181508_L0337150_logg5.904'
ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin',dirmod+model+'/obscont/obs_cont',l9,f9,LMIN=1200,LMAX=50000
;
model='P032z14S0_model029922_T045794_L0367647_logg3.507'
ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin_10',dirmod+model+'/obscont/obs_cont',l10,f10,LMIN=1200,LMAX=50000
;
model='P025z14S4_model042063_T024625_L0318560_logg2.439'
ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin',dirmod+model+'/obscont/obs_cont',l11,f11,LMIN=1200,LMAX=50000
;
model='P025z14S0_model030888_T027115_L0239316_logg2.663'
ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin',dirmod+model+'/obscont/obs_cont',l12,f12,LMIN=1200,LMAX=50000
;
model='P020z14S4_model049869_T020358_L0191044_logg2.200'
ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin',dirmod+model+'/obscont/obs_cont',l13,f13,LMIN=1200,LMAX=50000
;

model='P020z14S4_model029446_T019339_L0162573_logg2.193'
ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin',dirmod+model+'/obscont/obs_cont',l16,f16,LMIN=1200,LMAX=50000
;

model='P020z14S4_model022532_T018201_L0129137_logg2.236'
ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin',dirmod+model+'/obscont/obs_cont',l17,f17,LMIN=1200,LMAX=50000
;


model='model23950_T224855_L483178_logg6d211_2'
ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin',dirmod+model+'/obscont/obs_cont',l14,f14,LMIN=1200,LMAX=50000
;
model='P120z14S0_model025926_T167648_L1784201_logg5.527_with_highion_2'
ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs/obs_fin',dirmod+model+'/obscont/obs_cont',l15,f15,LMIN=1200,LMAX=50000


!P.Background = fsc_color('white')
;timesteps=[56,500,1000,2500,3500,3800,5500]
;;lineplot,l1,f1,title=string(timesteps[0],FORMAT='(I4)')
;;lineplot,l2,f2,title=string(timesteps[1],FORMAT='(I4)')
;;lineplot,l3,f3,title=string(timesteps[2],FORMAT='(I4)')
;;lineplot,l4,f4,title=string(timesteps[3],FORMAT='(I4)')
;;lineplot,l5,f5,title=string(timesteps[4],FORMAT='(I4)')
;;lineplot,l6,f6,title=string(timesteps[5],FORMAT='(I4)')
;;lineplot,l7,f7,title=string(timesteps[6],FORMAT='(I4)')
;
;
;;EW measurements
;;model   4471 4512, 4686   
;meas=[[56,500,1000,2500,3500,3800],[0.0352,0.0403,0.0515,0.1670,0.4401,0.4912],[0.8429,0.8207,0.7988,0.6837,0.3183,0.1812],[0.4944,0.4349,0.3952,0.2434,-0.1313,0.1318],$
;      [-0.0210,-0.0186,-0.0104,0.0132,0.1810,0.3379],[-0.00156,-0.00172,-0.00190,-0.00373,-0.0325,0.00169]]
;logWprime=alog10(meas[*,1]/meas[*,2]) ;= log (EW(He I 4471)/EW(He II 4512)) 
;log4686=alog10(meas[*,3]) ;=log EW(He II 4686)
;logWdoubleprime=alog10(meas[*,4]/meas[*,5]) ;= log (EW(Si IV 4089)/EW(He II 4143)) 
;;spectral type classification following mathis 1988
;nmodels=n_elements(logWprime)
;SpTYPE=strarr(nmodels)
;for i=0, nmodels -1 DO BEGIN 
;    IF (logWprime[i] LT 1.00 AND logWprime[i] GT 0.65) THEN SpType[i]='O9.7'
;    IF (logWprime[i] LT 0.65 AND logWprime[i] GT 0.45) THEN SpType[i]='O9.5'
;    IF (logWprime[i] LT 0.45 AND logWprime[i] GT 0.30) THEN SpType[i]='O9'    
;    IF (logWprime[i] LT 0.30 AND logWprime[i] GT 0.20) THEN SpType[i]='O8.5'
;    IF (logWprime[i] LT 0.20 AND logWprime[i] GT 0.10) THEN SpType[i]='O8'
;    IF (logWprime[i] LT 0.10 AND logWprime[i] GT 0.00) THEN SpType[i]='O7.5'
;    IF (logWprime[i] LT 0.00 AND logWprime[i] GT -0.10) THEN SpType[i]='O7'
;    IF (logWprime[i] LT -0.10 AND logWprime[i] GT -0.20) THEN SpType[i]='O6.5'        
;    IF (logWprime[i] LT -0.20 AND logWprime[i] GT -0.30) THEN SpType[i]='O6' 
;    IF (logWprime[i] LT -0.30 AND logWprime[i] GT -0.45) THEN SpType[i]='O5.5' 
;    IF (logWprime[i] LT -0.45 AND logWprime[i] GT -0.60) THEN SpType[i]='O5' 
;    IF (logWprime[i] LT -0.60 AND logWprime[i] GT -0.90) THEN SpType[i]='O4' 
;    IF (logWprime[i] LT -0.90) THEN SpType[i]='O3'    
;ENDFOR
;
;;luminosity classification following mathis 1988, markova+11
;LumClass=strarr(nmodels)
;for i=0, nmodels -1 DO BEGIN 
;    IF (logWprime[i] LT -0.10) THEN BEGIN ;these are SpType < O7
;      IF (log4686[i] GT -0.25) THEN LumClass[i]='V' ELSE LumClass[i]='III'
;    ENDIF ELSE BEGIN ;these are SPType > 07, using the classification of Conti & Alschuler 1971
;      IF (logWdoubleprime[i] LT 0.10 AND logWdoubleprime[i] GT -0.20) THEN LumClass[i]='V'
;      IF (logWdoubleprime[i] LT 0.30 AND logWdoubleprime[i] GT 0.10) THEN LumClass[i]='III'
;      IF (logWdoubleprime[i] GT 0.30) THEN LumClass[i]='I'    
;;      IF (logWdoubleprime[i] GT 5.35) THEN LumClass[i]='V'
;;      IF (logWdoubleprime[i] LT 5.35 AND logWdoubleprime[i] GT 5.05) THEN LumClass[i]='III'
;;      IF (logWdoubleprime[i] LT 5.05) THEN LumClass[i]='I'
;    ENDELSE
;ENDFOR
;
;print,SpTYpe
;print,LumClass
;
;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS,l1,f1,'Wavelength (Angstrom)', 'Normalized Flux','optical',x2=l6,y2=f6,$
;                          x3=l9,y3=f9,x4=l10,y4=f10,x5=l11,y5=f11,x6=l12,y6=f12,x7=l13,y7=f13,xrange=[5000,9000],yrange=[0,16]
;                          
;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS,l1,f1,'Wavelength (Angstrom)', 'Normalized Flux','Y band',x2=l6,y2=f6,$
;                          x3=l9,y3=f9,x4=l10,y4=f10,x5=l11,y5=f11,x6=l12,y6=f12,x7=l13,y7=f13,xrange=[9000,11000],yrange=[0,16]
;                          
;
;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS,l1,f1,'Wavelength (Angstrom)', 'Normalized Flux','J band',x2=l6,y2=f6,$
;                          x3=l9,y3=f9,x4=l10,y4=f10,x5=l11,y5=f11,x6=l12,y6=f12,x7=l13,y7=f13,xrange=[11000,13000],yrange=[0,16]
;                          
;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS,l1,f1,'Wavelength (Angstrom)', 'Normalized Flux','H band',x2=l6,y2=f6,$
;                          x3=l9,y3=f9,x4=l10,y4=f10,x5=l11,y5=f11,x6=l12,y6=f12,x7=l13,y7=f13,xrange=[14500,17200],yrange=[0,16]
;                          
;
;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS,l1,f1,'Wavelength (Angstrom)', 'Normalized Flux','K band',x2=l6,y2=f6,$
;                          x3=l9,y3=f9,x4=l10,y4=f10,x5=l11,y5=f11,x6=l12,y6=f12,x7=l13,y7=f13,xrange=[20000,24000],yrange=[0,16]
;                          
;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS,l2,f2,'Wavelength (Angstrom)', 'Normalized Flux','blue',x2=l4,y2=f4,$
;                          x3=l6,y3=f6,x4=l8,y4=f8,x5=l10,y5=f10,x6=l12,y6=f12,xrange=[3600,5000],yrange=[0,16]
;                          
;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS,l1,f1,'Wavelength (Angstrom)', 'Normalized Flux','blue',x2=l3,y2=f3,$
;                          x3=l5,y3=f5,x4=l7,y4=f7,x5=l9,y5=f9,x6=l11,y6=f11,xrange=[3600,5000],yrange=[0,10]  
                          
;20 and 25 msun, both rotating and non-rotating models
;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS,l13,f13+3,'Wavelength (Angstrom)', 'Normalized Flux','blue',x2=l12,y2=f12+6,x4=l02julr,y4=f02julr-4,x3=l11,y3=f11+9, xrange=[3900,4900],yrange=[0,18]   



;defines ewdata for reading, as generated by CMF_FLUX (including header)
ewdata='/Users/jgroh/ze_models/SN_progenitor_grid/P020z14S4_model049869_T020358_L0191044_logg2.200/obscont/ewdata_fin_ed'  
openu,1,ewdata     ; open file without writing

linha=''

;finds the i number of points in ewdata
i=0.
while not eof(1) do begin
readf,1,linha
if linha eq '' then begin
goto,skip1
endif
i=i+1.
skip1:
endwhile
close,1


;declare arrays
lambdac=dblarr(i) & cont=lambdac & ew=lambdac & sob=strarr(i) & sobc=strarr(i)
lambdac1=0. & cont1=0. & ew1=0. & sob1='A2' 

;read lambda central, continuum intensity, EW and transition ID
ewdata_header=''
openu,1,ewdata
readf,1,ewdata_header
for k=0., i-2. do begin
readf,1,lambdac1,cont1,ew1,sob1
sob1=strsub(sob1,4,50)
lambdac[k]=lambdac1 & cont[k]=cont1 & ew[k]=ew1 & sob[k]=sob1
endfor
close,1



;20 and 25 msun, only rotating models, figure version A&A letter Groh, Meynet, Ekstrom 2013
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_FOR_LBV_SN_PROGENITOR_PAPER,l13,f13+6,'Wavelength (Angstrom)', 'Normalized Flux','',x4=l02julr,y4=f02julr-4,x3=l11,y3=f11+8, xrange=[3900,6500],yrange=[0,18],id_lambda=lambdac,id_text=sob,id_ew=ew

;20 and 25 msun, only rotating models, different kinds of comparison spectra: WNL star
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_FOR_LBV_SN_PROGENITOR_PAPER,l13,f13+6,'Wavelength (Angstrom)', 'Normalized Flux','',x4=l8,y4=f8-4,x3=l11,y3=f11+8, xrange=[3900,6500],yrange=[0,18],id_lambda=lambdac,id_text=sob,id_ew=ew


;20 and 25 msun, only rotating models
;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS,l13,f13+6,'Wavelength (Angstrom)', 'Normalized Flux','',x4=l02julr,y4=f02julr-4,x3=l16,y3=f16+8, x2=l17,y2=f17, xrange=[3900,6500],yrange=[0,18]  

;;20 and 25 msun, both without rotation and rotating models
;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS,l13,f13+6,'Wavelength (Angstrom)', 'Normalized Flux','',x2=l12,y2=f12+13,x4=l02julr,y4=f02julr-4,x3=l11,y3=f11+8, xrange=[3900,5200],yrange=[0,20]                                                     
;
;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS,l1,f1,'Wavelength (Angstrom)', 'Normalized Flux','NUV',x2=l6,y2=f6,$
;                          x3=l9,y3=f9,x4=l10,y4=f10,x5=l11,y5=f11,x6=l12,y6=f12,x7=l13,y7=f13,xrange=[2000,3600],yrange=[0,16]
;
;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS,l1,f1,'Wavelength (Angstrom)', 'Normalized Flux','UV',x2=l6,y2=f6,$
;                          x3=l9,y3=f9,x4=l10,y4=f10,x5=l11,y5=f11,x6=l12,y6=f12,x7=l13,y7=f13,xrange=[1200,2000],yrange=[0,16]
;   
;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS,l1,f1,'Wavelength (Angstrom)', 'Normalized Flux','FUV',x2=l6,y2=f6,$
;                          x3=l9,y3=f9,x4=l10,y4=f10,x5=l11,y5=f11,x6=l12,y6=f12,x7=l13,y7=f13,xrange=[900,1200],yrange=[0,16]
;  
                          
END
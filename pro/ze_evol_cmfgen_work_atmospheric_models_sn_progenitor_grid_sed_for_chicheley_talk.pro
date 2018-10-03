;PRO ZE_EVOL_CMFGEN_WORK_ATMOSPHERIC_MODELS_SN_PROGENITOR_GRID_SED_FOR_CHICHELEY_TALK
;plots smoothed SED
;reads cmfgen models
;reads also marcs models to plot a typical RSG spectra and YHG spectra
;reads chorizos bandpasses

levol1=121441.
model='s3600_g+0.0_m5.0_t02_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00'
ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,dirmod,model,'V',mass,lum1,teff,absolute_mag,Mbol,BC,l1,f1,/MARCSWEB
scl=levol1/lum1
print,'scl1 ',scl
f1scl=f1 * 5.8  ;scale flux to correspond to that of evol model

levol2=153082.
model='s5250_g+0.5_m1.0_t05_hc_z+0.00_a+0.00_c-0.38_n+0.53_o+0.00_r+0.00_s+0.00'
ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,dirmod,model,'V',mass,lum2, teff,absolute_mag,Mbol,BC,l2,f2,/MARCSWEB
scl2=levol2/lum2
print,'scl2 ',scl2
f2scl=f2*25.549415d0

dirmod='/Users/jgroh/ze_models/SN_progenitor_grid/'

model='P020z14S4_model049869_T020358_L0191044_logg2.200'
ZE_CMFGEN_READ_OBS,dirmod+model+'/obs/obs_fin',l3,f3,/FLAM

model='P040z14S0new_model106339_T048183_L0482467_logg3.576'
ZE_CMFGEN_READ_OBS,dirmod+model+'/obs/obs_fin',l4,f4,/FLAM

model='P028z14S4_model060885_T028898_L0349513_logg2.725'
ZE_CMFGEN_READ_OBS,dirmod+model+'/obs/obs_fin_10',l4,f4,/FLAM

model='P032z14S4_model075198_T181508_L0337150_logg5.904'
ZE_CMFGEN_READ_OBS,dirmod+model+'/obs/obs_fin',l5,f5,/FLAM


bands=['U','B','V','R','I','J','H','Ks']
;bands=['U','B','V','R','I','WFPC2_F300W','WFPC2_F450W','WFPC2_F606W','WFPC2_F814W','WFPC2_F170W','WFPC2_F555W','J','H','Ks']

;ZE_READ_CHORIZOS_BANDPASS_ZP,'WFPC2_F450W',lambda,pass,passband,zp


;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,l1,f1scl,'Log Wavelength (Angstrom)','Log Flux (erg/s/cm^2/Angstrom)','',x2=l2,y2=f2scl,POSITION=[0.08,0.15,0.97,0.98],$
;                          x3=l4,y3=f4,x4=l3,y4=f3,x5=l5,y5=f5,xrange=[90,50000],yrange=[1e-14,1e-5],/xlog,/ylog,$
;                          /rebin,factor1=40,factor4=40.0,filename='sn_prog_sed',$
;                          color1='red',color2='yellow',color3='blue',color4='green',color5='cyan',bands=bands
                               

;for teachers talk
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,l1,f1scl,'','','',POSITION=[0.08,0.15,0.97,0.98],aa=800,bb=300,$
                          x5=l5,y5=f5,$
                        ;  x3=l3,y3=f3,$
                          xrange=[4000,7000],yrange=[1e-12,1e-8],/ylog,$
                          /rebin,factor1=3,factor4=3.0,filename='sn_prog_sed_talk',$
                          color1='black',color2='yellow',color3='blue',color4='green',color5='red';,bands=bands
                          
END                             
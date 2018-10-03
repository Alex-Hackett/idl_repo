;PRO ZE_CMFGEN_EVOL_60MSUN_NOROT_SPECTRUM_COMP_O_STAR_CLUMPING

;;reads default models where O stars have f=0.2, v_c=30 km/s
;modelstr='P060z14S0'
;ZE_CMFGEN_SPEC_FIND_AVAILABLE_TIMESTEPS,modelstr,timesteps_available,allobsfinfiles,allobscontfiles ;finds which timesteps have spectra computede in  dir 
;LMIN=900.0
;LMAX=50000.0
;nlambda=400000d0
;all_lambda=dblarr(n_elements(timesteps_available),nlambda)
;all_fluxnorm=dblarr(n_elements(timesteps_available),nlambda)
;all_nlambda_read=dblarr(n_elements(timesteps_available))
;for i=0, n_elements(timesteps_available) -1 do begin
; ZE_CMFGEN_CREATE_OBSNORM,allobsfinfiles[i],allobscontfiles[i],lnorm,fnorm,LMIN=lmin,LMAX=lmax,cnvl=50.0
; all_nlambda_read[i]=n_elements(lnorm)
; print,i,' ',all_nlambda_read[i]
; all_lambda[i,0:all_nlambda_read[i]-1]=lnorm
; all_fluxnorm[i,0:all_nlambda_read[i]-1]=fnorm 
;endfor
;save,filename='/Users/jgroh/temp/P060z14S0_cmfgen_evol_spectra_norm_cnvl50_f0d2.sav',/all
;;save,filename='/Users/jgroh/temp/P060z14S0_cmfgen_evol_spectra_norm.sav',/all
;STOP

;;reads default models where O stars have f=0.1, v_c=200 km/s
;;modelstrf0d1='';dummy if dirmod is present
;dirmodf0d1='/Users/jgroh/ze_models/grid_P060z14S0/auxiliary/clump0d1/' 
;LMIN=900.0
;LMAX=50000.0
;nlambda=400000d0
;allobsfinfilesf0d1=['model57_T48386_L507016_logg_4d2015_Fe_OK_f0d1/obs/obs_fin_10','model500_T47031_L528310_logg_4d1278_Fe_OK_f0d1/obs/obs_fin_10',$
;'model1000_T45796_L555083_logg_4d0519_Fe_OK_f0d1/obs/obs_fin_10','model001750_T043261_L0597948_logg3.907_f0d1/obs/obs_fin_10',$
;'model2500_T39375_L645563_logg_3d6925_Fe_OK_f0d1/obs/obs_fin_10','model003000_T035749_L0680682_logg3.495_f0d1/obs/obs_fin_10',$
;'model3500_T31088_L719179_logg_3d22_Fe_OK_f0d1/obs/obs_fin_10','model3800_T27864_L743098_logg3d01_Fe_OK_2_f0d1/obs/obs_fin_10',$
;'model003970_T025884_L0757148_logg2.875_f0d1/obs/obs_fin_10']
;allobscontfilesf0d1=['model57_T48386_L507016_logg_4d2015_Fe_OK_f0d1/obscont/obs_cont','model500_T47031_L528310_logg_4d1278_Fe_OK_f0d1/obscont/obs_cont',$
;'model1000_T45796_L555083_logg_4d0519_Fe_OK_f0d1/obscont/obs_cont','model001750_T043261_L0597948_logg3.907_f0d1/obscont/obs_cont',$
;'model2500_T39375_L645563_logg_3d6925_Fe_OK_f0d1/obscont/obs_cont','model003000_T035749_L0680682_logg3.495_f0d1/obscont/obs_cont',$
;'model3500_T31088_L719179_logg_3d22_Fe_OK_f0d1/obscont/obs_cont','model3800_T27864_L743098_logg3d01_Fe_OK_2_f0d1/obscont/obs_cont',$
;'model003970_T025884_L0757148_logg2.875_f0d1/obscont/obs_cont']
;all_lambdaf0d1=dblarr(n_elements(allobsfinfilesf0d1),nlambda)
;all_fluxnormf0d1=dblarr(n_elements(allobsfinfilesf0d1),nlambda)
;all_nlambda_readf0d1=dblarr(n_elements(allobsfinfilesf0d1))
;for i=0, n_elements(allobsfinfilesf0d1) -1 do begin
; ZE_CMFGEN_CREATE_OBSNORM,dirmodf0d1+allobsfinfilesf0d1[i],dirmodf0d1+allobscontfilesf0d1[i],lnorm,fnorm,LMIN=lmin,LMAX=lmax,cnvl=50.0
; all_nlambda_readf0d1[i]=n_elements(lnorm)
; print,i,' ',all_nlambda_readf0d1[i]
; all_lambdaf0d1[i,0:all_nlambda_readf0d1[i]-1]=lnorm
; all_fluxnormf0d1[i,0:all_nlambda_readf0d1[i]-1]=fnorm 
;endfor
;save,filename='/Users/jgroh/temp/P060z14S0_cmfgen_evol_spectra_norm_cnvl50_f0d1.sav',/all
;STOP

;;reads default models where O stars have f=1.0
;;modelstrf0d1='';dummy if dirmod is present
;dirmodf1d0='/Users/jgroh/ze_models/grid_P060z14S0/auxiliary/clump1d0/' 
;LMIN=900.0
;LMAX=50000.0
;nlambda=400000d0
;allobsfinfilesf1d0=['model57_T48386_L507016_logg_4d2015_Fe_OK_f1d0/obs/obs_fin_10','model500_T47031_L52831_logg_4d1278_Fe_OK_f1d0/obs/obs_fin_10',$
;'model1000_T45796_L555083_logg_4d0519_Fe_OK_f1d0/obs/obs_fin_10','model001750_T043261_L0597948_logg3.907_f1d0/obs/obs_fin_10',$
;'model2500_T39375_L645563_logg_3d6925_Fe_OK_f1d0/obs/obs_fin_10','model003000_T035749_L0680682_logg3.495_f1d0/obs/obs_fin_10',$
;'model3500_T31088_L719179_logg_3d22_Fe_OK_f1d0/obs/obs_fin_10','model3800_T27864_L743098_logg3d01_Fe_OK_2_f1d0/obs/obs_fin_10',$
;'model003970_T025884_L0757148_logg2.875_f1d0/obs/obs_fin_10']
;allobscontfilesf1d0=['model57_T48386_L507016_logg_4d2015_Fe_OK_f1d0/obscont/obs_cont','model500_T47031_L52831_logg_4d1278_Fe_OK_f1d0/obscont/obs_cont',$
;'model1000_T45796_L555083_logg_4d0519_Fe_OK_f1d0/obscont/obs_cont','model001750_T043261_L0597948_logg3.907_f1d0/obscont/obs_cont',$
;'model2500_T39375_L645563_logg_3d6925_Fe_OK_f1d0/obscont/obs_cont','model003000_T035749_L0680682_logg3.495_f1d0/obscont/obs_cont',$
;'model3500_T31088_L719179_logg_3d22_Fe_OK_f1d0/obscont/obs_cont','model3800_T27864_L743098_logg3d01_Fe_OK_2_f1d0/obscont/obs_cont',$
;'model003970_T025884_L0757148_logg2.875_f1d0/obscont/obs_cont']
;all_lambdaf1d0=dblarr(n_elements(allobsfinfilesf1d0),nlambda)
;all_fluxnormf1d0=dblarr(n_elements(allobsfinfilesf1d0),nlambda)
;all_nlambda_readf1d0=dblarr(n_elements(allobsfinfilesf1d0))
;for i=0, n_elements(allobsfinfilesf1d0) -1 do begin
; ZE_CMFGEN_CREATE_OBSNORM,dirmodf1d0+allobsfinfilesf1d0[i],dirmodf1d0+allobscontfilesf1d0[i],lnorm,fnorm,LMIN=lmin,LMAX=lmax,cnvl=50.0
; all_nlambda_readf1d0[i]=n_elements(lnorm)
; print,i,' ',all_nlambda_readf1d0[i]
; all_lambdaf1d0[i,0:all_nlambda_readf1d0[i]-1]=lnorm
; all_fluxnormf1d0[i,0:all_nlambda_readf1d0[i]-1]=fnorm 
;endfor
;save,filename='/Users/jgroh/temp/P060z14S0_cmfgen_evol_spectra_norm_cnvl50_f1d0.sav',/all
;;STOP

;restore,'/Users/jgroh/temp/P060z14S0_cmfgen_evol_spectra_norm_cnvl50_f0d2.sav'
;restore,'/Users/jgroh/temp/P060z14S0_cmfgen_evol_spectra_norm_cnvl50_f0d1.sav'
;restore,'/Users/jgroh/temp/P060z14S0_cmfgen_evol_spectra_norm_cnvl50_f1d0.sav'

;H alpha line, do it for all models
yrangevecmin=[0.6,0.6,0.6,0.6,0.6,0.6,0.6,0.6,0.6,0.6]
yrangevecmax=[1.33,1.33,1.33,1.33,1.33,1.33,1.33,1.33,1.33,1.33]
for i =0, n_elements(allobsfinfilesf1d0) -1 do begin
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,all_lambdaf1d0[i,0:all_nlambda_readf1d0[i]-1],all_fluxnormf1d0[i,0:all_nlambda_readf1d0[i]-1],'Wavelength (Angstrom)', 'Normalized Flux','',$
                          x2=all_lambda[i,0:all_nlambda_read[i]-1],y2=all_fluxnorm[i,0:all_nlambda_read[i]-1],linestyle2=0,xtitle='',ytitle='',$
                          x3=all_lambdaf0d1[i,0:all_nlambda_readf0d1[i]-1],y3=all_fluxnormf0d1[i,0:all_nlambda_readf0d1[i]-1],linestyle3=2,$                       
                          xtickinterval=20,pcharsize=3.0,thick=2,xrange=[6510,6605],yrange=[yrangevecmin[i],yrangevecmax[i]],position=[0.13,0.13,0.99,0.99],filename='P060z14S0_ms_clump_halpha'+strcompress(string(i),/REMOVE_ALL),/rebin,factor1=2.0,aa=1060,bb=700;,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.4,id_ypos=22.0
endfor

;He II 4686 line, do it for all models
yrangevecmin=[0.74,0.7,0.7,0.7,0.7,0.7,0.74,0.7,0.7,0.7]
yrangevecmax=[1.17,1.33,1.33,1.33,1.33,1.33,1.17,1.33,1.33,1.33]
for i =0, n_elements(allobsfinfilesf1d0) -1 do begin
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,all_lambdaf1d0[i,0:all_nlambda_readf1d0[i]-1],all_fluxnormf1d0[i,0:all_nlambda_readf1d0[i]-1],'Wavelength (Angstrom)', 'Normalized Flux','',$
                          x2=all_lambda[i,0:all_nlambda_read[i]-1],y2=all_fluxnorm[i,0:all_nlambda_read[i]-1],linestyle2=0,xtitle='',ytitle='',$
                          x3=all_lambdaf0d1[i,0:all_nlambda_readf0d1[i]-1],y3=all_fluxnormf0d1[i,0:all_nlambda_readf0d1[i]-1],linestyle3=2,$                       
                          xtickinterval=20,pcharsize=3.0,thick=1.5,xrange=[4650,4719],yrange=[yrangevecmin[i],yrangevecmax[i]],position=[0.13,0.13,0.99,0.99],filename='P060z14S0_ms_clump_heii4686'+strcompress(string(i),/REMOVE_ALL),/rebin,factor1=2.0,aa=1060,bb=700;,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.4,id_ypos=22.0
endfor

;He II 4540 line, do it for all models
yrangevecmin=[0.74,0.7,0.7,0.7,0.7,0.7,0.74,0.7,0.7,0.7]
yrangevecmax=[1.05,1.05,1.05,1.05,1.05,1.05,1.05,1.05,1.05,1.05]
for i =0, n_elements(allobsfinfilesf1d0) -1 do begin
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,all_lambdaf1d0[i,0:all_nlambda_readf1d0[i]-1],all_fluxnormf1d0[i,0:all_nlambda_readf1d0[i]-1],'Wavelength (Angstrom)', 'Normalized Flux','',$
                          x2=all_lambda[i,0:all_nlambda_read[i]-1],y2=all_fluxnorm[i,0:all_nlambda_read[i]-1],linestyle2=0,xtitle='',ytitle='',$
                          x3=all_lambdaf0d1[i,0:all_nlambda_readf0d1[i]-1],y3=all_fluxnormf0d1[i,0:all_nlambda_readf0d1[i]-1],linestyle3=2,$                       
                          ytickinterval=0.1,xtickinterval=5,pcharsize=3.0,thick=1.5,xrange=[4530,4554],yrange=[yrangevecmin[i],yrangevecmax[i]],position=[0.13,0.13,0.99,0.99],filename='P060z14S0_ms_clump_heii4540'+strcompress(string(i),/REMOVE_ALL),/rebin,factor1=2.0,aa=1060,bb=700;,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.4,id_ypos=22.0
endfor

;He I 4471 line, do it for all models
yrangevecmin=[0.50,0.5,0.5,0.5,0.5,0.5,0.50,0.5,0.5,0.5]
yrangevecmax=[1.05,1.05,1.05,1.05,1.05,1.05,1.05,1.05,1.05,1.05]
for i =0, n_elements(allobsfinfilesf1d0) -1 do begin
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,all_lambdaf1d0[i,0:all_nlambda_readf1d0[i]-1],all_fluxnormf1d0[i,0:all_nlambda_readf1d0[i]-1],'Wavelength (Angstrom)', 'Normalized Flux','',$
                          x2=all_lambda[i,0:all_nlambda_read[i]-1],y2=all_fluxnorm[i,0:all_nlambda_read[i]-1],linestyle2=0,xtitle='',ytitle='',$
                          x3=all_lambdaf0d1[i,0:all_nlambda_readf0d1[i]-1],y3=all_fluxnormf0d1[i,0:all_nlambda_readf0d1[i]-1],linestyle3=2,$                       
                          xtickinterval=5,pcharsize=3.0,thick=1.5,xrange=[4462,4483],yrange=[yrangevecmin[i],yrangevecmax[i]],position=[0.13,0.13,0.99,0.99],filename='P060z14S0_ms_clump_hei4471'+strcompress(string(i),/REMOVE_ALL),/rebin,factor1=2.0,aa=1060,bb=700;,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.4,id_ypos=22.0
endfor


END
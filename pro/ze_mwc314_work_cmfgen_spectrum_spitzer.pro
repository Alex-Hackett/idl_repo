;PRO ZE_MWC314_WORK_CMFGEN_SPECTRUM_SPITZER
;reads observed spitzer data from Ardila+ 2010, in .tbl format
;readcol,'/Users/jgroh/espectros/mwc314/MWC314_spitzer_ardila.tbl',dummy,lmwc314spitzer,fmwc314spitzer,fmwc314spitzererr,FORMAT='A,F,F,F'
;line_norm,lmwc314spitzer,fmwc314spitzer,fmwc314spitzern,norm_fmwc314spitzer,xnodes_fmwc314spitzer,ynodes_fmwc314spitzer
;save,filename='/Users/jgroh/espectros/mwc314/mwc314_spitzer_norm.sav',lmwc314spitzer,fmwc314spitzer,fmwc314spitzern,norm_fmwc314spitzer,xnodes_fmwc314spitzer,ynodes_fmwc314spitzer
restore,'/Users/jgroh/espectros/mwc314/mwc314_spitzer_norm.sav'
dirmod='/Users/jgroh/ze_models/agcar/'

model='421'
ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs2d/obs_fin',dirmod+model+'/obscont/obs_fin',lmod,fmod,LMIN=1200,LMAX=400000
fmodc=ze_spec_cnvl_vel(lmod,fmod,1000.0)

model='390'
ZE_CMFGEN_CREATE_OBSNORM,dirmod+model+'/obs2d/obs_fin',dirmod+model+'/obscont/obs_fin',lmod2,fmod2,LMIN=1200,LMAX=400000
fmod2c=ze_spec_cnvl_vel(lmod2,fmod2,1000.0)

ewdata='/Users/jgroh/ze_models/agcar/421/obscont/EWDATA'
ZE_CMFGEN_READ_EWDATA,ewdata,lambdac,cont,ew,sob,id
lambdac_micron=lambdac/1D4
;dirmod='/Users/jgroh/ze_models/agcar/'/.aux_mnt/auxa/jgroh/cmfgen_models/SN_progenitor_grid/P020z14S4_model049869_T020358_L0191044_logg2.200/

;lineplot,lmwc314spitzer,fmwc314spitzern
;lineplot,lmod/1e4,fmodc
;lineplot,lmod2/1e4,fmod2c

;read he2 linelist mir
readcol,'/Users/jgroh/temp/he2lines_mir.txt',he2lammir,he2idmir,F='F,A'
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_MWC314,lmwc314spitzer,fmwc314spitzern,'Wavelength (micron)', 'Normalized Flux','',x2=lmod/1e4,y2=(fmodc-1)/2.+2,$
                         xrange=[5,33],yrange=[0.5,4],/rebin,factor1=1,factor2=3.0,id_lambda=lambdac_micron,id_text=id,id_ew=ew,ewmin=10.0,id_ypos=3.5,$;,pointsx2=he2lammir,
                         color2='black

;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_MWC314,lmwc314spitzer,fmwc314spitzern,'Wavelength (micron)', 'Normalized Flux','',x2=lmod2/1e4,y2=(fmod2c-1)/2.+2,$
;                         xrange=[5,33],yrange=[0.5,4],/rebin,factor1=1,factor2=3.0,id_lambda=lambdac_micron,id_text=id,id_ew=ew,ewmin=10.0,id_ypos=1.8


ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_MWC314,lmwc314spitzer,fmwc314spitzern,'Wavelength (micron)', 'Normalized Flux','',x2=lmod/1e4,y2=(fmod-1)/2.+2,$
                         xrange=[5,33],yrange=[0.5,8],/rebin,factor1=1,factor2=3.0,id_lambda=lambdac_micron,id_text=id,id_ew=ew,ewmin=10.0,id_ypos=7.5,$;,pointsx2=he2lammir,
                         color2='black


END
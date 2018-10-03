;PRO ZE_WORK_WRAY1796_CMFGEN_MODEL
;compares observations of HD 316285 with CMFGEN models

!P.Background = fsc_color('white')

restore,'/Users/jgroh/espectros/wra1796/wra1796_2010jul27_85.sav'
l85_2010=lambda_fin
f85_2010narray=spectrum_array_norm

restore,'/Users/jgroh/espectros/wra1796/wra1796_2011may23_85.sav'
l85_2011=lambda_fin
f85_2011narray=spectrum_array_norm

dir_obs='/Users/jgroh/data/eso/amber/lbvs_p85/lbvs_amber_ascii/'
file_obs='SCIENCE_wray1796_AMBER.2010-08-25T01:26:29.573-AMBER.2010-08-25T01:32:40.582_K_AVG__DIV__CALIB_hd163197_AMBER.2010-08-25T01:54:21.699-AMBER.2010-08-25T02:00:05.132_K_AVG.fits.ascii'
ZE_AMBER_READ_3T_ASCII_FROM_ALEX_KREPLIN,dir_obs+file_obs,obsdata,header
lobs=REFORM(obsdata[0,*]*10000.)
fobs=REFORM(obsdata[19,*])

;dir316mod='/Users/jgroh/ze_models/HD316285/'
;ZE_CMFGEN_CREATE_OBSNORM,dir316mod+'M1'+'/obs/obs_fin',dir316mod+'M1'+'/obs/obs_cont',l1,f1,/AIR ;model M1
;f1(where(f1 lt 0 or f1 gt 90))=0.
;
;ZE_CMFGEN_CREATE_OBSNORM,dir316mod+'M4'+'/obs/obs_fin',dir316mod+'M4'+'/obs/obs_cont',l4,f4,/AIR ;model M4
;f4(where(f4 lt 0 or f4 gt 90))=0.
;
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/etacar/mod25_groh/obs/obs_fin','/Users/jgroh/ze_models/etacar/mod25_groh/obscont/obs_fin',l25e,f25e,/AIR ;model M1
;f25e(where(f25e lt 0 or f25e gt 90))=0.
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/etacar/mod23_groh/obs/obs_fin','/Users/jgroh/ze_models/etacar/mod25_groh/obscont/obs_fin',l23e,f23e,/AIR ;model M1
;f23e(where(f23e lt 0 or f23e gt 90))=0.
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/etacar/mod26_groh/obs/obs_fin','/Users/jgroh/ze_models/etacar/mod26_groh/obscont/obs_fin',l26e,f26e,/AIR ;model M1
;f26e(where(f26e lt 0 or f26e gt 90))=0.

lineplot,l85_2010,f85_2010narray[*,0]
lineplot,l85_2011,f85_2011narray[*,0]
;lineplot,l66,f66narray[*,0]
;lineplot,l1,f1
;lineplot,l4,f4
;lineplot,l23e,f23e
;lineplot,l25e,f25e
;lineplot,l26e,f26e
;lineplot,lobs,fobs
END
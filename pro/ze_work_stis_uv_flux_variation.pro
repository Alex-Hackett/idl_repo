;PRO ZE_WORK_STIS_UV_FLUX_VARIATION
!P.Background = fsc_color('white')

;filename_23mar00_e140m='/Users/jgroh/data/hst/stis/etacar_from_john/kirst_hst/E140m/E140M_23mar00_OK.dat'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_23mar00_e140m,lambda_23mar00_e140m,flux_23mar00_e140m,mask_23mar00_e140m
;
;filename_04jul02='/Users/jgroh/data/hst/stis/etacar_from_john/star_04jul02'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_04jul02,lambda_04jul02,flux_04jul02,mask_04jul02
;
;filename_20jan02_e140m='/Users/jgroh/data/hst/stis/etacar_from_john/kirst_hst/E140m/E140M_20jan02_OK.dat'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_20jan02_e140m,lambda_20jan02_e140m,flux_20jan02_e140m,mask_20jan02_e140m
;
;filename_04jul02_e140m='/Users/jgroh/data/hst/stis/etacar_from_john/kirst_hst/E140m/E140M_04jul02_OK.dat'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_04jul02_e140m,lambda_04jul02_e140m,flux_04jul02_e140m,mask_04jul02_e140m
;
;filename_13feb03='/Users/jgroh/data/hst/stis/etacar_from_john/star_13feb03'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_13feb03,lambda_13feb03,flux_13feb03,mask_13feb03
;
;filename_13feb03_e140m='/Users/jgroh/data/hst/stis/etacar_from_john/kirst_hst/E140m/E140M_13feb03_OK.dat'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_13feb03_e140m,lambda_13feb03_e140m,flux_13feb03_e140m,mask_13feb03_e140m
;
;filename_26may03_e140m='/Users/jgroh/data/hst/stis/etacar_from_john/kirst_hst/E140m/E140M_26may03_OK.dat'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_26may03_e140m,lambda_26may03_e140m,flux_26may03_e140m,mask_26may03_e140m
;
;filename_01jun03_e140m='/Users/jgroh/data/hst/stis/etacar_from_john/kirst_hst/E140m/E140M_01jun03_OK.dat'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_01jun03_e140m,lambda_01jun03_e140m,flux_01jun03_e140m,mask_01jun03_e140m
;
;filename_01jun03='/Users/jgroh/data/hst/stis/etacar_from_john/star_01jun03'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_01jun03,lambda_01jun03,flux_01jun03,mask_01jun03
;
;filename_22jun03_e140m='/Users/jgroh/data/hst/stis/etacar_from_john/kirst_hst/E140m/E140M_22jun03_OK.dat'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_22jun03_e140m,lambda_22jun03_e140m,flux_22jun03_e140m,mask_22jun03_e140m
;
;filename_22jun03='/Users/jgroh/data/hst/stis/etacar_from_john/star_22jun03'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_22jun03,lambda_22jun03,flux_22jun03,mask_22jun03
;
;filename_05jul03_e140m='/Users/jgroh/data/hst/stis/etacar_from_john/kirst_hst/E140m/E140M_05jul03_OK.dat'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_05jul03_e140m,lambda_05jul03_e140m,flux_05jul03_e140m,mask_05jul03_e140m
;
;filename_05jul03='/Users/jgroh/data/hst/stis/etacar_from_john/star_05jul03'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_05jul03,lambda_05jul03,flux_05jul03,mask_05jul03

;lineplot,lambda_23mar00_e140m,flux_23mar00_e140m,title='23mar2000'
;lineplot,lambda_20jan02_e140m,flux_20jan02_e140m,title='20jan2002'
;lineplot,lambda_04jul02_e140m,flux_04jul02_e140m,title='04jul2002'
;lineplot,lambda_13feb03_e140m,flux_13feb03_e140m,title='13feb2003'
;lineplot,lambda_01jun03_e140m,flux_01jun03_e140m,title='01jun2003'
;lineplot,lambda_22jun03_e140m,flux_22jun03_e140m,title='22jun2003'
;lineplot,lambda_05jul03_e140m,flux_05jul03_e140m,title='05jul03'


;models at different phases
dir='/Users/jgroh/ze_models/2D_models/etacar/mod25_groh/'
model='cut_v4_vstream'   ;b,c,o,r,t,u,v don't cover the UV range
sufix='k'
filename='OBSFRAME1'

ZE_CMFGEN_READ_OBS_2D,filename,dir+model+'/'+sufix+'/',lmcav7,fmcav7,nmcav,/FLAM

dir='/Users/jgroh/ze_models/2D_models/etacar/mod25_groh/'
model='cut_v4_vstream'   ;b,c,o,r,t,u,v don't cover the UV range
sufix='l'
filename='OBSFRAME1'

ZE_CMFGEN_READ_OBS_2D,filename,dir+model+'/'+sufix+'/',lmcav5,fmcav5,nmcav,/FLAM

dir='/Users/jgroh/ze_models/2D_models/etacar/mod25_groh/'
model='cut_v4_vstream'   ;b,c,o,r,t,u,v don't cover the UV range
sufix='m'
filename='OBSFRAME1'

ZE_CMFGEN_READ_OBS_2D,filename,dir+model+'/'+sufix+'/',lmcav9,fmcav9,nmcav,/FLAM

dir='/Users/jgroh/ze_models/2D_models/etacar/mod25_groh/'
model='cut_v4_vstream'   ;b,c,o,r,t,u,v don't cover the UV range
sufix='n'
filename='OBSFRAME1'

ZE_CMFGEN_READ_OBS_2D,filename,dir+model+'/'+sufix+'/',lmcav9t,fmcav9t,nmcav,/FLAM

;lineplot,lmcav5,fmcav5,title='phase 0.5'
;lineplot,lmcav7,fmcav7,title='phase 0.75'
lineplot,lmcav9,fmcav9,title='phase 0.9'
lineplot,lmcav9t,fmcav9t,title='phase 0.9 interp'

END
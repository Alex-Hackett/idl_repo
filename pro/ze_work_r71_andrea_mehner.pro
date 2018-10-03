;PRO ZE_WORK_R71_ANDREA_MEHNER
ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/R71/1/obs/obs_fin','/Users/jgroh/ze_models/R71/1/obscont/obs_cont',lr,fr,LMIN=3050,LMAX=11000,/AIR
;ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/espectros/r71/R71_UVES_20020723_blue_360s_normI.txt',lblue,fblue
;ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/espectros/r71/R71_UVES_20020723_redl_110s_1_normI.txt',lredl,fredl
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/espectros/r71/R71_UVES_20020723_redu_110s_1_normI.txt',lredu,fredu
;ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/espectros/r71/R71_FEROS_20051212_1_norm.txt',lferos,fferos

frs=ZE_SHIFT_SPECTRA_VEL(lr,fr,196.0)

;lineplot,lblue,fblue
;lineplot,lredl,fredl
;lineplot,lredu,fredu
lineplot,lferos,fferos
lineplot,lr,frs


END
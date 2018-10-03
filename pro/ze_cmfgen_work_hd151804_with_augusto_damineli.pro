;PRO ZE_CMFGEN_WORK_HD151804_WITH_AUGUSTO_DAMINELI


ZE_READ_SPECTRA_FITS,'/Users/jgroh/hd151804/HD_3500a9000_08may15.fits',lopt,fopt,header

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/ogrid_24jun09/NT30000_logg300/obs/obs_fin_10','/Users/jgroh/ze_models/ogrid_24jun09/NT30000_logg300/obs/obs_cont',l30g30,f30g30,lmin=1000,lmax=9000,/AIR
ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/ogrid_24jun09/NT30000_logg325/obs/obs_fin_10','/Users/jgroh/ze_models/ogrid_24jun09/NT30000_logg325/obs/obs_cont',l30g32,f30g32,lmin=1000,lmax=9000,/AIR
ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/ogrid_24jun09/NT32500_logg350/obs/obs_fin_10','/Users/jgroh/ze_models/ogrid_24jun09/NT32500_logg350/obs/obs_cont',l32g35,f32g35,lmin=1000,lmax=9000,/AIR
ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/ogrid_24jun09/NT35000_logg350/obs/obs_fin_10','/Users/jgroh/ze_models/ogrid_24jun09/NT35000_logg350/obs/obs_cont',l35g35,f35g35,lmin=1000,lmax=9000,/AIR



vshift=-35.0
vrot=100.0
ze_lineplot,lopt,fopt
;ze_lineplot,l30g30,ZE_SHIFT_SPECTRA_VEL(l30g30,ZE_SPEC_CNVL_VEL(l30g30,f30g30,vrot),vshift)
ze_lineplot,l30g32,ZE_SHIFT_SPECTRA_VEL(l30g32,ZE_SPEC_CNVL_VEL(l30g32,f30g32,vrot),vshift)
ze_lineplot,l32g35,ZE_SHIFT_SPECTRA_VEL(l32g35,ZE_SPEC_CNVL_VEL(l32g35,f32g35,vrot),vshift)
;ze_lineplot,l35g35,ZE_SHIFT_SPECTRA_VEL(l35g35,ZE_SPEC_CNVL_VEL(l35g35,f35g35,vrot),vshift)

END
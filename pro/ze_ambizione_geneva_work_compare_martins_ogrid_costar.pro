;PRO ZE_AMBIZIONE_GENEVA_WORK_COMPARE_MARTINS_OGRID_COSTAR

!P.Background = fsc_color('white')

;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/ogrid_24jun09/NT42500_logg375/obs/obs_fin_5','/Users/jgroh/ze_models/ogrid_24jun09/NT42500_logg375/obs/obs_cont',l,f,/AIR
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/ogrid_24jun09/NT42500_logg375/obs/obs_fin_5',l1,f1,nrec1

;ZE_SPEC_CNVL,l1,f1,50.0,1300.,fluxcnvl=fluxcnvl

ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/costar/E3.dat',lc,fc
fc=10^fc
END
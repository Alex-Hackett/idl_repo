;PRO ZE_WORK_HD45166_WITH_SELMA_DE_MINK
;HD45166 with Selma de Mink

;load constants
ZE_EVOL_CONST,pi,cst_c,cst_G,cs,t_h,cst_k,cst_a,rgaz,cst_sigma,cst_me,cst_avo,cst_u,cst_mh,cst_thomson,cst_e,cst_ecgs,qapicg,cst_K1, $
                  lgpi,cstlg_c,cstlg_G,cstlg_h,cstlg_k,cstlg_a,rgazlg,cstlg_sigma,cstlg_me,cstlg_avo,cstlg_u,cstlg_mh,cstlg_thomson,cstlg_e, $
                  lgqapicg,cstlg_K1,Msol,Rsol,Lsol,xlsomo,uastr,year,lgMsol,lgRsol,lgLsol,Q_H,Q_He,Q_C,convMeVerg

ZE_CMFGEN_COMPUTE_NUMBER_H_IONIZING_PHOTONS,'/Users/jgroh/ze_models/HD45166/106_copy_exp/obs2D/obs_fin',nphot_hyd,nphot_hei,nphot_he2,lum_hyd,lum_hei,lum_he2

ZE_CMFGEN_COMPUTE_NUMBER_H_IONIZING_PHOTONS,'/Users/jgroh/ze_models/HD45166/106_ZSMC_Mdot_scaled/obs/obs_fin',nphot_hyd,nphot_hei,nphot_he2,lum_hyd,lum_hei,lum_he2

rstar=0.5094
Mstar=4.2

logg=alog10(cst_G*Mstar*Msol/(rstar*Rsol)^2)
print,'log g(tau=100)= ',logg


ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/HD45166/106_copy_exp/obs2D/obs_fin',l,f,/FLAM
ZE_CMFGEN_READ_OBS,'/Users/jgroh/espectros/H',l,f,/FLAM
ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/HD45166/106_copy_exp/obs2D/obs_fin','/Users/jgroh/ze_models/HD45166/106_copy_exp/obs/obs_cont',ln,fn


ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/HD45166/106_ZSMC_Mdot_scaled/obs/obs_fin',lsmc,fsmc,/FLAM
ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/HD45166/106_ZSMC_Mdot_scaled/obs/obs_fin','/Users/jgroh/ze_models/HD45166/106_ZSMC_Mdot_scaled/obscont/obs_fin',lsmcn,fsmcn


;observed spectrum of HD45166
;ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/espectros/hd45166/hd45_alex_obs_minusb8_norm_highres.txt',lhd45obsn,fhd45obsn
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/espectros/hd45166/hd45_alex_obs_minusb8_flux_highres.txt',lhd45obs,fhd45obs


;ogrid_24jun09 models spectra
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/ogrid_24jun09/NT27500_logg375/obs/obs_fin_10',l27500logg375,f27500logg375,/FLAM
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/ogrid_24jun09/NT30000_logg400/obs/obs_fin_10',l30000logg400,f30000logg400,/FLAM

;convolve to vsini=50 km/s
vconv=50.0
f27500logg375cnvl=ZE_SPEC_CNVL_VEL(l27500logg375,f27500logg375,vconv)
f30000logg400cnvl=ZE_SPEC_CNVL_VEL(l30000logg400,f30000logg400,vconv)

;interp to same lambda grid as observed HD45166
f27500logg375cnvli=cspline(l27500logg375,f27500logg375cnvl,lhd45obs)
f30000logg400cnvli=cspline(l30000logg400,f30000logg400cnvl,lhd45obs)


;FORS2 spectral resolution 600B R=1000 (Evans et al. 2007 AJ paper)
rfors=1000.
vfors=299792./rfors
f27500logg375cnvlif=ZE_SPEC_CNVL_VEL(l27500logg375,f27500logg375cnvli,vfors)


lineplot,lhd45obs,fhd45obs+f27500logg375cnvli*0.71


;ZE_WRITE_SPECTRA_COL_VEC,'/Users/jgroh/temp/hd45166_model106_lambda_flam_fnorm.dat',l,f,fn

END
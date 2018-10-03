;PRO ZE_ETACAR_CMFGEN_MODEL_CUT_JOHN_COMPARE_SED_MOD43_GROH_FOR_MAIRAN_TEOdORO

close,/all
Angstrom = '!6!sA!r!u!9 %!6!n!6'
!P.Background = fsc_color('white')

ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/etacar/mod43_groh/obs/obs_fin',lmfull,fmfull,/FLAM
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/etacar/mod43_groh/obs/obs_fin',lmfull,fmfull,/FLAM

dir1='/Users/jgroh/ze_models/2D_models/etacar/mod43_groh/'
model1='cut_v4_vstream'   ;b,c,o,r,t,u,v don't cover the UV range
sufix1='inc_ang/0_10_20'
filename1='OBSFRAME1'
ZE_CMFGEN_READ_OBS_2D,filename1,dir1+model1+'/'+sufix1+'/',lmopt,fmopt,nm1,/FLAM
ZE_BH05_CAVITY_GET_INC_FROM_OBS_INP,dir1,model1,sufix1,filename1,inc1,inc_str1

;starting here we computed the flux for 3 angles, (OBSFRAME1=equator,OBSFRAME2=41deg,OBSFRAME3=pole)
filename1='OBSFRAME1'
sufix1='e'
ZE_CMFGEN_READ_OBS_2D,filename1,dir1+model1+'/'+sufix1+'/',lmuv,fmuv,nm1,/FLAM

sufix1='g'
ZE_CMFGEN_READ_OBS_2D,filename1,dir1+model1+'/'+sufix1+'/',lmmir,fmmir,nm1,/FLAM
;has a Nan values above 8e5 angs, corresponding to index 20000. shrinking vector
lmmir=lmmir[0:20000]
fmmir=fmmir[0:20000]

sufix1='f'
ZE_CMFGEN_READ_OBS_2D,filename1,dir1+model1+'/'+sufix1+'/',lmir,fmir,nm1,/FLAM

resolving_power=100.
lambda_val=1000
res=lambda_val/resolving_power
ZE_SPEC_CNVL,lmfull,fmfull,res,lambda_val,fluxcnvl=fmfullconv
ZE_SPEC_CNVL,lmuv,fmuv,res,lambda_val,fluxcnvl=fmuvconv
ZE_SPEC_CNVL,lmopt,fmopt,res,lambda_val,fluxcnvl=fmoptconv
ZE_SPEC_CNVL,lmir,fmir,res,lambda_val,fluxcnvl=fmirconv
ZE_SPEC_CNVL,lmmir,fmmir,res,lambda_val,fluxcnvl=fmmirconv

;interpolate cavity model into spherical model lambda grid and compute flux ratio
lm43equator=[lmuv,lmopt,lmir,lmmir]
fm43equator=[fmuv,fmopt,fmir,fmmir]

END
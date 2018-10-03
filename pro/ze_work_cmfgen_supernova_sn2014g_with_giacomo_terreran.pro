;PRO ZE_WORK_CMFGEN_SUPERNOVA_SN2014G_WITH_GIACOMO_TERRERAN

ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/papers_in_preparation_groh/2014G_with_terreran/2014G_20140114_P122_BC_300tr.dat',lobs,fobs
;normlizing spectrum
;line_norm,lobs,fobs,fobsnorm,fobsnval,fobsxnodesnorm,fobsnodesnorm
;save,lobs,fobs,fobsnorm,fobsnval,fobsxnodesnorm,fobsnodesnorm,filename='/Users/jgroh/temp/SN2014G_obs.sav'
;STOP
restore,'/Users/jgroh/temp/SN2014G_obs.sav'



;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13ast/46/obs/obs_fin',l1,f1,/FLAM,lmin=1150,lmax=11000,/AIR
;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13ast/52/obs/obs_fin',l2,f2,/FLAM,lmin=1150,lmax=11000,/AIR

ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/14G/1/obs/obs_fin',l1,f1,/FLAM,lmin=1150,lmax=11000,/AIR
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/14G/3/obs/obs_fin',l3,f3,/FLAM,lmin=1150,lmax=11000,/AIR
;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/14G/1/OBSFLUX',l1,f1,/FLAM,lmin=1150,lmax=11000,/AIR
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/14G/2/obs/obs_fin',l2,f2,/FLAM,lmin=1150,lmax=11000,/AIR
;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/14G/3/OBSFLUX',l3,f3,/FLAM,lmin=1150,lmax=11000,/AIR
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/14G/4/obs/obs_fin',l4,f4,/FLAM,lmin=1150,lmax=11000,/AIR
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/14G/5/obs/obs_fin',l5,f5,/FLAM,lmin=1150,lmax=11000,/AIR

ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/14G/1/obs/obs_fin','/Users/jgroh/ze_models/14G/1/obscont/obs_fin',l1n,f1n,lmin=1000,lmax=9000,/AIR


velcnvl=600.0 ; corresponding to R=500 
f1cnv=ZE_SPEC_CNVL_VEL(l1,f1,velcnvl)
f2cnv=ZE_SPEC_CNVL_VEL(l2,f2,velcnvl)
f3cnv=ZE_SPEC_CNVL_VEL(l3,f3,velcnvl)
f4cnv=ZE_SPEC_CNVL_VEL(l4,f4,velcnvl)
f5cnv=ZE_SPEC_CNVL_VEL(l5,f5,velcnvl)
;
; 

f1ncnv=ZE_SPEC_CNVL_VEL(l1n,f1n,velcnvl)

ebv=0.2
rv=3.1 
fm_unred, l1,f1cnv, ebv, f1cnvd, R_V=rv
;fm_unred, l3,f3cnv, ebv, f3cnvd, R_V=rv


dist=24.5e3 ;in kpc


;flux cliabrated spectrum for luminosity determinations
ze_lineplot,lobs,fobs
ze_lineplot,l1,f1cnv/dist^2
ze_lineplot,l2,f2cnv/dist^2
ze_lineplot,l3,f3cnv/dist^2
ze_lineplot,l4,f4cnv/dist^2
ze_lineplot,l5,f5cnv/dist^2
;;normalized spectrum
;ze_lineplot,lobs,fobsnorm
;ze_lineplot,l3n,f3ncnv

;computes distance of shock front
time14G=2.5*24.
r_shock=ZE_COMPUTE_DISTANCE_SN_SHOCK_FRONT(time14G,1e4) ;6.2h, 1e4 km/s
r_light=ZE_COMPUTE_DISTANCE_SN_SHOCK_FRONT(time14G,2.9929e5) ;distance travelled by light in 6.2h
;rectime=ZE_COMPUTE_RECOMBINATION_TIMESCALE(ed)
;vwind=100.0

END
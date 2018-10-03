;PRO ZE_WORK_SN_SPECTRA_FLASH_CSM_WITH_OFER_YARON_AVISHAY_GALYAM

ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/papers_in_preparation_groh/13dqy_ofer_yaron/lrisPTF13dqyEpoch1.spec.calcorr',lobs,fobs
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/papers_in_preparation_groh/13dqy_ofer_yaron/lrisPTF13dqy-UT09-sub.spec.calcorr',lobsnew,fobsnew
;ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/papers_in_preparation_groh/13dqy_ofer_yaron/13dqy_20131007_NOT_v1.ascii.calcorr',lobs,fobs
;line_norm,lobs,fobs,fobsnorm,fobsnval,fobsxnodesnorm,fobsynodesnorm
;save,lobs,fobs,fobsnorm,fobsnval,fobsxnodesnorm,fobsynodesnorm,filename='/Users/jgroh/temp/13dqy_lrisPTF13dqyEpoch2.spec.calcorr_norm.sav'
;restore,'/Users/jgroh/temp/13dqy_lrisPTF13dqyEpoch2.spec.calcorr_norm.sav',/VERBOSE

;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/grid_P060z14S0/model6250_T56420_L897212_logg_2d913_tauref20/obs/obs_fin_10','/Users/jgroh/ze_models/grid_P060z14S0/model6250_T56420_L897212_logg_2d913_tauref20/obscont/obs_cont',l01,f01,lmin=1150,lmax=10000
;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13ast/22/obs/obs_fin',l1,f1,/FLAM,lmin=1150,lmax=9000

;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/39/obs/obs_fin',l1,f1,/FLAM,lmin=1150,lmax=9000
;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/20/obs/obs_fin',l1,f1,/FLAM,lmin=1150,lmax=9000
;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/16/obs/obs_fin',l1,f1,/FLAM,lmin=1150,lmax=9000
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/11/obs/obs_fin',l1,f1,/FLAM,lmin=3000,lmax=9000;,/AIR
;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/76/OBSFLUX',l1,f1,/FLAM,lmin=3000,lmax=9000;,/AIR
;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/new_wo/r2/obs/obs_fin',l1,f1,/FLAM,lmin=1150,lmax=9000
;19 and 20 seem to bracket well the observed spectra, but 19 has accelerating wind
;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/binary/casA/prim/model046806_T072398_L0087100_logg4.538/OBSFLUX',l1,f1,/FLAM,lmin=1150,lmax=9000

;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/grid_P060z14S0/model6250_T56420_L897212_logg_2d913_tauref20/obs/obs_fin_10',l2,f2,/FLAM
;ZE_CMFGEN_READ_OBSFLUX,'/Users/jgroh/ze_models/13ast/11/OBSFLUX',l2,f2,/FLAM ,lmin=1150,lmax=9000
;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/2/obs/obs_fin',l2,f2,/FLAM,lmin=3050,lmax=9000
;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/4/obs/obs_fin',l2,f2,/FLAM,lmin=3050,lmax=9000
;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/5/obs/obs_fin',l2,f2,/FLAM,lmin=1150,lmax=9000
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/79/obs/obs_fin',l2,f2,/FLAM,lmin=1150,lmax=9000

ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/76/OBSFLUX',l76,f76,/FLAM,lmin=3000,lmax=9000;,/AIR
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/74/OBSFLUX',l74,f74,/FLAM,lmin=3000,lmax=9000;,/AIR
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/87/OBSFLUX',l87,f87,/FLAM,lmin=3000,lmax=9000;,/AIR
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/88/OBSFLUX',l88,f88,/FLAM,lmin=3000,lmax=9000;,/AIR

;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/76/obs/obs_fin',l76,f76,/FLAM,lmin=3000,lmax=9000;,/AIR
;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/85/obs/obs_fin',l85,f85,/FLAM,lmin=3000,lmax=9000;,/AIR

;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/73/obs/obs_fin',l2,f2,/FLAM,lmin=3000,lmax=9000;,/AIR
;;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/7/obs/obs_fin',l2,f2,/FLAM,lmin=1150,lmax=9000
;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/38/obs/obs_fin',l2,f2,/FLAM,lmin=1150,lmax=9000
;;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/17/obs/obs_fin',l2,f2,/FLAM,lmin=1150,lmax=9000
;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/24/obs/obs_fin',l2,f2,/FLAM;,lmin=1150,lmax=9000
;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/29/obs/obs_fin',l2,f2,/FLAM,lmin=1150,lmax=9000
;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/32/obs/obs_fin',l2,f2,/FLAM,lmin=1150,lmax=9000
;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/SN_progenitor_grid/P120z14S0_model025926_T167648_L1784201_logg5.527/obs/obs_fin',l2,f2,/FLAM


;for paper:
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/74/obs_es_20/obs_fin',l1,f1,/FLAM,lmin=3000,lmax=9000;,/AIR ;T*=48.4kK
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/74_more_xrays/obs/obs_fin',l1x,f1x,/FLAM,lmin=3000,lmax=9000;,/AIR ;T*=48.4kK with x-rays starting in the inner boundary
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/74_xray2/obs/obs_fin',l1x2,f1x2,/FLAM,lmin=3000,lmax=9000;,/AIR ;T*=48.4kK with x-rays starting in the inner boundary
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/74_xray3/obs/obs_fin',l1x3,f1x3,/FLAM,lmin=3000,lmax=9000;,/AIR ;T*=48.4kK with x-rays starting in the inner boundary
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/76/obs_es_20/obs_fin',l2,f2,/FLAM,lmin=3000,lmax=9000;,/AIR ;T*=53.5kK
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/78/obs_es_20/obs_fin',l3,f3,/FLAM,lmin=3000,lmax=9000;,/AIR ;T*=57.5kK; He enhanced, N solar
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/78_vinf20_nohei/obs_es_20/obs_fin',l4,f4,/FLAM,lmin=3000,lmax=9000;,/AIR ;T*=57.5kK
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/78_vinf20_nohei/obs_es_20/obs_fin',l4,f4,/FLAM,lmin=3000,lmax=9000;,/AIR ;T*=57.5kK
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/90/obs_es_20/obs_fin',l90,f90,/FLAM,lmin=3000,lmax=9000;,/AIR ;T*=57.5kK
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/91/obs_es_20/obs_fin',l91,f91,/FLAM,lmin=3000,lmax=9000;,/AIR ;T*=57.5kK; H/He solar
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/92/obs_es_20/obs_fin',l92,f92,/FLAM,lmin=3000,lmax=9000;,/AIR ;T*=57.5kK; He enhanced, N enhanced x5
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/93/obs_es_20/obs_fin',l93,f93,/FLAM,lmin=3000,lmax=9000;,/AIR ;T*=57.5kK; He enhanced, N enhanced x10
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/94/obs_es_20/obs_fin',l94,f94,/FLAM,lmin=3000,lmax=9000;,/AIR ;T*=57.5kK; He enhanced, N enhanced x5, vinf=15km/s
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/95/obs_es_20/obs_fin',l95,f95,/FLAM,lmin=3000,lmax=9000;,/AIR ;T*=57.5kK; same as 92, He enhanced, N enhanced x5, beta=1.5
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/96/obs_es_20/obs_fin',l96,f96,/FLAM,lmin=3000,lmax=9000;,/AIR ;T*=57.5kK; same as 92, He enhanced, N enhanced x5, beta=3.0
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/97/obs_es_20/obs_fin',l97,f97,/FLAM,lmin=3000,lmax=9000;,/AIR ;T*=57.5kK; same as 94, but Rmax=6.7e14

;test truncated model to mimic ionization volume to 7e14cm
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/78/obs/obs_fin',l78,f78,/FLAM,lmin=3000,lmax=9000;,/AIR ;T*=57.5kK
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/13dqy/78_rmax7e14/obs/obs_fin',l78rmax,f78rmax,/FLAM,lmin=3000,lmax=9000;,/AIR ;T*=57.5kK; rmax=7e14cm


;line_norm,lobs,fobs,fobsnorm,fobsnval,fobsxnodesnorm,fobsynodesnorm
;save,lobs,fobs,fobsnorm,fobsnval,fobsxnodesnorm,fobsynodesnorm,filename='/Users/jgroh/temp/13ast_20130503_norm.sav'
;restore,'/Users/jgroh/temp/13ast_20130503_norm.sav',/VERBOSE

;redshift correction of observed spectrum
z = 0.011855
lambda_factor=1+z
;lobs=lobs/lambda_Factor ;leave this COMMENTED since ofer yaron's spectra are already corrected by the redshift

;convolving to the same resolution and regridding
f1cnvl=ZE_SPEC_CNVL_VEL(l1,f1,175.0)
f2cnvl=ZE_SPEC_CNVL_VEL(l2,f2,175.0)
f3cnvl=ZE_SPEC_CNVL_VEL(l3,f3,175.0)
f4cnvl=ZE_SPEC_CNVL_VEL(l4,f4,175.0)
f78cnvl=ZE_SPEC_CNVL_VEL(l78,f78,175.0)
f78rmaxcnvl=ZE_SPEC_CNVL_VEL(l78rmax,f78rmax,175.0)
f90cnvl=ZE_SPEC_CNVL_VEL(l90,f90,175.0)
f91cnvl=ZE_SPEC_CNVL_VEL(l91,f91,175.0)
f92cnvl=ZE_SPEC_CNVL_VEL(l92,f92,175.0)
f93cnvl=ZE_SPEC_CNVL_VEL(l93,f93,175.0)
f94cnvl=ZE_SPEC_CNVL_VEL(l94,f94,175.0)
f95cnvl=ZE_SPEC_CNVL_VEL(l95,f95,175.0)
f96cnvl=ZE_SPEC_CNVL_VEL(l96,f96,175.0)
f97cnvl=ZE_SPEC_CNVL_VEL(l97,f97,175.0)


linterp,l1,f1cnvl,lobs,f1cnvli
linterp,l2,f2cnvl,lobs,f2cnvli
;linterp,f3,f3cnvl,lobs,f3cnvli

dist = lumdist(z) * 1e3
fm_unred, lobs,fobs, 0.06, fobsderedd, R_V=3.1
fobs=fobsderedd

fm_unred, lobsnew,fobsnew, 0.06, fobsnewderedd, R_V=3.1
fobsnew=fobsnewderedd

;lineplot,lobs,fobsnorm
;lineplot,l1,f1cnvli

scale1=1.0
scale2=0.914703
scale3=0.870852

lplanck=findgen(10000)*10
bbflux=planck(lplanck,20000.)
bbflux=bbflux*1.2734d-21
;lineplot,lobs,fobsderedd
lineplot,lobsnew,fobsnew
;lineplot,lobs,f2cnvli/(dist^2) *1.0
lineplot,l1,f1cnvl/(dist^2)*scale1 
lineplot,l2,f2cnvl/(dist^2)*scale2
lineplot,l3,f3cnvl/(dist^2)*scale2
lineplot,l4,f4cnvl/(dist^2)*scale2
;lineplot,lobsnew,fobsnew
;lineplot,l1x2,f1x2/(dist^2)*scale2
;lineplot,l1x3,f1x3/(dist^2)*scale2
;lineplot,l3,f3cnvl/(dist^2)*scale3

;ZE_CMFGEN_EVOL_FIND_CLOSEST_MODEL,50000.,5e6,1e-2,400.,0.2,0.78,0.00002,2e-3,2e-4,xn_array_sort,tstar_array_sort,lstar_array_sort,mdot_array_sort,vinf_array_sort,r_t_array_sort,tcut=0.3,modelid='13ast1',xwidget=1
;ZE_WRITE_SPECTRA_COL_VEC,'/Users/jgroh/temp/13ast_model14_fwhm175_to_avishay_carbon_times0d1.dat',l2,f2cnvl/(dist^2) *0.63795
;compute R band magnitude
;ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,'/Users/jgroh/ze_models/etacar/','mod16_groh','R',Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt;,redshift=0.025


ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,lobsnew,fobsnew,'Rest Wavelength (Angstrom)', '','',/ylog,$
                          x2=l1,y2=f1cnvl/(dist^2)*scale1,linestyle2=0,$
                          x3=l2,y3=f2cnvl/(dist^2)*scale2,linestyle3=2,$
                          x4=l3,y4=f3cnvl/(dist^2)*scale3,linestyle4=3,color4='orange',$
;                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
;                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
;                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
;                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
;                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
;                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
                          pthick=6,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=800,bb=500,$
                          xrange=[3100,6700],yrange=[1.6e-16,2.9e-15],POSITION=[0.14,0.10,0.98,0.98],filename='13dqy';,/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.05,id_ypos=10.5,size_id_text=1.0,elem=elem


ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,lobs,fobs,'Wavelength (Angstrom)', 'Flux [erg/s/cm^2/A]','',$
                          x2=l1,y2=f1cnvl/(dist^2)*scale1,linestyle2=0,$
                          x3=l2,y3=f2cnvl/(dist^2)*scale2,linestyle3=2,$
                          x4=l3,y4=f3cnvl/(dist^2)*scale3,linestyle4=3,color4='orange',$
;                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
;                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
;                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
;                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
;                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
;                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
                          pthick=7,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=800,bb=500,$
                          xrange=[3100,4400],yrange=[4.0e-16,2.9e-15],POSITION=[0.14,0.10,0.98,0.98],filename='13dqy_1';,/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.05,id_ypos=10.5,size_id_text=1.0,elem=elem

ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,lobs,fobs,'Wavelength (Angstrom)', 'Flux [erg/s/cm^2/A]','',$
                          x2=l1,y2=f1cnvl/(dist^2)*scale1,linestyle2=0,$
                          x3=l2,y3=f2cnvl/(dist^2)*scale2,linestyle3=2,$
                          x4=l3,y4=f3cnvl/(dist^2)*scale3,linestyle4=3,color4='orange',$
;                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
;                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
;                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
;                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
;                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
;                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
                          pthick=7,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=800,bb=500,$
                          xrange=[4400,5400],yrange=[1.6e-16,13.0e-16],POSITION=[0.14,0.10,0.98,0.98],filename='13dqy_2';,/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.05,id_ypos=10.5,size_id_text=1.0,elem=elem


ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,lobs,fobs,'Wavelength (Angstrom)', 'Flux [erg/s/cm^2/A]','',$
                          x2=l1,y2=f1cnvl/(dist^2)*scale1,linestyle2=0,$
                          x3=l2,y3=f2cnvl/(dist^2)*scale2,linestyle3=2,$
                          x4=l3,y4=f3cnvl/(dist^2)*scale3,linestyle4=3,color4='orange',$
;                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
;                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
;                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
;                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
;                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
;                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
                          pthick=7,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=800,bb=500,$
                          xrange=[5400,6800],yrange=[1.6e-16,7.0e-16],POSITION=[0.14,0.10,0.98,0.98],filename='13dqy_3';,/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.05,id_ypos=10.5,size_id_text=1.0,elem=elem




;shifted for clarity
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,lobsnew,fobsnew,'Rest Wavelength (Angstrom)', '','',$
                          x2=l1,y2=f1cnvl/(dist^2)*scale1+0.5e-15,linestyle2=0,$
                          x3=l2,y3=f2cnvl/(dist^2)*scale2+1.0e-15,linestyle3=2,$
                          x4=l3,y4=f3cnvl/(dist^2)*scale3+1.5e-15,linestyle4=3,color4='orange',$
;                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
;                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
;                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
;                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
;                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
;                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
                          pthick=6,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=800,bb=500,$
                          xrange=[3100,6700],yrange=[1.6e-16,3.9e-15],POSITION=[0.14,0.10,0.98,0.98],filename='13dqy_shifted';,/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.05,id_ypos=10.5,size_id_text=1.0,elem=elem


;progenitor magnitude in ptf-r
ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,'/Users/jgroh/ze_models/13dqy/','78','ptf_r',Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt,dist=51.3e3

rvtj='/Users/jgroh/ze_models/13dqy/78/RVTJ'
ZE_READ_RVTJ,rvtj,r,v,sigma,ed,t,chiross,fluxross,atom,ionden,den,clump,ND,NC,NP,NCF,mdot,lstar,output_format_date,$
    completion_of_model,program_date,was_t_fixed,species_name_con,greyt,heating_rad_decay

ZE_CMFGEN_COMPUTE_OPTICAL_DEPTH_TORSCL,CHIross,R,tauross

data2=read_ascii('/Users/jgroh/ze_models/13dqy/76/MEANOPAC',DATA_START=1,COMMENT_SYMBOL='NB')
taues=REFORM(data2.field01[10,*]*1D0)


;computes distance of shock front    
r_shock=ZE_COMPUTE_DISTANCE_SN_SHOCK_FRONT(6.2,1e4) ;6.2h, 1e4 km/s
r_light=ZE_COMPUTE_DISTANCE_SN_SHOCK_FRONT(6.2,2.9929e5) ;distance travelled by light in 6.2h
rectime=ZE_COMPUTE_RECOMBINATION_TIMESCALE(ed)
vwind=100.0  
;print,mdot*6.30321217d25/(4.*3.141592*((r_shock)^2)*vwind*1d5)

;plot recombination timescale
;lineplot,reform(r*1e10),(rectime/(365.*24.)),ytitle='Recombination time (h)', xtitle='Distance (cm)'
;lineplot,reform(r*1e10),reform(data.field01[11,*])


rstar=r[ND-1]
heff=0.007 *rstar;in units of rstar
den0=1e-9
;den1=den0*(exp(r0/r) -1 )/max(exp(r0/r) -1)
den1=den0*exp((Rstar - r)/heff)
den2=mdot*6.30321217d25/(4.*3.141592*((r*1d10)^2)*vwind*1d5)
transradius=min(where(den1-den2 GT 0))
dencomb=[den2[0:transradius-1],den1[transradius:nd-1]]


;plot v,den,line forming regions
data=read_ascii('/Users/jgroh/ze_models/13dqy/78/13dqy_78_lineform.dat',DATA_START=2)
v=replicate(40.,nd)
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,r*1e10,data.field01[1,*],TEXTOIDL('r (cm)'),TEXTOIDL('Line forming region'),'',linestyle1=0,color1='black',$ 
                                _EXTRA=extra,/xlog,ylog=0,/nodata,xrange=[1.2e14,2.5e16],yrange=[-0.1,5],psxsize=900,psysize=400,filename='13dqy_78_lineform',$
                                 x2=r*1e10,y2=data.field01[1,*],color2='red',linestyle2=0,double_yaxis=0,$;OIV 3411 
                                 x3=r*1e10,y3=data.field01[3,*],color3='blue',linestyle3=3,$ ;OVI3811
                                 x4=r*1e10,y4=data.field01[5,*],color4='brown',linestyle4=2,$ ;HeII 4686
                         ;        x5=r*1e10,y5=data.field01[7,*],color5='green',linestyle5=0,$ ;OIII 5007
                                 x6=r*1e10,y6=data.field01[9,*],color6='orange',linestyle6=5,$ ;OV 5597
                                 x7=r*1e10,y7=data.field01[11,*],color7='purple',linestyle7=2,$ ;H alpha 6562 
                                 x8=r*1e10,y8=taues,linestyle8=0,$ ;C3+  
;                                x9=data.field01[0,*],y9=data.field01[33,*],color9=colorcarb,linestyle9=1,$ ;C4+
;                                x10=data.field01[0,*],y10=data.field01[39,*],color_10=coloriron,linestyle_10=0,$ ;Fe5+    
;                                x11=data.field01[0,*],y11=data.field01[41,*],color_11=coloriron,linestyle_11=1,$ ;Fe6+      
;                                x12=data.field01[0,*],y12=data.field01[43,*],color_12=coloriron,linestyle_12=2,$ ;Fe7+                                                                                         
                                xcharsize=1.9,ycharsize=1.9,POSITION=[0.10,0.16,0.90,0.97],pthick=10,charthick=8,xthick=8,ythick=8;,/DOUBLE_YAXIS;,$
                                ;,/noyaxisvalues

;zoom in inner region
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,r*1e10,data.field01[1,*],TEXTOIDL('r (cm)'),TEXTOIDL('Line forming region'),'',linestyle1=0,color1='black',$ ;H0
                                _EXTRA=extra,xlog=0,ylog=0,/nodata,xrange=[1.4e14,2.0e14],yrange=[-0.1,15],xticks=4,xminor=5,psxsize=900,psysize=400,filename='13dqy_78_lineform_zoom',$
                                 x2=r*1e10,y2=data.field01[1,*],color2='red',linestyle2=0,double_yaxis=0,$;OIV 3411 
                                 x3=r*1e10,y3=data.field01[3,*],color3='blue',linestyle3=3,$ ;OVI3811
                                 x4=r*1e10,y4=data.field01[5,*],color4='brown',linestyle4=2,$ ;HeII 4686
                         ;        x5=r*1e10,y5=data.field01[7,*],color5='green',linestyle5=0,$ ;OIII 5007
                                 x6=r*1e10,y6=data.field01[9,*],color6='orange',linestyle6=5,$ ;OV 5597
                                 x7=r*1e10,y7=data.field01[11,*],color7='purple',linestyle7=2,$ ;H alpha 6562 
                                 x8=r*1e10,y8=taues,linestyle8=0,$ ;C3+  
;                                x9=data.field01[0,*],y9=data.field01[33,*],color9=colorcarb,linestyle9=1,$ ;C4+
;                                x10=data.field01[0,*],y10=data.field01[39,*],color_10=coloriron,linestyle_10=0,$ ;Fe5+    
;                                x11=data.field01[0,*],y11=data.field01[41,*],color_11=coloriron,linestyle_11=1,$ ;Fe6+      
;                                x12=data.field01[0,*],y12=data.field01[43,*],color_12=coloriron,linestyle_12=2,$ ;Fe7+                                                                                         
                                xcharsize=1.9,ycharsize=1.9,POSITION=[0.10,0.16,0.90,0.97],pthick=10,charthick=8,xthick=8,ythick=8;,/DOUBLE_YAXIS;,$
                                ;,/noyaxisvalues

;plot v,den,line forming regions
data=read_ascii('/Users/jgroh/ze_models/13dqy/76/13dqy_76_lineform.dat',DATA_START=2)
v=replicate(40.,nd)
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,r*1e10,data.field01[1,*],TEXTOIDL('r (cm)'),TEXTOIDL('Line forming region'),'',linestyle1=0,color1='black',$ 
                                _EXTRA=extra,/xlog,ylog=0,/nodata,xrange=[1.2e14,2.5e16],yrange=[-0.1,3.5],psxsize=900,psysize=400,filename='13dqy_76_lineform',$
                                 x2=r*1e10,y2=data.field01[1,*],color2='red',linestyle2=0,double_yaxis=1,alty_min=1,alty_max=5,$;OIV 3411 
                                 x3=r*1e10,y3=data.field01[3,*],color3='blue',linestyle3=3,$ ;OVI3811
                                 x4=r*1e10,y4=data.field01[5,*],color4='brown',linestyle4=2,$ ;HeII 4686
                         ;        x5=r*1e10,y5=data.field01[7,*],color5='green',linestyle5=0,$ ;OIII 5007
                                 x6=r*1e10,y6=data.field01[9,*],color6='orange',linestyle6=5,$ ;OV 5597
                                 x7=r*1e10,y7=data.field01[11,*],color7='purple',linestyle7=2,$ ;H alpha 6562 
                                 x8=r*1e10,y8=taues,linestyle8=0,$ ;C3+  
                                 alt_x7=r*1e10,alt_y7=t,alt_color7='green',alt_linestyle7=2,$
;                                x9=data.field01[0,*],y9=data.field01[33,*],color9=colorcarb,linestyle9=1,$ ;C4+
;                                x10=data.field01[0,*],y10=data.field01[39,*],color_10=coloriron,linestyle_10=0,$ ;Fe5+    
;                                x11=data.field01[0,*],y11=data.field01[41,*],color_11=coloriron,linestyle_11=1,$ ;Fe6+      
;                                x12=data.field01[0,*],y12=data.field01[43,*],color_12=coloriron,linestyle_12=2,$ ;Fe7+                                                                                         
                                xcharsize=1.9,ycharsize=1.9,POSITION=[0.10,0.16,0.90,0.97],pthick=10,charthick=8,xthick=8,ythick=8;,/DOUBLE_YAXIS;,$
                                ;,/noyaxisvalues

;zoom in inner region
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,r*1e10,data.field01[1,*],TEXTOIDL('r (cm)'),TEXTOIDL('Line forming region'),'',linestyle1=0,color1='black',$ ;H0
                                _EXTRA=extra,xlog=0,ylog=0,/nodata,xrange=[1.4e14,2.0e14],yrange=[-0.1,15],xticks=4,xminor=5,psxsize=900,psysize=400,filename='13dqy_76_lineform_zoom',$
                                 x2=r*1e10,y2=data.field01[1,*],color2='red',linestyle2=0,double_yaxis=1,alty_min=2,alty_max=8,$;OIV 3411 
                                 x3=r*1e10,y3=data.field01[3,*],color3='blue',linestyle3=3,$ ;OVI3811
                                 x4=r*1e10,y4=data.field01[5,*],color4='brown',linestyle4=2,$ ;HeII 4686
                         ;        x5=r*1e10,y5=data.field01[7,*],color5='green',linestyle5=0,$ ;OIII 5007
                                 x6=r*1e10,y6=data.field01[9,*],color6='orange',linestyle6=5,$ ;OV 5597
                                 x7=r*1e10,y7=data.field01[11,*],color7='purple',linestyle7=2,$ ;H alpha 6562 
                                 x8=r*1e10,y8=taues,linestyle8=0,$ ;C3+ 
                                 alt_x7=r*1e10,alt_y7=t,alt_color7='green',alt_linestyle7=2,$ 
;                                x9=data.field01[0,*],y9=data.field01[33,*],color9=colorcarb,linestyle9=1,$ ;C4+
;                                x10=data.field01[0,*],y10=data.field01[39,*],color_10=coloriron,linestyle_10=0,$ ;Fe5+    
;                                x11=data.field01[0,*],y11=data.field01[41,*],color_11=coloriron,linestyle_11=1,$ ;Fe6+      
;                                x12=data.field01[0,*],y12=data.field01[43,*],color_12=coloriron,linestyle_12=2,$ ;Fe7+                                                                                         
                                xcharsize=1.9,ycharsize=1.9,POSITION=[0.10,0.16,0.90,0.97],pthick=10,charthick=8,xthick=8,ythick=8;,/DOUBLE_YAXIS;,$
                                ;,/noyaxisvalues

;;normalized line profiles to probe electron scattering wings
;;lineplot,ZE_LAMBDA_TO_VEL(l29,6562.79), (f29n -1.0)/11.46, title='Halpha'
;;lineplot,ZE_LAMBDA_TO_VEL(l29,4861.32), (f29n -1.0)/2.776, title='Hbeta'
;;lineplot,ZE_LAMBDA_TO_VEL(l29,4340.6), (f29n -1.0)/1.120, title='Hgamma'
;;lineplot,ZE_LAMBDA_TO_VEL(l29,4685.7), (f29n -1.0)/0.574, title='He II 4686'
;;lineplot,ZE_LAMBDA_TO_VEL(l29,5875.66), (f29n -1.0)/1.496, title='He I 5786'
;
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,ZE_LAMBDA_TO_VEL(l29,6562.79), (f29n -1.0)/11.46,TEXTOIDL('v (km/s)'),TEXTOIDL('Flux normalized to peak'),'',linestyle1=0,color1='red',$ ;H0
;                                _EXTRA=extra,xlog=0,ylog=0,xrange=[-2000,2000],yrange=[-0.08,1.01],psxsize=900,psysize=400,filename='line_norm_es_2',$
;                                 x2=ZE_LAMBDA_TO_VEL(l29,4861.32), y2=(f29n -1.0)/2.776,color2='blue',linestyle2=0,double_yaxis=0,$;H+  
;                                 x3=ZE_LAMBDA_TO_VEL(l29,4340.6), y3=(f29n -1.0)/1.120,color3='brown',linestyle3=3,$ ;He +
;                                 x4=ZE_LAMBDA_TO_VEL(l29,4685.7), y4=(f29n -1.0)/0.574,color4='green',linestyle4=2,$ ;He ++
;                                 x5=ZE_LAMBDA_TO_VEL(l29,5875.66), y5=(f29n -1.0)/1.496,color5='orange',linestyle5=0,$ ;N3+  
;;                                x9=data.field01[0,*],y9=data.field01[33,*],color9=colorcarb,linestyle9=1,$ ;C4+
;;                                x10=data.field01[0,*],y10=data.field01[39,*],color_10=coloriron,linestyle_10=0,$ ;Fe5+    
;;                                x11=data.field01[0,*],y11=data.field01[41,*],color_11=coloriron,linestyle_11=1,$ ;Fe6+      
;;                                x12=data.field01[0,*],y12=data.field01[43,*],color_12=coloriron,linestyle_12=2,$ ;Fe7+                                                                                         
;                                xcharsize=1.9,ycharsize=1.9,POSITION=[0.10,0.16,0.90,0.97],pthick=10,charthick=8,xthick=8,ythick=8;,/DOUBLE_YAXIS;,$
;                                ;,/noyaxisvalues                             

;ZE_WRITE_SPECTRA_COL_VEC,'/Users/jgroh/temp/98s_27_lambda_flux.dat',l2,f2cnvl/(dist^2)*1.09024
;                                
;writecol,'/Users/jgroh/temp/98s_27_tau_den.dat',r*1e10,v,alog10(tauross),t
;
;writecol,'/Users/jgroh/temp/98s_27_lineform_es.dat',r*1e10,REFORM(data.field01[1,*]),REFORM(data.field01[3,*]),REFORM(data.field01[5,*]),REFORM(data.field01[7,*]),REFORM(data.field01[9,*]),REFORM(data.field01[11,*]),taues
;
;writecol,'/Users/jgroh/temp/98s_27_lineprofiles_norm_to_peak.dat',ZE_LAMBDA_TO_VEL(l29,6562.79), (f29n -1.0)/11.46, ZE_LAMBDA_TO_VEL(l29,4861.32), (f29n -1.0)/2.776,$
;                                                                  ZE_LAMBDA_TO_VEL(l29,4340.6), (f29n -1.0)/1.120,ZE_LAMBDA_TO_VEL(l29,4685.7), (f29n -1.0)/0.574,$
;                                                                  ZE_LAMBDA_TO_VEL(l29,5875.66), (f29n -1.0)/1.496
;
;;read if_struct.dat file with ionization structure, generated with dispgen if_* option
;order of ions: H, He, N, O, C, Fe
;ionization stages:
;
; Curve  1 is due to: HI
; Curve  3 is due to: H2
;
; Curve  5 is due to: HeI
; Curve  7 is due to: He2
; Curve  9 is due to: HeIII
;
;
; Curve  11 is due to: NIII
; Curve  13 is due to: NIV
; Curve  15 is due to: NV
; Curve  17 is due to: NSIX
;
; Curve  19 is due to: OIII
; Curve  21 is due to: OIV
; Curve  23 is due to: OV
; Curve  25 is due to: OSIX
; Curve  27 is due to: OSEV
;
;
; Curve  29 is due to: CIII
; Curve  31 is due to: CIV
; Curve  33 is due to: CV
; 
; Curve  35 is due to: FeIV
; Curve  37 is due to: FeV
; Curve  39 is due to: FeSIX
; Curve  41 is due to: FeSEV
; Curve  43 is due to: FeVIII

dataion=read_ascii('/Users/jgroh/ze_models//13dqy/78/13dqy_78_ionstruct.dat',data_START=2)
;convert r to cm
dataion.field01[0,*]=10^(dataion.field01[0,*])*1.4e14
colorhyd='black'
colorhe='blue'
colornit='green'
colorcarb='red'
coloroxy='cyan'
coloriron='orange'
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,dataion.field01[0,*],dataion.field01[1,*],TEXTOIDL('r (cm)'),'relative ionization mass fraction','',linestyle1=2,color1=colorhyd,$ ;H0
                                _EXTRA=extra,/xlog,xrange=[1.2e14,2.5e16],yrange=[-9,0.3],psxsize=900,psysize=400,filename='13dqy_78_ionstruct',$
                                x2=dataion.field01[0,*],y2=dataion.field01[3,*],color2=colorhyd,linestyle2=0,$;H+  
                                x3=dataion.field01[0,*],y3=dataion.field01[7,*],color3=colorhe,linestyle3=2,$ ;He +
                                x4=dataion.field01[0,*],y4=dataion.field01[9,*],color4=colorhe,linestyle4=0,$ ;He ++
                                x5=dataion.field01[0,*],y5=dataion.field01[15,*],color5=colornit,linestyle5=2,$ ;N4+  
                                x6=dataion.field01[0,*],y6=dataion.field01[17,*],color6=colornit,linestyle6=0,$ ;N5+
                                x7=dataion.field01[0,*],y7=dataion.field01[25,*],color7=coloroxy,linestyle7=2,$ ;O5+   
                                x8=dataion.field01[0,*],y8=dataion.field01[27,*],color8=coloroxy,linestyle8=0,$ ;O6+  
                                x9=dataion.field01[0,*],y9=dataion.field01[33,*],color9=colorcarb,linestyle9=0,$ ;C4+
                              ;  x10=dataion.field01[0,*],y10=dataion.field01[27,*],color_10=colooxy,linestyle_10=2,$ ;O6+    
                               x11=dataion.field01[0,*],y11=dataion.field01[41,*],color_11=coloriron,linestyle_11=2,$ ;Fe6+      
                                x12=dataion.field01[0,*],y12=dataion.field01[43,*],color_12=coloriron,linestyle_12=0,$ ;Fe7+                                                                                         
                                xcharsize=1.9,ycharsize=1.9,POSITION=[0.10,0.16,0.90,0.97],pthick=10,charthick=8,xthick=8,ythick=8;,/DOUBLE_YAXIS;,$
                                ;,/noyaxisvalues

dataion=read_ascii('/Users/jgroh/ze_models//13dqy/76/13dqy_76_ionstruct.dat',data_START=2)
;convert r to cm
dataion.field01[0,*]=10^(dataion.field01[0,*])*1.4e14
colorhyd='black'
colorhe='blue'
colornit='green'
colorcarb='red'
coloroxy='cyan'
coloriron='orange'
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,dataion.field01[0,*],dataion.field01[1,*],TEXTOIDL('r (cm)'),'relative ionization mass fraction','',linestyle1=2,color1=colorhyd,$ ;H0
                                _EXTRA=extra,/xlog,xrange=[1.2e14,2.5e16],yrange=[-9,0.3],psxsize=900,psysize=400,filename='13dqy_76_ionstruct',$
                                x2=dataion.field01[0,*],y2=dataion.field01[3,*],color2=colorhyd,linestyle2=0,$;H+  
                                x3=dataion.field01[0,*],y3=dataion.field01[7,*],color3=colorhe,linestyle3=2,$ ;He +
                                x4=dataion.field01[0,*],y4=dataion.field01[9,*],color4=colorhe,linestyle4=0,$ ;He ++
                                x5=dataion.field01[0,*],y5=dataion.field01[15,*],color5=colornit,linestyle5=2,$ ;N4+  
                                x6=dataion.field01[0,*],y6=dataion.field01[17,*],color6=colornit,linestyle6=0,$ ;N5+
                                x7=dataion.field01[0,*],y7=dataion.field01[25,*],color7=coloroxy,linestyle7=2,$ ;O5+   
                                x8=dataion.field01[0,*],y8=dataion.field01[27,*],color8=coloroxy,linestyle8=0,$ ;O6+  
                                x9=dataion.field01[0,*],y9=dataion.field01[33,*],color9=colorcarb,linestyle9=0,$ ;C4+
                              ;  x10=dataion.field01[0,*],y10=dataion.field01[27,*],color_10=colooxy,linestyle_10=2,$ ;O6+    
                               x11=dataion.field01[0,*],y11=dataion.field01[41,*],color_11=coloriron,linestyle_11=2,$ ;Fe6+      
                                x12=dataion.field01[0,*],y12=dataion.field01[43,*],color_12=coloriron,linestyle_12=0,$ ;Fe7+                                                                                         
                                xcharsize=1.9,ycharsize=1.9,POSITION=[0.10,0.16,0.90,0.97],pthick=10,charthick=8,xthick=8,ythick=8;,/DOUBLE_YAXIS;,$
                                ;,/noyaxisvalues

END



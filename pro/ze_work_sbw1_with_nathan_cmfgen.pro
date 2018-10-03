
;ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/papers_in_preparation_groh/sbw1_nathan/SBW1-cos.txt',lcos,fcos

;ZE_READ_SPECTRA_FITS,'/Users/jgroh/papers_in_preparation_groh/sbw1_nathan/sbw1.fits',lopt,fopt,header
;for k=0., n_elements(lopt)-1 do lopt[k]=3004.6282076164 + (k*1.0142999898088) ;I got this from the header
;
;getchelle,'/Users/jgroh/papers_in_preparation_groh/sbw1_nathan/sbw1.fits',lopt,fopt,norder=1,npix=npix,hd=hd,plot=plot
;
;line_norm,lopt,fopt,foptnorm,foptnval,foptxnodesnorm,foptnodesnorm

;ZE_READ_SPECTRA_FITS,'/Users/jgroh/papers_in_preparation_groh/sbw1_nathan/r.FEROS.2009-03-19T04:05:23.755.1081.fits',lferos1,fferos1
;line_norm,lferos1,fferos1,fferos1norm,fferos1nval,fferos1xnodesnorm,fferos1nodesnorm
;save,lferos1,fferos1,fferos1norm,fferos1nval,fferos1xnodesnorm,fferos1nodesnorm,filename='/Users/jgroh/temp/sbw1_feros1.sav'
restore,'/Users/jgroh/temp/sbw1_feros1.sav'
;set maximum value to 1.5 to cut spikes, minimum to 0
fferos1norm[where(fferos1norm gt 1.5)]=1.5
fferos1norm[where(fferos1norm lt 0)]=0.
;save, lcos, fcos, lopt,fopt,foptnorm,foptnval,foptxnodesnorm,foptnodesnorm,filename='/Users/jgroh/temp/sbw1_obs.sav'


;ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/papers_in_preparation_groh/sbw1_nathan/sbw1star.txt',lha,fha
;fhas=ZE_SHIFT_SPECTRA_VEL(lha,fha,825.0)
;save, lcos, fcos, lopt,fopt,foptnorm,foptnval,foptxnodesnorm,foptnodesnorm,lha,fha,filename='/Users/jgroh/temp/sbw1_obs.sav'

restore,'/Users/jgroh/temp/sbw1_obs.sav'


;data from IUE archive
file='/Users/jgroh/Downloads/sp02737s.txt'
readcol,file,liue,fiue,err,skip=20
liue2=liue
for k=0, 16498. do liue2[k]=0.05*k +1150.

;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/2b/obs/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/2b/obscont/obs_fin',l2,f2,lmin=1000,lmax=9000,/AIR
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/3/obs/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/3/obscont/obs_fin',l3,f3,lmin=1000,lmax=9000,/AIR
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/4/obs/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/4/obscont/obs_fin',l4,f4,lmin=1000,lmax=9000,/AIR
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/5/obs/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/5/obscont/obs_fin',l5,f5,lmin=1000,lmax=9000,/AIR
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/6/obs/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/6/obscont/obs_fin',l6,f6,lmin=1000,lmax=9000,/AIR
;
;;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/7/obs/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/7/obscont/obs_fin',l7,f7,lmin=1000,lmax=9000,/AIR
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/8/obs/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/8/obscont/obs_fin',l8,f8,lmin=1000,lmax=9000,/AIR
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/9/obs/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/9/obscont/obs_fin',l9,f9,lmin=1000,lmax=9000,/AIR
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/10/obs/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/10/obscont/obs_fin',l10,f10,lmin=1000,lmax=9000,/AIR
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/11/obs/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/11/obscont/obs_fin',l11,f11,lmin=1000,lmax=9000,/AIR
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/13/obs/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/13/obscont/obs_fin',l13,f13,lmin=1000,lmax=9000,/AIR
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/14/obs/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/14/obscont/obs_fin',l14,f14,lmin=1000,lmax=9000,/AIR
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/15/obs/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/15/obscont/obs_fin',l15,f15,lmin=1000,lmax=9000,/AIR
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/16/obs/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/16/obscont/obs_fin',l16,f16,lmin=1000,lmax=9000,/AIR
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/17/obs/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/17/obscont/obs_fin',l17,f17,lmin=1000,lmax=9000,/AIR
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/18/obs/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/18/obscont/obs_fin',l18,f18,lmin=1000,lmax=9000,/AIR
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/19/obs/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/19/obscont/obs_fin',l19,f19,lmin=1000,lmax=9000,/AIR
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/20/obs/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/20/obscont/obs_fin',l20,f20,lmin=1000,lmax=9000,/AIR
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/21/obs/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/21/obscont/obs_fin',l21,f21,lmin=1000,lmax=9000,/AIR
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/22/obs/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/22/obscont/obs_fin',l22,f22,lmin=1000,lmax=9000,/AIR
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/22/obs5/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/22/obscont/obs_fin',l22v5,f22v5,lmin=1000,lmax=9000,/AIR
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/22/obs7/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/22/obscont/obs_fin',l22v7,f22v7,lmin=1000,lmax=9000,/AIR
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/22/obs8/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/22/obscont/obs_fin',l22v8,f22v8,lmin=1000,lmax=9000,/AIR
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/22/obs9/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/22/obscont/obs_fin',l22v9,f22v9,lmin=1000,lmax=9000,/AIR
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/22/obs11/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/22/obscont/obs_fin',l22v11,f22v11,lmin=1000,lmax=9000,/AIR
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/22/obs20/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/22/obscont/obs_fin',l22v20,f22v20,lmin=1000,lmax=9000,/AIR

;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/22_ND100/obs/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/22_ND100/obscont/obs_fin',l22nd,f22nd,lmin=1000,lmax=9000,/AIR

;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/22_ND100_DEPDOP/obs/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/22_ND100_DEPDOP/obscont/obs_fin',l22nddep,f22nddep,lmin=1000,lmax=9000,/AIR
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/22_ND100_DEPDOP/obs10/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/22_ND100_DEPDOP/obscont/obs_fin',l22nddepv10,f22nddepv10,lmin=1000,lmax=9000,/AIR
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/22_ND100_DEPDOP/obs15/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/22_ND100_DEPDOP/obscont/obs_fin',l22nddepv15,f22nddepv15,lmin=1000,lmax=9000,/AIR

;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/plane_parallel/3/obs/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/plane_parallel/3/obscont/obs_cont',l3p,f3p,lmin=1000,lmax=9000,/AIR
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/plane_parallel/4/obs/obs_fin_01','/Users/jgroh/ze_models/sbw1_with_nathan/plane_parallel/4/obscont/obs_cont',l4p,f4p,lmin=1000,lmax=9000,/AIR
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/plane_parallel/5/obs/obs_fin_01','/Users/jgroh/ze_models/sbw1_with_nathan/plane_parallel/5/obscont/obs_cont',l5p,f5p,lmin=1000,lmax=9000,/AIR
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/plane_parallel/6/obs/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/plane_parallel/6/obscont/obs_cont',l6p,f6p,lmin=1000,lmax=9000,/AIR
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/plane_parallel/7/obs/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/plane_parallel/7/obscont/obs_cont',l7p,f7p,lmin=1000,lmax=9000,/AIR
;
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/sbw1_with_nathan/plane_parallel/T22000logg300/obs/obs_fin','/Users/jgroh/ze_models/sbw1_with_nathan/plane_parallel/T22000logg300/obscont/obs_fin',lt22g3p,ft22g3p,lmin=1000,lmax=9000,/AIR
;save,/all,filename='/Users/jgroh/temp/sbw1_cmfgen_all.sav'
;stop
restore,'/Users/jgroh/temp/sbw1_cmfgen_all.sav'

;reads tlusty models and produce norm spectrum; all below contained in the .sav file that is loaded after
;ZE_CMFGEN_CREATE_TLUSTY_NORM,'/Users/jgroh/tlusty/BGvispec_v10/BG20000g275v10.vis.17','/Users/jgroh/tlusty/BGvispec_v10/BG20000g275v10.vis.7',l20g275,f20g275
;ZE_CMFGEN_CREATE_TLUSTY_NORM,'/Users/jgroh/tlusty/BGvispec_v10/BG20000g275v10CN.vis.17','/Users/jgroh/tlusty/BGvispec_v10/BG20000g275v10CN.vis.7',l20g275CN,f20g275CN
;ZE_CMFGEN_CREATE_TLUSTY_NORM,'/Users/jgroh/tlusty/BGvispec_v10/BG21000g275v10.vis.17','/Users/jgroh/tlusty/BGvispec_v10/BG21000g275v10.vis.7',l21g275,f21g275
;ZE_CMFGEN_CREATE_TLUSTY_NORM,'/Users/jgroh/tlusty/BGvispec_v10/BG21000g300v10.vis.17','/Users/jgroh/tlusty/BGvispec_v10/BG21000g300v10.vis.7',l21g300,f21g300
;ZE_CMFGEN_CREATE_TLUSTY_NORM,'/Users/jgroh/tlusty/BGvispec_v10/BG21000g300v10CN.vis.17','/Users/jgroh/tlusty/BGvispec_v10/BG21000g300v10CN.vis.7',l21g300CN,f21g300CN
;ZE_CMFGEN_CREATE_TLUSTY_NORM,'/Users/jgroh/tlusty/BGvispec_v10/BG22000g300v10.vis.17','/Users/jgroh/tlusty/BGvispec_v10/BG22000g300v10.vis.7',l22g300,f22g300
;ZE_CMFGEN_CREATE_TLUSTY_NORM,'/Users/jgroh/tlusty/BGvispec_v10/BG23000g300v10.vis.17','/Users/jgroh/tlusty/BGvispec_v10/BG23000g300v10.vis.7',l23g300,f23g300
;ZE_CMFGEN_CREATE_TLUSTY_NORM,'/Users/jgroh/tlusty/BGvispec_v2/BG21000g300v2.vis.17','/Users/jgroh/tlusty/BGvispec_v2/BG21000g300v2.vis.7',l21g300v2,f21g300v2
;ZE_CMFGEN_CREATE_TLUSTY_NORM,'/Users/jgroh/tlusty/BGvispec_v2/BG22000g300v2.vis.17','/Users/jgroh/tlusty/BGvispec_v2/BG22000g300v2.vis.7',l22g300v2,f22g300v2
;ZE_CMFGEN_CREATE_TLUSTY_NORM,'/Users/jgroh/tlusty/BGvispec_v2/BG22000g325v2.vis.17','/Users/jgroh/tlusty/BGvispec_v2/BG22000g325v2.vis.7',l22g325v2,f22g325v2
;ZE_CMFGEN_CREATE_TLUSTY_NORM,'/Users/jgroh/tlusty/BGvispec_v2/BG22000g350v2.vis.17','/Users/jgroh/tlusty/BGvispec_v2/BG22000g350v2.vis.7',l22g350v2,f22g350v2

;save,/all,filename='/Users/jgroh/temp/sbw1_tlusty_opt_all.sav'
;STOP
restore,'/Users/jgroh/temp/sbw1_tlusty_opt_all.sav'

;read this if we want the non-normalized spectrum for e.g. UV
;readcol,'/Users/jgroh/tlusty/BGvispec_v10/BG21000g275v10.vis.7',l21g275,f21g275
;readcol,'/Users/jgroh/tlusty/BGvispec_v10/BG21000g250v10.vis.7',l21g250,f21g250


f15cnvluv=ZE_SPEC_CNVL_VEL(l15,f15,60.5) ;for UV COS
f18cnvluv=ZE_SPEC_CNVL_VEL(l18,f18,60.5) ;for UV COS
;f18bcnvluv=ZE_SPEC_CNVL_VEL(l18b,f18b,60.5) ;for UV COS
f21cnvluv=ZE_SPEC_CNVL_VEL(l21,f21,60.5) ;for UV COS


;line_norm,l2,f2,f2n,fobsnval,fobsxnodesnorm,fobsynodesnorm
ZE_SPEC_CNVL,l5,f5,2.0,4500.0,fluxcnvl=f5cnvl2
vconv=153.0
f2cnvl=ZE_SPEC_CNVL_VEL(l2,f2,vconv)
f3cnvl=ZE_SPEC_CNVL_VEL(l3,f3,vconv)
f4cnvl=ZE_SPEC_CNVL_VEL(l4,f4,vconv)
f5cnvl=ZE_SPEC_CNVL_VEL(l5,f5,vconv)
f6cnvl=ZE_SPEC_CNVL_VEL(l6,f6,vconv)
;f7cnvl=ZE_SPEC_CNVL_VEL(l7,f7,vconv)
f9cnvl=ZE_SPEC_CNVL_VEL(l9,f9,vconv)
f10cnvl=ZE_SPEC_CNVL_VEL(l10,f10,vconv)
f13cnvl=ZE_SPEC_CNVL_VEL(l13,f13,vconv)
f14cnvl=ZE_SPEC_CNVL_VEL(l14,f14,vconv)
f15cnvl=ZE_SPEC_CNVL_VEL(l15,f15,vconv)
f16cnvl=ZE_SPEC_CNVL_VEL(l16,f16,vconv)
f17cnvl=ZE_SPEC_CNVL_VEL(l17,f17,vconv)
f18cnvl=ZE_SPEC_CNVL_VEL(l18,f18,vconv)
f19cnvl=ZE_SPEC_CNVL_VEL(l19,f19,vconv)
f20cnvl=ZE_SPEC_CNVL_VEL(l20,f20,vconv)
f21cnvl=ZE_SPEC_CNVL_VEL(l21,f21,vconv)

;for plane parallel model
f4pcnvl=ZE_SPEC_CNVL_VEL(l4p,f4p,vconv)
f5pcnvl=ZE_SPEC_CNVL_VEL(l5p,f5p,vconv)
f6pcnvl=ZE_SPEC_CNVL_VEL(l6p,f6p,vconv)


f21g275cnvl=ZE_SPEC_CNVL_VEL(l21g275,f21g275,vconv)
;f20g275cnvl=ZE_SPEC_CNVL_VEL(l20g275,f20g275,vconv)
;f20g275CNcnvl=ZE_SPEC_CNVL_VEL(l20g275CN,f20g275CN,vconv)
;linterp,l5,f5cnvl,lopt,f5cnvlo

f5cnvluv=ZE_SPEC_CNVL_VEL(l5,f5,60.5) ;for UV COS
f2cnvluv=ZE_SPEC_CNVL_VEL(l2,f2,60.5) ;for UV COS
f6cnvluv=ZE_SPEC_CNVL_VEL(l6,f6,60.5) ;for UV COS
;f7cnvluv=ZE_SPEC_CNVL_VEL(l7,f7,60.5) ;for UV COS

f4pcnvluv=ZE_SPEC_CNVL_VEL(l4p,f4p,60.5) ;for UV COS
f5pcnvluv=ZE_SPEC_CNVL_VEL(l5p,f5p,60.5) ;for UV COS
f6pcnvluv=ZE_SPEC_CNVL_VEL(l6p,f6p,60.5) ;for UV COS

v=-150.
v=-78.98
;foptv=ZE_SHIFT_SPECTRA_VEL(lopt,foptnorm,v)
foptv=ZE_SHIFT_SPECTRA_VEL(lopt,fopt,v)

f21g275cnvlv=ZE_SHIFT_SPECTRA_VEL(l21g275,f21g275cnvl,v)

fm_unred, l3,f3cnvl, -0.85, f3cnvld, R_V=3.1

;low resolution blue spectrum from nathan's paper ; used in v1 of the paper submitted to MNRAS
;lineplot,lopt,foptv
;lineplot,l5,f5cnvl
;lineplot,l20,f20cnvl
;lineplot,l19,f19cnvl

;high resolution feros spectrum -- interactive plotting with ze_lineplot
vrot=60.5
vshift=-74.
ze_lineplot,lferos1,fferos1norm,xrange=[4000,5000], yrange=[0,1.2]
;ze_lineplot,l7p,ZE_SHIFT_SPECTRA_VEL(l7p,ZE_SPEC_CNVL_VEL(l7p,f7p,vrot),vshift)
;ze_lineplot,l22g300,ZE_SHIFT_SPECTRA_VEL(l22g300,ZE_SPEC_CNVL_VEL(l22g300,f22g300,vrot),vshift)
ze_lineplot,l22v9,ZE_SHIFT_SPECTRA_VEL(l22v9,ZE_SPEC_CNVL_VEL(l22v9,f22v9,vrot),vshift)
ze_lineplot,l22nddepv15,ZE_SHIFT_SPECTRA_VEL(l22nddepv15,ZE_SPEC_CNVL_VEL(l22nddepv15,f22nddepv15,vrot),vshift)
ze_lineplot,l22nddepv10,ZE_SHIFT_SPECTRA_VEL(l22nddepv10,ZE_SPEC_CNVL_VEL(l22nddepv10,f22nddepv10,vrot),vshift)
;ze_lineplot,l22nd,ZE_SHIFT_SPECTRA_VEL(l22nd,ZE_SPEC_CNVL_VEL(l22nd,f22nd,5),vshift)

;;high resolution feros spectrum -- interactive plotting with plot
;vrot=60.5
;vshift=-74.
;p = PLOT(lferos1, fferos1norm, Xtitle = 'Wavelength ($\AA$)',YTITLE='Normalized Flux', TITLE="", $
;    xrange=[4000,5000],yrange=[0.57,1.13], DIM=[600,400], MARGIN=0.12)
;p2 = PLOT(l22g300,ZE_SHIFT_SPECTRA_VEL(l22g300,ZE_SPEC_CNVL_VEL(l22g300,f22g300,vrot),vshift),'r',/OVERPLOT)
;p2 = PLOT(l21g300,ZE_SHIFT_SPECTRA_VEL(l21g300,ZE_SPEC_CNVL_VEL(l21g300,f21g300,vrot),vshift),'b-',/OVERPLOT)
;p2 = PLOT(l22v9,ZE_SHIFT_SPECTRA_VEL(l22v9,ZE_SPEC_CNVL_VEL(l22v9,f22v9,vrot),vshift),'g',/OVERPLOT)
;;p.Save, "/Users/jgroh/temp/sbw1_diagnostic_microturbulence.pdf",PAGE_SIZE=[6,6*400/600.]
;

;diagnostic plots
;1) microturbulence -- Si III lines CMFGEN various vturb
plot_microturb = PLOT(lferos1, fferos1norm, Xtitle = 'Wavelength ($\AA$)',YTITLE='Normalized Flux', TITLE="Diagnostic Microturbulence Si III", $
    xrange=[4541,4584],yrange=[0.57,1.13], DIM=[600,400], MARGIN=0.12)
;plot_microturb2 = PLOT(l22g300,ZE_SHIFT_SPECTRA_VEL(l22g300,ZE_SPEC_CNVL_VEL(l22g300,f22g300,vrot),vshift),'r',/OVERPLOT)
;plot_microturb3 = PLOT(l21g300,ZE_SHIFT_SPECTRA_VEL(l21g300,ZE_SPEC_CNVL_VEL(l21g300,f21g300,vrot),vshift),'b-',/OVERPLOT)
plot_microturb3 = PLOT(l22v5,ZE_SHIFT_SPECTRA_VEL(l22v5,ZE_SPEC_CNVL_VEL(l22v5,f22v5,vrot),vshift),'r',/OVERPLOT)
plot_microturb3 = PLOT(l22v9,ZE_SHIFT_SPECTRA_VEL(l22v9,ZE_SPEC_CNVL_VEL(l22v9,f22v9,vrot),vshift),color='deep sky blue',/OVERPLOT)
plot_microturb3 = PLOT(l22v20,ZE_SHIFT_SPECTRA_VEL(l22v20,ZE_SPEC_CNVL_VEL(l22v20,f22v20,vrot),vshift),color='orange',/OVERPLOT)
plot_microturb.Save, "/Users/jgroh/temp/sbw1_diagnostic_microturbulence.png",PAGE_SIZE=[6,6*400/600.]


;1) microturbulence -- Si III lines TLUSTY v10 and v2 turb
plot_microturb = PLOT(lferos1, fferos1norm, Xtitle = 'Wavelength ($\AA$)',YTITLE='Normalized Flux', TITLE="Diagnostic Microturbulence Si III", $
  xrange=[4541,4584],yrange=[0.57,1.13], DIM=[600,400], MARGIN=0.12)
plot_microturb2 = PLOT(l21g300,ZE_SHIFT_SPECTRA_VEL(l21g300,ZE_SPEC_CNVL_VEL(l21g300,f21g300,vrot),vshift),'r',/OVERPLOT)
plot_microturb2=plot(l21g300v2,ZE_SHIFT_SPECTRA_VEL(l21g300v2,ZE_SPEC_CNVL_VEL(l21g300v2,f21g300v2,vrot),vshift),color='deep sky blue',/OVERPLOT )
plot_microturb2 = PLOT(l7p,ZE_SHIFT_SPECTRA_VEL(l7p,ZE_SPEC_CNVL_VEL(l7p,f7p,vrot),vshift),color='orange',/OVERPLOT)
plot_microturb.Save, "/Users/jgroh/temp/sbw1_diagnostic_microturbulence2.png",PAGE_SIZE=[6,6*400/600.]


;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,lopt,foptv,'Wavelength (Angstrom)', 'Flux [erg/s/cm^2/A]','',$
;                          x2=l6,y2=f6cnvl,linestyle2=0,$
;                        ;  x3=l2,y3=f2cnvl/(dist^2)*scale2,linestyle3=2,$
;                     ;     x4=l3,y4=f3cnvl/(dist^2)*scale3,linestyle4=3,color4='orange',$
;;                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
;;                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
;;                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
;;                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
;;                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
;;                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
;                          pthick=6,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=800,bb=500,$
;                          xrange=[3800,4200],yrange=[0.6,1.1],POSITION=[0.14,0.10,0.98,0.98],filename='sbw1_optical_1';,/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.05,id_ypos=10.5,size_id_text=1.0,elem=elem
;
;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,lopt,foptv,'Wavelength (Angstrom)', 'Flux [erg/s/cm^2/A]','',$
;                          x2=l6,y2=f6cnvl,linestyle2=0,$
;                        ;  x3=l2,y3=f2cnvl/(dist^2)*scale2,linestyle3=2,$
;                     ;     x4=l3,y4=f3cnvl/(dist^2)*scale3,linestyle4=3,color4='orange',$
;;                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
;;                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
;;                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
;;                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
;;                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
;;                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
;                          pthick=6,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=800,bb=500,$
;                          xrange=[4200,4600],yrange=[0.6,1.1],POSITION=[0.14,0.10,0.98,0.98],filename='sbw1_optical_2';,/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.05,id_ypos=10.5,size_id_text=1.0,elem=elem
;
;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,lopt,foptv,'Wavelength (Angstrom)', 'Flux [erg/s/cm^2/A]','',$
;                          x2=l6,y2=f6cnvl,linestyle2=0,$
;                        ;  x3=l2,y3=f2cnvl/(dist^2)*scale2,linestyle3=2,$
;                     ;     x4=l3,y4=f3cnvl/(dist^2)*scale3,linestyle4=3,color4='orange',$
;;                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
;;                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
;;                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
;;                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
;;                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
;;                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
;                          pthick=6,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=800,bb=500,$
;                          xrange=[4600,5000],yrange=[0.6,1.1],POSITION=[0.14,0.10,0.98,0.98],filename='sbw1_optical_3';,/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.05,id_ypos=10.5,size_id_text=1.0,elem=elem
;
;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,lopt,foptv,'Wavelength (Angstrom)', 'Flux [erg/s/cm^2/A]','',$
;                          x2=l6,y2=f6cnvl,linestyle2=0,$
;                        ;  x3=l2,y3=f2cnvl/(dist^2)*scale2,linestyle3=2,$
;                     ;     x4=l3,y4=f3cnvl/(dist^2)*scale3,linestyle4=3,color4='orange',$
;;                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
;;                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
;;                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
;;                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
;;                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
;;                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
;                          pthick=6,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=800,bb=500,$
;                          xrange=[5000,6000],yrange=[0.6,1.1],POSITION=[0.14,0.10,0.98,0.98],filename='sbw1_optical_4';,/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.05,id_ypos=10.5,size_id_text=1.0,elem=elem
;
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,lopt,foptv,'Wavelength (Angstrom)', TEXTOIDL('Flux (erg/s/cm^2/A)'),'',$
                          x2=l20,y2=f20cnvl,linestyle2=0,$
                        ;  x3=l2,y3=f2cnvl/(dist^2)*scale2,linestyle3=2,$
                     ;     x4=l3,y4=f3cnvl/(dist^2)*scale3,linestyle4=3,color4='orange',$
;                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
;                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
;                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
;                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
;                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
;                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
                          pthick=6,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=800,bb=400,$
                          xrange=[3720,4700],yrange=[0.0,1.2],POSITION=[0.08,0.10,0.98,0.98],filename='sbw1_optical_full';,/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.05,id_ypos=10.5,size_id_text=1.0,elem=elem

ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,lcos,fcos,'Wavelength (Angstrom)', TEXTOIDL('Flux (erg/s/cm^2/A)'),'',$
                          x2=l6,y2=f6cnvluv*0.9*1e-14,linestyle2=0,$
                        ;  x3=l2,y3=f2cnvl/(dist^2)*scale2,linestyle3=2,$
                     ;     x4=l3,y4=f3cnvl/(dist^2)*scale3,linestyle4=3,color4='orange',$
;                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
;                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
;                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
;                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
;                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
;                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
                          pthick=6,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=1200,bb=400,$
                          xrange=[1370,1430],yrange=[0.0,1.5e-14],POSITION=[0.08,0.10,0.98,0.98],filename='sbw1_uv1';,/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.05,id_ypos=10.5,size_id_text=1.0,elem=elem

ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,lcos,fcos,'Wavelength (Angstrom)', TEXTOIDL('Flux (erg/s/cm^2/A)'),'',$
                          x2=l6,y2=f6cnvluv*0.992*1e-14,linestyle2=0,$
                        ;  x3=l2,y3=f2cnvl/(dist^2)*scale2,linestyle3=2,$
                     ;     x4=l3,y4=f3cnvl/(dist^2)*scale3,linestyle4=3,color4='orange',$
;                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
;                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
;                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
;                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
;                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
;                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
                          pthick=6,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=1200,bb=400,$
                          xrange=[1430,1530],yrange=[0.0,1.35e-14],POSITION=[0.08,0.10,0.98,0.98],filename='sbw1_uv2';,/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.05,id_ypos=10.5,size_id_text=1.0,elem=elem

ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,lcos,fcos,'Wavelength (Angstrom)', TEXTOIDL('Flux (erg/s/cm^2/A)'),'',$
                          x2=l6,y2=f6cnvluv*1.0*1e-14,linestyle2=0,$
                        ;  x3=l2,y3=f2cnvl/(dist^2)*scale2,linestyle3=2,$
                     ;     x4=l3,y4=f3cnvl/(dist^2)*scale3,linestyle4=3,color4='orange',$
;                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
;                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
;                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
;                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
;                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
;                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
                          pthick=6,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=1200,bb=400,$
                          xrange=[1522,1620],yrange=[0.0,1.65e-14],POSITION=[0.08,0.10,0.98,0.98],filename='sbw1_uv3';,/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.05,id_ypos=10.5,size_id_text=1.0,elem=elem


ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,lcos,fcos,'Wavelength (Angstrom)', TEXTOIDL('Flux (erg/s/cm^2/A)'),'',$
                          x2=l6,y2=f6cnvluv*1.277*1e-14,linestyle2=0,$
                        ;  x3=l2,y3=f2cnvl/(dist^2)*scale2,linestyle3=2,$
                     ;     x4=l3,y4=f3cnvl/(dist^2)*scale3,linestyle4=3,color4='orange',$
;                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
;                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
;                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
;                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
;                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
;                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
                          pthick=6,xthick=7,ythick=7,pcharthick=8,pcharsize=2.4,aa=1200,bb=500,$
                          xrange=[1620,1753],yrange=[0.0,1.85e-14],POSITION=[0.14,0.10,0.98,0.98],filename='sbw1_uv4';,/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.05,id_ypos=10.5,size_id_text=1.0,elem=elem


;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,lcos,fcos,'Wavelength (Angstrom)', 'Flux [erg/s/cm^2/A]','',$
;                          x2=l6,y2=f6cnvluv*1.137*1e-14,linestyle2=0,$
;                        ;  x3=l2,y3=f2cnvl/(dist^2)*scale2,linestyle3=2,$
;                     ;     x4=l3,y4=f3cnvl/(dist^2)*scale3,linestyle4=3,color4='orange',$
;;                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
;;                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
;;                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
;;                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
;;                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
;;                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
;                          pthick=6,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=800,bb=500,$
;                          xrange=[1672,1776],yrange=[0.0,2e-14],POSITION=[0.14,0.10,0.98,0.98],filename='sbw1_uv5';,/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.05,id_ypos=10.5,size_id_text=1.0,elem=elem
;
;
;
;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,lcos,fcos,'Wavelength (Angstrom)', 'Flux [erg/s/cm^2/A]','',$
;                          x2=l6,y2=f6cnvluv*1.137*1e-14,linestyle2=0,$
;                        ;  x3=l2,y3=f2cnvl/(dist^2)*scale2,linestyle3=2,$
;                     ;     x4=l3,y4=f3cnvl/(dist^2)*scale3,linestyle4=3,color4='orange',$
;;                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
;;                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
;;                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
;;                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
;;                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
;;                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
;                          pthick=6,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=800,bb=500,$
;                          xrange=[1672,1776],yrange=[0.0,2e-14],POSITION=[0.14,0.10,0.98,0.98],filename='sbw1_uv5';,/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.05,id_ypos=10.5,size_id_text=1.0,elem=elem
;
;
;
;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,lcos,fcos,'Wavelength (Angstrom)', 'Flux [erg/s/cm^2/A]','',/ylog,$
;                          x2=liue2,y2=liue*1.07*1e-3,linestyle2=0,$
;                        ;  x3=l2,y3=f2cnvl/(dist^2)*scale2,linestyle3=2,$
;                     ;     x4=l3,y4=f3cnvl/(dist^2)*scale3,linestyle4=3,color4='orange',$
;;                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
;;                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
;;                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
;;                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
;;                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
;;                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
;                          pthick=6,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=1000,bb=500,$
;                          xrange=[1382,1556],yrange=[1e-16,4e-14],POSITION=[0.14,0.10,0.98,0.98],filename='sbw1_hd13854_uv_comparison';,/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.05,id_ypos=10.5,size_id_text=1.0,elem=elem
;
;
;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,l2,f2,'Wavelength (Angstrom)', 'Flux [erg/s/cm^2/A]','',$
;                          x2=l3,y2=f3,linestyle2=0,$
;                          x3=l5,y3=f5,linestyle3=2,$
;                          x4=l6,y4=f6,linestyle4=3,color4='orange',$
;;                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
;;                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
;;                          x7=all_lambd1672a[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
;;                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
;;                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
;;                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
;                          pthick=6,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=800,bb=500,$
;                          xrange=[6555,6572],yrange=[0.0,1.5],POSITION=[0.14,0.10,0.98,0.98],filename='sbw1_halpha_mdot';,/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.05,id_ypos=10.5,size_id_text=1.0,elem=elem

;for extinction and luminosity calculation
;THIS PROD
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/sbw1_with_nathan/20/obs/obs_fin',l20non,f20non,lmin=50,lmax=500000,/FLAM;,/AIR,/FLAM

;lineplot,l7non,f7non_red*1e-23*(299792000./l7non*1D-05)/dist^2 ;term in parenthesis is obs_freq

;works for V, R, and COS UV
ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,'/Users/jgroh/ze_models/sbw1_with_nathan/','20','V',Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt,dist=7.0,ebv=-0.91,RV=3.1,norm_factor=0.25
ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,'/Users/jgroh/ze_models/sbw1_with_nathan/','20','R',Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt,dist=7.0,ebv=-0.91,RV=3.1,norm_factor=0.25
ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,'/Users/jgroh/ze_models/sbw1_with_nathan/','20','J',Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt,dist=7.0,ebv=-0.91,RV=3.1,norm_factor=0.25
ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,'/Users/jgroh/ze_models/sbw1_with_nathan/','20','H',Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt,dist=7.0,ebv=-0.91,RV=3.1,norm_factor=0.25
ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,'/Users/jgroh/ze_models/sbw1_with_nathan/','20','Ks',Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt,dist=7.0,ebv=-0.91,RV=3.1,norm_factor=0.25
fm_unred, l20non,f20non, -0.91, f20non_red, R_V=3.1
dist=7.0 ;kpc
;lineplot,l20non,f20non_red*0.25/dist^2 ;luminosty factor 0.25 for model 20 , i.e. L=2.5e4 Lsun

;works only for V,R

END
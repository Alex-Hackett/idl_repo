;PRO ZE_WORK_LBV_SPECTRAL_CLASSIFICATION_WITH_SIMON_CLARK
dir='/Users/jgroh/espectros/OBZoo_WF2000/'
ZE_READ_SPECTRA_FITS,dir+'HD87643.fits',l87,f87
ZE_READ_SPECTRA_FITS,dir+'HD93308.fits',letc,fetc
ZE_READ_SPECTRA_FITS,dir+'HD316285.fits',l316,f316
;ZE_READ_SPECTRA_FITS,dir+'HD94910.fits',lagc,fagc
ZE_READ_SPECTRA_FITS,'/Users/jgroh/espectros/pcygni/elodie_20010907_0026.fits',lpcyg,fpcyg
ZE_READ_SPECTRA_FITS,dir+'HD94910.fits',lagc,fagc

fpcygcnvl=ZE_SPEC_CNVL_VEL(lpcyg,fpcyg,100.0)
;line_norm,lpcyg,fpcygcnvl,fpcygcnvln,normfpcygcnvl,xnodesfpcygcnvl,ynodesfpcygcnvl
;save,lpcyg,fpcygcnvl,fpcygcnvln,normfpcygcnvl,xnodesfpcygcnvl,ynodesfpcygcnvl,filename='/Users/jgroh/temp/pcygni_elodie_20010907_0026.sav'
restore,'/Users/jgroh/temp/pcygni_elodie_20010907_0026.sav'
restore,'/Users/jgroh/espectros/etacar/etc_hst_stis_17apr01_1700_10400_norm.sav'

;all WF2000 data but P Cygni (ELODIE Archive 2001)
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,l87,f87,'Wavelength (Angstrom)', 'Normalized Flux','',$
                          x2=letc,y2=fetc+1.0,linestyle2=0,xtitle='',ytitle='',$
                          x3=l316,y3=f316+3.0,linestyle3=0,$
                          x4=lpcyg,y4=fpcygcnvln+5.0,linestyle4=0,$
                          x5=lagc,y5=fagc+6.0,linestyle5=0,$
                          ;x3=all_lambdaf0d1[i,0:all_nlambda_readf0d1[i]-1],y3=all_fluxnormf0d1[i,0:all_nlambda_readf0d1[i]-1],linestyle3=2,$                       
                          pcharsize=2.0,pthick=5.0,xrange=[4430,4749.99],yrange=[0,9],position=[0.14,0.13,0.96,0.99],filename='lbv_class_optical',/rebin,factor1=1.0,aa=1000,bb=1000;,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.4,id_ypos=22.0

;etc from STIS data, convolved to lower res
FLUX_17apr01ncnvl=ZE_SPEC_CNVL_VEL(LAMBDA_17apr01,FLUX_17apr01n,100.0)
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,l87,f87,'Wavelength (Angstrom)', 'Normalized Flux','',$
                          x2=LAMBDA_17apr01,y2=FLUX_17apr01ncnvl+1.0,linestyle2=0,xtitle='',ytitle='',$
                          x3=l316,y3=f316+3.0,linestyle3=0,$
                          x4=lpcyg,y4=fpcygcnvln+5.0,linestyle4=0,$
                          x5=lagc,y5=fagc+6.0,linestyle5=0,$
                          ;x3=all_lambdaf0d1[i,0:all_nlambda_readf0d1[i]-1],y3=all_fluxnormf0d1[i,0:all_nlambda_readf0d1[i]-1],linestyle3=2,$                       
                          pcharsize=2.0,pthick=5.0,xrange=[4430,4749.99],yrange=[0,9],position=[0.14,0.13,0.96,0.99],filename='lbv_class_optical_2',/rebin,factor1=1.0,aa=1000,bb=1000;,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.4,id_ypos=22.0

;AG Car high res data from stahl+01
dir='/Users/jgroh/espectros/agcar_stahl/'
ZE_READ_SPECTRA_FITS,dir+'caspec/rjan89.fits',l89,f89,header89 ; jan 89; WN11h
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/temp/agcar_feros_2002mar17.dat',l02mar,f02mar ;WN12h
ZE_READ_SPECTRA_FITS,dir+'ls93/f0024.fits',l93a,f93a,header93a ; 29/01/1993, 49016 ;WN13h


;ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/espectros/agcar/agc02jul04_45a53n.txt',l02jul,f02jul
;ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/temp/agcar_uves_2003jan11.dat',l03jan,f03jan

;ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/temp/agcar_feros_2001apr12.dat',l01apr,f01apr

ZE_READ_SPECTRA_FITS,dir+'caspec/rdec91.fits',l91,f91,header91 ; jan 91; WN12h
ZE_READ_SPECTRA_FITS,dir+'caspec/rdec93.fits',l93b,f93b,header93b ; dec 93; 49342
ZE_READ_SPECTRA_FITS,dir+'ls92/f0368.fits',l92,f92,header92 ; 19/07/1992, 48822;
ZE_READ_SPECTRA_FITS,dir+'ls93/f0024.fits',l93a,f93a,header93a ; 29/01/1993, 49016
;ZE_READ_SPECTRA_FITS,dir+'feros/f1011.fits',l93a,f93a,header93a ; 29/01/1993, 49016
f93bc=ZE_SPEC_CNVL_VEL(l93b,f93b,100.0)

END
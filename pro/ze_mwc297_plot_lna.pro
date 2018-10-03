;PRO ZE_MWC297_PLOT_LNA
LOADCT,13, /SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
dir='/Users/jgroh/data/lna/camiv_spectra/09abr21/'
;restore,dir+'hrcar/hrcar_norm_val.sav'
;dir='/Users/jgroh/espectros/'
;ZE_READ_SPECTRA_COL_VEC,dir+'/agcar/427_optn.txt',l431,f431,nrec431
ZE_READ_SPECTRA_FITS,dir+'mwc297_204_m_hel.fits',lmwc,fmwc,headermwc,nrecmwc
line_norm,lmwc,fmwc,fmwcn,normmwc,xnodesmwc,ynodesmwc
save,/variables,filename=dir+'mwc_norm.sav'
END
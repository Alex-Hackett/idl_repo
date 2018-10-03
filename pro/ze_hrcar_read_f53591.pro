;PRO ZE_HRCAR_READ_F53591
LOADCT,13, /SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
dir='/Users/jgroh/espectros/hrcar/'
file='f53591.fits'
!P.THICk=1
ZE_READ_SPECTRA_FITS,dir+file,lb,fb,headerb,nrecb
ZE_READ_SPECTRA_FITS,dir+'f53571.fits',lhrc,fhrc,headerhrc,nrechrc
restore,dir+'hrcar_norm_val.sav'
line_norm,lb,fb,fbn,norm,xnodes,ynodes

ZE_SPEC_CNVL,lb,fb,4,4000.,fluxcnvl=fbcnvl
help,xnodes,ynodes,lb
ynodesi=cspline(xnodes,ynodes,lb)

fbcnvli=cspline(lb,fbcnvl,xnodes)
line_norm,lb,fb,fbnfim,normfim,xnodes,fbcnvli

;fhrc=fhrc/normfim
ZE_SPEC_CNVL,lhrc,fhrc,0.3,4000.,fluxcnvl=fhrccnvl

line_norm,lhrc,fhrccnvl,fhrccnvln,normhrc,xnodeshrc,ynodeshrc
fhrcn=fhrc/normhrc
save,/variables,filename=dir+'hrcar_norm_val.sav'
END
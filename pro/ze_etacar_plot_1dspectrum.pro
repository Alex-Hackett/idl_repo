Angstrom = '!6!sA!r!u!9 %!6!n'
model='/Users/jgroh/etacar_john_mod111_obs.txt'
ZE_READ_SPECTRA_COL_VEC,model,lm,fm,nrecm

modelc='/Users/jgroh/eta_companion_r5_obs.txt'
ZE_READ_SPECTRA_COL_VEC,modelc,lc,fc,nrecc

tmine=MIN(ABS(lm-10750.),minle)
tmaxe=MIN(ABS(lm-10873.3),maxle)

lmcut=lm[minle:maxle]
fmcut=fm[minle:maxle]

tminc=MIN(ABS(lc-10750.),minlc)
tmaxc=MIN(ABS(lc-10873.3),maxlc)

lccut=lc[minlc:maxlc]
fccut=fc[minlc:maxlc]

tminc2=MIN(ABS(lccut-10761.),minlc2)
tmaxc2=MIN(ABS(lccut-10833.3),maxlc2)

;lccut2=lccut[minlc2:maxlc2]
;fccut2=fccut[minlc2:maxlc2]

fccut[minlc2:maxlc2]=0.001

fccuti=CSPLINE(lccut,fccut,lmcut)
fccuti(WHERE(fccuti lt 0.))=0.001

etaaplusb=fmcut+fccuti
etaaplusb_conta=fccuti+6080.

window,1,XSIZE=900,YSIZE=400
xmin=10780
xmax=10890
ymin=0.
ymax=25.
lambda0=21661.
plot,lm,fm,xstyle=1,ystyle=1,xrange=[xmin,xmax],yrange=[ymin,ymax],/NODATA,xtitle='Wavelength [ '+Angstrom+' ]',ytitle='F/F!Ic',$
XTICKFORMAT='(I7.0)'
plots,lm,fm,color=fsc_color('red'),noclip=0,clip=[xmin,ymin,xmax,ymax]

window,2,XSIZE=900,YSIZE=400
xmin=20530
xmax=20730
ymin=0.
ymax=6.
lambda0=21661.
plot,lm,fm,xstyle=1,ystyle=1,xrange=[xmin,xmax],yrange=[ymin,ymax],/NODATA,xtitle='Wavelength [ '+Angstrom+' ]',ytitle='F/F!Ic',$
XTICKFORMAT='(I7.0)'
plots,lm,fm,color=fsc_color('red'),noclip=0,clip=[xmin,ymin,xmax,ymax]



window,3,XSIZE=900,YSIZE=400
xmin=21580
xmax=21730
ymin=0.
ymax=6.
lambda0=21661.
plot,lm,fm,xstyle=1,ystyle=1,xrange=[xmin,xmax],yrange=[ymin,ymax],/NODATA,xtitle='Wavelength [ '+Angstrom+' ]',ytitle='F/F!Ic',$
XTICKFORMAT='(I7.0)'
plots,lm,fm,color=fsc_color('red'),noclip=0,clip=[xmin,ymin,xmax,ymax]



;plot,ZE_LAMBDA_TO_VEL(lm,lambda0),fm,xstyle=1,ystyle=1,xrange=[-800,500], /NODATA
;plots,ZE_LAMBDA_TO_VEL(lm,lambda0),fm,color=fsc_color('red')

!P.Background = fsc_color('white')

END

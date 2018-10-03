Angstrom = '!6!sA!r!u!9 %!6!n'
model='/Users/jgroh/etacar_john_mod111_obs.txt'
;ZE_READ_SPECTRA_COL_VEC,model,lm,fm,nrecm

modelc='/Users/jgroh/eta_companion_r5_obs.txt'
;ZE_READ_SPECTRA_COL_VEC,modelc,lc,fc,nrecc


lmin=4000.
lmax=5000.
tmine=MIN(ABS(lm-lmin),minle)
tmaxe=MIN(ABS(lm-lmax),maxle)

lmcut=lm[minle:maxle]
fmcut=fm[minle:maxle]

tminc=MIN(ABS(lc-lmin),minlc)
tmaxc=MIN(ABS(lc-lmax),maxlc)

lccut=lc[minlc:maxlc]
fccut=fc[minlc:maxlc]

fccuti=CSPLINE(lccut,fccut,lmcut)

etaaplusb=fmcut+fccuti

;escape speed of companion
mass=60.
rstar=40
vcrit1=SQRT(0.666666*0.0000000667*mass*1.989E+33/(rstar*6.96*10000000000.))/100000. ;ignoring departures from spherical symmetry (MM2000,A&A361,159)

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

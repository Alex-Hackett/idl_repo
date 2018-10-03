Angstrom = '!6!sA!r!u!9 %!6!n'
dir='/aux/pc244a/jgroh/data/eso_vlt/crires/Etacar/381D-0262A_C01/310720/sci_proc/'
file509=dir+'CR_SEXT_310720_2008-05-04T23:38:54.126_DIT1_2070.4nm.fits'
file511=dir+'CR_SEXT_310720_2008-05-04T23:51:56.388_DIT1_2076.6nm.fits'

dir='/aux/pc244a/jgroh/data/eso_vlt/crires/Etacar/381D-0262A_C01/310719/cal_proc/'
cal2070=dir+'CR_PEXT_080504A_DIT30_2070.4nm.fits'
cal2076=dir+'CR_PEXT_080504A_DIT30_2076.6nm.fits'

;ftab_help,file509
ftab_ext,file509,'Wavelength_model,Extracted_OPT',w1a,f1a,EXTEN_NO=1
ftab_ext,file509,'Wavelength_model,Extracted_OPT',w2a,f2a,EXTEN_NO=2
ftab_ext,file509,'Wavelength_model,Extracted_OPT',w3a,f3a,EXTEN_NO=3
ftab_ext,file509,'Wavelength_model,Extracted_OPT',w4a,f4a,EXTEN_NO=4

ftab_ext,file511,'Wavelength_model,Extracted_OPT',w1b,f1b,EXTEN_NO=1
ftab_ext,file511,'Wavelength_model,Extracted_OPT',w2b,f2b,EXTEN_NO=2
ftab_ext,file511,'Wavelength_model,Extracted_OPT',w3b,f3b,EXTEN_NO=3
ftab_ext,file511,'Wavelength_model,Extracted_OPT',w4b,f4b,EXTEN_NO=4

ftab_ext,cal2070,'Wavelength_model,Extracted_OPT',w1ca,f1ca,EXTEN_NO=1
ftab_ext,cal2070,'Wavelength_model,Extracted_OPT',w2ca,f2ca,EXTEN_NO=2
ftab_ext,cal2070,'Wavelength_model,Extracted_OPT',w3ca,f3ca,EXTEN_NO=3
ftab_ext,cal2070,'Wavelength_model,Extracted_OPT',w4ca,f4ca,EXTEN_NO=4

ftab_ext,cal2076,'Wavelength_model,Extracted_OPT',w1cb,f1cb,EXTEN_NO=1
ftab_ext,cal2076,'Wavelength_model,Extracted_OPT',w2cb,f2cb,EXTEN_NO=2
ftab_ext,cal2076,'Wavelength_model,Extracted_OPT',w3cb,f3cb,EXTEN_NO=3
ftab_ext,cal2076,'Wavelength_model,Extracted_OPT',w4cb,f4cb,EXTEN_NO=4


;correcting for the 0 value in the last pixel, very crudely, for further interpolation
w2a[1023]=w2a[1020]+3.*(w2a[1018]-w2a[1017])
w2ca[1023]=w2ca[1020]+3.*(w2ca[1018]-w2ca[1017])
w2b[1023]=w2b[1020]+3.*(w2b[1018]-w2b[1017])
w2cb[1023]=w2cb[1020]+3.*(w2cb[1018]-w2cb[1017])



;;converting to velocity for brg vacuum
;w1=299972*(w1-2166.120)/2166.120
;w2=299972*(w2-2166.120)/2166.120
;w3=299972*(w3-2166.120)/2166.120
;w4=299972*(w4-2166.120)/2166.120
;w5=299972*(w5-2166.120)/2166.120


;set plot range
;x1l=-200. & x1u=200.



x1l=2030 & x1u=2060
x2l=2051 & x2u=2062
x3l=2040 & x3u=2090
x4l=2040 & x4u=2090

; plot spectrum to window
set_plot,'x'

window,0,xsize=900,ysize=400,retain=2
plot,w1a,f1a,xstyle=1,ystyle=1,xrange=[x1l,x1u]
;,yrange=[0.5,1.1],xtitle='Wavelength (nm)',$
;ytitle='Flux (crudely normalized)'

window,1,xsize=900,ysize=400,retain=2
plot,w2a,f2a*1.05,xstyle=1,ystyle=1,xrange=[x2l,x2u], yrange=[-100,500], /NODATA
plots,w2a,f2a*1.05,color=fsc_color('red')
plots,w2b,f2b,color=fsc_color('white')
plots,w2ca,f2ca*90,color=fsc_color('blue')
plots,w2cb,f2cb*90,color=fsc_color('green')

;interpolating data
f2cai=cspline(w2ca,f2ca,w2a) ;interpolate to the same lambda grid
f2cbi=cspline(w2cb,f2cb,w2b) ;interpolate to the same lambda grid

;shifting in velocity
C=299792.458
v=0.5
w2can=w2a*(1.+v/C)
f2cain=cspline(w2can,f2cai,w2a)


;checking interpolated data
window,10,xsize=900,ysize=400,retain=2
plot,w2ca,f2ca,xstyle=1,ystyle=1,xrange=[2054,2055], /NODATA
plots,w2ca,f2ca,noclip=0
plots,w2a,f2cai,color=fsc_color('red'),noclip=0

;checking wavelength difference between science star and telluric calibrator star
window,11,xsize=900,ysize=400,retain=2
plot,w2a,f2a,xstyle=1,ystyle=1,xrange=[2054,2055],yrange=[-500,9055], /NODATA
plots,w2a,f2a,noclip=0
plots,w2a,f2cai*70.,color=fsc_color('red'),noclip=0
plots,w2a,f2cain*70.,color=fsc_color('green'),noclip=0


window,5,xsize=900,ysize=400,retain=2
plot,w2a,f2a/f2cai,xstyle=1,ystyle=1,xrange=[x2l,x2u], /NODATA
plots,w2a,f2a/f2cai,color=fsc_color('red')
plots,w2b,f2b/f2cbi,color=fsc_color('white')
plots,w2a,f2a/f2cain/1.15,color=fsc_color('green')
;plots,w2ca,f2ca*90,color=fsc_color('blue')
;plots,w2cb,f2cb*90,color=fsc_color('green')

lambda0=2058.69
window,6,xsize=900,ysize=400,retain=2
plot,ZE_LAMBDA_TO_VEL(w2a,lambda0),f2a/f2cain/1.15/69.,xstyle=1,ystyle=1,xrange=[-800,500], /NODATA
;plots,w2b,f2b/f2cbi/69.,color=fsc_color('white')
plots,ZE_LAMBDA_TO_VEL(w2a,lambda0),f2a/f2cain/1.15/69.,color=fsc_color('green')
;plots,w2ca,f2ca*90,color=fsc_color('blue')
;plots,w2cb,f2cb*90,color=fsc_color('green')
f2caine=((f2cain-95)*0.993)+95
plots,ZE_LAMBDA_TO_VEL(w2a,lambda0),f2a/f2caine/1.15/69.,color=fsc_color('blue')



;$,yrange=[0.5,1.1],xtitle='Wavelength (nm)',$
;$ytitle='Flux (crudely normalized)'

;window,2,xsize=900,ysize=400,retain=2
;plot,w3a,f3a,xstyle=1,ystyle=1,xrange=[x3l,x3u]
;;$,yrange=[0.5,1.1],xtitle='Wavelength (nm)',$
;;$ytitle='Flux (crudely normalized)'
;
;window,3,xsize=900,ysize=400,retain=2
;plot,w4a,f4a,xstyle=1,ystyle=1,xrange=[x4l,x4u]
;;$,yrange=[0.5,1.1],xtitle='Wavelength (nm)',$
;;$ytitle='Flux (crudely normalized)'


window,4,xsize=900,ysize=400
plot,w2a,f2a,xstyle=1,ystyle=1,xrange=[2040,2090],/NODATA
plots,w1b,f1b,color=fsc_color('white')
plots,w2b,f2b,color=fsc_color('white')
plots,w3b,f3b,color=fsc_color('white')
plots,w4b,f4b,color=fsc_color('white')

plots,w1a,f1a,color=fsc_color('red')
plots,w2a,f2a,color=fsc_color('red')
plots,w3a,f3a,color=fsc_color('red')
plots,w4a,f4a,color=fsc_color('red')

;plots,lambdamod,1.0*fluxmodescd,color=255, noclip=0,clip=[x1l,0,x1u,1.8e-11]
;plots,lambdanoabs,(0.5*fluxnoabsescd+0.5e-11),color=255, noclip=0,clip=[x1l,0,x1u,1.8e-11]
;for l=0, i-1 do begin
;if (lambdac[l] gt x1l) and (lambdac[l] lt x1u) and (abs(ew[l]) gt 0.1) then begin
;pos=strpos(strtrim(sob[l],1),'(')
;sobc[l]=strmid(sob[l],2,pos+2)
;xyouts,lambdac[l],8.0e-12,'!3'+string(45B)+sobc[l],alignment=0.5,orientation=90
;endif
;endfor



END

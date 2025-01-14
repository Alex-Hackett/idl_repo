Angstrom = '!6!sA!r!u!9 %!6!n'
file509='/aux/pc244a/jgroh/data/eso_vlt/crires/Cepheids_nardetto/302509/sci_proc/CR_SEXT_302509_2008-01-03T05:15:59.148_DIT15_2150.0nm.fits'
file511='/aux/pc244a/jgroh/data/eso_vlt/crires/Cepheids_nardetto/302511/sci_proc/CR_SEXT_302511_2008-02-26T02:07:09.772_DIT15_2150.0nm.fits'
file514='/aux/pc244a/jgroh/data/eso_vlt/crires/Cepheids_nardetto/302514/sci_proc/CR_SEXT_302514_2008-01-26T06:31:33.505_DIT5_2150.0nm.fits'
file515='/aux/pc244a/jgroh/data/eso_vlt/crires/Cepheids_nardetto/302515/sci_proc/CR_SEXT_302515_2008-01-03T04:40:02.458_DIT15_2150.0nm.fits'
file516='/aux/pc244a/jgroh/data/eso_vlt/crires/Cepheids_nardetto/302516/sci_proc/CR_SEXT_302516_2008-01-27T04:22:34.355_DIT3_2150.0nm.fits'
ftab_help,file514
ftab_ext,file509,'Wavelength,Extracted_RECT',w1,f1,EXTEN_NO=2
ftab_ext,file511,'Wavelength,Extracted_RECT',w2,f2,EXTEN_NO=2
ftab_ext,file514,'Wavelength,Extracted_RECT',w3,f3,EXTEN_NO=2
ftab_ext,file515,'Wavelength,Extracted_RECT',w4,f4,EXTEN_NO=2
ftab_ext,file516,'Wavelength,Extracted_RECT',w5,f5,EXTEN_NO=2

;converting to velocity for brg vacuum
;w1=299972*(w1-2166.120)/2166.120
;w2=299972*(w2-2166.120)/2166.120
;w3=299972*(w3-2166.120)/2166.120
;w4=299972*(w4-2166.120)/2166.120
;w5=299972*(w5-2166.120)/2166.120


;set plot range
;x1l=-200. & x1u=200.
x1l=2130. & x1u=2142.
;x2l=1060. & x2u=1180.
;x3l=1020. & x3u=1080.
;x4l=1080. & x4u=1180.

; plot spectrum to window
set_plot,'x'

window,0,xsize=900,ysize=400,retain=2
plot,w1,f1,xstyle=1,ystyle=1,xrange=[x1l,x1u]
;,yrange=[0.5,1.1],xtitle='Wavelength (nm)',$
;ytitle='Flux (crudely normalized)'

window,1,xsize=900,ysize=400,retain=2
plot,w2,f2/1350.,xstyle=1,ystyle=1,xrange=[x1l,x1u]
;$,yrange=[0.5,1.1],xtitle='Wavelength (nm)',$
;$ytitle='Flux (crudely normalized)'

window,2,xsize=900,ysize=400,retain=2
plot,w3,f3/6000.,xstyle=1,ystyle=1,xrange=[x1l,x1u]
;$,yrange=[0.5,1.1],xtitle='Wavelength (nm)',$
;$ytitle='Flux (crudely normalized)'

window,3,xsize=900,ysize=400,retain=2
plot,w4,f4/4000.,xstyle=1,ystyle=1,xrange=[x1l,x1u]
;$,yrange=[0.5,1.1],xtitle='Wavelength (nm)',$
;$ytitle='Flux (crudely normalized)'

window,4,xsize=900,ysize=400,retain=2
plot,w5,f5/8300.,xstyle=1,ystyle=1,xrange=[x1l,x1u]
;$,yrange=[0.5,1.1],xtitle='Wavelength (nm)',$
;$ytitle='Flux (crudely normalized)'

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

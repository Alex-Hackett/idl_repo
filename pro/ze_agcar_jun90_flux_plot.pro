Angstrom = '!6!sA!r!u!9 %!6!n'
close,/all


ldec90=[3491,4111 ,4662 ,5456 ,12500,16000,22200,35400] ;removed V 5500 = 2.64e-12
fdec90=[4.03e-12,3.43e-12,3.28e-12,3.08e-12,1.05e-12,5.14e-13,2.5e-13,6.56e-14]

dir='/aux/pc20072b/jgroh/espectros/agcar/'
sufix='_car_ebv65r34.txt'
model='390'

model394car='/aux/pc20072b/jgroh/espectros/agcar/394_car_ebv65r34.txt'
model389car='/aux/pc20072b/jgroh/espectros/agcar/389_car_ebv65r34.txt'
model395car='/aux/pc20072b/jgroh/espectros/agcar/395_car_ebv65r34.txt'

;defines observed photometry file
obsphot90='/aux/pc20072b/jgroh/espectros/agcar/agc90jun18_phot_ubvyVJHKL.txt'  

ZE_READ_SPECTRA_COL_VEC,obsphot90,ljun90,fjun90
ZE_READ_SPECTRA_COL_VEC,model389car,l389car,f389car
ZE_READ_SPECTRA_COL_VEC,model395car,l395car,f395car

ZE_READ_SPECTRA_COL_VEC,dir+'362'+sufix,l362car,f362car
ZE_READ_SPECTRA_COL_VEC,dir+'363'+sufix,l363car,f363car
ZE_READ_SPECTRA_COL_VEC,dir+'365'+sufix,l365car,f365car
ZE_READ_SPECTRA_COL_VEC,dir+'369'+sufix,l369car,f369car
ZE_READ_SPECTRA_COL_VEC,dir+'389'+sufix,l389car,f389car
ZE_READ_SPECTRA_COL_VEC,dir+'390'+sufix,l390car,f390car
ZE_READ_SPECTRA_COL_VEC,dir+'391'+sufix,l391car,f391car
ZE_READ_SPECTRA_COL_VEC,dir+'392'+sufix,l392car,f392car
ZE_READ_SPECTRA_COL_VEC,dir+'395'+sufix,l395car,f395car
ZE_READ_SPECTRA_COL_VEC,dir+'397'+sufix,l397car,f397car

ZE_READ_SPECTRA_COL_VEC,dir+'408'+sufix,l408car,f408car
ZE_READ_SPECTRA_COL_VEC,dir+'410'+sufix,l410car,f410car


;final redenning
minusebv=-0.65
a=3.4
;fm_unred, lambda, flux6, minusebv, flux6dfin, R_V = a

x8l=1000
x8u=40000
x9l=3000
x9u=40000

!p.multi=[0, 0, 0, 0, 0]
window,3
plot,ljun90,fjun90,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x8l,x8u],yrange=[1E-14,1e-11],xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+']', $
;ytitle='F/F!Ic',$
/nodata,charsize=2,XMARGIN=[5,3];,POSITION=[0.78,0.05,0.98,0.24]
plots,ljun90,fjun90,color=fsc_color('red'),noclip=0,psym=4,clip=[x8l,0,x8u,13],thick=2,symsize=1.5
;plots,l389car,f389car,noclip=0
plots,l410car,f410car,color=fsc_color('blue'), noclip=0,clip=[x8l,0,x8u,13],linestyle=0,thick=2
plots,l392car,f392car,color=fsc_color('orange'), noclip=0,clip=[x8l,0,x8u,13],linestyle=0,thick=2
plots,l397car,f397car/1.2,color=fsc_color('green'), noclip=0,clip=[x8l,0,x8u,13],linestyle=0,thick=2
;plots,l392car,f392car*1.5,color=fsc_color('white'), noclip=0,clip=[x8l,0,x8u,13],linestyle=0,thick=2
;plots,l392car,f392car/1.5,color=fsc_color('white'), noclip=0,clip=[x8l,0,x8u,13],linestyle=0,thick=2


window,4
plot,ldec90,fdec90,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x9l,x9u],yrange=[1E-14,1e-11],xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+']', $
ytitle='F/F!Ic',$
/nodata,charsize=2,XMARGIN=[5,3];,POSITION=[0.78,0.05,0.98,0.24]
plots,ldec90,fdec90,color=fsc_color('red'),noclip=0,psym=2;,clip=[x9l,0,x9u,13],thick=2
;plots,l358narv,t,color=fsc_color('red'), noclip=0,clip=[x9l,0,x9u,13],linestyle=1,thick=2
plots,l392car,f392car
plots,l389car,f389car
plots,l391car,f391car

;window,5
;plot,ljun90,fjun90,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x8l,x8u],yrange=[1E-14,1e-11],xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+']', $
;ytitle='F/F!Ic',$
;/nodata,charsize=2,XMARGIN=[5,3];,POSITION=[0.78,0.05,0.98,0.24]
;plots,ljun90,fjun90,color=fsc_color('red'),noclip=0,psym=4,clip=[x8l,0,x8u,13],thick=2,symsize=1.5
;plots,l389car,f389car,noclip=0
;plots,l397car,f390car,color=fsc_color('blue'), noclip=0,clip=[x8l,0,x8u,13],linestyle=0,thick=2
;plots,l392car,f392car,color=fsc_color('orange'), noclip=0,clip=[x8l,0,x8u,13],linestyle=0,thick=2
;
;plots,l392car,f392car*1.5,color=fsc_color('white'), noclip=0,clip=[x8l,0,x8u,13],linestyle=0,thick=2
;plots,l392car,f392car/1.5,color=fsc_color('white'), noclip=0,clip=[x8l,0,x8u,13],linestyle=0,thick=2
;
;window,6
;plot,ljun90,fjun90,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x8l,x8u],yrange=[1E-14,1e-11],xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+']', $
;ytitle='F/F!Ic',$
;/nodata,charsize=2,XMARGIN=[5,3];,POSITION=[0.78,0.05,0.98,0.24]
;plots,ljun90,fjun90,color=fsc_color('red'),noclip=0,psym=4,clip=[x8l,0,x8u,13],thick=2,symsize=1.5
;plots,l362car,f362car,color=fsc_color('green'), noclip=0,clip=[x8l,0,x8u,13],linestyle=0,thick=2
;plots,l369car,f369car,color=fsc_color('blue'), noclip=0,clip=[x8l,0,x8u,13],linestyle=0,thick=2
;plots,l365car,f365car,color=fsc_color('orange'), noclip=0,clip=[x8l,0,x8u,13],linestyle=0,thick=2


END

Angstrom = '!6!sA!r!u!9%!6 !n'
close,/all
obsdir='/Users/jgroh/espectros/agcar/'
ldec90=[3491,4111 ,4662 ,5456 ,5500 ,12500,16000,22200,35400]
fdec90=[3.43e-12,3.28e-12,3.08e-12,2.64e-12,1.05e-12,5.14e-13,2.5e-13,6.56e-14]
l91aug=[3491,4111 ,4662 ,5456,12500,16000,22200,35400]
l93apr=l91aug
f91aug=[6.19E-12,          5.17E-12,          5.01E-12 ,         4.96E-12,  2.37E-12      ,    1.22E-12     ,     6.55E-13     ,     1.65E-13]
f93apr=[8.99E-12,          6.96E-12,          6.88E-12 ,         7.13E-12, 3.45E-12       ,   1.78E-12       ,   9.29E-13    ,      2.09E-13]
errf91aug=f91aug*1

phot91may=obsdir+'agc91may25_photuvbyJHKL.txt'

ZE_READ_SPECTRA_COL_VEC,phot91may,l91may,f91may

model93car=obsdir+'93c'
model191car=obsdir+'191_car_ebv65r35.txt'
model198car=obsdir+'198_car_ebv65r35.txt'
model220car=obsdir+'220_car_ebv65r35.txt'
model222car=obsdir+'222_car_ebv65r35.txt'
model394car='/Users/jgroh/espectros/agcar/394_car_ebv65r35.txt'
model389car='/Users/jgroh/espectros/agcar/389_car_ebv65r35.txt'
model395car='/Users/jgroh/espectros/agcar/395_car_ebv65r35.txt'
model413car='/Users/jgroh/espectros/agcar/413_car_ebv65r35.txt'
model414car='/Users/jgroh/espectros/agcar/414_car_ebv65r35.txt'
model416car='/Users/jgroh/espectros/agcar/416_car6_ebv65r35.txt'
model417car='/Users/jgroh/espectros/agcar/417_car6_ebv65r35.txt'
model427car='/Users/jgroh/espectros/agcar/427_car6_ebv65r35.txt'
model418car='/Users/jgroh/espectros/agcar/418_car6_ebv65r35.txt'
model191varmdot8=obsdir+'var_191_regrid_223_mdot8_car_ebv65r35.txt'

ZE_READ_SPECTRA_COL_VEC,model93car,l93car,f93car
ZE_READ_SPECTRA_COL_VEC,model389car,l389car,f389car
ZE_READ_SPECTRA_COL_VEC,model395car,l395car,f395car
ZE_READ_SPECTRA_COL_VEC,model191car,l191car,f191car
ZE_READ_SPECTRA_COL_VEC,model198car,l198car,f198car
ZE_READ_SPECTRA_COL_VEC,model220car,l220car,f220car
ZE_READ_SPECTRA_COL_VEC,model222car,l222car,f222car
ZE_READ_SPECTRA_COL_VEC,model191varmdot8,l191carv8,f191carv8
ZE_READ_SPECTRA_COL_VEC,model413car,l413car,f413car
ZE_READ_SPECTRA_COL_VEC,model414car,l414car,f414car
ZE_READ_SPECTRA_COL_VEC,model416car,l416car,f416car
ZE_READ_SPECTRA_COL_VEC,model417car,l417car,f417car
ZE_READ_SPECTRA_COL_VEC,model418car,l418car,f418car
ZE_READ_SPECTRA_COL_VEC,model427car,l427car,f427car
;final redenning
minusebv=-0.65
a=3.5
fm_unred, l93car, f93car/36., minusebv, f93card6, R_V = a

LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')


x9l=3000
x9u=40000
window,1,title='1991 May'
plot,l91may,f91may,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x9l,x9u],yrange=[1E-15,3e-11],xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+']', $
;ytitle='F/F!Ic',$
/nodata,charsize=2,XMARGIN=[5,3];,POSITION=[0.78,0.05,0.98,0.24]
plots,l91may,f91may,color=fsc_color('red'),noclip=0,psym=2;,clip=[x9l,0,x9u,13],thick=2
plots,l93car,f93card6*1.0,color=fsc_color('blue'), noclip=0,clip=[x9l,0,x9u,13],linestyle=1,thick=2
plots,l395car,f395car

window,2,title='1991 August'
plot,l91aug,f91aug,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x9l,x9u],yrange=[1E-13,3e-11],xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+']', $
;ytitle='F/F!Ic',$
/nodata,charsize=2,XMARGIN=[5,3];,POSITION=[0.78,0.05,0.98,0.24]
ze_colorfill,low=3000,high=25000,ymin=f417car*0.8*1.1, ymax=f417car*1.1*1.2, x=l417car,yvals=f417car
plots,l91aug,f91aug,color=fsc_color('red'),noclip=0,psym=4
;plots,l395car,f395car
plots,l191car,f191car*1.0,color=fsc_color('orange'), noclip=0,clip=[x9l,0,x9u,13],linestyle=1,thick=2
;plots,l191carv8,f191carv8*1.0,color=fsc_color('blue'), noclip=0,clip=[x9l,0,x9u,13],linestyle=0,thick=3
;plots,l414car,f414car*1.0,color=fsc_color('blue'), noclip=0,clip=[x9l,0,x9u,13],linestyle=0,thick=3
plots,l418car,f418car*1.0,color=fsc_color('red'), noclip=0,clip=[x9l,0,x9u,13],linestyle=0,thick=3
plots,l417car,f417car*1.0,color=fsc_color('white'), noclip=0,clip=[x9l,0,x9u,13],linestyle=0,thick=3
plots,l427car,f427car*1.0,color=fsc_color('blue'), noclip=0,clip=[x9l,0,x9u,13],linestyle=0,thick=3

;bbflux=planck(l198car,2000)



factor=1.5E-17
window,3,title='1993 April'
plot,l93apr,f93apr,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x9l,x9u],yrange=[1E-15,3e-11],xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+']', $
;ytitle='F/F!Ic',$
/nodata,charsize=2,XMARGIN=[5,3];,POSITION=[0.78,0.05,0.98,0.24]
ze_colorfill,low=3000,high=25000,ymin=f198car*0.8, ymax=f198car*1.2, x=l198car,yvals=f198car
plots,l93apr,f93apr,color=fsc_color('blue'),noclip=0,psym=4
plots,l198car,f198car*1.0,color=fsc_color('orange'), noclip=0,clip=[x9l,0,x9u,13],linestyle=1,thick=2
plots,l222car,f222car*1.0,color=fsc_color('red'), noclip=0,clip=[x9l,0,x9u,13],linestyle=0,thick=2
;plots,l198car,bbflux*factor
;plots,l198car,(f198car+bbflux*factor),color=fsc_color('green')
END

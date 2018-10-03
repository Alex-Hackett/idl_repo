Angstrom = '!6!sA!r!u!9 %!6!n'
close,/all
obsdir='/aux/pc20072b/jgroh/espectros/agcar/'
ldec90=[3491,4111 ,4662 ,5456 ,5500 ,12500,16000,22200,35400]
fdec90=[3.43e-12,3.28e-12,3.08e-12,2.64e-12,1.05e-12,5.14e-13,2.5e-13,6.56e-14]
phot91may=obsdir+'agc91may25_photuvbyJHKL.txt'

ZE_READ_SPECTRA_COL_VEC,phot91may,l91may,f91may


model394car='/aux/pc20072b/jgroh/espectros/agcar/394_car_ebv65r34.txt'
model389car='/aux/pc20072b/jgroh/espectros/agcar/389_car_ebv65r34.txt'
model395car='/aux/pc20072b/jgroh/espectros/agcar/395_car_ebv65r34.txt'

ZE_READ_SPECTRA_COL_VEC,model389car,l389car,f389car
ZE_READ_SPECTRA_COL_VEC,model395car,l395car,f395car

x9l=3000
x9u=40000
window,4
plot,ldec90,fdec90,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x9l,x9u],yrange=[1E-15,1e-11],xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+']', $
;ytitle='F/F!Ic',$
/nodata,charsize=2,XMARGIN=[5,3];,POSITION=[0.78,0.05,0.98,0.24]
plots,ldec90,fdec90,color=fsc_color('red'),noclip=0,psym=2;,clip=[x9l,0,x9u,13],thick=2
;plots,l358narv,t,color=fsc_color('red'), noclip=0,clip=[x9l,0,x9u,13],linestyle=1,thick=2
plots,l395car,f395car

END

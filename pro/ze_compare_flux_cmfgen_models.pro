model='361'
readcol,'/Users/jgroh/espectros/agcar/'+model+'_car.txt',l361,f361

model='358'
readcol,'/Users/jgroh/espectros/agcar/'+model+'_car.txt',l358,f358

model='421'
readcol,'/Users/jgroh/espectros/agcar/'+model+'_car.txt',l421,f421

model='279'
;readcol,'/Users/jgroh/espectros/agcar/'+model+'_all.txt',l421a,f421a

model='378'
;readcol,'/Users/jgroh/espectros/agcar/'+model+'_all.txt',l358a,f358a

lfine=FINDGEN(500000)

LINTERP,l358,f358,lfine,f358fine
LINTERP,l358a,f358a,lfine,f358afine
LINTERP,l361,f361,lfine,f361fine
LINTERP,l421,f421,lfine,f421fine
LINTERP,l421a,f421a,lfine,f421afine

window,0
plot,l421a,f421a,xrange=[0,30000],yrange=[1E-12,1e-6],/NODATA,/ylog
plots,l358a,f358a,color=FSC_COLOR('red')
plots,l421a,f421a,color=FSC_COLOR('white')
;plots,lfine,f358fine,psym=2


print,total(f358fine)
print,total(f358afine)
print,total(f361fine)
print,total(f421fine)
print,total(f421afine)
d_kpc=1 ;kpc
d_cm=d_kpc*3.086E+21
lbol=total(f421afine)*4.D*!PI*d_cm*d_cm ;in erg/s
lbol_lsun=lbol/(3.84E33)
print,lbol_lsun

END
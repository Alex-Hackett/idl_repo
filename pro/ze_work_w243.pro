dir='/Users/jgroh/espectros/w243/'
file1=dir+'w243_06jun03_85n_hel.txt'
file2=dir+'w243_06aug04_85_hel.txt'

ZE_READ_SPECTRA_COL_VEC,file1,l06jun,f06jun
ZE_READ_SPECTRA_COL_VEC,file2,l06aug,f06aug

window,1
x1=8490
x2=8520
plot,l06jun,f06jun,XRANGE=[x1,x2],/NODATA
plots,l06jun,f06jun,color=fsc_color('white'),noclip=0
plots,l06aug,f06aug,color=fsc_color('red'),noclip=0


END
PRO ZE_READ_TELKPNO_AIR,lambdacut=lambdacut,fluxcut=fluxcut,lmin,lmax
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/espectros/transdata_1_2micron_ar',lambda,flux,nrec
nearmin = Min(Abs(lambda - lmin), indexmin)
nearmax = Min(Abs(lambda - lmax), indexmax)
print,lmin,lmax,indexmin,indexmax
lambdacut=lambda[indexmax:indexmin]
fluxcut=flux[indexmax:indexmin]
lambdacut=REVERSE(lambdacut)
fluxcut=REVERSE(fluxcut)
END
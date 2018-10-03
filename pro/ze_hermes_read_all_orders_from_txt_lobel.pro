PRO ZE_HERMES_READ_ALL_ORDERS_FROM_TXT_LOBEL

dir_hermes_hd168='/Users/jgroh/espectros/HermesLBVSep15/HD168625/20100628/'
listfile=dir_hermes_hd168+'list'

norder=55
npix=4608

list=strarr(norder)
openr,1,listfile
strtemp=''
for k=0, norder -1  DO BEGIN
readf,1,strtemp
list[k]=strtemp
ENDFOR
close,1

flux_array=dblarr(npix,norder)
lambda_array=dblarr(npix,norder)

FOR k=0, norder -1  DO BEGIN
ZE_READ_SPECTRA_COL_VEC,dir_hermes_hd168+list[k],lambdatemp,fluxtemp
lambda_array[*,k]=lambdatemp
flux_array[*,k]=fluxtemp
ENDFOR

save,lambda_array,flux_array,npix,norder,filename='/Users/jgroh/espectros/hd168625/hd168625_hermes_2010sep15_allorders.sav'

END
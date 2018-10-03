;PRO ZE_HERMES_COADD_ECHELLE_ORDERS_FROM_SAV
;crude coadd of echelle orders

restore,'/Users/jgroh/espectros/hd168625/hd168625_hermes_2010sep15_allorders_norm.sav'

FOR k=0, norder -2  DO BEGIN
l1=REFORM(lambda_Array[*,k])
f1=REFORM(fluxnorm_Array[*,k])
f2=REFORM(fluxnorm_Array[*,k+1])
l2=REFORM(lambda_Array[*,k+1])

lmerge=lambda_Array[*,k:k+1]
fmerge=fluxnorm_Array[*,k:k+1]
hrs_merge,lmerge,fmerge,0,0,lambdacomb_1dspc,fluxcomb_1dspc


ENDFOR




END
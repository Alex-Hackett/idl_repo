FUNCTION ZE_COMPUTE_L_FROM_MBOL,mbol
Mbolsun=4.74

lstar=10^((Mbolsun-mbol)/(2.5))
return,lstar


END
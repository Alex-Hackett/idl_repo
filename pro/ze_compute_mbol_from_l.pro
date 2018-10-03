FUNCTION ZE_COMPUTE_MBOL_FROM_L,lstar
Mbolsun=4.74
mbol=Mbolsun -2.5*alog10(lstar)

return,mbol


END
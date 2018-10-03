PRO ZE_EVOL_SCALE_POPULATIONS_TO_CMFGEN,u5,u7,u8,u10,u12,u6,u5scl,u7scl,u8scl,u10scl,u12scl,u6scl,zscale=zscale,zonzsun=zonzsun
;scale H,He,CNO and Ne populations output from Geneva stellar evolution code so the SUM=1.000
;does not change the abudances of the other impurity elements and Fe
other_elem=3.45D-05 +$;         [SOD/X]      !Na abundance (by mass: solar=3.45E-05)'
           6.47D-04 +$;         [MAG/X]      !Mg abundance (by mass: solar=6.47E-04)'
           5.58D-05 +$;         [ALUM/X]     !Al abundance (by mass: solar=5.58D-05)'
           6.60E-04 +$;         [SIL/X]      !Si abundance (by mass: solar=8.60E-04)'
           3.82E-04 +$;         [SUL/X]      !S abundance  (by mass: solar=3.82E-04)'
           6.12E-06 +$;         [PHOS/X]     !P abundance  (by mass: solar=6.12E-06)'
           7.87E-06 +$;         [CHL/X]      !Cl abundance (by mass: solar=7.87E-06)'
           1.02E-04 +$;         [ARG/X]      !Ar abundance (by mass: solar=1.04E-04)'
           3.61E-06 +$;         [POT/X]      !K abundance  (by mass: solar=3.61E-06)'
           6.15E-05 +$;         [CAL/X]      !Ca abundance (by mass: solar=6.15E-05)'
           3.28D-06 +$;         [TIT/X]      !Ti mass fraction (by mass: solar=3.28E-06)'
           1.70E-05 +$;         [CHRO/X]     !Cr abundance (by mass: solar=1.70E-05)'
           9.44E-06 +$;         [MAN/X]      !Mn abundance (by mass: solar=9.44E-06)'
           1.36E-03 +$;         [IRON/X]     !Fe abundance (by mass: solar=1.36E-03)'
           7.32D-05   ;         [NICK/X]     !Nk?X abunances (by mass: solar=7.32E-05)
           
IF KEYWORD_SET(ZSCALE) THEN other_elem=other_elem*zonzsun           
oldsum=u5+u7+u8+u10+u12+u6+other_elem
print,'Old sum of elements is: ',oldsum
scale_factor=1D0/oldsum
print,'Scale factor is: ',scale_factor
u5scl=u5*scale_factor
u7scl=u7*scale_factor
u8scl=u8*scale_factor
u10scl=u10*scale_factor
u12scl=u12*scale_factor
u6scl=u6*scale_factor


END
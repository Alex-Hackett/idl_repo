FUNCTION ZE_COMPUTE_MEJECTA_FROM_V_ENERGY,v,e
;E in 10^51 ergs
;v in km/s
mejecta=1d0

;1.99e-2 is 1e51 / (1e5^2)/1.99e33
mejecta=2D0*E/(v^2)/1.99e-2

print,'mejecta ',mejecta

END
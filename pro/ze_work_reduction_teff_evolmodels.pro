;references: langer 89, Meynet Maeder 2005, Schaller 1992
;Reff= Rstar + [(3 K Mdot) / (8 *PI* vinf)] ; K=opacity in cm^2/g

teff=[22.800,21.500,17.000,16.400,14.000,14.300]  ;in units kK from CMFGEN
tstar=[26.200,24.600,21.900,18.700,16.650,17.420] ;in units kK from CMFGEN
mdot=[1.5,1.5,3.7,4.72,6.0,6.0] 		  ;in units 10^-5 Msun/yr from CMFGEN
vinf=[300,300,105,195,200,150] 			  ;from CMFGEN in km/s
rstar=[59.6,67.4,85.3,95.5,120.4,115.2] 	  ;from CMFGEN in Rsun
reff=[78.7,88.5,141.6,124.2,179.4,171.3]          ;from CMFGEN in Rsun
lstar=[1.5,1.5,1.5,1.0,1.0,1.1]                   ;from CMFGEN in 10^6 Lsun units
K=[0.3,0.3,0.35,0.32,0.32,0.32]						  ;opacity in cm^2/g at Rstar from CMFGEN; caveat: decreases as a function of r
;parameters from Langer 1989 in order to check the calculation; extension should be equal to 3.75 Rsun)
;mdot=3.
;k=0.22
;vinf=2000. ;Ok working!

reff_mm05=rstar+(3.*K*mdot*1E-05*1.99E+33/(3600.*24.*365)/(8.*!PI*vinf*1.e+05))/(6.96E+10) ;reff computed using the MM05 formula
teff_mm05=5780.*(lstar*1E+06)^0.25/reff_mm05^0.5

;print,rstar
;print,reff
;print,reff_mm05
print,teff
print,teff_mm05
END

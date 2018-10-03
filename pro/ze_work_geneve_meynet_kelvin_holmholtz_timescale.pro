;PRO ZE_WORK_GENEVE_MEYNET_KELVIN_HOLMHOLTZ_TIMESCALE

;following George's suggestion to compute the Kelvin-Holmholtz timescale to check whether the timescale of the S-Dor cycles is related to the KH.
;t_kh=GM^2/(R*L)

;Constants
G=6.67e-8 ;in cgs
rsun=6.96E+10 ;in cm
msun=1.99e33 ; in g
lsun=3.83e33 ;in erg/s
s_to_year=1D0/(365.0*3600.0*24.0)

;stellar parameters in solar units
Rstar=70.0D
Mstar=70.0D
Lstar=1.5e6
Mexp=0.2D

t_kh=G*(Mstar*msun)*(Mexp*msun)/(Rstar*rsun*Lstar*lsun)*s_to_year
print,'Kelvin-Helmholtz timescale [years]', t_kh

;tdyn=SQRT((R*rsun)^3/(G*M*msun))*s_to_year
;print,'Dynamical timescale [years]', tdyn



END
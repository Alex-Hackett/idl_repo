PRO ZE_HRCAR_WORK_VROT_VCRIT_GAMMA_MAEDER

mdotsym= '!3!sM!r!u^!n'

sun = '!D!9n!3!N'

teff=17.700 ;in units kK
tstar=18.100 ; in units kK
mdot=0.72 ;in units 10^-5 Msun/yr
vinf=120
tefferr=0.5 ;assuming that is 2 sigma error
mdoterr=0.3*mdot
vinferr=10
;tstarerr=1

mass=25.
eta=0.16
gammafull=0.80*25./mass
gammavel2=0.67*25/mass
errgv2=0.1*gammavel2
rstar=70.
rstar=70.*1.5
vrot=150.
vcrit1=SQRT(0.0000000667*mass*1.989E+33/(rstar*6.96*10000000000.))/100000. ;ignoring departures from spherical symmetry (MM2000,A&A361,159)
errgam=0.02
omega1=vrot/vcrit1
factor=0.65 ;from Fig. 1 of MM2000,A&A361,159
vcrit2=vcrit1
for i=0, 0 do vcrit2[0]=factor[0]*vcrit1[0]
omega2=vrot/vcrit2
omegagamma=gammafull*(1./(1.-4.*vrot*vrot/(9.*vcrit2*vcrit2)))
print,vcrit1,vcrit2
print,omega1,omega2
print,gammafull,omegagamma



END
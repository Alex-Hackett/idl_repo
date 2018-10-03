mstar=70.
gamma=0.8
gamma=0.001
Meff=mstar*(1-gamma)
r1=85.
r2=115.
;r2=300.
rstar=[56.,63,81,86,119,111]

deltal=(0.5D*1.E6*3.84*1.E33)
deltatdays=15+31+31+30+31+30+31+365+11
print,deltatdays
;deltatdays=910.
deltat=deltatdays*24.*3600.
deltae=deltal*deltat

G=6.67E-08

deltamexp=deltae*6.96E+10/(G*Meff*1.99E+33*(1/r1 -1/r2))/1.99E+33
deltamexp_over_mstar=deltamexp/mstar
print,deltamexp,deltamexp_over_mstar


END

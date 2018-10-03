;PRO ZE_vh1_CAK_parameters_work

alpha=0.506
Qbar=1400.0
Gamma=0.8
mstar=50.0
L= 3e39  
M= 1.99e33*(mstar*(1-gamma))
c=299792*1e5
teff=20000.0

f1=alpha/(1D0-alpha)
f2=(teff/5.5e12)^(alpha/2.0D)
f3=qbar^(1D0-alpha)

k2=f1*f2*f3
print,f1,f2,f3,k2

k=(alpha/(1D0-alpha)*(teff/5.5e12)^(alpha/2.0D))*qbar^(1D0-alpha)


mdot=alpha/(1D0-alpha)*L/c^2*(Qbar*Gamma/(1D0-Gamma))^(1D0/alpha-1D0)



print,alpha,k,mdot

END
fe32=1.
T=20000.
k=1.3806503E-23 ;in m^2 kg s^-2 K^-1 
chi2=16.18 *1.6021E-19 ;in J
ratio=-chi2/(k*T)
pr=fe32 / (T^1.5 * exp(ratio))


END
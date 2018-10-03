;PRO ZE_SN_CSM_ANALYTICAL_LIGHTCURVE_FROM_TAKASHI_MORIYA_PAPER  
;computes SN-CSM analytical lightcurve based on Moryia et al. 2013 MNRAS 435, 1520
msuntog=1.9891*10d0^33
msunyrtogs=6.30321217 * 10d0^25
kmstocms=1*10d0^5
hrtos=3600d0

delta=1 ;*1.0D0
n=12 ;*1.0D0
Eej=1*10d0^49
Mej=5.0d0 * msuntog 
s=2
Mdot=1e-3 * msunyrtogs
vw=10.0 * kmstocms

;define t values
t=(indgen(1000)*1e-1) * hrtos
t[0]=1e-5
vt=((2*(5-delta)*(n-5)*Eej)/((3-delta)*(n-3)*Mej))^0.5

D=1 ; dummy

a=(3-s)*(4-s)
b=(2*(5-delta)*(n-5)*Eej)^((n-3)/2.)
c=4*!PI*(D)*(n-4)*(n-3)*(n-delta)
d=((3-delta)*(n-3)*Mej)^((n-5)/2.)
e=((3-delta)*(n-3)*Mej)^((5-s)/2.)
f=(2*(5-delta)*(n-5)*Eej)^((3-s)/2.)


rsh_t=(((a*b)/(c*d))^(1d0/(n-s)))*t^((n-3d0)/n-s)
t_t=((a*e)/(c*f))^(1d0/(3-s))

;for s=2, D=Mdot/(4*pi*vw)
rsh_t=((2*b*vw)/((n-4)*(n-3)*(n-delta)*d*Mdot))^(1d0/(n-2))*t^((n-3d0)/(n-2))
t_t=(2*e*vw)/((n-4)*(n-3)*(n-delta)*f*Mdot)



END
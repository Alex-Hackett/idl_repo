;PRO ZE_COMPUTE_WIND_COOLING_TIMESCALE
;based on hillier et al. 1993, eq. 12

U0=100.0
mu=1.27
gamma=1.0
mdot=1e-8
rstar=24.5

r1=reverse(indgen(100)*10.0+1.0)
v1=dblarr(100.0)
;velocity law for epoch 1:
vinf1=1000.
v0_1=1.0
beta1=1.0
sclht_1=0.04
;;v2mod=v2
nd1=n_elements(r1)
FOR k=0, nd1-1 do begin
v1[k]=(v0_1+(vinf1-v0_1)*((1-(r1[nd1-1]/r1[k]))^beta1))/(1.0+(v0_1/sclht_1)*exp((r1[nd1-1]-r1[k])/(sclht_1*r1[nd1-1])))
endfor


tcool=0.00835*(mu/gamma)*(mu/(1+gamma))^0.55 * r1^2 * (1e-6/mdot) * (vinf1/1000.) * (U0/100.)^3.1 ;in s

tflow=(r1*6.96e10)/(v1*1e5) ;in s
tflow[nd1-1]=0.0
vs1=15.0
ZE_COMPUTE_FLOWTIMESCALE,r1,v1,nd1,vs1,flowtime1,rirev1,virev1,flowtimerev1,dflowtimerev1
S_TO_DAY=1.0d/(24.0D*3600.0D)
flowtime1s=flowtime1/S_TO_DAY



END
FUNCTION ZE_COMPUTE_WIND_COOLING_TIMESCALE_FROM_HILLIER93,U0,mu,gamma,mdot,rstar,r1,vinf1
;based on hillier et al. 1993, eq. 12

;U0=100.0
;mu=1.27
;gamma=1.0
;mdot=1e-8
;rstar=24.5
;vinf1=1000.


tcool=0.00835*(mu/gamma)*(mu/(1+gamma))^0.55 * (r1*rstar)^2 * (1e-6/mdot) * (vinf1/1000.) * (U0/100.)^3.1 ;in s
return,tcool
END
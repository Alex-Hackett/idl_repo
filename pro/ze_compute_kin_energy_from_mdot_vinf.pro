FUNCTION ZE_COMPUTE_KIN_ENERGY_FROM_MDOT_VINF,mdot,vinf,duration
;computes kinectic energy from Mdot, vinf, and duration
;mdot in msunyr, vinf in km/s, duration in years
kin_energy=0.5D0* (Mdot*6.30321217e25) * (vinf*1e5)^2 * (duration*3.15569e7)

return,kin_energy


END
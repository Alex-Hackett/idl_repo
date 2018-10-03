FUNCTION ZE_COMPUTE_MDOT_TIRING,lum,mass,radius
;computes the maximum Mdot for radiative winds based on the photon tiring limit (owocki and gayley 1997) formulation, formula in Puls, Sundqvist, Markova 2014 IAUS 307 proc

mdottir=0.032 * lum/1e6 *radius/mass 

return,mdottir


END
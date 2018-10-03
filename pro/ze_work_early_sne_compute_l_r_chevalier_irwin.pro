;PRO ZE_WORK_EARLY_SNE_COMPUTE_L_R_CHEVALIER_IRWIN
;computes quantities for early sn based on Chevalier and Irwin 2011

;initial parameters
E51=1. ;explosion energy in 1e51 ergs
Me1=1. ;ejected mass in 10 Msun
t1=1.  ;age in units of 10days
k=1    ;opacity in units of 0.34 cm^2/g
Mdot=2e-2
vinf=100.0
Dstar=1d0 * (Mdot/1e-2) / (vinf/10d0) ;density parameter

;diffusion timescale in days
td=6.6*k*Dstar
print, 'Diffusion timescale is ', td*24.,' hour'
t1=0.1+indgen(10)
;luminosity
L=1*E51^(1.2) * Me1^(-0.6) * Dstar^(0.4) * t1^(-0.6) ;erg/s

END
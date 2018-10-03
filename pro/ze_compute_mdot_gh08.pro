FUNCTION ZE_COMPUTE_MDOT_GH08,gammae,T,L,Xh,ZoverZsun
;computes  Mdot from the recipe from Graefener & Hamann 2008, A&A
beta_z = 1.727 + 0.250 * alog10(ZoverZsun)
gamma0_Z = 0.326 - 0.301 * alog10(ZoverZsun) - 0.045 * alog10(ZoverZsun)^2

logMdot= 10.046 +beta_z*alog10(Gammae-gamma0_z)-3.5*alog10(T) +0.42 *alog10(L) - 0.45* XH
Mdot=10^logMdot
return,Mdot

END
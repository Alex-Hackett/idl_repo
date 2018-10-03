FUNCTION ZE_COMPUTE_D_FROM_DISTANCE_MODULUS,mu,deltamu=deltamu,deltad=deltad,kpc=kpc,mpc=mpc
;d and sigma in pc, mu and delta mu in mag unless keyord kpc or mpc is called
d=10^(mu/5.0 + 1.0)
IF KEYWORD_SET(KPC) THEN d=d/1e3
IF KEYWORD_SET(MPC) THEN d=d/1e6

if n_elements(deltamu) eq 0 then deltad=0.0 ELSE deltad=0.461*d*deltamu
return,d

END
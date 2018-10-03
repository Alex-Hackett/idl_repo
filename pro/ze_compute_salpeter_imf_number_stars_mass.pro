PRO ZE_COMPUTE_SALPETER_IMF_NUMBER_STARS_MASS,mlow,mup,nstars,mstars
;works only for a salpeter imf, computes de number of stars and mass in stars between Mlow and Mup

nstars=0.060/1.35*(mlow^(-1.35) - mup^(-1.35))
mstars=0.17/0.35*(mlow^(-0.35) - mup^(-0.35))

END
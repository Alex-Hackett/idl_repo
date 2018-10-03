FUNCTION ZE_EVOL_COMPUTE_DYNAMICAL_TIMESCALE,r,m
;r and m given in solar units

G=6.67e-8

tdyn=SQRT((r*6.96e10)^3/(2D0*G*M*1.99e33))   ;tdyn=sqrt( R^3/(2GM) )

return,tdyn

END
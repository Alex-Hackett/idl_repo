FUNCTION ZE_BINARY_STAR_COMPUTE_P_FROM_MP_MS_A,MP,MS,A

;compute period in years using as input the mass of the primary (MP) and secondary (MS) stars in Msun, semi-major axis (a) in AU
P=SQRT(a^3/(MP+MS))
RETURN,P


END
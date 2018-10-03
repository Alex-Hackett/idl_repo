FUNCTION ZE_BINARY_STAR_COMPUTE_A_FROM_MP_MS_P,MP,MS,P

;compute semi-major axis (a) in AU using as input the period (in years), and the mass of the primary (MP) and secondary (MS) stars in Msun 
a=((P^2)*(MP+MS))^0.333333333
RETURN,A


END
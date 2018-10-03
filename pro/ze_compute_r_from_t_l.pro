PRO ZE_COMPUTE_R_FROM_T_L,tstar,lstar,rstar,cmfgen=cmfgen

;compute tstar from tstar and l; tstar must be in 10^3 K units


rstar=(lstar^0.5)/((tstar/5.780)^2)

IF KEYWORD_SET(Cmfgen) THEN rstar=(rstar*6.96)

IF N_ELEMENTS(rstar) GT 10 THEN a='dummy' ELSE print,'rstar ', rstar

END
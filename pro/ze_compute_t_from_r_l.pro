PRO ZE_COMPUTE_T_FROM_R_L,rstar,lstar,tstar1,cmfgen=cmfgen
;rstar in solar radii, lstar in solar luminosities

;compute tstar from rstar and l
IF KEYWORD_SET(Cmfgen) THEN rstar=(rstar/6.96)

tstar1=5.780*(lstar^0.25/(rstar^0.5) )
print,tstar1

END
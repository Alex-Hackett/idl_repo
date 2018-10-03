FUNCTION ZE_LAMBDA_TO_VEL,lambda,lambda0,LMIN=LMIN,LMAX=LMAX

vel=299792.458 * ((lambda-lambda0)/lambda0)

IF KEYWORD_SET(LMIN) THEN BEGIN
 IF n_elements(where(lambda ge LMIN)) GT 0.0  THEN BEGIN 
    vel=vel(where(lambda ge LMIN))

 ENDIF
ENDIF

IF KEYWORD_SET(LMAX) THEN BEGIN
 IF n_elements(where(lambda le LMAX)) GT 0.0  THEN BEGIN 
    vel=vel(where(lambda le LMAX))
 ENDIF
ENDIF


return,vel

END

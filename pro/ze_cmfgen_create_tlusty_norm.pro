PRO ZE_CMFGEN_CREATE_TLUSTY_NORM,filecont,filefull,lobsnorm,fobsnorm,AIR=AIR,LMIN=LMIN,LMAX=LMAX,CNVL=CNVL

;create normalized tlusty spectrum by interpolating continuum spectrum into full spectral grid and dividing
;first reads continuum and full spectrum, may take some time
readcol,filecont,lcont,fcont
readcol,filefull,lobs,fobs


fcont_interp_to_obs=cspline(lcont,fcont,lobs)

fobsnorm=fobs/fcont_interp_to_obs
lobsnorm=lobs

IF KEYWORD_SET(AIR) THEN VACTOAIR,lobsnorm

IF KEYWORD_SET(LMIN) THEN BEGIN
 IF n_elements(where(lobsnorm ge LMIN)) GT 0.0  THEN BEGIN 
    fobsnorm=fobsnorm(where(lobsnorm ge LMIN))
    lobsnorm=lobsnorm(where(lobsnorm ge LMIN))
 ENDIF
ENDIF

IF KEYWORD_SET(LMAX) THEN BEGIN
 IF n_elements(where(lobsnorm le LMAX)) GT 0.0  THEN BEGIN 
    fobsnorm=fobsnorm(where(lobsnorm le LMAX))
    lobsnorm=lobsnorm(where(lobsnorm le LMAX))
 ENDIF
ENDIF

IF KEYWORD_SET(CNVL) THEN fobsnorm=ZE_SPEC_CNVL_VEL(lobsnorm,fobsnorm,CNVL)

END
PRO ZE_BH05_CREATE_OBSNORM,obs,modeldir,obscont,lobsnorm,fobsnorm,AIR=AIR,LMIN=LMIN,LMAX=LMAX

;normalize by the continuum spectrum from a 1-D model
print,modeldir

ZE_CMFGEN_READ_OBS_2D,obs,modeldir,lobs,fobs,num_rec
ZE_CMFGEN_READ_OBS,obscont,lcont,fcont,num_rec

fcont_interp_to_obs=cspline(lcont,fcont,lobs)

fobsnorm=fobs/fcont_interp_to_obs
lobsnorm=lobs

IF KEYWORD_SET(AIR) THEN VACTOAIR,lobsnorm

IF KEYWORD_SET(LMIN) THEN BEGIN
 IF n_elements(where(lobsnorm ge LMIN) GT 0 ) THEN BEGIN 
    fobsnorm=fobsnorm(where(lobsnorm ge LMIN))
    lobsnorm=lobsnorm(where(lobsnorm ge LMIN))
 ENDIF
ENDIF

IF KEYWORD_SET(LMIN) THEN BEGIN
 IF n_elements(where(lobsnorm le LMAX) GT 0 ) THEN BEGIN 
    fobsnorm=fobsnorm(where(lobsnorm le LMAX))
    lobsnorm=lobsnorm(where(lobsnorm le LMAX))
 ENDIF
ENDIF

END
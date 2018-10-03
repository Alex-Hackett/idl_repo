PRO ZE_ETACAR_CRIRES_CREATE_GENERIC_IMAGE_FROM_DATAA2,dataa2,a,b,img,SQRT=SQRT,LOG=LOG

;remove negative points
dataa2(WHERE(dataa2) le 0)=1e-32

;using  log?
IF KEYWORD_SET(LOG) THEN dataa2=alog10(dataa2)

;using sqrt?
IF KEYWORD_SET(SQRT) THEN dataa2=SQRT(dataa2)

;creating image image
img=bytscl(dataa2,MIN=a,MAX=b)

;using  log?
IF KEYWORD_SET(LOG) THEN dataa2=10^(dataa2)

;using sqrt?
IF KEYWORD_SET(SQRT) THEN dataa2=dataa2^2


END
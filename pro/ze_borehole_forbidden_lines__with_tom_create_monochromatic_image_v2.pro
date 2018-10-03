PRO ZE_BOREHOLE_FORBIDDEN_LINES__WITH_TOM_CREATE_MONOCHROMATIC_IMAGE_V2,dataa2,a,b,img,SQRT=SQRT,LOG=LOG
;v2 properly adjust min=a and max=b according to SQRT or LOG scaling
;remove negative points
dataa2(WHERE(dataa2) le 0)=1e-32

;using  log?
IF KEYWORD_SET(LOG) THEN BEGIN 
  dataa2=alog10(dataa2)
  a=ALOG10(a)
  b=ALOG10(b)
ENDIF

;using sqrt?
IF KEYWORD_SET(SQRT) THEN BEGIN 
  dataa2=SQRT(dataa2)
  a=sqrt(a)
  b=sqrt(b)
ENDIF

;creating image image
img=bytscl(dataa2,MIN=a,MAX=b)

;using  log?
IF KEYWORD_SET(LOG) THEN BEGIN 
  dataa2=10^(dataa2)
  a=10^a
  b=10^b
ENDIF

;using sqrt?
IF KEYWORD_SET(SQRT) THEN BEGIN 
  dataa2=dataa2^2
  a=a^2
  b=b^2
ENDIF

END
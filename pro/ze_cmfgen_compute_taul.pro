PRO ZE_CMFGEN_COMPUTE_TAUL,freq,nd,chil,r,v,sigma,taul,ELEC=ELEC,RADS=RADS

taul=dblarr(nd)
IF KEYWORD_SET(ELEC) THEN BEGIN ;'Stationary opactical depth?'
;    CALL USR_HIDDEN(RADIAL,'RADS','F','Radial Sobolev optical depth?')
;CALL TORSCL(TA,CHIL,R,TB,TC,ND,METHOD,TYPE_ATM)
;!
;! Assumes V_D=10kms.
;!
      T1=ALOG10(1.6914D-11/FREQ)
      FOR I=0,ND-1 DO BEGIN
        IF(TA(I) GT 0) THEN BEGIN
         taul(I)=T1+ALOG10(TA(I))
        ENDIF ELSE BEGIN
         IF (TA(I) LT 0) THEN taul(I)=T1+ALOG10(-TA(I))-20.0D0  ELSE  YV(I)=-30.0
        ENDELSE
      ENDFOR
      YAXIS=TEXTOIDL('\Tau stat')
ENDIF ELSE BEGIN 
      FOR I=0,ND-1 DO BEGIN
        taul(I)=CHIL(I)*R(I)*2.998E-10/FREQ/V(I)
        IF KEYWORD_SET(RADIAL) THEN taul(I)=taul(I)/(1.0D0+sigma[I]) ;'Radial Sobolev optical depth?')
        IF(taul(I) GT 0) THEN taul(I)=ALOG10(taul(I)) ELSE YV(I)=-20.0
      ENDFOR
      YAXIS=TEXTOIDL('\Tau sob')
ENDELSE

END
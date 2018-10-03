PRO ZE_CMFGEN_REV_RV,OLD_R,OLD_V,OLD_SIGMA,OLD_DEPTH,option,r,v,sigma,nd
;based on ZE_CMFGEN_REV_RVSIG, but reads OLD_R,OLD_V,OLD_SIGMA,OLD_DEPTH as input from an IDL variable
;John Hillier's CMFGEN routine misc/rev_rvsig.f for 'NEWG' option
;revises the radial grid between two velocities
;converted to IDL by Jose Groh
;currently only options 'NEW_ND' and 'NEWG' have been coded up so far

IONE=1

ND_OLD=n_elements(OLD_R)

CASE option OF

'NEW_ND': BEGIN
    PRINT, ' '
    PRINT, 'This option allows a new R grid to be output'
    PRINT, 'Grid spacing is similar to input grid.'
    PRINT, ' '
    ND=70
    read,ND,prompt='Number of depth points'
    v=dblarr(ND) & R=dblarr(ND) & sigma=dblarr(ND) & X1=DBLARR(ND_OLD) & X2=DBLARR(ND)
    FOR I=0,ND_OLD -1 DO BEGIN
      X1[I]=I
    ENDFOR
    T1=DOUBLE(ND_OLD-2)/DOUBLE(ND-2)
    FOR I=0,ND -1 DO BEGIN
      X2[I]=I*T1+1
    ENDFOR
    X2[0]=X1[0]
    X2[ND-1]=X1[ND_OLD-1]
    
    ZE_CMFGEN_MON_INTERP,R,ND,IONE,X2,ND,OLD_R,ND_OLD,X1,ND_OLD
    
    COEF=dblarr(ND_OLD,4)
    ZE_CMFGEN_MON_INT_FUNS_V2,COEF,OLD_V,OLD_R,ND_OLD
    
    J=0
    I=0
    WHILE (I LE (ND-1)) DO BEGIN
      IF (R[I] GE OLD_R[J+1]) THEN BEGIN
        T1=R[I]-OLD_R[J]
        V[I]=COEF[J,3]+T1*(COEF[J,2]+T1*(COEF[J,1]+T1*COEF[J,0]))
        SIGMA[I]=COEF[J,2]+T1*(2.0D0*COEF[J,1]+3.0*T1*COEF[J,0])
        SIGMA[I]=R[I]*SIGMA[I]/V[I]-1.0D0
        I=I+1
      ENDIF ELSE BEGIN
        J=J+1
      ENDELSE
    ENDWHILE

   END

'NEWG': BEGIN 
    PRINT, ''
    PRINT, 'This option allows the grid to be redefined'
    read,V_MAX,prompt='Maximum velocity for grid refinement'
    read,V_MIN,prompt='Initial velocity for grid refinement'
    IF (V_MAX GE OLD_V[0] OR V_MAX LE OLD_V[ND_OLD-1]) THEN BEGIN
      PRINT,'Error: cannot insert grid points outside velocity grid'
      STOP
    ENDIF
    IF (V_MIN GE OLD_V[0] OR V_MIN LE OLD_V[ND_OLD-1]) THEN BEGIN
      PRINT,'Error: can''t insert grid points outside velocity grid'
      STOP
    ENDIF

; Find interval --- Jose Groh: could be written more compact with near_val=MIN(ABS(V_MAX - OLD_V),I_ST)

    FOR I=0,ND_OLD-2 DO BEGIN
      IF (V_MAX GT OLD_V(I+1)) THEN BEGIN
        I_ST=I
        BREAK
      ENDIF
    ENDFOR
    
    IF (V_MAX-OLD_V(I+1) LT OLD_V(I)-V_MAX) THEN I_ST=I+1

    FOR I=0,ND_OLD-2 DO BEGIN
      IF (V_MIN GT OLD_V[I+1]) THEN BEGIN
        I_END=I
        BREAK
      ENDIF
    ENDFOR
    IF (V_MIN-OLD_V[I+1] LT OLD_V[I]-V_MIN) THEN I_END=I+1
    PRINT,' I_ST=',I_ST,OLD_V[I_ST]
    PRINT,' I_END=',I_END,OLD_V[I_END]
    PRINT,'Current number of points in interval is',I_END-I_ST-1
    read,N_ADD,prompt='Number of points in interval (exclusive)'

    ND=N_ADD+ND_OLD-(I_END-I_ST-1)
    v=dblarr(ND) & R=dblarr(ND) & sigma=dblarr(ND)
    V[0:I_ST]=OLD_V[0:I_ST]
    T1=EXP(ALOG(V_MAX/V_MIN)/(N_ADD+1))
    FOR I=I_ST+1,I_ST+N_ADD DO BEGIN
     V[I]=V[I-1]/T1
    ENDFOR
    V[I_ST+N_ADD+1:ND-1]=OLD_V[I_END:ND_OLD-1]

   ZE_CMFGEN_MON_INTERP,R,ND,IONE,V,ND,OLD_R,ND_OLD,OLD_V,ND_OLD 


; Now compute the revised SIGMA. V has already been computed.

    COEF=dblarr(ND_OLD,4)
    ZE_CMFGEN_MON_INT_FUNS_V2,COEF,OLD_V,OLD_R,ND_OLD
    J=0
    I=0
    WHILE (I LE (ND-1)) DO BEGIN
      IF (R[I] GE OLD_R[J+1]) THEN BEGIN
        T1=R[I]-OLD_R[J]
;;!      V(I)=COEF[J,3]+T1*(COEF[J,2]+T1*(COEF[J,1]+T1*COEF[J,0]))
        SIGMA[I]=COEF[J,2]+T1*(2.0D0*COEF[J,1]+3.0*T1*COEF[J,0])
        SIGMA[I]=R[I]*SIGMA[I]/V[I]-1.0D0
        I=I+1
      ENDIF ELSE BEGIN
        J=J+1
      ENDELSE
    ENDWHILE
   END

'MDOT': BEGIN 

    ND=ND_OLD
    v=dblarr(ND) & R=dblarr(ND) & sigma=dblarr(ND)
    READ,OLD_MDOT,PROMPT='Old mass-loss rate in Msun/yr'
    MDOT=OLD_MDOT
    READ,MDOT,PROMPT='New mass-loss rate in Msun/yr'
    READ,VINF,PROMPT='Velocity at infinity in km/s'
    READ,BETA,PROMPT='Beta for velocity law'
    READ,V_TRANS,PROMPT='Connection velocity in km/s'

    PRINT, ''
    PRINT, 'Type 1: W(r).V(r) = 2V(t) + (Vinf-2V(t))*(1-r(t)/r))**BETA'
    PRINT, 'Type 2: W(r).V(r) = Vinf*(1-rx/r)**BETA'
    PRINT, '        with W(r) = 1.0D0+exp( (r(t)-r)/h )'
    PRINT, '

    READ,VEL_TYPE,PROMPT='Velocity law to be used: 1 or 2'

; Find conection velocity and index.

    FOR I=0,ND_OLD -1 DO BEGIN
      IF(V_TRANS LE OLD_V[I] AND V_TRANS GE OLD_V[I+1]) THEN BEGIN
        TRANS_I=I
        BREAK
      ENDIF
    ENDFOR
    IF( OLD_V[TRANS_I]-V_TRANS GT V_TRANS-OLD_V[TRANS_I+1]) THEN TRANS_I=TRANS_I+1
    V_TRANS=OLD_V[TRANS_I]
    R[0:ND-1]=OLD_R[0:ND_OLD-1]

; In the hydrostatic region, the velocity is simply scaled by the change in
; mass-loss rate. This preserves the density. Only valid if wind does not have
; a significant optical depth.

    FOR I=TRANS_I-1, ND-1 DO BEGIN
      V[I]=MDOT*OLD_V[I]/OLD_MDOT
      SIGMA[I]=OLD_SIGMA[I]
    ENDFOR

; Now do the new wind law, keeping the same radius grid.

    R_TRANS=R[TRANS_I]
    V_TRANS=MDOT*V_TRANS/OLD_MDOT
    dVdR_TRANS=(SIGMA[TRANS_I]+1.0D0)*V_TRANS/R_TRANS

    IF (VEL_TYPE EQ 1) THEN BEGIN
      RO = R_TRANS * (1.0D0 - (2.0D0*V_TRANS/VINF)^(1.0D0/BETA) )
      T1= R_TRANS * dVdR_TRANS / V_TRANS
      SCALE_HEIGHT =  0.5D0*R_TRANS / (T1 - BETA*RO/(R_TRANS-RO) )
 
      PRINT, '  Transition radius is',R_TRANS
      PRINT, 'Transition velocity is',V_TRANS
      PRINT, '                 R0 is',RO
      PRINT, '       Scale height is',SCALE_HEIGHT
;!
      FOR I=0,TRANS_I-2 DO BEGIN
              T1=RO/R[I]
              T2=1.0D0-T1
              TOP = VINF* (T2^BETA)
              BOT = 1.0D0 + exp( (R_TRANS-R[I])/SCALE_HEIGHT )
              V[I] = TOP/BOT
                                                                                
;NB: We drop a minus sign in dBOTdR, which is fixed in the next line.
                                                                                
              dTOPdR = VINF * BETA * T1 / R[I] * T2^(BETA - 1.0D0)
              dBOTdR=  exp( (R_TRANS-R[I])/SCALE_HEIGHT )  / SCALE_HEIGHT
              dVdR = dTOPdR / BOT  + V[I]*dBOTdR/BOT
              SIGMA[I]=R[I]*dVdR/V[I]-1.0D0
      ENDFOR
    ENDIF ELSE BEGIN
      SCALE_HEIGHT = V_TRANS / (2.0D0 * DVDR_TRANS)
      PRINT, '  Transition radius is',R_TRANS
      PRINT, 'Transition velocity is',V_TRANS
      PRINT, '       Scale height is',SCALE_HEIGHT
      FOR I=0,TRANS_I-2 DO BEGIN
        T1=R_TRANS/R[I]
        T2=1.0D0-T1
        TOP = 2.0D0*V_TRANS + (VINF-2.0D0*V_TRANS) * T2^BETA
        BOT = 1.0D0 + exp( (R_TRANS-R[I])/SCALE_HEIGHT )
        V[I] = TOP/BOT
                                                                                
;NB: We drop a minus sign in dBOTdR, which is fixed in the next line.
                                                                                
        dTOPdR = (VINF - 2.0D0*V_TRANS) * BETA * T1 / R[I] * T2^(BETA - 1.0D0)
        dBOTdR=  exp( (R_TRANS-R[I])/SCALE_HEIGHT ) / SCALE_HEIGHT
        dVdR = dTOPdR / BOT  + TOP*dBOTdR/BOT/BOT
        SIGMA[I]=R[I]*dVdR/V[I]-1.0D0
      ENDFOR
    ENDELSE   
   END
   
ENDCASE
END
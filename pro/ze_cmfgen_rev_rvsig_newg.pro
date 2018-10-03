;PRO ZE_CMFGEN_REV_RVSIG_NEWG
;John Hillier's CMFGEN routine misc/rev_rvsig.f for 'NEWG' option
;revises the radial grid between two velocities
;converted to IDL by Jose Groh

IONE=1

;read old RVSIG_COL file
READCOL,'/Users/jgroh/ze_models/timedep_armagh//41/RVSIG_COL_NEW_v150_beta1',OLD_R,OLD_V,OLD_SIGMA,OLD_DEPTH,COMMENT='!',F='D,D'
ND_OLD=n_elements(OLD_R)

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
    ZE_CMFGEN_MON_INT_FUNS_V2,COEF,OLD_V,OLD_R,ND_OLD,H,S,D
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
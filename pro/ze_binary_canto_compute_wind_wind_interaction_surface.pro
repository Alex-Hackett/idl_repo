;PRO ZE_BINARY_CANTO_COMPUTE_WIND_WIND_INTERACTION_SURFACE
;needs to run ze_read_2d_rv_data_v5 of comment 1st line bbelow
r_val=r
b=betaang

beta=4.2 ;inverse of eta
mdota=0.84e-3
vinfa=420.
mdotb=1e-5
vinfb=3000.
beta=mdota*vinfa/(mdotb*vinfb)
print,beta
R0=14.6  ;in AU
AU_TO_CM=1.496e+13
CM_TO_CMFGEN=1e-10
;R0=r0*AU_TO_CM*CM_TO_CMFGEN
D=R0*(1.0+SQRT(beta))/SQRT(beta)

nbtot=151.
theta=DBLARR(nbtot/2.)
For I=0, nbtot/2-1 DO theta[i]=0.000001+ i*90.0/(nbtot-1)


DEG_TO_RAD=!PI/180.0
theta_rad=theta*DEG_TO_RAD


theta_rad=betaang

;approximation for theta1, equation 26 Canto, Raga, Wilkin 1996
theta1_rad=SQRT(7.5*(-1.0+SQRT(1.0 + 0.8*beta*(1.0-theta_rad/TAN(theta_rad)))))

r=dblarr(nbtot/2.)
fOR i=1, NBTOT/2-1 DO R[i]=D * SIN(theta1_rad[i]) * 1.0/SIN(theta_rad[i]+theta1_Rad[i])
r[0]=r0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')


window,3,xsize=600,ysize=600
plot,/polar, r, theta_rad,xrange=[-35,35],yrange=[-35,35]


;   FOR I=0,NB/2 DO BEGIN
;      FOR J=0,ND-1 DO BEGIN
;      ;changed from CRIT_INDX to 31 to put the apex of the shock cone at d=19 AU
;
;        theta1_rad=SQRT(7.5*(-1.0+SQRT(1.0 + 0.8*beta*(1.0-theta_rad/TAN(theta_rad)))))
;        IF (I .EQ. 0) THEN 
;         R_CRW=R(RP1)
;        ELSE
;         R_CRW =  D_CRW * SIN(THETA1_RAD) * 1.0/SIN(B(I)+THETA1_RAD) !R_CRW is the shock cone  from CAnto et al. 1996
;        ENDIF
;!       R_CRW_INC_WALL= D * SIN(THETA1_RAD) * 1.0/SIN(B(I)+THETA1_RAD) !R_CRW is the shock cone  from CAnto et al. 1996
;        R_PRIME=R(J)/COS(B(I)+0.000001)                         ! R PRIME is the distance of the grid point to the star, we sum a small value
;        WRITE(LUER,*),I,J,R(J),B(I),THETA1_RAD,R_CRW,R_PRIME,D_CRW
;        IF (R_CRW .LT. 0) THEN
;         ROT_DEN(J,I)=DP2
;         ROT_DEN(J,NB+1-I)=ROT_DEN(J,I)
;        ELSEIF (R_PRIME*1.03 .GT. R_CRW) THEN
;         ROT_DEN(J,I)=DP1       !DP3 is the density factor to deplete neutral hydrogen population
;         ROT_DEN(J,NB+1-I)=DP2  !DP2 is the scale factor of the density of the primary wind, default=1
;        ELSE
;         ROT_DEN(J,I)=DP2
;         ROT_DEN(J,NB+1-I)=ROT_DEN(J,I)
;        ENDIF   
;    END DO
;    ENDDO


r_crw1=r
END
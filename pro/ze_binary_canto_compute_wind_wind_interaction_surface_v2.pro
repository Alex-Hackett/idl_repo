;PRO ZE_BINARY_CANTO_COMPUTE_WIND_WIND_INTERACTION_SURFACE_V2
DEG_TO_RAD=!PI/180.0D
;needs to run ze_read_2d_rv_data_v5 of comment 1st line bbelow
r_val=r1
b=betaang
nb=n_elements(b)
nd=n_elements(r)

rot_den=dblarr(nd,nb)
r_prime=rot_den
r_crw=dblarr(nb)
r_crw_inner_wall=r_crw
rot_den[*,*]=1.0
rp1=93
dp1=0.04
dp2=1.
DELTA_ALPHA_DEG=3.0 ;in degrees
DELTA_ALPHA=DELTA_ALPHA_DEG*DEG_TO_RAD
mdota=0.5e-3
vinfa=500.
mdotb=1e-5
vinfb=3000.
beta_crw=mdota*vinfa/(mdotb*vinfb)
print,beta_crw
R0=14.6  ;in AU
AU_TO_CM=1.496e+13
CM_TO_CMFGEN=1e-10
R0=r0*AU_TO_CM*CM_TO_CMFGEN
D_CRW=R0*(1.0+SQRT(beta_crw))/SQRT(beta_crw)
;scpecify D_CRW to be physically consistent
D_CRW=21.9 ;in AU
;D_CRW=D_CRW*AU_TO_CM*CM_TO_CMFGEN
R_0=D_CRW*SQRT(beta_crw)/(1.0+SQRT(beta_crw))

DEG_TO_RAD=!PI/180.0
theta=b/DEG_TO_RAD

;approximation for theta1, equation 26 Canto, Raga, Wilkin 1996
;theta1_rad=SQRT(7.5*(-1.0+SQRT(1.0 + 0.8*beta*(1.0-theta_rad/TAN(theta_rad)))))

;r=dblarr(nbtot/2.)
;fOR i=1, NBTOT/2-1 DO R[i]=D * SIN(theta1_rad[i]) * 1.0/SIN(theta_rad[i]+theta1_Rad[i])
;r[0]=r0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')



   FOR I=0,NB/2 DO BEGIN
      FOR J=0,ND-1 DO BEGIN
      
        IF (I EQ 0) THEN BEGIN
         R_CRW[i]=R_0
         r_crw_inner_wall[i]=R_CRW[i]
        ENDIF ELSE BEGIN
         theta1_rad=SQRT(7.5*(-1.0+SQRT(1.0 + 0.8*beta_crw*(1.0-B[i]/TAN(B[i])))))
         R_CRW[i] =  D_CRW * SIN(THETA1_RAD) * 1.0/SIN(B[I]+THETA1_RAD) ;R_CRW is the shock cone  from CAnto et al. 1996
         theta1_rad_wall=SQRT(7.5*(-1.0+SQRT(1.0 + 0.8*beta_crw*(1.0-(B[i]-DELTA_ALPHA)/TAN(B[i]-DELTA_ALPHA)))))
         IF B[i] LT DELTA_ALPHA THEN BEGIN
          r_crw_inner_wall[i]= R_CRW[i]
         ENDIF ELSE BEGIN
          r_crw_inner_wall[i] =  D_CRW * SIN(THETA1_RAD_WALL) * 1.0/SIN(B[I]-DELTA_ALPHA+THETA1_RAD_WALL) ;R_CRW is the shock cone  from CAnto et al. 1996                  
         ENDELSE
        ENDELSE
;       R_CRW_INC_WALL= D * SIN(THETA1_RAD) * 1.0/SIN(B(I)+THETA1_RAD) ;R_CRW is the shock cone  from CAnto et al. 1996
        R_PRIME[j,i]=R_VAL[J]/COS(B[I])                        ; ! R PRIME is the distance of the grid point to the star, we sum a small value
 ;       WRITE(LUER,*),I,J,R(J),B(I),THETA1_RAD,R_CRW,R_PRIME,D_CRW
        IF (R_CRW[i] LT 0) THEN BEGIN
         IF (R_PRIME[j,i]*1.04 GT R_CRW[i]) THEN BEGIN
         ROT_DEN[J,I]=DP1       ;!DP3 is the density factor to deplete neutral hydrogen population
         ROT_DEN[J,NB-I-1]=DP2 ; !DP2 is the scale factor of the density of the primary wind, default=1
         ENDIF
         ROT_DEN[J,I]=DP2
         ROT_DEN[J,NB-I-1]=ROT_DEN[J,I]
        ENDIF
        IF (R_PRIME[j,i]*1.04 GT R_CRW[i]) THEN BEGIN
         ROT_DEN[J,I]=DP1       ;!DP3 is the density factor to deplete neutral hydrogen population
         ROT_DEN[J,NB-I-1]=DP2 ; !DP2 is the scale factor of the density of the primary wind, default=1
        ENDIF

    ENDFOR
    ENDFOR
window,3,xsize=800,ysize=800
plot,/polar, r_crw[0:50], b[0:50],linestyle=0,xrange=[0,50],yrange=[0,50]
oplot,/polar, r_crw[0:50], b[0:50],psym=1
;oplot,/polar, r_crw_inner_wall[0:70], b[0:70],linestyle=0,color=fsc_color('red')
;oplot,/polar, r_crw_inner_wall[0:50], b[0:50],psym=1,color=fsc_color('red')
;FOR i=0,80,1 DO oplot,/polar, r_val,REPLICATE(b[i],nd),psym=2,color=fsc_color('blue')
;oplot,/polar, r_val,REPLICATE(b[39],nd),linestyle=2,color=fsc_color('orange')
;oplot,/polar,[r_val[80],r_val[80]],[b[39],b[42]],psym=4,color=fsc_color('green'),symsize=1.0,thick=3

;oplot,/polar, r_crw1[0:10], theta_rad[0:10],color=fsc_color('red')
;oplot,/polar, r_crw1[0:10], theta_rad[0:10],psym=2,color=fsc_color('red')
END
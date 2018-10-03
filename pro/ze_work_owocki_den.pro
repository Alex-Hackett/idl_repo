;PRO ZE_WORK_OWOCKI_DEN

;conclusion: we need the 90 deg datapoint, and that only happens if (NB -1) is multiple of 4.
;conclusion 2: if using variable alpha, we need at least 50 beta points.
omega=0.95
GAM_ES=0.5
QBAR=1000.
ALPHAPOL=0.66
ALPHAEQ=0.6
ALPHALAT=80.
ALPHALAT=ALPHALAT*!PI/180.0

DP1=3.
DP2=2.


beta=151.*1.
beta_vec=dblarr(beta)
FOR I=0, beta-1 DO Beta_vec(I)=0.D0+(I+0.D0)*(2.D0*ACOS(-1.D0))/(beta-1.D0)  ;for now don't assume top-bottom symmetry 
FOR I=0, beta-1 DO Beta_vec(I)=0.D0+(I+0.D0)*(2.D0*ACOS(-1.D0))/(beta-1.D0)  ;for now don't assume top-bottom symmetry 
;print,beta_vec

; Normalize so that integral is 1. Thus the average mass-loss rate is
; preserved. Note that the mass-loss rate is proportional to Int dmu.
;normalization constant T1; T3=mu=cos(theta)
T2=2.0D0/(1000.D0-1.0D0)  ; this is dx in the trap integration
T1=0.0D0
FOR I=1, 998 DO BEGIN
      T3=ABS( 1.0D0-(I-1.0D0)*T2 )
 ;     T1=T1+T2*(1.D0+DP1*(1-T3*T3)^DP2) ;for oblate
  ;     T1=T1+T2*((1.D0-omega*(1.-T3*T3))^0.5) ; owocki constant alpha 
      ; IF (T3 - COS(beta_vec(ALPHALAT)) GE 0.0) THEN T1=T1+T2*((1.D0-omega*(1.-T3*T3))^0.5)*(GAM_ES*QBAR)^(1.0D0/ALPHAPOL-1.0D0/ALPHAPOL) ELSE T1=T1+T2*((1.D0-omega*(1.-T3*T3))^0.5)*(GAM_ES*QBAR)^(1.0D0/ALPHAEQ-1.0D0/ALPHAPOL)    
       IF (T3 - COS(ALPHALAT) GE 0.0) THEN T1=T1+T2*((1.D0-omega*(1.-T3*T3))^0.5)*(GAM_ES*QBAR)^(1.0D0/ALPHAPOL-1.0D0/ALPHAPOL) ELSE T1=T1+T2*((1.D0-omega*(1.-T3*T3))^0.5)*(GAM_ES*QBAR)^(1.0D0/ALPHAEQ-1.0D0/ALPHAPOL)    
       print,t1,t3
ENDFOR
;T1=T1+T2      ;end values, where MU=pm1, and Den. fun=1      Ze: CORRECT
T1=T1+T2*(1+omega)     ;end values, where MU=pm1, and Den. fun=1      Ze: trying
T1=2.0D0/T1


dencon_owocki=T1*(1-omega*SIN(beta_vec)^2)^0.5

dencon_owovar=beta_vec
dencon_owovar[*]=1.0

FOR i=0, beta-1 DO BEGIN
    IF (ABS(SIN(beta_vec(i))) - SIN(ALPHALAT) LE 0.005) THEN dencon_owovar[i]=T1*(1-omega*SIN(beta_vec[i])^2)^0.5*(GAM_ES*QBAR)^(1.0D0/ALPHAPOL-1.0D0/ALPHAPOL) ELSE $
     dencon_owovar[i]=T1*(1-omega*SIN(beta_vec[i])^2)^0.5*(GAM_ES*QBAR)^(1.0D0/ALPHAEQ-1.0D0/ALPHAPOL)
ENDFOR

 ;   print,dencon_owovar
 ;   print,ABS(SIN(beta_vec)) - SIN(beta_vec(ALPHALAT))
dencon_oblate=T1*(1.D0+DP1*(1.0D0-COS(beta_vec)^2)^DP2)
;print,dencon_oblate

;dencon=dencon_owocki
dencon=dencon_owovar
;dencon=dencon_oblate
;print,dencon

M1=0.0D
FOR I=0, beta/2-1 DO BEGIN
M1=M1+0.25D0*(dencon(i)+dencon(I+1))*(COS(beta_vec(I))-COS(beta_vec(I+1)))
print,M1
ENDFOR
print,'Beta/2', beta_vec[beta/2]

W=0.95 ;vrot/vcrit
tstar_pole=37920.0
;changes of Tstar as a function of latitude according to Von Zeipel 1924
Tstar_on_tpole= (1.D0-W^2* SIN(beta_vec)^2)^0.25
tstar_vz=tstar_pole*Tstar_on_tpole

omega_vec=[0.3,0.5,0.6,0.7,0.8,0.85,0.9,0.95,0.97,0.99]
print,omega_vec
print,sqrt(omega_vec)
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
lineplot,beta_vec*180./!PI,tstar_vz

;lineplot,beta_vec*180./!PI, dencon_owovar
END

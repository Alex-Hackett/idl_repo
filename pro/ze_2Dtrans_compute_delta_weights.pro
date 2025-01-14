NDELTA_CG=25.
NDELTA_FG=25.
DELTA1=DBLARR(NDELTA_CG)
DELTA2=DBLARR(NDELTA_FG)
DELTA2_WGHTS=DBLARR(NDELTA_FG)
MU=DBLARR(NP)

; Determine Delta1 and Delta2 angles
;
FOR i=0,NDELTA_CG-1 DO BEGIN
	  DELTA1(i)=0.D0+(i-0.D0)*(2.D0*ACOS(-1.D0))/(NDELTA_CG-1.D0)
ENDFOR	
FOR i=0,NDELTA_FG-1 DO BEGIN
	  DELTA2(I)=0.D0+(I-0.D0)*(2.D0*ACOS(-1.D0))/(NDELTA_FG-1.D0)
ENDFOR

;
; Determine integration weights over delta2
;
	DELTA2_WGHTS(*)=0.D0
	FOR I=0,NDELTA_FG-2 DO BEGIN
	  T1=0.5D0*(DELTA2(I+1)-DELTA2(I))
	  PRINT,T1
	  DELTA2_WGHTS(I)=DELTA2_WGHTS(I)+T1
	  DELTA2_WGHTS(I+1)=DELTA2_WGHTS(I+1)+T1
	ENDFOR
	T1=0.D0
	FOR I=0,NDELTA_FG-1 DO BEGIN
	  T1=T1+DELTA2_WGHTS(I)
	ENDFOR


;
; By definition, p * dp equals R**2 * mu * dmu. Integration over mu is
; more stable, and is to be preferred. To get better accuracy with the
; integration, NORDULUND weights will be used (Changed 11-Dec-1986).
;
	T1=R(1)*R(1)
	FOR LS=0,NP-1 DO BEGIN
	  MU(LS)=SQRT(T1-P(LS)*P(LS))/R(1)
	ENDFOR
	ZE_HWEIGHT,MU,HQW_AT_RMAX,NP

END

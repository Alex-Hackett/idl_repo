; Subroutine to perform integration using a fit by a cubic polynomial.
; Based on NAG routin D01GAF which is in turn based on the work of
; Gill and Miller.
;
;
; Altered 24-May-1996 - ERROR_LU installed.
; Altered 07-Jan-1991 - Main loop made vectozable by separating computation
;                     of total integrand.
; Altered 29-Jan-1987 - Error handling for non monotonic function inserted.
; Created 29-APR-1985

        PRO ZE_INTEGRATE,X,F,TA,IFAIL,ND

     ;   X=dblarr(ND) & F=X & TA=X
     TA=dblarr(ND)
     
      print,x,f,nd
	if ND lt 4 then begin
	  print,'Error in INTEGRATE - not enough points'
	  IFAIL=1  
	ENDIF

	IF X[ND-1] gt X[1] then begin
	  FOR I=0, ND-2 DO BEGIN
	    IF(X[I+1] LT X[I]) THEN BEGIN
	      print,'Error in INTEGRATE - X function not monotonic'
	      IFAIL=2
	    ENDIF
	  ENDFOR
	ENDIF ELSE BEGIN
            FOR I=0,ND-2 DO BEGIN
	    IF (X[I+1] GT X[I]) THEN BEGIN
	      print,'Error in INTEGRATE - X function not monotonic'
	      IFAIL=2
	    ENDIF
	  ENDFOR
	ENDELSE

; Initialize values.

	IFAIL=0
	H0=X[1]-X[0]
	H1=X[2]-X[1]
	H2=X[3]-X[2]

	F01=(F[1]-F[0])/H0
	F12=(F[2]-F[1])/H1
	F23=(F[3]-F[2])/H2

	F012=(F12-F01)/(X[2]-X[0])
	F123=(F23-F12)/(X[3]-X[1])

	F0123=(F123-F012)/(X[3]-X[0])

; Compute integral for first step.

	TA[0]=H0*(F[0]+0.5*H0*(F01-H0*(F012/3.0D0-(H0*0.5+(H1-H0)/3.0)*F0123)))

; Compute integral for all subsequent steps. We first evaluate DINT
; (but store in TA) so that loop is vectorizable. The total integrand
; is subsequently formed in a non-vectorizable do loop.

	FOR I=1,ND-3 DO BEGIN

	  IF I ne 1 THEN BEGIN
	    H0=H1
	    H1=H2
	    F01=F12
	    F12=F23
	    F012=F123
	  ENDIF

	  H2=(X[I+2]-X[I+1])
	  F23=(F[I+2]-F[I+1])/H2
	  F123=(F23-F12)/(X[I+2]-X[I])
	  F0123=(F123-F012)/(X[I+2]-X[I-1])

	  TA[I]=0.5*H1*(F[I]+F[I+1]-H1*H1/6.0*(F012+F123+(H0-H2)*F0123))

	ENDFOR

	FOR I=1,ND-3 DO BEGIN
	  TA[I]=TA[I]+TA[I-1]
	ENDFOR

; Compute integral for last step.

	TA[ND-1]=TA[ND-3]+H2*(F[ND-1]-H2*(0.5*F23+H2*(F123/6.0+F0123*(0.25*H2+(H1-H2)/6.0))))

	IFAIL=0

	END

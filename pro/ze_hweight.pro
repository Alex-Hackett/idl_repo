; CONVERTED TO IDL BY JOSE GROH (MPIfR) FROM JOHN HILLIER's HWEIGHT.F
;
;
; Subroutine to compute the quadrature weights for a modified cubic rule.
; Reference - A Nordlund (Methods in Radiative Transfer, W Kallofen).
; The routine makes specific assumptions concerning the behaviour of the
; flux at the boundary, and would need to be moified to obtain  other
; quantities other than 1st moment of the intensity. The program assumes
; that the first point corresponds to mu=1.0 .
; 
; Note that these weights should not be normalized in the usual fashion. 
; Physically, we dont expect V (the flux) to be constant with respect to mu.
; For small mu, we expect a that V is proportional to mu.
;
; D1, and R2 are work vectors.
;
	PRO ZE_HWEIGHT,X,N,W
;	IMPLICIT NONE
;
; Altered 24-May-1996 - Call to DP_ZERO deleted.
;                       ERROR_LU,LUER installed.
; Altered 25-Feb-1987 - Normalization implemented.
; Altered 14-Jan-87 - Program nolonger assumes that X(N)=0, since can
;                     assume X(N+1)=0 with W(N+1)=0.0 with out loss of
;                     accuracy.
; Created 25-Nov-1986 (Based on KWEIGHT)
;
	I=N
	W=DBLARR(N) & H=1.0 & HN=H & RF=H & RE=H & SUM=H
;
	LUER=1 & ERROR_LU=1
;	EXTERNAL ERROR_LU
;
;	LUER=ERROR_LU()
	W(*)=0.0D0
;
	H=X(0)-X(1)
	HN=X(1)-X(2)
	RF=X(0)-X(2)
	W(0)=0.5*H*(X(0)-H/6.0D0) - H*H/RF/12.0*((2.0D0+HN/H)*X(0)-X(1))
	W(1)=0.5*H*(X(1)+H/6.0D0) + H*H/RF/12.0D0*(2.0+H/HN+HN/H)*X(0)
	W(2)=-H*H/RF/12.0*(X(1)+H/HN*X(0))
  
; CONVERTED UNTIL HERE, NOT SURE ABOUT THE REST


	FOR I=2,N-2 DO BEGIN  ;JOSE NOTE: CHANGED N-1 to N-2 
	  H=X(I-1)-X(I)
	  RF=X(I-2)-X(I)
	  RE=X(I-1)-X(I+1)
	  W(I-2)=W(I-2)-X(I-1)*H*H/12.0/RF
	  W(I-1)=W(I-1)+0.5*H*(X(I-1)-H/6.0D0) +X(I)*H*H/12.0/RE
	  W(I)=W(I)+0.5*H*(X(I)+H/6.0D0) +X(I-1)*H*H/12.0/RF
	  W(I+1)=W(I+1)-X(I)*H*H/12.0/RE
	ENDFOR
         
;
; Assumes that V(mu=0)=0 and mu.V'(mu)=0 at mu=0. 
;
	IF(X(N-1)=0) THEN BEGIN
	  H=X(N-2)
	  W(N-2)=W(N-2)+H*H/3.0D0
	ENDIF ELSE BEGIN

; Since V(mu=0) is zero, we dont actually need a ray with mu=0 since the weight
; is automatically zero.
;
; Integral from X(N-2) to X(N-1)
;
	  H=X(N-2)-X(N-1)
	  RF=X(N-3)-X(N-1)
	  RE=X(N-2)				; As X(N)=0
	  W(N-3)=W(N-3)-X(N-2)*H*H/12.0/RF
	  W(N-2)=W(N-2)+0.5*H*(X(N-2)-H/6.0D0) +X(N-1)*H*H/12.0/RE
	  W(N-1)=W(N-1)+0.5*H*(X(N-1)+H/6.0D0) + X(I-1)*H*H/12.0/RF
;
; Integral from X(N-1) to X(N)
;
	  H=X(N-1)
	  W(N-1)=W(N-1)+H*H/3.0D0
	  ; WRITE(lUER,*)'Warning - Extrapolation to zero required in HWEIGHT'
	ENDELSE
	
;
;; Ensure that the weights have the correct normalization (but dont
;; perform the normalization). 
;;
	SUM=0.0D0
	FOR I=0,N-1 DO BEGIN
	  SUM=SUM+W(I)*X(I)
	ENDFOR
	SUM=1.0D0/SUM/3.0D0
	IF(ABS(SUM-1.0D0) GT 1.0D-12) THEN BEGIN
	PRINT,' Warning - weights require normalization in HWEIGHT'
	ENDIF
;;
;;
;	
	END

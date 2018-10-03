PRO	funct_gauss,X,A,F,isel,PDER
;
; Compute guassian for use by curfit
;
	Z = (X-A(1))/A(2)	;GET Z
	EZ = EXP(-Z^2/2.)*(ABS(Z) LE 7.) ;GAUSSIAN PART IGNORE SMALL TERMS
        F = A(0)*EZ
	IF N_PARAMS(0) LE 3 THEN RETURN ;NEED PARTIAL?
;
; compute partial direvatives
;
	PDER = FLTARR(N_ELEMENTS(X),n_elements(isel)) ;YES, MAKE ARRAY.
	for i=0,n_elements(isel)-1 do begin
	    case isel(i) of

		0: PDER(0,i) = EZ
		1: PDER(0,i) = A(0) * EZ * Z/A(2)
		2: PDER(0,i) = PDER(*,1) * Z
	    endcase
	endfor
	RETURN
END


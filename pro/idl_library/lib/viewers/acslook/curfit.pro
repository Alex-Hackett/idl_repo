;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+
;
;*NAME:
;	CURFIT
;
; CATEGORY:
;	Curve and Surface Fitting
;
;*PURPOSE:
;	Non-linear least squares fit to a function of an
;	arbitrary number of parameters.
;	Function may be any non-linear function where
;	the partial derivatives are known or can be approximated.
;
;*CALLING SEQUENCE:
;	YFIT = CURFIT(X,Y,FUNCNAME,A,ISEL,W,SIGMAA)
;
;*PARAMETERS:
; INPUTS:
;	X = Row vector of independent variables.
;	Y = Row vector of dependent variable, same length as x.
;	FUNCNAME = Name of the fitting function (string)
;	A = Vector of nterms length containing the initial estimate
;		for each parameter.  If A is double precision, calculations
;		are performed in double precision, otherwise in single prec.
; 	
; OPTIONAL INPUT PARAMETERS:
;	ISEL - Vector of parameters in A to fit.  Other parameters are
;		not changed but only used in the function computation.
;	W = Row vector of weights, same length as x and y.
;		For no weighting
;		w(i) = 1., instrumental weighting w(i) =
;		1./y(i), etc.
;
; OUTPUTS:
;	A = Vector of parameters containing fit.
;	Function result = YFIT = Vector of calculated
;		values.
; OPTIONAL OUTPUT PARAMETERS:
;	Sigmaa = Vector of standard deviations for parameters
;		A.
;	
;
; SIDE EFFECTS:
;	The function to be fit must be defined and called by the name
;	given in FUNCNAME.
;
;	For an example see FUNCT in the IDL User's Libaray.
;	Call to FUNCT is:
;	FUNCT,X,A,F,ISEL,PDER
; where:
;	X = Vector of NPOINT independent variables, input.
;	A = Vector of NTERMS function parameters, input.
;	F = Vector of NPOINT values of function, y(i) = funct(x(i)), output.
;	ISEL = parameters to be fitted
;	PDER = Array, (NPOINT, NTERMS), of partial derivatives of funct.
;		PDER(I,J) = DErivative of function at ith point with
;		respect to jth parameter.  Optional output parameter.
;		PDER should not be calculated if parameter is not
;		supplied in call (Unless you want to waste some time).
;
;*PROCEDURE:
;	Copied from "CURFIT", least squares fit to a non-linear
;	function, pages 237-239, Bevington, Data Reduction and Error
;	Analysis for the Physical Sciences.
;
;	"This method is the Gradient-expansion algorithm which
;	compines the best features of the gradient search with
;	the method of linearizing the fitting function."
;
;	Iterations are perform until the chi square changes by
;	only 0.1% or until 20 iterations have been performed.
;
;	The initial guess of the parameter values should be
;	as close to the actual values as possible or the solution
;	may not converge.
;
;*MODIFICATION HISTORY:
;	Written, DMS, RSI, September, 1982.
;	Don Lindler, Sept, 1987, added optional function name parameter,
;		and ISEL parameter.
;       Mar 14 1991      JKF/ACC    - moved to GHRS DAF (IDL Version 2)
;	Sep 05 1995	 JKF/ACC    - handled NAN condition
;-
;-------------------------------------------------------------------------------
FUNCTION CURFIT,X,Y,FUNCNAME,A,ISEL,W,SIGMAA
;
; SET DEFAULT PARAMETERS
;
	IF N_PARAMS(0) LT 6 THEN W=Y*0+1
	IF N_PARAMS(0) LT 5 THEN ISEL=INDGEN(N_ELEMENTS(A))
	A = 1.*A			;MAKE PARAMS FLOATING
	NTERMS = n_elements(isel)		;# OF PARAMS.
	NFREE = (N_ELEMENTS(Y)<N_ELEMENTS(X))-NTERMS ;Degs of freedom
	IF NFREE LE 0 THEN STOP,'Curvefit - not enough data points.'
	FLAMBDA = 0.001		;Initial lambda
	DIAG = INDGEN(NTERMS)*(NTERMS+1) ;SUBSCRIPTS OF DIAGONAL ELEMENTS
;
	FOR ITER = 1,20 DO BEGIN	;Iteration loop
;
;		EVALUATE ALPHA AND BETA MATRICIES.
;
	STATUS=EXECUTE(FUNCNAME+',X,A,YFIT,ISEL,PDER')
	BETA = (Y-YFIT)*W # PDER
	ALPHA = TRANSPOSE(PDER) # (W # (FLTARR(NTERMS)+1)*PDER)
;
	CHISQ1 = TOTAL(W*(Y-YFIT)^2)/NFREE ;PRESENT CHI SQUARED.
;
;	INVERT MODIFIED CURVATURE MATRIX TO FIND NEW PARAMETERS.
;
	REPEAT BEGIN
		C = SQRT(ALPHA(DIAG) # ALPHA(DIAG))
		ARRAY = ALPHA/C
		ARRAY(DIAG) = 1.+FLAMBDA
		ARRAY = INVERT(ARRAY)
		B = A
		B(ISEL) = A(ISEL) + ARRAY/C # TRANSPOSE(BETA) ;NEW PARAMS
		STATUS=EXECUTE(FUNCNAME+',X,B,YFIT,ISEL')
		CHISQR = TOTAL(W*(Y-YFIT)^2)/NFREE ;NEW CHISQR

;
; 	Check for NAN...if NAN, abort routine and return YFIT= 0
; 	10/5/95		JKF/ACC	 - added test for NAN
;
		nan = wherenan(chisqr,nan_count)
		if nan_count gt 0 then begin
			;
			; Set all values for variable SIGMAA to NAN as 
			; indicator that the fit did not converge.
			;
			case datatype(chisqr) of
				'FLO': chisqr = !values.f_nan
				'DOU': chisqr = !values.d_nan
				else: $
				   message,/info,' Invalid CHISQR computed- NAN'
			endcase				

			PRINT,'CURFIT - Failed to converge'
			sigmaa = array(diag) * 0. + chisqr
			return,yfit
		end
;
		FLAMBDA = FLAMBDA*10.	;ASSUME FIT GOT WORSE
		ENDREP UNTIL CHISQR LE CHISQ1
;
	FLAMBDA = FLAMBDA/100.	;DECREASE FLAMBDA BY FACTOR OF 10
	A=B			;SAVE NEW PARAMETER ESTIMATE.
	IF !debug GT 1 THEN BEGIN
		PRINT,'ITERATION =',ITER,' ,CHISQR =',CHISQR,CHISQ1
		PRINT,A
	ENDIF
	IF ((CHISQ1-CHISQR)/CHISQ1) LE .001 THEN GOTO,DONE ;Finished?
	ENDFOR			;ITERATION LOOP
;
	PRINT,'CURFIT - Failed to converge'
;
DONE:	
	SIGMAA = SQRT(ARRAY(DIAG)/ALPHA(DIAG)) ;RETURN SIGMA'S
	RETURN,YFIT		;RETURN RESULT
END

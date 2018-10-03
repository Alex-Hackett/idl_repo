;+
;			plane_fit
;
; Routine to fit a least squares plane
;
; CALLING SEQUENCE:
;	coef = plane_fit(x,y,z,zfit,weights=weights)
;
; INPUTS:
;	x - vector of x positions
;	y - vector of y positions
;	z - vector of z positions to fit as a function of x and y
;
; OPTIONAL KEYWORD INPUTS:
;	weigths = vector of wieghts (default = 1.0 for all data points)
;
; OUTPUTS:
;	coefficents of the fit are returned as the function results
;	
;	zfit = coef(0) + coef(1)*x + coef(2)*y
; 
; HISTORY:
;	version 1  D. Lindler  May 4, 1999
;-
;--------------------------------------------------------------------------
function plane_fit,x,y,z,zfit,weights=weights


	if n_params(0) eq 0 then begin
		print,'coef = plane_fit(x,y,z,zfit,weights=weights)'
		return,0
	end
	
	n = n_elements(x)
	xx = dblarr(n,2)
	xx(*,0) = x
	xx(*,1) = y	
	if n_elements(weights) eq 0 then weights = replicate(1.0,n)
	coef = regress(transpose(xx),z,weights,zfit,c0)
	return,[c0,transpose(coef)]
end

; $Id: svdleg.pro,v 1.4 1997/08/28 17:11:16 slett Exp $

function svdleg,X,M
;
;       Legendre polynomial basis function 
;       generator for SVDFIT,/LEGENDRE
;
        XX=X[0]                   ; ensure scalar XX
	sz=reverse(size(XX))      ; use size to get the type
        IF sz[n_elements(sz)-2] EQ 5 THEN $
                basis=DBLARR(M) else basis=FLTARR(M)
;
;       Calculate and return the basis functions
;
	d=(basis[0]=1.0)
        IF M ge 2 THEN f2=(basis[1]=XX)
	FOR i=2,M-1 DO BEGIN
	    f1 = d
            d  = d + 1.0
	    f2 = f2 + 2.0*XX
	    basis[i] = (f2*basis[i-1] - f1*basis[i-2] ) / d
	ENDFOR
	return,basis
end

; $Id: lmfunct.pro,v 1.11 2005/02/01 20:24:27 scottm Exp $
;
; Copyright (c) 1988-2005, Research Systems, Inc.  All rights reserved.
;       Unauthorized reproduction prohibited.

function lmfunct,x,a
;
;       Return a vector appropriate for LMFIT
;
;       The function being fit is of the following form:
;          F(x) = A(0) + A(1)*X + A(2)*X*X 
;
;       dF/dA(0) is dF(x)/dA(0) = 1.0
;       dF/dA(1) is dF(x)/dA(1) = X
;       dF/dA(2) is dF(x)/dA(2) = X*X
;
;       return,[[F(x)],[dF/dA(0)],[dF/dA(1)],[dF/dA(2)]]
;
;       Note: returning the required function in this manner
;             ensures that if X is double the returned vector
;             is also of type double. Other methods, such as
;             evaluating size(x) are also valid.
;
        return,[ [A[0]+A[1]*X+A[2]*X*X],[1.0], [X], [X*X] ]
end

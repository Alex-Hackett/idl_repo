PRO ZE_CMFGEN_MON_INT_FUNS_V2,COEF,CHI,R,ND,H,S,D
;John Hillier's CMFGEN routine subs/mon_int_funs_v2.f
;converted to IDL by Jose Groh
;
; Subroutine to define the cubic interpolation coefficent to interpolate a 
; vecto onto a new grid. The grid vector must be 
; either a monotonically decreasing or increasing function. A modified cubic
; polynomial is used to do the interpolation. Instead of using
; the excact cubic estiamtes for the first derivative at the two nodes,
; we use revised estimates which insure that the interpolating function
; is mononotonic in the interpolating interval.
;
; Both the interpolated function and its first derivatives are continuous.
;
; The techniques is somewhat similar to that suggested by Nordulund.
;
; Disadvantages: The interpolating coefificents can only be defined when the
;                function is known. In principal could use these modified
;                first derivatives to compute an accurate integration
;                formulae. However, the integration weights cannot be defined
;                independently of the function values, as desired in many
;                situations.
;
; Ref: Steffen. M, 1990, A/&A, 239, 443-450
;
; Altered 16-Jan-2005 - COEF(ND,1:4) was previously zero. For ease of use
;                         elsewhere, COEF(ND,4) now contains CHI(ND) and
;                         COEF(ND,3) contains dCHIdR for the last point. The
;                         other two coefficients are zero. These two
;                         assignments are consistent with those at other depths.
;                         The other coefficients are left zero. CHI(ND,:) should
;                         not be used for function fitting.
; Altered 25-Sep-1997 - Rewritten for speed and to vectorize efficiently.
; Created 25-Mar-1996 - Based on MON_INTERP
;
   COEF=DBLARR(ND,4)
   ONE=1.0D0
  H=DBLARR(ND)      ;Delta R [ R(I+1)-R(I) ]
  S=DBLARR(ND)      ;Slope in interval (I to I+1)
  D=DBLARR(ND)      ;First derivative at node I

; The array R may be either monotonically increasing, or decreasing.

  FOR I=0,ND-2 DO BEGIN
    H[I]=R[I+1]-R[I]
    S[I]=(CHI[I+1]-CHI[I])/H[I]
  ENDFOR
;
; Compute the first derivatives at node I.
;
  D[0]=S[0] +(S[0]-S[2])*H[0]/(H[0]+H[1])
  FOR I=1,ND-2 DO BEGIN
    D[I]=(S[I-1]*H[I]+S[I]*H[I-1])/(H[I-1]+H[I])
  ENDFOR
  D[ND-1]=S[ND-2]+(S[ND-2]-S[ND-3])*H[ND-2]/(H[ND-3]+H[ND-2])

; Adjust first derivatives so that function is monotonic  in each interval.

  D[0]=( ZE_FORTRAN_SIGN(ONE,S[0])+ZE_FORTRAN_SIGN(ONE,D[0]) )*MIN([ABS(S[0]),0.5*ABS(D[0])])
  FOR I=1,ND-2 DO BEGIN
    D[I]=( ZE_FORTRAN_SIGN(ONE,S[I-1])+ZE_FORTRAN_SIGN(ONE,S[I]) )*  MIN([ABS(S[I-1]),ABS(S[I]),0.5*ABS(D[I])])
  ENDFOR
  D[ND-1]=( ZE_FORTRAN_SIGN(ONE,S[ND-2])+ZE_FORTRAN_SIGN(ONE,D[ND-1]) )* MIN([ABS(S[ND-2]),0.5*ABS(D[ND-1])])

; Determine the coeffients of the monotonic cubic polynmial.

;C If T1=X-R(I) then
;C            Y=COEF(I,1)*T1^3 + COEF(I,2)*T1^3 +COEF(I,3)*T1 +COEF(I,4)

  FOR I=0,ND-2 DO BEGIN
    COEF[I,0]=(D[I]+D[I+1]-2.0*S[I])/H[I]/H[I]
    COEF[I,1]=(3.0*S[I]-2.0*D[I]-D[I+1])/H[I]
    COEF[I,2]=D[I]
    COEF[I,3]=CHI[I]
  ENDFOR
  COEF[ND-1,0:1]=0.0D0
  COEF[ND-1,2]=D[ND-1]
  COEF[ND-1,3]=CHI[ND-1]
;C

  END

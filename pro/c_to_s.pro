; (24-jan-91)
FUNCTION C_TO_S,V0
;+
; NAME:
; C_TO_S
; 
; PURPOSE:
; Returns sperical coordinates (r,theta,phi) of a position vector
; or array of position vectors whose cartesian coordinates are
; specified by V0.
;
; CALLING SEQUENCE:
; V1 = C_TO_S(V0)
;
; INPUTS:
; V0 = Cartesian coordinates (X,Y,Z) of a 3-vector or array
;      of 3-vectors
;
; OUTPUTS:
; V1 = Spherical coordinates (r,theta,phi) corresponding to
;      cartesian coordinates specified by V0
;
; MODIFICATION HISTORY:
; Version 1.0 - Jan, 1991, Written, G. L. Slater, LPARL
;-

  x = v0(0) & y = v0(1) & z = v0(2)
  return,[sqrt(x*x+y*y+z*z), arccos(sqrt(x*x+z*z)), arctan(x/z)]
  end

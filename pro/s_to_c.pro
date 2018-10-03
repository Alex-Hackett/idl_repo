; (4-feb-91)
FUNCTION S_TO_C,V0
;+
; NAME:
; S_TO_C
; 
; PURPOSE:
; Returns Cartesian coordinates (X,Y,Z) of a position vector
; or array of position vectors whose spherical coordinates are
; specified by V0.
;
; CALLING SEQUENCE:
; V1 = S_TO_C(V0)
;
; INPUTS:
; V0 = Spherical coordinates (r,theta,phi) of a 3-vector or
;      array of 3-vectors
;
; OUTPUTS:
; V1 = Cartesian coordinates (x,y,z) corresponding to sperical
;      coordinates specified by V0
;
; MODIFICATION HISTORY:
; Version 1.0 - Feb, 1991, G. L. Slater, LPARL
;-

  r = v0(0) & theta = v0(1)/!radeg & phi = v0(2)/!radeg
  return,r*[cos(theta)*sin(phi), sin(theta), cos(theta)*cos(phi)]
  end

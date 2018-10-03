FUNCTION ZE_SCALE_MAG_FROM_L,mag,lfactor
;scales magnitudes by a given change in L by lfactor, Lnew=L*lfactor
;magnitude can be a scalar or a vector

if n_elements(mag) LT 2 THEN newmag=mag - (2.5*alog10(lfactor)) ELSE BEGIN
  newmag=mag
  FOR i=0, n_elements(mag) -1 DO newmag[i]= mag[i] - (2.5*alog10(lfactor))
ENDELSE   

return,newmag

END
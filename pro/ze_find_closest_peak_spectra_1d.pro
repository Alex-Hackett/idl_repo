PRO ZE_FIND_CLOSEST_PEAK_SPECTRA_1D,x,datac,xcen

npts=n_elements(datac)
  for i=x+.5, npts-1  DO IF (datac[i] GE datac[i+1]) THEN BREAK 

  while ((i GT 1) AND (datac[i] LE datac[i-1])) DO i=i-1

  for j=x+.5, 1,-1  DO IF (datac[j] LE datac[j+1]) THEN BREAK 

  while ((j LT npts-1) AND (datac[j] LE datac[j+1])) DO j=j+1  

  if (abs(i-x) LT abs(x-j)) THEN xcen = i ELSE xcen = j




END
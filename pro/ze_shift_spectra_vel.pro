FUNCTION ZE_SHIFT_SPECTRA_VEL,lambda,flux,v

;return the shifted flux from a spectrum for a given velocity, correctly sample in the same lambda as original data
;shifting the spectrum in velocity
C=299792.458
lnew=lambda*(1.+v/C)
fluxshifted=cspline(lnew,flux,lambda)

RETURN,fluxshifted

END

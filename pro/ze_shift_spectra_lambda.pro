FUNCTION ZE_SHIFT_SPECTRA_LAMBDA,lambda,flux,deltal

;return the shift flux from a spectrum for a given velocity, correctly sample in the same lambda as original data
;shifting the spectrum in velocity
C=299792.458
lnew=lambda+deltal
fluxshifted=cspline(lnew,flux,lambda)

RETURN,fluxshifted

END

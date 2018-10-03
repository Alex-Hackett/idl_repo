FUNCTION ZE_SPEC_CNVL_VEL,lambda,flux,fwhm_vel
;convolves spectrum with a gaussian of a given fwhm in vel

vel=ZE_LAMBDA_TO_VEL(lambda,lambda[n_elements(lambda)/2.])
dl=vel[n_elements(lambda)/2.]-vel[n_elements(lambda)/2. -1.]
fluxcnvl=cnvlgauss(flux,fwhm=fwhm_vel/dl)

return,fluxcnvl
END
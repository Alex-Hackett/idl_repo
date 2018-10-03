PRO ZE_SPEC_CNVL,lambda,flux,fwhm_ang,lambda_val,fluxcnvl=fluxcnvl
;res need to be in Angstrom!!!!
near = Min(Abs(lambda-lambda_val), index)
IF index eq 0 THEN dl=lambda[1]-lambda[0] ELSE dl=lambda[index]-lambda[index-1.]
fluxcnvl=cnvlgauss(flux,fwhm=fwhm_ang/dl)

END

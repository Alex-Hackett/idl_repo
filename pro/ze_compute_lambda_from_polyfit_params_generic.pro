PRO ZE_COMPUTE_LAMBDA_FROM_POLYFIT_PARAMS_GENERIC,indexvec,lambda_fit_params,lambda
;computes lambda values from a given set o polynomial fit parameters that where previously computed using poly_fit or something similar
;works for order up to 5 at this point, easily extendable for high order polynomials
;more generic than ZE_COMPUTE_LAMBDA_FROM_POLYFIT_PARAMS, as it allows an input vector of floating index values (like centroids) have their lambda computed.
;this routine is ok and works well! 
npix=n_elements(indexvec)
lambda=dblarr(npix)
poly_degree=n_elements(lambda_fit_params)-1

CASE poly_degree of

  0: FOR i=0D, npix -1D do lambda[i]=lambda_fit_params[0]
  1: FOR i=0D, npix -1D do lambda[i]=lambda_fit_params[0]+lambda_fit_params[1]*indexvec[i]
  2: FOR i=0D, npix -1D do lambda[i]=lambda_fit_params[0]+lambda_fit_params[1]*indexvec[i]+lambda_fit_params[2]*indexvec[i]^2
  3: FOR i=0D, npix -1D do lambda[i]=lambda_fit_params[0]+lambda_fit_params[1]*indexvec[i]+lambda_fit_params[2]*indexvec[i]^2+lambda_fit_params[3]*indexvec[i]^3
  4: FOR i=0D, npix -1D do lambda[i]=lambda_fit_params[0]+lambda_fit_params[1]*indexvec[i]+lambda_fit_params[2]*indexvec[i]^2+lambda_fit_params[3]*indexvec[i]^3+lambda_fit_params[4]*indexvec[i]^4
  5: FOR i=0D, npix -1D do lambda[i]=lambda_fit_params[0]+lambda_fit_params[1]*indexvec[i]+lambda_fit_params[2]*indexvec[i]^2+lambda_fit_params[3]*indexvec[i]^3+lambda_fit_params[4]*indexvec[i]^4+lambda_fit_params[5]*indexvec[i]^5
ENDCASE

END
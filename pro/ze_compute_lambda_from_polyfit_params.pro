PRO ZE_COMPUTE_LAMBDA_FROM_POLYFIT_PARAMS,npix,lambda_fit_params,lambda
;computes lambda values from a given set o polynomial fit parameters that where previously computed using poly_fit or something similar
;works for order up to 5 at this point, easily extendable for high order polynomials
;;this routine had a bug which is FIXED now: i has to be a double 
lambda=dblarr(npix)
poly_degree=n_elements(lambda_fit_params)-1

CASE poly_degree of

  0: FOR i=0D, npix -1. do lambda[i]=lambda_fit_params[0]
  1: FOR i=0D, npix -1. do lambda[i]=lambda_fit_params[0]+lambda_fit_params[1]*i
  2: FOR i=0D, npix -1 do lambda[i]=lambda_fit_params[0]+lambda_fit_params[1]*i+lambda_fit_params[2]*i^2
  3: FOR i=0D, npix -1. do lambda[i]=lambda_fit_params[0]+lambda_fit_params[1]*i+lambda_fit_params[2]*i^2+lambda_fit_params[3]*i^3
  4: FOR i=0D, npix -1. do lambda[i]=lambda_fit_params[0]+lambda_fit_params[1]*i+lambda_fit_params[2]*i^2+lambda_fit_params[3]*i^3+lambda_fit_params[4]*i^4
  5: FOR i=0D, npix -1. do lambda[i]=lambda_fit_params[0]+lambda_fit_params[1]*i+lambda_fit_params[2]*i^2+lambda_fit_params[3]*i^3+lambda_fit_params[4]*i^4+lambda_fit_params[5]*i^5
ENDCASE

END
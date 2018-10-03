PRO ZE_CCD_COMPUTE_SIGMA_SPECTRUM_1D,flux,bw,sigma_val,sigma_med
mean_val=flux
sigma_val=flux

for i=bw,n_elements(flux)-bw-1 DO BEGIN
flux_cut=flux[i-bw:i+bw]
max_val=MAX(flux_cut,indexmax)
REMOVE,indexmax,flux_cut
mean_val[i]=(MOMENT(flux_cut,sdev=sigma_med))[0]
sigma_val[i]=SQRT((flux[i]-mean_val[i])^2)
endfor

dummy=(MOMENT(sigma_val,sdev=sigma_med))[0]
sigma_val[0]=sigma_med
sigma_val[n_elements(sigma_val)-1]=sigma_med

END

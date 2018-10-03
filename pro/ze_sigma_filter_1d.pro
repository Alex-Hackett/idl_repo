PRO ZE_SIGMA_FILTER_1D,flux,bw,threshold,ngrow,flux_sigcorr,sigma_val,sigma_med
;finally works!
flux_sigcorr=flux

ZE_CCD_COMPUTE_SIGMA_SPECTRUM_1D,flux,bw,sigmaval1,sigma_med1
loc=where(sigmaval1 GT threshold*sigma_med1)
;grow rejection radius by ngrow pix -- currently assumes  ngrow=2
loc=[loc-2,loc-1,loc,loc+1,loc+2]
;print,loc
for I=0, n_elements(loc)-1 DO BEGIN 
flux_sigcorr[loc[i]]=MEAN(flux_sigcorr[loc[i]-5*bw:loc[i]-1])
ENDFOR
END

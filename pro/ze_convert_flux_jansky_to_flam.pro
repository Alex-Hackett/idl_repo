PRO ZE_CONVERT_FLUX_JANSKY_TO_FLAM,lambda_vac,flux_jansky,flux_flam
;NOT WORKING
SPEED_OF_LIGHT=2.99792458E10 ; in cm/s

obs_freq=SPEED_OF_LIGHT/lambda_vac*1E-05 ;vacuum lambda in Angstroms
nflux=n_elements(flux_jansky)
flux_flam=dblarr(nflux)

;convert from Jansky to erg/cm2/g/A
;lambda has to be lambda vac
;adapted from John's cnvrt.f in /spec_plt/subs

T1=1.0E-01/SPEED_OF_LIGHT      ;1.0E-23*1.0E+30*1.0E-08
FOR I=0.,nflux-1. DO flux_flam(I)=T1*flux_jansky(I)*obs_freq(I)*obs_freq(I)


END
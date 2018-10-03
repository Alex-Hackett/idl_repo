;PRO ZE_WORK_HD316285_FIT_VISIBILITIES_GAUSSIAN_AMBER

restore,'/Users/jgroh/hd316285_amber_obs.sav'
rad_to_mas=206264.806247*1e+3
baseline=[45.,85,105]
rho=baseline/(mean(lobs)*1e-10)   ;lambda_eff vinci measurementes is 2.196 (Kervella 2007)
fwhm_gauss=1.5
fwhm_gauss=2.5
;WARNING!!! ^2 factor was missing in the previous calculations and on grid plots; not taking into account changes in the projected baseline
vis_gaussian=exp(-(!PI*!PI*(fwhm_gauss/rad_to_mas)*(fwhm_gauss/rad_to_mas)*rho*rho)^2/(4*alog(2)))
print,vis_gaussian
END
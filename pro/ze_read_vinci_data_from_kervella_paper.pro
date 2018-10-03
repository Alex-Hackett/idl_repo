PRO ZE_READ_VINCI_DATA_FROM_KERVELLA_PAPER,base_min,base_max,jd_min,jd_max,baseline_sel_sort,pa_sel_sort,v_sel_sort,fwhm_sel_sort,errtotv_sel_sort,jd_sel_sort
file='/Users/jgroh/temp/etacar_vinci_kervella_paper07.txt'
;file='/Users/jgroh/etacar_vinci_vanboekel.txt'
;nobs=63
;jd=dblarr(nobs)

;jd_min=2452678.0D
;jd_max=2452679.0D
;base_min=17.0
;base_max=26.0

fres=0.44
vis_corr_factor=1-fres ;1-fres=0.57, from van Boekel et al. 2003
READCOL,file,jd,fov,Ninter,baseline,pa,vsq,errvsqst,errvsqsy,/SILENT
;print,jd
jd=jd+2452000.0D
;READCOL,file,jd,Ninter,baseline,pa,vsq,errtot,errvsqst,errvsqsy
vsq=vsq/100.
errvsqst=errvsqst/100.
errvsqsy=errvsqsy/100.
v=SQRT(vsq)/vis_corr_factor
errtotvsq=SQRT(errvsqst^2+errvsqsy^2)
errtotv=errtotvsq/(2.*v*vis_corr_factor)
;do this fucking shit right dude! doing wrtong sorting right now!
sel=where((baseline lt base_max) AND (baseline gt base_min) AND (jd lt jd_max) AND (jd gt jd_min) ) 
v_sel=v(sel)
baseline_sel=baseline(sel)
pa_sel=pa(sel)
errtotv_sel=errtotv(sel)
jd_sel=jd(sel)
pa_sel_sort=pa_sel(sort(pa_sel))
v_sel_sort=v_sel(sort(pa_sel))
baseline_sel_sort=baseline_sel(sort(pa_sel))
errtotv_sel_sort=errtotv_sel(sort(pa_sel))
jd_sel_sort=jd_sel(sort(pa_sel))

rad_to_mas=206264.806247*1e+3
rho=baseline_sel_sort/(2.196*1e-6)
fwhm_sel_sort=SQRT(ALOG(v_sel_sort)*(4*alog(2))/(3.141529*(1/rad_to_mas)*rho)^2*(-1.D0))
!P.Background = fsc_color('white')
END
;PRO ZE_WORK_ETACAR_INTERFEROMETRY_VANBOEKEL03_GRID_V2
;GRID version works for grid of models produced with ZE_BH05_CREATE_GRID_OWOCKI
;v1 

filevb03='/Users/jgroh/vanboekel03_fwhm_gauss_eta.txt'
ZE_READ_SPECTRA_COL_VEC,filevb03,pa_vb,fwhm_vb

;computing visibilites for a guassian 
;V(rho)=exp[-(Pi a roh)^2/(4 ln 2)
;V=visibility, rho=B/lambda   , a=FWHM
;for VB 03 K-band, lambda=2.39 micron, B=24m
rad_to_mas=206264.806247*1e+3
rho=24./(2.39*1e-6)
vis_vb=exp(-(3.141529*(fwhm_vb/rad_to_mas)*rho)/(4*alog(2)))

jd_min=2452216.0D
jd_max=2452900.0D
base_min=17.0D
base_max=26.0D

;ZE_READ_VINCI_DATA_FROM_VB,base_min,base_max,jd_min,jd_max,baseline_vb,pa_vb,vis_vb,fwhm_vb,errortotvt,jd_vb
ZE_READ_VINCI_DATA_FROM_KERVELLA_PAPER,base_min,base_max,jd_min,jd_max,baseline_vb,pa_vb,vis_vb,fwhm_vb,errortotvt,jd_vb
df=n_elements(vis_vb)-2 ;degrees of freedom

;1.68 gives chi_squared red=1
;errortotvt=errortotvt*1.68/vis_vb ;should alway use relative error if using chisq procedure below
errortotvt=errortotvt*1.0/vis_vb ;should alway use relative error if using chisq procedure below
weight=1./errortotvt^2 ; to be used later in chi-squared calculation

dir='/Users/jgroh/ze_models/2D_models/etacar/'
model='mod111_john'
;model2d='latidep'
;sufix='a'       ;latidep a (PROL) and d (OBL) provide a good fit
;model2d='c'
;sufix=''
;model2d='cut_v4'
;sufix='i'       ;cut_v4 u provides a good fit with PA=220
;model2d='tilted'
;sufix='c'       ;cut_v4 u provides a good fit with PA=220
;model2d='tilted_owocki_prol_grid_coarse_noscale_doas2d'
;model2d='tilted_owocki_obl'
model2d='tilted_owocki_grid2'

dist=2.3 ;in kpc
dstr=strcompress(string(dist*10., format='(I03)')) ;for 'a' models
;dstr=strcompress(string(dist*10., format='(I02)')) ;for other models
pa=130.          ;position angle in degrees; by definition PA=0 towards N, and increase eastwards. USE PA significantly different than 0 (e.g.50) for spherical models
pa_str=strcompress(string(pa, format='(I03)'))


;Grid information
omegamin=0.50
omegamax=0.99
omega_step=0.01
incmin=0.0
incmax=90.0
inc_step=1.

size_omega=FIX((omegamax-omegamin)/omega_step)+1
size_inc=FIX((incmax-incmin)/inc_step)+1
omega_vec=fltarr(size_omega)
inc_vec=fltarr(size_inc)

FOR i=0, size_omega -1  DO omega_vec[i]=omegamin+omega_step*i
FOR i=0, size_inc -1  DO inc_vec[i]=incmin+inc_step*i

omega_vec=REVERSE(omega_vec)
;omegainc_vec=dblarr(size_omega*size_inc,2)

sufix_vec=strarr(size_omega*size_inc)
omega_vec_str=strcompress(string(100.*omega_Vec, format='(I02)'))
inc_vec_str=strcompress(string(inc_Vec, format='(I02)'))

j=0
k=0
l=1
m=1

FOR i=0., size_omega*size_inc - 1 DO BEGIN  
  IF i GE (size_inc)*m THEN BEGIN
  k=0
  m=m+1
  j=j+1
  ENDIF
  sufix_vec[i]=omega_vec_str[j]+'_'+inc_vec_str[k]
  k=k+1
ENDFOR

nmodels=n_elements(sufix_vec)
chisq_opt_vec=dblarr(nmodels)
norm_opt_vec=dblarr(nmodels)
cp_kband_vec=dblarr(nmodels)

FOR L=0, nmodels -1 do BEGIN
sufix=sufix_vec[l]
inc_str=strmid(sufix,3,2)
;compute vis, cp_kband
COMP_FILE='T'
IF (COMP_FILE eq 'T') THEN BEGIN 
ZE_READ_OBS_DELTA_IP_ETACAR_V4,dir,model,model2d,sufix,pa,cp_kband,base_min,base_max,jd_min,jd_max,compute_image=0
ENDIF ELSE BEGIN
;read CPs from FILE
;WARNING
;NOTICE HERE THAT WHEN USING COMP_FILE=F, the PA=220 (for oblate models) and PA=130 (for prolate) cps are read; cannot be used to compare with models with different PA!!!!!!
;cOMP-F should be used only for computing chi-square assuming different sigma
file='/Users/jgroh/temp/cp_lambda_'+model+'_'+model2d+'_'+sufix+'_d'+dstr+'_PA'+pa_str+'_i'+inc_str+'.txt'
print,file
close,1
openr,1,file     ; open file to write
readf,1,nlambda
lambda_vector=dblarr(nlambda)
cp_triplet_wavelength_cnvl_sys=dblarr(nlambda)
readf,1,lambda_vector
readf,1,cp_triplet_wavelength_cnvl_sys
close,1

cp_kband=cp_triplet_wavelength_cnvl_sys[nlambda-1]

ENDELSE

;read data from FILE
file='/Users/jgroh/temp/vis_model_vb_baseline_pa_'+model+'_'+model2d+'_'+sufix+'_d'+dstr+'_PA'+pa_str+'.txt'
close,1
openr,1,file     ; open file to read

readf,1,nbas
readf,1,npa_vb
vis_profile2=dblarr(nbas,npa_vb)
baseline_val2=dblarr(nbas,npa_vb)
readf,1,vis_profile2
readf,1,baseline_val2
close,1


npa_vb=n_elements(pa_vb)
vis_24_vec=dblarr(npa_vb)
FOR I=0, npa_vb -1 DO BEGIN
LINTERP, REFORM(baseline_val2[*,i]), REFORM(vis_profile2[*,i]), baseline_vb[i], vis_24_vect
;print,i
vis_24_vec[i]=vis_24_vect
ENDFOR

imgname='vis_pa_'+model+'_'+model2d+'_'+sufix+'_d'+dstr+'_imagePA'+pa_str

norm_min=0.84
norm_max=1.02
norm_step=0.01
size_norm=(norm_max-norm_min)/norm_step+1
chisq_vec=dblarr(size_norm)
norm_vec=dblarr(size_norm)

;compute normalization factor and chi_sq
i=0
FOR norm=norm_min, norm_max, norm_step DO BEGIN
;LINTERP,pa_vec, vis_24_vec*norm,pa_vb, vis_24_vec_ivb
vis_24_vec_ivb=vis_24_vec*norm
chisq,vis_vb,weight,vis_24_vec_ivb,df,chisq
;print,i,norm,chisq
chisq_vec[i]=chisq
norm_vec[i]=norm
i=i+1
ENDFOR

chisq_opt=MIN(chisq_vec,pos_min)
print,chisq_vec,MIN(chisq_vec), pos_min
norm_opt=norm_vec[pos_min]

print,'Reduced Chi square=', chisq_opt
print,'CP K_band=', cp_kband
!P.Background = fsc_color('white')
;lineplot,pa_vb,vis_vb
;lineplot,pa_vec,vis_24_vec*norm_opt

;ZE_ETACAR_INTERFEROMETRY_PLOT_VIS_PA_EPS,imgname,pa_vb,vis_vb,pa_vb,vis_24_vec*norm_opt,errortotvt,model2d,sufix

chisq_opt_vec[l]=chisq_opt
norm_opt_vec[l]=norm_opt
cp_kband_vec[l]=cp_kband
endfor
;SAVE,omega_vec,inc_vec,sufix_vec,chisq_opt_vec,norm_opt_vec,cp_kband_vec,pa,pa_str,FILENAME='/Users/jgroh/temp/ze_work_etacar_interferometry_results_bh05_'+model2d+'_d'+dstr+'_PA'+pa_str+'_omega_inc_newdata.var'
END
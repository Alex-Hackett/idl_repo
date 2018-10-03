;PRO ZE_WORK_ETACAR_INTERFEROMETRY_VANBOEKEL03_GRID
;GRID version works for grid of models produced with ZE_BH05_CREATE_GRID_OWOCKI

filevb03='/Users/jgroh/vanboekel03_fwhm_gauss_eta.txt'
ZE_READ_SPECTRA_COL_VEC,filevb03,pa_vb,fwhm_vb

;computing visibilites for a guassian 
;V(rho)=exp[-(Pi a roh)^2/(4 ln 2)
;V=visibility, rho=B/lambda   , a=FWHM
;for VB 03 K-band, lambda=2.39 micron, B=24m
rad_to_mas=206264.806247*1e+3
rho=24./(2.39*1e-6)
vis_vb=exp(-(3.141529*(fwhm_vb/rad_to_mas)*rho)/(4*alog(2)))

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
model2d='tilted_owocki_prol_grid_coarse_noscale_doas2d'


dist=2.3 ;in kpc
dstr=strcompress(string(dist*10., format='(I03)')) ;for 'a' models
;dstr=strcompress(string(dist*10., format='(I02)')) ;for other models
pa=130.          ;position angle in degrees; by definition PA=0 towards N, and increase eastwards. USE PA significantly different than 0 (e.g.50) for spherical models
pa_str=strcompress(string(pa, format='(I03)'))

pamin=50.
pamax=130.
pastep=20.
npa=(pamax - pamin)/pastep +1.
pamin_str=strcompress(string(pamin, format='(I03)'))
pamax_str=strcompress(string(pamax, format='(I03)'))
pastep_str=strcompress(string(pastep, format='(I03)'))
nbas=n_elements(baseline_val50)
;nbas=391.
pa_vec=dblarr(npa)
FOR i=0,npa-1 do pa_vec[i]=pamin+ i*pastep
;vis_profile=dblarr(nbas,npa)
;baseline_val=dblarr(nbas,npa)

;Grid information
omegamin=0.50
omegamax=0.95
omega_step=0.05
incmin=0.0
incmax=90.0
inc_step=5.

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

;compute vis, cp_kband
ZE_READ_OBS_DELTA_IP_ETACAR_V4,dir,model,model2d,sufix,pa,cp_kband,COMPUTE_IMAGE=0

;read data from FILE
file='/Users/jgroh/temp/vis_baseline_'+model+'_'+model2d+'_'+sufix+'_d'+dstr+'_PA'+pa_str+'_PAmin'+pamin_str+'_PAmax'+pamax_str+'_PAstep'+pastep_str+'.txt'
close,1
openr,1,file     ; open file to read

readf,1,nbas
readf,1,pamin
readf,1,npa
vis_profile=dblarr(nbas,npa)
baseline_val=dblarr(nbas,npa)
readf,1,vis_profile
readf,1,baseline_val
close,1


vis_24_vec=dblarr(npa)
FOR I=0, npa -1 DO BEGIN
LINTERP, REFORM(baseline_val[*,i]), REFORM(vis_profile[*,i]), 24., vis_24_vect
vis_24_vec[i]=vis_24_vect
ENDFOR


imgname='vis_pa_'+model+'_'+model2d+'_'+sufix+'_d'+dstr+'_imagePA'+pa_str

df=n_elements(vis_vb)-2
sigma=0.01
weight = vis_vb
weight[*]=1/sigma^2

norm_min=0.93
norm_max=1.06
norm_step=0.005
size_norm=FIX((norm_max-norm_min)/norm_step)+2
chisq_vec=dblarr(size_norm)
norm_vec=dblarr(size_norm)

;compute normalization factor and chi_sq
i=0
FOR norm=norm_min, norm_max, norm_step DO BEGIN
LINTERP,pa_vec, vis_24_vec*norm,pa_vb, vis_24_vec_ivb
chisq,vis_vb,weight,vis_24_vec_ivb,df,chisq
chisq_vec[i]=chisq
norm_vec[i]=norm
i=i+1
ENDFOR

chisq_opt=MIN(chisq_vec,pos_min)
norm_opt=norm_vec[pos_min]

print,'Reduced Chi square=', chisq_opt
print,'CP K_band=', cp_kband
!P.Background = fsc_color('white')
;lineplot,pa_vb,vis_vb
;lineplot,pa_vec,vis_24_vec*norm_opt

ZE_ETACAR_INTERFEROMETRY_PLOT_VIS_PA_EPS,imgname,pa_vb,vis_vb,pa_vec,vis_24_vec*norm_opt,model2d,sufix

chisq_opt_vec[l]=chisq_opt
norm_opt_vec[l]=norm_opt
cp_kband_vec[l]=cp_kband
endfor
;SAVE,omega_vec,inc_vec,sufix_vec,chisq_opt_vec,norm_opt_vec,cp_kband_vec,FILENAME='/Users/jgroh/temp/ze_work_etacar_interferometry_results_bh05_'+model2d+'_omega_inc.var'
END
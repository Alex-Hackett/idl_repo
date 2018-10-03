;PRO ZE_WORK_ETACAR_INTERFEROMETRY_VANBOEKEL03_V2
;works for a single model at a time only
;v2 takes into account the real data from vb03/k07, and takes into account changes in the projected baseline as a function of pa
;remember data have different baseline at different PA
filevb03='/Users/jgroh/temp/vanboekel03_fwhm_gauss_eta.txt'
ZE_READ_SPECTRA_COL_VEC,filevb03,pa_vb_letter,fwhm_vb_letter

;computing visibilites for a guassian 
;V(rho)=exp[-(Pi a roh)^2/(4 ln 2)
;V=visibility, rho=B/lambda   , a=FWHM
;for VB 03 K-band, lambda=2.39 micron, B=24m
rad_to_mas=206264.806247*1e+3
rho=24./(2.196*1e-6)   ;lambda_eff vinci measurementes is 2.196 (Kervella 2007)
;WARNING!!! ^2 factor was missing in the previous calculations and on grid plots; not taking into account changes in the projected baseline
vis_vb_letter=exp(-(!PI*!PI*(fwhm_vb_letter/rad_to_mas)*(fwhm_vb_letter/rad_to_mas)*rho*rho)^2/(4*alog(2)))

jd_min=2452216.0D
jd_max=2452900.0D
base_min=17.0D
base_max=26.0D

;ZE_READ_VINCI_DATA_FROM_VB,base_min,base_max,jd_min,jd_max,baseline_vb,pa_vb,vis_vb,fwhm_vb,errortotvt,jd_vb
ZE_READ_VINCI_DATA_FROM_KERVELLA_PAPER,base_min,base_max,jd_min,jd_max,baseline_vb,pa_vb,vis_vb,fwhm_vb,errortotvt,jd_vb

phi_vb=1.0 + (jd_vb - 2452819.8)/2022.7

error_tot_vis=errortotvt
df=n_elements(vis_vb)-2
errortotvt=errortotvt*1.0/vis_vb ;should alway use relative error if using chisq procedure below
weight=1./errortotvt^2

dir='/Users/jgroh/ze_models/2D_models/etacar/'
model='mod111_john' ;Mdot=1e-3
;model='mod106_john' ;Mdot=5e-4
;model='mod2_groh'   ;Mdot=8e-4
;model='mod3_groh'   ;Mdot=1e-3 but different rstar
;model='mod_111_copy_groh_finer_rgrid'   ;Mdot=1e-3 but different rstar
;model2d='latidep'
;model2d='tilted_owocki_grid2'
;sufix='a'       ;latidep a (PROL) and d (OBL) provide a good fit
;model2d='c'
;sufix=''
model2d='cut_v4'
sufix='m12' ;AMBER wall falpha=10; f4cd
;model2d='cavity'
;sufix='m10' ;AMBER wall falpha=10
;model2d='cut_v5'
;sufix='t1'
;sufix='m7'       ;
;model2d='tilted'
;sufix='c'       ;
;model2d='tests'
model2d='tilted_owocki_prol_grid_coarse_noscale_doas2d'
;model2d='tilted_owocki_obl'
;sufix='72_75' ;f1
sufix='75_75' ;f1
;sufix='85_80' ;f1ef
;sufix='98_41' ;f1hi
;sufix='70_85' ;f2bc

dist=2.3 ;in kpc
dstr=strcompress(string(dist*10., format='(I03)')) ;for 'a' models
;dstr=strcompress(string(dist*10., format='(I02)')) ;for other models
pa=40.          ;position angle in degrees; by definition PA=0 towards N, and increase eastwards. USE PA significantly different than 0 (e.g.50) for spherical models
pa=130.0
pa_str=strcompress(string(pa, format='(I03)'))
;
;pamin=50.
;pamax=130.
;pastep=20.
;npa=(pamax - pamin)/pastep +1.
;pamin_str=strcompress(string(pamin, format='(I03)'))
;pamax_str=strcompress(string(pamax, format='(I03)'))
;pastep_str=strcompress(string(pastep, format='(I03)'))
;nbas=n_elements(baseline_val50)
;;nbas=391.
;pa_vec=dblarr(npa)
;FOR i=0,npa-1 do pa_vec[i]=pamin+ i*pastep
;vis_profile=dblarr(nbas,npa)
;baseline_val=dblarr(nbas,npa)

;compute vis, cp_kband
ZE_READ_OBS_DELTA_IP_ETACAR_V4,dir,model,model2d,sufix,pa,cp_kband,base_min,base_max,jd_min,jd_max,compute_image=1
;ZE_READ_OBS_DELTA_IP_ETACAR_V4_BINARY,dir,model,model2d,sufix,pa,cp_kband,base_min,base_max,jd_min,jd_max,compute_image=1,gauss=1,30.,0.2
;ZE_READ_OBS_DELTA_IP_ETACAR_V4_MOD106_JOHN,dir,model,model2d,sufix,pa,cp_kband,compute_image=1,gauss=1,700.,0.0

;;read data from FILE
;file='/Users/jgroh/temp/vis_baseline_'+model+'_'+model2d+'_'+sufix+'_d'+dstr+'_PA'+pa_str+'_PAmin'+pamin_str+'_PAmax'+pamax_str+'_PAstep'+pastep_str+'.txt'
;close,1
;openr,1,file     ; open file to read
;
;readf,1,nbas
;readf,1,pamin
;readf,1,npa
;vis_profile=dblarr(nbas,npa)
;baseline_val=dblarr(nbas,npa)
;readf,1,vis_profile
;readf,1,baseline_val
;close,1
;
;
;vis_24_vec=dblarr(npa)
;FOR I=0, npa -1 DO BEGIN
;LINTERP, REFORM(baseline_val[*,i]), REFORM(vis_profile[*,i]), 24., vis_24_vect
;vis_24_vec[i]=vis_24_vect
;ENDFOR


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
vis_24_vec[i]=vis_24_vect
ENDFOR


imgname='vis_pa_'+model+'_'+model2d+'_'+sufix+'_d'+dstr+'_imagePA'+pa_str

norm_min=0.86
norm_max=1.08
;norm_min=0.950
;norm_max=0.960
norm_step=0.005
size_norm=(norm_max-norm_min)/norm_step+2.0
chisq_vec=dblarr(size_norm)
norm_vec=dblarr(size_norm)

;compute normalization factor and chi_sq
i=0
FOR norm=norm_min, norm_max, norm_step DO BEGIN
;LINTERP,pa_vec, vis_24_vec*norm,pa_vb, vis_24_vec_ivb
vis_24_vec_ivb=vis_24_vec*norm
chisq,vis_vb,weight,vis_24_vec_ivb,df,chisq
;print,i,norm,chisq
print,i,size_norm
chisq_vec[i]=chisq
norm_vec[i]=norm
i=i+1
ENDFOR

chisq_new=TOTAL(((vis_vb-vis_24_vec)/errortotvt)^2)
red_chisq_new=chisq_new/df
chisq_opt=MIN(chisq_vec(WHERE(chisq_vec ne 0)),pos_min)
;print,MIN(chisq_vec), pos_min
norm_opt=norm_vec[pos_min]

print,'Reduced Chi square=', chisq_opt
print,'CP K_band=', cp_kband
!P.Background = fsc_color('white')
;lineplot,pa_vb,vis_vb
;lineplot,pa_vec,vis_24_vec*norm_opt

ZE_ETACAR_INTERFEROMETRY_PLOT_VIS_PA_EPS,imgname,pa_vb,vis_vb,pa_vb,vis_24_vec*norm_opt,error_tot_vis,model2d,sufix

END
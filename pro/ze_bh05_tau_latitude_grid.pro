;PRO ZE_BH05_TAU_LATITUDE_GRID

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
model2d='tilted_owocki_prol_grid4'

file='TAU_DATA'

;star info
tstar_pole=37920.0

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
reff_vec=dblarr(nmodels)
teff_vec=dblarr(nmodels)
tstar_vec=dblarr(nmodels)

FOR L=0, nmodels -1 do BEGIN
sufix=sufix_vec[l]
omega_from_sufix=FLOAT(strmid(sufix,0,2))
w_from_sufix=SQRT(omega_from_sufix/100.0)
inc_from_sufix=FLOAT(strmid(sufix,3,2))
ZE_BH05_READ_TAU_COMPUTE_TEFF_INDIV,dir+model+'/'+model2d+'/',sufix+'/'+file,reff_out1,teff_out1
reff_vec[l]=reff_out1
teff_vec[l]=teff_out1*1e3 ;converting from kK to K
ZE_BH05_READ_TAU_COMPUTE_TSTAR_FROM_VZ,tstar_pole,w_from_sufix,inc_from_sufix,tstar_out1
print,tstar_pole,w_from_sufix,inc_from_sufix,tstar_out1
tstar_vec[l]=tstar_out1
ENDFOR


reff_image=dblarr(size_omega,size_inc)
Teff_image=dblarr(size_omega,size_inc)
Tstar_image=dblarr(size_omega,size_inc)
inc_image=dblarr(size_omega,size_inc)
omega_image=dblarr(size_omega,size_inc)

omega_from_sufix=FLOAT(strmid(sufix_vec,0,2))
inc_from_sufix=FLOAT(strmid(sufix_vec,3,2))
inc_from_sufix_image=dblarr(size_omega,size_inc)
omega_from_sufix_image=dblarr(size_omega,size_inc)

FOR j=0, size_omega -1 DO BEGIN
;print,j
;print,size(chisq_opt_vec[(size_inc)*j:((size_inc)*(j+1)-1)])
reff_image[j,*]=reff_vec[(size_inc)*j:((size_inc)*(j+1)-1)]
teff_image[j,*]=teff_vec[(size_inc)*j:((size_inc)*(j+1)-1)]
tstar_image[j,*]=tstar_vec[(size_inc)*j:((size_inc)*(j+1)-1)]
inc_from_sufix_image[j,*]=inc_from_sufix[(size_inc)*j:((size_inc)*(j+1)-1)]
omega_from_sufix_image[j,*]=omega_from_sufix[(size_inc)*j:((size_inc)*(j+1)-1)]
inc_image[j,*]=inc_vec
ENDFOR

FOR s=0, size_inc -1 DO omega_image[*,s]=omega_vec

;correct the omega,inc orientation of the image
ang_rot=-180.
reff_imaget=ROT((reff_image),ang_rot,/INTERP)
teff_imaget=ROT((teff_image),ang_rot,/INTERP)
tstar_imaget=ROT((tstar_image),ang_rot,/INTERP)
inc_imaget=ROT((inc_image),ang_rot,/INTERP)
omega_imaget=ROT((omega_image),ang_rot,/INTERP)
inc_from_sufix_imaget=ROT((inc_from_sufix_image),ang_rot,/INTERP)
omega_from_sufix_imaget=ROT((omega_from_sufix_image),ang_rot,/INTERP)

omega_vec=SQRT(omega_vec)

imgname='reff_image_'+model2d
title='R (tau=2/3) image'
quantity_str='reff'
label='(a)'
aa=700.
bb=700.
a=min(reff_imaget,/NAN)
b=max(reff_imaget,/NAN)
c=5
values=reff_image
image=bytscl(reff_imaget,MIN=a,MAX=b); byte scaling the image for display purposes with tvimage
;ZE_PLOT_IMAGE_chisq_omega_inc_EPS,label,values,image,a,b,c,imgname,omega_Vec,inc_vec,aa,bb,title,VEL=vel,INV=0,CONT=0
ZE_PLOT_IMAGE_GEN_omega_inc_EPS,label,values,image,a,b,c,imgname,omega_Vec,inc_vec,aa,bb,title,quantity_str,VEL=vel,INV=0,CONT=0

imgname='teff_image_'+model2d
title='Teff values image'
quantity_str='teff'
label='(b)'
aa=700.
bb=700.
a=min(teff_imaget,/NAN)
b=max(teff_imaget,/NAN)
c=13
image=bytscl(teff_imaget,MIN=a,MAX=b); byte scaling the image for display purposes with tvimage
ZE_PLOT_IMAGE_GEN_omega_inc_EPS,label,values,image,a,b,c,imgname,omega_Vec,inc_vec,aa,bb,title,quantity_str,VEL=vel,INV=0,CONT=0

imgname='tstar_image_'+model2d
title='Tstar values image'
quantity_str='tstar'
label='(c)'
aa=700.
bb=700.
a=min(tstar_imaget,/NAN)
b=max(tstar_imaget,/NAN)
c=13
image=bytscl(tstar_imaget,MIN=a,MAX=b); byte scaling the image for display purposes with tvimage
ZE_PLOT_IMAGE_GEN_omega_inc_EPS,label,values,image,a,b,c,imgname,omega_Vec,inc_vec,aa,bb,title,quantity_str,VEL=vel,INV=0,CONT=0

imgname='omega_image_'+model2d
title='Omega values image'
aa=700.
bb=700.
c=5
a=min(omega_imaget,/NAN)
b=max(omega_imaget,/NAN)
image=bytscl(omega_imaget,MIN=a,MAX=b); byte scaling the image for display purposes with tvimage
ZE_PLOT_IMAGE_chisq_omega_inc_EPS,label,values,image,a,b,c,imgname,omega_Vec,inc_vec,aa,bb,title,VEL=vel,INV=0,CONT=0

imgname='inc_image_'+model2d
title='Inc values image'
aa=700.
bb=700.
c=5
a=min(inc_imaget,/NAN)
b=max(inc_imaget,/NAN)
image=bytscl(inc_imaget,MIN=a,MAX=b); byte scaling the image for display purposes with tvimage
ZE_PLOT_IMAGE_chisq_omega_inc_EPS,label,values,image,a,b,c,imgname,omega_Vec,inc_vec,aa,bb,title,VEL=vel,INV=0,CONT=0

imgname='omega_from_sufix_image_'+model2d
title='Omega from sufix values image'
aa=700.
bb=700.
c=5
a=min(omega_from_sufix_imaget,/NAN)
b=max(omega_from_sufix_imaget,/NAN)
image=bytscl(omega_from_sufix_imaget,MIN=a,MAX=b); byte scaling the image for display purposes with tvimage
ZE_PLOT_IMAGE_chisq_omega_inc_EPS,label,values,image,a,b,c,imgname,omega_Vec,inc_vec,aa,bb,title,VEL=vel,INV=0,CONT=0

imgname='inc_from_sufix_image_'+model2d
title='Inc from_sufix_ values image'
aa=700.
bb=700.
a=min(inc_from_sufix_imaget,/NAN)
b=max(inc_from_sufix_imaget,/NAN)
c=5
image=bytscl(inc_from_sufix_imaget,MIN=a,MAX=b); byte scaling the image for display purposes with tvimage
ZE_PLOT_IMAGE_chisq_omega_inc_EPS,label,values,image,a,b,c,imgname,omega_Vec,inc_vec,aa,bb,title,VEL=vel,INV=0,CONT=0

;SAVE,omega_vec,inc_vec,sufix_vec,chisq_opt_vec,norm_opt_vec,cp_kband_vec,FILENAME='/Users/jgroh/temp/ze_work_etacar_interferometry_results_bh05_'+model2d+'_omega_inc.var'


END
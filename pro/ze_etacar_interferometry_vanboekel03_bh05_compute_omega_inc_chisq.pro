;PRO ZE_ETACAR_INTERFEROMETRY_VANBOEKEL03_BH05_COMPUTE_OMEGA_INC_CHISQ
;model2d='tilted_owocki_obl'
;model2d='grid_owocki'
vel=0
model2d='tilted_owocki_prol_grid_coarse_noscale_doas2d'
RESTORE, FILENAME='/Users/jgroh/temp/ze_work_etacar_interferometry_results_bh05_'+model2d+'_omega_inc.var'

size_omega=n_elements(omega_vec)
size_inc=n_elements(inc_vec)

chisq_image=dblarr(size_omega,size_inc)
cp_kband_image=dblarr(size_omega,size_inc)
inc_image=dblarr(size_omega,size_inc)
omega_image=dblarr(size_omega,size_inc)

omega_from_sufix=FLOAT(strmid(sufix_vec,0,2))
inc_from_sufix=FLOAT(strmid(sufix_vec,3,2))
inc_from_sufix_image=dblarr(size_omega,size_inc)
omega_from_sufix_image=dblarr(size_omega,size_inc)

;THERE WAS A SERIOUS ERROR WITH OBTAINING THE PROPER VALUES OF CHISQ and CP_KBAND from chisq_opt_vec and cp_kband_vec: WAS NOT SORTING THE ARRAY VALUES PROPERLY (SEE inc_from_sufix_image and omega_from_sufix_image for DEBUG)
;CORRECTED NOW!
FOR j=0, size_omega -1 DO BEGIN
print,j
print,size(chisq_opt_vec[(size_inc)*j:((size_inc)*(j+1)-1)])
chisq_image[j,*]=chisq_opt_vec[(size_inc)*j:((size_inc)*(j+1)-1)]
cp_kband_image[j,*]=cp_kband_vec[(size_inc)*j:((size_inc)*(j+1)-1)]
inc_from_sufix_image[j,*]=inc_from_sufix[(size_inc)*j:((size_inc)*(j+1)-1)]
omega_from_sufix_image[j,*]=omega_from_sufix[(size_inc)*j:((size_inc)*(j+1)-1)]
inc_image[j,*]=inc_vec
ENDFOR

FOR s=0, size_inc -1 DO omega_image[*,s]=omega_vec

;correct the omega,inc orientation of the image
ang_rot=-180.
chisq_imaget=ROT((chisq_image),ang_rot,/INTERP)
cp_kband_imaget=ROT((cp_kband_image),ang_rot,/INTERP)
inc_imaget=ROT((inc_image),ang_rot,/INTERP)
omega_imaget=ROT((omega_image),ang_rot,/INTERP)
inc_from_sufix_imaget=ROT((inc_from_sufix_image),ang_rot,/INTERP)
omega_from_sufix_imaget=ROT((omega_from_sufix_image),ang_rot,/INTERP)

;uncomment line bbelow for Feb 9th version plots
;omega_vec=SQRT(omega_vec)

big_omega_vec=omega_vec
little_omega_vec=big_omega_vec
;w=2.*COS((!PI+acos(little_omega_vec))/3.);
omega_vec=SQRT(big_omega_vec)

imgname='chisq_image_'+model2d
title='Chi Squared image'
label='d)'
aa=700.
bb=700.
a=min(chisq_imaget,/NAN)
b=max(chisq_imaget,/NAN)
c=43
values=chisq_image
image=bytscl(chisq_imaget,MIN=a,MAX=b); byte scaling the image for display purposes with tvimage
ZE_PLOT_IMAGE_chisq_omega_inc_EPS,label,values,image,a,b,c,imgname,omega_Vec,inc_vec,aa,bb,title,VEL=vel,INV=1,CONT=0

imgname='cp_kband_image_'+model2d
title='Closure phase values image'
label='e)'
aa=700.
bb=700.
a=min(cp_kband_imaget,/NAN)
b=max(cp_kband_imaget,/NAN)
c=13
image=bytscl(cp_kband_imaget,MIN=a,MAX=b); byte scaling the image for display purposes with tvimage
ZE_PLOT_IMAGE_chisq_omega_inc_EPS,label,values,image,a,b,c,imgname,omega_Vec,inc_vec,aa,bb,title,VEL=vel,INV=1,CONT=0

;pixx=1050.
;pixy=1050.
;chisq_image_i=congrid(chisq_image,pixx,pixy)
m=chisq_imaget
thre=5.
m(WHERE(cp_kband_imaget gt thre))=1000.
;cp_kband_imaget(WHERE(cp_kband_imaget) le 5.0)=1.
;m=cp_kband_imaget*chisq_imaget

imgname='chi-squared-selected_'+model2d+strcompress(string(thre, format='(I02)'))
title='chi_square selected image'
label='f)'
aa=700.
bb=700.
a=min(chisq_imaget,/NAN)
b=max(chisq_imaget,/NAN)
c=43
image=bytscl(m,MIN=a,MAX=b); byte scaling the image for display purposes with tvimage
ZE_PLOT_IMAGE_chisq_omega_inc_EPS,label,values,image,a,b,c,imgname,omega_Vec,inc_vec,aa,bb,title,VEL=vel,INV=1,CONT=0

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
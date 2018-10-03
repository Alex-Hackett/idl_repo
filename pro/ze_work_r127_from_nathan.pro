;PRO ZE_WORK_R127_FROM_NATHAN

dir='/Users/jgroh/espectros/r127/'
file=dir+'R127b_MIKE_21feb05.ec.fits'
getchelle,file,w,f

dirhrcmod='/Users/jgroh/ze_models/hrcar/'
ZE_CMFGEN_CREATE_OBSNORM,dirhrcmod+'2'+'/obsopt/obs_fin',dirhrcmod+'2'+'/obscont/obs_fin',l2,f2,/AIR
ZE_CMFGEN_CREATE_OBSNORM,dirhrcmod+'3'+'/obsopt/obs_fin',dirhrcmod+'3'+'/obscont/obs_fin',l3,f3,/AIR
ZE_CMFGEN_CREATE_OBSNORM,dirhrcmod+'4'+'/obsopt/obs_fin',dirhrcmod+'4'+'/obscont/obs_fin',l4,f4,/AIR
ZE_CMFGEN_CREATE_OBSNORM,dirhrcmod+'5'+'/obsopt/obs_fin',dirhrcmod+'5'+'/obscont/obs_fin',l5,f5,/AIR
ZE_CMFGEN_CREATE_OBSNORM,dirhrcmod+'6'+'/obsopt/obs_fin',dirhrcmod+'6'+'/obscont/obs_fin',l6,f6,/AIR
ZE_CMFGEN_CREATE_OBSNORM,dirhrcmod+'7'+'/obsopt/obs_fin',dirhrcmod+'7'+'/obscont/obs_fin',l7,f7,/AIR
ZE_CMFGEN_CREATE_OBSNORM,dirhrcmod+'8'+'/obsopt/obs_fin',dirhrcmod+'8'+'/obscont/obs_fin',l8,f8,/AIR


vsys=266.


order=16
order=2
lambda0=4088.89

!P.Background = fsc_color('white')

lineplot,REFORM(w[*,order]),REFORM(f[*,order])

;lineplot,ZE_LAMBDA_TO_VEL(REFORM(w[*,order]),lambda0)-vsys,REFORM(f[*,order])/3.41
;lineplot,ZE_LAMBDA_TO_VEL(l2,lambda0),f2

END
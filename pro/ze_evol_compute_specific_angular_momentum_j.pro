;PRO ZE_EVOL_COMPUTE_SPECIFIC_ANGULAR_MOMENTUM_J

!P.Background = fsc_color('white')

vfile='/Users/jgroh/evol_models/Z014/P010z14S4/P010z14S4.v0012491'
ZE_EVOL_READ_V_FILE_FROM_GENEVA_ORIGIN2010,vfile,data_vfile,header_vfile

xmr=REFORM(data_vfile.field01[1,*])
r=REFORM(data_vfile.field01[4,*])
omegav=REFORM(data_vfile.field01[43,*])

j=(2D0/3D0)*omegav*(10^r)^2   ;specific angular momentum is j=(2/3)*omegav*r^2

lineplot,xmr,alog10(j)


END
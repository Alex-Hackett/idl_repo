;PRO ZE_READ_HYDRO_V2,fhydro,r,v
fhydro='/aux/pc20117a/jgroh/cmfgen_models/agcar/369/HYDRO'
hydro=read_ascii(fhydro, DATA_START=1, MISSING_VALUE=0.)

r=dblarr((SIZE(hydro.field01))[2]) & v=r & sigma=r
r[*]=hydro.field01[0,*]
v[*]=hydro.field01[1,*]


END

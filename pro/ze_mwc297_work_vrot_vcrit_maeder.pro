;PRO ZE_MWC297_WORK_VROT_VCRIT_MAEDER

mdotsym= '!3!sM!r!u^!n'
sun = '!D!9n!3!N'
DEG_TO_RAD=!PI/180.0D

mass=10.
rstar_pb=800.0 ;weigelt10,kraus08
;rstar_pb=8. ;Acke et al. 2009, pg 211
inc=20.
vrot=150./SIN(inc*DEG_TO_RAD)
vcrit1=SQRT((2./3.)*0.0000000667*mass*1.989E+33/(rstar_pb*6.96*10000000000.))/100000. ; (MM2000,A&A361,159)
omega=vrot/vcrit1
print,vrot,inc,vcrit1,omega



END
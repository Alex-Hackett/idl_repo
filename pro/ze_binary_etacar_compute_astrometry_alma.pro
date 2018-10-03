;PRO ZE_BINARY_ETACAR_COMPUTE_ASTROMETRY_ALMA

P=5.54
M1=90
M2=1
a=ZE_BINARY_STAR_COMPUTE_A_FROM_MP_MS_P(M1,M2,P)
print,'a= ',a
a1=(a*M2)/(M1+M2)
a2=a-a1
print,'a1= ',a1
print,'a2= ',a2
print,(a1*(1+.9)/2.3)*COS(45.*3.14159/180.0), ' mas'








END
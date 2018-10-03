PRO ZE_BH05_READ_TAU_COMPUTE_TEFF_INDIV,dir,file,reff_out1,teff_out1
C=299792000.


lambda_vac=21520.0
obs_freq_in=C*1E-05/lambda_vac*1.D0

;find locations where to start readding, for each inclination angle
READCOL,dir+file,v1
size_all=n_elements(v1)
t1=MIN(ABS(v1-obs_Freq_in),pos1)

OPENR,1,dir+file
dummy_vec1=dblarr(pos1-2)
readf,1,dummy_vec1
READF,1,LS1
READF,1,DELTA_INDX1
READF,1,OBS_FREQ_VAL1
READF,1,SM_NRAY1
READF,1,INC_ANG1
z_ray1=dblarr(SM_NRAY1-1)
dtau1=dblarr(SM_NRAY1-1)
tau1=dblarr(SM_NRAY1-1)
;sm_nray=97
;nray=178
READF,1,z_ray1
READF,1,dtau1
FOR I=0, n_elements(tau1) -1 DO tau1[i]=TOTAL(dtau1[0:i])
CLOSE,1



lstar=5E+06
reff1=z_ray1/6.96

LINTERP,tau1,reff1,0.667,reff_out1
teff_out1=5.780*(lstar^0.25/(reff_out1^0.5) )

END
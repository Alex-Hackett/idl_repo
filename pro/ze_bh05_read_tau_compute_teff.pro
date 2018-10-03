;PRO ZE_BH05_READ_TAU_COMPUTE_TEFF
C=299792000.
dir='/Users/jgroh/temp/'
file='TAU_DATA2'
file2='21500_opac.txt'

lambda_vac=21520.0
obs_freq_in=C*1E-05/lambda_vac*1.D0

;find locations where to start readding, for each inclination angle
READCOL,dir+file,v1
size_all=n_elements(v1)
t1=MIN(ABS(v1-obs_Freq_in),pos1)
t2=MIN(ABS(v1[(pos1+1):*]-obs_Freq_in),pos2)
pos2=pos2+pos1+1
t3=MIN(ABS(v1[(pos2+1):*]-obs_Freq_in),pos3)
pos3=pos3+pos2+1

;read the file 3 times

;LS=dblarr(3)
;delta_indx=ls
;obs_Freq_val=ls
;sm_nray=ls
;inc_ang=ls

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

OPENR,1,dir+file
dummy_vec2=dblarr(pos2-2)
readf,1,dummy_vec2
READF,1,LS2
READF,1,DELTA_INDX2
READF,1,OBS_FREQ_VAL2
READF,1,SM_NRAY2
READF,1,INC_ANG2
z_ray2=dblarr(SM_NRAY2-1)
dtau2=dblarr(SM_NRAY2-1)
tau2=dblarr(SM_NRAY2-1)
;sm_nray=97
;nray=178
READF,1,z_ray2
READF,1,dtau2
FOR I=0, n_elements(tau2) -1 DO tau2[i]=TOTAL(dtau2[0:i])
CLOSE,1

OPENR,1,dir+file
dummy_vec3=dblarr(pos3-2)
readf,1,dummy_vec3
READF,1,LS3
READF,1,DELTA_INDX3
READF,1,OBS_FREQ_VAL3
READF,1,SM_NRAY3
READF,1,INC_ANG3
z_ray3=dblarr(SM_NRAY3-1)
dtau3=dblarr(SM_NRAY3-1)
tau3=dblarr(SM_NRAY3-1)
;sm_nray=97
;nray=178
READF,1,z_ray3
READF,1,dtau3
FOR I=0, n_elements(tau3) -1 DO tau3[i]=TOTAL(dtau3[0:i])
CLOSE,1

rstar=(417.60/6.96)
lstar=5E+06

reff1=z_ray1/6.96
tstar1=5.780*(lstar^0.25/(reff1^0.5) )

reff2=z_ray2/6.96
tstar2=5.780*(lstar^0.25/(reff2^0.5) )

reff3=z_ray3/6.96
tstar3=5.780*(lstar^0.25/(reff3^0.5) )

LINTERP,tau1,reff1,1.0,reff_out1
LINTERP,tau2,reff2,1.0,reff_out2
LINTERP,tau3,reff3,1.0,reff_out3


;READCOL,dir+file2,v2,v3,SKIPLINE=2
;r2=417.60*10^v2
;tau21500=10^v3
;
;
;for I=0, sm_nray-2 DO print,i,z_ray[i],tau[i]
;for I=0, n_elements(r2)-1 DO print,r2[i],tau21500[i]
;
!P.Background = fsc_color('white')
;lineplot,r2,tau21500
lineplot,tstar1,tau1
lineplot,tstar2,tau2
lineplot,tstar3,tau3
END
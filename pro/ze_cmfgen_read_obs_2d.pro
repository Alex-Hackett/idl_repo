PRO ZE_CMFGEN_READ_OBS_2D,filename,modeldir,lambdavac,flux,num_rec,flam=flam
C=299792458.
SPEED_OF_LIGHT=2.99792458E10 ; in cm/s
;Revised version of ZE_CMFGEN_READ_OBS in order to read  OBSFRAME1, OBSFRAME2, OBSFRAME3 generated by 2D models.
;assuming MODEL is present in modeldir
spawn,'grep "Number of observer" '+modeldir+'MODEL',result,/sh
pos=strpos(result,':')
num_rec=float(strmid(result,pos+1))

print,modeldir+filename
print,num_rec
OPENR, lun, modeldir+filename, /GET_LUN

header=strarr(4) 
READF,lun,header
print,header
obs_freq=dblarr(num_rec)
READF,lun,obs_freq

lambdavac=C/obs_freq*1E-05 ;vacuum lambda in Angstroms

header2=strarr(4) 
READF,lun,header2

flux=dblarr(num_rec)
READF,lun,flux

;Release the logical unit number and close the fortran file.  
FREE_LUN, lun  

NBB=num_rec
zero_flux_index_vec=WHERE(flux lt 1e-40)
zero_flux_firstindex=zero_flux_index_vec[0]
for i=0, zero_flux_firstindex -1 DO flux[i]=flux[zero_flux_firstindex]

yv=flux
xv=obs_freq ;in units of 10^15 Hz

;adapted from John's cnvrt.f in /spec_plt/subs
C_CMS=SPEED_OF_LIGHT
T1=1.0E-01/C_CMS      ;1.0E-23*1.0E+30*1.0E-08
FOR I=0.,NBB[0]-1. DO YV(I)=T1*YV(I)*XV(I)*XV(I)

IF keyword_set(FLAM) THEN flux=yv



END
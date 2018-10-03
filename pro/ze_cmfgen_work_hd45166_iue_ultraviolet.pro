;PRO ZE_CMFGEN_WORK_HD45166_IUE_ULTRAVIOLET
;data from IUE archive
file='/Users/jgroh/Downloads/sp32863.txt'
readcol,file,fiue1,fiue2,err,skip=20,FORMAT='D,D,D'
liue=fiue1
for k=0, 16498. do liue[k]=0.05*k +1150.
fiue1[where(fiue1 lt 0)]=0
fiue2[where(fiue2 lt 0)]=0

;models
ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/HD45166/106_copy_exp/obs/obs_fin','/Users/jgroh/ze_models/HD45166/106_copy_exp/obs/obs_cont',l106,f106n,lmin=900,lmax=9000,/AIR
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/HD45166/106_copy_exp/obs/obs_fin',l106,f106,lmin=900,lmax=9000,/FLAM
END
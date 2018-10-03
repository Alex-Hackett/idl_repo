;PRO ZE_WORK_IPTF14ARU_FREMMLING_GALYAM_JESPER
data=READ_ASCII('/Users/jgroh/papers_in_preparation_groh/iptf14aru_fremmling/14aru_20140731_Keck1_v1.ascii.txt',comment='#')

lobs=REFORM(data.field1[0,*])
fobs=REFORM(data.field1[1,*])

dirmod='/Users/jgroh/ze_models/prog13ast/'
model='3'
ZE_CMFGEN_READ_OBS,dirmod+model+'/obs/obs_fin',lprog3,fprog3,LMIN=1200,LMAX=50000,/FLAM

ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/etacar/mod16_groh/obs/obs_fin',l1,f1,/FLAM,lmin=1150,lmax=9000

ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,'/Users/jgroh/ze_models/etacar/','mod16_groh','B',Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt,dist=18.57e3,norm_factor=6.5


;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/14aru/1b/obs/obs_fin',l2,f2,/FLAM,lmin=1150,lmax=9000
;ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/grid_P060z14S0/model005425_T019166_L0964242_logg1.960/obs/obs_fin',l1,f1,/FLAM,lmin=1150,lmax=9000

;redshift correction of observed spectrum
z = 0.003413
lambda_factor=1+z
lobs=lobs/lambda_Factor
dist=18.5737e3 ;in kpc
print
fm_unred, lobs,fobs, 0.05, fobsderedd


;convolving to the same resolution and regridding
f1cnvl=ZE_SPEC_CNVL_VEL(l1,f1,1.0)

;reconvolving to mimic high vinf (remove this later)
f1cnvl=ZE_SPEC_CNVL_VEL(l1,f1,800.0)

line_norm,l1,f1cnvl,f1cnvln

lineplot,lobs,fobsderedd,title='obs' ;* 1e-15
;;lineplot,lobs,f2cnvli/(dist^2) *1.0
;lineplot,lprog3,fprog3/(dist^2)*16.4,title='16' ;*0.63795
lineplot,l1,f1cnvl/(dist^2) *2.54329,title='49' ;*0.63795

;ZE_WRITE_SPECTRA_COL_VEC,'/Users/jgroh/temp/mod16_groh_14aru_to_christoffer_R30000',l1,f1cnvl/(dist^2) * 2.54329
END
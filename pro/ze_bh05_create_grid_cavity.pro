;PRO ZE_BH05_CREATE_GRID_CAVITY,omegamin,omegamax,incmin,incmax,omega_step,inc_step

omegamin=0.80
omegamax=0.81
omega_step=0.01
incmin=0.0
incmax=90.0
inc_step=10.

dir='/aux/pc20163a/jgroh/cmfgen_models/2d_models/etacar/mod111_john/'
dir='/aux/pc20157a/jgroh/cmfgen_models/2D_models/etacar/mod111_john/'
model2d='tilted_owocki_grid2'
grid_dir='/Users/jgroh/temp/bh05_80/'

size_omega=FIX((omegamax-omegamin)/omega_step)+1
size_inc=FIX((incmax-incmin)/inc_step)+1
omega_vec=fltarr(size_omega)
inc_vec=fltarr(size_inc)

FOR i=0, size_omega -1  DO omega_vec[i]=omegamin+omega_step*i
FOR i=0, size_inc -1  DO inc_vec[i]=incmin+inc_step*i

omega_vec=REVERSE(omega_vec)
;omegainc_vec=dblarr(size_omega*size_inc,2)

sufix_vec=strarr(size_omega*size_inc)
omega_vec_str=strcompress(string(100.*omega_Vec, format='(I02)'))
inc_vec_str=strcompress(string(inc_Vec, format='(I02)'))

j=0
k=0
l=1
m=1

FOR i=0., size_omega*size_inc - 1 DO BEGIN  
  IF i GE (size_inc)*m THEN BEGIN
  k=0
  m=m+1
  j=j+1
  ENDIF
  sufix_vec[i]=omega_vec_str[j]+'_'+inc_vec_str[k]
  k=k+1
ENDFOR

;creating directories, has to be executed inside model2d dir
file=grid_dir+'ze_bh05_create_grid_dir.sh'
close,1
openw,1,file     ; open file to write

;for i=0, size_omega*size_inc - 1 do printf,1,'mkdir '+dir+model2d+'/'+sufix_vec[i]
for i=0, size_omega*size_inc - 1 do printf,1,'mkdir '+grid_dir+sufix_vec[i]
close,1

spawn,'source '+file



FOR I=0, size_omega*size_inc - 1 DO BEGIN

; for each model, create CMF_1D_CONTROL file and put it in each directory
file_cmf=grid_dir+sufix_vec[i]+'/CMF_1D_CONTROL'
close,2
openw,2,file_cmf     ; open file to write

printf,2,'F           [CONV_ES_J]         ! Convolve J to J(e.s.)?'
printf,2,'T           [VB_TO_ZERO]        ! Set vbeta to zero?'
printf,2,'T           [DEN_INC]           ! Include density effects?'
printf,2,'T           [DO_AS_2D]          ! Do as if full 2D model'
printf,2,'OWOCKI      [DEN_FUN]           ! Form of density dependence'
printf,2,'0.'+strmid(sufix_vec[i],0,2)+'        [DP1]               ! Omega value (vrot/vcrit)^2'
printf,2,'1.0         [DP2]               ! Dummy - not used
printf,2,'0.0         [TILT_ANG]          ! Tilting angle between pole and density distribution axis
printf,2,'F           [SCALE]             ! Scale ETA,CHI according to density.
close,2

; for each model, create OBS_INP file and put it in each directory
file_obs=grid_dir+sufix_vec[i]+'/OBS_INP'
close,4
openw,4,file_obs    ; open file to write

printf,4,'T           [CMF_MOD]           ! Use 1D cmfgen model.'
printf,4,'F           [2D_MOD]'
printf,4,'150         [NB]                ! # spatial angles'
printf,4,'25          [NDEL_CG]           ! # azi. angles on coarse grid'
printf,4,'25          [NDEL_FG]           ! # azi. angles on fine grid'
printf,4,'1           [N_OBS]             ! Number of angles which spectrum will be computed.'
printf,4,'T           [INC_OPT]           ! Specify explictly observing angles?'
printf,4,strmid(sufix_vec[i],3,3)+'.0D0      [ANG1]              ! Inclination angle measured from pole'
printf,4,'90.0D0      [ANG2]              ! Dummy, not used' 
printf,4,'90.0D0      [ANG3]              ! Dummy, not used'
printf,4,'21517.0     [MIN_WAVE]          !'
printf,4,'21523.0     [MAX_WAVE]          !'
printf,4,'T           [UN_OBS_GRID]'
printf,4,'10.0D0      [DEL_V_OBS]         !'
printf,4,'20.0D0      [VTURB_MIN]         !'
printf,4,'20.0D0      [VTURB_MAX]         !'
printf,4,'0.25D0      [FRAC_DOP]          !In Doppler widths'
printf,4,'20.D0       [TAU_MAX]           !'
printf,4,'0.2D0       [ES_DTAU]           !'
printf,4,'STAU        [INT_METH]          !'
printf,4,'T           [USE_TAB]           ! Use table to save computational effort.'
printf,4,'T           [WRIP]              ! Write flux as a function of impact parameter'
printf,4,'F           [DUST]'
close,4

; for each model, create VEL_IN file and put it in each directory
file_vel=grid_dir+sufix_vec[i]+'/VEL_IN'
close,3
openw,3,file_vel    ; open file to write

printf,3,'NUM           [LAW]           ! Which velocity law option (NUM, CAK, HEFF, IBC)
printf,3,'0.00          [GAM]           ! CAK Gamma'
printf,3,'0.            [V_I]           ! V AT CORE'
printf,3,'0.0D0         [V_ROT]         ! Rotation velocity'
printf,3,''
printf,3,'!'
printf,3,'! Values of V_CRIT and V_ESC are irelvant when CALC_VCRIT is true,'
printf,3,'! but are still required. L_STAR, MU, and EPA are used to compute the '
printf,3,'! radiation pressure due to electrons.'
printf,3,''
printf,3,'F             [CALC_VCRIT]    !'
printf,3,'35.0          [M_STAR]        ! Mass of star'
printf,3,'1.00D+06      [L_STAR]        ! Luminosity of star in Lsun'
printf,3,'1.2D0         [MU]            ! Mean atomic/ionic mass (amu)'
printf,3,'1.10D0        [EPA]           ! Electrons per atom/ion'
printf,3,'!'
printf,3,'265.1         [V_CRIT]        ! Break-up velocity'
printf,3,'200.30        [V_ESC]         ! Escape velocity'
printf,3,'1.7714270E+01 [V_S]           ! Velocity at sonic point.'
printf,3,''
printf,3,'F             [SPEC_VINF_BETA]'
printf,3,'3             [NVB]           !'
printf,3,'0.8           [VB1]           !'
printf,3,'2.2           [VB2]           !'
printf,3,'4.0           [VB3]           !'
close,3

; for each model, create bat2d.sh file and put it in each directory PROBLEMS TO WRITE A SINGLE QUOTATION i.e. ' 
; instead now uses spawn and copy a pre-existing bat2sh.sh file
spawn,'cp '+grid_dir+'bat2d.sh '+grid_dir+sufix_vec[i] 

;file_vel=grid_dir+sufix_vec[i]+'/VEL_IN'
;close,5
;openw,5,file_batsh    ; open file to write
;
;
;printf,5,'#!/bin/csh
;printf,5,''
;printf,5,'limit stacksize unlimited'
;printf,5,'setenv model_obs2D /aux/pc20157b/jgroh/backup_20117/cmfgen_models/etacar/mod_111/obs_groh_full3'
;printf,5,'setenv model /aux/pc20157b/jgroh/backup_20117/cmfgen_models/etacar/mod_111/'
;printf,5,'setenv PROG_2D /aux/pc20157a/jgroh/trans_2d_64/ze_test_select_rhydro_tilted_wind_owocki/sph_obs/obs_frame_2d.exe'
;'
;printf,5,'# ***********************************************************************'
;printf,5,'# Perform soft links so Atomic data files can be accessed.'
;printf,5,'# ***********************************************************************'
;printf,5,''
;printf,5,'ln -sf $model/RVTJ     RVTJ'
;printf,5,''
;printf,5,'ln -sf $model_obs2D/ETA_DATA       ETA_DATA'
;printf,5,'ln -sf $model_obs2D/ETA_DATA_INFO     ETA_DATA_INFO'
;printf,5,''
;printf,5,''
;printf,5,'ln -sf $model_obs2D/CHI_DATA            CHI_DATA'
;printf,5,'ln -sf $model_obs2D/CHI_DATA_INFO       CHI_DATA_INFO'
;printf,5,''
;printf,5,'ln -sf $model_obs2D/ES_J_CONV                   RJ_DATA'
;printf,5,'ln -sf $model_obs2D/ES_J_CONV_INFO           RJ_DATA_INFO'
;printf,5,''
;printf,5,'# ***********************************************************************'
;printf,5,'# Copy file across with main settings.'
;printf,5,'# ***********************************************************************'
;printf,5,''
;printf,5,'#cp -f CMF_FLUX_PARAM_INIT CMF_FLUX_PARAM'
;printf,5,''
;printf,5,''
;printf,5,'# ***********************************************************************'
;printf,5,''
;printf,5,'# Start the job, fist getting the machine name.'
;printf,5,'# We first do a full spectrum calculations'
;printf,5,'
;printf,5,'rm -f bat2d.log'
;printf,5,'
;printf,5,'echo "Machine name is :" > 'bat2d.log' '
;printf,5,'uname -a >> 'bat2d.log' '
;printf,5,'
;printf,5,'echo " " >> 'bat2d.log' '
;printf,5,'echo "Program started on:" >> 'bat2d.log' '
;printf,5,'date >> 'bat2d.log' '
;printf,5,'echo " " >> 'bat2d.log' '
;printf,5,'#'
;printf,5,'$PROG_2D  >>& 'bat2d.log'  << END  '
;printf,5,'END'
;printf,5,''
;printf,5,'#'
;printf,5,'echo "Program finished on:" >> 'bat2d.log' '
;printf,5,'date >> 'bat2d.log' '
;
;close,5

ENDFOR

;paralellizing
nproc=4 ;number of processors
jobs_per_proc=FIX(size_omega*size_inc/nproc)
remainder_jobs=size_omega*size_inc mod nproc
proc_vec=INDGEN(nproc)+1
proc_str=strtrim(STRING(proc_vec),2)
;create master files run_*.sh to run a fraction of the jobs defined by jobs_per_proc
FOR J=0, nproc -1 DO BEGIN
  file_runsh=grid_dir+'/run_'+proc_str[j]+'.sh'
  close,6
  openw,6,file_runsh    ; open file to write

  FOR I=(proc_vec[j]-1)*jobs_per_proc, (proc_vec[j])*jobs_per_proc -1 DO BEGIN
    print,i,j
    printf,6,'cd '+dir+model2d+'/'+sufix_vec[i]
    printf,6 ,'./bat2d.sh'
  ENDFOR 
  IF (J EQ nproc-1) THEN BEGIN
    FOR i=((size_omega*size_inc) - remainder_jobs), (size_omega*size_inc) -1 DO BEGIN
        print,i,j
    printf,6,'cd '+dir+model2d+'/'+sufix_vec[i]
    printf,6 ,'./bat2d.sh'   
    ENDFOR
  ENDIF
  close,6
ENDFOR

;;paralellizing for different computers
;nproc=4  ;number of processors
;;ncomp=4
;jobs_per_proc=FIX(size_omega*size_inc/nproc)
;proc_vec=INDGEN(nproc)+1
;proc_str=strtrim(STRING(proc_vec),2)
;;create master files run_*.sh to run a fraction of the jobs defined by jobs_per_proc
;FOR J=0, nproc -1 DO BEGIN
;  file_runsh=grid_dir+'/run_'+proc_str[j]+'.sh'
;  close,6
;  openw,6,file_runsh    ; open file to write
;
;  FOR I=(proc_vec[j]-1)*jobs_per_proc, (proc_vec[j])*jobs_per_proc-1 DO BEGIN
;    print,i,j
;    printf,6,'cd '+dir+model2d+'/'+sufix_vec[i]
;    printf,6 ,'./bat2d.sh'
;  ENDFOR 
;  close,6
;ENDFOR

END
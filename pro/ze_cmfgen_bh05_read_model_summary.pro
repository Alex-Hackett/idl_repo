PRO ZE_CMFGEN_BH05_READ_MODEL_SUMMARY,dir,model,sufix,nb,ndel_cg,ndel_fg,nobs,ang1,ang2,ang3,min_wave,max_wave,dp1,dp2,dp3,dp4,rp1,rp2,ap1,ap2,wrip
close,/all
;dir='/Users/jgroh/ze_models/2D_models/etacar/mod111_john/'
;model='cut_v3'   ;b,c,o,r,t,u,v don't cover the UV range
;sufix='g'
file='MODEL'
openr,2,dir+model+'/'+sufix+'/'+file     ; open file without writing 
;set text string variables (scratch)
desc1=''
desc2=''
wrip='' & output_format_date='' & completion_of_model='' & program_date='' & was_t_fixed='' & species_name_con=''

;reading standard RVTJ header, and finding the values of ND,NC,NP,NCF,Mdot,L etc
readf,2,desc1
readf,2,desc1
readf,2,desc1
readf,2,desc1 ; CMF_MOD
readf,2,desc1 ; 2D_MOD
readf,2,FORMAT='(I0,5x,A90)',NB,desc1 ;ONLY WOKRING FOR NB < 100
readf,2,FORMAT='(I0,5x,A90)',NDEL_CG,desc1 ;ONLY WOKRING FOR NB < 100
readf,2,FORMAT='(I0,5x,A90)',NDEL_FG,desc1 ;ONLY WOKRING FOR NB < 100
readf,2,FORMAT='(I0,5x,A90)',NOBS,desc1 ;ONLY WOKRING FOR NB < 100
readf,2,desc1 ; INC_OPT
CASE NOBS OF
1.0: BEGIN 
 readf,2,FORMAT='(F0,5x,A90)',ANG1,desc1 ;ONLY WOKRING FOR NB < 100
     END
     
2.0: BEGIN
readf,2,FORMAT='(F0,5x,A90)',ANG1,desc1 ;ONLY WOKRING FOR NB < 100
readf,2,FORMAT='(F0,5x,A90)',ANG2,desc1 ;ONLY WOKRING FOR NB < 100
     END

3.0: BEGIN
readf,2,FORMAT='(F0,5x,A90)',ANG1,desc1 ;ONLY WOKRING FOR NB < 100
readf,2,FORMAT='(F0,5x,A90)',ANG2,desc1 ;ONLY WOKRING FOR NB < 100
readf,2,FORMAT='(F0,5x,A90)',ANG3,desc1 ;ONLY WOKRING FOR NB < 100
     END
     
ENDCASE

readf,2,FORMAT='(F0,5x,A90)',MIN_WAVE,desc1 ;ONLY WOKRING FOR NB < 100
readf,2,FORMAT='(F0,5x,A90)',MAX_WAVE,desc1 ;ONLY WOKRING FOR NB < 100
readf,2,desc1 ; UN_OBS_GRID
readf,2,FORMAT='(F0,5x,A90)',DEL_V_OBS,desc1 ;ONLY WOKRING FOR NB < 100
readf,2,FORMAT='(F0,5x,A90)',VTURB_MIN,desc1 ;ONLY WOKRING FOR NB < 100
readf,2,FORMAT='(F0,5x,A90)',VTURB_MAX,desc1 ;ONLY WOKRING FOR NB < 100
readf,2,FORMAT='(F0,5x,A90)',FRAC_DOP,desc1 ;ONLY WOKRING FOR NB < 100
readf,2,desc1 ; UN_OBS_GRID
readf,2,desc1 ; UN_OBS_GRID
readf,2,desc1 ; UN_OBS_GRID
readf,2,desc1 ; UN_OBS_GRID
readf,2,FORMAT='(12x,A1,5x,A0)',wrip,desc1 ; WRIP
readf,2,desc1 ; UN_OBS_GRID
readf,2,desc1 ; UN_OBS_GRID
readf,2,desc1 ; UN_OBS_GRID
readf,2,desc1 ; UN_OBS_GRID
readf,2,desc1 ; UN_OBS_GRID
readf,2,desc1 ; UN_OBS_GRID
readf,2,desc1 ; UN_OBS_GRID
readf,2,desc1 ; UN_OBS_GRID
readf,2,desc1 ; DEN_FUN
readf,2,FORMAT='(F0,5x,A90)',DP1,desc1 ;ONLY WOKRING FOR NB < 100
readf,2,FORMAT='(F0,5x,A90)',DP2,desc1 ;ONLY WOKRING FOR NB < 100
readf,2,FORMAT='(F0,5x,A90)',DP3,desc1 ;ONLY WOKRING FOR NB < 100
readf,2,FORMAT='(F0,5x,A90)',DP4,desc1 ;ONLY WOKRING FOR NB < 100
readf,2,FORMAT='(F0,5x,A90)',RP1,desc1 ;ONLY WOKRING FOR NB < 100
readf,2,FORMAT='(F0,5x,A90)',RP2,desc1 ;ONLY WOKRING FOR NB < 100
readf,2,FORMAT='(F0,5x,A90)',AP1,desc1 ;ONLY WOKRING FOR NB < 100
readf,2,FORMAT='(F0,5x,A90)',AP2,desc1 ;ONLY WOKRING FOR NB < 100


close,2

END
;PRO ZE_ETACAR_CMFGEN_MODEL_CUT_JOHN_TOM_PRODUCE_TABLE_MODEL_SUMMARY,dir,model,sufix,nb,ndel_cg,ndel_fg,nobs,ang1,ang2,ang3,min_wave,max_wave,dp1,dp2,dp3,dp4,rp1,rp2,ap1,ap2
close,/all
dir='/Users/jgroh/ze_models/2D_models/etacar/mod111_john/'

model='cut_v3'   ;b,c,o,r,t,u,v don't cover the UV range
sufix=['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u']

nmodels=n_elements(sufix)
nb_all=fltarr(nmodels) & ndel_cg_all=nb_all & ndel_fg_all=nb_all & nobs_all=nb_all & ang1_all=nb_all & ang2_all=nb_all & ang3_all=nb_all & min_wave_all=nb_all & max_wave_all=nb_all & dp1_all=nb_all & dp2_all=nb_all &  dp3_all=nb_all & dp4_all=nb_all & rp1_all=nb_all & rp2_all=nb_all & ap1_all=nb_all & ap2_all=nb_all
wrip_all=strarr(nmodels)
wall_all=strarr(nmodels)
wallthick_all=nb_all
half_op_angle_all=nb_all

nvar=20 ; number of model parameters to br written
summary_all_cut_v3=strarr(nvar,nmodels)

FOR I=0, nmodels -1 DO BEGIN
ZE_CMFGEN_BH05_READ_MODEL_SUMMARY,dir,model,sufix[i],nb,ndel_cg,ndel_fg,nobs,ang1,ang2,ang3,min_wave,max_wave,dp1,dp2,dp3,dp4,rp1,rp2,ap1,ap2,wrip
nb_all[i]=nb
ndel_cg_all[i]=ndel_cg
ndel_fg_all[i]=ndel_fg
nobs_all[i]=nobs
ang1_all[i]=ang1
ang2_all[i]=ang2 
ang3_all[i]=ang3  
min_wave_all[i]=min_wave
max_wave_all[i]=max_wave
dp1_all[i]=dp1  
dp2_all[i]=dp2  
dp3_all[i]=dp3  
dp4_all[i]=dp4  
rp1_all[i]=rp1  
rp2_all[i]=rp2 
ap1_all[i]=ap1 
ap2_all[i]=ap2
wrip_all[i]=wrip
half_op_angle_all[i]=(ap1)*180./(nb-1)
IF ap1 eq ap2 THEN  wall_all[i]='F' ELSE wall_all[i]='T'
IF wall_all[i] eq 'F' THEN wallthick_all[i]=0. ELSE wallthick_all[i]=(ap2-ap1)*180./(nb-1)
print,sufix[i],nb,nobs,ang1,ang2,ang3,min_wave,max_wave,dp1,dp2,dp3,dp4,rp1,rp2,ap1,ap2,'  ',wrip,'  ',wall_all[i],wallthick_all[i],half_op_angle_all[i]
summary_all_cut_v3[*,i]=[sufix[i],STRING([nb,nobs,ang1,ang2,ang3,min_wave,max_wave,dp1,dp2,dp3,dp4,rp1,rp2,ap1,ap2]),wrip,wall_all[i],STRING([wallthick_all[i],half_op_angle_all[i]])]
ENDFOR

model='cut_v4'   ;b,c,o,r,t,u,v don't cover the UV range
sufix=['m1','m2','m3','m4','m5','m6','m7','m8','m9','m10','m11','m12','m13','m14','m15','m16','m17','m18','m19','m20','m21']

nmodels=n_elements(sufix)
nb_all=fltarr(nmodels) & ndel_cg_all=nb_all & ndel_fg_all=nb_all & nobs_all=nb_all & ang1_all=nb_all & ang2_all=nb_all & ang3_all=nb_all & min_wave_all=nb_all & max_wave_all=nb_all & dp1_all=nb_all & dp2_all=nb_all &  dp3_all=nb_all & dp4_all=nb_all & rp1_all=nb_all & rp2_all=nb_all & ap1_all=nb_all & ap2_all=nb_all
wrip_all=strarr(nmodels)
wall_all=strarr(nmodels)
wallthick_all=nb_all
half_op_angle_all=nb_all

nvar=20 ; number of model parameters to br written
summary_all_cut_v4=strarr(nvar,nmodels)

FOR I=0, nmodels -1 DO BEGIN
ZE_CMFGEN_BH05_READ_MODEL_SUMMARY,dir,model,sufix[i],nb,ndel_cg,ndel_fg,nobs,ang1,ang2,ang3,min_wave,max_wave,dp1,dp2,dp3,dp4,rp1,rp2,ap1,ap2,wrip
nb_all[i]=nb
ndel_cg_all[i]=ndel_cg
ndel_fg_all[i]=ndel_fg
nobs_all[i]=nobs
ang1_all[i]=ang1
ang2_all[i]=ang2 
ang3_all[i]=ang3  
min_wave_all[i]=min_wave
max_wave_all[i]=max_wave
dp1_all[i]=dp1  
dp2_all[i]=dp2  
dp3_all[i]=dp3  
dp4_all[i]=dp4  
rp1_all[i]=rp1  
rp2_all[i]=rp2 
ap1_all[i]=ap1 
ap2_all[i]=ap2
wrip_all[i]=wrip
half_op_angle_all[i]=(ap1)*180./(nb-1)
IF ap1 eq ap2 THEN  wall_all[i]='F' ELSE wall_all[i]='T'
IF wall_all[i] eq 'F' THEN wallthick_all[i]=0. ELSE wallthick_all[i]=(ap2-ap1)*180./(nb-1)
print,sufix[i],nb,nobs,ang1,ang2,ang3,min_wave,max_wave,dp1,dp2,dp3,dp4,rp1,rp2,ap1,ap2,'  ',wrip,'  ',wall_all[i],wallthick_all[i],half_op_angle_all[i]
summary_all_cut_v4[*,i]=[sufix[i],STRING([nb,nobs,ang1,ang2,ang3,min_wave,max_wave,dp1,dp2,dp3,dp4,rp1,rp2,ap1,ap2]),wrip,wall_all[i],STRING([wallthick_all[i],half_op_angle_all[i]])]
ENDFOR


model='cut_v4'
theData=summary_all_cut_v4

;write CSV file
output='/Users/jgroh/temp/etc_2D_models_summary_'+model+'.csv'
Write_CSV_Data, theData,FILENAME=output

END
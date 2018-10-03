;PRO ZE_WORK
!P.Background = fsc_color('white')
dir='/Users/jgroh/ze_models/2D_models/etacar/mod111_john/'

model1='cut_v4'   
sufix1='spherical_uv1400'
extra_label1=TEXTOIDL(',1')
filename1='OBSFRAME1'
ZE_CMFGEN_READ_OBS_2D,filename1,dir+model1+'/'+sufix1+'/',lm1,fm1,nm1,/FLAM
ZE_BH05_CAVITY_GET_INC_FROM_OBS_INP,dir,model1,sufix1,filename1,inc1,inc_str1
;line_norm,lm1,fm1,fm1n

model2='cut_v4'   
sufix2='m15_uv1400'
extra_label2=TEXTOIDL(',2')
filename2='OBSFRAME1'
ZE_CMFGEN_READ_OBS_2D,filename2,dir+model2+'/'+sufix2+'/',lm2,fm2,nm2,/FLAM
ZE_BH05_CAVITY_GET_INC_FROM_OBS_INP,dir,model2,sufix2,filename2,inc2,inc_str2
;line_norm,lm2,fm2,fm2n

model3='cut_v4'   
sufix3='m25_uv1400'
extra_label3=TEXTOIDL(',3')
filename3='OBSFRAME1'
ZE_CMFGEN_READ_OBS_2D,filename3,dir+model3+'/'+sufix3+'/',lm3,fm3,nm3,/FLAM
ZE_BH05_CAVITY_GET_INC_FROM_OBS_INP,dir,model3,sufix3,filename3,inc3,inc_str3
;line_norm,lm2,fm2,fm2n


lineplot,lm1,fm1
lineplot,lm2,fm2
lineplot,lm3,fm3

END
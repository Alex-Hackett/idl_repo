!P.Background = fsc_color('white')
!P.Color = fsc_color('black')


dir='/Users/jgroh/ze_models/2D_models/etacar/mod111_john/'
model2='azim_changes_test'
sufix2='1d6em3_on_i0_az0'
extra_label2=TEXTOIDL(',az=90^\circ')
filename2='OBSFRAME1'
ZE_CMFGEN_READ_OBS_2D,filename2,dir+model2+'/'+sufix2+'/',lm2,fm2,nm2,/FLAM
;ZE_BH05_CAVITY_GET_INC_FROM_OBS_INP,dir,model2,sufix2,filename2,inc2,inc_str2




END
PRO ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dir,model,sufix,filename,lm,fm,fn,inc,inc_str,FLAM=FLAM

IF KEYWORD_SET(FLAM) THEN flam=1 ELSE flam=0

ZE_CMFGEN_READ_OBS_2D,filename,dir+model+'/'+sufix+'/',lm,fm,countn,FLAM=flam
ZE_BH05_CAVITY_GET_INC_FROM_OBS_INP,dir,model,sufix,filename,inc,inc_str
line_norm,lm,fm,fn


END
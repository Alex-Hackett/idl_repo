PRO ZE_BH05_CAVITY_GET_INC_FROM_OBS_INP,dir,model,sufix,filename,inc,inc_str


;grep inclination angle info from OBS_INP
CASE filename of

'OBSFRAME1': BEGIN
spawn,'grep ANG1 '+dir+model+'/'+sufix+'/OBS_INP' ,result,/sh
inc=90-result ;for cavity models, we have to flip the orientation by 90 degrees
inc_str=strcompress(string(inc, format='(I02)'))
END

'OBSFRAME2': BEGIN
spawn,'grep ANG2 '+dir+model+'/'+sufix+'/OBS_INP' ,result,/sh
inc=90-result ;for cavity models, we have to flip the orientation by 90 degrees
inc_str=strcompress(string(inc, format='(I02)'))
END

'OBSFRAME3': BEGIN
spawn,'grep ANG3 '+dir+model+'/'+sufix+'/OBS_INP' ,result,/sh
inc=90-result ;for cavity models, we have to flip the orientation by 90 degrees
inc_str=strcompress(string(inc, format='(I02)'))
END

ENDCASE


END
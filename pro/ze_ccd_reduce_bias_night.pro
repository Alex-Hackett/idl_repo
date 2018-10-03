PRO ZE_CCD_REDUCE_BIAS_NIGHT,dir,dir_out,starname,bias_med,bias_med_val,save_bias=save_bias
;routine to reduce all bias files in a night dir, and optially saves the results to dir_out

;locate all bias  exposures taken in the night dir
ZE_CCD_LOCATE_FILES_IN_STARNAME,starname,'bias',starname_bias_all,index_found_bias
file_bias=dir+starname_bias_all+'.fits'

ZE_CCD_REDUCE_BIAS,dir,file_bias,bias_med,bias_med_val

IF KEYWORD_SET(save_bias) THEN save,file_bias,bias_med,bias_med_val,FILENAME=dir_out+'bias_reduced.sav'

END
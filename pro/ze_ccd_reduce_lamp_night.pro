PRO ZE_CCD_REDUCE_LAMP_NIGHT,dir,dir_out,file_lamp,star,sufix,angle,starname,exptime,ut,airmass_val,rdnoise,time,nightarray,bias_med,flat_norm_night,angle_flat_norm_night,time_flat_norm_night,lamp_array,starname_lamp_night,angle_lamp_night,time_lamp_night,save_lamp=save_lamp

;locate all lamp  exposures taken in the night dir
ZE_CCD_LOCATE_FILES_IN_STARNAME,starname,'tho',starname_lamp_all,index_found_lamp
star_lamp_all=star(index_found_lamp)
sufix_lamp_all=sufix(index_found_lamp)
angle_lamp_all=angle(index_found_lamp)
time_lamp_all=time(index_found_lamp)

;index_lamp_keep=uniq(sufix_lamp_all) ;will remove duplicates using the UNIQ keyword on the sufix_lamp_all file -- works well but will have trouble if the first element of sufix_lamp_all is equal to the last element. could try to edit unique.pro to fix that
index_lamp_keep=indgen(n_elements(star_lamp_all))
nlamp=n_elements(index_lamp_keep)

starname_lamp_night=starname_lamp_all(index_lamp_keep) 
sufix_lamp_night=sufix_lamp_all(index_lamp_keep) 
angle_lamp_night=angle_lamp_all(index_lamp_keep) 
time_lamp_night=time_lamp_all(index_lamp_keep) 

file_lamp=dir+starname_lamp_all+'.fits'

;read one header to obtain detector
detector=strtrim(sxpar(headfits(file_lamp[0]),'DETECTOR'))

CASE DETECTOR OF

  'WI105': BEGIN
  ;read one header to obtain nx and ny of the detector -- these correspond to the header keywords NAXIS1 and NAXIS2, respectively
  nx=sxpar(headfits(file_lamp[0]),'NAXIS2');detector is rotated by 90 degrees compared to CCD098
  ny=sxpar(headfits(file_lamp[0]),'NAXIS1')
  ;default values ccd105
  slow_rdnoise=2.5
  fast_rdnoise=5.0
  ;default bias section for CCD 105
  biassec_l=2060
  biassec_u=2099  
  END
  
  'WI098': BEGIN
  ;read one header to obtain nx and ny of the detector -- these correspond to the header keywords NAXIS1 and NAXIS2, respectively
  nx=sxpar(headfits(file_lamp[0]),'NAXIS1')
  ny=sxpar(headfits(file_lamp[0]),'NAXIS2')
  ;default values ccd098
  slow_rdnoise=2.4
  fast_rdnoise=4.8
  ;default bias section for CCD 098
  biassec_l=4613
  biassec_u=4619
  END
ENDCASE


lamp_array=dblarr(nx,ny,nlamp) & rdnoise_vec=fltarr(nlamp)

for i=0, nlamp - 1 DO BEGIN
  readtemp=mrdfits(file_lamp[i],0,header_lamp)             ;read fits files
  IF DETECTOR EQ 'WI098' THEN lamp_array[*,*,i]=readtemp ELSE lamp_array[*,*,i]=ROTATE(readtemp,3)
  
  rdnoise_vec[i]=sxpar(headfits(file_lamp[i]),'RDNOISE') ;read rdnoise values to ID bias as slow or fast readout
;  print,i
;  help,lamp_array
;  help,bias_med
  IF (rdnoise_vec[i] EQ slow_rdnoise) THEN lamp_array[*,*,i]=lamp_array[*,*,i] - bias_med[*,*,0] ELSE lamp_array[*,*,i]=lamp_array[*,*,i] - bias_med[*,*,1]  ;bias subtraction, recognizes from RDNOISE whether slow or fast readout was used
   
  ZE_CCD_MATCH_ANGLE_MINTIME_FLAT,angle_lamp_night,time_lamp_night,angle_flat_norm_night,time_flat_norm_night,index_match_angle_mintime_flat
  lamp_array[*,*,i]=lamp_array[*,*,i] / flat_norm_night[*,*,index_match_angle_mintime_flat]

endfor

IF KEYWORD_SET(save_lamp) THEN save,lamp_array,starname_lamp_night,angle_lamp_night,time_lamp_night,FILENAME=dir_out+'lamp_reduced.sav'

END


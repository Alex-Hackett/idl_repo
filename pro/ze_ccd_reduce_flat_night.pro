PRO ZE_CCD_REDUCE_FLAT_NIGHT,dir,dir_out,starname,star,sufix,angle,exptime,ut,airmass_val,rdnoise,time,nightarray,bias_med,flat_norm_night,starname_flat_norm_night,sufix_flat_norm_night,angle_flat_norm_night,time_flat_norm_night,save_flat=save_flat
;reduce all flat field files of a given night, returning the normalized flat field image for all allowed grating angles -- if a grating angle was not used during the night, then 0 values are returned in the image 
;works OK

;read one header to obtain detector
detector=strtrim(sxpar(headfits(dir+starname[0]+'.fits'),'DETECTOR'))

CASE DETECTOR OF

  'WI105': BEGIN
  ;read one header to obtain nx and ny of the detector -- these correspond to the header keywords NAXIS1 and NAXIS2, respectively
  nx=sxpar(headfits(dir+starname[0]+'.fits'),'NAXIS2');detector is rotated by 90 degrees compared to CCD098
  ny=sxpar(headfits(dir+starname[0]+'.fits'),'NAXIS1')
  END
  
  'WI098': BEGIN
  ;read one header to obtain nx and ny of the detector -- these correspond to the header keywords NAXIS1 and NAXIS2, respectively
  nx=sxpar(headfits(dir+starname[0]+'.fits'),'NAXIS1')
  ny=sxpar(headfits(dir+starname[0]+'.fits'),'NAXIS2')

  END
ENDCASE



;locate all flat field exposures taken in the night dir
ZE_CCD_LOCATE_FILES_IN_STARNAME,starname,'fla',starname_flat_all,index_found_flat
star_flat_all=star(index_found_flat)
sufix_flat_all=sufix(index_found_flat)
angle_flat_all=angle(index_found_flat)
time_flat_all=time(index_found_flat)

index_flat_keep=uniq(sufix_flat_all) ;will remove duplicates using the UNIQ keyword on the sufix_flat_all file -- works well but will have trouble if the first element of sufix_flat_all is equal to the last element. could try to edit unique.pro to fix that
nflat=n_elements(index_flat_keep)

starname_flat_norm_night=starname_flat_all(index_flat_keep) 
sufix_flat_norm_night=sufix_flat_all(index_flat_keep) 
angle_flat_norm_night=angle_flat_all(index_flat_keep) 
time_flat_norm_night=time_flat_all(index_flat_keep) 

nflat=n_elements(index_flat_keep)
flat_norm_night=dblarr(nx,ny,nflat)


;now this routine also includes consecutive exposures for the same grat angle 
for i=0, nflat -1 DO BEGIN
  ;tring to include consecutive exposures for the same grat angle
  ZE_CCD_LOCATE_FILES_IN_STARNAME,sufix_flat_all,sufix_flat_norm_night[i],additional_flat_exp,index_addition_flat_found, count_addition_flat_found
  ;this works fine
 ; print,sufix_flat_all,sufix_flat_norm_night[i],additional_flat_exp,index_addition_flat_found, count_addition_flat_found
  IF count_addition_flat_found GT 0 THEN BEGIN
  ;  print,i,' ',index_flat_keep[i],' ',starname_flat_norm_night[i]
  ;  print,index_addition_flat_found,' ',n_elements(index_addition_flat_found),' ',n_elements(index_addition_flat_found)/2.
    reference_index=min([i,(count_addition_flat_found-1)])
    ZE_COMPUTE_DIFFTIME_VECTOR,time_flat_all(index_addition_flat_found),reference_index,difftime ;remember time is in days
  ;  print,difftime,format='(F15.6)'  ;this is also in days
    maxtime=1200.   ;maximum time interval (in seconds) to qualify exposure as being from a consecutive group of exposures
    index_addition_flat_found_keep=index_addition_flat_found(WHERE(abs(difftime) LT (maxtime/(60D*60D*24D))))
    file_flat=dir+starname_flat_all(index_addition_flat_found_keep)+'.fits' 
  ENDIF ELSE file_flat=dir+starname_flat_norm_night[i]+'.fits'
 ; print,file_flat
  ZE_CCD_REDUCE_FLAT,dir,file_flat,angle,bias_med,flat_norm_ang
  flat_norm_night[*,*,i]=flat_norm_ang
endfor

IF KEYWORD_SET(save_flat) THEN save,flat_norm_night,starname_flat_norm_night,sufix_flat_norm_night,angle_flat_norm_night,time_flat_norm_night,FILENAME=dir_out+'flat_reduced.sav'

END
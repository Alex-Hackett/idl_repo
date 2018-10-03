PRO ZE_CCD_REDUCE_SCIENCE_NIGHT,dir,starname,star,sufix,angle,exptime,ut,airmass_val,rdnoise,time,nightarray,bias_med,bias_med_val,flat_norm_night,angle_flat_norm_night,time_flat_norm_night,$
                                lamp_array,starname_lamp_night,angle_lamp_night,time_lamp_night,starname_science_array,lambda_fin_array,spectrum_array,spectrum_norm_array,save_science=save_science,auto=auto

index_science_starname=WHERE(strmatch(starname,'*tho*') EQ 0 AND strmatch(starname,'*bias*') EQ 0 AND strmatch(starname,'*fla*') EQ 0 AND $
         strmatch(starname,'*lixo*') EQ 0 AND strmatch(starname,'*tes*') EQ 0 AND strmatch(starname,'*foco*') EQ 0)
starname_science=starname(index_science_starname)
star_science=star(index_science_starname)
sufix_science=sufix(index_science_starname)
angle_science=angle(index_science_starname)
exptime_science=exptime(index_science_starname)
ut_science=ut(index_science_starname)
airmass_val_science=airmass_val(index_science_starname)
rdnoise_science=rdnoise(index_science_starname)
time_science=time(index_science_starname)
nightarray_science=nightarray(index_science_starname)

nframes=n_elements(index_science_starname)
print,'nframes :',nframes

;read one header to obtain detector
detector=strtrim(sxpar(headfits(dir+starname_science[0]+'.fits'),'DETECTOR'))

CASE DETECTOR OF

  'WI105': BEGIN
  trimsecspec_l=0
  trimsecspec_u=2008
  END
  
  'WI098': BEGIN
  ;read one header to obtain nx and ny of the detector -- these correspond to the header keywords NAXIS1 and NAXIS2, respectively
  trimsecspec_l=0
  trimsecspec_u=4609
  END
ENDCASE

npix=trimsecspec_u-trimsecspec_l+1

lambda_fin_array=dblarr(npix,nframes)
spectrum_array=dblarr(npix,nframes)
spectrum_norm_Array=dblarr(npix,nframes)
starname_science_array=strarr(nframes)

;for i=0, nframes -1 do begin
for i=20, 21 do begin
   ;index_free_lun=indgen(28)+100
   ;for z=0, 27 do free_lun,index_free_lun[z]
  ZE_CCD_REDUCE_SCIENCE,dir,starname_science[i],star_science[i],sufix_science[i],angle_science[i],exptime_science[i],ut_science[i],airmass_val_science[i],rdnoise_science[i],time_science[i],nightarray_science[i],$
                        bias_med,bias_med_val,flat_norm_night,angle_flat_norm_night,time_flat_norm_night,lamp_array,starname_lamp_night,angle_lamp_night,time_lamp_night,$
                        lambda_fin,spectrum,spectrum_norm,xnodes_lamp_autocentroid,ynodes_lamp_autocentroid,auto=0
  lambda_fin_array[*,i]=lambda_fin
  spectrum_array[*,i]=spectrum
  spectrum_norm_Array[*,i]=spectrum_norm
  starname_science_array[i]=starname_science[i]
endfor

IF KEYWORD_SET(save_science) THEN save,starname_science_array,lambda_fin_array,spectrum_array,spectrum_norm_array,FILENAME=dir_out+'science_reduced.sav'

END
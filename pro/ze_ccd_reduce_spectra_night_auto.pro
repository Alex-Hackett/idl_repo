;PRO ZE_CCD_REDUCE_SPECTRA_NIGHT_AUTO,night,dir,dir_out,starname_science_array,lambda_fin_array,spectrum_array,spectrum_norm_array
;main program to do a pipeline reduction of OPD/LNA CamIV spectroscopic data
;does the full reduction for all stars and grating angles in a given night directory
;right now works for night with CCD098 only -- will have to put a switch to rotate observation takes in with CCD 105, and create lamp templates
;does not work if processed files (e.g. flatc_2420001p) are present in the directory, or if bias or flat were averaged beforehand on iraf, and only biasm.fits or fla242m.fits are present
;written by Jose H. Groh
print,'Initial time',systime()
!P.Background = fsc_color('white')

allowed_angles=['131','149','157','168','198','205','234','242','255','308','309','310','384','393']
nallowed_angles=n_elements(allowed_angles)

night_default='11may23'
;night_default='04apr28'
;night_default='07jun26'
base_dir_default='/Users/jgroh/data/lna/ccd_spectra/'
dir_default=base_dir_default+night_default+'/'
dir_out_default=base_dir_default+'reduced/'+night_default+'/'

IF FILE_TEST(dir_out_default) NE 1 THEN spawn,'mkdir '+dir_out_default 

IF n_elements(dir)     eq 0 THEN  dir=dir_default
IF n_elements(dir_out) eq 0 THEN  dir_out=dir_out_default
IF n_elements(night)   eq 0 THEN  night=night_default 

ZE_CCD_PRODUCE_NIGHT_SUMMARY, dir,night,dir_out,starname,exptime,ut,airmass_val,rdnoise,time,ra,dec,nightarray,write=1,xwidget=1,print_screen=0
ZE_CCD_OBTAIN_ANGLE_FROM_STARNAME,starname,allowed_angles,angle,star
ZE_CCD_OBTAIN_SUFIX_FROM_STARNAME,starname,endsufix,sufix
ZE_OBTAIN_STARNAME_SCIENCE_FROM_STARNAME,dir,night,dir_out,star,sufix,angle,starname,exptime,ut,airmass_val,rdnoise,time,ra,dec,nightarray,starname_science,index_science_starname,write=0,xwidget=1,print_screen=0
;
;;script below will reduce all bias, flat, and lamp only once for a given night, and restore .sav files if they already exist 
;IF FILE_TEST(dir_out+'bias_reduced.sav') NE 1 THEN ZE_CCD_REDUCE_BIAS_NIGHT,dir,dir_out,starname,bias_med,bias_med_val,save_bias=1 ELSE restore,dir_out+'bias_reduced.sav'
;
;IF FILE_TEST(dir_out+'flat_reduced.sav') NE 1 THEN ZE_CCD_REDUCE_FLAT_NIGHT,dir,dir_out,starname,star,sufix,angle,exptime,ut,airmass_val,rdnoise,time,nightarray,bias_med,flat_norm_night,$
;                                                                            starname_flat_norm_night,sufix_flat_norm_night,angle_flat_norm_night,time_flat_norm_night,save_flat=1 ELSE restore,dir_out+'flat_reduced.sav'
;
;IF FILE_TEST(dir_out+'lamp_reduced.sav') NE 1 THEN ZE_CCD_REDUCE_LAMP_NIGHT,dir,dir_out,file_lamp,star,sufix,angle,starname,exptime,ut,airmass_val,rdnoise,time,nightarray,bias_med,flat_norm_night,angle_flat_norm_night,$
;                                                                            time_flat_norm_night,lamp_array,starname_lamp_night,angle_lamp_night,time_lamp_night,save_lamp=1 ELSE restore,dir_out+'lamp_reduced.sav'
;
;IF FILE_TEST(dir_out+'science_reduced.sav') NE 1 THEN ZE_CCD_REDUCE_SCIENCE_NIGHT,dir,starname,star,sufix,angle,exptime,ut,airmass_val,rdnoise,time,nightarray,bias_med,bias_med_val,flat_norm_night,angle_flat_norm_night,time_flat_norm_night,$
;                            lamp_array,starname_lamp_night,angle_lamp_night,time_lamp_night,starname_science_array,lambda_fin_array,spectrum_array,spectrum_norm_array,save_science=1,auto=1


print,'End time',systime()
END
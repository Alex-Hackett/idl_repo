PRO ZE_CCD_REDUCE_SCIENCE,dir,starname,star,sufix,angle,exptime,ut,airmass_val,rdnoise,time,nightarray,bias_med,bias_med_val,flat_norm_night,angle_flat_norm_night,time_flat_norm_night,$
                          lamp_array,starname_lamp_night,angle_lamp_night,time_lamp_night,lambda_fin,spectrum,spectrum_norm,xnodes_lamp_autocentroid,ynodes_lamp_autocentroid,auto=auto

file_science=dir+starname+'.fits'

;read header to obtain detector
detector=strtrim(sxpar(headfits(file_science),'DETECTOR'))

CASE DETECTOR OF

  'WI105': BEGIN
  ;read one header to obtain nx and ny of the detector -- these correspond to the header keywords NAXIS1 and NAXIS2, respectively
  nx=sxpar(headfits(file_science),'NAXIS2');detector is rotated by 90 degrees compared to CCD098
  ny=sxpar(headfits(file_science),'NAXIS1')
  ;default values ccd105
  slow_rdnoise=2.5
  fast_rdnoise=5.0
  ;default bias section for CCD 105
  biassec_l=2060
  biassec_u=2099  
  trimsecspec_l=0
  trimsecspec_u=2008
  ;; default trim section is (nx/2 - 60pix):nx/2+60pix) 
  trimsecspat_l=(nx/2 - 80)
  trimsecspat_u=(nx/2 + 80)
  END
  
  'WI098': BEGIN
  ;read one header to obtain nx and ny of the detector -- these correspond to the header keywords NAXIS1 and NAXIS2, respectively
  nx=sxpar(headfits(file_science),'NAXIS1')
  ny=sxpar(headfits(file_science),'NAXIS2')
  ;default values ccd098
  slow_rdnoise=2.4
  fast_rdnoise=4.8
  ;default bias section for CCD 098
  biassec_l=4613
  biassec_u=4619
  trimsecspec_l=0
  trimsecspec_u=4609
  ;; default trim section is (nx/2 - 60pix):nx/2+60pix) 
  trimsecspat_l=(nx/2 - 60)
  trimsecspat_u=(nx/2 + 60)
  END
ENDCASE

readtemp=mrdfits(file_science,0,header_science)

IF DETECTOR EQ 'WI098' THEN science_array=readtemp ELSE science_array=ROTATE(readtemp,3)

;if we wish, biassec and overscan region can be found interactively; in principle needed to be done only once in the night
;ZE_CCD_FIND_OVERSCAN_REGION_BIASSEC_INTERACTIVE,flat0,nx,ny,biassec_u,biassec_l,trimsecspec_u,trimsecspec_l,RETURN_TRIMSEC=0
 
;compute average overscan value on science array -- done to monitor the bias level over the night. Return a scalar number (i.e. order 0 fit).
overscan_med_val=MEDIAN(science_array[trimsecspat_l:trimsecspat_u,biassec_l:biassec_u],/DOUBLE)

science_array_trim=science_array[trimsecspat_l:trimsecspat_u,trimsecspec_l:trimsecspec_u]
flat_norm_night_trim=flat_norm_night[trimsecspat_l:trimsecspat_u,trimsecspec_l:trimsecspec_u,*]
bias_med_trim=bias_med[trimsecspat_l:trimsecspat_u,trimsecspec_l:trimsecspec_u,*]
lamp_trim=lamp_array[trimsecspat_l:trimsecspat_u,trimsecspec_l:trimsecspec_u,*]

;update values of nx and ny, and keep originals as sufix orig
nx_orig=nx & ny_orig=ny
nx=(size(science_array_trim))[1]
ny=(size(science_array_trim))[2]

;bias subtraction,  based on RDNOISE, recognizes whether slow or fast readout was used
IF (rdnoise EQ slow_rdnoise) THEN science_array_trim=science_array_trim - bias_med[*,*,0] ELSE science_array_trim=science_array_trim - bias_med[*,*,1]  

;flat div, first find which flat image should be used
ZE_CCD_MATCH_ANGLE_MINTIME_FLAT,angle,time,angle_flat_norm_night,time_flat_norm_night,index_match_angle_mintime_flat
science_array_trim=science_array_trim / flat_norm_night_trim[*,*,index_match_angle_mintime_flat]

if (n_elements(star_center) eq 0) THEN ZE_CAMIV_SELECT_STAR_CENTER_V2,science_array_trim,star_center,auto=1


ZE_CCD_TRACE_IMAGE_RECTIFIFY, science_array_trim, star_center,specastrom,centervals,xnodescen,ynodescen, science_array_trim_rect ;will have to use the same rectify parameters to extract lamp

center=0
apradius=1
help,science_array_trim_rect,star_center,center,apradius
ZE_CCD_EXTRACT_SPECTRUM,science_array_trim_rect,star_center,center,apradius,spectrum

bw=1
ngrow=2
threshold=10
;ZE_SIGMA_FILTER_1D,spectrum,bw,threshold,ngrow,spectrum_filtered,sigma_val,sigma_med ;sigma filter 1d is not working very well -- wipes out strong Halpha lines!
;spectrum=spectrum_filtered

;;saving reduction results for faster load while testing lambda cal procedure
;save,angle,nx,ny,star_center,specastrom,centervals,xnodescen,ynodescen,spectrum_array,lamp_trim,filename='/Users/jgroh/temp/lna_reduc_'+star+angle+'_'+night+'.sav'
;restore,'/Users/jgroh/temp/lna_reduc_'+star+angle+'_'+night+'.sav'

;find which lamp image should be used
ZE_CCD_MATCH_ANGLE_MINTIME_FLAT,angle,time,angle_lamp_night,time_lamp_night,index_match_angle_mintime_lamp

ZE_CCD_WAVECAL_SPEC,detector,angle,nx,ny,star_center,specastrom,centervals,xnodescen,ynodescen,lamp_trim[*,*,index_match_angle_mintime_lamp],lambda_fin,xnodes_lamp_autocentroid,ynodes_lamp_autocentroid

ZE_CCD_NORM_SPECTRA,lambda_fin,spectrum,angle,spectrum_norm

END
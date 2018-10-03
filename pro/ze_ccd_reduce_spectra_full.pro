;PRO ZE_CCD_REDUCE_SPECTRA_FULL,night,star,angle,dir=dir,dir_out=dir_out
;main program to do a pipeline reduction of OPD/LNA CamIV spectroscopic data
;does the full reduction for a given star and grating angle in a given night
;right now works for night with CCD098 only -- will have to put a switch to rotate observation taken in with CCD 105, and create lamp templates
;written by Jose H. Groh
!P.Background = fsc_color('white')


night_default='11may23'
;night_default='06jun01'
;night_default='07apr01'
base_dir_default='/Users/jgroh/data/lna/ccd_spectra/'
dir_default=base_dir_default+night_default+'/'
dir_out_default=base_dir_default+'reduced/'+night_default+'/'

IF FILE_TEST(dir_out_default) NE 1 THEN spawn,'mkdir '+dir_out_default 

IF n_elements(dir)     eq 0 THEN  dir=dir_default
IF n_elements(dir_out) eq 0 THEN  dir_out=dir_out_default
IF n_elements(night)   eq 0 THEN  night=night_default 

ZE_CCD_PRODUCE_NIGHT_SUMMARY, dir,night,dir_out,starname,exptime,ut,airmass_val,rdnoise,nightarray,write=0,xwidget=1

allowed_angles=['157','198','242','310','384']

IF n_elements(star)  eq 0 THEN  star='hd316285'
IF n_elements(tel)   eq 0 THEN  tel='zetop'
IF n_elements(angle) eq 0 THEN  angle='198'

sufix=star+angle+'_'

;select files interactively
file_science  = DIALOG_PICKFILE(/READ, FILTER = star+'*'+angle+'*.fits',/MULTIPLE,PATH=dir)
;read one header to obtain nx and ny of the detector -- these correspond to the header keywords NAXIS1 and NAXIS2, respectively
nx=sxpar(headfits(file_science[0]),'NAXIS1')
ny=sxpar(headfits(file_science[0]),'NAXIS2')

file_tel  = DIALOG_PICKFILE(/READ, FILTER = tel+'*'+angle+'*.fits',/MULTIPLE,PATH=dir)

file_lamp     = DIALOG_PICKFILE(/READ, FILTER = 'tho*'+angle+'*.fits',/MULTIPLE,PATH=dir)
nframes=n_elements(file_science)
nframes_tel=n_elements(file_tel)

;default bias section for CCD 098
biassec_l=4613
biassec_u=4619

;trim data using trim section; default trim section is (nx/2 - 60pix):nx/2+60pix) 
trimsecspat_l=(nx/2 - 60)
trimsecspat_u=(nx/2 + 60)
trimsecspec_l=0
trimsecspec_u=4609

ZE_CCD_REDUCE_BIAS,dir,file_bias,bias_med,bias_med_val
ZE_CCD_REDUCE_FLAT,dir,file_flat_on,angle,bias_med,flat_norm
;STOP
;build arrays
science_array=dblarr(nx,ny,nframes)
tel_array=dblarr(nx,ny,nframes_tel)


;read fits files
FOR i=0, nframes -1 DO science_array[*,*,i]=mrdfits(file_science[i],0,header_science)
FOR i=0, nframes_tel -1 DO tel_array[*,*,i]=mrdfits(file_tel[i],0,header_tel)
lamp=mrdfits(file_lamp,0,header_lamp)


;if we wish, biassec and overscan region can be found interactively; in principle needed to be done only once in the night
;ZE_CCD_FIND_OVERSCAN_REGION_BIASSEC_INTERACTIVE,flat0,nx,ny,biassec_u,biassec_l,trimsecspec_u,trimsecspec_l,RETURN_TRIMSEC=0
 
;compute average overscan value on science array -- done to monitor the bias level over the night. Return a scalar number (i.e. order 0 fit).
overscan_med_val=MEDIAN(science_array[trimsecspat_l:trimsecspat_u,biassec_l:biassec_u,*],/DOUBLE)

science_array_trim=science_array[trimsecspat_l:trimsecspat_u,trimsecspec_l:trimsecspec_u,*]
tel_array_trim=tel_array[trimsecspat_l:trimsecspat_u,trimsecspec_l:trimsecspec_u,*]
flat_norm=flat_norm[trimsecspat_l:trimsecspat_u,trimsecspec_l:trimsecspec_u]
bias_med_trim=bias_med[trimsecspat_l:trimsecspat_u,trimsecspec_l:trimsecspec_u,*]
lamp_trim=lamp[trimsecspat_l:trimsecspat_u,trimsecspec_l:trimsecspec_u]

;update values of nx and ny, and keep originals as sufix orig
nx_orig=nx & ny_orig=ny
nx=(size(science_array_trim))[1]
ny=(size(science_array_trim))[2]

;define spectrum array
spectrum_array=dblarr(ny,nframes)
spectrum_tel_array=dblarr(ny,nframes)

;bias sub: assuming slow read, otherwise change index of bias_med to 1
FOR i=0, nframes -1 DO science_array_trim[*,*,i]=science_array_trim[*,*,i] - bias_med_trim[*,*,0] - (overscan_med_val-bias_med_val[0])
FOR i=0, nframes_tel -1 DO tel_array_trim[*,*,i]=tel_array_trim[*,*,i] - bias_med_trim[*,*,0] - (overscan_med_val-bias_med_val[0])
lamp_trim=lamp_trim- bias_med_trim[*,*,0] - (overscan_med_val-bias_med_val[0])

;flat div
FOR i=0, nframes -1 DO science_array_trim[*,*,i]=science_array_trim[*,*,i] / flat_norm
FOR i=0, nframes_tel -1 DO tel_array_trim[*,*,i]=tel_array_trim[*,*,i] / flat_norm
lamp_trim=lamp_trim / flat_norm


FOR i=0, nframes -1 DO BEGIN 
  image=reform(science_array_trim[*,*,i])
  if (n_elements(star_center) eq 0) THEN ZE_CAMIV_SELECT_STAR_CENTER,image,star_center
  image_Rect=dblarr(nx,ny)
  ZE_CCD_TRACE_IMAGE_RECTIFIFY, image, star_center,specastrom,centervals,xnodescen,ynodescen, image_rect ;will have to use the same rectify parameters to extract lamp

  center=0
  apradius=1
  ZE_CCD_EXTRACT_SPECTRUM,image_rect,star_center,center,apradius,spectrum

  bw=1
  ngrow=2
  threshold=10
  ;ZE_SIGMA_FILTER_1D,spectrum,bw,threshold,ngrow,spectrum_filtered,sigma_val,sigma_med ;sigma filter 1d is not working very well -- wipes out strong Halpha lines!
  spectrum_array[*,i]=spectrum

ENDFOR

;;saving reduction results for faster load while testing lambda cal procedure
;save,angle,nx,ny,star_center,specastrom,centervals,xnodescen,ynodescen,spectrum_array,lamp_trim,filename='/Users/jgroh/temp/lna_reduc_'+star+angle+'_'+night+'.sav'
;restore,'/Users/jgroh/temp/lna_reduc_'+star+angle+'_'+night+'.sav'

ZE_CCD_WAVECAL_SPEC,detector,angle,nx,ny,star_center,specastrom,centervals,xnodescen,ynodescen,lamp_trim,lambda_fin

ZE_CCD_NORM_SPECTRA,lambda_fin,spectrum_array,angle,spectrum_array_norm

END
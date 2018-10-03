;PRO ZE_CAMIV_REDUCE_SPECTRA,dir,star,angle
;main program to do a pipeline reduction of OPD/LNA CamIV spectroscopic data
;written by Jose H. Groh

dir_default='/Users/jgroh/data/lna/camiv_spectra/11mai20/'

IF n_elements(dir) eq 0 THEN dir=dir_default

star='irc10420'
angle='206'

sufix=star+angle+'_'
trimsec_l=90
trimsec_u=287

;select files for flat fielding interactively
;file_science  = DIALOG_PICKFILE(/READ, FILTER = '*.fits',/MULTIPLE,PATH=dir)
;file_flat_on  = DIALOG_PICKFILE(/READ, FILTER = '*on*.fits',/MULTIPLE,PATH=dir)
;file_flat_off = DIALOG_PICKFILE(/READ, FILTER = '*off*.fits',/MULTIPLE,PATH=dir)
;file_lamp     = DIALOG_PICKFILE(/READ, FILTER = '*.fits',/MULTIPLE,PATH=dir)

;read one file to obtain NX and NY 
datascratch=mrdfits(file_flat_on[0],0,header)
nx=(size(datascratch))[1]
ny=(size(datascratch))[2]

nimages_per_pos=3 ;currently assumes 3 exposures per dithering position
nframes=n_elements(file_science)
noffset=FLOOR(nframes/nimages_per_pos)
nflat_on=n_elements(file_flat_on)
nflat_off=n_elements(file_flat_off)

;build arrays
science_array=dblarr(nx,ny,nframes)
flat_on_array=dblarr(nx,ny,nflat_on)
flat_off_array=dblarr(nx,ny,nflat_off)
science_array_sky_sub_flat_comb_offset=dblarr(nx,ny,noffset)

;read fits files
FOR i=0, nframes -1 DO science_array[*,*,i]=mrdfits(file_science[i],0,header_science)
FOR i=0, nflat_on -1 DO flat_on_array[*,*,i]=mrdfits(file_flat_on[i],0,header_flat_off)
FOR i=0, nflat_off -1 DO flat_off_array[*,*,i]=mrdfits(file_flat_off[i],0,header_flat_off)
lamp=mrdfits(file_lamp,0,header_lamp)

;trim data using trim section 
science_array_trim=science_array[trimsec_l:trimsec_u,*,*]
flat_on_array_trim=flat_on_array[trimsec_l:trimsec_u,*,*]
flat_off_array_trim=flat_off_array[trimsec_l:trimsec_u,*,*]

flat_on_med=MEDIAN(flat_on_array_trim,/DOUBLE,diMENSION=3)
flat_off_med=MEDIAN(flat_off_array_trim,/DOUBLE,diMENSION=3)
flat_sub=flat_on_med-flat_off_med
flat_norm=flat_sub/(MOMENT(flat_sub[50:160,*]))[0]
flat_norm=sigma_filter(flat_norm,5,n_sigma=3)

sky_crude=MEDIAN(science_array_trim,/DOUBLE,diMENSION=3)
;ZE_CAMIV_SKY_SUBTRACT_ADAPTIVE,science_array_trim,nframes,nimages_per_pos,science_array_sky_sub,sky_image

ZE_CAMIV_FLATFIELD_DIVIDE,science_array_sky_sub,nframes,flat_norm,science_array_sky_sub_flat


image=TOTAL(science_array_sky_sub_flat[*,*,0:2],3)/3.0
;image=reform(science_array_sky_sub_flat[*,*,1])
undefine,star_center_calib
if (n_elements(star_center_calib) eq 0) THEN BEGIN 
  ZE_CAMIV_SELECT_STAR_CENTER,image,star=star
  star_center_calib=star
ENDIF


;shifting each column in the spatial direction 
  ;1st finding centroids using gaussians
  ;image=ROTATE(image,4)
  spatindex=(size(image))[1]
  specindex=(size(image))[2]
  y=findgen(spatindex)
  center=dblarr(specindex)
  fwhm_spat=dblarr(specindex) 

  for i=0., specindex-1 do begin
  fit=gaussfit(y,image[*,i],A)
  center[i]=A[1]
  fwhm_spat[i]=2*SQRT(2*ALOG(2))*A[2]*0.16
  endfor

  ;2nd sigma clipping centroids around mean value in order to remove spikes
  meanclip,center,mean_val,sigma_val
  print,sigma_val
  for i=0., specindex-1 do begin
  if center[i] lt (mean_val - 3*sigma_val) then begin
  center[i]=mean_val
  endif
  if center[i] gt (mean_val + 3*sigma_val) then begin
  center[i]=mean_val
  endif
  endfor
  
  ;3rd manually replacing the first 7 pixels by crude linear interpolation in order to remove the influence of the teluric line
        ;
  for i=0, 6 do begin
  center[i]=center[7]+ ((7-i)*(center[8]-center[7]))
  endfor
  
  ; 3rd fitting centroids
  x=indgen(specindex)
  yfit2 = poly_fit2(x, center, 2)  ;LINEAR FIT
  line_norm,x,center,centernorm,centervals,xnodescen,ynodescen ;SPLINE FIT INTERACTIVE, BETTER CHOICE
        ;

  ;convolve with a gaussian with a fwhm in the spectral direction?
  ;fwhm=2.35*1.1
  fwhm_spatval=30.
  ;center2=cnvlgauss(center,fwhm=fwhmspatval)
        
  ; 4th finding offsets which can be relative to a given  line (arbitrary) 410 (i.e. 411) or to the mean centroid value
  ;
  spatoffset=centervals-star_center_calib
 
  ;
  ;plotting routines for debugging
  LOADCT,0
  window,8
  plot,center 
  oplot,yfit2,color=fsc_color('blue'),noclip=0,linestyle=1,thick=1.9 
  ;oplot,center2,color=fsc_color('red')
  oplot,centervals,color=fsc_color('green')

  ;shifting each column by the offset (i.e. shifting in spatial direction) 
  prel=dblarr(specindex)  
  for i=0, spatindex - 1 do begin
  prel[*]=image[i,*]
  prel=shiftf(prel,-1.*spatoffset[i])
  image[i,*]=prel
  endfor



 ;sum flux from  lines centered at center
center=0
apradius=2
flux_sum=0.
for i=0, 2*apradius do begin
flux_sum=REFORM(image[star_center_calib+center-apradius+i,*]+flux_sum)
print,star_center_calib+center-apradius+i
endfor
print,'Spectral aperture extraction of '+number_formatter(((apradius*2)+1)*0.16,decimals=2)+'x 1.5 arcsec'

  
   

END
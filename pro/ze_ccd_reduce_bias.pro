PRO ZE_CCD_REDUCE_BIAS,dir,file_bias,bias_med,bias_med_val
;routine to reduce bias frames and return a median bias image and the median bias value in the overhead section of the chip
; bias_med is a 3D array (nx,ny,2) with the 0 index in the last dimension being the slow readout bias_med (if existent), and the index 1 being the fast readout 
; always return this array even if only one readout was used during the night
;same convention is used for bias_med_val=dblarr(2) : index 0 is slow, index 1 is fast readout

;select files interactively
IF n_elements(file_bias) EQ 0 THEN file_bias  = DIALOG_PICKFILE(/READ, FILTER = 'bias*.fits',/MULTIPLE,PATH=dir)
nbias=n_elements(file_bias)

;read one header to obtain detector
detector=strtrim(sxpar(headfits(file_bias[0]),'DETECTOR'))

CASE DETECTOR OF

  'WI105': BEGIN
  ;read one header to obtain nx and ny of the detector -- these correspond to the header keywords NAXIS1 and NAXIS2, respectively
  nx=sxpar(headfits(file_bias[0]),'NAXIS2');detector is rotated by 90 degrees compared to CCD098
  ny=sxpar(headfits(file_bias[0]),'NAXIS1')
  ;default values ccd105
  slow_rdnoise=2.5
  fast_rdnoise=5.0
  ;default bias section for CCD 105
  biassec_l=2060
  biassec_u=2099
  END
  
  'WI098': BEGIN
  ;read one header to obtain nx and ny of the detector -- these correspond to the header keywords NAXIS1 and NAXIS2, respectively
  nx=sxpar(headfits(file_bias[0]),'NAXIS1')
  ny=sxpar(headfits(file_bias[0]),'NAXIS2')
  ;default values ccd098
  slow_rdnoise=2.4
  fast_rdnoise=4.8
  ;default bias section for CCD 098
  biassec_l=4613
  biassec_u=4619
  END

ENDCASE

  
;default trim section is (nx/2 - 60pix):nx/2+60pix) 
trimsecspat_l=(nx/2 - 60)
trimsecspat_u=(nx/2 + 60)

bias_array=dblarr(nx,ny,nbias) & bias_array_slow=bias_array & bias_array_fast=bias_array & & bias_med=dblarr(nx,ny,2) & rdnoise_vec=fltarr(nbias) & bias_med_val=dblarr(2)

;read fits files
FOR i=0, nbias -1 DO BEGIN 
  readtemp=mrdfits(file_bias[i],0,header_bias)             ;read fits files
  IF DETECTOR EQ 'WI098' THEN bias_array[*,*,i]=readtemp ELSE bias_array[*,*,i]=ROTATE(readtemp,3)
ENDFOR


;read rdnoise values to ID bias as slow or fast readout
FOR i=0, nbias -1 DO rdnoise_vec[i]=sxpar(headfits(file_bias[i]),'RDNOISE')

slowindex=WHERE(rdnoise_vec EQ slow_rdnoise,slowcount)
fastindex=WHERE(rdnoise_vec EQ fast_rdnoise,fastcount)

IF slowcount NE 0 THEN BEGIN
  bias_med_val[0]=MEDIAN(bias_array[trimsecspat_l:trimsecspat_u,biassec_l:biassec_u,slowindex],/DOUBLE)
  bias_med[*,*,0]=MEDIAN(bias_array[*,*,slowindex],/DOUBLE,diMENSION=3)
ENDIF ELSE BEGIN
  bias_med_val[0]=0.
  bias_med[*,*,0]=0.
ENDELSE

IF fastcount NE 0 THEN BEGIN
  bias_med_val[1]=MEDIAN(bias_array[trimsecspat_l:trimsecspat_u,biassec_l:biassec_u,fastindex],/DOUBLE)
  bias_med[*,*,1]=MEDIAN(bias_array[*,*,fastindex],/DOUBLE,diMENSION=3)
ENDIF ELSE BEGIN
  bias_med_val[1]=0.
  bias_med[*,*,1]=0.
ENDELSE

END
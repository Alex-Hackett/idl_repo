PRO ZE_CCD_REDUCE_FLAT,dir,file_flat_on,angle,bias_med,flat_norm
;routine to reduce flat fielding frames and return a median flat-fielding image 
; bias_med is a 3D array (nx,ny,2) with the 0 index in the last dimension being the slow readout bias_med (if existent), and the index 1 being the fast readout 
; always return this array even if only one readout was used during the night
;same convention is used for bias_med_val=dblarr(2) : index 0 is slow, index 1 is fast readout

;select files interactively
IF n_elements(file_flat_on) EQ 0 THEN file_flat_on  = DIALOG_PICKFILE(/READ, FILTER = 'flat*'+angle+'*.fits',/MULTIPLE,PATH=dir)
nflat_on=n_elements(file_flat_on)

;read one header to obtain detector
detector=strtrim(sxpar(headfits(file_flat_on[0]),'DETECTOR'))

CASE DETECTOR OF

  'WI105': BEGIN
  ;read one header to obtain nx and ny of the detector -- these correspond to the header keywords NAXIS1 and NAXIS2, respectively
  nx=sxpar(headfits(file_flat_on[0]),'NAXIS2');detector is rotated by 90 degrees compared to CCD098
  ny=sxpar(headfits(file_flat_on[0]),'NAXIS1')
  ;default values ccd105
  slow_rdnoise=2.5
  fast_rdnoise=5.0
  ;default bias section for CCD 105
  biassec_l=2060
  biassec_u=2099
  END
  
  'WI098': BEGIN
  ;read one header to obtain nx and ny of the detector -- these correspond to the header keywords NAXIS1 and NAXIS2, respectively
  nx=sxpar(headfits(file_flat_on[0]),'NAXIS1')
  ny=sxpar(headfits(file_flat_on[0]),'NAXIS2')
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

flat_on_array=dblarr(nx,ny,nflat_on) & flat_norm=dblarr(nx,ny) & rdnoise_vec=fltarr(nflat_on)

;read fits files

FOR i=0, nflat_on -1 DO BEGIN
  readtemp=mrdfits(file_flat_on[i],0,header_flat_on)             ;read fits files
  IF DETECTOR EQ 'WI098' THEN flat_on_array[*,*,i]=readtemp ELSE flat_on_array[*,*,i]=ROTATE(readtemp,3)
ENDFOR

;read rdnoise values to ID bias as slow or fast readout
FOR i=0, nflat_on -1 DO rdnoise_vec[i]=sxpar(headfits(file_flat_on[i]),'RDNOISE')

slowindex=WHERE(rdnoise_vec EQ slow_rdnoise,slowcount)
fastindex=WHERE(rdnoise_vec EQ fast_rdnoise,fastcount)

IF nflat_on EQ 1 THEN BEGIN ;only one flat field image availalbe
 IF slowcount NE 0 THEN flat_on_med=flat_on_array - bias_med[*,*,0] ELSE flat_on_med=flat_on_array - bias_med[*,*,1] ;ignores possible changes in overscan level during the night
ENDIF ELSE BEGIN  
 IF slowcount NE 0 THEN flat_on_med=MEDIAN(flat_on_array,/DOUBLE,diMENSION=3) - bias_med[*,*,0] ELSE flat_on_med=MEDIAN(flat_on_array,/DOUBLE,diMENSION=3) - bias_med[*,*,1] ;ignores possible changes in overscan level during the night
ENDELSE

flat_norm=flat_on_med/(MOMENT(flat_on_med[0:120,*]))[0]

END
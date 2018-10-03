;;; REDSPEC, a GUI software package for reduction of spectrum data.
;;; Sungsoo S. Kim, UCLA Astronomy
;;; version 1.0 -- October, 2000
;;; version 2.0 -- December, 2000
;;; version 2.5 -- February, 2001
;;;
;;; A quick routine for spatial and spectral rectification only.
;;; Spatial map and spectral map need to be made before using this routine.
;;; This routine is indenpendent from 'pipe.pro' or 'redspec.pro'.


;===============================================================================
PRO rectify, infile, outimage, low=low, vertical=vertical, cal=use_callamp, $
    use_interpol=use_interpol

;;; infile	: input image to be rectified (IDL 2D array or fits file name)
;;; outimage	: clipped, rectified output image (IDL 2D array)
;;; low		: flag for low resolution data
;;; vertical	: flag for vertically running spectrum (low resolution for
;;;		      NIRSPEC)
;;; use_callmap	: flag for the use of callamp instead of tarlamp
;;; use_interpol: flag for using interpolation in rectification instead of
;;;                   using more slow, but more exact mapping method

COMPILE_OPT idl2, hidden

;;; Initialize flags.
if (n_elements(low) eq 0) then low=0
if (n_elements(vertical) eq 0) then vertical=0
if (n_elements(use_callamp) eq 0) then use_callamp=0
if (n_elements(use_interpol) eq 0) then use_interpol=1

if (use_callamp eq 0) then strnow='' else strnow='.cal'

if (n_elements(infile) eq 1) then begin
  ;;;
  ;;; When infile is a fits file name.
  ;;;
  ;;; See if the input file exists.
  get_lun,funit
  openr,funit,infile,error=err
  if (err ne 0) then begin
    free_lun,funit
    printf,"Can not find file '"+infile+"'."
    return
  endif
  close,funit
  free_lun,funit
  ;;; Try to detect if the file is low resoluation data.
  field1 = '' & field2 = 0.
  field1 = SXPAR(HEADFITS(infile), 'CURRINST', count=count1)
  field2 = SXPAR(HEADFITS(infile), 'ECHLPOS',  count=count2)
  if ( (strtrim(field1) eq 'NIRSPEC' or strtrim(field1) eq 'NIRSPAO') and $
      (count2 gt 0)) then begin
    if (field2 gt 100.) then low=1 else low=0
  endif
  ;;; Read the input image file.
  image=readfits(infile,/silent)
endif else begin
  ;;;
  ;;; When infile is an IDL 2D array.
  ;;;
  ;;; See if the input variable is a 2D array.
  sizetemp=size(inimage)
  if (sizetemp[0] ne 2) then begin
    print,'Input variable should be a 2-D array.'
    return
  endif
  ;;; Read the input image file.
  image=infile
endelse

;;; Read spatial map.
get_lun,funit
openr,funit,'spat.map'+strnow,error=err
if (err ne 0) then begin
  free_lun,funit
  printf,"Can not find file 'spat.map'"+strnow+"."
  return
endif
idummy=0 & clip_ya=0 & clip_yb=0
readf,funit,idummy,idummy,clip_ya,clip_yb
close,funit
free_lun,funit

;;; Read spectral map.
get_lun,funit
openr,funit,'spec.map'+strnow,error=err
if (err ne 0) then begin
  free_lun,funit
  printf,"Can not find file 'spec.map'"+strnow+"."
  return
endif
close,funit
free_lun,funit

;;; Rotate if necessary, and clip.
if (vertical eq 1) then low=1
if (low ne 0) then image=rotate(image,3)
sizetemp=size(image) & ydim_orig=sizetemp[2]
image=image[*,clip_ya:clip_yb]

;;; Rectify the image.
print,"=== RECTIFY:  Rectifying the spatial dimension of the image..."
spatrect,image,imagetemp,'spat.map'+strnow,use_interpol=use_interpol
print,"=== RECTIFY:  Done with spatial rectification..."
print,"=== RECTIFY:  Rectifying the spectral dimension of the image..."
specrect,imagetemp,outimage,'spec.map'+strnow,0.,use_interpol=use_interpol
print,"=== RECTIFY:  Done with spectral rectification..."

return
END

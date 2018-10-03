;;; REDSPEC, a GUI software package for reduction of spectrum data.
;;; Sungsoo S. Kim, UCLA Astronomy
;;; version 1.0 -- October, 2000
;;; version 2.0 -- December, 2000
;;; version 2.5 -- February, 2001
;;;
;;; Make a spatial map.


;===============================================================================
PRO spatmap, low=low, vertical=vertical, cal=use_callamp

;;; low		: flag for low resolution data
;;; vertical	: flag for vertically running spectrum (low resolution for
;;;		      NIRSPEC)
;;; use_callamp	: flag for the use of callamp instead of tarlamp

COMPILE_OPT idl2, hidden

!except=0
device,decomposed=0
loadct,39

;;; Initialize flags.
clip_ya=0 & clip_yb=0
if (n_elements(use_callamp) eq 0) then use_callamp=0
if (use_callamp eq 0) then lampnow='target' else lampnow='calibrator'
if (use_callamp eq 0) then strnow='' else strnow='.cal'

;;; See if 'files.in' exists.
get_lun,funit
openr,funit,'files.in',error=err
if (err ne 0) then begin
  free_lun,funit
  errmessage = DIALOG_MESSAGE("Can not find file 'files.in'.",/ERROR)
  return
endif
close,funit
free_lun,funit

;;; Read parameters.
err=fltarr(3)
readpar, lampnow+' arc 1', lampfile1, errtemp & err[0]=errtemp
readpar, 'calibrator nod 1', calfile1, errtemp, /no_field_error & $
    err[1]=errtemp
readpar, 'calibrator nod 2', calfile2, errtemp, /no_field_error & $
    err[2]=errtemp
if (err[0] ne 0) then return
if (err[1] eq 2 or err[2] eq 2) then return

if (err[1] eq 1) then begin
  readpar, 'target nod 1', calfile1, errtemp, /no_field_error & $
      err[1]=errtemp
  if (err[1] ne 0) then begin
    message=DIALOG_MESSAGE('Can not find calibrator or target nod 1.', $
			   /ERROR)
    return
  endif
endif
if (err[2] eq 1) then begin
  readpar, 'target nod 2', calfile2, errtemp, /no_field_error & $
      err[2]=errtemp
  if (err[2] ne 0) then begin
    message=DIALOG_MESSAGE('Can not find calibrator or target nod 2.', $
			   /ERROR)
    return
  endif
endif

;;; Try to detect if the file is low resolution data.
if (n_elements(vertical) ne 0) then begin
  if (vertical eq 1) then low=1
endif
if (n_elements(low) eq 0) then low=0
field1 = '' & field2 = 0.
field1 = SXPAR(HEADFITS(calfile1), 'CURRINST', count=count1)
field2 = SXPAR(HEADFITS(calfile1), 'ECHLPOS',  count=count2)
if ( (strtrim(field1) eq 'NIRSPEC' or strtrim(field1) eq 'NIRSPAO') and $
    (count2 gt 0)) then begin
  if (field2 gt 100.) then low=1 else low=0
endif

;;; Have the user clip the region of interest.
msg='Clip the rows of interest by clicking the lower and upper boundaries.'
displines,lampfile1,lines,-1,msg,'SPATMAP',low=low
if (lines[1] eq -99) then begin
  print,"==="
  print,"=== SPATMAP:  Mission aborted."
  print,"==="
  return
endif
clip_ya=min(lines)
clip_yb=max(lines)

;;; Read the data and remove bad pixels.
cushion=4      ; For better performance of fixpix at the edges.
               ; Do not modify without changing the fixpix_cushion
               ; in displines.pro
ydim=clip_yb-clip_ya+1
cal1=readfits(calfile1,/silent)
if (low ne 0) then cal1=rotate(cal1,3)
cal2=readfits(calfile2,/silent)
if (low ne 0) then cal2=rotate(cal2,3)
sizetemp=size(cal1)
xdim=sizetemp[1]
ydim_orig=sizetemp[2]
cusha=cushion<clip_ya
cushb=cushion<(ydim_orig-1-clip_yb)
cal1=cal1[*,clip_ya-cusha:clip_yb+cushb]
cal2=cal2[*,clip_ya-cusha:clip_yb+cushb]
cal=(cal1+cal2)/2.
print,"=== SPATMAP:  Cleaning the image with `fixpix'..."
cal=fixpix_rs(cal,maskarr,/quiet)
print,"=== SPATMAP:  Done with cleaning..."
cal=cal[*,cusha:ydim-1+cushb]

;;; Have the user indentify the calibrator spectra.
pickcal,cal,obsfitorder,coef
if (obsfitorder eq -99) then begin
  print,"==="
  print,"=== SPATMAP:  Mission aborted."
  print,"==="
  return
endif

;;; Make a spatial map.
sizetemp=size(coef)
nline=sizetemp[0]
recfitorder=1
spatmap=fltarr(recfitorder+1,xdim)
if (nline eq 2) then begin
  fity=[1,2]
  for i=0,xdim-1 do begin
    fitx=fltarr(2)
    for j=0,obsfitorder do fitx[*]=fitx[*]+reform(coef[j,*])*float(i)^j
    spatmap[*,i]=poly_fit(fitx,fity,recfitorder,/double)
  endfor
endif else begin
  for i=0,xdim-1 do begin
    for j=0,obsfitorder do spatmap[0,i]=spatmap[0,i]-coef[j,0]*float(i)^j
    spatmap[1,i]=1
  endfor
endelse

;;; Calculate wavelength information.
;;;
;;; Integers fall on the centers of pixels.
;;; Wavelength of the first pixel becomes "wavecntr-(xdim/2.-0.5)*wavedelta".
bottom=fltarr(xdim) & top=fltarr(xdim)
for j=0,recfitorder do begin
  bottom[*]=bottom[*]+spatmap[j,*]*(-0.5)^j
  top[*]=top[*]+spatmap[j,*]*(ydim-0.5)^j
endfor
wavemin=max(bottom)
wavemax=min(top)
wavecntr=(wavemax+wavemin)/2.
wavedelta=(wavemax-wavemin)/ydim

;;; Save the spatial map.
get_lun,funit
openw,funit,'spat.map'+strnow
printf,funit,recfitorder,xdim,clip_ya,clip_yb,wavecntr,wavedelta, $
    format='(i2,3i5,e15.7,e11.3)'
for i=0,xdim-1 do printf,funit,i+1,spatmap[*,i],format='(i5,5e15.7)'
close,funit
free_lun,funit

;;; Rectify the calibrator image to show the goodness of the rectification.
inimage=cal
print,"=== SPATMAP:  Rectifying the spatial dimension of the image..."
spatrect,inimage,outimage,'spat.map'+strnow,/use_interpol
print,"=== SPATMAP:  Done with spatial rectification..."

;;; Display the rectified image.
final,outimage,type=1,use_callamp=use_callamp

END

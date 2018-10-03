;;; REDSPEC, a GUI software package for reduction of spectrum data.
;;; Sungsoo S. Kim, UCLA Astronomy
;;; version 1.0 -- October, 2000
;;; version 2.0 -- December, 2000
;;; version 2.5 -- February, 2001
;;;
;;; Make a spectral map.


;===============================================================================
PRO specmap, low=low, vertical=vertical, cal=use_callamp, etalon=use_etalon

;;; low         : flag for low resolution data
;;; vertical    : flag for vertically running spectrum (low resolution for
;;;                   NIRSPEC)
;;; use_callamp : flag for the use of callamp instead of tarlamp
;;; etalon	: flag for the use of etalon image for better dispersion
;;;		      solution (not for public use)

COMPILE_OPT idl2, hidden
COMMON specetacom,n_eta,coef_eta,obsfit_eta

!except=0
device,decomposed=0
loadct,39
resolve_routine, 'right'

;;; Initialize flags.
if (n_elements(use_callamp) eq 0) then use_callamp=0
if (n_elements(use_etalon) eq 0) then use_etalon=0
if (use_callamp eq 0) then lampnow='target' else lampnow='calibrator'
if (use_callamp eq 0) then strnow='' else strnow='.cal'

;;; See if 'files.in' exsits.
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
readpar, lampnow+' arc 1', lampfile1, err1
readpar, lampnow+' arc 2', lampfile2, err2, /no_field_error
if (err2 eq 1) then begin
  nlamp=1
endif else begin
  nlamp=2
endelse
if (err1 ne 0 or err2 eq 2) then return

readpar, lampnow+' reference arc', reffile, err3, /no_field_error
readpar, lampnow+' ref. spec map', refspec, err4, /no_field_error
if (err3 eq 2 or err4 eq 2) then return
if (err3+err4 eq 0) then begin
  use_ref=1
endif else begin
  use_ref=0
endelse

;;; Read wavelength data.
wave=fltarr(10000) & wave_2=fltarr(10000)
get_lun,funit
openr,funit,'spec1.in',ERROR=err
if (err ne 0) then begin
  message=DIALOG_MESSAGE( $
	"Can not find file 'spec1.in' in the current directory.",/ERROR)
  free_lun,funit
  return
endif
i=0
while not EOF(funit) do begin
  wavetemp=''
  readf,funit,wavetemp
  wave[i]=float(wavetemp)
  if (wave[i] le 0) then begin
    errmessage = DIALOG_MESSAGE("Incorrect input in file 'spec1.in'.", $
				/ERROR)
    free_lun,funit
    return
  endif
  i=i+1
endwhile
nline=i
close,funit
free_lun,funit
if (nline eq 0) then begin
  errmessage = DIALOG_MESSAGE("No data in file 'spec1.in'.", /ERROR)
  return
endif
wave=wave[0:nline-1]

if (nlamp eq 2) then begin
  get_lun,funit
  openr,funit,'spec2.in',ERROR=err
  if (err ne 0) then begin
    message=DIALOG_MESSAGE( $
	"Can not find file 'spec2.in' in the current directory.",/ERROR)
    free_lun,funit
    return
  endif
  i=0
  while not EOF(funit) do begin
    wavetemp=''
    readf,funit,wavetemp
    wave_2[i]=float(wavetemp)
    if (wave_2[i] le 0) then begin
      errmessage = DIALOG_MESSAGE("Incorrect input in file 'spec2.in'.", $
				/ERROR)
      free_lun,funit
      return
    endif
    i=i+1
  endwhile
  nline_2=i
  close,funit
  free_lun,funit
  if (nline_2 eq 0) then begin
    errmessage = DIALOG_MESSAGE("No data in file 'spec2.in'.", /ERROR)
    return
  endif
  wave_2=wave_2[0:nline_2-1]
endif

;;; Try to detect if the file is low resolution data.
if (n_elements(vertical) ne 0) then begin
  if (vertical eq 1) then low=1
endif
if (n_elements(low) eq 0) then low=0
field1 = '' & field2 = 0.
field1 = SXPAR(HEADFITS(lampfile1), 'CURRINST', count=count1)
field2 = SXPAR(HEADFITS(lampfile1), 'ECHLPOS',  count=count2)
if ( (strtrim(field1) eq 'NIRSPEC' or strtrim(field1) eq 'NIRSPAO') and $
    (count2 gt 0)) then begin
  if (field2 gt 100.) then low=1 else low=0
endif

;;; Read parameters from spatial map.
idummy=0 & xdim=0 & clip_ya=0 & clip_yb=0
get_lun,funit
openr,funit,'spat.map'+strnow,ERROR=err
if (err ne 0) then begin
  errmessage = DIALOG_MESSAGE( $
      "Can not find file 'spat.map"+strnow+"' in the current directory.",/ERROR)
  free_lun,funit
  return
endif
readf,funit,idummy,xdim,clip_ya,clip_yb
close,funit
free_lun,funit

;;; Read the data, remove bad pixels, and rectify the spatial dimension.
cushion=4      ; For better performance of fixpix at the edges.
               ; Do not modify without changing the fixpix_cushion
               ; in displines.pro
ydim=clip_yb-clip_ya+1
image=readfits(lampfile1,/silent)
if (low ne 0) then image=rotate(image,3)
sizetemp=size(image)
ydim_orig=sizetemp[2]
cusha=cushion<clip_ya
cushb=cushion<(ydim_orig-1-clip_yb)
lampraw=image[*,clip_ya-cusha:clip_yb+cushb]
print,"=== SPECMAP:  Cleaning arc 1 with `fixpix'..."
lampraw=fixpix_rs(lampraw,mask,/quiet)
print,"=== SPECMAP:  Done with cleaning..."
lampraw=lampraw[*,cusha:ydim-1+cushb]
print,"=== SPECMAP:  Rectifying the spatial dimension of arc 1..."
spatrect,lampraw,lamp,'spat.map'+strnow,/use_interpol
print,"=== SPECMAP:  Done with spatial rectification..."

if (nlamp eq 2) then begin
  image=readfits(lampfile2,/silent)
  if (low ne 0) then image=rotate(image,3)
  sizetemp=size(image)
  ydim_orig=sizetemp[2]
  cusha=cushion<clip_ya
  cushb=cushion<(ydim_orig-1-clip_yb)
  lampraw_2=image[*,clip_ya-cusha:clip_yb+cushb]
  print,"=== SPECMAP:  Cleaning arc 2 with `fixpix'..."
  lampraw_2=fixpix_rs(lampraw_2,mask,/quiet)
  print,"=== SPECMAP:  Done with cleaning..."
  lampraw_2=lampraw_2[*,cusha:ydim-1+cushb]
  print,"=== SPECMAP:  Rectifying the spatial dimension of arc 2..."
  spatrect,lampraw_2,lamp_2,'spat.map'+strnow,/use_interpol
  print,"=== SPECMAP:  Done with spatial rectification..."
endif

;;; Have the user identify etalon fringes.
;;; Not for public use.
if (use_etalon eq 1) then begin
  etalon, n_eta, coef_eta, obsfit_eta, low=low, use_interpol=use_interpol, $
          use_callamp=use_callamp
endif else begin
  n_eta=0
endelse

;;; Have the user identify the arc lamp lines.
picklamp,lamp,wave,nline,coef,flagline,obsfitorder,recfitorder,nlamp, $
    lamp_2,wave_2,nline_2,coef_2,flagline_2,obsfitorder_2,use_ref=use_ref, $
    low=low,use_callamp=use_callamp
if (obsfitorder eq -99) then begin
  print,"==="
  print,"=== SPECMAP:  Mission aborted."
  print,"==="
  return
endif

;;; Make a spectral map.
if (nlamp eq 1) then begin
  nlinenow=total(flagline)
  specmap=fltarr(recfitorder+1,ydim)
  arc_lambda_residual=fltarr(ydim)
  nflagall=nlinenow
  fitxsave=fltarr(nflagall,ydim)
  fitysave=fltarr(nflagall,ydim)
  yfit=fltarr(nflagall)
  for j=0,ydim-1 do begin
    fitx=fltarr(nline)
    for k=0,obsfitorder do fitx=fitx+coef[k,*]*float(j)^k
    fitx=fitx[where(flagline)]
    fity=wave[where(flagline)]
    if (!version.release ne 5.3) then begin
      specmap[*,j]=poly_fit(fitx,fity,recfitorder,yfit=yfit,/double)
    endif else begin
      specmap[*,j]=poly_fit(fitx,fity,recfitorder,yfit,/double)
    endelse
    arc_lambda_residual[j]=sqrt(total((yfit-fity)^2/(nflagall-1)))
    fitxsave[*,j]=fitx
    fitysave[*,j]=fity
  endfor
endif else begin
  nlinenow=total(flagline)
  nlinenow_2=total(flagline_2)
  specmap=fltarr(recfitorder+1,ydim)
  arc_lambda_residual=fltarr(ydim)
  nflagall=nlinenow+nlinenow_2
  fitxsave=fltarr(nflagall,ydim)
  fitysave=fltarr(nflagall,ydim)
  yfit=fltarr(nflagall)
  for j=0,ydim-1 do begin
    fitx1=fltarr(nline)
    fitx2=fltarr(nline_2)
    for k=0,obsfitorder do fitx1=fitx1+coef[k,*]*float(j)^k
    for k=0,obsfitorder_2 do fitx2=fitx2+coef_2[k,*]*float(j)^k
    fitxtemp=[fitx1,fitx2]
    fitytemp=[wave,wave_2]
    flagboth=[flagline,flagline_2]
    fitxtemp=fitxtemp[where(flagboth)]
    fitytemp=fitytemp[where(flagboth)]
    fitx=fitxtemp[sort(fitxtemp)]
    fity=fitytemp[sort(fitxtemp)]
    specmap[*,j]=poly_fit(fitx,fity,recfitorder,/double)
    arc_lambda_residual[j]=sqrt(total((yfit-fity)^2/(nflagall-1)))
    fitxsave[*,j]=fitx
    fitysave[*,j]=fity
  endfor
endelse

;;; If available, use etalon information to improve the dispersion solution.
;;; Not for public use.
if (n_eta ge 2) then begin
  ;;; Get the etalon einformation.
  etaloninfo,specmap,etalonx,etalony,deltanu,sigma_deltanu, $
             etalon_lambda_residual
  ;;; Recalculate the spectral map with weighted polynomial fitting.
  for j=0,ydim-1 do begin
    fitx=[fitxsave[*,j],etalonx[*,j]]
    fity=[fitysave[*,j],etalony[*,j]]
    weight=[(fltarr(nflagall)+1.)*arc_lambda_residual[j], $
            (fltarr(n_eta)+1.)*etalon_lambda_residual[j]]
    if (!version.release ne 5.3) then begin
      specmap[*,j]=poly_fit(fitx,fity,recfitorder,measure_errors=weight,/double)
    endif else begin
      specmap[*,j]=polyfitw(fitx,fity,weight,recfitorder)
    endelse
  endfor
endif

;;; Calculate wavelength information.
;;;
;;; Integers fall on the centers of pixels.
;;; Wavelength of the first pixel becomes "wavecntr-(xdim/2.-0.5)*wavedelta".
bottom=fltarr(ydim) & top=fltarr(ydim)
for j=0,recfitorder do begin
  bottom[*]=bottom[*]+specmap[j,*]*(-0.5)^j
  top[*]=top[*]+specmap[j,*]*(xdim-0.5)^j
endfor
wavemin=max(bottom)
wavemax=min(top)
wavecntr=(wavemax+wavemin)/2.
wavedelta=(wavemax-wavemin)/xdim

;;; Save the spectral map.
get_lun,funit
openw,funit,'spec.map'+strnow
printf,funit,recfitorder,xdim,clip_ya,clip_yb,wavecntr,wavedelta, $
    format='(i2,3i5,e15.7,e11.3)'
for i=0,ydim-1 do printf,funit,i+clip_ya+1,specmap[*,i],format='(i5,5e15.7)'
close,funit
free_lun,funit

;;; Rectify the arc lamp image to show the goodness of the rectification.
inimage=lamp
print,"=== SPECMAP:  Rectifying the spectral dimension of arc 1..."
specrect,inimage,outimage,'spec.map'+strnow,0.,/use_interpol
print,"=== SPECMAP:  Done with spectral rectification..."

;;; Display the rectified image.
final,outimage,type=2,use_callamp=use_callamp

END

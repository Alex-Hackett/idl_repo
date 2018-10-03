;;; REDSPEC, a GUI software package for reduction of spectrum data.
;;; Sungsoo S. Kim, UCLA Astronomy
;;; version 1.0 -- October, 2000
;;; version 2.0 -- December, 2000
;;; version 2.5 -- February, 2001
;;;
;;; A collection of two routines for the use of reference arc lamp image.


;===============================================================================
FUNCTION shiftfunc,xpix
common shiftcom,recfitorder,specmapnow,lambdanow

;;; Called from refxpix.
;;;
;;; xpix	: input pixel number for calculation of its lambda

COMPILE_OPT idl2, hidden

lambda=0.
for i=0,recfitorder do lambda=lambda+specmapnow[i]*float(xpix)^i
return, lambda-lambdanow

END


;===============================================================================
PRO refxpix,wave,xdim,ycenter,recfitin,specmapin,xpix
common shiftcom,recfitorder,specmapnow,lambdanow

;;; Estimate the pixel number of each arc lamp line from the reference
;;;     spectral map.
;;;
;;; wave	: input wavelength
;;; xdim	: x dimension of the image (input)
;;; ycenter	: center row number of the image (input)
;;; recfitin	: order of polynomial fit for reference spectral map (input)
;;; specmapin	: coefficients of polynomial fit for the center row of
;;;		      reference spectral map (input)
;;; xpix	: estimate of x pixel number for each wavelength given (output)

COMPILE_OPT idl2, hidden

recfitorder=recfitin
specmapnow=specmapin

nline=n_elements(wave)
xpix=fltarr(nline)
for i=0,nline-1 do begin
  lambdanow=wave[i]
  if (shiftfunc(0)*shiftfunc(xdim-1) le 0.) then begin
    xinit=[0,xdim/2,xdim-1]
    xpix[i] = fx_root(xinit,'shiftfunc',TOL=1.e-6,/double)
  endif else begin
    if (shiftfunc(0) gt 0.) then xpix[i]=0.
    if (shiftfunc(0) lt 0.) then xpix[i]=xdim-1.
  endelse
endfor

END


;===============================================================================
PRO refshift,xdim,ycenter,recfitout,specmapnow,low=low,use_callamp=use_callamp

;;; Return the reference spectral map modified for the offset between the
;;;     reference arc image and the current arc image.
;;;
;;; xdim	: x dimension of the image (output)
;;; ycenter	: center row number of the image (output)
;;; recfitout	: order of polynomial fit for reference spectral map (output)
;;; specmapnow	: coefficients of polynomial fit for the center row of
;;;		      reference spectral map (output)
;;; low		: flag for low resolution data (input)
;;; use_callamp	: flag for use of callamp instead of tarlamp (input)

COMPILE_OPT idl2, hidden

;;; Initialize flags.
if (n_elements(low) eq 0) then low=0
if (n_elements(use_callamp) eq 0) then use_callamp=0
if (use_callamp eq 0) then lampnow='target' else lampnow='calibrator'
if (use_callamp eq 0) then strnow='' else strnow='.cal'

;;; Read parameters.
readpar, lampnow+' reference arc', reffile, err1
readpar, lampnow+' arc 1', lampfile1, err2
readpar, lampnow+' ref. spec map', refspec, err3
if (err1+err2+err3 gt 0) then return

;;; Read images.
ref=readfits(reffile)
if (low ne 0) then ref=rotate(ref,3)
lamp=readfits(lampfile1)
if (low ne 0) then lamp=rotate(lamp,3)

;;; Read reference spectral map.
recfitorder=0 & refclip_ya=0 & refclip_yb=0 & wavecntr=0. & wavedelta=0.
idummy = 0
get_lun,funit
openr,funit,refspec,ERROR=err
readf,funit,recfitorder,idummy,refclip_ya,refclip_yb,wavecntr,wavedelta
refydim  = refclip_yb-refclip_ya+1
specmap  = fltarr(recfitorder+1,refydim)
readtemp = fltarr(recfitorder+1)
for i=0,refydim-1 do begin
  readf,funit,idummy,readtemp
  specmap[*,i]=readtemp[*]
endfor
close,funit
free_lun,funit

;;; Read the current spatial map.
idummy=0 & clip_ya=0 & clip_yb=0
get_lun,funit
openr,funit,'spat.map'+strnow,ERROR=err
readf,funit,idummy,xdim,clip_ya,clip_yb
close,funit
free_lun,funit

refcenter = (refclip_ya+refclip_yb)/2
center    = (clip_ya+clip_yb)/2
ydim      = clip_yb-clip_ya+1

nmedian    = min([refydim,ydim,9])
shiftrange = 20.
shiftstep  = 0.5
nshift     = shiftrange*2/shiftstep+1

;;; Calculate the offset between the reference image and the current arc image.
lagmaxsave=fltarr(nmedian)
xi=findgen(fix(xdim/shiftstep+1.e-4)+1)*shiftstep
for k=0,nmedian-1 do begin
  yshift=fix(k-nmedian/2+1.e-4)
  reftemp=ref[*,refcenter+yshift]
  refi=interpolate(reftemp,xi)
  lamptemp=lamp[*,center+yshift]
  lampi=interpolate(lamptemp,xi)
  lag=-fix(shiftrange/shiftstep+1.e-4)+indgen(nshift)
  corrnow=c_correlate(refi,lampi,lag)
  corrmax=max(corrnow,imax)
  lagmaxsave[k]=lag[imax]*shiftstep
endfor

;;; Modify the reference spectral map to reflect the offset found above.
lampshift=median(lagmaxsave)
specmapnow=specmap[*,refcenter-refclip_ya]
specmapnow[0]=specmapnow[0]-lampshift*specmapnow[1]

print,'Offset between reference arc and '+lampnow+' arc 1 is '+ $
    string(lampshift,format='(f4.1)')+' pixel.'

ycenter = center-clip_ya
recfitout=recfitorder

END

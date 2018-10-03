;;; REDSPEC, a GUI software package for reduction of spectrum data.
;;; Sungsoo S. Kim, UCLA Astronomy
;;; version 1.0 -- October, 2000
;;; version 2.0 -- December, 2000
;;; version 2.5 -- February, 2001
;;;
;;; This routine is not in use any more.


;===============================================================================
PRO imshift,lamp,reference,clip_ya,clip_yb,lagout,low=low

COMPILE_OPT idl2, hidden

if (n_elements(low) eq 0) then low=0

lbase=readfits(reference)
if (low ne 0) then lbase=rotate(lbase,3)
lnow=readfits(lamp)
if (low ne 0) then lnow=rotate(lnow,3)

sizetemp = size(lbase)
clip_xa = 1
clip_xb = sizetemp[1]
shiftrange = 7.
shiftstep  = 0.2
nmedian = 9

clip_xa = clip_xa - 1
clip_xb = clip_xb - 1
clip_y=(clip_ya+clip_yb)/2.
nshift = shiftrange*2/shiftstep+1

lagmaxsave=fltarr(nmedian)
xi=findgen((clip_xb-clip_xa)/shiftstep+1)*shiftstep
for k=0,nmedian-1 do begin
  yshift=fix(k-nmedian/2+1.e-4)
  lbasetemp=lbase[clip_xa:clip_xb,clip_y+yshift]
  lbasei=interpolate(lbasetemp,xi)
  lnowtemp=lnow[clip_xa:clip_xb,clip_y+yshift]
  lnowi=interpolate(lnowtemp,xi)
  lag=-fix(shiftrange/shiftstep+1.e-4)+indgen(nshift)
  corrnow=c_correlate(lbasei,lnowi,lag)
  corrmax=max(corrnow,imax)
  lagmaxsave[k]=lag(imax)*shiftstep
endfor

lagout=median(lagmaxsave)

END

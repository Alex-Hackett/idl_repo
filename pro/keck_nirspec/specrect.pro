;;; REDSPEC, a GUI software package for reduction of spectrum data.
;;; Sungsoo S. Kim, UCLA Astronomy
;;; version 1.0 -- October, 2000
;;; version 2.0 -- December, 2000
;;; version 2.5 -- February, 2001
;;;
;;; Rectify the spectral dimension.


;===============================================================================
PRO specrect,inimage,outimage,specfile,lampshift,use_interpol=use_interpol

;;; inimage     : input image to be rectified
;;; outimage    : rectified output image
;;; lampshift	: offset between the current arc image and the reference arc
;;;		      image (obsolete)
;;; specfile    : file name of the special map (string variable; input)
;;; use_interpol: flag for using interpolation in rectification instead of
;;;                   using more slow, but more exact mapping method (input)

COMPILE_OPT idl2, hidden

;;; Initialize a flag.
if (n_elements(use_interpol) eq 0) then use_interpol=0

;;; Read parameters and spectral map.
rectfitorder=0 & xdim=0 & clip_ya=0 & clip_ya=0
wavecntr=0. & wavedelta=0. & idummy=0
get_lun,funit
openr,funit,specfile
readf,funit,recfitorder,xdim,clip_ya,clip_yb,wavecntr,wavedelta
ydim=clip_yb-clip_ya+1
wavemin=wavecntr-(xdim/2.)*wavedelta
specmap=fltarr(recfitorder+1,ydim)
readtemp=fltarr(recfitorder+1)
for i=0,ydim-1 do begin
  readf,funit,idummy,readtemp
  specmap[*,i]=readtemp[*]
endfor
close,funit
free_lun,funit

;;; Correct the spectral map by the offset between the reference arc image
;;;     and the current arc image, assuming that the dispersion solution is
;;;     almost linear.
;;; This correction is not in use any more.
specmap[0,*]=specmap[0,*]-lampshift*specmap[1,*]

outimage=fltarr(xdim,ydim)

if (use_interpol eq 0) then begin
  ;;; Mapping
  for j=0,xdim-1 do begin
    wavebot=fltarr(ydim) & wavetop=fltarr(ydim)
    for k=0,recfitorder do begin
      wavebot[*]=wavebot[*]+specmap[k,*]*(j-0.5)^k
      wavetop[*]=wavetop[*]+specmap[k,*]*(j+0.5)^k
    endfor
    for i=0,ydim-1 do begin
      waveboti=fix((wavebot[i]-wavemin)/wavedelta)>0
      wavetopi=fix((wavetop[i]-wavemin)/wavedelta)<(xdim-1)
      waverange=wavetop[i]-wavebot[i]
      for k=waveboti,wavetopi do begin
        wavenow=wavemin+wavedelta*k
        botnow=wavebot[i]>wavenow
        topnow=wavetop[i]<(wavenow+wavedelta)
        outimage[k,i]=outimage[k,i]+inimage[j,i]*(topnow-botnow)/waverange
      endfor
    endfor
  endfor
endif else begin
  ;;; Interpolation
  for j=0,ydim-1 do begin
    wavein=fltarr(xdim)
    waveinb=fltarr(xdim+1)
    for k=0,recfitorder do wavein=wavein+specmap[k,j]*findgen(xdim)^k
    for k=0,recfitorder do waveinb=waveinb+specmap[k,j]*(findgen(xdim+1)-0.5)^k
    waveout=wavemin+wavedelta*(findgen(xdim)+0.5)
    datain=inimage[*,j]
    dataout=interpol(datain,wavein,waveout)
    dout_din=wavedelta/(waveinb[1:xdim]-waveinb[0:xdim-1])
    outimage[*,j]=dataout*dout_din
  endfor
endelse

return
END

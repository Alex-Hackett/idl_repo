;;; REDSPEC, a GUI software package for reduction of spectrum data.
;;; Sungsoo S. Kim, UCLA Astronomy
;;; version 1.0 -- October, 2000
;;; version 2.0 -- December, 2000
;;; version 2.5 -- February, 2001
;;;
;;; Rectify the spatial dimension.


;===============================================================================
PRO spatrect,inimage,outimage,spatfile,use_interpol=use_interpol

;;; inimage	: input image to be rectified
;;; outimage	: rectified output image
;;; spatfile	: file name of the spatial map (string variable; input)
;;; use_interpol: flag for using interpolation in rectification instead of
;;;                   using more slow, but more exact mapping method (input)

COMPILE_OPT idl2, hidden

;;; Initialize a flag.
if (n_elements(use_interpol) eq 0) then use_interpol=0

;;; Read parameters and spatial map.
rectfitorder=0 & xdim=0 & clip_ya=0 & clip_yb=0
wavecntr=0. & wavedelta=0. & idummy=0
get_lun,funit
openr,funit,spatfile
readf,funit,recfitorder,xdim,clip_ya,clip_yb,wavecntr,wavedelta
ydim=clip_yb-clip_ya+1
wavemin=wavecntr-(ydim/2.)*wavedelta
spatmap=fltarr(recfitorder+1,xdim)
readtemp=fltarr(recfitorder+1)
for i=0,xdim-1 do begin
  readf,funit,idummy,readtemp
  spatmap[*,i]=readtemp[*]
endfor
close,funit
free_lun,funit

outimage=fltarr(xdim,ydim)

if (use_interpol eq 0) then begin
  ;;; Mapping
  for j=0,ydim-1 do begin
    wavebot=fltarr(xdim) & wavetop=fltarr(xdim)
    for k=0,recfitorder do begin
      wavebot[*]=wavebot[*]+spatmap[k,*]*(j-0.5)^k
      wavetop[*]=wavetop[*]+spatmap[k,*]*(j+0.5)^k
    endfor
    for i=0,xdim-1 do begin
      waveboti=fix((wavebot[i]-wavemin)/wavedelta)>0
      wavetopi=fix((wavetop[i]-wavemin)/wavedelta)<(ydim-1)
      waverange=wavetop[i]-wavebot[i]
      for k=waveboti,wavetopi do begin
        wavenow=wavemin+wavedelta*k
        botnow=wavebot[i]>wavenow
        topnow=wavetop[i]<(wavenow+wavedelta)
        outimage[i,k]=outimage[i,k]+inimage[i,j]*(topnow-botnow)/waverange
      endfor
    endfor
  endfor
endif else begin
  ;;; Interpolation
  for i=0,xdim-1 do begin
    wavein=fltarr(ydim)
    waveinb=fltarr(ydim+1)
    for k=0,recfitorder do wavein=wavein+spatmap[k,i]*findgen(ydim)^k
    for k=0,recfitorder do waveinb=waveinb+spatmap[k,i]*(findgen(ydim+1)-0.5)^k
    waveout=wavemin+wavedelta*(findgen(ydim)+0.5)
    datain=reform(inimage[i,*])
    dataout=interpol(datain,wavein,waveout)
    dout_din=wavedelta/(waveinb[1:ydim]-waveinb[0:ydim-1])
    outimage[i,*]=transpose(dataout*dout_din)
  endfor
endelse

return
END

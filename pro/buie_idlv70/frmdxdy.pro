;+
; NAME:
;  frmdxdy
; PURPOSE:
;  Given two lists of source on field, find the dx,dy offset between lists.
; DESCRIPTION:
;
; CATEGORY:
;  Astrometry
; CALLING SEQUENCE:
;  frmdxdy,x1,y1,x2,y2,xoff,yoff,error
; INPUTS:
;  x1 - X coordinate from list 1, in pixels.
;  y1 - Y coordinate from list 1, in pixels.
;  x2 - X coordinate from list 2, in pixels.
;  y2 - Y coordinate from list 2, in pixels.
; OPTIONAL INPUT PARAMETERS:
;
; KEYWORD INPUT PARAMETERS:
;  NX - maximum extent in X to consider (default is max([x1,x2]))
;  NY - maximum extent in Y to consider (default is max([y1,y2]))
;  MAXERR - maximum error allowed in initial spread test of position.
;              (default=3)
;
; OUTPUTS:
;  xoff - X offset (2-1) between positions in each list.
;  yoff - Y offset (2-1) between positions in each list.
;  error - Flag, set if something went wrong in correlating the lists.
; KEYWORD OUTPUT PARAMETERS:
;  FOM - Figure of merit, a number than can be used (differentially) to
;           measure how good the spatial correlation is.  This number is
;           approximately the fraction of objects in the shortest list that
;           ended up spatially correlated.  A number close to 1 should be
;           good.
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; MODIFICATION HISTORY:
;  99/03/22, Written by Marc W. Buie, Lowell Observatory
;  2005/06/21, MWB, changed called to robomean to trap errors.
;  2007/11/21, MWB, merged with alternate code buried in astrom.pro
;-
pro frmdxdy,x1,y1,x2,y2,xoff,yoff,error, $
      NX=nx,NY=ny,MAXERR=maxerr,FOM=fom

   self='FRMDXDY: '
   if badpar(x1,[2,3,4,5],1,caller=self+'(x1) ') then return
   if badpar(y1,[2,3,4,5],1,caller=self+'(y1) ') then return
   if badpar(x2,[2,3,4,5],1,caller=self+'(x2) ') then return
   if badpar(y2,[2,3,4,5],1,caller=self+'(y2) ') then return

   if badpar(nx,[0,2,3],0,caller=self+'(NX) ', $
                default=long(max([x1,x2]))) then return
   if badpar(ny,[0,2,3],0,caller=self+'(NY) ', $
                default=long(max([y1,y2]))) then return
   if badpar(maxerr,[0,2,3,4,5],0,caller=self+'(MAXERR) ', $
                default=3.0) then return

   n1 = n_elements(x1)
   n2 = n_elements(x2)
   normfac = float(min([n1,n2]))

   ; The first step is to generate a cross-correlation image and find the
   ;    peak, this gives a crude offset.
   dxdy=intarr(nx,ny)
   for i=0L,n1-1 do begin
      dx = fix(x2-x1[i]+0.5+nx/2.0)
      dy = fix(y2-y1[i]+0.5+ny/2.0)
      zd=where(dx ge 0 and dx lt nx and $
               dy ge 0 and dy lt ny,countzd)
      if countzd gt 0 then begin
         dxdy[dx[zd],dy[zd]]=dxdy[dx[zd],dy[zd]]+1
      endif
   endfor
   zd=where(dxdy ge max(dxdy)-1,countmax)
   xoff=(zd mod nx)-nx/2.0
   yoff=zd/nx-ny/2.0
   if countmax gt 1 then begin
      if max(xoff)-min(xoff) gt maxerr then begin
         fom = 0.
         error=1
         xoff=0.
         yoff=0.
         return
      endif
      if max(yoff)-min(yoff) gt maxerr then begin
         fom = 0.
         xoff=0.
         yoff=0.
         error=1
         return
      endif
      xoff = mean(xoff)
      yoff = mean(yoff)
   endif else begin
      xoff=xoff[0]
      yoff=yoff[0]
   endelse

   fndrad=12.0
   basphote,1,dxdy,1.,xoff+nx/2.0,yoff+ny/2.0,fndrad, $
      fndrad+10,fndrad+40,/nolog,/silent,xcen=nxc,ycen=nyc, $
      fwhm=fwhm,rdnoise=0.1,flux=flux,flerr=flerr,skymean=sky,skysig=skysig
   nxc = nxc - nx/2.0
   nyc = nyc - ny/2.0

   if flux le 0. or fwhm le 0. then begin
      error=1
      fom = 0.0
   endif else begin
      error=0
      fom = flux/fwhm/normfac
      xoff = nxc
      yoff = nyc

      ; Using the rough offset, compute a good offset.
      gdx=fltarr(n1)
      gdy=fltarr(n1)
      for i=0L,n1-1 do begin
         tdx=(x2-xoff)-x1[i]
         tdy=(y2-yoff)-y1[i]
         tdr=tdx^2+tdy^2
         zt=where(tdr eq min(tdr))
         zt=zt[0]
         if tdr[zt] lt 3.0 then begin
            gdx[i]=x2[zt[0]]-x1[i]
            gdy[i]=y2[zt[0]]-y1[i]
         endif else begin
            gdx[i]=nx*2
            gdy[i]=ny*2
         endelse
      endfor
      zt=where(gdx lt nx*1.5,countzt)
      if countzt ne 0 then begin
         robomean,gdx[zt],3.0,0.5,avgxoff,error=error
         if error then return
         robomean,gdy[zt],3.0,0.5,avgyoff,error=error
         if error then return
      endif else begin
         error = 1
         fom = 0.0
         return
      endelse

      xoff = avgxoff
      yoff = avgyoff

   endelse


end


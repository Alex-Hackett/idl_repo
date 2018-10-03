;+
; NAME:
;  showsrc
; PURPOSE:   (one line only)
;  Show image with source lists and astrometric references overlain.
; DESCRIPTION:
; CATEGORY:
;  CCD data processing
; CALLING SEQUENCE:
;  showsrc,image,srclist,reflist
; INPUTS:
;  imname - String, file name of image to be read (FITS format assumed)
; OPTIONAL INPUT PARAMETERS:
;  srclist - String, name of FITS file containing the source list.  (Optional)
;  reflist - String, name of raw file containing the reference list. (Optional)
; KEYWORD INPUT PARAMETERS:
;  BINFAC - binning factor to use for display.  Default is the smallest binning
;              needed so that the binned image fits on the display.
;  WINDOWNUM - direct graphics window number to use for display, default=7
; OUTPUTS:
; KEYWORD OUTPUT PARAMETERS:
;  OUTFILE - Name of file to save a screen shot of display image (PNG format).
; COMMON BLOCKS:
; SIDE EFFECTS:
; RESTRICTIONS:
; PROCEDURE:
; MODIFICATION HISTORY:
;  Written by Marc W. Buie, Lowell Observatory, 2007/11/06
;  2008/10/31, MWB, changed to use rdref
;-
pro showsrc,imname,srclist,reflist,OUTFILE=outfile,BINFAC=binfac, $
       WINDOWNUM=windownum

   self='showsrc: '
   if badpar(imname,7,0,caller=self+'(imname) ') then return
   if badpar(srclist,[0,7],0,caller=self+'(srclist) ',default='') then return
   if badpar(reflist,[0,7],0,caller=self+'(reflist) ',default='') then return
   if badpar(outfile,[0,7],0,caller=self+'(OUTFILE) ',default='') then return
   if badpar(windownum,[0,2,3],0,caller=self+'(WINDOWNUM) ',default=7) then return

   if not exists(imname) then begin
      print,self,'Image ',imname,' does not exist'
      return
   endif

   if srclist ne '' and not exists(srclist) then begin
      print,self,'Source list ',srclist,' does not exist'
      return
   endif

   if reflist ne '' and not exists(reflist) then begin
      print,self,'Astrometry reference list ',reflist,' does not exist'
      return
   endif

   image = readfits(imname)
   sz=size(image,/dimen)

   ; figure out the scaling factor for the image.  This is to handle cases
   ;  where the image to be displayed is much larger than the display.
   device,get_screen_size=wsz
   if sz[0] le wsz[0] and sz[1] le wsz[1] then begin
      sf = 1
   endif else begin
      sf = min([sz[0]/wsz[0],sz[1]/wsz[1]])
   endelse
   if badpar(binfac,[0,2,3],0,caller=self+'(BINFAC) ',default=sf) then return
   sf = binfac

   xsm = sz[0] / sf
   ysm = sz[1] / sf
   bim = rebin(float(image[0:xsm*sf-1,0:ysm*sf-1]),xsm,ysm)
   skysclim,bim,lowval,hival
   setwin,windownum,xsize=xsm,ysize=ysm
   tv,bytscl(bim,min=lowval,max=hival,top=255)
   plot,[0],[1],/nodata,xmargin=[0,0],ymargin=[0,0], $
      xr=[0,xsm*sf-1],yr=[0,ysm*sf-1],xstyle=5,ystyle=5,/noerase

   setusym,-1

   if srclist ne '' then begin
      src = readfits(srclist)
      xsrc = src[*,0]
      ysrc = src[*,1]
      plots,xsrc,ysrc,psym=4,color='00ff00'xl,symsize=2
   endif

   if reflist ne '' then begin
      rdref,reflist,ref,referr
      if referr eq 0 then begin
         if ref.nstars gt 0 then $
            plots,ref.xpos,ref.ypos,psym=8,color='00ffff'xl,symsize=3
      endif
   endif

   setusym,1

   if outfile ne '' then begin
      tvgrab,outfile,windownum,/png
   endif

end

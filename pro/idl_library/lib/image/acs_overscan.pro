;+
; $Id: acs_overscan.pro,v 1.4 2002/03/12 18:09:48 mccannwj Exp $
;
; NAME:
;     ACS_OVERSCAN
;
; PURPOSE:
;     Subtract overscan bias level and remove overscan pixels
;
; CATEGORY:
;     ACS/Image
;
; CALLING SEQUENCE:
;     ACS_OVERSCAN, header, image
; 
; INPUTS:
;     header - FITS header
;     image  - image data
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;     The input header and image are modified and returned.
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;     version 1  D. Lindler  Aug 1998
;     Jan 22, 1999, Lindler, Modified to leave values of 65535 in the
;                            image without subtracting the overscan
;     June 22, 2000, Lindler, Modified to work with 2 Amp WFC images
;     Feb 23, 2001, McCann, Fixed to work for single chips (ie. two
;                            amps in serial direction and one in parallel)
;     Jan, 2002, Lindler, Modified to accept header keyword SUBARRAY as
;		a logical
;-
PRO acs_overscan, h, image

   IF N_PARAMS(0) EQ 0 THEN BEGIN
      PRINT, 'CALLING SEQUENCE: acs_overscan,h,image'
      return
   ENDIF
;
; get header information
;
   detector = STRTRIM(sxpar(h,'detector'))
   IF detector EQ 'SBC' THEN RETURN

   amps = strtrim(sxpar(h,'ccdamp'))

   if STRPOS(amps,'A') ge 0 then ampa = 1 else ampa = 0
   if STRPOS(amps,'B') ge 0 then ampb = 1 else ampb = 0
   if STRPOS(amps,'C') ge 0 then ampc = 1 else ampc = 0
   if STRPOS(amps,'D') ge 0 then ampd = 1 else ampd = 0

   namps = STRLEN(amps)
   ccdxcor = sxpar(h,'ccdxcor')
   ccdycor = sxpar(h,'ccdycor')
   expstart = sxpar(h,'expstart')
   subarray = sxpar(h,'subarray')
   if datatype(subarray) eq 'BYT' then $
   	if subarray then subarray = 'SUBARRAY' else subarray = 'FULL'
   nleadac = sxpar(h,'OVER_AC')
   nleadbd = sxpar(h,'OVER_BD')
   ntop = sxpar(h,'OVER_V')
   if subarray eq 'SUBARRAY' then ntop = 0
   nlead = nleadac
   if ampb or ampd then nlead = nleadbd
;
; get size of image 
;
   s = SIZE(image)
   ns = s[1]
   nl = s[2]
;
; determine if double amp readouts in each direction
;
   if (ampa and ampb) or (ampc and ampd) then sdouble = 2 else sdouble = 1
   ldouble = 0
   if (ampa or ampb) then ldouble=ldouble+1
   if (ampc or ampd) then ldouble=ldouble+1
;
; determine trailing overscan
;
   if detector eq 'WFC' then csize = 2048 else csize = 1024
   if (sdouble eq 1) and (ns gt 4000) then csize=4096
   ntrail = (ns/sdouble - csize - nlead)>0
;
; determine region of image to keep
;
   s1 = nlead
   s2 = (nlead + csize - 1)<(ns/sdouble-1)
   l1 = 0
   l2 = nl/ldouble - ntop - 1
   nlout = l2-l1+1  ;output image size for each amp
   nsout = s2-s1+1
;
; determine starting and ending sample in overscan region
; using leading overscan.  skip last 2 pixels in overscan and take the nine
; preceeding ones.
;
   os2 = s1-2       ; go back two pixels
   os1 = os2-8      ; go back up to eight more
   os1 = os1>2      ; skip first two pixels if they are included
   nos = os2-os1+1  ; number of pixels
;
; loop on amps
;
   ;;HELP, sdouble, ldouble
   image_out = FLTARR(nsout*sdouble,nlout*ldouble)
   FOR iamp=0, namps-1 DO BEGIN
      amp = STRMID(amps,iamp,1)
;
; determine offset of the amp in the input image and output image
;
      soff = 0 & loff = 0
      soffout = 0 & loffout = 0
      IF (((amp eq 'B') and ampA) or ((amp eq 'D') and ampC)) THEN BEGIN
         soff = ns/2
         soffout = nsout
      ENDIF
      IF ((amp eq 'C') or (amp eq 'D')) and (ampA or ampB) THEN BEGIN
         loff = nl/2
         loffout = nlout
      ENDIF
;
; extract image region
;
      x0 = soff+s1
      x1 = soff+s2
      y0 = loff+l1
      y1 = loff+l2
      ;;HELP, amp, image, x0, x1, y0, y1, soff, s1, s2
      region = FLOAT(image[x0:x1,y0:y1])
;
; process overscan if more than five acceptable overscan pixels per row
;
      IF nos LT 5 THEN BEGIN
         IF iamp EQ 0 THEN BEGIN
            hist = 'ACS_OVERSCAN: No overscan subtraction possible'
            sxaddhist, hist, h
            IF !DUMP GT 0 THEN PRINT, hist
         ENDIF
         GOTO, no_over
      ENDIF ELSE BEGIN
         IF iamp EQ 0 THEN BEGIN
            hist = 'ACS_OVERSCAN: Overscan subtracted using' +$
             ' columns '+STRTRIM(os1,2)+' to '+ $
             STRTRIM(os2,2)
            sxaddhist, hist, h
            IF !DUMP GT 0 THEN PRINT, hist
         ENDIF
      ENDELSE
;
; extract overscan strip
;
      overscan_strip = image[soff+os1:soff+os2,loff:loff+nlout-1]
;
; collapse with 5 pixel median filter
;
      overscan = FLTARR(nlout)
      FOR i=0,nlout-1 DO overscan[i] = MEDIAN(overscan_strip[*,i])
;
; fit polynomial to all points within 50 DN of the median
;
      med = MEDIAN(overscan)
      good = WHERE(ABS(overscan-med) LT 50,ngood)
      IF ngood LT nlout/2 THEN BEGIN
         hist = 'ACS_OVERSCAN: Overscan region is no good for amp '+amp
         sxaddhist, hist, h
         IF !DUMP GT 0 THEN PRINT, hist
         GOTO, no_over
      ENDIF
      coef = POLY_FIT(good,overscan(good),1)
      fit = coef[0] + FINDGEN(nlout)*coef[1]
;
; subtract fitted overscan from each row (but leave values of 65535)
;
      bad = WHERE(region GT 65534,nbad)
      FOR i=0,nlout-1 DO region[*,i] = region[*,i] - fit[i]
      IF nbad GT 0 THEN region[bad] = 65535
;
; insert region into output image
;
no_over:
      image_out[soffout,loffout] = region
   end
   image = TEMPORARY(image_out)
   return
END

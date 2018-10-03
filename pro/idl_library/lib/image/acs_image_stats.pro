;+
; $Id: acs_image_stats.pro,v 1.2 2001/11/07 15:56:03 mccannwj Exp $
;
; NAME:
;     ACS_IMAGE_STATS
;
; PURPOSE:
;     Get statistics on image and overscan regions.
;
; CATEGORY:
;     ACS/Image
;
; CALLING SEQUENCE:
;     result = ACS_IMAGE_STATS(image [,header])
; 
; INPUTS:
;     image  - properly rotated ACS image or ACS_LOG entry number
;
; OPTIONAL INPUTS:
;     header - ACS FITS header (required unless image is an entry number)
;      
; KEYWORD PARAMETERS:
;     /OVERSCAN - set to only compute the overscan statistics for
;                 faster runtime.
;     /SHOW - display structure for each amp.
;
; OUTPUTS:
;     result - Array of ACS_IMAGE_STATS structures, one per amp.
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; PROCEDURE:
;     The ACS_IMAGE_STATS structure contains the following fields:
;         median_image
;         median_leading
;         median_trailing
;         median_parallel
;         stddev_image
;         stddev_leading
;         stddev_trailing
;         stddev_parallel
;         rms_image
;         rms_leading
;         rms_trailing
;         rms_parallel
;
; EXAMPLE:
;     stat = ACS_IMAGE_STATS(14000)
;     
;
; MODIFICATION HISTORY:
;
;       Thu Jun 22 15:24:21 2000, William Jon McCann
;-

; _____________________________________________________________________________

FUNCTION acs_image_stats_skel
   sStats = { ACS_IMAGE_STATS, $
              median_image: 0e, $
              median_leading: 0e, $
              median_trailing: 0e, $
              median_parallel: 0e, $
              stddev_image: 0e, $
              stddev_leading: 0e, $
              stddev_trailing: 0e, $
              stddev_parallel: 0e, $
              rms_image: 0e, $
              rms_leading: 0e, $
              rms_trailing: 0e, $
              rms_parallel: 0e }
   return, sStats
END 

; _____________________________________________________________________________

FUNCTION acs_image_stats, image_in, h, OVERSCAN_ONLY=over_only, DEBUG=debug, $
                          SHOW=show

   IF N_PARAMS(0) LT 1 THEN BEGIN
      PRINT, 'usage: result=ACS_IMAGE_STATS(image,h)'
      return, -1
   ENDIF

   n_dims = SIZE(image_in, /N_DIMENSIONS)
   IF n_dims LT 2 THEN BEGIN
      ACS_READ, image_in[0], h, image, /WAIT
      use_image_in = 0b
   ENDIF ELSE use_image_in = 1b
;
; get header information
;
   detector = STRTRIM(SXPAR(h,'detector'))
   IF detector EQ 'SBC' THEN return, -1

   amps = STRTRIM(sxpar(h,'ccdamp'),2)
   n_amps = STRLEN(amps)
   IF STRPOS(amps,'A') GE 0 THEN ampa = 1 ELSE ampa = 0
   IF STRPOS(amps,'B') GE 0 THEN ampb = 1 ELSE ampb = 0
   IF STRPOS(amps,'C') GE 0 THEN ampc = 1 ELSE ampc = 0
   IF STRPOS(amps,'D') GE 0 THEN ampd = 1 ELSE ampd = 0

   namps = STRLEN(amps)
   subarray = sxpar(h,'subarray')
   nleadac = sxpar(h,'OVER_AC')
   nleadbd = sxpar(h,'OVER_BD')
   nvirtual = sxpar(h,'OVER_V')
   IF subarray EQ 'SUBARRAY' THEN BEGIN
      nvirtual = 0
      nlead = 0
      ntrail = 0
   ENDIF ELSE nlead = nleadac
   IF ampb OR ampd THEN nlead = nleadbd
;
; get size of image 
;
   image_sz = SIZE( (use_image_in ? image_in : image) )
   ns = image_sz[1]
   nl = image_sz[2]
;
; determine if double amp readouts in each direction
;
   if (ampa and ampc) or (ampb and ampd) then sdouble = 2 else sdouble = 1
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
   s2 = (nlead+csize-1)<(ns/sdouble-1)
   l1 = 0
   l2 = nl/ldouble-nvirtual-1
   nlout = l2-l1+1  ;output image size for each amp
   nsout = s2-s1+1
;
; determine starting and ending sample in overscan region
; using leading overscan.  skip last 2 pixels in overscan and take the nine
; preceeding ones.
;
   los2 = s1-2      ; go back two pixels
   los1 = los2-8    ; go back up to eight more
   los1 = los1>2    ; skip first two pixels if they are included
   nlos = los2-los1+1 ; number of pixels
;
; loop on amps
;
   sStat = acs_image_stats_skel()
   aStats = REPLICATE(sStat,namps)
   FOR iamp=0,namps-1 DO BEGIN
      amp = STRMID(amps,iamp,1)
      IF KEYWORD_SET(debug) THEN HELP, amp
;
; determine offset of the amp in the input image and output image
;
      IF (n_amps EQ 4) THEN ntrail=0
      IF (n_amps GT 1) AND (detector EQ 'HRC') THEN nvirtual=0

      IF subarray NE 'SUBARRAY' THEN BEGIN
         soff = 0 & loff = 0
         soffout = 0 & loffout = 0
         IF (((amp EQ 'B') AND ampA) OR ((amp EQ 'D') AND ampC)) THEN BEGIN
            soff = ns/2
            soffout = nsout
         ENDIF
         IF ((amp EQ 'C') OR (amp EQ 'D')) AND (ampA OR ampB) THEN BEGIN
            loff = nl/2
            loffout = nlout
         ENDIF
      ENDIF ELSE BEGIN
         soff = 0 & loff = 0
         soffout = 0 & loffout = 0
      ENDELSE 
;
; extract image region
;
      ix0 = soff+s1 & ix1 = soff+s2
      IF (amp EQ 'A') OR (amp EQ 'B') THEN BEGIN
         iy0 = loff+l1 & iy1 = loff+l2
      ENDIF ELSE BEGIN
         iy0 = loff+l1+nvirtual & iy1 = loff+l2+nvirtual
      ENDELSE
      IF KEYWORD_SET(debug) THEN HELP, ix0, ix1, iy0, iy1
      IF NOT KEYWORD_SET(over_only) THEN BEGIN
;
; Compute image statistics
;
         aStats[iamp].median_image = MEDIAN((use_image_in ? image_in : image)[ix0:ix1,iy0:iy1])
         aStats[iamp].stddev_image = STDDEV((use_image_in ? image_in : image)[ix0:ix1,iy0:iy1])
         diff = (use_image_in ? image_in : image)[ix0:ix1,iy0:iy1] - aStats[iamp].median_image
                    ; use points less than median to determine RMS
         good = WHERE(diff LE 0,ngood) 
         aStats[iamp].rms_image = (SQRT(TOTAL(diff[good]^2)/ngood))>1
      ENDIF 
;
; process overscan if more than five acceptable overscan pixels per row
;
      IF nlos LT 5 THEN BEGIN
         IF iamp EQ 0 THEN BEGIN
            hist = 'No overscan subtraction possible'
            IF !DUMP GT 0 THEN MESSAGE, hist, /CONTINUE
         ENDIF
         GOTO, no_over
      ENDIF 
;
; extract lead overscan strip
;
      ly0 = loff & ly1 = loff+nlout-1
      IF (amp EQ 'A') OR (amp EQ 'C') THEN BEGIN
         lx0 = soff+los1 & lx1 = soff+los2
      ENDIF ELSE BEGIN
         lx0 = ns-los2-1 & lx1 = ns-los1-1
      ENDELSE 
      IF KEYWORD_SET(debug) THEN HELP, lx0, lx1, ly0, ly1
      lead_overscan = (use_image_in ? image_in : image)[lx0:lx1,ly0:ly1]
;
; Compute lead overscan statistics
;
      aStats[iamp].median_leading = MEDIAN(lead_overscan)
      aStats[iamp].stddev_leading = STDDEV(lead_overscan)
      diff = TEMPORARY(lead_overscan) - aStats[iamp].median_leading
                    ; use points less than median to determine RMS
      good = WHERE(diff LE 0,ngood) 
      aStats[iamp].rms_leading = (SQRT(TOTAL(diff[good]^2)/ngood))>1

      IF ntrail GT 1 THEN BEGIN
;
; extract trail overscan strip
;
         ty0 = loff & ty1 = loff+nlout-1
         IF (amp EQ 'A') OR (amp EQ 'C') THEN BEGIN
            tx0 = ns-ntrail-1 & tx1 = ns-1
         ENDIF ELSE BEGIN
            tx0 = 2 & tx1 = ntrail-3
         ENDELSE
         IF KEYWORD_SET(debug) THEN HELP, tx0, tx1, ty0, ty1
         trail_overscan = (use_image_in ? image_in : image)[tx0:tx1,ty0:ty1]
;
; Compute trail overscan statistics
;
         aStats[iamp].median_trailing = MEDIAN(trail_overscan)
         aStats[iamp].stddev_trailing = STDDEV(trail_overscan)
         diff = TEMPORARY(trail_overscan) - aStats[iamp].median_trailing
                    ; use points less than median to determine RMS
         good = WHERE(diff LE 0,ngood) 
         aStats[iamp].rms_trailing = (SQRT(TOTAL(diff[good]^2)/ngood))>1
      ENDIF 
      IF nvirtual GT 1 THEN BEGIN
;
; extract virtual overscan strip
;
         vx0 = ix0 & vx1 = ix1
         IF (amp EQ 'A') OR (amp EQ 'B') THEN BEGIN
            vy1 = iy1+nvirtual & vy0 = iy1+1
         ENDIF ELSE BEGIN
            vy0 = iy0-nvirtual+1 & vy1 = iy0-2
         ENDELSE
         IF KEYWORD_SET(debug) THEN HELP, vx0, vx1, vy0, vy1
         parallel_overscan = (use_image_in ? image_in : image)[vx0:vx1,vy0:vy1]
;
; Compute trail overscan statistics
;
         aStats[iamp].median_parallel = MEDIAN(parallel_overscan)
         aStats[iamp].stddev_parallel = STDDEV(parallel_overscan)
         diff = TEMPORARY(parallel_overscan) - aStats[iamp].median_parallel
                    ; use points less than median to determine RMS
         good = WHERE(diff LE 0,ngood) 
         aStats[iamp].rms_parallel = (SQRT(TOTAL(diff[good]^2)/ngood))>1
      ENDIF 
NO_OVER:
      IF KEYWORD_SET(show) THEN HELP, /STR, amp, aStats[iamp]
   ENDFOR

   return, aStats
END

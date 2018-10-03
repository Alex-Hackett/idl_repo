;+
; $Id: acs_eer.pro,v 1.1 2001/11/05 21:17:28 mccannwj Exp $
;
; NAME:
;     ACS_EER
;
; PURPOSE:
;     Compute encircled energy vs radius from specified center point,
;     normalizing to 1 at specified radius (rnorm) or adjusting
;     background to produce 0 slope at edge of field (/ADJBKG). Also
;     computes azimuthally-averaged PSF.
;
; CATEGORY:
;     ACS/Analysis
;
; CALLING SEQUENCE:
;     ACS_EER, image, x, y, radius, ee [, azav, /ADJUST, /AZAVG, $
;              BACKGROUND=, /RNORM, SCALE=] 
;
; INPUTS:
;     image  - image array
;     x      - x position of aperture center (pixels)
;     y      - y position of aperture center (pixels)
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:
;     /ADJUST - set to adjust (constant) background level to make slope of
;                EE vs r curve equal 0 at large r
;     /AZAVG  - set to calculate azimuthally-averaged PSF
;     BACKGROUND - specify the background level (scalar) to be
;                subtracted from image.  
;                If /ADJUST is set then also outputs the new
;                background level subtracted from the image.
;     /SHOW - set to plot radius vs encircled energy result
;     /RNORM - set to normalize EE at specified radius
;     SCALE - plate scale (arcsec/pixel), assumed same in both dimensions
;
; OUTPUTS:
;     ee     - vector of energy fraction for each r
;     radius - vector of radius corresponding to ee, scaled by keyword scale
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
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;     revised 11 July 96 to further adj bkg if ee at edge of field < max(ee)
;     adapted from eerd.pro 6 Jun 00 -gfh
;     Cleaned up for ACS library - W.McCann June 2000
;-
PRO ACS_EER, image, xcntr, ycntr, r, ee, azav, SCALE=scale, $
             RNORM=rnorm, AZAVG=azavg, ADJUST=adjbkg, SHOW=show_plot, $
             BACKGROUND=bkgd, SILENT=silent

   IF KEYWORD_SET(adjbkg) THEN azavg=1
   IF N_ELEMENTS(rnorm) EQ 0 THEN rnorm=0
   IF N_ELEMENTS(scale) EQ 0 THEN scale=1.0
   IF N_ELEMENTS(bkgd) LE 0 THEN bkgd=0.0

;find radius of each pixel from image ctr
   image_sz = SIZE(image)
   IF image_sz[0] EQ 1 THEN ny=1 ELSE ny=image_sz[2]
   nx=image_sz[1]

   IF NOT KEYWORD_SET(silent) THEN $
    PRINT, 'Computing encircled energy vs. radius...'
   x = INDGEN(nx) # REPLICATE(1.,ny)
   x = (x-xcntr)
   y = REPLICATE(1.0,nx) # INDGEN(ny)
   y = (y-ycntr)
   rr = SQRT(x*x+y*y)

   rlims = (nx/2-ABS(nx/2-xcntr))
   IF image_sz[0] EQ 2 THEN rlims = rlims<(ny/2-ABS(ny/2-ycntr))
   IF rlims LT nx/4.0 THEN BEGIN
      rlim = nx/4.0
      IF NOT KEYWORD_SET(silent) THEN $
       PRINT, 'Image center close to field edge...estimating EE!', STRING(7b)
   ENDIF ELSE rlim = rlims
   good = WHERE(rr LE rlim)
   rr = rr[good]
   d = image[good] - bkgd[0]
   rlim = FIX(rlim)

   IF KEYWORD_SET(azavg) THEN BEGIN
      ee = FLTARR(rlim+2)
      r = FLTARR(rlim+2)
      r[1] = INDGEN(rlim+1)
      azav = FLTARR(rlim+1)
      nel = FLTARR(rlim+2)
      nin = FLTARR(rlim+1)
      nins = FLTARR(rlim+1)
      FOR i=0,rlim DO BEGIN
         in = WHERE((rr GE r[i]) AND (rr LT r[i+1]))
         IF in[0] NE -1 THEN BEGIN
            tot = TOTAL(d[in])
            nin[i] = N_ELEMENTS(in)
            IF i LT rlims THEN nins[i]=1.0 ELSE nins[i]=(2*!PI*i)/nin[i]
            azav[i] = tot*nins[i]/nin[i]
            nel[i+1] = nel[i]+nin[i]*nins[i]
            ee[i+1] = ee[i]+tot*nins[i]
         ENDIF ELSE ee[i+1] = ee[i]
      ENDFOR

      IF (KEYWORD_SET(adjbkg)) THEN BEGIN
         eet = ee
         dback = 0.0
         nee = N_ELEMENTS(ee)
                    ; adjust backgrd for null slope of EE between radius=.8-1.
         n0 = FIX(0.8*nee)
         n1 = nee-1
         xt = INDGEN(n1-n0+1)
         n_iter = 3
         background_delta = MAKE_ARRAY(n_iter,/DOUBLE)
         FOR i=0,n_iter-1 DO BEGIN
            cf = POLY_FIT(xt,eet[n0:n1], 1, /DOUBLE)
            dback = cf[1]*(n1-n0)/(nel[n1]-nel[n0])
            background_delta[i] = dback
            eet = eet-dback*nel
         ENDFOR
         dback = TOTAL(background_delta)
         ee = eet
         azav = azav-dback
         rnorm = (rlim-1)*scale
         bkgd = DOUBLE(bkgd)+dback
         IF NOT KEYWORD_SET(silent) THEN BEGIN
            PRINT, 'Background adjusted by: ', dback
            PRINT, 'Background is now: ', bkgd
         ENDIF 
      ENDIF
      r = (r-0.5)>0
   ENDIF ELSE BEGIN
      ng = N_ELEMENTS(good)
      a = SORT(rr)  ; sort into ascending radius order
      rr = rr[a]
      d = d[a]
      ee = FLTARR(ng+1)
      r = ee
      ee[0] = 0.0
      r[0] = 0.0
      r[1] = rr+0.2  ; fudge radius to ameliorate pixelation error
      FOR i=1l,ng DO ee[i]=ee[i-1]+d[i-1]
   ENDELSE

                    ; normalize to 1.0 at specified radius
   IF KEYWORD_SET(adjbkg) AND (rnorm EQ 0) THEN enorm=MAX(ee) ELSE BEGIN
      IF rnorm LE 0 THEN rn=rlim-1 ELSE rn=rnorm/scale
      IF rn GT rlim THEN BEGIN
         IF NOT KEYWORD_SET(silent) THEN BEGIN
            PRINT, 'Normalization radius outside image boundary...'
            PRINT, 'Using maximum possible radius...', rlim*scale
         ENDIF 
         enorm = ee[N_ELEMENTS(ee)-1]
      ENDIF ELSE BEGIN
         bot = MAX(WHERE(r LT rn))
         top = MIN(WHERE(r GE rn))
         enorm = (ee[top]-ee[bot])*(rn-r[bot])/(r[top]-r[bot])+ee[bot]
      ENDELSE
   ENDELSE
   ee = ee/(enorm>1e-20)
   r = r*scale

   IF KEYWORD_SET(show_plot) THEN BEGIN
      IF scale EQ 1 THEN xt='(px, px/10)' ELSE xt='(arcsec, arcsec/10)'
      PLOT, r, ee, XTITLE='Radius '+xt, $
       YTITLE='Encircled energy', YRANGE=[0,1.2]
      OPLOT, !X.CRANGE, [1,1], LINESTYLE=1
      OPLOT, r*10, ee, LINES=3
      IF NOT KEYWORD_SET(adjbkg) THEN $
       OPLOT, [rnorm,rnorm], !Y.CRANGE, LINESTYLE=2
   ENDIF

   IF KEYWORD_SET(azavg) THEN azav = azav/MAX(azav)

END

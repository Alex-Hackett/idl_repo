;+
; $Id: acs_ee.pro,v 1.1 2001/11/05 21:17:07 mccannwj Exp $
;
; NAME:
;     ACS_EE
;
; PURPOSE:
;     Calculate encircled or ensquared energy within specified aperture.
;     Contribution of pixels partially within aperture estimated to minimize
;     pixelation error.
;
; CATEGORY:
;     ACS/Analysis
;
; CALLING SEQUENCE:
;     result = ACS_EE(image, x, y, width [, height, SCALE=, ETOTAL=])
; 
; INPUTS:
;     image - image array
;     x     - x position of aperture center (pixels)
;     y     - y position of aperture center (pixels)
;     width - aperture width or diameter (pixels)
;
; OPTIONAL INPUTS:
;     height - square aperture height (pixels)
;
; KEYWORD PARAMETERS:
;     /ADJCTR - Adjust center location to optimize EE in specified aperture.
;     ETOTAL - (OUTPUT) total energy (counts) in image
;     SCALE  - (NUMBER) plate scale (arcsec/pixel), assumed same in both
;              dimensions.  If specified, width and height are
;              interpreted as having arcsec units.
;
; OUTPUTS:
;     result - ratio energy within aperture to total energy in image 
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
;     version 1.0  G. Hartig,  Sep 1992
;     repaired 9 July 1996 to correct indexing bug that produced ensquared
;       energy values too large when image center above pixel center. GFH
;     Cleaned up for ACS library - W.McCann June 2000
;-
FUNCTION ACS_EE_COMPUTE, image, xctr, yctr, apw, aph, ETOTAL=etot, $
                         ERROR=error_code
   error_code = 0b
                    ; calc region of interest boundaries
   x0 = FIX(xctr-apw+0.5)
   x1 = FIX(xctr+apw+0.5)
   y0 = FIX(yctr-aph+0.5)
   y1 = FIX(yctr+aph+0.5)
                    ; check if within image dimensions
   xdim = N_ELEMENTS(image[*,0])
   ydim = N_ELEMENTS(image[0,*])
   IF (x0 LT 0) OR (x1 GE xdim) OR $
    (y0 LT 0) OR (y1 GE ydim) THEN GOTO, toobig

   IF aph EQ 0 THEN BEGIN ; circular aperture case
      apw2 = apw*apw ; square of aperture radius
      s = 0.0         ; initialize energy sum
      FOR i=x0,x1 DO BEGIN ; for each pixel within apw of image ctr:
         ii = (i-xctr)^2
         y = FIX(SQRT((apw2-ii)>0.0)+1.5)
         y0 = FIX(yctr-y)
         y1 = FIX(yctr+y)
                    ; compute radius from image ctr of pixel
         FOR j=y0,y1 DO BEGIN 
            jj = (j-yctr)^2
            r = SQRT(ii+jj)
                    ; find approx relative area of pixel within apw
            cr = 0>(apw-r+0.5)<1.0 
                    ; add contribution to previous sum
            s = s+image[i,j]*cr
         ENDFOR
      ENDFOR
   ENDIF ELSE BEGIN ; rectangular aperture case
      x0=x0+1
      x1=x1-1
      y0=y0+1
      y1=y1-1
      cx0=x0-(xctr-apw)-0.5 ; rel areas of edge pixels inside aperture
      cx1=xctr+apw-x1-0.5
      cy0=y0-(yctr-aph)-0.5
      cy1=yctr+aph-y1-0.5
      s = TOTAL(image[x0:x1,y0:y1])
                    ; top/bottom edges
      s = s+cy0*TOTAL(image[x0:x1,y0-1])+cy1*TOTAL(image[x0:x1,y1+1])
                    ; left/rt edges
      s = s+cx0*TOTAL(image[x0-1,y0:y1])+cx1*TOTAL(image[x1+1,y0:y1])
                    ; add contrib from corner pixels
      s = s+cx0*cy0*image[x0-1,y0-1]
      s = s+cx1*cy0*image[x1+1,y0-1]
      s = s+cx0*cy1*image[x0-1,y1+1]
      s = s+cx1*cy1*image[x1+1,y1+1]
   ENDELSE

   etot = TOTAL(image)
   ee_value = s/etot
   return, ee_value

toobig: 
   MESSAGE, 'Specified aperture exceeds image dimensions.', /CONTINUE
   ee_value = 0.0
   etot = 0.0
   error_code = 1b
   return, ee_value
END

FUNCTION ACS_EE, image, xctr, yctr, width, height, ETOTAL=etot, SCALE=scale, $
                 ADJCTR=adjctr, ERROR=error_code, $
                 XOFFSET=xoff_tot, YOFFSET=yoff_tot, SHOW_FIT=show_fit
   error_code = 0b
   IF N_PARAMS() LE 3 THEN BEGIN
      PRINT, 'usage: ee = ACS_EE(image,xctr,yctr,width)'
      error_code = 1b
      return, -1.0
   ENDIF 
   IF N_ELEMENTS(scale) LE 0 THEN scale = 1.0
   IF N_ELEMENTS(height) LE 0 THEN height = 0.0

   apw = width/(scale*2.0) ; aperture radius or half-width in pixels
   aph = height/(scale*2.0) ; aperture half-height in pixels
   ;;IF aph EQ 0 THEN aph=apw

   IF KEYWORD_SET(adjctr) THEN BEGIN
      aps = apw * 2
      IF aps GT 3 THEN ss=1.0 ELSE ss=2.0
      !ERR=0
      nn_gauss = 7        ; number of offset points to investigate
      PRINT, 'Adjusting center location to optimize EE in specified aperture...'
      off = FLOAT(INDGEN(nn_gauss)-nn_gauss/2)/ss
      eet = FLTARR(nn_gauss)
      offit=(INDGEN((nn_gauss-1)*10+1)-(nn_gauss-1)*5)/(10.0*ss)
      FOR i=0,nn_gauss-1 DO BEGIN
         eet[i] = ACS_EE_COMPUTE(image,xctr+off[i],yctr,apw,aph)
      ENDFOR
      estimates = [MAX(eet),0.0,2.0]
      junk = GAUSSFIT(off,eet,cf,NTERMS=3,ESTIMATE=estimates)
      fit = cf[0] * EXP((-((offit - cf[1]) / cf[2])^2)/2)
      xoff = cf[1]

      IF KEYWORD_SET(dofine) THEN BEGIN
         nn_fine = 5
         off_fine = FLOAT(INDGEN(nn_fine)-nn_fine/2)/ss
         eet_fine = FLTARR(nn_fine)
         offit_fine = (INDGEN((nn_fine-1)*10+1)-(nn_fine-1)*5)/(10.0*ss)
         FOR i=0,nn_fine-1 DO BEGIN
            eet_fine[i] = ACS_EE_COMPUTE(image,xctr+xoff+off_fine[i],$
                                         yctr,apw,aph)
         ENDFOR
         cf_fine = POLY_FIT(off_fine,eet_fine,2)
         fit_fine=poly(offit_fine,cf_fine)
         xoff_fine = -cf_fine[1]/(2.*cf_fine[2])
      ENDIF ELSE xoff_fine = 0.0

      IF KEYWORD_SET(show_fit) THEN BEGIN
         PLOT, off, eet, TITLE='EE: Encircled energy optimization fit', $
          XTITLE='X offset (pixels)', YTITLE='EE', PSYM=2, XSTYLE=3
         OPLOT,offit,fit,LINESTYLE=0
         OPLOT,[xoff,xoff],!Y.CRANGE,LINESTYLE=2
         IF KEYWORD_SET(dofine) THEN BEGIN
            OPLOT,xoff-offit_fine,fit_fine,LINESTYLE=1
            OPLOT,xoff-[xoff_fine,xoff_fine],!Y.CRANGE,LINESTYLE=4
         ENDIF
         WAIT, 1
      ENDIF
      IF (ABS(xoff+xoff_fine) GT nn_gauss*0.8) THEN BEGIN
         xoff = 0.0
         xoff_fine = 0.0
         PRINT, 'Unable to optimize EE along X'
      ENDIF

      FOR i=0,nn_gauss-1 DO BEGIN
         eet[i] = ACS_EE_COMPUTE(image,xctr+xoff+xoff_fine,yctr+off[i],apw,aph)
      ENDFOR
      junk = GAUSSFIT(off,eet,cf,NTERMS=3,ESTIMATE=estimates)
      fit = cf[0] * EXP((-((offit - cf[1]) / cf[2])^2)/2)
      yoff = cf[1]

      IF KEYWORD_SET(dofine) THEN BEGIN
         off_fine = FLOAT(INDGEN(nn_fine)-nn_fine/2)/ss
         eet_fine = FLTARR(nn_fine)
         offit_fine = (INDGEN((nn_fine-1)*10+1)-(nn_fine-1)*5)/(10.0*ss)
         FOR i=0,nn_fine-1 DO BEGIN
            eet_fine[i] = ACS_EE_COMPUTE(image,xctr+xoff+xoff_fine,$
                                         yctr+yoff+off_fine[i],apw,aph)
         ENDFOR
         cf_fine = POLY_FIT(off_fine,eet_fine,2)
         fit_fine=poly(offit_fine,cf_fine)
         yoff_fine = -cf_fine[1]/(2.*cf_fine[2])
      ENDIF ELSE yoff_fine = 0.0

      IF KEYWORD_SET(show_fit) THEN BEGIN
         PLOT, off, eet, TITLE='EE: Encircled energy optimization fit', $
          XTITLE='Y offset (pixels)',YTITLE='EE',PSYM=2,XSTYLE=3
         OPLOT,offit,fit,LINESTYLE=0
         OPLOT,[yoff,yoff],!Y.CRANGE,LINESTYLE=2
         IF KEYWORD_SET(dofine) THEN BEGIN
            OPLOT,yoff-offit_fine,fit_fine,LINESTYLE=1
            OPLOT,yoff-[yoff_fine,yoff_fine],!Y.CRANGE,LINESTYLE=4
         ENDIF
         WAIT, 1
      ENDIF
      IF (ABS(yoff+yoff_fine) GT nn_gauss*0.8) THEN BEGIN
         yoff = 0.0
         yoff_fine = 0.0
         PRINT, 'Unable to optimize EE along Y'
      ENDIF
      
      xoff_tot = xoff+xoff_fine
      yoff_tot = yoff+yoff_fine
      IF (xoff_tot NE 0) AND (yoff_tot NE 0) THEN BEGIN
         PRINT, 'X offset: ',xoff_tot,'  Y offset: ',yoff_tot
         xctr = xctr+xoff_tot & yctr = yctr+yoff_tot
         ;;if n_params lt 6 then center,xc,yc,frame=fr
      ENDIF
   ENDIF

   ee_value = ACS_EE_COMPUTE(image,xctr,yctr,apw,aph,ETOTAL=etot,$
                             ERROR=error_code)
   return, ee_value
END

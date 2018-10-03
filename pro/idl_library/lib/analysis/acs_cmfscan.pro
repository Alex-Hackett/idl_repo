;+
; $Id: acs_cmfscan.pro,v 1.1 2001/11/05 20:48:20 mccannwj Exp $
;
; NAME:
;     ACS_CMFSCAN
;
; PURPOSE:
;     Reduces focus scan data obtained by moving the corrector focus
;     mechanism.
;
; CATEGORY:
;     ACS/Analysis
;
; CALLING SEQUENCE:
;     ACS_CMFSCAN, first_entry, n_positions, n_per_pos [,XCENTER= ,
;                  YCENTER= , TITLE= , PS_FILENAME= , /HARCOPY]
;
; INPUTS:
;     first_entry - first image file database entry number
;     n_positions - number of focus positions (16 for normal CCD scan)
;     n_per_pos   - number of files dumped per focus position (4 SBC, 2 CCDs)
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     /VERBOSE - show verbose output
;
; OUTPUTS:
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
;
;-
FUNCTION cmf_get_focus_pos, header, detector
   det = STRMID(detector,0,1)
   det = (det EQ 'S') ? 'H' : det
   item = det + 'FOCPOS'
   pos = SXPAR(header,item)
   return, pos
END 

PRO cmf_get_plate_scale, detector, scale
   CASE STRTRIM(detector,2) OF
      'WFC': scale=.0494
      'HRC': scale=.0266
      'SBC': scale=.0317
      ELSE: BEGIN
         scale = 1.0
         PRINT, 'Invalid detector; returning...', STRING(7b) 
         RETURN
      END
   ENDCASE
END 

PRO cmf_get_magnification, detector, xmag, ymag, theta
   CASE STRTRIM(detector,2) OF
      'WFC': begin
         xmag=1.04
         ymag=1.0/1.04
         theta=45.0
      end
      'HRC': begin
         xmag=1.083
         ymag=1.0/1.083
         theta=20.13
      end
      'SBC': BEGIN
         xmag=1.083
         ymag=1.0/1.083
         theta=-20.13
      END
      ELSE: BEGIN
         xmag = 1.0
         ymag = 1.0
         theta = 0.0
         PRINT, 'Invalid detector; returning...', STRING(7b) 
         RETURN
      END
   ENDCASE
END 

FUNCTION cmf_get_isize, detector
   return, (detector EQ 'WFC') ? 20 : 40
END 

PRO cmf_get_center, image, xcenter, ycenter

   data_sz = SIZE(image)

   xsize = data_sz[1]
   ysize = data_sz[2]

   WINDOW, /FREE, XSIZE=xsize, YSIZE=ysize, TITLE='Select center:', $
    COLORS = 256
   imin = MIN(image)
   imax = MAX(image)
   tmin = imax / 1e4
   TV, BYTSCL(ALOG10((image-imin)>tmin), $
              MIN=ALOG10(tmin), MAX=ALOG10(imax - imin),$
              TOP=!D.N_COLORS-1)
   ;;TV, BYTSCL(HIST_EQUAL(image, MINV=imin, MAXV=imax))
   CURSOR, xcenter, ycenter, /UP, /DEVICE
   WDELETE
END

PRO cmf_fit_center, image, xcenter, ycenter, x, y, VERBOSE=verbose

   image_sz = SIZE(image)
   n_x = image_sz[1]
   n_y = image_sz[2]
   xw = 11
   yw = 11

   CNTRD, image, xcenter, ycenter, xcen, ycen, 5
                    ; do x
   x0 = xcen-xw > 0
   x1 = xcen+xw < (n_x-1)
   y0 = ycen-yw > 0
   y1 = ycen+yw < (n_y-1)

   xslice = TOTAL(image[x0:x1,y0:y1],2) / n_x
   xi = LINDGEN(N_ELEMENTS(xslice))
   xmax = MAX(xslice)
   x_est = [xmax,FLOAT(xw),2.0,0.0,0.0]
   x_fit = GAUSSFIT(xi, xslice, x_a, NTERMS=5, ESTIMATE=x_est)
   x_fit = GAUSSINT_FIT(xi, xslice, x_a, NTERMS=5, ESTIMATE=x_a)
   x = x_a[1] + x0
   IF KEYWORD_SET(verbose) THEN BEGIN
      PLOT, xslice, PSYM=10, TITLE='X Center - Gaussian fit'
      OPLOT, x_fit, LINESTYLE=1
      OPLOT, [1,1]*x_a[1], !Y.CRANGE, LINES=1
      WAIT, 0.2
   ENDIF
                    ; do y
   yslice = TOTAL(image[x0:x1,y0:y1],1) / n_y
   yi = LINDGEN(N_ELEMENTS(yslice))
   ymax = MAX(yslice)
   y_est = [ymax,FLOAT(yw),2.0,0.0,0.0]
   y_fit = GAUSSFIT(yi, yslice, y_a, NTERMS=5, ESTIMATE=y_est)
   y_fit = GAUSSINT_FIT(yi, yslice, y_a, NTERMS=5, ESTIMATE=y_a)
   y = y_a[1] + y0
   IF KEYWORD_SET(verbose) THEN BEGIN
      PLOT, yslice, PSYM=10, TITLE='Y Center - Gaussian fit'
      OPLOT, y_fit, LINESTYLE=1
      OPLOT, [1,1]*y_a[1], !Y.CRANGE, LINES=1
      WAIT, 0.2
   ENDIF 
END 

PRO acs_cmfscan, first_id, n_positions, n_per_pos, $
                 XCENTER=xcenter, YCENTER=ycenter, $
                 TITLE=strTitle, OUTPUT_FILENAME=output_filename, $
                 HARDCOPY=hardcopy, ERROR=error_code, $
                 SCALE=scale, XMAG=xmag, YMAG=ymag, THETA=theta, $
                 VERBOSE=verbose, SKIP=num_skip, $
                 WRITE_FILE=write_file, $
                 OPTIMAL_FOCUS=optimal_focus, $
                 EE=ee, FOCUS=cmf_pos
   error_code = 0b
   IF N_PARAMS() LT 3 THEN BEGIN
      PRINT, 'Usage: acs_cmfscan, first_id, n_positions, n_per_pos'
      error_code = 1b
      return
   ENDIF 
   ;;tit='ID 19452:19459  15 Sep 00  SBC  RAS/Cal  Field pt HC'
   IF N_ELEMENTS(n_per_pos) LE 0 THEN n_per_pos=1
   IF N_ELEMENTS(num_skip) LE 0 THEN num_skip=0
   IF N_ELEMENTS(strTitle) LE 0 THEN strTitle = ''
   IF N_ELEMENTS(output_filename) LE 0 THEN $
    output_filename='cmfscan_'+STRTRIM(first_id,2)

;isize=81	; dimension of cropped image to use for EE computation  (41 for WFC)
   
   list = INDGEN(n_positions)*((num_skip>0)+n_per_pos) + first_id
   PRINT, list
   ACS_READ, list[0], h, /NODATA, /SILENT
   detector = STRTRIM(sxpar(h,'detector'),2)
   xcorner = sxpar(h,'ccdxcor')
   ycorner = sxpar(h,'ccdycor')

   IF N_ELEMENTS(xmag) LE 0 OR N_ELEMENTS(ymag) LE 0 THEN $
    cmf_get_magnification, detector, xmag, ymag, theta
   IF N_ELEMENTS(scale) LE 0 THEN $
    cmf_get_plate_scale, detector, scale

   isize = cmf_get_isize(detector)

   ee = MAKE_ARRAY(n_positions*n_per_pos,/DOUBLE)
   cmf_pos = MAKE_ARRAY(n_positions*n_per_pos,/DOUBLE)
   xcenter_pos = MAKE_ARRAY(n_positions*n_per_pos,/FLOAT)
   ycenter_pos = xcenter_pos
   dx = isize
   dy = isize
   FOR i=0,n_positions-1 DO BEGIN
      FOR j=0,n_per_pos-1 DO BEGIN
         ACS_READ, list[i]+j, header, image, /SILENT
         cmf_pos[i*n_per_pos+j] = cmf_get_focus_pos(header,detector)
         IF N_ELEMENTS(xcenter) LE 0 OR N_ELEMENTS(ycenter) LE 0 THEN BEGIN
            cmf_get_center, image, xcenter, ycenter
            PRINT,'Found center: ('+STRTRIM(xcenter,2)+','+STRTRIM(ycenter,2)+')'
         ENDIF

         SKY, image, skymode, skysig, SILENT=1

         IF KEYWORD_SET(verbose) THEN $
          PRINT, 'Sutracting sky level: ', (skymode > 0)
         ;;image = TEMPORARY(image) - (skymode > 0)
         background = (skymode > 0)
         cmf_fit_center, image-background, xcenter, ycenter, ox, oy, $
          VERBOSE=verbose

         a_x = 1.3 * dx
         a_y = 1.3 * dy
         IF KEYWORD_SET(verbose) THEN BEGIN
            PRINT, 'Anamorph using (xmag, ymag, theta):  ',xmag,ymag,theta
         ENDIF 
         image = (TEMPORARY(image))[ox-a_x:ox+a_x, $
                                    oy-a_y:oy+a_y]
         anamorph, image, xmag, ymag, theta, /CUBIC

         cx = a_x+1
         cy = a_y+1
         image = (TEMPORARY(image))[cx-dx:cx+dx, $
                                    cy-dy:cy+dy]
         ACS_EER, image, dx, dy, .15, SCALE=scale, /ADJUST, BACK=background, $
          SHOW=verbose
         WAIT, 0.2
         image = TEMPORARY(image) - background

         adj_x = dx
         adj_y = dy
         ee[i*n_per_pos+j] = $
          ACS_EE(image,adj_x,adj_y,0.15,SCALE=scale,/ADJCTR,$
                 XOFFSET=x_offset, YOFFSET=y_offset,SHOW_FIT=verbose,$
                 ETOT=etot)
         IF KEYWORD_SET(verbose) THEN BEGIN
            imin = MIN(image)
            imax = MAX(image)
            factor = 4
            image_sz = SIZE(image)
            new_x = factor * image_sz[1]
            new_y = factor * image_sz[2]
            ERASE
            tmin = imax / 1e4
            rbimage = REBIN(image,new_x,new_y)
            TV, BYTSCL(ALOG10((rbimage-imin)>tmin), $
                       MIN=ALOG10(tmin), MAX=ALOG10(imax - imin),$
                       TOP=!D.N_COLORS-1)
            ;;TV, BYTSCL(HIST_EQUAL(REBIN(image,new_x,new_y), $
            ;;                      MINV=imin, MAXV=imax))
            WIN_TRACE, adj_x*factor, adj_y*factor
            WAIT, 0.2
            ;;RDPIX, rbimage
         ENDIF 
         xcenter_pos[i*n_per_pos+j] = ox+x_offset
         ycenter_pos[i*n_per_pos+j] = oy+y_offset
         PRINT, FORMAT='(I5,2X,F8.2,2X,F10.8,2X,F7.2,2X,F7.2,2X,F12.2,2X,F12.2)', $
          list[i]+j, cmf_pos[i*n_per_pos+j], ee[i*n_per_pos+j], $
          xcenter_pos[i*n_per_pos+j], ycenter_pos[i*n_per_pos+j], etot, $
          background
      ENDFOR
   ENDFOR

plotit:

   strXTitle = 'Corrector focus position (cts)'
   strYTitle = 'Encircled energy (d=.15)'
   plot_title = 'Focus scan  entries '+STRTRIM(first_id,2)+':'+$
    STRTRIM(first_id+n_positions-1,2)+' '+strTitle
   plot_yrange = [MIN(ee-.02),MAX(ee)+.02]
   PLOT, cmf_pos, ee, PSYM=1, YSTYLE=1, XSTYLE=3, $
    XTITLE=strXTitle, YTITLE=strYTitle, $
    YRANGE=plot_yrange, TITLE=plot_title

   nominal_focus = cmf_pos[n_positions-1]

                    ; Try to reject outliers
   ;;n_iter = 2
   ;;FOR i=0, n_iter-1 DO BEGIN
   cf = POLY_FIT(cmf_pos,ee,2,YBAND=yband,YFIT=yfit,YERROR=yerror)
   ;;residual = yfit - ee
   ;;errors = residual / yband
   ;;good = WHERE(ABS(errors) LE 5,ngood)
   ;;IF ngood GT 0 THEN BEGIN
   ;;ee = ee[good]
   ;;cmf_pos = cmf_pos[good]
   ;;PRINT, 'Rejecting '+STRTRIM(N_ELEMENTS(ee)-ngood,2)+' outlier points'
   ;;ENDIF 
   ;;ENDFOR 
   optimal_focus = -cf(1)/(2.*cf(2)) ; optimal focus position (cts)
   fopts=STRTRIM(ROUND(optimal_focus),2)
   focoff=FIX((optimal_focus-nominal_focus)*2.93) ; focus offset (steps)
   if detector eq 'WFC' then begin
      mmstep=1.25e-3 ; mm per step
      pxsiz=0.015    ; pixel size (mm) 
      dctr=[2071,2047] ; detector ctr (px)
   ENDIF ELSE BEGIN
      mmstep=8.45e-3
      pxsiz=0.021    ; pixel size (mm) 
      dctr=[530,511] ; detector ctr (px)
   ENDELSE
   focoffm=mmstep*focoff ; focus offset (mm) 

                    ; fit EE vs focus in mm from ctr of range
   fm = 2.93*mmstep*(cmf_pos-2048.0)
   cfm = FLOAT(TRANSPOSE(POLY_FIT(fm,ee,2)))
   xcenter = xcenter_pos[n_positions*n_per_pos-1]
   ycenter = ycenter_pos[n_positions*n_per_pos-1]
   mctr=([xcenter,ycenter]+[ycorner,xcorner]-dctr)*pxsiz

   ff = INDGEN(1001)*(!X.CRANGE(1)-!X.CRANGE(0))/1000.+!X.CRANGE(0)
   fit = POLY(ff,cf)
   OPLOT, ff, fit
   OPLOT, [optimal_focus,optimal_focus],!Y.CRANGE, LINESTYLE=1
   XYOUTS, optimal_focus+10, !Y.CRANGE(0)+.02, 'Optimal focus: '+fopts
   PRINT, 'Optimal focus (cts): ', fopts
   PRINT, 'Required focus offset (steps): ', STRTRIM(focoff,2)
   PRINT, 'Detector focus offset (mm): ', STRTRIM(focoffm,2)

   ;;rd,'Make plot hardcopy and summary file (Y/N):',hc,'Y'
   IF KEYWORD_SET(write_file) THEN BEGIN
      OPENW, lun, output_filename+'.dat', /GET_LUN
      PRINTF, lun, '        '+plot_title
      PRINTF, lun, '        Image coords (mm): ',mctr,FORMAT='(a27,2f13.4)'
      PRINTF, lun, '        Parabolic fit coeff: ',cfm,FORMAT='(a29,3f13.6)'
      PRINTF, lun, ' '
      PRINTF, lun, "          Entry    Foc pos'n   EE(d=.15 as)"
      fmt='(10x,i5,f12.0,f12.3)'
      FOR i=0,n_positions-1 DO FOR j=0,n_per_pos-1 DO $
       PRINTF, lun, list[i]+j, cmf_pos[i*n_per_pos+j], ee[i*n_per_pos+j], $
       FORMAT=fmt
      PRINTF, lun, ' '
      PRINTF, lun, '        Required focus offset (steps): ',STRTRIM(focoff,2)
      PRINTF, lun, '        Detector focus offset (mm): ',STRTRIM(focoffm,2)
      FREE_LUN, lun
   ENDIF 

   IF KEYWORD_SET(hardcopy) THEN BEGIN
      saved_device = !D.name
      SET_PLOT, 'PS'
      DEVICE, FILENAME=output_filename+'.ps', /COLOR, BITS_PER_PIXEL=8
      PLOT, cmf_pos, ee, psym=1, ys=3, xs=3, $
       XTIT=strXTitle, $
       YTIT=strYTitle, TITLE=plot_title
      OPLOT, ff, fit
      OPLOT, [optimal_focus,optimal_focus], !Y.CRANGE, LINESTYLE=1
      XYOUTS, optimal_focus+10, !Y.CRANGE(0)+.02, 'Optimal focus: '+fopts
      DEVICE, /CLOSE
      SET_PLOT, saved_device

      SPAWN, 'lp '+output_filename+'.ps'
      SPAWN, 'lp '+output_filename+'.dat'
   ENDIF
END

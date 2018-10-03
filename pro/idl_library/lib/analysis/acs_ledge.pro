;+
; $Id: acs_ledge.pro,v 1.1 2001/11/05 20:58:02 mccannwj Exp $
;
; NAME:
;     ACS_LEDGE
;
; PURPOSE:
;     Leading Edge ramp plots
;
; CATEGORY:
;     JHU/ACS
;
; CALLING SEQUENCE:
;     LEDGE, entry [, /HARDCOPY ]
; 
; INPUTS:
;     entry - ACS_LOG database entry number
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     HARDCOPY - send the output to the printer
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
;       Mon Sep 13 18:28:22 1999, William Jon McCann
;       <mccannwj@acs13.+ball.com>
;
;		written.
;
;-
PRO acs_ledge, entry, DEBUG=debug, HARDCOPY=hardcopy

   IF N_ELEMENTS( entry ) LE 0 THEN BEGIN
      MESSAGE, 'usage: LEDGE, entry', /NONAME, /CONTINUE
      return
   ENDIF 

   strDatabaseName = 'acs_log'
   DBOPEN, strDatabaseName, UNAVAIL=unavail_flag
   IF unavail_flag EQ 1 THEN BEGIN
      PRINTF, -2, 'error: '+strDatabaseName + ' is unavailable'
      return
   ENDIF

   last_entry = DB_INFO( 'entries', 0 )
   IF ( (entry LE 0) OR (entry GT last_entry) ) THEN BEGIN
      MESSAGE, 'error: entry must be > 0 < '+STRTRIM(last_entry+1,2), $
       /CONTINUE
      return
   ENDIF 

   ccd_amp = STRTRIM( DBVAL( entry, 'CCDAMP' ), 2 )
   ccd_gain = STRTRIM( DBVAL( entry, 'CCDGAIN' ), 2 )
   ccd_offset = STRTRIM( DBVAL( entry, 'CCDOFF' ), 2 )
   detector = STRTRIM( DBVAL( entry, 'DETECTOR' ), 2 )
   IF detector EQ 'SBC' THEN RETURN

   IF STRPOS( ccd_amp, 'A' ) GE 0 THEN ampA = 1 ELSE ampA = 0
   IF STRPOS( ccd_amp, 'B' ) GE 0 THEN ampB = 1 ELSE ampB = 0
   IF STRPOS( ccd_amp, 'C' ) GE 0 THEN ampC = 1 ELSE ampC = 0
   IF STRPOS( ccd_amp, 'D' ) GE 0 THEN ampD = 1 ELSE ampD = 0

; determine if double amp readouts in each direction

   IF (ampA AND ampB) OR (ampC AND ampD) THEN x_double = 2 ELSE x_double = 1

   IF (ampA AND ampC) OR (ampB AND ampD) OR $
   (ampA AND ampD) OR (ampB AND ampC) THEN y_double = 2 ELSE y_double = 1

   n_amps = STRLEN( ccd_amp )

   ACS_READ, entry, header, image, hudl, /NO_ABORT, /RAW
   IF KEYWORD_SET(debug) THEN HELP, image, x_double, y_double, ccd_amp
   IF detector EQ 'WFC' THEN BEGIN
      n_over = 24
      csize = 2048 
   ENDIF ELSE BEGIN
      n_over = 19
      csize = 1024
   ENDELSE 

; get size of image
   image_sz = SIZE( image )
   nx = image_sz[1]
   ny = image_sz[2]
   x1 = 0
   x2 = (csize - 1)<( nx / x_double-1)
   y1 = 0
   y2 = ny / y_double - 1

   IF KEYWORD_SET( hardcopy ) THEN BEGIN
      device_saved = !D.NAME
      SET_PLOT, 'PS'
      strPSFilename = 'leading_edge_'+STRTRIM(entry,2)+'.ps'
      page_xsize = 7.4
      page_ysize = 9.4
      DEVICE, FILENAME=strPSFilename, SCALE_FACTOR=1.0, $
       /INCHES, BITS = 8, $
       XOFF = 0.7, YOFF = 0.7, $
       XSIZE = page_xsize, YSIZE = page_ysize

   ENDIF 
   pmulti_saved = !P.MULTI
   !P.MULTI = [0,1,4]
   FOR i_amp=0, n_amps-1 DO BEGIN
      IF KEYWORD_SET(debug) THEN $
       PRINT, '_____________________________________________'
      amp = STRMID( ccd_amp, i_amp, 1 )

; determine offset of the amp in the input image and output image

      x_off = 0 & y_off = 0

      IF ( ( (amp EQ 'B') AND (ampA EQ 1) ) OR $
           ( (amp EQ 'D') AND (ampC EQ 1) ) ) THEN BEGIN
         x_off = nx / 2
      ENDIF
      IF ( (amp EQ 'C') OR (amp EQ 'D') ) AND (ampA OR ampB) THEN BEGIN
         y_off = ny / 2
      ENDIF

                    ; extract image region
      IF KEYWORD_SET(debug) THEN HELP, x1, x2, x_off, y1, y2, y_off, amp
      region = FLOAT( image[x_off+x1:x_off+x2,y_off+y1:y_off+y2] )

;      CASE amp OF
;         'A':
;         'B': region = ROTATE( region, 5 )
;         'C': region = ROTATE( region, 7 )
;         'D': region = ROTATE( region, 2 )
;         ELSE:
;      ENDCASE

; extract overscan strip

      n_lead = 100
      leading_strip = region[0:n_lead-1,*]

; collapse with 5 pixel median filter

      lead_edge = FLTARR(n_lead)

      FOR i=0,n_lead-1 DO lead_edge[i] = MEDIAN( leading_strip[i, *] )

      y_min = MIN(lead_edge)
      y_max = MEDIAN(lead_edge[n_over+1:*])
      
      high_part = lead_edge[n_over+5:*]
      FOR i=0,4 DO BEGIN
         std_dev = STDDEV(high_part)
         bad_pix = WHERE( high_part GT (4*std_dev)+y_max, bad_count )
         IF bad_count GT 0 THEN high_part[bad_pix] = y_max
      ENDFOR 
      y_diff = y_max - y_min
      y_min_buffer = y_diff / 10.0
      y_max_buffer = std_dev + y_diff / 5.0
      y_range = [ y_min - y_min_buffer, $
                  y_max + y_max_buffer ]
      IF KEYWORD_SET(debug) THEN HELP, y_min, y_max, y_min_buffer, $
       y_max_buffer, std_dev

      IF i_amp EQ 0 THEN BEGIN
         strTitle = STRING( FORMAT='("Leading Edge Ramp for entry",1X,I0,2X,"Amplifier",1X,A,2X,"CCD Gain",1X,I0,2X,"Offset",1X,I0)', $
                            entry, amp, ccd_gain, ccd_offset )
      ENDIF ELSE BEGIN
         strTitle = STRING( FORMAT='("Amplifier",1X,A)', amp )
      ENDELSE
      strXTitle = 'Number of columns'
      strYTitle = 'Signal (DN)'
      PPLOT, lead_edge, PSYM=10, XSTYLE=1, YSTYLE=3, $
       TITLE=strTitle, XTITLE=strXTitle, YTITLE=strYTitle, $
       YRANGE=y_range

   ENDFOR

   IF KEYWORD_SET( hardcopy ) THEN BEGIN
      DEVICE, /CLOSE
      strExec = 'lp '+strPSFilename
      SPAWN, strExec
      SET_PLOT, device_saved
   ENDIF 
   !P.MULTI = pmulti_saved

   return
END 

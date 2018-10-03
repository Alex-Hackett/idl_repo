;+
; $Id: mview.pro,v 2.10 2001/08/06 15:58:03 mccannwj Exp $
;
; NAME:
;       MVIEW
;
; PURPOSE:
;       Graphical image viewer with analysis tools.
;       
; CATEGORY:
;       ACS/JHU (graphics/image display)
;
; CALLING SEQUENCE:
;       MVIEW, image, [, header, ...]
;
; INPUTS:
;       image - if (SCALAR)   The ACS_LOG entry number to load.
;                  (1D ARRAY) A list of ACS_LOG entry numbers to load.
;                  (2D ARRAY) A two dimensional image.
;                  (3D ARRAY) A "stack" of two dimensional images.
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:
;       AUTO    - (BOOLEAN) Autoscale the image on start up.
;       LOG_SCALE - (BOOLEAN) Select log display on start up.
;       SQRT_SCALE - (BOOLEAN) Select square-root display on start up.
;       LINEAR_SCALE - (BOOLEAN) Select linear dipslay on start up (default).
;       RAW_SCALE - (BOOLEAN) Select raw (unscaled) display on start up.
;       GROUP   - (NUMERIC) widget id of an existing widget that
;                  serves as "group leader" for this instance.
;       LABELS  - (STRING/ARRAY) Specify labels for each image.
;       MINIMUM - (NUMERIC) Set initial value of display minimum (Z1).
;       MAXIMUM - (NUMERIC) Set initial value of display maximum (Z2).
;       RETAIN  - (NUMERIC) Override the default value for the RETAIN keyword.
;       TITLE   - (STRING) Set the title for the widget.
;
; OUTPUTS:
;       None
;
; OPTIONAL OUTPUTS:
;       Save image to a file.
;
; COMMON BLOCKS:
;       COMMON MVIEW, handler
;
; SIDE EFFECTS:
;       Optionally writes preferences to ~/.mview
;
; RESTRICTIONS:
;       Requires IDL 5.3 or higher.
;       Requires astronomy library routines,
;        the ACS library routines, and PPLOT.
;
; PROCEDURES:
;
; MODIFICATION HISTORY:
;
;    1999, William Jon McCann
;    <mccannwj@acs10.pha.jhu.edu>
;
;	     written.
;
;-

; _____________________________________________________________________________

FUNCTION make_colorbar, width, HEIGHT=height, MINIMUM=minimum, $
                        MAXIMUM=maximum
   COMPILE_OPT IDL2

   IF N_ELEMENTS(width) LE 0 THEN BEGIN
      MESSAGE, 'width not specified.', /INFO
      return, [-1]
   ENDIF

   IF N_ELEMENTS(height) LE 0 THEN height = 5
   IF N_ELEMENTS(minimum) LE 0 THEN minimum = 0
   IF N_ELEMENTS(maximum) LE 0 THEN maximum = 100

   value_range = (maximum - minimum) > 0
   colorbar = (minimum + value_range * FINDGEN(width) / FLOAT(width-1)) # $
    REPLICATE(1, height)

   return, colorbar
END

; _____________________________________________________________________________

PRO wait_for_click, wDraw, xpos, ypos, PRESS=press, RELEASE=release
   COMPILE_OPT IDL2

   IF N_ELEMENTS(release) LE 0 THEN type = 0b ELSE type = 1b
 
   sEvent = WIDGET_EVENT(wDraw, BAD_ID=error)

   IF error GT 0 THEN BEGIN
      MESSAGE, 'Invalid widget identifier.', /CONT
      return
   ENDIF

   WHILE sEvent.type NE type DO BEGIN

      sEvent = WIDGET_EVENT(wDraw, BAD_ID=error)
   
      IF error GT 0 THEN BEGIN
         MESSAGE, 'Invalid widget identifier.', /CONT
         return
      ENDIF

      xpos = sEvent.x
      ypos = sEvent.y

   ENDWHILE 

END 

; _____________________________________________________________________________

FUNCTION x_openf, param1, param2, param3, param4, $
                  FITS=fits_type, SDI=sdi_type, $
                  NAME=filename, ERROR=error, $
                  PATH=init_path, GET_PATH=get_path, $
                  _EXTRA=extra, GROUP_LEADER=group, $
                  RED=color_r, GREEN=color_g, BLUE=color_b
   COMPILE_OPT IDL2, HIDDEN

   error = 0b
   file_type = ''
   IF KEYWORD_SET(fits_type) THEN file_type = 'FITS'
   IF KEYWORD_SET(sdi_type) THEN file_type = 'SDI'

   IF N_ELEMENTS(file_type) GT 0 THEN BEGIN
      title = 'Select '+file_type+' file to read.'
   ENDIF ELSE title = 'Select a file to read.'

   IF N_ELEMENTS(init_path) EQ 1 THEN BEGIN
      IF init_path NE '' THEN use_path = init_path
   ENDIF

   CASE file_type OF

      'FITS': BEGIN
         filename = DIALOG_PICKFILE(TITLE=title, /MUST_EXIST, $
                                     PATH=use_path, GET_PATH=get_path)

         IF N_ELEMENTS(filename) EQ 1 THEN BEGIN
            IF filename EQ '' THEN BEGIN
               error = 1b
               return, -1
            ENDIF
         ENDIF

         FDECOMP, filename[0], fdisk, fdir, fname, fext, fversion
         aNames = fits_ext(filename, LIST=aList, DIMENSIONS=aDimensions, $
                           NAXIS=aNaxis, BITPIX=aBitpix, ERROR=error_flag)
         IF error_flag EQ 1 THEN BEGIN
            error = 1b
            return, -1
         ENDIF
         strTitle = 'Select FITS extension:'
         strLabel = STRING(FORMAT='(3X,2X,A8,2X,A15,2X,A6,2X,A)', $
                            "TYPE", "NAME", "BITPIX", $
                            "DIMENSIONS")
         items = x_select_list(aList, TITLE=strTitle, GROUP=group, $
                                STATUS=status, LABEL=strLabel)
         IF status NE 0 THEN BEGIN
            error = 1b
            return, -1
         ENDIF

         allow_multiple = 0b
         IF N_ELEMENTS(items) GT 1 THEN BEGIN
                    ; allow multiple images only if they are the same
                    ; size, type and only 2D

            allow_multiple = 1b
            FOR i=1,N_ELEMENTS(items)-1 DO BEGIN
               IF (LONG(aNaxis[items[i]]) NE 2) THEN allow_multiple=0b
               cmp1_result = STRCMP(aDimensions[items[0]], $
                                    aDimensions[items[i]])
               cmp2_result = STRCMP(aBitpix[items[0]], $
                                    aBitpix[items[i]])
               IF NOT (cmp1_result AND cmp2_result) THEN allow_multiple=0b
            ENDFOR 
         ENDIF

         IF allow_multiple EQ 1 THEN read_list = items $
         ELSE read_list = items[0]

         FOR i=0,N_ELEMENTS(read_list)-1 DO BEGIN
            ext_num = read_list[i]
            data = READFITS(filename, param1, EXTEN=ext_num, _EXTRA=extra)
            IF N_ELEMENTS(data) LT 2 THEN BEGIN
               error = 1b
               return, -1
            ENDIF
            data_sz = SIZE(data)
            IF data_sz[0] LT 2 THEN BEGIN
               MESSAGE, 'Image must have at least two dimensions', /INFO
               error = 1b
               return, -1
            ENDIF
            IF (i EQ 0) AND (N_ELEMENTS(read_list) GT 1) THEN BEGIN
               image = MAKE_ARRAY(data_sz[1],data_sz[2],N_ELEMENTS(read_list),$
                                  TYPE = data_sz[3])
            ENDIF 
            IF (N_ELEMENTS(read_list) GT 1) THEN BEGIN
               image[*,*,i] = data
            ENDIF ELSE image = TEMPORARY(data)
         ENDFOR 
         return, image
      END

      'SDI': BEGIN
         filename = DIALOG_PICKFILE(TITLE=title, /MUST_EXIST, $
                                     PATH=use_path, GET_PATH=get_path)

         IF N_ELEMENTS(filename) EQ 1 THEN BEGIN
            IF filename EQ '' THEN BEGIN
               error = 1b
               return, -1
            ENDIF
         ENDIF

         FDECOMP, filename[0], fdisk, fdir, fname, fext, fversion

         ACS_ACQUIRE, filename, param1, image, param2, udl, param3, param4, $
          /NOWRITE
         image_mask = image LT 0
         image = TEMPORARY(image) + TEMPORARY(image_mask) * 65536.0
         return, image
      END

      ELSE: MESSAGE, 'Filename extension not recognized', /INFO

   ENDCASE

   error = 1b
   return, -1
END 

; _____________________________________________________________________________

PRO mview_wmessage, sState, strMessage
   COMPILE_OPT IDL2, HIDDEN

   IF N_ELEMENTS(strMessage) GT 0 THEN $
    WIDGET_CONTROL, sState.wMessageText, SET_VALUE = strMessage

   return
END

; _____________________________________________________________________________

FUNCTION mview_stat_skel
   COMPILE_OPT IDL2, HIDDEN

   sStat = { STATS, $
             moment: DBLARR(4), $
             min: -1d, $
             max: -1d, $
             median: -1d, $
             stdev: -1d, $
             total: -1d }

   return, sStat
END

; _____________________________________________________________________________


FUNCTION mview_get_stats, sState, subscripts, MIN=min_val, MAX= max_val, $
                    TOTAL=total_val, MEDIAN=median_val, STDEV=stdev_val,$
                    RANDOM_NUMBER=random_number, STAT_STRUCT=sStat
   COMPILE_OPT IDL2, HIDDEN

   n_frame = sState.current_frame
   n_pixels = N_ELEMENTS((*sState.pImage)[*,*,0])
   
   subscript_offset = n_pixels * LONG(n_frame)
   
   IF N_ELEMENTS(random_number) GT 0 THEN BEGIN
      
      n_pixels = N_ELEMENTS((*sState.pImage)[*,*,n_frame]) - 1
      
      subscripts = random_subscripts(n_pixels, random_number)
      
   ENDIF ELSE BEGIN

      IF N_ELEMENTS(subscripts) LE 0 THEN BEGIN

         subscripts = LINDGEN(n_pixels)
      ENDIF

   ENDELSE

   IF N_ELEMENTS(subscripts) GT 1 THEN BEGIN

      total_val = TOTAL((*sState.pImage)[subscripts+subscript_offset],/DOUBLE)

      IF total_val NE 0 THEN BEGIN
         
         moment_val = MOMENT((*sState.pImage)[subscripts+subscript_offset], $
                              SDEV = stdev_val, /DOUBLE)

         min_val = MIN((*sState.pImage)[subscripts+subscript_offset])
         
         max_val = MAX((*sState.pImage)[subscripts+subscript_offset])
         
         median_val = MEDIAN((*sState.pImage)[subscripts+subscript_offset])

      ENDIF ELSE BEGIN
         
         moment_val = [0,0,0,0]
         min_val = 0
         max_val = 0
         stdev_val = 0
         median_val = 0
         
      ENDELSE

   ENDIF

   sStat = mview_stat_skel()
   sStat.moment = moment_val
   sStat.total = total_val
   sStat.min = min_val
   sStat.max = max_val
   sStat.median = median_val
   sStat.stdev = stdev_val

   return, moment_val
END

; _____________________________________________________________________________


PRO mview_put_stats, sState, sStats, BLANK=blank
   COMPILE_OPT IDL2, HIDDEN

   IF N_ELEMENTS(sStats) GT 0 THEN BEGIN
      IF N_TAGS(sStats) GE 6 THEN BEGIN
         sState.stattxt[0] = $
          STRING(FORMAT='("  mean ",F0)', sStats.moment[0])
         sState.stattxt[1] = $
          STRING(FORMAT='(" stdev ",F0)', sStats.stdev)
         sState.stattxt[2] = $
          STRING(FORMAT='("median ",F0)', sStats.median)
         sState.stattxt[3] = $
          STRING(FORMAT='("   min ",F0)', sStats.min)
         sState.stattxt[4] = $
          STRING(FORMAT='("   max ",F0)', sStats.max)
         sState.stattxt[5] = $
          STRING(FORMAT='(" total ",E0)', sStats.total)
      ENDIF ELSE blank=1
   ENDIF ELSE blank=1

   IF KEYWORD_SET(blank) THEN BEGIN
      sState.stattxt[0] = "  mean "
      sState.stattxt[1] = " stdev "
      sState.stattxt[2] = "median "
      sState.stattxt[3] = "   min "
      sState.stattxt[4] = "   max "
      sState.stattxt[5] = " total"
      sStats = mview_stat_skel()
   ENDIF 
   WIDGET_CONTROL, sState.wStatText, SET_VALUE=sState.stattxt
   
   sState.sStats = sStats

END

; _____________________________________________________________________________


PRO mview_update_stats, sState, subscripts, RANDOM=random_number, $
                        STAT_STRUCT=sStat, DEBUG=debug
   COMPILE_OPT IDL2, HIDDEN
   IF KEYWORD_SET(debug) THEN PRINTF, -2, '===> Entered mview_update_stats'
   WIDGET_CONTROL, /HOURGLASS

   moments = mview_get_stats(sState, subscripts, RANDOM=random_number, $
                              STAT=sStat)

   IF N_TAGS(sStat) LT 5 THEN return

   IF sStat.total NE 0 THEN BEGIN
      
      mview_put_stats, sState, sStat

   ENDIF ELSE mview_wmessage, sState, "Region selected is zero"
   IF KEYWORD_SET(debug) THEN PRINTF, -2, '<=== Leaving mview_update_stats'

END

; _____________________________________________________________________________

pro mview_print_get_labels, header, label_col1, label_col2, $
                            title_left, title_right
   
   IF N_ELEMENTS(header) GT 1 THEN BEGIN
      hdr_sz = SIZE(header)
      IF hdr_sz[0] EQ 2 THEN n_hdr = hdr_sz[2] ELSE n_hdr = 1
      label_col1 = MAKE_ARRAY(7, n_hdr, /STRING)
      label_col2 = MAKE_ARRAY(7, n_hdr, /STRING)
      title_left = MAKE_ARRAY(n_hdr, /STRING)
      FOR i=0, n_hdr-1 DO BEGIN
         h = header[*,i]
         instr = STRUPCASE(STRTRIM(SXPAR(h, 'INSTRUME'), 2))
         CASE instr OF
            'ACS': BEGIN
               entry = SXPAR(h, 'ENTRY')
               filename = STRTRIM(SXPAR(h, 'FILENAME'), 2)
               IF entry GT 0 THEN BEGIN
                  title_left[i] = STRING(FORMAT='("Entry ",A,4X,A)', $
                                          STRTRIM(entry,2), filename)
               ENDIF ELSE title_left[i] = filename
               detector = STRUPCASE(STRTRIM(SXPAR(h, 'DETECTOR'), 2))
               IF detector EQ 'SBC' THEN label_col1[0,i] = detector $
               ELSE BEGIN
                  ccdamp   =  SXPAR(h, 'CCDAMP')
                  label_col1[0,i] = detector+' Amp: '+ccdamp
               ENDELSE
               label_col1[1,i] = 'Obstype = ' + SXPAR(h, 'OBSTYPE')
               label_col1[2,i] = 'Exptime = ' + STRING(FORMAT='(F6.1)',SXPAR(h, 'EXPTIME'))+' sec'
               IF detector EQ 'SBC' THEN BEGIN
                  label_col1[3,i] = 'Filter3 = ' + SXPAR(h, 'FILTER3')
               ENDIF ELSE BEGIN
                  label_col1[3,i] = 'Filter1 = ' + SXPAR(h, 'FILTER1')
                  label_col1[4,i] = 'Filter2 = ' + SXPAR(h, 'FILTER2')
               ENDELSE

               label_col2[0,i] = 'Sclamp = ' + SXPAR(h, 'SCLAMP')
               IF detector EQ 'SBC' THEN BEGIN
                  
               ENDIF ELSE BEGIN
                  label_col2[1,i] = 'CCD Gain = ' + STRTRIM(SXPAR(h, 'CCDGAIN'), 2)
                  label_col2[2,i] = 'CCD Off = ' + STRTRIM(SXPAR(h, 'CCDOFF'), 2)
                  IF STRUPCASE(STRTRIM(SXPAR(h,'SUBARRAY'),2)) EQ 'SUBARRAY' THEN BEGIN
                     label_col2[3,i] = 'CCD Xcorner = '+STRTRIM(SXPAR(h,'CCDXCOR'),2)
                     label_col2[4,i] = 'CCD Ycorner = '+STRTRIM(SXPAR(h,'CCDYCOR'),2)
                  ENDIF
               ENDELSE
            END
            ELSE:
         ENDCASE 
      ENDFOR 

   ENDIF 

END

; _____________________________________________________________________________

PRO mview_printout, sState, FRAME=use_frame, SCREEN=use_screen, $
                    ALL=use_all, PRINTER=use_printer
   COMPILE_OPT IDL2, HIDDEN

   first_frame = sState.current_frame[0]
   last_frame = first_frame
   win_save = !D.WINDOW

   IF KEYWORD_SET(use_printer) THEN BEGIN
      bResult = DIALOG_PRINTJOB()
      IF bResult EQ 0 THEN BEGIN
         mview_wmessage, sState, 'print cancelled'
         return
      ENDIF 
   ENDIF 

   IF KEYWORD_SET(use_screen) THEN BEGIN
      IF NOT KEYWORD_SET(use_printer) THEN BEGIN
         filename = 'mv_screen_' + STRTRIM(first_frame+1, 2) + '.ps'
         strMessage = $
          STRING(FORMAT='("printing screen to ",A, "...",$)', filename)
      ENDIF ELSE BEGIN
         strMessage = "Sending screen to printer"
      ENDELSE
         
   ENDIF ELSE IF KEYWORD_SET(use_all) THEN BEGIN
      
      image_sz = SIZE(*sState.pImage)
      IF image_sz[0] EQ 3 THEN number_frames = image_sz[3] $
      ELSE number_frames = 1

      first_frame = 0
      last_frame = number_frames - 1

      IF NOT KEYWORD_SET(use_printer) THEN BEGIN
         filename = 'mv_frame.ps'
         strMessage = $
          STRING(FORMAT='("printing to ",A, "...",$)', filename)
      ENDIF ELSE BEGIN
         strMessage = "Sending to printer"
      ENDELSE

   ENDIF ELSE BEGIN

      IF NOT KEYWORD_SET(use_printer) THEN BEGIN
         filename = 'mv_frame_' + STRTRIM(first_frame+1, 2) + '.ps'
         strMessage = $
          STRING(FORMAT='("printing frame ", I0, " to ",A, "...",$)', $
                  first_frame+1, filename)
      ENDIF ELSE BEGIN
         strMessage = "Sending frame to printer"
      ENDELSE

   ENDELSE

   min_val = sState.min
   max_val = sState.max

   mview_wmessage, sState, strMessage

;   IF win_valid(sState.draw_win) THEN $
;    WSET, sState.draw_win $
;   ELSE MESSAGE, 'Invalid window selection.'

;   WSHOW, sState.draw_win, ICONIC=0

   IF KEYWORD_SET(use_screen) THEN BEGIN
      WIDGET_CONTROL, sState.wDraw, GET_DRAW_VIEW=corner

      x0 = corner[0] > 0
      y0 = corner[1] > 0
      x1 = (x0+sState.x_draw_sz) < (sState.x_image_sz-1)
      y1 = (y0+sState.y_draw_sz) < (sState.y_image_sz-1)

   ENDIF ELSE BEGIN

      x0 = 0
      y0 = 0
      frame_sz = SIZE((*sState.pImage)[*,*,first_frame])
      x1 = frame_sz[1] - 1
      y1 = frame_sz[2] - 1

   ENDELSE

   IF PTR_VALID(sState.pLabels) THEN $
    title_left = (*sState.pLabels)[first_frame:last_frame] $
   ELSE title_left = 'Frame'+STRTRIM(INDGEN(last_frame-first_frame+1)+first_frame,2)

   IF PTR_VALID(sState.pHeader) THEN BEGIN
      mview_print_get_labels, *sState.pHeader, label_col1, label_col2, $
       title_left, title_right
   ENDIF

   acs_image_ps, sState.pImage, XRANGE=[x0,x1], YRANGE=[y0,y1], $
    ZRANGE=[first_frame,last_frame], SCALE_TYPE = sState.scale_type, $
    FILENAME = filename, MINIMUM = min_val, MAXIMUM = max_val, $
    PRINTER = use_printer, TITLE_LEFT=title_left, TITLE_RIGHT=title_right, $
    LABEL_COL1=label_col1, LABEL_COL2=label_col2

   IF win_valid(save_win) THEN WSET, win_save

   IF NOT KEYWORD_SET(use_printer) THEN BEGIN
      strMessage = STRING(FORMAT='("Wrote", 1X, A)', filename)
   ENDIF ELSE BEGIN
      strMessage = "Sent to printer"
   ENDELSE

   mview_wmessage, sState, strMessage

   return
END 

; _____________________________________________________________________________

PRO mview_analysis_centroid, sState, xpos, ypos
   COMPILE_OPT IDL2, HIDDEN

   IF sState.sPrefs.analysis.centroid_fwhm LE 0 THEN BEGIN
      strMessage = '[centroid] input FWHM...'
      mview_wmessage, sState, strMessage

      input_title = 'Input centroid FWHM'
      input_label = 'FWHM:'
      value = 3.0
      fwhm = x_get_input(STATUS=status, TITLE=input_title, $
                         LABEL=input_label, /FLOAT, $
                         VALUE=value, GROUP=sState.wRoot)
   ENDIF ELSE status = 0b

   IF status EQ 0 THEN BEGIN

                    ; Save if available
      IF N_ELEMENTS(fwhm) GT 0 THEN $
       sState.sPrefs.analysis.centroid_fwhm = fwhm > 0

      mview_wmessage, sState, '[centroid] Left click on approximate center pixel'
      
      save_win = !D.WINDOW
      IF win_valid(sState.draw_win) THEN $
       WSET, sState.draw_win $
      ELSE MESSAGE, 'Invalid window selection.'
      
      IF (N_ELEMENTS(xpos) LE 0) OR (N_ELEMENTS(ypos) LE 0) THEN $
       wait_for_click, sState.wDraw, xpos, ypos

      x = (xpos / sState.main_zoom_factor)
      y = (ypos / sState.main_zoom_factor)

      strMessage = 'computing centroid...'
      mview_wmessage, sState, strMessage
      
      n_frame = sState.current_frame
      
      median = MEDIAN((*sState.pImage)[*,*,n_frame])
      CNTRD, (*sState.pImage)[*,*,n_frame]-median, x, y, $
       xcenter, ycenter, sState.sPrefs.analysis.centroid_fwhm
      
      IF win_valid(save_win) THEN WSET, save_win
      
      strMessage = STRING(FORMAT='("[centroid] computed center [x,y]: [",' + $
                          'I0,",",I0, "]")', $
                          xcenter, ycenter)
      mview_wmessage, sState, strMessage
   ENDIF ELSE mview_wmessage, sState, 'centroid cancelled.'

END 

; _____________________________________________________________________________

PRO mview_acslog_read, sState, entry, image, $
                       header, header_udl, header_eng1, header_eng2, $
                       ERROR=error_flag, DEBUG=debug
   COMPILE_OPT IDL2, HIDDEN
   start_memory = MEMORY(/CURRENT)
   IF KEYWORD_SET(debug) THEN PRINTF, -2, '===> Entered mview_acslog_read'
   error_flag = 0b
   
   FOR i=0, N_ELEMENTS(entry)-1 DO BEGIN
      strFormat = '("reading ACS_LOG entry number ",I0,"...")'
      strMessage = STRING(FORMAT=strFormat, entry[i])
      PRINT, strMessage
      ACS_READ, entry[i], header, data, header_udl, udl, $
       header_eng1, header_eng2, /NO_ABORT, MESSAGE=error_message

      IF N_ELEMENTS(data) GT 2 THEN BEGIN
         strExec = 'junk = UINT(2.2)'
         retval = EXECUTE(strExec)
         IF retval NE 0 THEN BEGIN
            data = UINT(TEMPORARY(data))
         ENDIF
      ENDIF ELSE BEGIN 
         strFormat = '(A,1X,I0,1H:,/,1X,A)'
         strMessage = STRING(FORMAT=strFormat, $
                              'error reading ACS_LOG entry number', $
                              entry[i], $
                              error_message)
         PRINTF, -2, strMessage
         error_flag = 1b
         return
      ENDELSE
      
      data_sz = SIZE(data)
      
      IF i EQ 0 THEN BEGIN
         image = MAKE_ARRAY(data_sz[1],data_sz[2],N_ELEMENTS(entry),$
                            TYPE=data_sz[3],/NOZERO)
         aLabels = STRARR(N_ELEMENTS(entry))
         aHeaders = MAKE_ARRAY(N_ELEMENTS(header), $
                                N_ELEMENTS(entry), /STRING)
      ENDIF ELSE BEGIN
      ENDELSE
      image_sz = SIZE(image)
      IF (image_sz[1] EQ data_sz[1]) AND (image_sz[2] EQ data_sz[2])$
       THEN BEGIN
         image[*,*,i] = TEMPORARY(data)
         aLabels[i] = 'Entry '+STRTRIM(entry[i], 2)
         aHeaders[*,i] = header
      ENDIF ELSE BEGIN
         strMessage = "WARNING: image " + STRTRIM(i+1, 2) + $
          " of " + STRTRIM(N_ELEMENTS(entry), 2) + $
          " has incompatible size; skipping."
         MESSAGE, strMessage, /CONTINUE, /NONAME
      ENDELSE

   ENDFOR

   IF KEYWORD_SET(debug) THEN PRINTF, -2, '<=== Leaving mview_acslog_read'
   IF KEYWORD_SET(debug) THEN BEGIN
      PRINTF, -2, FORMAT='("     used: ",I," bytes  current:",I)', $
       MEMORY(/HIGH)-start_memory,MEMORY(/CURRENT)
   ENDIF
   return
END

; _____________________________________________________________________________

PRO mview_open, sState, FITS=fits_type, JPEG=jpeg_type, $
                GIF=gif_type, TIFF=tiff_type, ACS_LOG=acs_log_type, $
                SDI=sdi_type, IMAGE=image_type, GROUP=group, $
                DEBUG=debug

   COMPILE_OPT IDL2, HIDDEN
   IF KEYWORD_SET(debug) THEN PRINTF, -2, '===> Entered mview_open'

   IF N_ELEMENTS(group) LE 0 THEN group = sState.wRoot

   type = ''
   IF KEYWORD_SET(fits_type) THEN type = 'FITS'
   IF KEYWORD_SET(image_type) THEN type = 'IMAGE'
   IF KEYWORD_SET(jpeg_type) THEN type = 'JPEG'
   IF KEYWORD_SET(gif_type) THEN type = 'GIF'
   IF KEYWORD_SET(tiff_type) THEN type = 'TIFF'
   IF KEYWORD_SET(acs_log_type) THEN type = 'ACS_LOG'
   IF KEYWORD_SET(sdi_type) THEN type = 'SDI'

                    ; erase crosshair
   x_trace, sState.wDraw, XSIZE=sState.x_image_sz, YSIZE=sState.y_image_sz, $
    x, y, LASTX=sState.lastx, LASTY=sState.lasty, /ERASE, $
    ZOOM=sState.main_zoom_factor
   sState.lastx = -1L
   sState.lasty = -1L

   mview_wmessage, sState, 'opening file...'
   WIDGET_CONTROL, /HOURGLASS
   CASE type OF
      'ACS_LOG': BEGIN
         input_title = 'Input ACS_LOG entry number'
         input_label = 'Entry number: '

         IF PTR_VALID(sState.pHeader) THEN BEGIN
            IF N_ELEMENTS(*sState.pHeader) GT 1 THEN BEGIN
               value = SXPAR((*sState.pHeader)[*,0], 'ENTRY')
            ENDIF
         ENDIF

         IF N_ELEMENTS(value) LE 0 THEN BEGIN
            db_name = 'ACS_LOG'
            DBOPEN, db_name
            value = LONG(DB_INFO('entries', 0))
         ENDIF

         entry_number = x_get_input(STATUS = status, $
                                     TITLE=input_title, $
                                     LABEL=input_label, /LONG, $
                                     VALUE=value, GROUP=sState.wRoot)
         IF status EQ 0 THEN BEGIN
            IF entry_number GT 0 THEN BEGIN

               strMessage = $
                STRING(FORMAT='("reading ACS_LOG entry ",I0,"...")', $
                        entry_number)
               mview_wmessage, sState, strMessage

               mview_acslog_read, sState, entry_number, data, $
                header, header_udl, header_eng1, header_eng2, $
                ERROR=error_flag, DEBUG=debug

               IF error_flag NE 1 THEN BEGIN
                  n_pixels = N_ELEMENTS(data)
                  IF n_pixels GT 2 THEN BEGIN
                     
                     labels = ['Entry '+STRTRIM(entry_number[0],2)]
                     
                  ENDIF ELSE BEGIN
                     strMessage = 'error: no data read from ACS_LOG database'
                     mview_wmessage, sState, strMessage
                     return
                  ENDELSE          
               ENDIF ELSE BEGIN
                  strMessage = 'error: no data read from ACS_LOG database'
                  mview_wmessage, sState, strMessage
                  return
               ENDELSE          
            ENDIF ELSE BEGIN
               strMessage = 'error: entry number must be greater than zero'
               mview_wmessage, sState, strMessage
               return
            ENDELSE
         ENDIF ELSE BEGIN
            strMessage = 'error: open cancelled'
            mview_wmessage, sState, strMessage
            return
         ENDELSE
         
      END 

      'SDI': BEGIN
         data = x_openf(header, header_udl, header_eng1, header_eng2, $
                         /SDI, NAME=filename, ERROR=error, $
                         PATH=sState.last_file_path, $
                         GET_PATH = new_path, GROUP=group)

         IF error NE 1 THEN BEGIN
            sState.last_file_path = new_path
            FDECOMP, filename[0], fdisk, fdir, fname, fext, fversion
            file = fname ; + '.' + fext + fversion

            labels = [file]
         ENDIF ELSE BEGIN
            mview_wmessage, sState, 'error: no data read.'
            return
         ENDELSE
      END

      'FITS': BEGIN
         data = x_openf(header, /FITS, NAME=filename, ERROR=error, $
                         PATH=sState.last_file_path, $
                         GET_PATH=new_path, GROUP=group)

         IF error NE 1 THEN BEGIN
            sState.last_file_path = new_path
            FDECOMP, filename[0], fdisk, fdir, fname, fext, fversion
            file = fname ; + '.' + fext + fversion

            labels = [file]
         ENDIF ELSE BEGIN
            mview_wmessage, sState, 'error: no data read.'
            return
         ENDELSE 
      END

      'IMAGE': BEGIN
         status = DIALOG_READ_IMAGE(IMAGE=data, $
                                     FILE=filename, $
                                     PATH=sState.last_file_path, $
                                     RED=color_r, $
                                     GREEN=color_g, $
                                     BLUE=color_b, $
                                     QUERY=sImageQuery, $
                                     DIALOG_PARENT=group)
         IF status EQ 1 THEN BEGIN
            FDECOMP, filename[0], fdisk, fdir, fname, fext, fversion
            file = fname + '.' + fext + fversion

            sState.last_file_path = fdisk + fdir

            ;;HELP, /STR, sImageQuery
            data_sz = SIZE(data)
            dimensions  = data_sz[1:data_sz[0]]
            dimensions1 = [sImageQuery.channels,sImageQuery.dimensions]
            dimensions3 = SHIFT(dimensions1, -1)
            IF (MAX(dimensions-dimensions1) EQ 0) THEN interleave=1 $
            ELSE IF (MAX(dimensions-dimensions3) EQ 0) THEN interleave=3 $
            ELSE interleave=2

                    ; Ignore alpha channel
            IF (sImageQuery.channels EQ 2) OR (sImageQuery.channels EQ 4) THEN BEGIN
               CASE interleave OF
                  1: BEGIN
                     data = (TEMPORARY(data))[0:(sImageQuery.channels-2),*,*]
                  END 
                  2: BEGIN
                     data = (TEMPORARY(data))[*,0:(sImageQuery.channels-2),*]
                  END
                  3: BEGIN
                     data = (TEMPORARY(data))[*,*,0:(sImageQuery.channels-2)]
                  END 
                  ELSE:
               ENDCASE 
            ENDIF 

            n_colors = !D.N_COLORS
            IF sImageQuery.channels GE 3 THEN BEGIN
               mview_wmessage, sState, 'quantizing colors...'
               data = COLOR_QUAN(TEMPORARY(data), interleave[0], COLORS=n_colors, $
                                  color_r, color_g, color_b, /DITHER)
            ENDIF

            IF N_ELEMENTS(color_r) GT 2 THEN BEGIN
               sState.scale_type = 'RAW'
               ;;TVLCT, color_r, color_g, color_b
               sState.pColorTableRed   = PTR_NEW(color_r, /NO_COPY)
               sState.pColorTableGreen = PTR_NEW(color_g, /NO_COPY)
               sState.pColorTableBlue  = PTR_NEW(color_b, /NO_COPY)
            ENDIF 

            labels = [file]
         ENDIF ELSE BEGIN
            mview_wmessage, sState, 'error: no data read.'
            return
         ENDELSE 
      END 

      ELSE: BEGIN
         return
      END

   ENDCASE 

                    ; At this point we have a variable named 'data'
                    ; and optionally 'header', 'header_udl',
                    ; 'header_eng1', 'header_eng2', 'labels'

   WIDGET_CONTROL, sState.wRoot, /CLEAR_EVENTS

   mview_update_all, sState, data, HEADER_STD=header, $
    HEADER_UDL=header_udl, HEADER_ENG1=header_eng1, $
    HEADER_ENG2=header_eng2, LABELS=labels, DEBUG=debug

   IF (sState.initial_open EQ 1) OR (sState.sPrefs.setup.autoscale EQ 1) THEN BEGIN
      mview_autoscale_display, sState
   ENDIF
   sState.initial_open = 0b

   image_sz = SIZE(data)
   strMessage = $
    STRING(FORMAT='("Read ",' + STRTRIM(image_sz[0]-1, 2) + $
            '(I0," x "),I0," array")', $
            image_sz[1:image_sz[0]])
   IF (sState.scale_type EQ 'RAW') THEN $
    strMessage=strMessage+' ('+STRTRIM(n_colors,2)+' colors)'
   mview_wmessage, sState, strMessage

   WIDGET_CONTROL, sState.wRoot, /CLEAR_EVENTS
   IF KEYWORD_SET(debug) THEN PRINTF, -2, '<=== Leaving mview_open'

END

; _____________________________________________________________________________

FUNCTION mview_get_zoom_image, sState, xpos, ypos
   COMPILE_OPT IDL2, HIDDEN

   zoom_factor = sState.zoom_factor
   IF zoom_factor EQ 0 THEN zoom_factor = 1
   IF zoom_factor LT 0 THEN zoom_factor = 1 / ABS(FLOAT(zoom_factor))

                    ; compute size of rectangle in original image
                    ; round up to make sure image fills zoom window
   rect_x = LONG(sState.x_zoom_sz / FLOAT(zoom_factor) + 0.999)
   rect_y = LONG(sState.y_zoom_sz / FLOAT(zoom_factor) + 0.999)

                    ; Plan to erase if the zoom rectangle is larger
                    ; than the original image size.
   doerase = (rect_x GT sState.x_image_sz OR rect_y GT sState.y_image_sz)

   rect_x = rect_x < sState.x_image_sz
   rect_y = rect_y < sState.y_image_sz

                    ; compute location of origin of rect (user
                    ; specified center)
   x0 = xpos - rect_x/2
   y0 = ypos - rect_y/2

                    ; make sure rectangle fits into original image
                    ;left edge from center
   x0 = x0 > 0
                    ; limit right position
   x0 = x0 < (sState.x_image_sz - rect_x)

                    ; Save this position
   sState.zoom_xcor = x0

                    ;bottom
   y0 = y0 > 0
   y0 = y0 < (sState.y_image_sz - rect_y)

                    ; Save this position
   sState.zoom_ycor = y0

   n_frame = sState.current_frame

   IF zoom_factor EQ 1 THEN BEGIN
      IF doerase THEN ERASE

      zoom_image = (*sState.pImage)[x0:x0+rect_x-1, y0:y0+rect_y-1, n_frame]
      
   ENDIF ELSE BEGIN
                    ;Make integer rebin factors.  These may be larger
                    ;than the zoom image
      dim_x = rect_x * zoom_factor
      dim_y = rect_y * zoom_factor

                    ; Constrain upper right edge to within original image.
      x1 = (x0 + rect_x - 1) < (sState.x_image_sz-1)
      y1 = (y0 + rect_y - 1) < (sState.y_image_sz-1)

      temp_image = FREBIN((*sState.pImage)[x0:x1,y0:y1,n_frame], $
                           dim_x, dim_y)

      fill_x = dim_x < sState.x_zoom_sz 
      fill_y = dim_y < sState.y_zoom_sz 
      zoom_image = MAKE_ARRAY(sState.x_zoom_sz, sState.y_zoom_sz)
      zoom_image[0:fill_x-1,0:fill_y-1] = temp_image[0:fill_x-1,0:fill_y-1]

                    ; Pad zoomed image with black if necessary.
      if (fill_x LT sState.x_zoom_sz) then $
       zoom_image[fill_x:sState.x_zoom_sz-1, *] = 0
      if (fill_y LT sState.y_zoom_sz) then $
       zoom_image[*, fill_y:sState.y_zoom_sz-1] = 0

   ENDELSE

   return, zoom_image
END

; _____________________________________________________________________________

PRO mview_free_pointers, sState
   COMPILE_OPT IDL2, HIDDEN

   PTR_FREE, sState.pImage, sState.pHeader, $
    sState.pActiveRegion, sState.pHeaderUdl, sState.pHeaderEng1, $
    sState.pHeaderEng2, sState.pLabels, $
    sState.pColorTableRed, sState.pColorTableGreen, sState.pColorTableBlue

   return
END 

; _____________________________________________________________________________

FUNCTION mview_get_default_prefs, version
   COMPILE_OPT IDL2, HIDDEN

   IF N_ELEMENTS(version) LE 0 THEN version = '0.0'

   plot_opts = CREATE_STRUCT(NAME='PLOT_OPTS_'+STRTRIM(version,2), $
                              'postscript_output', 0b, $
                              'contour', 'image, NLEVELS=10, /FILL', $
                              'surface', 'image', $
                              'shade_surf', 'image', $
                              'show3', 'image', $
                              'contour_over', 'image', $
                              'histogram', 'HISTOGRAM(image, MIN=0, MAX=MAX(image)), PSYM=10')

   setup_opts = CREATE_STRUCT(NAME='SETUP_OPTS_'+STRTRIM(version,2), $
                               'track', 1b, $
                               'defroi', 0b, $
                               'autoscale', 0b, $
                               'autostats', 1b, $
                               'autozoom', 1.0, $
                               'keep_roi', 0b, $
                               'color_scale', 0b, $
                               'slice_width', 3L, $
                               'autoblink', 0b, $
                               'blink_delay', 1e)

   button_opts = CREATE_STRUCT(NAME='BUTTON_OPTS_'+STRTRIM(version,2), $
                                'button1', 0b, $
                                'button2', 1b, $
                                'button3', 2b)

   startup_opts = CREATE_STRUCT(NAME='STARTUP_OPTS_'+STRTRIM(version,2), $
                                 'color_table_number', 3, $
                                 'display_scale', 0b, $
                                 'profiles_xsize', 250, $
                                 'profiles_ysize', 250)

   analysis_opts = CREATE_STRUCT(NAME='ANALYSIS_OPTS_'+STRTRIM(version,2), $
                                  'centroid_fwhm', 3e, $
                                  'centroid_multiple', 0b)

   filter_opts = CREATE_STRUCT(NAME='FILTER_OPTS_'+STRTRIM(version,2), $
                                'median_size', 5, $
                                'smooth_size', 5, $
                                'lee_size', 5, $
                                'lee_sigma', 5)
                                  
   struct_name = 'MVIEW_PREFS_' + STRTRIM(version,2)
   sPrefs = CREATE_STRUCT(NAME=struct_name, $
                           'filter', filter_opts, $
                           'plot', plot_opts, $
                           'setup', setup_opts, $
                           'button', button_opts, $
                           'startup', startup_opts, $
                           'analysis', analysis_opts)

   return, sPrefs
END 

; _____________________________________________________________________________

FUNCTION mview_restore_prefs, strFileName, version, SILENT=silent
   COMPILE_OPT IDL2, HIDDEN

   IF N_ELEMENTS(strFileName) LE 0 THEN $
    strFileName = GETENV('HOME') + '/.mview'

   pfile = FINDFILE(strFileName, COUNT=pcount)
   sPrefs_merged = mview_get_default_prefs(version)

   IF pcount GT 0 THEN BEGIN
      IF NOT KEYWORD_SET(silent) THEN $
       PRINTF, -1, FORMAT='(A,$)', 'restoring preferences...'

                    ; This will restore a variable named sPrefs
      RESTORE, FILENAME = strFileName, /RELAXED_STRUCTURE_ASSIGNMENT

      IF NOT KEYWORD_SET(silent) THEN $
       PRINTF, -1, 'done.'

      IF N_TAGS(sPrefs) GT 1 THEN BEGIN
                    ; Now merge sPrefs with the defaults
         STRUCT_ASSIGN, sPrefs, sPrefs_merged, /NOZERO
      ENDIF
   ENDIF
   
   return, sPrefs_merged
END

; _____________________________________________________________________________

PRO mview_event, sEvent
   COMPILE_OPT IDL2, HIDDEN

                    ; ______________________________________
   
                    ; event processing for Mview
                    ; ______________________________________

                    ; get state information from first child of root
   wChildBase = WIDGET_INFO(sEvent.handler, /CHILD)
   wStateHandler = WIDGET_INFO(wChildBase, /SIBLING)
   WIDGET_CONTROL, wStateHandler, GET_UVALUE=sState, /NO_COPY 

   junk = WHERE('UVALUE' EQ TAG_NAMES(sEvent), uvcount)
   IF uvcount LE 0 THEN $
    WIDGET_CONTROL, sEvent.id, GET_UVALUE = event_uval $
   ELSE event_uval = sEvent.UVALUE
   
   debug = sState.debug
   CASE STRUPCASE(event_uval) OF
      'ROOT': BEGIN
         IF TAG_NAMES(sEvent, /STRUCTURE_NAME) EQ 'WIDGET_KILL_REQUEST' $
          THEN BEGIN
            sState.wProfileWin = -1L
            mview_free_pointers, sState
            WIDGET_CONTROL, sEvent.top, /DESTROY
            return
         ENDIF
      END 

      'MENU': BEGIN
         dotpos = STRPOS(sEvent.value, '.', /REVERSE_SEARCH)

         IF dotpos NE -1 THEN BEGIN
            parentmenus = STRMID(sEvent.value, 0, dotpos)
            menuvalue = STRMID(sEvent.value, dotpos+1, STRLEN(sEvent.value))

            CASE STRUPCASE(parentmenus) OF

               'OPTIONS.FILTERS': BEGIN
                  mview_image_filter, sState, menuvalue
               END

               'OPTIONS.PLOT TYPES': BEGIN
                  
                  mview_wmessage, sState, 'Generating plot...'
                  mview_new_plot, sState.pImage, menuvalue, $
                   PLOT_OPTS = sState.sPrefs.plot, POSITION = position, $
                   /NORMAL, FRAME = sState.current_frame, $
                   ERROR = error, MAX = sState.max, MIN = sState.min, $
                   POSTSCRIPT=sState.sPrefs.plot.postscript_output
                  IF error EQ 1 THEN BEGIN
                     mview_wmessage, sState, !ERR_STRING
                  ENDIF ELSE mview_wmessage, sState, ' '

               END
               
               'VIEW.SCALE': BEGIN

                  CASE STRUPCASE(menuvalue) OF
                     'LINEAR': type = 'LINEAR'
                     'SQRT'  : type = 'SQRT'
                     'LOG'   : type = 'LOG'
                     'HISTOGRAM EQ': type = 'HIST_EQ'
                     'RAW'   : type = 'RAW'
                     ELSE: MESSAGE, 'case not found '+menuvalue, /INFO
                  ENDCASE

                  IF type NE sState.scale_type THEN BEGIN
                     sState.scale_type = type
                     mview_update_widget, sState, DEBUG=debug
                  ENDIF

               END

               ELSE:

            ENDCASE

         ENDIF

         CASE sEvent.value OF

            'File.Open.ACS_LOG': BEGIN
                    ; Save the state before we hand off to x_get_input
                    ; Don't use /NOCOPY because we still need the
                    ; state in the event handler
               WIDGET_CONTROL, wStateHandler, SET_UVALUE=sState

               Mview_Open, sState, /ACS_LOG, DEBUG=debug
            END 
            
            'File.Open.SDI': BEGIN
               Mview_Open, sState, /SDI, DEBUG=debug
            END
            
            'File.Open.Image': BEGIN
               Mview_Open, sState, /IMAGE, DEBUG=debug
            END 

            'File.Open.FITS': BEGIN
               Mview_Open, sState, /FITS, DEBUG=debug
            END

            'File.Open.JPEG': BEGIN
               Mview_Open, sState, /JPEG, DEBUG=debug
            END

            'File.Open.GIF': BEGIN
               Mview_Open, sState, /GIF, DEBUG=debug
            END

            'File.Open.TIFF': BEGIN
               Mview_Open, sState, /TIFF, DEBUG=debug
            END

            'File.Open.Region': BEGIN
               
               IF PTR_VALID(sState.pActiveRegion) THEN BEGIN
                  
                  IF sState.sPrefs.setup.defroi NE 1 THEN BEGIN
                     
                     IF N_ELEMENTS(*sState.pActiveRegion) GT 4 THEN BEGIN
                        version = sState.version
                        instance = XREGISTERED('mview', /NOSHOW) + 1L

                        n_frame = sState.current_frame
                        n_pixels = N_ELEMENTS((*sState.pImage)[*,*,0])
                        
                        image_sz = SIZE((*sState.pImage)[*,*,0])
                        subscripts = (*sState.pActiveRegion)
                        subscript_offset = n_pixels * LONG(n_frame)
                        
                        min_sub = MIN(subscripts)
                        max_sub = MAX(subscripts)
                        subscripts = 0b

                        x0 = min_sub MOD image_sz[1]
                        y0 = min_sub / LONG(image_sz[1])
                        x1 = max_sub MOD image_sz[1]
                        y1 = max_sub / LONG(image_sz[1])

                        IF (x0 LT (x1-1)) AND (y0 LT (y1-1)) THEN BEGIN
                           DataRegion = $
                            (*sState.pImage)[x0:x1,y0:y1,*]
                           
                           strTitle = $
                            STRING(FORMAT='("Mview (v",A,")")', $
                                   version)

                           strMessage = 'opening region in new viewer...'
                           mview_wmessage, sState, strMessage
                           CASE STRUPCASE(sState.scale_type) OF
                              'LOG': log_type = 1b
                              'SQRT': sqrt_type = 1b
                              'HIST_EQ': hist_type = 1b
                              'LINEAR': linear_type = 1b
                              'RAW': raw_type = 1b
                              ELSE: 
                           ENDCASE
                           mview, DataRegion, $
                            TITLE=strTitle, /NO_COPY, $
                            LOG=log_type, SQRT=sqrt_type, $
                            HIST=hist_type, LINEAR=linear_type, $
                            RAW=raw_type, DEBUG=debug
                           mview_wmessage, sState, 'launched new viewer.'
                        ENDIF ELSE mview_wmessage, sState, 'Invalid region.'
                        
                     ENDIF ELSE BEGIN
                        mview_wmessage, sState, 'Active region is invalid.'
                     ENDELSE
                  ENDIF ELSE BEGIN
                     strMessage='Feature not available with irregular selections.'
                     mview_wmessage, sState, strMessage
                  ENDELSE 
               ENDIF ELSE BEGIN
                  mview_wmessage, sState, 'No active region defined.'
               ENDELSE

            END

            'File.Save.Frame.FITS': BEGIN
               dialog_file = 'object.fits'
               svname = DIALOG_PICKFILE(FILE=dialog_file, /WRITE, $
                                         FILTER='*.fits', $
                                         PATH=sState.last_file_path, $
                                         GET_PATH=writepath)
               IF svname[0] NE '' THEN BEGIN
                  junk = FINDFILE(svname, COUNT=fcnt)

                  IF fcnt GE 1 THEN BEGIN
                     strMessage = 'write error: file '+svname[0]+' exists'
                     mview_wmessage, sState, strMessage
                  
                  ENDIF ELSE BEGIN
                     
                     IF PTR_VALID(sState.pHeader) THEN BEGIN
                        WRITEFITS,svname[0],(*sState.pImage),(*sState.pHeader)[*,0]
                     ENDIF ELSE WRITEFITS, svname[0], (*sState.pImage)
                     sState.last_file_path = writepath[0]
                     mview_wmessage, sState, 'wrote '+svname[0]

                  ENDELSE
               ENDIF ELSE BEGIN
                  strMessage = 'save cancelled.'
                  mview_wmessage, sState, strMessage
               ENDELSE
            END

            'File.Save.Frame.Image': BEGIN
               n_frame = sState.current_frame
               TVLCT, color_r, color_g, color_b, /GET
               n_colors = 256
               color_r = CONGRID(color_r, n_colors, /INTERP)
               color_g = CONGRID(color_g, n_colors, /INTERP)
               color_b = CONGRID(color_b, n_colors, /INTERP)
               
               status = DIALOG_WRITE_IMAGE(BYTSCL((*sState.pImage)[*,*,n_frame], $
                                                    MIN=sState.min,MAX=sState.max, $
                                                    TOP=n_colors-1), $
                                            color_r, color_g, color_b, $
                                            OPTIONS=sSaveImageOptions, $
                                            FILENAME=save_filename, $
                                            PATH=sState.last_file_path, $
                                            DIALOG_PARENT=sEvent.top)
               ;;HELP, /STR, sSaveImageOptions
               IF status EQ 1 THEN BEGIN
                  strMessage = STRING(FORMAT='("Wrote frame ",I0)',$
                                       n_frame+1)
                  mview_wmessage, sState, strMessage
               ENDIF ELSE BEGIN
                  mview_wmessage, sState, 'save cancelled.'
               ENDELSE 
            END 

            'File.Save.Sequence.MPEG': BEGIN

               n_frame = sState.current_frame
               dialog_file = sState.last_file_path+'/object.mpg'
               svname = DIALOG_PICKFILE(FILE=dialog_file, /WRITE, $
                                         FILTER='*.mpg', GET_PATH=writepath)

               junk = FINDFILE(svname, COUNT=fcnt)

               IF fcnt GE 1 THEN BEGIN
                  mview_wmessage, sState, 'write error: file exists'
               ENDIF ELSE BEGIN

                  image_sz = SIZE(*sState.pImage)
                  IF image_sz[0] EQ 3 THEN number_frames = image_sz[3] $
                  ELSE number_frames = 1
                  
                  IF number_frames GT 1 THEN BEGIN
                     first_frame = 0
                     last_frame = number_frames - 1

                    ; Open the MPEG object
                     oMpeg = MPEG_OPEN([image_sz[1],image_sz[2]])

                     n_colors = 256
                     FOR n_frame = first_frame, last_frame DO BEGIN
                        PRINT, 'writing frame ' + STRTRIM(n_frame)
                        MPEG_PUT, oMpeg, FRAME = n_frame, /COLOR, IMAGE = $
                         BYTSCL((*sState.pImage)[*,*,n_frame], $
                                 MIN=sState.min,MAX=sState.max, $
                                 TOP=n_colors-1)
                     ENDFOR
                     MPEG_SAVE, oMpeg, FILENAME = svname ; Save the file
                     MPEG_CLOSE, oMpeg ; Close the sequence

                     mview_wmessage, sState, 'Wrote sequence to '+svname
                  ENDIF ELSE BEGIN
                     mview_wmessage, sState, 'Sequence must have more than one frame'
                  ENDELSE

               ENDELSE

            END

            'File.Save.Screen.FITS': BEGIN

               dialog_file = 'object.fits'
               svname = DIALOG_PICKFILE(FILE=dialog_file, /WRITE, $
                                         FILTER='*.fits', $
                                         PATH=sState.last_file_path, $
                                         GET_PATH=writepath)
               IF svname[0] NE '' THEN BEGIN
                  junk = FINDFILE(svname[0], COUNT=fcnt)

                  IF fcnt GE 1 THEN BEGIN
                     mview_wmessage, sState, 'write error: file exists'
                  ENDIF ELSE BEGIN

                     WIDGET_CONTROL, sState.wDraw, GET_DRAW_VIEW=corner
                     x0 = corner[0] > 0
                     y0 = corner[1] > 0
                     x1 = (x0+sState.x_draw_sz) < (sState.x_image_sz-1)
                     y1 = (y0+sState.y_draw_sz) < (sState.y_image_sz-1)
                     
                     n_frame = sState.current_frame
                     WRITEFITS, svname[0], (*sState.pImage)[x0:x1,y0:y1,n_frame]
                     sState.last_file_path = writepath[0]
                     strMessage = STRING(FORMAT='("Wrote frame ",I0," to ",A)',$
                                          n_frame+1, svname[0])
                     mview_wmessage, sState, strMessage
                  ENDELSE
               ENDIF ELSE BEGIN
                  mview_wmessage, sState, 'save cancelled.'
               ENDELSE
            END

            'File.Save.Screen.Image': BEGIN
               WIDGET_CONTROL, sState.wDraw, GET_DRAW_VIEW=corner
               x0 = corner[0] > 0
               y0 = corner[1] > 0
               x1 = (x0+sState.x_draw_sz) < (sState.x_image_sz-1)
               y1 = (y0+sState.y_draw_sz) < (sState.y_image_sz-1)

               n_frame = sState.current_frame

               TVLCT, color_r, color_g, color_b, /GET
               n_colors = 256
               color_r = CONGRID(color_r, n_colors, /INTERP)
               color_g = CONGRID(color_g, n_colors, /INTERP)
               color_b = CONGRID(color_b, n_colors, /INTERP)
               
               status = DIALOG_WRITE_IMAGE(BYTSCL((*sState.pImage)[x0:x1,y0:y1,n_frame], $
                                                    MIN=sState.min, MAX=sState.max, $
                                                    TOP=n_colors-1), $
                                            color_r, color_g, color_b, $
                                            OPTIONS=sSaveImageOptions, $
                                            FILENAME=save_filename, $
                                            PATH=sState.last_file_path, $
                                            DIALOG_PARENT=sEvent.top)
               ;;HELP, /STR, sSaveImageOptions
               IF status EQ 1 THEN BEGIN
                  mview_wmessage, sState, 'Wrote screen to file'
               ENDIF ELSE BEGIN
                  mview_wmessage, sState, 'save cancelled.'
               ENDELSE 
            END 
            
            'File.Print.Frame.PS file': BEGIN
               mview_printout, sState, /FRAME
            END 
            'File.Print.Frame.Printer': BEGIN
               mview_printout, sState, /FRAME, /PRINTER
            END 

            'File.Print.Screen.PS file': BEGIN
               mview_printout, sState, /SCREEN
            END 
            'File.Print.Screen.Printer': BEGIN
               mview_printout, sState, /SCREEN, /PRINTER
            END 

            'File.Print.All.PS file': BEGIN
               mview_printout, sState, /ALL
            END 
            'File.Print.All.Printer': BEGIN
               mview_printout, sState, /ALL, /PRINTER
            END 

            'File.Print setup': BEGIN
               bResult = DIALOG_PRINTERSETUP(TITLE='Print setup')
            END 
               
            'File.Reset': BEGIN
               sPrefs = mview_restore_prefs(strFileName, sState.version)
               sState.sPrefs = sPrefs
               sState.button_down = 0b ; reset the button down flag
                    ; reset the active region
               PTR_FREE, sState.pActiveRegion
               sState.pActiveRegion = PTR_NEW()

               mview_refresh_display, sState, /ALL, DEBUG=debug
            END 

            'File.Exit': BEGIN
               sState.wProfileWin = -1L
               mview_free_pointers, sState
               WIDGET_CONTROL, sEvent.top, /DESTROY
               return
            END 
            
            'Options.Preferences': BEGIN
               mview_prefs, sEvent.top, sState.sPrefs, GROUP=sEvent.top, $
                INSTANCE = sState.instance, VERSION = sState.Version
            END
            
            'Options.Reset region': BEGIN
                    ; reset the active region
               PTR_FREE, sState.pActiveRegion
               sState.pActiveRegion = PTR_NEW()
               mview_wmessage, sState, 'Active region reset.'
            END 

            'Options.Image operations.Rebin': BEGIN
                    ; Save the state before we hand off to x_get_input
                    ; Don't use /NOCOPY because we still need the
                    ; state in the event handler
               
               WIDGET_CONTROL, wStateHandler, SET_UVALUE=sState
               mview_image_operations, sState, 'REBIN'
            END

            'Options.Image operations.Logarithm': BEGIN
               mview_image_operations, sState, 'ALOG'
            END

            'Options.Image operations.Logarithm10': BEGIN
               mview_image_operations, sState, 'ALOG10'
            END

            'Options.Image operations.Square root': BEGIN
               mview_image_operations, sState, 'SQRT'
            END

            'Options.Image operations.Square': BEGIN
               mview_image_operations, sState, 'SQUARE'
            END

            'Options.Image operations.Subtraction.Constant': BEGIN
               mview_image_operations, sState, 'SUBTRACT_CONSTANT'
            END

            'Options.Image operations.Subtraction.Image.ACS_LOG': BEGIN
               mview_image_operations, sState, 'SUBTRACT_IMAGE', 'ACS_LOG'
            END

            'Options.Image operations.Subtraction.Image.FITS': BEGIN
               mview_image_operations, sState, 'SUBTRACT_IMAGE', 'FITS'
            END
            
            'Options.Image operations.Division.Constant': BEGIN
               mview_image_operations, sState, 'DIVIDE_CONSTANT'
            END

            'Options.Image operations.Division.Image.ACS_LOG': BEGIN
               mview_image_operations, sState, 'DIVIDE_IMAGE', 'ACS_LOG'
            END

            'Options.Image operations.Division.Image.FITS': BEGIN
               mview_image_operations, sState, 'DIVIDE_IMAGE', 'FITS'
            END

            "Options.Image operations.Two's complement": BEGIN
               mview_image_operations, sState, 'COMPLEMENT'
            END
            
            'View.Next frame': BEGIN
               mview_blink_images, sState
            END 

            'View.Prev frame': BEGIN
               mview_blink_images, sState, /REVERSE
            END 

            'View.Refresh': BEGIN
               sState.button_down = 0b ; reset the button down flag
               mview_refresh_display, sState, /ALL, DEBUG=debug
            END

            'View.Autoscale': BEGIN
               mview_autoscale_display, sState               
            END
            
            'View.Shrink to fit': BEGIN
               IF ((sState.x_draw_sz GT sState.x_image_sz) OR $
                    (sState.y_draw_sz GT sState.y_image_sz)) THEN BEGIN
                  offset = 20
                  sState.x_draw_sz = sState.x_image_sz
                  sState.y_draw_sz = sState.y_image_sz

                  WIDGET_CONTROL, sState.wDraw, $
                   XSIZE=sState.x_image_sz-offset, YSIZE=sState.y_image_sz-offset
               ENDIF 
            END 

            'View.Bring forward': BEGIN
               IF win_valid(sState.draw_win) THEN $
                WSHOW, sState.draw_win, ICONIC = 0 $
               ELSE MESSAGE, 'Invalid window selection.'
            END

            'View.Header.Standard': BEGIN
               IF PTR_VALID(sState.pHeader) THEN BEGIN
                  n_frame = sState.current_frame
                  header_sz = SIZE(*sState.pHeader)
                  IF header_sz[0] LT (n_frame+1) THEN n_frame = 0
                  x_display_list, (*sState.pHeader)[*,n_frame], $
                   TITLE = 'Header', FILENAME = 'header.txt', $
                   GROUP = sEvent.top
               ENDIF ELSE BEGIN
                  strMessage = 'No header defined.'
                  mview_wmessage, sState, strMessage
               ENDELSE
            END 

            'View.Header.UDL': BEGIN
               IF PTR_VALID(sState.pHeaderUdl) THEN BEGIN
                  n_frame = sState.current_frame
                  x_display_list, (*sState.pHeaderUdl)[*,n_frame], $
                   TITLE = 'UDL Header', FILENAME = 'udl_header.txt',$
                   GROUP = sEvent.top
               ENDIF ELSE BEGIN
                  strMessage = 'No header defined.'
                  mview_wmessage, sState, strMessage
               ENDELSE
            END 

            'View.Header.Engineering1': BEGIN
               IF PTR_VALID(sState.pHeaderEng1) THEN BEGIN
                  n_frame = sState.current_frame
                  x_display_list, (*sState.pHeaderEng1)[*,n_frame], $
                   TITLE = 'Engineering Header 1', $
                   FILENAME = 'eng1_header.txt', $
                   GROUP = sEvent.top
               ENDIF ELSE BEGIN
                  strMessage = 'No header defined.'
                  mview_wmessage, sState, strMessage
               ENDELSE
            END 

            'View.Header.Engineering2': BEGIN
               IF PTR_VALID(sState.pHeaderEng2) THEN BEGIN
                  n_frame = sState.current_frame
                  x_display_list, (*sState.pHeaderEng2)[*,n_frame], $
                   TITLE = 'Engineering Header 2', $
                   FILENAME = 'eng2_header.txt', $
                   GROUP = sEvent.top
               ENDIF ELSE BEGIN
                  strMessage = 'No header defined.'
                  mview_wmessage, sState, strMessage
               ENDELSE
            END 

            'Tools.Annotate': BEGIN
                    ; Save the state before handing off to annotate
               WIDGET_CONTROL, wStateHandler, SET_UVALUE=sState
                    ; Erase the current crosshair
               x_trace, sState.wDraw, XSIZE=sState.x_image_sz, $
                YSIZE=sState.y_image_sz, ZOOM=sState.main_zoom_factor, $
                x, y, LASTX=sState.lastx, LASTY=sState.lasty, /ERASE
               sState.lastx = -1L
               sState.lasty = -1L

                    ; Maximize window
               screen_size = GET_SCREEN_SIZE()
               sGeometry = WIDGET_INFO(sState.wDraw, /GEOMETRY)
               IF ((sState.x_draw_sz LT sState.x_image_sz) OR $
                    (sState.y_draw_sz LT sState.y_image_sz)) THEN BEGIN
                  offset = 20
                  new_xsize = (sState.x_image_sz-offset) > 100 < screen_size[0]
                  new_ysize = (sState.y_image_sz-offset) > 100 < screen_size[1]
                  WIDGET_CONTROL,sState.wDraw,XSIZE=new_xsize, YSIZE=new_ysize
               ENDIF 
               
               ANNOTATE, WINDOW=sState.draw_win
               WIDGET_CONTROL, sState.wDraw, /CLEAR_EVENTS
                    ; Restore window size
               WIDGET_CONTROL, sState.wDraw, XSIZE=sGeometry.xsize, $
                YSIZE=sGeometry.ysize
            END

            'Tools.Xloadct': XLOADCT, GROUP=sEvent.top

            'Analysis.Plot slice': BEGIN

               save_win = !D.WINDOW

               IF win_valid(sState.draw_win) THEN $
                WSET, sState.draw_win $
               ELSE MESSAGE, 'Invalid window selection.'

               strMessage = 'Click two points on the image'

               mview_wmessage, sState, strMessage

               slice = PROFILE(*sState.pImage, x_index, y_index, /NOMARK)
               WIDGET_CONTROL, sState.wDraw, /CLEAR_EVENTS

               strTitle = 'Mview Slice'
               ;;WINDOW, /FREE, XSIZE = 512, YSIZE = 256, TITLE = strTitle
               pplot, slice, PSYM = 10, XTITLE = 'Pixel number', $
                YTITLE = 'Pixel value', /XSTYLE, /YSTYLE, $
                YRANGE = [ sState.min, sState.max ], WTITLE = strTitle, $
                GROUP = sState.wRoot

               strMessage = ' '

               mview_wmessage, sState, strMessage

               IF win_valid(save_win) THEN WSET, save_win

            END 

            'Analysis.Image stats': BEGIN

               mview_wmessage, sState, 'calculating image statistics...'

               n_frame = sState.current_frame
               IF N_ELEMENTS((*sState.pImage)[*,*,n_frame]) GT 1.2e6 THEN BEGIN

                  rand_num = 1.2e6
                  mview_update_stats, sState, RANDOM=rand_num

                  strFormat = '("computed stats of ",I0," random points.")'
                  strMessage = STRING(FORMAT=strFormat, rand_num)
                  mview_wmessage, sState, strMessage
               ENDIF ELSE BEGIN
                  n_frame = sState.current_frame
                  region = LINDGEN(N_ELEMENTS((*sState.pImage)[*,*,n_frame]))
                  mview_update_stats, sState, region
                  mview_wmessage, sState, ' '
               ENDELSE
               
            END 

            'Analysis.Region stats': BEGIN
               IF PTR_VALID(sState.pActiveRegion) THEN BEGIN
                  IF N_ELEMENTS(*sState.pActiveRegion) GT 4 THEN BEGIN
                     mview_wmessage, sState, 'calculating region statistics...'
                     mview_update_stats, sState, *sState.pActiveRegion
                     mview_wmessage, sState, ' '
                  ENDIF ELSE BEGIN
                     mview_wmessage, sState, 'Active region too small.'
                  ENDELSE 
               ENDIF ELSE BEGIN
                  mview_wmessage, sState, 'No active region defined.'
               ENDELSE                  
            END

            'Analysis.Centroid': BEGIN

                    ; Save the state before we hand off to x_get_input
                    ; Don't use /NOCOPY because we still need the
                    ; state in the event handler

               WIDGET_CONTROL, wStateHandler, SET_UVALUE=sState

                    ; erase the current crosshair
               x_trace, sState.wDraw, XSIZE=sState.x_image_sz, $
                YSIZE=sState.y_image_sz, ZOOM=sState.main_zoom_factor, $
                LASTX=sState.lastx, LASTY=sState.lasty, /ERASE
               sState.lastx = -1L
               sState.lasty = -1L

               mview_wmessage, sState, $
                '[centroid] left click on approximate center pixel.'
               IF sState.sPrefs.analysis.centroid_multiple EQ 1b THEN BEGIN
                  sState.analysis_loop = 1b
                  sState.analysis_routine = 'CENTROID'
               ENDIF ELSE BEGIN
                  mview_analysis_centroid, sState
               ENDELSE

            END

            'Analysis.Histogram region': BEGIN
               IF PTR_VALID(sState.pActiveRegion) THEN BEGIN
                  IF N_ELEMENTS(*sState.pActiveRegion) GT 4 THEN BEGIN
                     strTitle = 'Histogram region'
                     mview_wmessage, sState, 'Generating plot...'

;                     min_val = MIN((*sState.pImage)[*sState.pActiveRegion])
;                     max_val = MAX((*sState.pImage)[*sState.pActiveRegion])
;                     xindex = LINDGEN(max_val - min_val) + min_val
                     IF sState.sPrefs.setup.defroi NE 1 THEN BEGIN
                        
                        n_frame = sState.current_frame
                        n_pixels = N_ELEMENTS((*sState.pImage)[*,*,0])
                        
                        image_sz = SIZE((*sState.pImage)[*,*,0])
                        subscripts = (*sState.pActiveRegion)
                        subscript_offset = n_pixels * LONG(n_frame)
                        
                        min_sub = MIN(subscripts)
                        max_sub = MAX(subscripts)
                        subscripts = 0b
                        
                        x0 = min_sub MOD image_sz[1]
                        y0 = min_sub / LONG(image_sz[1])
                        x1 = max_sub MOD image_sz[1]
                        y1 = max_sub / LONG(image_sz[1])
                        
                        strFormat = '(1H[,I0,1H:,I0,1H,,I0,1H:,I0,1H,,I0,1H])'
                        strRegion=STRING(FORMAT=strFormat,x0,x1,y0,y1,n_frame)

                     ENDIF ELSE strRegion = 'irregular'
                     strLabel = (*sState.pLabels)[0]
                     strSubtitle = strLabel+'  region: ' + strRegion

                     IF PTR_VALID(sState.pHeader) THEN BEGIN
                        IF N_ELEMENTS(*sState.pHeader) GT 1 THEN BEGIN
                           entry = $
                            STRTRIM(SXPAR((*sState.pHeader)[*,0], 'ENTRY'),2)
                           IF entry NE 0 THEN $
                            strSubtitle='region: '+strRegion+'  entry: '+entry
                        ENDIF
                     ENDIF

                     strTitle = 'Histogram Region'
                     strYTitle = 'Density per Bin'
                     strXTitle = 'Pixel value (DN)'
                     
                     region = (*sState.pImage)[(*sState.pActiveRegion)]
                     dz = MAX(region) - MIN(region)
                     IF dz EQ 0 THEN BEGIN
                        mview_wmessage, sState, 'Region is single valued.'
                     ENDIF ELSE BEGIN
                        IF dz GT 3 THEN binsize = 1 $
                        ELSE binsize = ((sState.max - sState.min) > 1)/10
                        hist_y = $
                         HISTOGRAM(region, OMIN=o_min, OMAX=o_max, $
                                    BINSIZE=binsize)

                        hist_x = LINDGEN(LONG((o_max-o_min+1)/binsize)) $
                         * binsize + o_min

                        PPLOT, hist_x, hist_y, $
                         TITLE = strTitle, PSYM = 10, SUBTITLE = strSubtitle, $
                         XTITLE = strXTitle, YTITLE = strYTitle
                        mview_wmessage, sState, ' '
                     ENDELSE 
                  ENDIF ELSE BEGIN
                     mview_wmessage, sState, 'Active region too small.'
                  ENDELSE 
               ENDIF ELSE BEGIN
                  mview_wmessage, sState, 'No active region defined.'
               ENDELSE 
            END 

            'Analysis.Radial plot': BEGIN
               strMessage = 'Click on center pixel'
               mview_wmessage, sState, strMessage

               save_win = !D.WINDOW
               IF win_valid(sState.draw_win) THEN $
                WSET, sState.draw_win $
               ELSE MESSAGE, 'Invalid window selection.'

               wait_for_click, sState.wDraw, xcenter, ycenter
               strMessage = 'computing radial plot...'
               mview_wmessage, sState, strMessage

               n_frame = sState.current_frame
               radialv = azimuthal_avg((*sState.pImage)[*,*,n_frame], $
                                        xcenter, ycenter)

               strTitle = 'Mview Radial plot'
               ;;WINDOW, /FREE, XSIZE=512, YSIZE=256, TITLE = strTitle
               pplot, radialv, PSYM = 10, XTITLE = 'Radius (pixels)', $
                YTITLE = 'Azimuthal average', WTITLE = strTitle, $
                GROUP = sState.wRoot, /YLOG, XSTYLE=1

               IF win_valid(save_win) THEN WSET, save_win

               strMessage = ' '
               mview_wmessage, sState, strMessage
               
            END 
            
            'Help.About': mview_show_about, sState

            'Help.Help': mview_show_help, sState
            
            ELSE:

         ENDCASE 

      END


      'ORIG_DRAW': BEGIN
         CASE sEvent.type OF

            0: BEGIN
                    ; BUTTON PRESS

               CASE sEvent.press OF
                  
                  2: BEGIN
                    ; BUTTON 2 PRESS
                     sState.button_down = sState.button_down + 2b
                     
                     mview_pan_display, sState, sEvent.x, sEvent.y
                     
                  END

                  1: BEGIN
                     sState.button_down = sState.button_down + 1b
                     IF sState.sPrefs.setup.keep_roi GE 1 THEN keep_roi=1 $
                     ELSE keep_roi=0

                     ox = sState.x_orig_sz
                     oy = sState.y_orig_sz
                     
                     IF (sEvent.x LT ox) AND (sEvent.y LT oy) THEN BEGIN
                        ix = sState.x_image_sz
                        iy = sState.y_image_sz
                     
                        xfactor = ix / FLOAT(ox)
                        yfactor = iy / FLOAT(oy)
                        x0 = sEvent.x
                        y0 = sEvent.y
                        limit_region = [ 0L, 0L, $
                                         sState.x_orig_sz, sState.y_orig_sz ]

                        sState.button_down = sState.button_down - 1b
                        corners = x_select_box(sState.wOrigDraw, /CORNERS, $
                                                x0, y0, KEEP=keep_roi, $
                                                LIMIT_REGION=limit_region, $
                                                STATUS=error_flag)
                        IF error_flag EQ 0 THEN BEGIN
                           IF N_ELEMENTS(corners) EQ 4 THEN BEGIN
                              x0 = corners[0] * xfactor
                              x1 = corners[2] * xfactor
                              y0 = corners[1] * yfactor
                              y1 = corners[3] * yfactor
                              x_corners = [x0, x0, x1, x1 ]
                              y_corners = [y0, y1, y1, y0 ]
                        
                              subscripts = POLYFILLV(x_corners, y_corners, $
                                                      ix, iy)
                     
                    ; draw on main window
                              IF keep_roi THEN x_draw_box, sState.wDraw, $
                               x0, y0, x1, y1
                              mview_define_region, sState, REGION=subscripts
                           ENDIF ELSE BEGIN
                              mview_wmessage, sState, $
                               'Not enough points.'
                           ENDELSE
                        ENDIF 
                     ENDIF ELSE BEGIN
                        mview_wmessage, sState, 'Point is outside image area.'
                     ENDELSE
                  END
                  4: sState.button_down = sState.button_down + 4b
                  ELSE:
               ENDCASE 
            END

            1: BEGIN
                    ; BUTTON RELEASE
               
               CASE sEvent.release OF
                  1: sState.button_down = BYTE((sState.button_down - 1) > 0)
                  2: sState.button_down = BYTE((sState.button_down - 2) > 0)
                  4: sState.button_down = BYTE((sState.button_down - 4) > 0)
                  ELSE:
               ENDCASE

            END

            2: BEGIN
                    ; MOTION

               IF (sState.button_down AND 2b) GE 1 THEN BEGIN
                  mview_pan_display, sState, sEvent.x, sEvent.y
               ENDIF
               IF (sState.button_down AND 1b) GE 1 THEN BEGIN
               ENDIF
            END

            ELSE:
         ENDCASE

      END
      
      'ZOOM_DRAW': BEGIN
         IF (sEvent.type EQ 0) OR (sEvent.press EQ 1) THEN BEGIN
                    ; if there is a button 1 press
            xpos=sEvent.x
            ypos=sEvent.y
            IF sEvent.clicks EQ 2 THEN BEGIN 

               IF sState.x NE -1 THEN x = sState.x $
               ELSE x = sState.x_image_sz/2
               IF sState.y NE -1 THEN y = sState.y $
               ELSE y = sState.y_image_sz/2

               zoom_image = mview_get_zoom_image(sState, x, y)

               strMessage = 'opening region in new viewer...'
               mview_wmessage, sState, strMessage
               CASE STRUPCASE(sState.scale_type) OF
                  'LOG': log_type = 1b
                  'SQRT': sqrt_type = 1b
                  'HIST_EQ': hist_type = 1b
                  'LINEAR': linear_type = 1b
                  'RAW': raw_type = 1b
                  ELSE: 
               ENDCASE
               mview, zoom_image, $
                /NO_COPY, $
                LOG = log_type, SQRT = sqrt_type, $
                HIST = hist_type, LINEAR = linear_type, $
                RAW = raw_type
               mview_wmessage, sState, 'launched new viewer.'
            END 

         ENDIF ELSE IF (sEvent.type EQ 2) THEN BEGIN
            zoom_factor = sState.zoom_factor
            IF zoom_factor EQ 0 THEN zoom_factor = 1
            IF zoom_factor LT 0 THEN zoom_factor = 1 / ABS(FLOAT(zoom_factor))
            x = sState.zoom_xcor + (sEvent.x / zoom_factor)
            y = sState.zoom_ycor + (sEvent.y / zoom_factor)
            mview_update_pixel, sState, x, y
         ENDIF 

      END 

      'ZOOM_SLIDER': BEGIN
         IF sEvent.value LT 0 THEN $
          zoom_percentage = 100 / FLOAT(ABS(sEvent.value))$
         ELSE IF sEvent.value EQ 0 THEN zoom_percentage=100 $
         ELSE zoom_percentage = 100 * sEvent.value
         strMessage = STRING(FORMAT='("zoom ",I0,"%")', zoom_percentage)
         mview_wmessage, sState, strMessage
         IF sEvent.drag NE 1 THEN BEGIN
            sState.zoom_factor = sEvent.value
                    ; update window
            mview_draw_zoom, sState, sState.lastx, sState.lasty
         ENDIF 
      END 

      'CBAR_DRAW': BEGIN

         CASE sEvent.type OF

            0: BEGIN
                    ; BUTTON PRESS

               CASE sEvent.press OF
                  
                  1: BEGIN
                    ; BUTTON 1 PRESS
                     sState.button_down = sState.button_down + 1b

                     bar_sz = SIZE(sState.colorbar)
                     x = sEvent.x > 0 < bar_sz[1]
                     y = sEvent.y > 0 < bar_sz[2]
                     minval = sState.colorbar[x,y]
                     mview_set_z1_value, sState, minval
                     
;                     IF sState.sPrefs.setup.color_scale EQ 0 THEN $
;                      mview_refresh_display, sState, /ALL
                  END

                  2: BEGIN
                    ; BUTTON 2 PRESS
                     sState.button_down = sState.button_down + 2b
                  END 
                  4: BEGIN
                    ; BUTTON 3 PRESS
                     sState.button_down = sState.button_down + 4b

                     bar_sz = SIZE(sState.colorbar)
                     x = sEvent.x > 0 < bar_sz[1]
                     y = sEvent.y > 0 < bar_sz[2]
                     maxval = sState.colorbar[x,y]
                     mview_set_z2_value, sState, maxval

;                     IF sState.sPrefs.setup.color_scale EQ 0 THEN $
;                      mview_refresh_display, sState, /ALL
                  END 
                  ELSE:
               ENDCASE 
            END

            1: BEGIN
                    ; BUTTON RELEASE
               
               CASE sEvent.release OF
                  1: BEGIN
                     sState.button_down = (sState.button_down - 1b) > 0
                     
                     IF sState.sPrefs.setup.color_scale EQ 0 THEN $
                      mview_refresh_display, sState, /ALL, DEBUG=debug
                  END
                  2: BEGIN
                     sState.button_down = (sState.button_down - 2b) > 0
                     
                     IF sState.sPrefs.setup.color_scale EQ 0 THEN $
                      mview_refresh_display, sState, /ALL, DEBUG=debug
                  END
                  4: BEGIN
                     sState.button_down = (sState.button_down - 4b) > 0
                     
                     IF sState.sPrefs.setup.color_scale EQ 0 THEN $
                      mview_refresh_display, sState, /ALL, DEBUG=debug
                  END
                  ELSE:
               ENDCASE

            END

            2: BEGIN
                    ; MOTION

               IF (sState.button_down AND 1b) GE 1 THEN BEGIN

                  bar_sz = SIZE(sState.colorbar)
                  x = sEvent.x > 0 < (bar_sz[1]-1)
                  y = sEvent.y > 0 < (bar_sz[2]-1)
                  minval = sState.colorbar[ x, y ]

                  mview_set_z1_value, sState, minval

               ENDIF ELSE IF (sState.button_down AND 4b) GE 1 THEN BEGIN

                  bar_sz = SIZE(sState.colorbar)
                  x = sEvent.x > 0 < (bar_sz[1]-1)
                  y = sEvent.y > 0 < (bar_sz[2]-1)
                  maxval = sState.colorbar[ x, y ]

                  mview_set_z2_value, sState, maxval

               ENDIF
            END

            ELSE:

         ENDCASE

      END

      'MIN_SLIDER': BEGIN

         n_frame = sState.current_frame

         factor = sEvent.value / DOUBLE(sState.slider_resolution)
         steps = ABS((sState.frame_max - sState.frame_min) * factor)
         minval = sState.frame_min + steps

         mview_set_z1_value, sState, minval, DEBUG=0

         IF sEvent.drag NE 1 THEN BEGIN

            IF sState.sPrefs.setup.color_scale EQ 0 THEN $
             mview_refresh_display, sState, /ALL, DEBUG=debug

            WIDGET_CONTROL, sState.wBase, /CLEAR_EVENTS
         ENDIF 
      END 
      
      'Z1_FIELD': BEGIN

         minval = sEvent.value
         WIDGET_CONTROL, sState.wZ2Field, GET_VALUE = maxval

         mview_set_z1_value, sState, minval, /NOCHECK
         mview_set_z2_value, sState, maxval, /NOCHECK

         IF sState.sPrefs.setup.color_scale EQ 0 THEN $
          mview_refresh_display, sState, /ALL, DEBUG=debug

      END 

      'MAX_SLIDER': BEGIN
         n_frame = sState.current_frame

         factor = sEvent.value / DOUBLE(sState.slider_resolution)
         steps = ABS((sState.frame_max - sState.frame_min) * factor)
         maxval = sState.frame_min + steps

         mview_set_z2_value, sState, maxval, DEBUG=0

         IF sEvent.drag NE 1 THEN BEGIN
            
            IF sState.sPrefs.setup.color_scale EQ 0 THEN $
             mview_refresh_display, sState, /ALL, DEBUG=debug

            WIDGET_CONTROL, sState.wBase, /CLEAR_EVENTS
         ENDIF
      END 
      
      'Z2_FIELD': BEGIN
         maxval = sEvent.value
         WIDGET_CONTROL, sState.wZ1Field, GET_VALUE = minval

         mview_set_z2_value, sState, maxval, /NOCHECK
         mview_set_z1_value, sState, minval, /NOCHECK

         IF sState.sPrefs.setup.color_scale EQ 0 THEN $
          mview_refresh_display, sState, /ALL, DEBUG=debug

      END

      'NEW_PREFS': BEGIN
         
         IF N_TAGS(sEvent.value) GT 0 THEN BEGIN
            sPrefs = sEvent.value

            IF N_TAGS(sPrefs) GE 2 THEN BEGIN
               state_prefs = sState.sPrefs

               STRUCT_ASSIGN, sPrefs, state_prefs, /NOZERO
               sState.sPrefs = TEMPORARY(state_prefs)

               strMessage = 'preferences updated, a refresh may be required.'
               mview_wmessage, sState, strMessage

                    ; Since the DEFROI option may have changed.
               PTR_FREE, sState.pActiveRegion
               sState.pActiveRegion = PTR_NEW()
               
               ;;mview_refresh_display, sState, /ALL
            ENDIF

         ENDIF
      END 

      'MVIEW_LOAD': BEGIN
         error_flag = 0b
         image_sz = SIZE(sEvent.value)
         mview_wmessage, sState, 'loading new data...'
         WIDGET_CONTROL, /HOURGLASS
         CASE sEvent.type OF
            1: BEGIN
                    ; This is an ACS_LOG entry number array or scalar
               mview_acslog_read, sState, sEvent.value, data, $
                header, header_udl, header_eng1, header_eng2, $
                ERROR=error_flag
               labels = 'Entry ' + STRTRIM(sEvent.value, 2)
            END

            ELSE: BEGIN
               IF (image_sz[0] GE 2) THEN BEGIN
                  
                  IF (N_ELEMENTS(sEvent.label) GT 0) AND $
                   sEvent.label[0] NE '' THEN labels=sEvent.label

                  IF (N_ELEMENTS(sEvent.header) GT 0) AND $
                   sEvent.header[0] NE '' THEN header = sEvent.header

                  data = TEMPORARY(sEvent.value)
                  WIDGET_CONTROL, sState.wRoot, /CLEAR_EVENTS
                  
               ENDIF
            END
         ENDCASE

         IF error_flag NE 1 THEN BEGIN
            mview_update_all, sState, data, HEADER_STD=header, $
             HEADER_UDL=header_udl, HEADER_ENG1=header_eng1, $
             HEADER_ENG2=header_eng2, LABELS=labels
            image_sz = SIZE(data)
            strMessage = $
             STRING(FORMAT='("Read ",' + STRTRIM(image_sz[0]-1, 2) + $
                     '(I0," x "),I0," array")', $
                     image_sz[1:image_sz[0]])
            mview_wmessage, sState, strMessage
         ENDIF
      END

      ELSE: PRINTF, -2, 'UVALUE case not found: '+STRUPCASE(event_uval)

   ENDCASE

   ;;WIDGET_CONTROL, sState.wRoot, /CLEAR_EVENTS 

   IF WIDGET_INFO(wStateHandler, /VALID_ID) EQ 1 THEN BEGIN
                    ; restore state information
      WIDGET_CONTROL, wStateHandler, SET_UVALUE=sState, /NO_COPY
   ENDIF 


END

; _____________________________________________________________________________


PRO mview_show_about_event, sEvent
   COMPILE_OPT IDL2, HIDDEN

   WIDGET_CONTROL, sEvent.id, GET_UVALUE=event_uval
   
   CASE event_uval OF

      'OK_BUTTON': BEGIN
         IF WIDGET_INFO(sEvent.top, /VALID_ID) THEN $
          WIDGET_CONTROL, sEvent.top, /DESTROY
      END 

      ELSE: BEGIN
         IF WIDGET_INFO(sEvent.top, /VALID_ID) THEN $
          WIDGET_CONTROL, sEvent.top, /DESTROY
      END

   ENDCASE

END

PRO mview_show_about, sState
   COMPILE_OPT IDL2, HIDDEN

   version = sState.version
   version_date = sState.version_date

   wintitle =  STRING(FORMAT='("About Mview (v",A,")")', version)

   message = [ STRING(FORMAT='("Mview version",1X,A)', version), $
               'written by: William Jon McCann', $
               '© The Johns Hopkins University', $
               'Advanced Camera for Surveys', $
               version_date ]

   wBase = WIDGET_BASE(TITLE=wintitle, GROUP=sState.wRoot, /COLUMN)

   wLabels = LONARR(N_ELEMENTS(message))

   wLabels[0] = WIDGET_LABEL(wBase, VALUE=message[0], $
                              FONT='helvetica*20', /ALIGN_CENTER)
   FOR i = 1, N_ELEMENTS(message) - 1 DO BEGIN
      wLabels[i] = WIDGET_LABEL(wBase, VALUE=message[i], $
                           FONT='helvetica', /ALIGN_CENTER)
   ENDFOR

   wButton = WIDGET_BUTTON(wBase, VALUE='OK', /ALIGN_CENTER, $
                          UVALUE='OK_BUTTON')

   WIDGET_CONTROL, wBase, /REALIZE

   XMANAGER, 'mview_show_about', wBase, /NO_BLOCK

END

; _____________________________________________________________________________

PRO mview_show_help_event, sEvent
   COMPILE_OPT IDL2, HIDDEN

   WIDGET_CONTROL, sEvent.id, GET_UVALUE = event_uval
   
   CASE event_uval OF

      'OK_BUTTON': BEGIN
         IF WIDGET_INFO(sEvent.top, /VALID_ID) THEN $
          WIDGET_CONTROL, sEvent.top, /DESTROY
      END 

      ELSE: BEGIN
         IF WIDGET_INFO(sEvent.top, /VALID_ID) THEN $
          WIDGET_CONTROL, sEvent.top, /DESTROY
      END

   ENDCASE

END

PRO mview_show_help, sState
   COMPILE_OPT IDL2, HIDDEN

   version = sState.version
   version_date = sState.version_date

   wintitle =  STRING(FORMAT='("Mview Help (v",A,")")', version)

   message=[STRING(FORMAT='("Mview version",1X,A)', version), $
            'Define mouse button actions using the Options/Preferences menu.',$
            'To change zoom scale, move vertical slider next to zoom window.',$
            'To change display range, move horizontal sliders below colorbar.']
   
   wBase = WIDGET_BASE(TITLE=wintitle, GROUP=sState.wRoot, /COLUMN)

   wLabels = LONARR(N_ELEMENTS(message))

   wLabels[0] = WIDGET_LABEL(wBase, VALUE=message[0], $
                        FONT='helvetica*20', /ALIGN_CENTER)
   FOR i = 1, N_ELEMENTS(message) - 1 DO BEGIN
      wLabels[i] = WIDGET_LABEL(wBase, VALUE = message[i], $
                           FONT='helvetica', /ALIGN_CENTER)
   ENDFOR

   wButton = WIDGET_BUTTON(wBase, VALUE='OK', /ALIGN_CENTER, $
                          UVALUE='OK_BUTTON')

   WIDGET_CONTROL, wBase, /REALIZE

   XMANAGER, 'mview_show_help', wBase, /NO_BLOCK

END 

; _____________________________________________________________________________

PRO set_color_scale, min, max, GAMMA=gamma, CLIP=clip, TOP=top
   COMPILE_OPT IDL2, HIDDEN
   COMMON colors, r_orig, g_orig, b_orig, r_curr, g_curr, b_curr

   IF N_ELEMENTS(r_orig) LE 0 THEN BEGIN
      TVLCT, r_orig, g_orig, b_orig, /GET
      r_curr = r_orig
      b_curr = b_orig
      g_curr = g_orig
   ENDIF

   n_colors = !D.N_COLORS

   IF N_ELEMENTS(top) GT 0 THEN scale = (n_colors-1) / top $
   ELSE scale = 1.0

   x0 = min * scale
   x1 = max * scale

   IF x0 NE x1 THEN scale = (n_colors - 1.0) / (x1 - x0) ELSE scale = 1.0
   int = -1 * scale * x0

   IF N_ELEMENTS(gamma) GT 0 THEN BEGIN
      IF gamma EQ 1.0 THEN $
       scale = ROUND((FINDGEN(n_colors) * scale + int) > 0.0) $
      ELSE $
       scale = ((FINDGEN(n_colors) * (scale / n_colors) + $
                  (int / n_colors) > 0.0) ^ gamma) * n_colors
   ENDIF ELSE scale = ROUND((FINDGEN(n_colors) * scale + int) > 0.0)

   IF KEYWORD_SET(clip) THEN BEGIN
      too_high = WHERE(scale GE n_colors, ctoo_high)
      IF ctoo_high GT 0 THEN scale[ too_high ] = 0L
   ENDIF

   IF N_ELEMENTS(cbot) LE 0 THEN cbot = 0L
   r_curr[cbot] = (r = r_orig[scale])
   g_curr[cbot] = (g = g_orig[scale])
   b_curr[cbot] = (b = b_orig[scale])
   
   TVLCT, r, g, b, cbot

END

; _____________________________________________________________________________

PRO mview_image_filter, sState, type
   COMPILE_OPT IDL2, HIDDEN

   image_sz = SIZE((*sState.pImage))

   IF image_sz[0] EQ 2 THEN BEGIN

      strMessage = 'computing ' + type + ' filter...'
      mview_wmessage, sState, strMessage
      CASE STRUPCASE(type) OF
         'MEDIAN': BEGIN
            median_width = sState.sPrefs.filter.median_size
            rdata = MEDIAN((*sState.pImage)[*,*,0], median_width)
         END
         'SMOOTH': BEGIN
            smooth_width = sState.sPrefs.filter.smooth_size
            rdata = SMOOTH((*sState.pImage)[*,*,0], smooth_width, $
                            /EDGE_TRUNCATE, /NAN)
         END 
         'LEE': BEGIN
            lee_width = sState.sPrefs.filter.lee_size
            lee_sigma = sState.sPrefs.filter.lee_sigma
            rdata = LEEFILT((*sState.pImage)[*,*,0], $
                             lee_width, lee_sigma)
         END
         'SOBEL': BEGIN
            rdata = SOBEL((*sState.pImage)[*,*,0])
         END
         'ROBERTS': BEGIN
            rdata = ROBERTS((*sState.pImage)[*,*,0])
         END
         ELSE: 
      ENDCASE 

      WIDGET_CONTROL, sState.wRoot, /CLEAR_EVENTS

      IF (MIN(rdata) EQ MAX(rdata)) THEN BEGIN
         strMessage = type + ' filter failed.'
         mview_wmessage, sState, strMessage
         return
      ENDIF 
      
      strMessage = 'updating state...'
      mview_wmessage, sState, strMessage
      
      mview_update_state, sState, rdata, /KEEP_HEADERS
      
      mview_update_widget, sState, DEBUG=debug
      
      strMessage = type + ' complete.'
      mview_wmessage, sState, strMessage

   ENDIF ELSE mview_wmessage, sState, $
    'Only 2D arrays supported for this operation'

END 

; _____________________________________________________________________________

PRO mview_image_operations, sState, type, subtype
   COMPILE_OPT IDL2, HIDDEN

   image_sz = SIZE((*sState.pImage))

   IF image_sz[0] EQ 2 THEN BEGIN

      strMessage = 'computing ' + type + ' of image...'
      mview_wmessage, sState, strMessage
      CASE STRUPCASE(type) OF

         'SQRT': BEGIN
            rdata = SQRT(FLOAT((*sState.pImage)[*,*,0]) > 1e-6)
         END

         'REBIN': BEGIN

            strMessage = 'input rebin factor...'
            mview_wmessage, sState, strMessage

            input_title = 'Input REBIN factor'
            input_label = 'Bin factor:'
            value = 2
            factor = x_get_input(STATUS = status, TITLE=input_title, $
                                LABEL=input_label, /FLOAT, $
                                VALUE=value, GROUP=sState.wRoot)

            IF status NE 0 THEN BEGIN
               mview_wmessage, sState, 'rebin cancelled'
               return
            ENDIF

            IF (factor GT 0) THEN BEGIN
               image_sz = SIZE((*sState.pImage))
               
               num_x = image_sz[1] / FLOAT(factor)
               num_y = image_sz[2] / FLOAT(factor)
               
               strMessage = 'rebinning image...'
               mview_wmessage, sState, strMessage
                     
               rdata = FREBIN((*sState.pImage)[*,*,0], num_x, num_y)
            ENDIF ELSE BEGIN
               strMessage = 'rebin factor must be greater than zero, dopey.'
               mview_wmessage, sState, strMessage
               return
            ENDELSE

         END
         
         'SQUARE': BEGIN
            rdata = (FLOAT((*sState.pImage)[*,*,0])) ^ 2.0
         END

         'ALOG': BEGIN
            rdata = ALOG(FLOAT((*sState.pImage)[*,*,0]) > 1e-6)
         END

         'ALOG10': BEGIN
            rdata = ALOG10(FLOAT((*sState.pImage)[*,*,0]) > 1e-6)
         END

         'SUBTRACT_CONSTANT': BEGIN

            strMessage = 'input subtract constant...'
            mview_wmessage, sState, strMessage

            input_title = 'Input constant to subtract from image'
            input_label = 'Constant:'
            value = 2
            constant = x_get_input(STATUS = status, TITLE=input_title, $
                                    LABEL=input_label, /FLOAT, $
                                    VALUE=value, GROUP=sState.wRoot)

            IF status NE 0 THEN BEGIN
               mview_wmessage, sState, 'subtract cancelled'
               return
            ENDIF

            strMessage = 'subtracting constant from image...'
            mview_wmessage, sState, strMessage
            rdata = (*sState.pImage)[*,*,0] - constant
         END

         'SUBTRACT_IMAGE': BEGIN
            IF subtype EQ 'ACS_LOG' THEN BEGIN
               input_title = 'Input ACS_LOG entry number'
               input_label = 'Entry number: '
               
               IF PTR_VALID(sState.pHeader) THEN BEGIN
                  IF N_ELEMENTS(*sState.pHeader) GT 1 THEN BEGIN
                     value = SXPAR((*sState.pHeader)[*,0], 'ENTRY')
                  ENDIF
               ENDIF
               entry_number = x_get_input(STATUS = status, $
                                           TITLE=input_title, $
                                           LABEL=input_label, /LONG, $
                                           VALUE=value, GROUP=sState.wRoot)
               IF status EQ 1 THEN BEGIN
                  mview_acslog_read, sState, entry_number, second_image, $
                   second_header, ERROR=error_flag
               ENDIF ELSE BEGIN
                  strMessage = 'subtract image cancelled'
                  mview_wmessage, sState, strMessage
                  return
               ENDELSE

               IF error_flag EQ 1 THEN BEGIN
                  strMessage = 'subtract image cancelled'
                  mview_wmessage, sState, strMessage
                  return
               ENDIF

            ENDIF ELSE BEGIN
               strTitle = 'Select FITS image'
               filename = DIALOG_PICKFILE(TITLE = strTitle, /MUST_EXIST, $
                                           PATH = use_path, $
                                           GET_PATH = get_path)
               IF N_ELEMENTS(filename) EQ 1 THEN BEGIN
                  IF filename EQ '' THEN BEGIN
                     strMessage = 'subtract image cancelled'
                     mview_wmessage, sState, strMessage
                     return
                  ENDIF
               ENDIF

               second_image = READFITS(filename[0], second_header)
               IF N_ELEMENTS(second_image) LE 2 THEN $
                second_image = READFITS(filename[0], second_header, /EXTEN)
               
               IF N_ELEMENTS(second_image) LE 2 THEN BEGIN
                  strMessage = 'subtract image cancelled'
                  mview_wmessage, sState, strMessage
                  return
               ENDIF 

            ENDELSE
            
            image_size = SIZE((*sState.pImage)[*,*,0])
            image2_size = SIZE(second_image)
            IF (image2_size[1] NE image_size[1]) OR $
             (image2_size[2] NE image_size[2]) THEN BEGIN
               strMessage = 'images must be the same size'
               mview_wmessage, sState, strMessage
               return
            ENDIF 

            rdata = FLOAT((*sState.pImage)[*,*,0]) - $
             FLOAT(TEMPORARY(second_image))
         END 

         'DIVIDE_CONSTANT': BEGIN

            strMessage = 'input division constant...'
            mview_wmessage, sState, strMessage

            input_title = 'Input constant to divide from image'
            input_label = 'Constant:'
            value = 1
            constant = x_get_input(STATUS = status, TITLE=input_title, $
                                    LABEL=input_label, /FLOAT, $
                                    VALUE=value, GROUP=sState.wRoot)

            IF status NE 0 THEN BEGIN
               mview_wmessage, sState, 'divide cancelled'
               return
            ENDIF

            IF constant EQ 0 THEN BEGIN
               strMessage = 'constant may not be zero.'
               mview_wmessage, sState, strMessage
               return
            ENDIF

            strMessage = 'dividing constant from image...'
            mview_wmessage, sState, strMessage
            rdata = (*sState.pImage)[*,*,0] / FLOAT(constant)
         END

         'DIVIDE_IMAGE': BEGIN
            IF subtype EQ 'ACS_LOG' THEN BEGIN
               input_title = 'Input ACS_LOG entry number'
               input_label = 'Entry number: '
               
               IF PTR_VALID(sState.pHeader) THEN BEGIN
                  IF N_ELEMENTS(*sState.pHeader) GT 1 THEN BEGIN
                     value = SXPAR((*sState.pHeader)[*,0], 'ENTRY')
                  ENDIF
               ENDIF
               entry_number = x_get_input(STATUS = status, $
                                           TITLE=input_title, $
                                           LABEL=input_label, /LONG, $
                                           VALUE=value, GROUP=sState.wRoot)
               IF status EQ 0 THEN BEGIN
                  mview_acslog_read, sState, entry_number, second_image, $
                   second_header, ERROR=error_flag
               ENDIF ELSE BEGIN
                  strMessage = 'image division cancelled'
                  mview_wmessage, sState, strMessage
                  return
               ENDELSE

               IF error_flag EQ 1 THEN BEGIN
                  strMessage = 'image division cancelled'
                  mview_wmessage, sState, strMessage
                  return
               ENDIF

            ENDIF ELSE BEGIN
               strTitle = 'Select FITS image'
               filename = DIALOG_PICKFILE(TITLE=strTitle, /MUST_EXIST, $
                                           PATH=use_path, $
                                           GET_PATH=get_path)
               IF N_ELEMENTS(filename) EQ 1 THEN BEGIN
                  IF filename EQ '' THEN BEGIN
                     strMessage = 'image division cancelled'
                     mview_wmessage, sState, strMessage
                     return
                  ENDIF
               ENDIF

               second_image = READFITS(filename[0], second_header)
               IF N_ELEMENTS(second_image) LE 2 THEN $
                second_image = READFITS(filename[0], second_header, /EXTEN)
               
               IF N_ELEMENTS(second_image) LE 2 THEN BEGIN
                  strMessage = 'image division cancelled'
                  mview_wmessage, sState, strMessage
                  return
               ENDIF 

            ENDELSE
            
            image_size = SIZE((*sState.pImage)[*,*,0])
            image2_size = SIZE(second_image)
            IF (image2_size[1] NE image_size[1]) OR $
             (image2_size[2] NE image_size[2]) THEN BEGIN
               strMessage = 'images must be the same size'
               mview_wmessage, sState, strMessage
               return
            ENDIF 

            rdata = FLOAT((*sState.pImage)[*,*,0]) / $
             FLOAT(TEMPORARY(second_image))

         END 

         'COMPLEMENT': BEGIN
            rdata = (*sState.pImage)[*,*,*] + $
             (((*sState.pImage)[*,*,*]) LT 0) * 65536.0
         END
            
         ELSE:

      ENDCASE

      WIDGET_CONTROL, sState.wRoot, /CLEAR_EVENTS
      
      strMessage = 'updating state...'
      mview_wmessage, sState, strMessage
      
      mview_update_state, sState, rdata, /KEEP_HEADERS
      
      mview_update_widget, sState, DEBUG=debug
      
      strMessage = type + ' complete.'
      mview_wmessage, sState, strMessage

   ENDIF ELSE mview_wmessage, sState, $
    'Only 2D arrays supported for this operation'

END 

; _____________________________________________________________________________

PRO mview_set_z1_value, sState, minval, NOCHECK=nocheck, DEBUG=debug
   COMPILE_OPT IDL2, HIDDEN

   IF (minval LE sState.max) OR (KEYWORD_SET(nocheck)) THEN $
    sState.min = minval $
   ELSE sState.min = sState.max

   value_range = DOUBLE(sState.frame_max - sState.frame_min) > 1e-4
   slider_factor = sState.slider_resolution / value_range
   color_factor = !D.N_COLORS / value_range

   slider_bot = FIX(slider_factor * (sState.min-sState.frame_min)) > 0
   slider_top = FIX(slider_factor * (sState.max-sState.frame_min)) > 0
   color_bot = FIX(color_factor * (sState.min-sState.frame_min)) > 0
   color_top = FIX(color_factor * (sState.max-sState.frame_min)) > 0

   IF KEYWORD_SET(debug) THEN $
    HELP, slider_bot, slider_top, value_range, slider_factor

   WIDGET_CONTROL, sState.wMinSlider, SET_VALUE = slider_bot

   IF sState.sPrefs.setup.color_scale EQ 1 THEN BEGIN

      mview_wmessage, sState, 'changing color tables...'
      STRETCH, color_bot, color_top
      ;;set_color_scale, color_bot, color_top
      mview_wmessage, sState, ' '
   ENDIF

   WIDGET_CONTROL, sState.wZ1Field, SET_VALUE=STRTRIM(sState.min[0], 2)

END

; _____________________________________________________________________________


PRO mview_set_z2_value, sState, maxval, NOCHECK=nocheck, DEBUG=debug
   COMPILE_OPT IDL2, HIDDEN

   IF (maxval GT sState.min) OR (KEYWORD_SET(nocheck)) THEN $
    sState.max = maxval $
   ELSE sState.max = sState.min

   value_range = DOUBLE(sState.frame_max - sState.frame_min) > 1e-4
   slider_factor = sState.slider_resolution / value_range
   color_factor = !D.N_COLORS / value_range

   slider_bot = FIX(slider_factor * (sState.min-sState.frame_min)) > 0
   slider_top = FIX(slider_factor * (sState.max-sState.frame_min)) > 0
   color_bot = FIX(color_factor * (sState.min-sState.frame_min)) > 0
   color_top = FIX(color_factor * (sState.max-sState.frame_min)) > 0

   IF KEYWORD_SET(debug) THEN $
    HELP, slider_bot, slider_top, value_range, slider_factor

   WIDGET_CONTROL, sState.wMaxSlider, SET_VALUE = slider_top

   IF sState.sPrefs.setup.color_scale EQ 1 THEN BEGIN
      mview_wmessage, sState, 'changing color tables...'
      STRETCH, color_bot, color_top
      ;;set_color_scale, color_bot, color_top
      mview_wmessage, sState, ' '
   ENDIF

   WIDGET_CONTROL, sState.wZ2Field, SET_VALUE = sState.max

END

; _____________________________________________________________________________


PRO mview_pan_display, sState, xpos, ypos
   COMPILE_OPT IDL2, HIDDEN

   ix = sState.x_image_sz
   iy = sState.y_image_sz
   large_size = ix > iy
   max_size = sState.x_orig_sz < sState.y_orig_sz
   scale_factor = (large_size / FLOAT(max_size)) > 1
   ox = LONG(ix / scale_factor)
   oy = LONG(iy / scale_factor)

   x = xpos > 0 < (ox-1)
   y = ypos > 0 < (oy-1)

   xfactor = ix / FLOAT(ox)
   yfactor = iy / FLOAT(oy)

   xview_width = sState.x_draw_sz / 2
   yview_width = sState.y_draw_sz / 2

   corner = [ (x * xfactor) - xview_width, $
              (y * yfactor) - yview_width ] > 0

   WIDGET_CONTROL, sState.wDraw, SET_DRAW_VIEW=corner

END 

; _____________________________________________________________________________


PRO mview_autoscale_display, sState, DEBUG=debug
   COMPILE_OPT IDL2, HIDDEN

   IF (sState.sPrefs.setup.keep_roi GE 1) AND $
    (PTR_VALID(sState.pActiveRegion)) THEN BEGIN

      mview_wmessage, sState, 'calculating statistics of active region...'

      subscripts = (*sState.pActiveRegion)

      moments = mview_get_stats(sState, subscripts, $
                                STAT_STRUCT=sStats)
      
   ENDIF ELSE BEGIN

      IF (sState.sStats.stdev EQ -1) THEN BEGIN
         mview_wmessage, sState, 'calculating statistics of image...'
      
         n_frame = sState.current_frame
         n_pixels = N_ELEMENTS((*sState.pImage)[*,*,n_frame])
         IF n_pixels GT 1.2e6 THEN n_subs = 1.2e6

         mview_update_stats, sState, RANDOM=n_subs, STAT_STRUCT=sStats, $
          DEBUG=debug

      ENDIF
      moments = sState.sStats.moment
      sStats = sState.sStats

   ENDELSE

   sigma = SQRT(moments[1])

   mview_wmessage, sState, 'setting new scale values...'

   mview_set_z1_value, sState, (sStats.median - 2 * sigma) > sStats.min, $
    /NOCHECK
   mview_set_z2_value, sState, (sStats.median + 2 * sigma) < sStats.max, $
    /NOCHECK

   mview_wmessage, sState, 'updating display...'
   
   mview_put_stats, sState, sStats
   
   IF sState.sPrefs.setup.color_scale EQ 0 THEN BEGIN
                    ; Update sliders
      mview_set_z1_value, sState, sState.min
      mview_set_z2_value, sState, sState.max

      mview_refresh_display, sState, /ALL, DEBUG=debug
   ENDIF 

   mview_wmessage, sState, ' '

END 

; _____________________________________________________________________________

PRO mview_refresh_display, sState, ALL=all, DEBUG=debug
   COMPILE_OPT IDL2, HIDDEN
   IF KEYWORD_SET(debug) THEN PRINTF, -2, '===> Entered mview_refresh_display'
   WIDGET_CONTROL, /HOURGLASS

   saved_device = !D.NAME
   CASE STRUPCASE(!VERSION.OS_FAMILY) OF
      'WINDOWS': SET_PLOT, 'WIN'
      'MACOS': SET_PLOT, 'MAC'
      ELSE: SET_PLOT, 'X'
   ENDCASE
   save_win = !D.WINDOW

   IF win_valid(sState.draw_win) THEN WSET, sState.draw_win $
   ELSE MESSAGE, 'Invalid window selection.'

   IF sState.scale_type EQ 'RAW' THEN BEGIN
      IF PTR_VALID(sState.pColorTableRed) THEN BEGIN
         mview_wmessage, sState, 'refreshing colors...'
         n_colors = !D.N_COLORS
         TVLCT, *sState.pColorTableRed, *sState.pColorTableGreen, $
          *sState.pColorTableBlue
      ENDIF 
   ENDIF ELSE BEGIN 
      mview_wmessage, sState, 'refreshing colors...'

      STRETCH
      IF sState.sPrefs.setup.color_scale EQ 1 THEN BEGIN
         color_factor = !D.N_COLORS / DOUBLE(sState.frame_max)
         
         color_bot = FIX(color_factor * sState.min)
         color_top = FIX(color_factor * sState.max)
         STRETCH, color_bot, color_top
      ENDIF
   ENDELSE

   mview_wmessage, sState, 'refreshing display...'

   IF sState.sPrefs.setup.color_scale EQ 0 THEN BEGIN
      min_val = sState.min
      max_val = sState.max
   ENDIF ELSE BEGIN
      min_val = sState.frame_min
      max_val = sState.frame_max
   ENDELSE

                    ; Calculate rebin factor
   n_frame = sState.current_frame
   image_sz = SIZE((*sState.pImage)[*, *, n_frame])
   x_rebin = image_sz[1] * sState.main_zoom_factor
   y_rebin = image_sz[2] * sState.main_zoom_factor
   IF KEYWORD_SET(debug) THEN PRINTF, -2, 'Rebinning image to ['+$
    STRTRIM(x_rebin,2)+','+STRTRIM(y_rebin,2)+']'

                    ; Update draw widget
   offset = 20
   WIDGET_CONTROL, sState.wDraw, $
    DRAW_XSIZE=x_rebin, $
    DRAW_YSIZE=y_rebin, XSIZE=sState.x_draw_sz-offset,$
    YSIZE=sState.y_draw_sz-offset

                    ; DISPLAY IMAGE
   mview_wmessage, sState, 'refreshing display (image)...'
   CASE STRUPCASE(sState.scale_type) OF

      'RAW': BEGIN
         IF KEYWORD_SET(all) THEN BEGIN
            image = (*sState.pImage)[*, *, n_frame]
            TV, CONGRID(image,x_rebin,y_rebin)
         ENDIF ELSE BEGIN
            TV, CONGRID((*sState.pImage)[*, *, n_frame],x_rebin,y_rebin)
         ENDELSE
      END

      'LINEAR': BEGIN
         IF KEYWORD_SET(all) THEN BEGIN
            image = (*sState.pImage)[*, *, n_frame]
                    ; clipping the image to the maxval to compensate
                    ; for an IDL bug.  Unfortunately may promote type
                    ; to floating point.
            TV, CONGRID(BYTSCL(image<max_val, $
                               MIN=min_val, MAX=max_val, $
                               TOP=!D.TABLE_SIZE-1),x_rebin,y_rebin), TRUE=sState.use_true_color
         ENDIF ELSE BEGIN
            TV, CONGRID(BYTSCL((*sState.pImage)[*, *, n_frame]<max_val, $
                               MIN=min_val, MAX=max_val, $
                               TOP=!D.TABLE_SIZE-1),x_rebin,y_rebin), TRUE=sState.use_true_color
         ENDELSE
      END

      'LOG': BEGIN
         tmin = max_val / 1e4
         IF KEYWORD_SET(all) THEN BEGIN
            image = ALOG10(((*sState.pImage)[*, *, n_frame]-min_val) > tmin)
            TV, CONGRID(BYTSCL(image, $
                       MIN=ALOG10(tmin), MAX=ALOG10(max_val - min_val),$
                       TOP=!D.N_COLORS-1),x_rebin,y_rebin)
         ENDIF ELSE BEGIN
            TV, CONGRID(BYTSCL(ALOG10(((*sState.pImage)[*, *, n_frame]-min_val)>tmin), $
                        MIN=ALOG10(tmin), MAX=ALOG10(max_val - min_val), $
                        TOP=!D.N_COLORS-1),x_rebin,y_rebin)
         ENDELSE
      END

      'SQRT': BEGIN
         IF KEYWORD_SET(all) THEN BEGIN
            image = SQRT(((*sState.pImage)[*, *, n_frame]-min_val) > 0)
            TV, CONGRID(BYTSCL(image, $
                        MIN=0, MAX=SQRT(max_val - min_val), $
                        TOP=!D.N_COLORS-1),x_rebin,y_rebin)
         ENDIF ELSE BEGIN
            TV, CONGRID(BYTSCL(SQRT(((*sState.pImage)[*, *, n_frame]-min_val)>0), $
                        MIN=0, MAX=SQRT(max_val - min_val), $
                        TOP=!D.N_COLORS-1),x_rebin,y_rebin)
         ENDELSE
      END

      'HIST_EQ': BEGIN
         IF KEYWORD_SET(all) THEN BEGIN
            image = CONGRID(HIST_EQUAL(FLOAT((*sState.pImage)[*, *, n_frame]), $
                                MINV=min_val, MAXV=max_val, $
                                TOP=!D.N_COLORS-1),x_rebin,y_rebin)
            TV, image
         ENDIF ELSE BEGIN
            TV, CONGRID(HIST_EQUAL(FLOAT((*sState.pImage)[*, *, n_frame]), $
                            MINV=min_val, MAXV=max_val, $
                            TOP=!D.N_COLORS-1),x_rebin,y_rebin)
         ENDELSE
      END

      ELSE:

   ENDCASE 

   sState.lastx = -1L
   sState.lasty = -1L

                    ; DISPLAY ORIGINAL IMAGE
   IF KEYWORD_SET(all) THEN BEGIN
      mview_draw_original, sState, image
   ENDIF

                    ; DISPLAY ZOOM IMAGE
   mview_wmessage, sState, 'refreshing display (zoom)...'

   IF sState.x NE -1 THEN xpos = sState.x ELSE xpos = sState.x_image_sz/2
   IF sState.y NE -1 THEN ypos = sState.y ELSE ypos = sState.y_image_sz/2
   mview_draw_zoom, sState, xpos, ypos

                    ; DISPLAY COLORBAR
   IF win_valid(sState.cbar_win) THEN WSET, sState.cbar_win $
   ELSE MESSAGE, 'Invalid window selection.'

   mview_wmessage, sState, 'refreshing display (colorbar)...'
   
   CASE STRUPCASE(sState.scale_type) OF

      'RAW': BEGIN
         TV, BYTSCL(sState.colorbar, MIN=min_val, MAX=max_val, $
                     TOP=!D.TABLE_SIZE-1), TRUE=use_true_color
      END 

      'LINEAR': BEGIN
         TV, BYTSCL(sState.colorbar, MIN=min_val, MAX=max_val, $
                     TOP=!D.TABLE_SIZE-1), TRUE=use_true_color
      END

      'LOG': BEGIN
         tmin = max_val / 1e4
         TV, BYTSCL(ALOG10((sState.colorbar-min_val)>tmin), $
                     MIN=ALOG10(tmin), MAX=ALOG10(max_val - min_val), $
                     TOP=!D.N_COLORS-1)
      END

      'SQRT': BEGIN
         TV, BYTSCL(SQRT((sState.colorbar-min_val)>0), $
                     MIN=0, MAX=SQRT(max_val - min_val), $
                     TOP=!D.N_COLORS-1)
      END

      'HIST_EQ': BEGIN
         TV, BYTSCL(sState.colorbar, MIN=min_val, MAX=max_val, $
                     TOP=!D.TABLE_SIZE-1), TRUE=use_true_color
      END

      ELSE: 

   ENDCASE

   IF win_valid(save_win) THEN WSET, save_win

   mview_wmessage, sState, ' '

   SET_PLOT, saved_device
   IF KEYWORD_SET(debug) THEN PRINTF, -2, '<=== Leaving mview_refresh_display'

   return
END 

; _____________________________________________________________________________

PRO mview_zoom_plus, sState
   offset = 0.25
   sState.main_zoom_factor = sState.main_zoom_factor + offset
   mview_refresh_display, sState
END

; _____________________________________________________________________________

PRO mview_zoom_zero, sState
   sState.main_zoom_factor = 1.0
   mview_refresh_display, sState
END
; _____________________________________________________________________________

PRO mview_zoom_minus, sState
   offset = 0.25
   sState.main_zoom_factor = sState.main_zoom_factor - offset
   mview_refresh_display, sState
END

; _____________________________________________________________________________


PRO mview_blink_images, sState, REVERSE=reverse
   COMPILE_OPT IDL2, HIDDEN

   save_win = !D.WINDOW
   saved_device = !D.NAME
   CASE STRUPCASE(!VERSION.OS_FAMILY) OF
      'WINDOWS': SET_PLOT, 'WIN'
      'MACOS': SET_PLOT, 'MAC'
      ELSE: SET_PLOT, 'X'
   ENDCASE

   IF win_valid(sState.draw_win) THEN WSET, sState.draw_win $
   ELSE MESSAGE, 'Invalid window selection.'

   IF PTR_VALID(sState.pImage) THEN BEGIN

      image_sz = SIZE(*sState.pImage)

      IF image_sz[0] EQ 3 THEN BEGIN

         number_frames = image_sz[3]

         IF PTR_VALID(sState.pLabels) THEN $
          number_labels = N_ELEMENTS(*sState.pLabels) $
         ELSE number_labels = 0
         
         IF KEYWORD_SET(reverse) THEN next_frame = sState.current_frame - 1 $
         ELSE next_frame = sState.current_frame + 1
         IF next_frame LT 0 THEN next_frame = number_frames + next_frame

         n_frame = next_frame MOD number_frames

         IF n_frame GT (number_labels-1) THEN $
          label = 'frame' + STRTRIM(n_frame[0] + 1, 2) $
         ELSE label = (*sState.pLabels)[n_frame]

         sState.current_frame = n_frame
         sState.frame_min = DOUBLE(MIN((*sState.pImage)[*,*,n_frame]))
         sState.frame_max = DOUBLE(MAX((*sState.pImage)[*,*,n_frame]))
         sState.lastx = -1L
         sState.lasty = -1L

         mview_refresh_display, sState, /ALL

         WIDGET_CONTROL, sState.wDrawLabel, SET_VALUE = label

         mview_update_pixel, sState, sState.x, sState.y
         mview_draw_profiles, sState, sState.x, sState.y, $
          sState.lastx, sState.lasty
         IF (sState.sPrefs.setup.keep_roi GE 1) AND $
          (PTR_VALID(sState.pActiveRegion)) THEN BEGIN
            mview_update_stats, sState, (*sState.pActiveRegion)

         ENDIF

      ENDIF

   ENDIF

   IF win_valid(save_win) THEN WSET, save_win

   SET_PLOT, saved_device

   return
END

; _____________________________________________________________________________

PRO mview_update_all, sState, data, HEADER_STD=header, $
                HEADER_UDL=header_udl, HEADER_ENG1=header_eng1, $
                HEADER_ENG2=header_eng2, LABELS=labels, DEBUG=debug
   COMPILE_OPT IDL2, HIDDEN
   IF KEYWORD_SET(debug) THEN PRINTF, -2, '===> Entered mview_update_all'
                    ; This is just a sort of macro to do all updates
                    ; at once (ie. when there is new data)

   mview_update_state, sState, data, HEADER_STD=header, $
    HEADER_UDL=header_udl, HEADER_ENG1=header_eng1, $
    HEADER_ENG2=header_eng2, LABELS=labels, DEBUG=debug

   mview_update_widget, sState, DEBUG=debug

   IF sState.sPrefs.setup.autostats EQ 1 THEN BEGIN
      IF N_ELEMENTS(n_pixels) LE 0 THEN n_pixels = N_ELEMENTS(data)
      n_random_points = 1.2e6
      IF n_pixels GT n_random_points THEN BEGIN
         strMessage = $
          STRING(FORMAT='("computing stats for ", G0, ' + $
                  '" random points across image...")', $
                  n_random_points)
         mview_wmessage, sState, strMessage 
         mview_update_stats, sState, RANDOM=n_random_points, DEBUG=debug
      ENDIF ELSE BEGIN
         strMessage = 'computing image stats...'
         mview_wmessage, sState, strMessage 
         mview_update_stats, sState, DEBUG=debug
         mview_wmessage, sState, ' '
      ENDELSE
   ENDIF 

   IF KEYWORD_SET(debug) THEN PRINTF, -2, '<=== Leaving mview_update_all'
   return
END

; _____________________________________________________________________________

PRO mview_update_widget, sState, DEBUG=debug
   COMPILE_OPT IDL2, HIDDEN
   IF KEYWORD_SET(debug) THEN PRINTF, -2, '===> Entered mview_update_widget'

   WIDGET_CONTROL, /HOURGLASS

                    ; Update draw widget
   offset = 20
   WIDGET_CONTROL, sState.wDraw, $
    DRAW_XSIZE=sState.x_image_sz, $
    DRAW_YSIZE=sState.y_image_sz, XSIZE=sState.x_draw_sz-offset,$
    YSIZE=sState.y_draw_sz-offset

                    ; Update draw label
   IF PTR_VALID(sState.pLabels) THEN $
    number_labels = N_ELEMENTS(*sState.pLabels) $
   ELSE number_labels = 0

   n_frame = sState.current_frame
   
   IF n_frame GT (number_labels-1) THEN $
    label = 'frame' + STRTRIM(n_frame[0] + 1, 2) $
   ELSE label = (*sState.pLabels)[n_frame]
   
   ;;label = label + ' : ' + STRLOWCASE(sState.scale_type)
   WIDGET_CONTROL, sState.wDrawLabel, SET_VALUE=label
   strScaleLabel = '[' + STRLOWCASE(sState.scale_type) + ']'
   WIDGET_CONTROL, sState.wScaleLabel, SET_VALUE=strScaleLabel

                    ; Update sliders
   mview_set_z1_value, sState, sState.min
   mview_set_z2_value, sState, sState.max

   mview_put_stats, sState, /BLANK
   mview_refresh_display, sState, /ALL, DEBUG=debug
   IF KEYWORD_SET(debug) THEN PRINTF, -2, '<=== Leaving mview_update_widget'

END

; _____________________________________________________________________________


PRO mview_update_state, sState, image, HEADER_STD=header, $
                        HEADER_UDL=header_udl, HEADER_ENG1=header_eng1, $
                        HEADER_ENG2=header_eng2, KEEP_HEADERS=keep_headers, $
                        LABELS=labels, DEBUG=debug
   COMPILE_OPT IDL2, HIDDEN
   IF KEYWORD_SET(debug) THEN PRINTF, -2, '===> Entered mview_update_state'

   IF (N_ELEMENTS(image) LE 0) THEN BEGIN
      PTR_FREE, sState.pImage
      image_ptr = PTR_NEW(DIST(256))
   ENDIF ELSE BEGIN
      PTR_FREE, sState.pImage
      image_ptr = PTR_NEW(image)
   ENDELSE

   IF NOT KEYWORD_SET(keep_headers) THEN BEGIN

      IF N_ELEMENTS(labels) LE 0 THEN BEGIN
         PTR_FREE, sState.pLabels
         label_ptr = PTR_NEW()
      ENDIF ELSE BEGIN
         PTR_FREE, sState.pLabels
         label_ptr = PTR_NEW(labels)
      ENDELSE

      IF (N_ELEMENTS(header) LE 0) THEN BEGIN
         PTR_FREE, sState.pHeader
         header_ptr = PTR_NEW()
      ENDIF ELSE BEGIN
         PTR_FREE, sState.pHeader
         header_ptr = PTR_NEW(header)
      ENDELSE 
      
      IF (N_ELEMENTS(header_udl) LE 0) THEN BEGIN
         PTR_FREE, sState.pHeaderUdl
         header_udl_ptr = PTR_NEW()
      ENDIF ELSE BEGIN
         PTR_FREE, sState.pHeaderUdl
         header_udl_ptr = PTR_NEW(header_udl)
      ENDELSE 
      
      IF (N_ELEMENTS(header_eng1) LE 0) THEN BEGIN
         PTR_FREE, sState.pHeaderEng1
         header_eng1_ptr = PTR_NEW()
      ENDIF ELSE BEGIN
         PTR_FREE, sState.pHeaderEng1
         header_eng1_ptr = PTR_NEW(header_eng1)
      ENDELSE 

      IF (N_ELEMENTS(header_eng2) LE 0) THEN BEGIN
         PTR_FREE, sState.pHeaderEng2
         header_eng2_ptr = PTR_NEW()
      ENDIF ELSE BEGIN
         PTR_FREE, sState.pHeaderEng2
         header_eng2_ptr = PTR_NEW(header_eng2)
      ENDELSE

      sState.pHeader = header_ptr
      sState.pHeaderUdl = header_udl_ptr
      sState.pHeaderEng1 = header_eng1_ptr
      sState.pHeaderEng2 = header_eng2_ptr
      sState.pLabels = label_ptr

   ENDIF

   PTR_FREE, sState.pActiveRegion

   image_sz = SIZE((*image_ptr))

   IF image_sz[1] GT 430 THEN x_dw_sz=430 ELSE x_dw_sz=image_sz[1]
   IF image_sz[2] GT 430 THEN y_dw_sz=430 ELSE y_dw_sz=image_sz[2]

   sState.pImage = image_ptr
   sState.pActiveRegion = PTR_NEW()
   sState.current_frame = 0
   sState.frame_min = MIN((*image_ptr)[*,*,0])
   sState.frame_max = MAX((*image_ptr)[*,*,0])

   IF (sState.scale_type EQ 'RAW') THEN BEGIN
                    ; put new preference option scale min/max on open here
      sState.min = sState.frame_min
      sState.max = sState.frame_max
   ENDIF 
   
   colorbar_sz = SIZE(sState.colorbar)
   sState.colorbar = make_colorbar(colorbar_sz[1], $
                                    MIN=sState.frame_min, $
                                    MAX=sState.frame_max, $
                                    HEIGHT=colorbar_sz[2])
   sState.x_image_sz = image_sz[1]
   sState.y_image_sz = image_sz[2]

   dx = sState.x_image_sz
   dy = sState.y_image_sz
   large_size = dx > dy
                    ; only worry about aspect if not sorta square
   unsquareness = ABS(dx-dy) / FLOAT(large_size)

   IF unsquareness GT 0.05 THEN BEGIN
      max_size = sState.x_zoom_sz < sState.y_zoom_sz
      scale_factor = (large_size / FLOAT(max_size)) > 1
      sState.x_orig_sz = LONG(dx / scale_factor)
      sState.y_orig_sz = LONG(dy / scale_factor)
   ENDIF ELSE BEGIN
      sState.x_orig_sz = sState.x_zoom_sz
      sState.y_orig_sz = sState.y_zoom_sz
   ENDELSE

   sState.lastx = -1L
   sState.lasty = -1L

   sState.main_zoom_factor = sState.sPrefs.setup.autozoom

   sState.sStats = mview_stat_skel()
   IF KEYWORD_SET(debug) THEN PRINTF, -2, '<=== Leaving mview_update_state'
   
END 

; _____________________________________________________________________________

PRO mview_draw_original, sState, image
   COMPILE_OPT IDL2, HIDDEN

   IF win_valid(sState.orig_win) THEN WSET, sState.orig_win $
   ELSE MESSAGE, 'Invalid window selection.'

   mview_wmessage, sState, 'refreshing display (original)...'

   n_frame = sState.current_frame
   IF sState.sPrefs.setup.color_scale EQ 0 THEN BEGIN
      min_val = sState.min
      max_val = sState.max
   ENDIF ELSE BEGIN
      min_val = sState.frame_min
      max_val = sState.frame_max
   ENDELSE

   x_orig_size = sState.x_orig_sz
   y_orig_size = sState.y_orig_sz

   ERASE

   CASE STRUPCASE(sState.scale_type) OF
      'RAW': BEGIN
         IF N_ELEMENTS(image) GT 2 THEN BEGIN
            TV, CONGRID(image, $
                         x_orig_size, $
                         y_orig_size)
         ENDIF ELSE BEGIN
            TV, CONGRID((*sState.pImage)[*,*,n_frame], $
                         x_orig_size, $
                         y_orig_size)
         ENDELSE
      END 

      'LINEAR': BEGIN
         IF N_ELEMENTS(image) GT 2 THEN BEGIN
            TV, BYTSCL(CONGRID(image, $
                                 x_orig_size, $
                                 y_orig_size)<max_val, $
                        MIN=min_val, MAX=max_val, $
                        TOP=!D.TABLE_SIZE-1), TRUE=use_true_color
         ENDIF ELSE BEGIN
            TV, BYTSCL(CONGRID((*sState.pImage)[*,*,n_frame], $
                                 x_orig_size, $
                                 y_orig_size), $
                        MIN=min_val, MAX=max_val, $
                        TOP=!D.TABLE_SIZE-1), TRUE=use_true_color
         ENDELSE
      END

      'LOG': BEGIN
         tmin = max_val / 1e4
         IF N_ELEMENTS(image) GT 2 THEN BEGIN
            TV, BYTSCL(CONGRID(image, $
                                 x_orig_size, $
                                 y_orig_size), $
                        MIN=ALOG10(tmin), MAX=ALOG10(max_val - min_val),$
                        TOP=!D.N_COLORS-1)
         ENDIF ELSE BEGIN
            TV, BYTSCL(CONGRID(ALOG10(((*sState.pImage)[*,*,n_frame]-$
                                         min_val)>tmin), $
                                 x_orig_size, $
                                 y_orig_size), $
                        MIN=ALOG10(tmin), MAX=ALOG10(max_val-min_val),$
                        TOP=!D.N_COLORS-1)
         ENDELSE
      END

      'SQRT': BEGIN
         IF N_ELEMENTS(image) GT 2 THEN BEGIN
            TV, BYTSCL(CONGRID(image, $
                                 x_orig_size, $
                                 y_orig_size), $
                        MIN=0, MAX=SQRT(max_val-min_val), $
                        TOP=!D.N_COLORS-1)
         ENDIF ELSE BEGIN
            TV, BYTSCL(CONGRID(SQRT(((*sState.pImage)[*, *, n_frame]-$
                                        min_val)>0), $
                                 x_orig_size, $
                                 y_orig_size), $
                        MIN=0, MAX=SQRT(max_val-min_val), $
                        TOP=!D.N_COLORS-1)
         ENDELSE
      END

      'HIST_EQ': BEGIN
         IF N_ELEMENTS(image) GT 2 THEN BEGIN
            TV, CONGRID(image, $
                         x_orig_size, $
                         y_orig_size)
         ENDIF ELSE BEGIN
            TV, CONGRID(HIST_EQUAL(FLOAT((*sState.pImage)[*, *, n_frame]),$
                                     MINV=min_val, MAXV=max_val, $
                                     TOP=!D.N_COLORS-1), $
                         x_orig_size, $
                         y_orig_size)
         ENDELSE
      END

      ELSE:

   ENDCASE
   
   return
END 

; _____________________________________________________________________________

PRO mview_draw_zoom, sState, xpos, ypos
   COMPILE_OPT IDL2, HIDDEN

                    ;Save window number
   save_win = !D.WINDOW
   IF win_valid(sState.zoom_win) THEN WSET, sState.zoom_win $
   ELSE MESSAGE, 'Invalid window selection.'

   IF sState.sPrefs.setup.color_scale EQ 0 THEN BEGIN
      max_val = sState.max
      min_val = sState.min
   ENDIF ELSE BEGIN
      max_val = sState.frame_max
      min_val = sState.frame_min
   ENDELSE

   zoom_image = mview_get_zoom_image(sState, xpos, ypos)

   CASE STRUPCASE(sState.scale_type) OF

      'RAW': BEGIN
         TV, zoom_image
      END 

      'LINEAR': BEGIN
         TV, BYTSCL(zoom_image<max_val, MIN=min_val, MAX=max_val, $
                     TOP=!D.TABLE_SIZE-1)
      END

      'LOG': BEGIN
         tmin = max_val / 1e4
         TV, BYTSCL(ALOG10((zoom_image - min_val) > tmin), $
                     MIN=ALOG10(tmin), MAX=ALOG10(max_val - min_val),$
                     TOP=!D.N_COLORS-1)
      END

      'SQRT': BEGIN
         TV, BYTSCL(SQRT((zoom_image - min_val) > 0), $
                     MIN=0, MAX=SQRT(max_val - min_val), $
                     TOP=!D.N_COLORS-1)
      END

      'HIST_EQ': BEGIN
         TV, HIST_EQUAL(zoom_image, $
                         MINV=min_val, MAXV=max_val, $
                         TOP=!D.N_COLORS-1)
      END

      ELSE:

   ENDCASE 

   IF win_valid(save_win) THEN WSET, save_win

END

; _____________________________________________________________________________

PRO mview_profiles_event, sEvent
   COMPILE_OPT IDL2, HIDDEN

                    ; get state information from first child of root
   wStateHandler = WIDGET_INFO(sEvent.handler, /CHILD)
   WIDGET_CONTROL, wStateHandler, GET_UVALUE=sState, /NO_COPY 
   
   WIDGET_CONTROL, sEvent.id, GET_UVALUE=event_uval

   struct_name = TAG_NAMES(sEvent, /STRUCTURE_NAME)

   IF STRUPCASE(struct_name) EQ 'WIDGET_BASE' THEN BEGIN
      offset_x = 0
      offset_y = 0
      newx = (sEvent.x - offset_x) / 2
      newy = sEvent.y - offset_y

      WIDGET_CONTROL, sState.wRoot, UPDATE=0
      WIDGET_CONTROL, sState.wDrawProfileX, XSIZE=newx, YSIZE=newy
      WIDGET_CONTROL, sState.wDrawProfileY, XSIZE=newx, YSIZE=newy
      WIDGET_CONTROL, sState.wRoot, UPDATE=1

   ENDIF ELSE BEGIN

      CASE strupcase(event_uval) OF
         ELSE:
      ENDCASE 

   ENDELSE 

   IF WIDGET_INFO(wStateHandler, /VALID_ID) EQ 1 THEN BEGIN
                    ; restore state information
      WIDGET_CONTROL, wStateHandler, SET_UVALUE=sState, /NO_COPY
   ENDIF 

   return
END 

; _____________________________________________________________________________

PRO mview_profiles, sState, xpos, ypos, ZOOM=use_zoom
   COMPILE_OPT IDL2, HIDDEN

   IF WIDGET_INFO(sState.wProfileWin, /VALID_ID) NE 1 THEN BEGIN

      strTitle = STRING(FORMAT='("Mview profiles",:," [",I0,"]")', $
                         sState.instance)
      
      wRoot = WIDGET_BASE(GROUP_LEADER=sState.wRoot, UVALUE='ROOT', $
                           TITLE=strTitle, /COLUMN, /MAP, $
                           /TLB_SIZE_EVENTS, $
                           XPAD=0, YPAD=0, XOFFSET=0, YOFFSET=0, SPACE=0)

      wBase = WIDGET_BASE(wRoot, /ROW, $
                           XPAD=0, YPAD=0, XOFFSET=0, YOFFSET=0, SPACE=0)

      xs = sState.sPrefs.startup.profiles_xsize
      ys = sState.sPrefs.startup.profiles_ysize
      wDrawProfileX = WIDGET_DRAW(wBase, /FRAME, XSIZE=xs, YSIZE=ys)
      wDrawProfileY = WIDGET_DRAW(wBase, /FRAME, XSIZE=xs, YSIZE=ys)

      WIDGET_CONTROL, wRoot, /REALIZE
      WIDGET_CONTROL, GET_VALUE=xi, wDrawProfileX
      WIDGET_CONTROL, GET_VALUE=yi, wDrawProfileY

      sState.xcut_win = xi
      sState.ycut_win = yi
      sState.wProfileWin = wRoot

      sLocalState = { wRoot: wRoot, $
                      wBase: wBase, $
                      wDrawProfileX: wDrawProfileX, $
                      wDrawProfileY: wDrawProfileY }

      WIDGET_CONTROL, wBase, SET_UVALUE=sLocalState, /NO_COPY

      XMANAGER, 'mview_profiles', wRoot, /NO_BLOCK
   ENDIF

   sz_im1 = SIZE((*sState.pImage))

   n_frame = sState.current_frame

   IF (xpos GE 0) AND (xpos LT sz_im1[1]) AND $
    (ypos GE 0) AND (ypos LT sz_im1[2]) THEN BEGIN

      mview_draw_profiles, sState, xpos, ypos, /INIT
   ENDIF

   return
END 

; _____________________________________________________________________________

PRO mview_draw_profiles, sState, xpos, ypos, lastx, lasty, $
                         DEBUG=debug, INIT=init
   COMPILE_OPT IDL2, HIDDEN

   saved_device = !D.NAME
   CASE STRUPCASE(!VERSION.OS_FAMILY) OF
      'WINDOWS': SET_PLOT, 'WIN'
      'MACOS': SET_PLOT, 'MAC'
      ELSE: SET_PLOT, 'X'
   ENDCASE

   IF WIDGET_INFO(sState.wProfileWin, /VALID_ID) EQ 1 THEN BEGIN

      n_frame = sState.current_frame

      IF ((sState.lasty NE ypos) OR KEYWORD_SET(init)) THEN BEGIN
         
         WSET, sState.xcut_win

         xpix = LINDGEN(sState.x_image_sz)
         ;ypix = LINDGEN(sState.y_image_sz)

         n_frame = sState.current_frame
         image_sz = SIZE(*sState.pImage)
         width = sState.sPrefs.setup.slice_width

         IF width GT 1 THEN BEGIN
            y0 = (ypos - LONG(width) / 2) > 0
            y1 = (ypos - 1 + LONG(width) / 2) < (image_sz[2]-1)

                    ; have we hit the edge so width -> 1 ?
            IF (y0 LT y1) THEN BEGIN
               im1xcut = TOTAL((*sState.pImage)[ *, y0:y1, n_frame], 2) / $
                (y1 - y0 + 1)

               value_title = STRING(FORMAT='("z (", I0, " row average)")', $
                                     y1-y0+1)
            ENDIF ELSE BEGIN
               im1xcut = (*sState.pImage)[ *, ypos, n_frame]
               
               value_title = 'z (value)'
            ENDELSE

         ENDIF ELSE BEGIN
            im1xcut = (*sState.pImage)[ *, ypos, n_frame]

            value_title = 'z (value)'
         ENDELSE

         IF KEYWORD_SET(init) THEN BEGIN
            PLOT, xpix, im1xcut, COLOR=!D.N_COLORS-1, PSYM=10, $
             TITLE='HORIZONTAL', XTITLE='x (pixels)',/XSTYLE, /YSTYLE, $
             YTITLE=value_title, YRANGE=[sState.min,sState.max], CHARSIZE=.8, $
             XRANGE=[0,sState.x_image_sz]
         ENDIF ELSE BEGIN
            ; These are the same for now
            PLOT, xpix, im1xcut, COLOR=!D.N_COLORS-1, PSYM=10, $
             TITLE='HORIZONTAL', XTITLE='x (pixels)',/XSTYLE, /YSTYLE, $
             YTITLE=value_title, YRANGE=[sState.min,sState.max], CHARSIZE=.8, $
             XRANGE=[0,sState.x_image_sz]
         ENDELSE

      ENDIF

      IF ((sState.lastx NE xpos) OR KEYWORD_SET(init))THEN BEGIN
         
         WSET, sState.ycut_win

         ;xpix = LINDGEN(sState.x_image_sz)
         ypix = LINDGEN(sState.y_image_sz)

         n_frame = sState.current_frame
         image_sz = SIZE(*sState.pImage)
         width = sState.sPrefs.setup.slice_width

         IF width GT 1 THEN BEGIN
            x0 = (xpos - LONG(width) / 2) > 0
            x1 = (xpos - 1 + LONG(width) / 2) < (image_sz[1]-1)

                    ; have we hit the edge so width -> 1 ?
            IF (x0 LT x1) THEN BEGIN
               im1ycut = TOTAL((*sState.pImage)[x0:x1, *, n_frame],1) / $
                (x1 - x0 + 1)
               value_title = STRING(FORMAT='("z (", I0, " column average)")',$
                                     x1-x0+1)
            ENDIF ELSE BEGIN
               im1ycut = (*sState.pImage)[xpos, *, n_frame]
               value_title = 'z (value)'
            ENDELSE
         
         ENDIF ELSE BEGIN
            im1ycut = (*sState.pImage)[xpos, *, n_frame]
            value_title = 'z (value)'
         ENDELSE

                    ; Duplicate data for use with vertical PSYM=10
         new_ypix = LONARR(N_ELEMENTS(ypix) * 2)
         new_ycut = FLTARR(N_ELEMENTS(im1ycut) * 2)

         new_ypix[ ypix * 2 ] = ypix
         new_ypix[ ypix * 2 + 1 ] = ypix + 1
         new_ycut[ ypix * 2 ] = im1ycut
         new_ycut[ ypix * 2 + 1 ] = im1ycut

         IF KEYWORD_SET(init) THEN BEGIN
            PLOT, new_ycut, new_ypix, COLOR=!D.N_COLORS-1, PSYM = 10, $
             TITLE='VERTICAL', YTITLE='y (pixels)',/XSTYLE, /YSTYLE, $
             XTITLE=value_title, XRANGE=[sState.min,sState.max], CHARSIZE=.8, $
             YRANGE=[0,sState.y_image_sz]
         ENDIF ELSE BEGIN
            ; These are the same for now
            PLOT, new_ycut, new_ypix, COLOR=!D.N_COLORS-1, PSYM = 10, $
             TITLE='VERTICAL', YTITLE='y (pixels)',/XSTYLE, /YSTYLE, $
             XTITLE=value_title, XRANGE=[sState.min,sState.max], CHARSIZE=.8, $
             YRANGE=[0,sState.y_image_sz]
         ENDELSE
         
      ENDIF 

   ENDIF

   SET_PLOT, saved_device
   return
END 

; _____________________________________________________________________________


PRO mview_trace_cursor, sState, xpos, ypos
   COMPILE_OPT IDL2, HIDDEN

   saved_device = !D.NAME
   CASE STRUPCASE(!VERSION.OS_FAMILY) OF
      'WINDOWS': SET_PLOT, 'WIN'
      'MACOS': SET_PLOT, 'MAC'
      ELSE: SET_PLOT, 'X'
   ENDCASE

   x0 = 0
   y0 = 0
   x = x0 + (xpos / sState.main_zoom_factor)
   y = y0 + (ypos / sState.main_zoom_factor)
   x = LONG(x) > 0 < (sState.x_image_sz-1)
   y = LONG(y) > 0 < (sState.y_image_sz-1)
   mview_update_pixel, sState, x, y

   save_win = !D.WINDOW
   IF win_valid(sState.draw_win) THEN WSET, sState.draw_win $
   ELSE MESSAGE, 'Invalid window selection.'

   x_trace, sState.wDraw, XSIZE=sState.x_image_sz, YSIZE=sState.y_image_sz, $
    x, y, LASTX=sState.lastx, LASTY=sState.lasty, ZOOM=sState.main_zoom_factor

   mview_draw_profiles, sState, x, y, sState.lastx, sState.lasty

   WSET, sState.draw_win
   mview_draw_zoom, sState, x, y

   IF win_valid(save_win) THEN WSET, save_win
   sState.x = x
   sState.y = y
   sState.lasty = y
   sState.lastx = x
   
   SET_PLOT, saved_device

   return
END 

; _____________________________________________________________________________


PRO mview_new_plot, image_ptr, value, PLOT_OPTS=plot_opts, $
                    POSITION=position, DEVICE=device, NORMAL=normal, $
                    ERROR=error, MIN=min_val, MAX=max_val, $
                    FRAME=frame, POSTSCRIPT=postscript
   COMPILE_OPT IDL2, HIDDEN

   IF N_ELEMENTS(plot_opts) LE 0 THEN BEGIN
      plot_opts = { postscript: 0b, $
                    contour: 'image, NLEVELS=10, /FILL', $
                    surface: 'image', $
                    shade_surf: 'image', $
                    show3: 'image', $
                    contour_over: 'image', $
                    histogram: 'HISTOGRAM(image, MIN=0, MAX=MAX(image)), PSYM=10' }

   ENDIF 

   IF NOT KEYWORD_SET(normal) THEN device = 1

   IF KEYWORD_SET(postscript) THEN BEGIN
      current_device = !D.NAME
      save_pmulti = !P.MULTI
      SET_PLOT, 'PS'
      filename = 'mv_plot.ps'
      page_xsize = 7.4
      page_ysize = 9.4
      scale_factor = 1.0
      DEVICE, FILENAME=filename, SCALE_FACTOR=scale_factor, $
       /INCHES, BITS = 8, $
       XOFF = 0.7, YOFF = 0.7, $
       XSIZE = page_xsize, YSIZE = page_ysize
   ENDIF ELSE BEGIN
      WINDOW, /FREE, XSIZE=512, YSIZE=512, TITLE = menuvalue
      window_id = !D.WINDOW
   ENDELSE

   IF N_ELEMENTS(winid) GT 0 THEN BEGIN
      save_win = !D.WINDOW
      IF win_valid(winid) THEN WSET, winid ELSE return
   ENDIF 

   IF N_ELEMENTS(frame) LE 0 THEN frame = 0
   image_sz = SIZE((*image_ptr))
   IF (frame+1) GT image_sz[0] THEN frame = 0
   image = (*image_ptr)[*,*,frame]
   
   dx = image_sz[1]
   dy = image_sz[2]

   IF !D.NAME NE 'PS' THEN BEGIN
      large_size = dx > dy
      page_xsize = !D.X_SIZE
      page_ysize = !D.Y_SIZE
      max_size = page_xsize >!D.Y_SIZE
      scale_factor = (large_size / FLOAT(max_size))
   ENDIF

   xout = dx/scale_factor
   yout = dy/scale_factor

   image_xsize = page_xsize
   image_ysize = page_xsize
   IF xout LT yout THEN image_xsize = page_xsize*(FLOAT(xout)/yout)
   IF yout LT xout THEN image_ysize = page_ysize*(FLOAT(yout)/xout)

   y_offset = page_ysize - page_xsize
   x0 = 0
   y0 = y_offset / FLOAT(page_ysize)
   x1 = image_xsize / page_xsize
   y1 = (image_ysize+y_offset) / page_ysize

;   position = LONG([ 0, 0, (image_sz[1] / scale_factor), $
;                      (image_sz[2] / scale_factor) ])
   position = [x0, y0, x1, y1] * 0.8 + 0.1

   CASE STRUPCASE(value) OF

      'NONE DEFINED':

      'HISTOGRAM': BEGIN

         plot_string = 'PLOT, TITLE="HISTOGRAM",' + $
          '/DEVICE, ' + $
          plot_opts.histogram

         ret = EXECUTE(plot_string)
      END 

      'CONTOUR': BEGIN
         plot_string = 'CONTOUR, TITLE="CONTOUR",' + $
          'POSITION=position, /NORMAL, /XSTYLE, /YSTYLE, ' + $
          plot_opts.contour

         ret = EXECUTE(plot_string)
      END

      'CONTOUR_OVER': BEGIN

         IF (scale_factor NE 1) AND (!D.NAME NE 'PS') THEN BEGIN
            xsize = (position[2] - position[0]) * page_xsize
            ysize = (position[3] - position[1]) * page_ysize
            tvimage = CONGRID(BYTSCL(image[*,*,0], $
                                       MIN = min_val, MAX = max_val, $
                                       TOP = !D.TABLE_SIZE), $
                               xsize, ysize)

         ENDIF ELSE tvimage = BYTSCL(image[*,*,0], $
                                      MIN = min_val, MAX = max_val, $
                                      TOP = !D.TABLE_SIZE)

         IF !D.NAME EQ 'PS' THEN BEGIN
            TV, 255b-tvimage, position[0], position[1], /NORMAL, $
             XSIZE=position[2]-position[0], YSIZE=position[3]-position[1]
         ENDIF ELSE TV, tvimage, position[0], position[1], /NORMAL

         plot_string = 'CONTOUR, /NOERASE, POSITION=position, '+$
          '/NORMAL, /XSTYLE, /YSTYLE, ' + plot_opts.contour_over
         ret = EXECUTE(plot_string)
      END

      'SURFACE': BEGIN

         plot_string = 'SURFACE, TITLE="SURFACE",' + $
          'POSITION=position, ' + $
          plot_opts.surface
         ret = EXECUTE(plot_string)
      END

      'SHADE_SURF': BEGIN
         plot_string = 'SHADE_SURF, TITLE="SHADE_SURF",' + $
          'POSITION=position, ' + $
          plot_opts.shade_surf
         ret = EXECUTE(plot_string)
      END 

      'SHOW3': BEGIN
         
         plot_string = 'SHOW3,' + plot_opts.show3
         ret = EXECUTE(plot_string)
      END 

      ELSE: BEGIN
         MESSAGE, 'Case match not found', /NO_NAME, /CONT
         ret = 0
      END

   ENDCASE

   IF ret NE 1 THEN error = 1 ELSE error = 0
   
   IF KEYWORD_SET(postscript) THEN BEGIN
      DEVICE, /CLOSE
      SET_PLOT, current_device
   ENDIF ELSE BEGIN
      IF error EQ 1 THEN WDELETE
   ENDELSE

   IF N_ELEMENTS(winid) GT 0 THEN BEGIN
      IF win_valid(save_win) THEN WSET, save_win
   ENDIF 

END

; _____________________________________________________________________________


PRO mview_define_region, sState, x0, y0, REGION=subscripts, CORNERS=corners
   COMPILE_OPT IDL2, HIDDEN

   region_type = sState.sPrefs.setup.defroi
   error_flag = 0
   get_region = 1b
   IF N_ELEMENTS(subscripts) GT 2 THEN get_region = 0b
   IF N_ELEMENTS(corners) EQ 4 THEN get_region = 0b

   ;;dx0 = (x0 / sState.main_zoom_factor)
   ;;dy0 = (y0 / sState.main_zoom_factor)

   IF (get_region) THEN BEGIN
      save_win = !D.WINDOW
      IF win_valid(sState.draw_win) THEN WSET, sState.draw_win $
      ELSE MESSAGE, 'Invalid window selection.'
      
      x_trace, sState.wDraw, XSIZE=sState.x_image_sz, YSIZE=sState.y_image_sz, $
       LASTX=sState.lastx, LASTY=sState.lasty, /ERASE, $
       ZOOM=sState.main_zoom_factor
      
      sState.lastx = -1L
      sState.lasty = -1L
   ENDIF

   ximsize = (SIZE(*sState.pImage))[1]
   yimsize = (SIZE(*sState.pImage))[2]
   
   keep_roi = sState.sPrefs.setup.keep_roi
   IF keep_roi GE 1 THEN restore = 0 ELSE restore = 1
      
   CASE region_type OF
      0: BEGIN
         IF get_region THEN BEGIN
            corners = x_select_box(sState.wDraw, x0, y0, KEEP=keep_roi, $
                                   /CORNERS, STATUS=error_flag)
         ENDIF
         IF (error_flag EQ 0) AND (N_ELEMENTS(corners) EQ 4) THEN BEGIN
            x0 = corners[0] / sState.main_zoom_factor
            y0 = corners[1] / sState.main_zoom_factor
            x1 = corners[2] / sState.main_zoom_factor
            y1 = corners[3] / sState.main_zoom_factor
            x_corners = [x0, x0, x1, x1 ]
            y_corners = [y0, y1, y1, y0 ]
            subscripts = POLYFILLV(x_corners, y_corners, $
                                    ximsize, yimsize)

            IF keep_roi GE 1 THEN BEGIN
                    ; draw box on original image
               ox = sState.x_orig_sz
               oy = sState.y_orig_sz            
               ix = sState.x_image_sz
               iy = sState.y_image_sz
               xfactor = ox / FLOAT(ix)
               yfactor = oy / FLOAT(iy)
               x_draw_box, sState.wOrigDraw, x0*xfactor, y0*yfactor, $
                x1*xfactor, y1*yfactor
            ENDIF
         ENDIF
      END
      1: BEGIN
         IF get_region THEN BEGIN
            subscripts = DEFROI(ximsize, yimsize, /NOFILL, $
                                RESTORE=restore)
         ENDIF
      END
      ELSE: 
   ENDCASE

   n_frame = sState.current_frame

   IF N_ELEMENTS(subscripts) LE 1 THEN BEGIN
      mview_wmessage, sState, 'No data selected'
      return
   ENDIF ELSE BEGIN

      IF sState.sPrefs.setup.keep_roi GE 1 THEN BEGIN
         IF (keep_roi EQ 2) AND (PTR_VALID(sState.pActiveRegion)) THEN BEGIN
                    ; append to active region
            subscripts = [*sState.pActiveRegion,subscripts]
         ENDIF

         PTR_FREE, sState.pActiveRegion
         sState.pActiveRegion = PTR_NEW(subscripts)

      ENDIF

   ENDELSE

   strMessage = STRING(FORMAT='("selected ",I0," pixels")', $
                        N_ELEMENTS(subscripts))
   mview_wmessage, sState, strMessage

   IF (get_region) AND win_valid(save_win) THEN WSET, save_win

   mview_update_stats, sState, subscripts, DEBUG=debug

   WIDGET_CONTROL, sState.wRoot, /CLEAR_EVENTS

END

; _____________________________________________________________________________


PRO mview_update_pixel, sState, xpos, ypos
   COMPILE_OPT IDL2, HIDDEN

   x = xpos > 0 < (sState.x_image_sz-1)
   y = ypos > 0 < (sState.y_image_sz-1)

   n_frame = sState.current_frame

                    ; print the coordinate and value at cursor
   pixel_string = STRING(FORMAT='("[",I0,",",I0,"]",1X,F0)', x, y, $
                          (*sState.pImage)[x,y,n_frame])

   WIDGET_CONTROL, sState.wPixelText, SET_VALUE=pixel_string

END 

; _____________________________________________________________________________


FUNCTION mview_retrieve_pref_values, sState
   COMPILE_OPT IDL2, HIDDEN

   sPrefs = mview_get_default_prefs(sState.Version)

                    ; ___________________________________

                    ; Get plot options
                    ; ___________________________________

   WIDGET_CONTROL, sState.wPlotOptsPostscriptOutput, GET_VALUE=value
   sPrefs.plot.postscript_output = value[0] EQ 1
   
   WIDGET_CONTROL, sState.wPlotOptsContour, GET_VALUE=value
   im1pos = STRPOS(STRLOWCASE(value), 'image')
   IF im1pos[0] NE -1 THEN sPrefs.plot.contour = value[0]
   WIDGET_CONTROL, sState.wPlotOptsContourOver, GET_VALUE=value
   im1pos = STRPOS(STRLOWCASE(value), 'image')
   IF im1pos[0] NE -1 THEN sPrefs.plot.contour_over = value[0]
   WIDGET_CONTROL, sState.wPlotOptsSurface, GET_VALUE=value
   im1pos = STRPOS(STRLOWCASE(value), 'image')
   IF im1pos[0] NE -1 THEN sPrefs.plot.surface = value[0]
   WIDGET_CONTROL, sState.wPlotOptsShadeSurf, GET_VALUE=value
   im1pos = STRPOS(STRLOWCASE(value), 'image')
   IF im1pos[0] NE -1 THEN sPrefs.plot.shade_surf = value[0]
   WIDGET_CONTROL, sState.wPlotOptsHistogram, GET_VALUE=value
   im1pos = STRPOS(STRLOWCASE(value), 'image')
   IF im1pos[0] NE -1 THEN sPrefs.plot.histogram = value[0]
   WIDGET_CONTROL, sState.wPlotOptsShow3, GET_VALUE=value
   im1pos = STRPOS(STRLOWCASE(value), 'image')
   IF im1pos[0] NE -1 THEN sPrefs.plot.show3 = value[0]
   
                    ; ___________________________________

                    ; Get setup options
                    ; ___________________________________

   WIDGET_CONTROL, sState.wSetupOptsTrack, GET_VALUE=value
   sPrefs.setup.track = value[0] EQ 1

   WIDGET_CONTROL, sState.wSetupOptsDefroi, GET_VALUE=value
   sPrefs.setup.defroi = value[0] EQ 1

   WIDGET_CONTROL, sState.wSetupOptsKeepRoi, GET_VALUE=value
   sPrefs.setup.keep_roi = value[0] > 0

   WIDGET_CONTROL, sState.wSetupOptsAutoScale, GET_VALUE=value
   sPrefs.setup.autoscale = value[0] EQ 2
   sPrefs.setup.autostats = value[0] EQ 1

   WIDGET_CONTROL, sState.wSetupOptsAutoZoom, GET_VALUE=value
   sPrefs.setup.autozoom = value[0] > 0

   WIDGET_CONTROL, sState.wSetupOptsColorScale, GET_VALUE=value
   sPrefs.setup.color_scale = value[0] > 0

   WIDGET_CONTROL, sState.wSetupOptsSliceWidth, GET_VALUE=value
   sPrefs.setup.slice_width = value[0] > 0

   WIDGET_CONTROL, sState.wSetupOptsAutoBlink, GET_VALUE=value
   sPrefs.setup.autoblink = value[0] EQ 1

   WIDGET_CONTROL, sState.wSetupOptsBlinkDelay, GET_VALUE=value
   sPrefs.setup.blink_delay = value[0] > 0


                    ; ___________________________________

                    ; Get button options
                    ; ___________________________________

   WIDGET_CONTROL, sState.wButtonOptsButton1, GET_VALUE=value
   sPrefs.button.button1 = value[0] > 0
   WIDGET_CONTROL, sState.wButtonOptsButton2, GET_VALUE=value
   sPrefs.button.button2 = value[0] > 0
   WIDGET_CONTROL, sState.wButtonOptsButton3, GET_VALUE=value
   sPrefs.button.button3 = value[0] > 0

                    ; ___________________________________

                    ; Get startup options
                    ; ___________________________________

   WIDGET_CONTROL, sState.wStartupOptsColorTableNumber, GET_VALUE=value
   sPrefs.startup.color_table_number = FIX(value[0] > (-1) < 40)

   WIDGET_CONTROL, sState.wStartupOptsDisplayScale, GET_VALUE=value
   sPrefs.startup.display_scale = value[0] > 0

   screen_size = GET_SCREEN_SIZE()
   WIDGET_CONTROL, sState.wStartupOptsProfilesXsize, GET_VALUE=value
   sPrefs.startup.profiles_xsize = value[0] > 0 < screen_size[0]
   WIDGET_CONTROL, sState.wStartupOptsProfilesYsize, GET_VALUE=value
   sPrefs.startup.profiles_ysize = value[0] > 0 < screen_size[1]

                    ; ___________________________________

                    ; Get filter options
                    ; ___________________________________

   WIDGET_CONTROL, sState.wFiltersOptsMedianSize, GET_VALUE=value
   sPrefs.filter.median_size = value[0] > 1

   WIDGET_CONTROL, sState.wFiltersOptsSmoothSize, GET_VALUE=value
   sPrefs.filter.smooth_size = value[0] > 1

   WIDGET_CONTROL, sState.wFiltersOptsLeeSize, GET_VALUE=value
   sPrefs.filter.lee_size = value[0] > 1

   WIDGET_CONTROL, sState.wFiltersOptsLeeSigma, GET_VALUE=value
   sPrefs.filter.lee_sigma = value[0] > 1

                    ; ___________________________________

                    ; Get analysis options
                    ; ___________________________________

   WIDGET_CONTROL, sState.wAnalysisOptsCentroidFWHM, GET_VALUE=value
   sPrefs.analysis.centroid_fwhm = value[0] > 0

   WIDGET_CONTROL, sState.wAnalysisOptsCentroidMultiple, GET_VALUE=value
   sPrefs.analysis.centroid_multiple = value[0] EQ 1

   return, sPrefs
END 

; _____________________________________________________________________________


PRO mview_prefs_event, sEvent
   COMPILE_OPT IDL2, HIDDEN

                    ; get state information from first child of root
   child = WIDGET_INFO(sEvent.handler, /CHILD)
   infobase = WIDGET_INFO(child, /SIBLING)
   WIDGET_CONTROL, infobase, GET_UVALUE=sState, /NO_COPY 
   
   WIDGET_CONTROL, sEvent.id, GET_UVALUE=event_uval

   struct_name = TAG_NAMES(sEvent, /STRUCTURE_NAME)

   IF STRUPCASE(struct_name) EQ 'WIDGET_BASE' THEN BEGIN

      newx = (sEvent.x - 10) > 10
      newy = (sEvent.y - 75) > 10
            
      WIDGET_CONTROL, sState.wRoot, UPDATE=0
      WIDGET_CONTROL, sState.wScrollBase, SCR_XSIZE = newx, $
       SCR_YSIZE = newy
      WIDGET_CONTROL, sState.wRoot, UPDATE=1

   ENDIF ELSE BEGIN

      CASE strupcase(event_uval) OF

         'MENU': BEGIN
            CASE sEvent.value OF
               'Options.Setup': BEGIN
                  WIDGET_CONTROL, sState.wMapped, MAP=0
                  WIDGET_CONTROL, sState.wSetupOptsBase, MAP=1
                  sState.wMapped = sState.wSetupOptsBase
               END 

               'Options.Buttons': BEGIN
                  WIDGET_CONTROL, sState.wMapped, MAP=0
                  WIDGET_CONTROL, sState.wButtonOptsBase, MAP=1
                  sState.wMapped = sState.wButtonOptsBase
               END

               'Options.Plot types': BEGIN
                  WIDGET_CONTROL, sState.wMapped, MAP=0
                  WIDGET_CONTROL, sState.wPlotOptsBase, MAP=1
                  sState.wMapped = sState.wPlotOptsBase
               END

               'Options.Startup': BEGIN
                  WIDGET_CONTROL, sState.wMapped, MAP=0
                  WIDGET_CONTROL, sState.wStartupOptsBase, MAP=1
                  sState.wMapped = sState.wStartupOptsBase
               END

               'Options.Filters': BEGIN
                  WIDGET_CONTROL, sState.wMapped, MAP=0
                  WIDGET_CONTROL, sState.wFiltersOptsBase, MAP=1
                  sState.wMapped = sState.wFiltersOptsBase
               END

               'Options.Analysis': BEGIN
                  WIDGET_CONTROL, sState.wMapped, MAP=0
                  WIDGET_CONTROL, sState.wAnalysisOptsBase, MAP=1
                  sState.wMapped = sState.wAnalysisOptsBase
               END

               'File.Save': BEGIN
                  sPrefs = mview_retrieve_pref_values(sState)
                  strFileName = GETENV('HOME') + '/.mview'
                  SAVE, sPrefs, FILENAME = strFileName

                  sSendEvent = { ID: sState.parent, $
                                 TOP: sState.parent, $
                                 HANDLER: sState.parent, $
                                 UVALUE: 'NEW_PREFS', $
                                 VALUE: sPrefs }

                  WIDGET_CONTROL, sState.parent, SEND_EVENT=sSendEvent
               END

               'File.Close': BEGIN
                  WIDGET_CONTROL, sEvent.top, /DESTROY
               END

               ELSE:
            ENDCASE 
         END 

         'CANCEL_BUTTON': BEGIN
            WIDGET_CONTROL, sEvent.top, /DESTROY
         END 
         'OK_BUTTON': BEGIN

            sPrefs = mview_retrieve_pref_values(sState)

            sSendEvent = { ID: sState.parent, $
                           TOP: sState.parent, $
                           HANDLER: sState.parent, $
                           UVALUE: 'NEW_PREFS', $
                           VALUE: sPrefs }

            WIDGET_CONTROL, sState.parent, SEND_EVENT=sSendEvent

            WIDGET_CONTROL, sEvent.top, /DESTROY
         END 
         'APPLY_BUTTON': BEGIN
            
            sPrefs = mview_retrieve_pref_values(sState)

            sSendEvent = { ID: sState.parent, $
                           TOP: sState.parent, $
                           HANDLER: sState.parent, $
                           UVALUE: 'NEW_PREFS', $
                           VALUE: sPrefs }

            WIDGET_CONTROL, sState.parent, SEND_EVENT=sSendEvent

         END 

         ELSE:

      ENDCASE 

   ENDELSE

   IF WIDGET_INFO(sEvent.top, /VALID_ID) EQ 1 THEN BEGIN
                    ; restore state information
      WIDGET_CONTROL, infobase, SET_UVALUE=sState, /NO_COPY

   ENDIF 

END 

; _____________________________________________________________________________


PRO mview_prefs, toplevelbase, sPrefs, GROUP_LEADER=group, $
                 INSTANCE=instance, VERSION=version
   COMPILE_OPT IDL2, HIDDEN

   ;;IF XREGISTERED('mview_prefs') THEN return

   IF N_ELEMENTS(sPrefs) LE 0 THEN $
    default = mview_get_default_prefs() $
   ELSE default = sPrefs

   IF N_ELEMENTS(instance) LE 0 THEN instance = ''
   IF N_ELEMENTS(version) LE 0 THEN version = '0.0'
   
   strTitle = STRING(FORMAT='("Preferences",:," [",I0,"]")', instance)

   pref_root = WIDGET_BASE(GROUP_LEADER=group, UVALUE='ROOT', $
                            TITLE=strTitle, MBAR=mbar, /COLUMN, $
                            /TLB_SIZE_EVENTS)

   pref_base = WIDGET_BASE(pref_root, /COLUMN, /FRAME, XPAD=1, YPAD=1)

   MenuList = [ '1\File', '0\Save', '2\Close', $
                '1\Options', '0\Setup', '0\Buttons', '0\Plot types', $
                '0\Filters', '0\Startup', '2\Analysis' ]

   MenuBar = CW_PDMENU(mbar, /RETURN_FULL_NAME, /MBAR, $
                        MenuList, UVALUE='MENU')

   options_top_base = WIDGET_BASE(pref_base, /COLUMN, /SCROLL, $
                                   X_SCROLL_SIZE=350, Y_SCROLL_SIZE=350)

   options_base = WIDGET_BASE(options_top_base)

                    ; ______________________________________
                    ;
                    ; Setup Page
                    ; ______________________________________


   setup_base = WIDGET_BASE(options_base, /COLUMN, MAP=1)
   setup_label = WIDGET_LABEL(setup_base, VALUE='Setup')

   value = default.setup.track
   track_opt = CW_BGROUP(setup_base, 'Track Cursor', $
                            /NO_RELEASE, UVALUE='TRACK', /NONEXCLUSIVE, $
                            SET_VALUE=[value EQ 1])

   value = default.setup.defroi
   defroi_opt = CW_BGROUP(setup_base, /ROW, ['Box','Irregular'], $
                           /NO_RELEASE, UVALUE='DEFROI', /EXCLUSIVE, $
                           SET_VALUE=value, LABEL_LEFT='Region Selection')

   value = default.setup.keep_roi
   keep_roi_opt = CW_BGROUP(setup_base, /ROW, ['Off','On','Multiple'], $
                             /NO_RELEASE, UVALUE='KEEP_ROI', /EXCLUSIVE, $
                             SET_VALUE=value, LABEL_LEFT='Keep Region')

   value = (default.setup.autoscale EQ 1) ? 2 : $
    ((default.setup.autostats) ? 1 : 0)
   autoscale_opt = CW_BGROUP(setup_base, /ROW, $
                             ['None','Autostats', 'Autoscale'], $
                             /NO_RELEASE, UVALUE='AUTOSCALE', /EXCLUSIVE, $
                             SET_VALUE=[value EQ 1],LABEL_LEFT='On Open')

   value = (default.setup.autozoom LE 0) ? 1.0 : default.setup.autozoom
   autozoom_opt = CW_FIELD(setup_base, /FLOAT, /ROW, XSIZE=5, $
                           VALUE=value, $
                           TITLE='Auto zoom factor', $
                           UVALUE='AUTO_ZOOM_FACTOR')
   
   value = default.setup.color_scale
   color_scale_opt = CW_BGROUP(setup_base, /ROW, ['image','table'], $
                                /NO_RELEASE,UVALUE='SCALE_BUTTON',/EXCLUSIVE,$
                                SET_VALUE=value, LABEL_LEFT='Color scaling')

   value = default.setup.slice_width
   slice_width_opt = CW_FIELD(setup_base, /LONG, /ROW, XSIZE=5, $
                               VALUE=value, $
                               TITLE='Slice width (pixels)', $
                               UVALUE='SLICE_WIDTH')

   value = default.setup.autoblink
   autoblink_opt = CW_BGROUP(setup_base, 'Auto Blink', $
                              /NO_RELEASE, UVALUE='AUTOBLINK', /NONEXCLUSIVE, $
                              SET_VALUE=[value EQ 1])
   
   value = default.setup.blink_delay
   blink_delay_opt = CW_FIELD(setup_base, /FLOAT, /ROW, XSIZE=8, $
                               VALUE=value, $
                               TITLE='Blink Delay (sec)', UVALUE='BLINK_DELAY')

                    ; ______________________________________
                    ;
                    ; Buttons Page
                    ; ______________________________________

   button_setup_base = WIDGET_BASE(options_base, /COLUMN, MAP=0)
   button_setup_label = WIDGET_LABEL(button_setup_base, VALUE='Button setup')

   button_desc = [ 'Define region', 'Draw profiles', 'Blink', 'Select Point' ]
   value = default.button.button1
   button1_opts = CW_BGROUP(button_setup_base, button_desc, $
                             /NO_RELEASE, UVALUE='BUTTON1', /EXCLUSIVE, $
                             SET_VALUE=value, LABEL_LEFT='Button1 action')
   value = default.button.button2
   button2_opts = CW_BGROUP(button_setup_base, button_desc, $
                             /NO_RELEASE, UVALUE='BUTTON2', /EXCLUSIVE, $
                             SET_VALUE=value, LABEL_LEFT='Button2 action')
   value = default.button.button3
   button3_opts = CW_BGROUP(button_setup_base, button_desc, $
                             /NO_RELEASE, UVALUE='BUTTON3', /EXCLUSIVE, $
                             SET_VALUE=value, LABEL_LEFT='Button3 action')

                    ; ______________________________________
                    ;
                    ; Plot types Page
                    ; ______________________________________


   plot_types_base = WIDGET_BASE(options_base, /COLUMN, MAP=0)
   plot_types_label = WIDGET_LABEL(plot_types_base, VALUE='Plot Options')

   value = default.plot.postscript_output
   postscript_output_opt = CW_BGROUP(plot_types_base, 'PostScript output', $
                              /NO_RELEASE, UVALUE='POSTSCRIPT_OUTPUT', $
                              /NONEXCLUSIVE, $
                              SET_VALUE=[value EQ 1])

   value = default.plot.contour
   contour_opts = CW_FIELD(plot_types_base, /STRING, /ROW, VALUE=value, $
                            TITLE='CONTOUR, ', UVALUE='CONTOUR_OPTS')

   value = default.plot.contour_over
   contour_over_opts = CW_FIELD(plot_types_base, /STRING, /ROW, $
                                 VALUE=value, UVALUE='CONTOUR_OVER_OPTS', $
                                 TITLE='contour_over, ')

   value = default.plot.surface
   surface_opts = CW_FIELD(plot_types_base, /STRING, /ROW, VALUE=value, $
                            TITLE='SURFACE, ', UVALUE='SURFACE_OPTS')

   value = default.plot.shade_surf
   shade_surf_opts = CW_FIELD(plot_types_base, /STRING, /ROW, VALUE=value, $
                               TITLE='SHADE_SURF, ', $
                               UVALUE='SHADE_SURF_OPTS')

   value = default.plot.show3
   show3_opts = CW_FIELD(plot_types_base, /STRING, /ROW, VALUE=value, $
                          TITLE='SHOW3, ', UVALUE='SHOW3_OPTS')

   value = default.plot.histogram
   histogram_opts = CW_FIELD(plot_types_base, /STRING, /ROW, XSIZE=25, $
                              VALUE=value, $
                              TITLE='PLOT, ', UVALUE='CONTOUR_OPTS')


                    ; ______________________________________
                    ;
                    ; Startup Options Page
                    ; ______________________________________

   startup_base = WIDGET_BASE(options_base, /COLUMN, MAP=0)
   startup_label = WIDGET_LABEL(startup_base, VALUE='Startup')

   value = FIX(default.startup.color_table_number)
   color_table_number_opt = CW_FIELD(startup_base, /INTEGER,/ROW, XSIZE=3, $
                                      VALUE=value,$
                                      TITLE='Color table (-1,0-40)', $
                                      UVALUE='COLOR_TABLE_NUMBER')

   value = default.startup.display_scale
   aDisplayTypes = ['Linear', 'Log', 'Sqrt', 'Hist Eq', 'Raw']
   display_scale_opt = CW_BGROUP(startup_base, aDisplayTypes, $
                                  /NO_RELEASE, UVALUE='DISPLAY_SCALE_BUTTON', $
                                  /EXCLUSIVE, $
                                  SET_VALUE=value, LABEL_LEFT='Display scale')

   value = default.startup.profiles_xsize
   profiles_xsize_opt = CW_FIELD(startup_base, /LONG, /ROW, XSIZE=5, $
                                  VALUE=value, $
                                  TITLE='Profiles X size (pixels)', $
                                  UVALUE='PROFILES_XSIZE')
   value = default.startup.profiles_ysize
   profiles_ysize_opt = CW_FIELD(startup_base, /LONG, /ROW, XSIZE=5, $
                                  VALUE=value, $
                                  TITLE='Profiles Y size (pixels)', $
                                  UVALUE='PROFILES_YSIZE')


                    ; ______________________________________
                    ;
                    ; Filters Options Page
                    ; ______________________________________

   filters_base = WIDGET_BASE(options_base, /COLUMN, MAP=0)
   filters_label = WIDGET_LABEL(filters_base, VALUE='Filters')

   value = default.filter.median_size
   median_size_opt = CW_FIELD(filters_base, /INT, /ROW, XSIZE=5, $
                                 VALUE=value, $
                                 TITLE='Median width', $
                                 UVALUE='MEDIAN_SIZE')

   value = default.filter.smooth_size
   smooth_size_opt = CW_FIELD(filters_base, /INT, /ROW, XSIZE=5, $
                               VALUE=value, $
                               TITLE='Smooth width', $
                               UVALUE='SMOOTH_SIZE')

   value = default.filter.lee_size
   lee_size_opt = CW_FIELD(filters_base, /INT, /ROW, XSIZE=5, $
                               VALUE=value, $
                               TITLE='Lee width', $
                               UVALUE='LEE_SIZE')

   value = default.filter.lee_sigma
   lee_sigma_opt = CW_FIELD(filters_base, /FLOAT, /ROW, XSIZE=5, $
                               VALUE=value, $
                               TITLE='Lee sigma', $
                               UVALUE='LEE_SIGMA')

                    ; ______________________________________
                    ;
                    ; Analysis Options Page
                    ; ______________________________________

   analysis_base = WIDGET_BASE(options_base, /COLUMN, MAP=0)
   analysis_label = WIDGET_LABEL(analysis_base, VALUE='Analysis')

   value = default.analysis.centroid_fwhm
   centroid_fwhm_opt = CW_FIELD(analysis_base, /FLOAT, /ROW, XSIZE=8, $
                                 VALUE=value, $
                                 TITLE='Centroid FWHM', $
                                 UVALUE='CENTROID_FWHM')
   value = default.analysis.centroid_multiple
   centroid_multiple_opt = CW_BGROUP(analysis_base,'Centroid multiple times',$
                                      /NO_RELEASE, UVALUE='CENTROID_MULTI', $
                                      /NONEXCLUSIVE, $
                                      SET_VALUE=[value EQ 1])

                    ; ______________________________________
                    ;
                    ; Bottom buttons etc.
                    ; ______________________________________

   button_base = WIDGET_BASE(pref_root, /ROW, /ALIGN_CENTER)
   apply_button = WIDGET_BUTTON(button_base, VALUE='APPLY', $
                                 UVALUE='APPLY_BUTTON')
   ok_button = WIDGET_BUTTON(button_base, VALUE='OK', UVALUE='OK_BUTTON')
   cancel_button = WIDGET_BUTTON(button_base, VALUE='CANCEL', $
                                  UVALUE='CANCEL_BUTTON')

   WIDGET_CONTROL, /REALIZE, pref_root

   state = { parent: toplevelbase, $
             wScrollBase: options_top_base, $
             wPlotOptsBase: plot_types_base, $
             wSetupOptsBase: setup_base, $
             wButtonOptsBase: button_setup_base, $
             wPlotOptsPostscriptOutput: postscript_output_opt, $
             wPlotOptsContour: contour_opts, $
             wPlotOptsSurface: surface_opts, $
             wPlotOptsShadeSurf: shade_surf_opts, $
             wPlotOptsShow3: show3_opts, $
             wPlotOptsContourOver: contour_over_opts, $
             wPlotOptsHistogram: histogram_opts, $
             wSetupOptsTrack: track_opt, $
             wSetupOptsDefroi: defroi_opt, $
             wSetupOptsKeepRoi: keep_roi_opt, $
             wSetupOptsAutoScale: autoscale_opt, $
             wSetupOptsColorScale: color_scale_opt, $
             wSetupOptsAutoZoom: autozoom_opt, $
             wSetupOptsSliceWidth: slice_width_opt, $
             wSetupOptsAutoBlink: autoblink_opt, $
             wSetupOptsBlinkDelay: blink_delay_opt, $
             wButtonOptsButton1: button1_opts, $
             wButtonOptsButton2: button2_opts, $
             wButtonOptsButton3: button3_opts, $
             wStartupOptsBase: startup_base, $
             wStartupOptsColorTableNumber: color_table_number_opt, $
             wStartupOptsDisplayScale: display_scale_opt, $
             wStartupOptsProfilesXsize: profiles_xsize_opt, $
             wStartupOptsProfilesYsize: profiles_ysize_opt, $
             wFiltersOptsBase: filters_base, $
             wFiltersOptsMedianSize: median_size_opt, $
             wFiltersOptsSmoothSize: smooth_size_opt, $
             wFiltersOptsLeeSize: lee_size_opt, $
             wFiltersOptsLeeSigma: lee_sigma_opt, $
             wAnalysisOptsBase: analysis_base, $
             wAnalysisOptsCentroidFWHM: centroid_fwhm_opt, $
             wAnalysisOptsCentroidMultiple: centroid_multiple_opt, $
             wMapped: setup_base, $
             Version: version }
   
   WIDGET_CONTROL, pref_base, SET_UVALUE=state, /NO_COPY
   
   XMANAGER, 'mview_prefs', pref_root, /NO_BLOCK
END 

; _____________________________________________________________________________

PRO mview_image_analysis_case, sState, x, y
   COMPILE_OPT IDL2, HIDDEN

   CASE STRUPCASE(sState.analysis_routine) OF
      'CENTROID': BEGIN
         mview_analysis_centroid, sState, x, y
      END 
      ELSE: MESSAGE, 'Analysis case unknown: ' + routine, /INFO
   ENDCASE

END

; _____________________________________________________________________________

PRO image_widget_button_case, sEvent, sLocalState, sGlobalState
   COMPILE_OPT IDL2, HIDDEN

   button_number = sEvent.press

   IF sGlobalState.autoblinking NE 1b THEN BEGIN

      CASE button_number OF
         1: BEGIN
            button_action = sGlobalState.sPrefs.button.button1

            IF sGlobalState.analysis_loop EQ 1b THEN BEGIN
               mview_image_analysis_case, sGlobalState, $
                sEvent.x, sEvent.y
               return
            ENDIF
         END
         2: button_action = sGlobalState.sPrefs.button.button2
         4: BEGIN
            button_action = sGlobalState.sPrefs.button.button3
            IF sGlobalState.analysis_loop EQ 1b THEN BEGIN
                    ; Stop the analysis point/click loop
               sGlobalState.analysis_loop = 0b
               mview_wmessage, sGlobalState, ' '
               return
            ENDIF
         END
         ELSE: return
      ENDCASE

      CASE button_action OF
         0: BEGIN
                    ; define region and update stats
            mview_define_region, sGlobalState, $
             sEvent.x, sEvent.y
         END
         1: BEGIN
                    ; draw profile
            mview_profiles, sGlobalState, $
             sEvent.x, sEvent.y
         END
         2: BEGIN
                    ; blink images
            mview_blink_images, sGlobalState
            
            IF sGlobalState.sPrefs.setup.autoblink EQ 1b $
             THEN BEGIN
               sGlobalState.autoblinking = 1b
               WIDGET_CONTROL, sLocalState.wLabel, $
                TIMER=sGlobalState.sPrefs.setup.blink_delay
            ENDIF
            
         END 
         3: BEGIN
                    ; Select point
            mview_trace_cursor, sGlobalState, $
             sEvent.x, sEvent.y
         END 
         ELSE:
      ENDCASE
   
   ENDIF ELSE BEGIN
      sGlobalState.autoblinking = 0b
      WIDGET_CONTROL, sLocalState.wRoot, /CLEAR_EVENTS
   ENDELSE

END

; _____________________________________________________________________________

PRO image_widget_motion_case, sEvent, sLocalState, sGlobalState
   COMPILE_OPT IDL2, HIDDEN

   IF (sGlobalState.sPrefs.setup.track EQ 1) THEN BEGIN

      CASE sGlobalState.button_down OF 
         0: mview_trace_cursor, sGlobalState, sEvent.x, sEvent.y
         1: BEGIN
            CASE sGlobalState.sPrefs.button.button1 OF
               0: BEGIN
                  mview_define_region, sGlobalState, $
                   sEvent.x, sEvent.y
               END 
               ELSE: 
            ENDCASE 
         END 
         2: BEGIN
         END 
         4: BEGIN
         END
         ELSE: mview_trace_cursor, sGlobalState, sEvent.x, sEvent.y
      ENDCASE 
   ENDIF

END

; _____________________________________________________________________________

PRO image_widget_event, sEvent
   COMPILE_OPT IDL2, HIDDEN

   wLocalStateHandler = WIDGET_INFO(sEvent.handler, /CHILD)
   WIDGET_CONTROL, wLocalStateHandler, GET_UVALUE=sLocalState, /NO_COPY

   WIDGET_CONTROL, sLocalState.wStateHandler, $
    GET_UVALUE=sGlobalState, /NO_COPY

   struct_name = TAG_NAMES(sEvent, /STRUCTURE_NAME)
   
   IF STRUPCASE(struct_name) EQ 'WIDGET_BASE' THEN BEGIN
      offset = 20
      newx = (sEvent.x - offset)
      newy = (sEvent.y - offset)

;      IF newx GT sGlobalState.x_image_sz THEN newx = sGlobalState.x_image_sz
;      IF newy GT sGlobalState.y_image_sz THEN newy = sGlobalState.y_image_sz

      sGlobalState.x_draw_sz = newx
      sGlobalState.y_draw_sz = newy

      WIDGET_CONTROL, sLocalState.wDraw, XSIZE=newx, YSIZE=newy

   ENDIF ELSE BEGIN

      WIDGET_CONTROL, sEvent.id, GET_UVALUE=event_uval
      CASE STRUPCASE(event_uval) OF
         'IMAGE_DRAW': BEGIN
            CASE sEvent.type OF
               0: BEGIN
                    ; BUTTON PRESS
                  image_widget_button_case, sEvent, sLocalState, sGlobalState
               END
               2: BEGIN
                    ; MOTION EVENT
                  image_widget_motion_case, sEvent, sLocalState, sGlobalState
               END 
               ELSE:
            ENDCASE
         END

         'IMAGE_LABEL': BEGIN
                    ; TIMER EVENT
            IF (sGlobalState.autoblinking EQ 1b) THEN BEGIN
                    ; If we still want to autoblink
                    ; (if this isn't a remnant of an old autoblink)
               mview_blink_images, sGlobalState
            
               WIDGET_CONTROL, sEvent.id, $
                TIMER = sGlobalState.sPrefs.setup.blink_delay
            ENDIF
         END
         
         'ZOOM_BUTTON_PRESS': BEGIN
            CASE sEvent.value OF
               'ZOOM_PLUS': mview_zoom_plus, sGlobalState
               'ZOOM_MINUS': mview_zoom_minus, sGlobalState
               'ZOOM_ZERO': mview_zoom_zero, sGlobalState
               ELSE:
            ENDCASE
         END
         ELSE: 
      ENDCASE
   ENDELSE

   ;;WIDGET_CONTROL, sLocalState.wRoot, /CLEAR_EVENTS 
   
   WIDGET_CONTROL, sLocalState.wStateHandler, $
    SET_UVALUE=sGlobalState, /NO_COPY
   
   WIDGET_CONTROL, wLocalStateHandler, SET_UVALUE=sLocalState, /NO_COPY
   
END

; _____________________________________________________________________________


PRO image_widget, TopLevelBase, wRoot, $
                  VALUE=image, LABEL=label, SCALE_LABEL=scale_label, $
                  STATE_HANDLER=wStateHandler, $
                  TITLE=title, RETAIN=retain, $
                  X_SCROLL_SIZE=x_scroll, Y_SCROLL_SIZE=y_scroll, $
                  XSIZE=xsize, YSIZE=ysize

   COMPILE_OPT IDL2, HIDDEN

   IF N_ELEMENTS(label) LE 0 THEN label = 'frame1'
   IF N_ELEMENTS(scale_label) LE 0 THEN scale_label = ' '
   IF N_ELEMENTS(retain) LE 0 THEN retain = 2
   IF N_ELEMENTS(wStateHandler) LE 0 THEN BEGIN
      IF N_ELEMENTS(TopLevelBase) LE 0 THEN wStateHandler = 0L ELSE BEGIN
         wChild = WIDGET_INFO(TopLevelBase, /CHILD)
         wStateHandler = WIDGET_INFO(wChild, /SIBLING)
      ENDELSE
   END

   IF N_ELEMENTS(image) GT 2 THEN BEGIN
      image_sz = SIZE(image)
      offset = 20
      IF N_ELEMENTS(xsize) LE 0 THEN xsize = image_sz[1]-offset
      IF N_ELEMENTS(ysize) LE 0 THEN ysize = image_sz[2]-offset
   ENDIF 

   IF N_ELEMENTS(x_scroll) LE 0 THEN x_scroll = 450
   IF N_ELEMENTS(y_scroll) LE 0 THEN y_scroll = 450

   wRoot = WIDGET_BASE(GROUP_LEADER=TopLevelBase, /COLUMN, MAP=0, $
                        TLB_FRAME_ATTR=8, $
                        /TLB_SIZE_EVENTS, $
                        TITLE = title, $
                        UVALUE = 'IMAGE_BASE', $
                        RESOURCE_NAME='image', $
                        XPAD=0, YPAD=0, XOFFSET=0, YOFFSET=0, SPACE=0)

   wBase = WIDGET_BASE(wRoot, /COLUMN, /ALIGN_CENTER, $
                        XPAD=0, YPAD=0, XOFFSET=0, YOFFSET=0, SPACE=0)
   wTopBase = WIDGET_BASE(wBase, /ROW, XPAD=0, YPAD=0, /ALIGN_RIGHT, $
                          XOFFSET=0, YOFFSET=0, SPACE=0)
   wTopLeftBase = WIDGET_BASE(wTopBase, /COLUMN, XPAD=0, YPAD=0, $
                              XOFFSET=0, YOFFSET=0, SPACE=0, /BASE_ALIGN_LEFT)
   wTopRightBase = WIDGET_BASE(wTopBase, /COLUMN, XPAD=0, YPAD=0, $
                               XOFFSET=0, YOFFSET=0, SPACE=0, $
                               /BASE_ALIGN_RIGHT)

   wButtonBase = WIDGET_BASE(wTopRightBase, /ROW, /ALIGN_LEFT, $
                             XPAD=0, YPAD=0, XOFFSET=0, YOFFSET=0, SPACE=0)
   aButtonUvals = ['ZOOM_MINUS','ZOOM_ZERO','ZOOM_PLUS']
   aButtons = ['-','0','+']
   wZoomButtons = CW_BGROUP(wButtonBase, aButtons, FONT='fixed', $
                             BUTTON_UVALUE=aButtonUvals, $
                             /ROW, /NO_RELEASE, UVALUE='ZOOM_BUTTON_PRESS',$
                             SPACE=0, XPAD=0, YPAD=0)

   wLabelBase = WIDGET_BASE(wTopLeftBase, /ROW, /ALIGN_RIGHT, $
                            RESOURCE_NAME='label', $
                            XPAD=0, YPAD=0, XOFFSET=0, YOFFSET=0, SPACE=0)

   wLabelLeftBase = WIDGET_BASE(wLabelBase, /ROW, /BASE_ALIGN_LEFT, $
                                 XPAD=0, YPAD=0, $
                                 XOFFSET=0, YOFFSET=0, SPACE=0)

   wDescriptionLabel = WIDGET_LABEL(wLabelLeftBase, VALUE=label, $
                                     /ALIGN_RIGHT, $
                                     /DYNAMIC_RESIZE, UVALUE='IMAGE_LABEL', $
                                     FONT='fixed')

   wLabelRightBase = WIDGET_BASE(wLabelBase, /ROW, /BASE_ALIGN_RIGHT, $
                                  XPAD=0, YPAD=0, $
                                  XOFFSET=0, YOFFSET=0,SPACE=0)

   wScaleLabel = WIDGET_LABEL(wLabelRightBase, VALUE=scale_label, $
                               /ALIGN_RIGHT, $
                               /DYNAMIC_RESIZE, UVALUE='SCALE_LABEL', $
                               FONT='fixed')

   wDraw = WIDGET_DRAW(wBase, XSIZE=xsize, YSIZE=ysize, $
                        /MOTION_EVENTS, /BUTTON_EVENTS, $
                        /SCROLL, RETAIN = retain, $
                        X_SCROLL_SIZE=x_scroll, $
                        Y_SCROLL_SIZE=y_scroll, $
                        UVALUE = 'IMAGE_DRAW', $
                        RESOURCE_NAME='draw')

   WIDGET_CONTROL, /REALIZE, wRoot
   WIDGET_CONTROL, GET_VALUE = draw_index, wDraw

   IF N_ELEMENTS(image) GT 2 THEN BEGIN

      save_win = !D.WINDOW
      saved_device = !D.NAME
      
      CASE STRUPCASE(!VERSION.OS_FAMILY) OF
         'WINDOWS': SET_PLOT, 'WIN'
         'MACOS': SET_PLOT, 'MAC'
         ELSE: SET_PLOT, 'X'
      ENDCASE
      WSET, draw_index
      TV, BYTSCL(image, MAX=MAX(image), MIN=MIN(image))

      IF win_valid(save_win) THEN WSET, save_win
      SET_PLOT, saved_device

   ENDIF
   
   sState = { wRoot: wRoot, $
              wBase: wBase, $
              wLabel: wDescriptionLabel, $
              wScaleLabel: wScaleLabel, $
              wDraw: wDraw, $
              wStateHandler: wStateHandler, $
              draw_index: draw_index }

   WIDGET_CONTROL, wBase, SET_UVALUE=sState, /NO_COPY

   XMANAGER, 'image_widget', wRoot, /NO_BLOCK

END 

; _____________________________________________________________________________

PRO mview, ims, header, LABELS=labels, TRUE_COLOR=use_true_color, $
           TITLE=WinTitle, GROUP_LEADER=group, WINDEX=windex, $
           NO_COPY=no_copy, MINIMUM=minimum, MAXIMUM=maximum, $
           RETAIN=retain, AUTOSCALE=autoscale, $
           LOG_SCALE=log_scale, LINEAR_SCALE=linear_scale, $
           SQRT_SCALE=sqrt_scale, HIST_SCALE=hist_scale, $
           RAW_SCALE=raw_scale, DEBUG=debug

   COMPILE_OPT IDL2
   COMMON MVIEW, handler

; ______________________________________
;
; Check input
; ______________________________________

   instance_number = XREGISTERED('mview', /NOSHOW) + 1L
   strVersion = rcs_revision(' $Revision: 2.10 $ ')
   strVersion_date = rcs_date(' $Date: 2001/08/06 15:58:03 $ ')

   IF N_ELEMENTS(group) LE 0 THEN group = 0L
   IF N_ELEMENTS(labels) LE 0 THEN labels=['frame1']
   IF N_ELEMENTS(WinTitle) LE 0 THEN WinTitle = "Mview (v"+strVersion+")"
   strTitleFormat = '(A,1X,"[",I0,"]")'
   strWinTitle = STRING(FORMAT=strTitleFormat, WinTitle, instance_number)

   strImageTitle = strWinTitle

   IF NOT KEYWORD_SET(use_true_color) THEN use_true_color = 0b

   IF N_ELEMENTS(ims) GT 0 THEN BEGIN
      ims_sz = SIZE(ims)

      CASE ims_sz[0] OF 

         0: BEGIN
            mview_acslog_read, sState, ims, image, $
             header, header_udl, header_eng1, header_eng2, $
             ERROR=error_flag, DEBUG=debug
            labels = 'Entry ' + STRTRIM(ims, 2)
            IF error_flag EQ 1 THEN return
         END 

         1: BEGIN
            mview_acslog_read, sState, ims, image, $
             header, header_udl, header_eng1, header_eng2, $
             ERROR=error_flag, DEBUG=debug
            labels = 'Entry ' + STRTRIM(ims, 2)
            IF error_flag EQ 1 THEN return
         END 
         
         ELSE: BEGIN
            IF KEYWORD_SET(no_copy) THEN image = TEMPORARY(ims) $
            ELSE image = ims
         END
      ENDCASE

   ENDIF ELSE image = (SIN(SHIFT(DIST(256),128,128)/8 + 2) * ((DIST(256) < 160)/160.0)^3) > 0.0 < 1.0

; ______________________________________

; Define some stuff
; ______________________________________

   ximsize = (SIZE(image))[1]
   yimsize = (SIZE(image))[2]

   x_dw_sz = ximsize < 450
   y_dw_sz = yimsize < 450

   x_zm_sz = 128
   y_zm_sz = 128

   large_size = ximsize > yimsize
   unsquareness = ABS(ximsize-yimsize) / FLOAT(large_size)

   IF unsquareness GT 0.05 THEN BEGIN
      max_size = x_zm_sz < y_zm_sz
      scale_factor = (large_size / FLOAT(max_size)) > 1
      x_orig_sz = LONG(ximsize / scale_factor)
      y_orig_sz = LONG(yimsize / scale_factor)
   ENDIF ELSE BEGIN
      x_orig_sz = x_zm_sz
      y_orig_sz = y_zm_sz
   ENDELSE

   lastx=-1L
   lasty=-1L
   
   zoom_min = -5L
   zoom_max = 50L
   zoom_factor = 1L

   required_major_version = 5
   required_minor_version = 3
   aIDLVersion = STRSPLIT(!VERSION.RELEASE, '.', /EXTRACT)
   idl_major_version = FIX(aIDLVersion[0])
   idl_minor_version = FIX(aIDLVersion[1])

   IF idl_major_version LT required_major_version THEN BEGIN
      PRINT, 'Sorry IDL version '+STRTRIM(idl_major_version, 2)+$
       ' is not supported.'
      return
   ENDIF ELSE IF idl_major_version EQ required_major_version THEN BEGIN
      IF idl_minor_version LT required_minor_version THEN BEGIN
         PRINT, 'Sorry this version requires at least IDL '+$
          STRTRIM(required_major_version, 2)+'.'+$
          STRTRIM(required_minor_version, 2)+', try MVIEW1 instead.'
         return
      ENDIF 
   ENDIF 
   MenuList = [ '1\File', $
                '1\Open', $
                '0\ACS_LOG', '0\SDI', '0\FITS', '0\Image', '2\Region', $
                '1\Save', $
                '1\Frame',  '0\FITS', '2\Image', $
                '1\Screen', '0\FITS', '2\Image', $
                '3\Sequence', '2 \MPEG', $
                '1\Print', $
                '1\Frame',  '0\PS file', '2\Printer', $
                '1\Screen', '0\PS file', '2\Printer', $
                '3\All', $
                '0\PS file', '2\Printer', $
                '0\Print setup', '0\Reset', $
                '2\Exit', $
                '1\View', $
                '0\Next frame', '0\Prev frame', '0\Refresh', '0\Autoscale', $
                '1\Scale', $
                '0\Linear', '0\Log', '0\Sqrt', '0\Histogram Eq', '2\Raw', $
                '1\Header', $
                '0\Standard', '0\UDL', '0\Engineering1', '2\Engineering2', $
                '0\Bring forward', $
                '2\Shrink to fit', $
                '1\Options', $
                '0\Preferences', '0\Reset region', '1\Image operations', $
                '0\Rebin', '0\Logarithm', '0\Logarithm10', $
                '0\Square root', '0\Square', '1\Subtraction', $
                '0\Constant', '3\Image', $
                '0\ACS_LOG', '2\FITS', $
                '1\Division', $
                '0\Constant', '3\Image', $
                '0\ACS_LOG', '2\FITS', $
                '2\'+"Two's complement", $
                '1\Plot types', $
                '0\Contour', '0\Contour_over', '0\Histogram', $
                '0\Surface', '0\Shade_surf', '2\Show3', $
                '3\Filters', $
                '0\Median', '0\Smooth', '0\Lee', '0\Roberts', '2\Sobel', $
                '1\Analysis', $
                '0\Image stats', '0\Region stats', '0\Plot slice', $
                '0\Centroid', '0\Histogram region', $
                '2\Radial plot', $
                '1\Tools', '0\Annotate', '2\Xloadct', $
                '1\Help', '0\Help', '2\About' ]

   statfields = [ '  mean ', $
                  ' stdev ', $
                  'median ', $
                  '   min ', $
                  '   max ', $
                  ' total ' ]

   aResources = MAKE_ARRAY(N_ELEMENTS(MenuList), /STRING)
   refresh_index = WHERE(MenuList EQ '0\Refresh', icount)
   IF icount GT 0 THEN aResources[ refresh_index[0] ] = 'refresh'

   rangefields = [ 'Z1   ', 'Z2   ']

; ______________________________________

; Build Widget
; ______________________________________


   wRoot = WIDGET_BASE(GROUP_LEADER=Group, UVALUE='ROOT', TITLE=strWinTitle, $
                        /COLUMN, /MAP, MBAR=wMbar, /TLB_KILL_REQUEST_EVENTS, $
                        RESOURCE_NAME='mview', RNAME_MBAR='menubar', $
                        XPAD=0, YPAD=0, XOFFSET=0, YOFFSET=0, SPACE=0)

   wBase = WIDGET_BASE(wRoot, /COLUMN, FRAME=0, XPAD=0, YPAD=0, SPACE=0)

   wMenuBar = CW_PDMENU(wMbar, /RETURN_FULL_NAME, /MBAR, /HELP, $
                         MenuList, UVALUE='MENU')

   wWinBase = WIDGET_BASE(wBase, /COLUMN, RESOURCE_NAME='control', $
                           XPAD=0, YPAD=0, SPACE=0)

   wReportBase = WIDGET_BASE(wWinBase, /ROW, FRAME=0, $
                              XPAD=0, YPAD=0, SPACE=0)
   wStatBase = WIDGET_BASE(wReportBase, /COLUMN, XPAD=0, YPAD=0, SPACE=0)

   report_box_xsize = 25
   report_box_ysize = 6
   report_box_scr_ysize = y_zm_sz - 2.0*!D.Y_CH_SIZE - 5

   wStatTopBase = WIDGET_BASE(wStatBase, /ROW, XPAD=0, YPAD=0, SPACE=0, $
                               /ALIGN_TOP)
   wStatText = WIDGET_TEXT(wStatTopBase, XSIZE=report_box_xsize, $
                            YSIZE=report_box_ysize, $
                            SCR_YSIZE=report_box_scr_ysize, $
                            FONT='fixed', VALUE=statfields)

   wStatBottomBase = WIDGET_BASE(wStatBase, /ROW, XPAD=0, YPAD=0, SPACE=0, $
                               /ALIGN_BOTTOM)
   wPixText = WIDGET_TEXT(wStatBottomBase, XSIZE=report_box_xsize, YSIZE=1, $
                           ;;SCR_YSIZE=2.0*!D.Y_CH_SIZE+5, $
                           FONT='fixed', VALUE='[,] ', $
                           /ALIGN_TOP)

   wOrigBase = WIDGET_BASE(wReportBase, /COLUMN, RESOURCE_NAME='original', $
                            XPAD=0, YPAD=1, SPACE=0)
   wOrigDraw = WIDGET_DRAW(wOrigBase, XSIZE=x_zm_sz, YSIZE=y_zm_sz, $
                            /MOTION_EVENTS, /BUTTON_EVENTS, $
                            UVALUE='ORIG_DRAW')
   
   wZoomBase = WIDGET_BASE(wReportBase, /ROW, RESOURCE_NAME='zoom', $
                            XPAD=1, YPAD=1, SPACE=0)

   wZoomDraw = WIDGET_DRAW(wZoomBase, XSIZE=x_zm_sz, YSIZE=y_zm_sz, $
                            /MOTION_EVENTS, /BUTTON_EVENTS, $
                            UVALUE='ZOOM_DRAW')

   wZoomSlider = WIDGET_SLIDER(wZoomBase, YSIZE = y_zm_sz, /DRAG, $
                                MINIMUM = zoom_min, MAXIMUM = zoom_max, $
                                VALUE = zoom_factor, /SUPPRESS_VALUE, $
                                XSIZE = 10, /VERTICAL, UVALUE='ZOOM_SLIDER')

   cbar_sz = (x_zm_sz * 2) + (report_box_xsize * !D.X_CH_SIZE) + (10 * 2)
   wBarBase = WIDGET_BASE(wWinBase, /COLUMN, /ALIGN_CENTER, $
                           RESOURCE_NAME='colorbar', XPAD=0, YPAD=0)

   wCbarDraw = WIDGET_DRAW(wBarBase, XSIZE=cbar_sz, UVALUE='CBAR_DRAW', $
                            YSIZE=5, /BUTTON_EVENTS, /MOTION_EVENTS, /FRAME)

   wRangeBase = WIDGET_BASE(wBarBase, /ROW, /ALIGN_CENTER, XPAD=0, YPAD=0)

   wRangeLeftBase = WIDGET_BASE(wRangeBase, /COLUMN, /BASE_ALIGN_CENTER, $
                                 XPAD=0, YPAD=0)
   wRangeRightBase = WIDGET_BASE(wRangeBase, /COLUMN, /BASE_ALIGN_CENTER, $
                                  XPAD=0, YPAD=0)
   slider_resolv = 1000

   wMinSlider = WIDGET_SLIDER(wRangeLeftBase, MINIMUM=0, $
                               MAXIMUM=slider_resolv, /DRAG, $
                               VALUE=0, UVALUE='MIN_SLIDER', $
                               XSIZE=cbar_sz/2, $
                               YSIZE=10, /SUPPRESS_VALUE)

   wMaxSlider = WIDGET_SLIDER(wRangeRightBase, MINIMUM=0, $
                               MAXIMUM=slider_resolv, /DRAG, $
                               VALUE=99, UVALUE='MAX_SLIDER', $
                               XSIZE=cbar_sz/2, $
                               YSIZE=10, /SUPPRESS_VALUE)

   wRangeZ1Field = CW_FIELD(wRangeLeftBase, /FLOATING, /ROW, TITLE='min', $
                             UVALUE='Z1_FIELD', FONT='fixed', $
                             FIELDFONT='fixed', /RETURN_EVENTS)
   
   wRangeZ2Field = CW_FIELD(wRangeRightBase, /FLOATING, /ROW, TITLE='max', $
                             UVALUE='Z2_FIELD', FONT='fixed', $
                             FIELDFONT='fixed', /RETURN_EVENTS)

   wMessageText = WIDGET_TEXT(wWinBase, YSIZE = 1, FONT='fixed', $
                           UVALUE = 'MESSAGE')

                    ; create drawboxbase and all children
   WIDGET_CONTROL, /REALIZE, wBase
   WIDGET_CONTROL, wBase, UPDATE=0
   WIDGET_CONTROL, /HOURGLASS

; ______________________________________

; Setup Widget State
; ______________________________________

   image_widget, wRoot, wImage, STATE_HANDLER=wBase,  VALUE=image[*,*,0], $
    X_SCROLL=x_dw_sz, Y_SCROLL=y_dw_sz, TITLE=strImageTitle, LABEL=labels[0], $
    RETAIN=retain

   image_child = WIDGET_INFO(wImage, /CHILD)
   WIDGET_CONTROL, image_child, GET_UVALUE = image_state

                    ; get window index of image window
   WIDGET_CONTROL, GET_VALUE=orig_index, wOrigDraw
   WIDGET_CONTROL, GET_VALUE=zoom_index, wZoomDraw
   WIDGET_CONTROL, GET_VALUE=cbar_index, wCbarDraw
   WIDGET_CONTROL, GET_VALUE=draw_index, image_state.wDraw

   cbar_height = 5
   cbot = 0
   ncolors = !D.TABLE_SIZE

   frame_min = DOUBLE(MIN(image[*,*,0]))
   frame_max = DOUBLE(MAX(image[*,*,0]))
   IF N_ELEMENTS(minimum) GT 0 THEN im_min = DOUBLE(minimum[0]) $
   ELSE im_min = frame_min

   IF N_ELEMENTS(maximum) GT 0 THEN im_max = DOUBLE(maximum[0]) $
   ELSE im_max = frame_max

   im_sz = SIZE(image[*,*,0])

   colorbar = make_colorbar(cbar_sz, HEIGHT=cbar_height, $
                             MIN=im_min, MAX=im_max)

   sPrefs = mview_restore_prefs(strFileName, strVersion)
   IF sPrefs.setup.autozoom LE 0 THEN sPrefs.setup.autozoom=1.0

   image_ptr = PTR_NEW(image, /NO_COPY)

   IF N_ELEMENTS(header) LE 0 THEN header_ptr = PTR_NEW() $
   ELSE header_ptr = PTR_NEW(header)

   IF N_ELEMENTS(header_udl) LE 0 THEN udl_ptr = PTR_NEW() $
   ELSE udl_ptr = PTR_NEW(header_udl)

   IF N_ELEMENTS(header_eng1) LE 0 THEN eng1_ptr = PTR_NEW() $
   ELSE eng1_ptr = PTR_NEW(header_eng1)

   IF N_ELEMENTS(header_eng2) LE 0 THEN eng2_ptr = PTR_NEW() $
   ELSE eng2_ptr = PTR_NEW(header_eng2)

   IF N_ELEMENTS(labels) LE 0 THEN label_ptr = PTR_NEW() $
   ELSE label_ptr = PTR_NEW(labels)

   region_ptr = PTR_NEW()
   region_corners_ptr = PTR_NEW()

   color_red_ptr = (color_green_ptr = (color_blue_ptr = PTR_NEW()))

   sStats = mview_stat_skel()

   CD, CURRENT=current_working_directory

; ______________________________________

; Do startup prefs stuff
; ______________________________________

   scale_type = 'LINEAR' ; default
   CASE sPrefs.startup.display_scale OF
      0b: scale_type = 'LINEAR'
      1b: scale_type = 'LOG'
      2b: scale_type = 'SQRT'
      3b: scale_type = 'HIST_EQ'
      4b: scale_type = 'RAW'
      ELSE: scale_type = 'LINEAR'
   ENDCASE

   IF KEYWORD_SET(log_scale) THEN scale_type = 'LOG'
   IF KEYWORD_SET(sqrt_scale) THEN scale_type = 'SQRT'
   IF KEYWORD_SET(linear_scale) THEN scale_type = 'LINEAR'
   IF KEYWORD_SET(hist_scale) THEN scale_type = 'HIST_EQ'
   IF KEYWORD_SET(raw_scale) THEN scale_type = 'RAW'   

   IF (scale_type NE 'RAW') THEN BEGIN
      IF (sPrefs.startup.color_table_number NE -1) THEN $
       LOADCT, sPrefs.startup.color_table_number, /SILENT
   ENDIF

   IF sPrefs.setup.autoscale EQ 1 THEN autoscale = 1b

; ______________________________________

; Define Widget State Structure
; ______________________________________

   sState = { $
             wRoot: wRoot, $ ;  ______________________ Widgets
             wBase: wBase, $
             wDrawBase: image_state.wRoot, $
             wDraw: image_state.wDraw, $
             wDrawLabel: image_state.wLabel, $
             wScaleLabel: image_state.wScaleLabel, $
             wPixelText: wPixText, $
             wMessageText: wMessageText, $
             wProfileWin: -1L, $
             wOrigBase: wOrigBase, $
             wOrigDraw: wOrigDraw, $
             wZoomBase: wZoomBase, $
             wZoomDraw: wZoomDraw, $
             wStatText: wStatText, $
             wZ1Field: wRangeZ1Field, $
             wZ2Field: wRangeZ2Field, $
             wCbarDraw: wCbarDraw, $
             wMinSlider: wMinSlider, $
             wMaxSlider: wMaxSlider, $
             draw_win: draw_index, $ ;  ______________ Windows
             zoom_win: zoom_index, $
             orig_win: orig_index, $
             cbar_win: cbar_index, $
             ycut_win: -1L, $
             xcut_win: -1L, $
             pImage: image_ptr, $ ; ______________________ Data 
             pActiveRegion: region_ptr, $
             pActiveRegionCorners: region_corners_ptr, $
             pHeader: header_ptr, $
             pHeaderUdl: udl_ptr, $
             pHeaderEng1: eng1_ptr, $
             pHeaderEng2: eng2_ptr, $
             pLabels: label_ptr, $
             colorbar: colorbar, $
             pColorTableRed: color_red_ptr, $
             pColorTableGreen: color_green_ptr, $
             pColorTableBlue: color_blue_ptr, $
             x_image_sz: im_sz[1], $ ; _______________ Internal info 
             y_image_sz: im_sz[2], $
             x_draw_sz: x_dw_sz, $
             y_draw_sz: y_dw_sz, $
             x_zoom_sz: x_zm_sz, $
             y_zoom_sz: y_zm_sz, $
             x_orig_sz: x_orig_sz, $
             y_orig_sz: y_orig_sz, $
             zoom_xcor: 0, $
             zoom_ycor: 0, $
             main_zoom_factor: FLOAT(sPrefs.setup.autozoom), $
             slider_resolution: slider_resolv, $
             initial_open: 1b, $
             debug: BYTE(KEYWORD_SET(debug)), $
             use_true_color: use_true_color, $
             instance: instance_number, $
             version_date: strVersion_date, $
             version: strVersion, $
             idl_major_version: idl_major_version, $
             idl_minor_version: idl_minor_version, $
             current_frame: 0L, $
             frame_min: frame_min, $
             frame_max: frame_max, $
             min: im_min, $
             max: im_max, $
             x: -1L, $
             y: -1L, $
             lastx: -1L, $
             lasty: -1L, $
             scale_type: scale_type, $
             autoblinking: 0b, $
             analysis_loop: 0b, $
             analysis_routine: '', $
             button_down: 0b, $
             button_down_x: -1L, $
             button_down_y: -1L, $
             stattxt: statfields , $
             sStats: sStats, $
             last_file_path: current_working_directory, $
             centroid_fwhm: -1L, $
             zoom_min: zoom_min, $ ; ___________________ Preferences
             zoom_max: zoom_max, $
             zoom_factor: zoom_factor, $
             sPrefs: sPrefs }

; ______________________________________

; Update Widget and hand off
; ______________________________________

   IF KEYWORD_SET(autoscale) THEN $
    mview_autoscale_display, sState, DEBUG=debug $
   ELSE mview_update_widget, sState, DEBUG=debug
   WIDGET_CONTROL, sState.wBase, UPDATE=1
   WIDGET_CONTROL, wImage, MAP=1

   IF sPrefs.setup.autostats EQ 1 THEN BEGIN
      n_frame = sState.current_frame
      n_pixels = N_ELEMENTS((*sState.pImage)[*,*,n_frame])
      IF n_pixels GT 1.2e6 THEN n_subs = 1.2e6
      mview_update_stats, sState, RANDOM=n_subs, DEBUG=debug
   ENDIF

   IF !D.NAME EQ 'X' THEN DEVICE, CURSOR_STANDARD=33

   windex = draw_index ; return draw window index via keyword WINDEX

   strMessage = STRING(FORMAT='("Loaded ",I0," x ",I0," image into frame1")',$
                        sState.x_image_sz, sState.y_image_sz)
   mview_wmessage, sState, strMessage

                    ; If not defined or valid
                    ; set the common block variable
   IF N_ELEMENTS(handler) LE 0 THEN handler = sState.wRoot $
   ELSE BEGIN      
      IF NOT WIDGET_INFO(handler, /VALID) THEN handler = sState.wRoot
   ENDELSE

                    ; restore state information
   WIDGET_CONTROL, wBase, SET_UVALUE = sState, /NO_COPY   

   WIDGET_CONTROL, wRoot, /CLEAR_EVENTS
   XMANAGER, 'mview', wRoot, /NO_BLOCK

END

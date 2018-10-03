;+
; $Id: acs_image_ps.pro,v 1.2 2001/02/28 19:36:56 mccannwj Exp $
;
; NAME:
;     ACS_IMAGE_PS
;
; PURPOSE:
;     Generate a postscript file from the specified image.
;
; CATEGORY:
;     ACS/Output
;
; CALLING SEQUENCE:
;     ACS_IMAGE_PS, input [, FILENAME=filename, SCALE_TYPE=scale_type, $
;               MINIMUM=minimum, MAXIMUM=maximum, $
;               XRANGE=x_range, YRANGE=y_range, ZRANGE=z_range, $
;               NO_INVERT=no_invert, /PRINTER, $
;               TITLE_LEFT=title_left, TITLE_RIGHT=title_right, $
;               LABEL_COL1=label_col1, LABEL_COL2=label_col2]
;
; INPUTS:
;     input - (2D array) image file to print
;             (3D array) stack of images to print one per page
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     FILENAME    - (STRING) specify name for postscript file [idl.ps]
;     LABEL_COL1  - (STRARR) list of strings to be output in a column
;                    at the bottom left side of page
;     LABEL_COL2  - (STRARR) list of strings to be output in a column
;                    at the bottom right side of page
;     MINIMUM     - (NUMBER) minimum value of image to be considered
;     MAXIMUM     - (NUMBER) maximum value of image to be considered
;     NO_INVERT   - (BOOLEAN) don't invert the color table to save toner
;     PRINTER     - (BOOLEAN) send output to the printer device
;     SCALE_TYPE  - (STRING) specify type of image scaling. ['LINEAR']
;                    Allowed to be: 'RAW','LINEAR','LOG','SQRT','HIST_EQ'
;                    or use one of these keywords:
;                      /RAW, /LINEAR, /LOG, /SQRT, /HIST_EQ
;     TITLE_LEFT  - (STRING) text to be put at top left of page
;     TITLE_RIGHT - (STRING) text to be put at top right of page
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
;       Thu Jun 15 21:07:25 2000, William Jon McCann
;       <mccannwj@acs13.+ball.com>
;-

FUNCTION acs_make_colorbar, width, HEIGHT=height, MINIMUM=minimum, $
                            MAXIMUM=maximum
   COMPILE_OPT IDL2

   IF N_ELEMENTS( width ) LE 0 THEN BEGIN
      MESSAGE, 'width not specified.', /INFO
      return, [-1]
   ENDIF

   IF N_ELEMENTS( height ) LE 0 THEN height = 5
   IF N_ELEMENTS( minimum ) LE 0 THEN minimum = 0
   IF N_ELEMENTS( maximum ) LE 0 THEN maximum = 100

   value_range = ( maximum - minimum ) > 0
   colorbar = ( minimum + value_range * FINDGEN(width) / FLOAT(width-1) ) # $
    REPLICATE( 1, height )

   return, colorbar
END

PRO acs_image_ps, input, SCALE_TYPE=scale_type, $
                  MINIMUM=minimum, MAXIMUM=maximum, FILENAME=filename, $
                  XRANGE=x_range, YRANGE=y_range, ZRANGE=z_range, $
                  MULTI=multi, NO_INVERT=no_invert, $
                  PRINTER=printer_device, ERROR=error_flag, $
                  TITLE_LEFT=title_left, TITLE_RIGHT=title_right, $
                  LABEL_COL1=label_col1, LABEL_COL2=label_col2, $
                  LOG_SCALE=log_scale, SQRT_SCALE=sqrt_scale, $
                  RAW_SCALE=raw_scale, HIST_EQ_SCALE=hist_eq_scale, $
                  LINEAR_SCALE=linear_scale

   IF KEYWORD_SET( printer_device ) THEN output_device='PRINTER' $
   ELSE output_device='PS'

   IF N_ELEMENTS( scale_type ) LE 0 THEN scale_type = 'LINEAR'

   current_device = !D.NAME  
   save_pmulti = !P.MULTI

   input_sz = SIZE( input )
   input_type = input_sz[ input_sz[0] + 1 ]
   CASE input_type OF
      0: BEGIN
         MESSAGE, 'input not specified', /INFO
         return
      END
      10: BEGIN
         use_pointer_flag = 1b
         input_sz = SIZE( (*input) )
      END
      ELSE: use_pointer_flag = 0b
   ENDCASE

   IF N_ELEMENTS( x_range ) EQ 2 THEN BEGIN
      x0 = x_range[0]
      x1 = x_range[1]
   ENDIF ELSE BEGIN
      x0 = 0
      x1 = input_sz[1] - 1
   ENDELSE
   IF N_ELEMENTS( y_range ) EQ 2 THEN BEGIN
      y0 = y_range[0]
      y1 = y_range[1]
   ENDIF ELSE BEGIN
      y0 = 0
      y1 = input_sz[2] - 1
   ENDELSE
   IF N_ELEMENTS( z_range ) EQ 2 THEN BEGIN
      first_frame = z_range[0]
      last_frame = z_range[1]
   ENDIF ELSE BEGIN
      first_frame = 0
      last_frame = 0
   ENDELSE
   
   SET_PLOT, output_device
   page_xsize = 7.4
   page_ysize = 9.4
   scale_factor = 1.0
   CASE STRUPCASE(output_device) OF
      'PS': BEGIN
         OPENW, lun, filename, /GET_LUN, ERROR=error
         IF error EQ 0 THEN BEGIN
            FREE_LUN, lun
            DEVICE, FILENAME=filename, SCALE_FACTOR=scale_factor, $
             /INCHES, BITS=8, $
             XOFF=0.7, YOFF=0.7, $
             XSIZE=page_xsize, YSIZE=page_ysize
         ENDIF ELSE BEGIN
            MESSAGE, 'Cannot write output file.', /CONT
            return
         ENDELSE
      END
      'PRINTER': BEGIN
         DEVICE, SCALE_FACTOR=scale_factor, $
          /INCHES, $
          XOFF=0.7, YOFF=0.7, $
          XSIZE=page_xsize, YSIZE=page_ysize
      END
      ELSE: return
   ENDCASE

   IF N_ELEMENTS( multi ) GT 0 THEN !P.MULTI = multi ELSE !P.MULTI = [0,1,1]

   FOR n_frame = first_frame, last_frame DO BEGIN

      IF n_frame NE first_frame THEN PLOT, [0,0], /NODATA, XSTYLE=4, YSTYLE=4
      
      rb_x = x1 - x0
      rb_y = y1 - y0
      rb_factor = 1
      WHILE ((rb_x/rb_factor) GT 1000) OR ((rb_y/rb_factor) GT 1000) DO rb_factor=rb_factor+1
      IF rb_factor GT 1 THEN BEGIN
         rb_xout = rb_x/rb_factor
         rb_yout = rb_y/rb_factor
      
                    ; Rebin the image
         rx1 = x0 + rb_xout*rb_factor - 1
         ry1 = y0 + rb_yout*rb_factor - 1
         IF use_pointer_flag EQ 1 THEN BEGIN
            image = REBIN( (*input)[x0:rx1,y0:ry1,n_frame], rb_xout, rb_yout )
         ENDIF ELSE BEGIN
            image = REBIN( input[x0:rx1,y0:ry1,n_frame], rb_xout, rb_yout )
         ENDELSE
      ENDIF ELSE BEGIN
         IF use_pointer_flag EQ 1 THEN BEGIN
            image = (*input)[x0:x1,y0:y1,n_frame]
         ENDIF ELSE BEGIN
            image = input[x0:x1,y0:y1,n_frame]
         ENDELSE
      ENDELSE 
      ;;HELP, image, rb_factor

      color_bar = acs_make_colorbar(256,HEIGHT=10,MIN=minimum,MAX=maximum)
      CASE STRUPCASE(scale_type) OF
         'RAW': BEGIN
         END
         'LINEAR': BEGIN
            image = BYTSCL( TEMPORARY(image), $
                            MIN=minimum, MAX=maximum, $
                            TOP=!D.TABLE_SIZE )
            scaled_color_bar=BYTSCL(color_bar,MIN=minimum,MAX=maximum)
         END
         'LOG': BEGIN
            tmin = maximum / 1e4
            image = BYTSCL( ALOG10( ( TEMPORARY(image) $
                                      - minimum) > tmin ), $
                            MIN=ALOG10(tmin), $
                            MAX=ALOG10(maximum-minimum), $
                            TOP=!D.N_COLORS )
            scaled_color_bar=BYTSCL(ALOG((color_bar-minimum)>tmin), $
                                    MIN=ALOG10(tmin), $
                                    MAX=ALOG10(maximum-minimum))
         END
         'SQRT': BEGIN
            image = BYTSCL(SQRT((TEMPORARY(image) $
                                 - minimum) > 0), $
                           MIN=0, MAX=SQRT(maximum - minimum), $
                           TOP=!D.N_COLORS)
            scaled_color_bar=BYTSCL(SQRT((color_bar-minimum)>0), $
                                    MIN=0, MAX=SQRT(maximum-minimum))
         END
         'HIST_EQ': BEGIN
            image = HIST_EQUAL( FLOAT( TEMPORARY(image) ), $
                                MINV=minimum, MAXV=maximum, $
                                TOP=!D.N_COLORS )
         END
         ELSE: BEGIN
            MESSAGE, 'SCALE_TYPE not recognized.', /INFO
            return
         END
      ENDCASE 

      image_sz = SIZE( image )
      dx = image_sz[1]
      dy = image_sz[2]
      xout = dx/scale_factor
      yout = dy/scale_factor
      image_xsize = page_xsize
      image_ysize = page_xsize
      IF xout LT yout THEN image_xsize = page_xsize*(FLOAT(xout)/yout)
      IF yout LT xout THEN image_ysize = page_ysize*(FLOAT(yout)/xout)

      y_offset = page_ysize - page_xsize
      tv_x0 = 0
      tv_y0 = y_offset / FLOAT(page_ysize) - 0.03
      tv_x1 = (image_xsize / page_xsize) < 1
      tv_y1 = (((image_ysize+y_offset)/ page_ysize)<1) - 0.03

      IF KEYWORD_SET( no_invert ) THEN BEGIN
         TV, image, tv_x0, tv_y0, XSIZE=(tv_x1-tv_x0), $
          YSIZE=(tv_y1-tv_y0), /NORMAL
      ENDIF ELSE BEGIN
         IF N_ELEMENTS(scaled_color_bar) GT 0 THEN $
          scaled_color_bar = 255b-TEMPORARY(scaled_color_bar)
         TV, 255b - image, tv_x0, tv_y0, XSIZE=(tv_x1-tv_x0), $
          YSIZE=(tv_y1-tv_y0), /NORMAL
      ENDELSE

      IF NOT KEYWORD_SET( no_frame ) THEN BEGIN
         PLOTS, [tv_x0,tv_x1,tv_x1,tv_x0,tv_x0], $
          [tv_y0,tv_y0,tv_y1,tv_y1,tv_y0], /NORMAL, THICK=2
      ENDIF

                    ; Print titles
      IF N_ELEMENTS( title_left ) GT 0 THEN BEGIN
         delta = 0.023
         XYOUTS, 0.0, 0.98, title_left[0], /NORM, FONT=0
      ENDIF 
      IF N_ELEMENTS( title_right ) GT 0 THEN BEGIN
         delta = 0.023
         XYOUTS, 1.0, 0.98, title_right[0], /NORM, ALIGN=1.0, $
          FONT=0
      ENDIF 

                    ; Print size
      delta = 0.023
      ypos = tv_y0 - delta
      strSize = STRING( FORMAT='("(",A,":",A,",",A,":",A,")")', $
                        STRTRIM(x0,2), STRTRIM(x1,2), $
                        STRTRIM(y0,2), STRTRIM(y1,2) )
      XYOUTS, 1.0, ypos, strSize, /NORM, ALIGN=1.0, FONT=0
      

                    ; Print labels
      IF N_ELEMENTS( label_col1 ) GT 0 THEN BEGIN
         delta = 0.023
         number = N_ELEMENTS(label_col1) < 7
         fi = n_frame - first_frame
         FOR i=0,number-1 DO BEGIN
            label = label_col1[i,fi]
            ypos = tv_y0-delta*(i+1)
            XYOUTS, 0, ypos, label, /NORM, FONT=0
         ENDFOR 
      ENDIF 
      IF N_ELEMENTS( label_col2 ) GT 0 THEN BEGIN
         delta = 0.023
         number = N_ELEMENTS(label_col2) < 7
         fi = n_frame - first_frame
         FOR i=0,number-1 DO BEGIN
            label = label_col2[i,fi]
            ypos = tv_y0-delta*(i+1)
            XYOUTS, 0.5, ypos, label, /NORM, FONT=0
         ENDFOR 
      ENDIF 

      IF (N_ELEMENTS( minimum ) GT 0) AND $
       (N_ELEMENTS( maximum ) GT 0) THEN BEGIN
         strDesc = $
          STRING( FORMAT='(A,1X,"display between",1X,F10.4,1X,"and",1X,F10.4)', $
                  scale_type, minimum, maximum )
      ENDIF ELSE BEGIN
         strDesc = $
          STRING( FORMAT = '(A,1X,"display")', scale_type )
      ENDELSE
      
      XYOUTS, 0, 0, strDesc, /NORM, FONT=0

      IF N_ELEMENTS(scaled_color_bar) GT 1 THEN BEGIN
         cb_y0 = -0.02
         cb_y1 = -0.01
         TV, scaled_color_bar, 0, cb_y0, $
          XSIZE=(tv_x1-tv_x0), YSIZE=ABS(cb_y1-cb_y0), /NORMAL
         PLOTS, [tv_x0,tv_x1,tv_x1,tv_x0,tv_x0], $
          [cb_y0,cb_y0,cb_y1,cb_y1,cb_y0], $
          /NORMAL, THICK=2
      ENDIF
   ENDFOR

   DEVICE, /CLOSE
   SET_PLOT, current_device

   !P.MULTI = save_pmulti
END

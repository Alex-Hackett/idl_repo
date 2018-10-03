;+
; $Id: dino.pro,v 1.23 2002/03/15 02:00:59 mccannwj Exp $
;
; NAME:
;     DINO
;
; PURPOSE:
;     Detector Noise analysis
;
; CATEGORY:
;     JHU/ACS
;
; CALLING SEQUENCE:
;     DINO [, image]
; 
; INPUTS:
;     image - 2D array in readout time order
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
;
; RESTRICTIONS:
;     Requires IDL Astronomy library.
;
; PROCEDURE:
;     Use environment variables to override defaults.
;
;     [variable]                      [default]
;     DINO_LP_COMMAND                 lp %s
;     DINO_AUTO_PS_FILE               dino_%v%a_plot.ps
;     DINO_AUTO_PEAK_FILE             dino_%v%a_peak.txt
;                                 above %v - value, %a - amp selection
;     DINO_AUTO_LP_COMMAND            lp %s
;     DINO_AUTO_RM_COMMAND            /bin/rm -f %s
;
;     The token %s will be replaced with the filename.  If the %s
;     token is not found then the filename will be appended to the command.
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;       Fri Jul 23 14:54:34 1999, William Jon McCann
;       <mccannwj@acs13.+ball.com>
;
;		written.
;
;-
; _____________________________________________________________________________

PRO dino_free_pointers, sState

   PTR_FREE, sState.ptrTransform, sState.ptrFrequency, sState.ptrBadColumns, $
    sState.ptrLineIndex, sState.ptrTimeSeries, sState.ptrData

END 

; _____________________________________________________________________________

FUNCTION fill_template_string, template, sMap

   tokens = TAG_NAMES(sMap)
   string = template
   FOR i=0,N_ELEMENTS(tokens)-1 DO BEGIN
      key = STRTRIM(tokens[i],2)
      value = STRTRIM(sMap.(i),2)
      string = STRJOIN(STRSPLIT(string,'%'+key,$
                                /REGEX,/EXTRACT,/FOLD_CASE), $
                       value)
   ENDFOR
   
   return, string
END 

; _____________________________________________________________________________

FUNCTION dino_get_peak_filename, value, amp
   env_template = GETENV('DINO_AUTO_PEAK_FILE')
   default_template = 'dino_%v%a_peak.txt'
   template = (env_template[0] EQ '') ? default_template : env_template[0]
   filename = fill_template_string(template,{a:STRLOWCASE(STRTRIM(amp,2)),$
                                             v:STRTRIM(value,2)})
   return, filename
END
; _____________________________________________________________________________

FUNCTION dino_get_ps_filename, value, amp
   env_template = GETENV('DINO_AUTO_PS_FILE')
   default_template = 'dino_%v%a_plot.ps'
   template = (env_template[0] EQ '') ? default_template : env_template[0]
   filename = fill_template_string(template,{a:STRLOWCASE(STRTRIM(amp,2)),$
                                             v:STRTRIM(value,2)})
   return, filename
END
; _____________________________________________________________________________

FUNCTION dino_get_lp_command, strPSfile
   env_command = GETENV('DINO_LP_COMMAND')
   default_command = 'lp %s'
   template = (env_command[0] EQ '') ? default_command : env_command[0]
   strCmd = fill_template_string(template+' %s',{s:strPSfile})
   return, strCmd
END 
; _____________________________________________________________________________

FUNCTION dino_get_rm_command, list
   env_command = GETENV('DINO_AUTO_RM_COMMAND')
   default_command = '/bin/rm -f %s'
   template = (env_command[0] EQ '') ? default_command : env_command[0]
   n_list = N_ELEMENTS(list)
   aCmd = MAKE_ARRAY(n_list,/STRING)
   FOR i=0,n_list-1 DO BEGIN
      aCmd[i] = fill_template_string(template+' %s',{s:list[i]})
   ENDFOR
   return, aCmd
END 
; _____________________________________________________________________________

FUNCTION get_time_stamp, julian_date, TIME_ONLY=time_only, UTC=utc, $
                         MJD=mjd

   time_zone = TIMEZONE() ; -4 for EDT, -5 for EST
                    ; -6 for MDT, -7 for MST

   ;;IF N_ELEMENTS(julian_date) GT 0 THEN PRINT, julian_date, FORMAT='(F15.8)'

   IF N_ELEMENTS( julian_date ) GT 0 THEN BEGIN
      IF KEYWORD_SET( mjd ) THEN $
       julian_date = DOUBLE(2.4e6) + DOUBLE(julian_date) + 0.5d
   ENDIF ELSE BEGIN
      ;;julian_date = DOUBLE( SYSTIME(/JULIAN) )
      juldate, BIN_DATE(SYSTIME()), rjd
      julian_date = rjd + 2400000.0
   ENDELSE

   IF KEYWORD_SET( utc ) THEN julian_date = julian_date - (time_zone / 24d)

   CALDAT, DOUBLE(julian_date), month, day, year, hour, minute, second

   monthdays = [0,31,59,90,120,151,181,212,243,273,304,334,366]
   leap_year = (((year MOD 4) EQ 0) AND ((year MOD 100) NE 0)) $
    OR ((year MOD 400) EQ 0) AND (month GE 3)
   day_of_year = day + monthdays[month-1] + leap_year

   second = ROUND(second)
   IF second GE 60 THEN BEGIN
      second = 0
      minute = minute + 1
      IF minute GE 60 THEN BEGIN
         minute = 0
         hour = hour + 1
         IF hour GE 24 THEN BEGIN
            hour = 0
            day_of_year = day_of_year + 1
                    ; we won't be working on new year's eve hopefully
         ENDIF 
      ENDIF 
   ENDIF

   IF KEYWORD_SET( time_only ) THEN BEGIN
      strStamp = STRING( FORMAT='(3(I2.2,:,":"))', $
                         hour, minute, second )      
   ENDIF ELSE BEGIN
      strStamp = STRING( FORMAT='(I4.4,":",I3.3,3(":",I2.2))', $
                         year, day_of_year, hour, minute, second )
   ENDELSE 

   return, strStamp
END

; _____________________________________________________________________________

FUNCTION dino_get_amps, type, value

   CASE STRUPCASE(type) OF
      'ACS_LOG': BEGIN
         DBOPEN, 'acs_log'
         detector = STRUPCASE(STRTRIM(DBVAL(value, 'detector'), 2))
         ccdamp = STRUPCASE(STRTRIM(DBVAL(value, 'ccdamp'), 2))
         subarray = STRUPCASE(STRTRIM(DBVAL(value, 'subarray'), 2))
      END
      'ACS_SDI': BEGIN
         ACS_ACQUIRE, value, header, /NODATA, NUMBER=1
         detector = STRUPCASE(STRTRIM(SXPAR(header, 'detector'), 2))
         ccdamp = STRUPCASE(STRTRIM(SXPAR(header, 'ccdamp'), 2))
         subarray = STRUPCASE(STRTRIM(SXPAR(header, 'subarray'), 2))
      END
      ELSE: return, -1
   ENDCASE

   IF detector EQ 'SBC' THEN return, -1
   ;;IF subarray NE 'FULL' THEN return, -1
   return, ccdamp
END

; _____________________________________________________________________________

FUNCTION dino_select_amp, ccdamp

   bAmp = BYTE(STRTRIM(ccdamp,2))
   IF N_ELEMENTS( bAmp ) LE 0 THEN MESSAGE, 'CCD amp not specified'

   aAmps = STRARR(N_ELEMENTS(bAmp))
   IF N_ELEMENTS( bAmp ) GT 1 THEN BEGIN

      FOR i=0,N_ELEMENTS(bAmp)-1 DO aAmps[i] = STRING( bAmp[i] )
      result = x_select_list( aAmps, STATUS=status_flag, $
                              TITLE='Select Amp', GROUP=group )
      
      IF status_flag NE 0 THEN BEGIN
         error_flag = 1b
         return, ''
      ENDIF
      IF result[0] EQ -1 THEN BEGIN
         return, ''
      ENDIF 
      amp = STRUPCASE( STRTRIM( aAmps[result[0]], 2 ) )
   ENDIF ELSE amp = STRTRIM(ccdamp,2)

   return, amp
END 

; _____________________________________________________________________________

PRO dino_read_acssdi, filename, image, pst, sst, bad_columns, AMP=amp, $
                      TITLE=strTitle, SUBTITLE=strSubTitle, ERROR=error_flag,$
                      WIDGET_MESSAGE=wMessage

   error_flag = 0b

   ACS_ACQUIRE, filename, header, /NODATA, NUMBER=1

   detector = STRUPCASE( STRTRIM( SXPAR( header, 'detector' ), 2 ) )
   ccdamp   = STRUPCASE( STRTRIM( SXPAR( header, 'ccdamp' ), 2 ) )
   subarray = STRUPCASE(STRTRIM(SXPAR(header, 'subarray'),2))
   IF N_ELEMENTS(amp) LE 0 THEN BEGIN
      valid_widget = 0
      IF N_ELEMENTS(wMessage) GT 0 THEN BEGIN
         IF WIDGET_INFO(wMessage,/VALID) THEN BEGIN
            valid_widget = 1
            WIDGET_CONTROL, wMessage, SET_VALUE='select amplifier...'
         ENDIF 
      ENDIF 
      amp = STRUPCASE(dino_select_amp(ccdamp))
      IF valid_widget EQ 1 THEN WIDGET_CONTROL, wMessage, SET_VALUE='reading '+filename+'...'
   ENDIF 

   IF ccdamp EQ 'ABCD' THEN four_quad_flag = 1b ELSE four_quad_flag = 0b

   CASE detector OF
      'HRC': BEGIN
         IF four_quad_flag THEN BEGIN
            CASE amp OF
               'A': BEGIN
                  x0 = 0
                  x1 = 530
                  y0 = 0
                  y1 = 521
               END 
               'B': BEGIN
                  x0 = 531
                  x1 = 1061
                  y0 = 0
                  y1 = 521
               END 
               'C': BEGIN
                  x0 = 0
                  x1 = 530
                  y0 = 522
                  y1 = 1043
               END 
               'D': BEGIN
                  x0 = 531
                  x1 = 1061
                  y0 = 522
                  y1 = 1043
               END 
               ELSE: BEGIN
                  error_flag = 1b
                  return
               END 
            ENDCASE
         ENDIF

         pst = 1892.0 ;1408.0 ; parallel shift time (us)
         sst = 22.0 ; serial shift period (us)
         
         nbc = 6    ; num bad cols to patch at start of each row
         nos = 19   ; number of overscan columns at each end of array
         osoff = 2.5
      END 

      'WFC': BEGIN

         CASE amp OF
            'A': BEGIN
               chip_number = 1
               IF four_quad_flag THEN BEGIN
                  x0 = 0
                  x1 = 2071
                  y0 = 0
                  y1 = 2067
               ENDIF ELSE BEGIN
                  
               ENDELSE
            END
            'B': BEGIN
               chip_number = 1
               IF four_quad_flag THEN BEGIN
                  x0 = 2072
                  x1 = 4143
                  y0 = 0
                  y1 = 2067
               ENDIF ELSE BEGIN
                  
               ENDELSE
            END 
            'C': BEGIN
               chip_number = 2
               IF four_quad_flag THEN BEGIN
                  x0 = 0
                  x1 = 2071
                  y0 = 0
                  y1 = 2067
               ENDIF ELSE BEGIN
                  
               ENDELSE 
            END 
            'D': BEGIN
               chip_number = 2
               IF four_quad_flag THEN BEGIN
                  x0 = 2072
                  x1 = 4143
                  y0 = 0
                  y1 = 2067
               ENDIF ELSE BEGIN
                  
               ENDELSE
            END 
            ELSE: BEGIN
               error_flag = 1b
               return
            END 
         ENDCASE

         pst = 3212.0 ; parallel shift time (us)
         sst = 22.0 ; serial shift period (us)
         
         nbc = 0   ; num bad cols to patch at start of each row
         nos = 0    ; number of overscan columns at each end of array
         osoff = 0
      END 

      ELSE: BEGIN
         MESSAGE, 'Invalid detector: "' + detector + '"', /CONTINUE
         return
      END 
   ENDCASE

   ACS_ACQUIRE, filename, header, image, /NOWRITE, $
    ROTATE=0, NUMBER=1, CHIP=chip_number

   mask = BYTE( (image LT 0) )
   image = TEMPORARY(image) + TEMPORARY(mask)*65536.
   mask = 0

   IF (N_ELEMENTS( x0 ) GT 0) AND (subarray EQ 'FULL') THEN BEGIN
      image = (TEMPORARY( image ))[x0:x1,y0:y1]
   ENDIF 

;                    ; flip about horiz axis
;   IF (amp EQ 'C') OR (amp EQ 'D') THEN image = ROTATE( image, 7 ) 
;                    ; flip about vert axis
;   IF (amp EQ 'B') OR (amp EQ 'D') THEN image = REVERSE( image )

   detector = STRUPCASE( STRTRIM( detector, 2 ) )
   amp      = STRUPCASE( STRTRIM( amp, 2 ) )

   mjd_time = SXPAR( header, 'EXPSTART' )
   mebid    = SXPAR( header, 'MEBID' )
   ccd_gain   = SXPAR( header, 'CCDGAIN' )
   ccd_offset = SXPAR( header, 'CCDOFF' )

   sct0 = get_time_stamp(mjd_time[0], /MJD)

   strTitleFormat = '(A,1X,"Side ",I1," noise analysis - Amp ",A,", Gain ",I1,", Offset ",I1)'
   strTitle  = STRING( FORMAT=strTitleFormat, $
                       detector, mebid, amp, ccd_gain, ccd_offset )

   FDECOMP, filename[0], fdisk, fdir, fname, fext, fversion
   strSubTitle = STRING( FORMAT='("Start ",A,1X,"Filename ",A,".",A)', $
                         sct0, fname, fext )


END

; _____________________________________________________________________________

PRO dino_read_acslog, entry, image, pst, sst, bad_columns, AMP=amp, $
                      TITLE=strTitle, SUBTITLE=strSubTitle, ERROR=error_flag,$
                      MESSAGE=error_message, WIDGET_MESSAGE=wMessage
   error_flag = 0b
   DBOPEN, 'acs_log'
   detector = STRUPCASE(STRTRIM(DBVAL(entry, 'detector'), 2))
   ccdamp   = STRUPCASE(STRTRIM(DBVAL(entry, 'ccdamp'), 2))
   subarray = STRUPCASE(STRTRIM(DBVAL(entry, 'subarray'),2))
   IF N_ELEMENTS(amp) LE 0 THEN BEGIN
      valid_widget = 0
      IF N_ELEMENTS(wMessage) GT 0 THEN BEGIN
         IF WIDGET_INFO(wMessage,/VALID) THEN BEGIN
            valid_widget = 1
            WIDGET_CONTROL, wMessage, SET_VALUE='select amplifier...'
         ENDIF
      ENDIF 
      amp = STRUPCASE(dino_select_amp(ccdamp))
      IF valid_widget EQ 1 THEN $
       WIDGET_CONTROL, wMessage, SET_VALUE='reading entry '+STRTRIM(entry,2)+'...'
   ENDIF 
   IF amp EQ '' THEN BEGIN
      error_flag=1b
      error_message = 'error: amp not specified.'
      return
   ENDIF 

   IF ccdamp EQ 'ABCD' THEN four_quad_flag = 1b ELSE four_quad_flag = 0b

   CASE detector OF
      'HRC': BEGIN
         IF four_quad_flag THEN BEGIN
            CASE amp OF
               'A': BEGIN
                  x0 = 0
                  x1 = 530
                  y0 = 0
                  y1 = 521
               END 
               'B': BEGIN
                  x0 = 531
                  x1 = 1061
                  y0 = 0
                  y1 = 521
               END 
               'C': BEGIN
                  x0 = 0
                  x1 = 530
                  y0 = 522
                  y1 = 1043
               END 
               'D': BEGIN
                  x0 = 531
                  x1 = 1061
                  y0 = 522
                  y1 = 1043
               END 
               ELSE: BEGIN
                  error_flag = 1b
                  return
               END 
            ENDCASE
         ENDIF

         pst = 1892.0 ;1408.0 ; parallel shift time (us)
         sst = 22.0 ; serial shift period (us)
         
         nbc = 6    ; num bad cols to patch at start of each row
         nos = 19   ; number of overscan columns at each end of array
         osoff = 2.5
      END 

      'WFC': BEGIN

         CASE amp OF
            'A': BEGIN
               chip_number = 1
               IF four_quad_flag THEN BEGIN
                  x0 = 0
                  x1 = 2071
                  y0 = 0
                  y1 = 2067
               ENDIF ELSE BEGIN
                  
               ENDELSE
            END
            'B': BEGIN
               chip_number = 1
               IF four_quad_flag THEN BEGIN
                  x0 = 2072
                  x1 = 4143
                  y0 = 0
                  y1 = 2067
               ENDIF ELSE BEGIN
                  
               ENDELSE
            END 
            'C': BEGIN
               chip_number = 2
               IF four_quad_flag THEN BEGIN
                  x0 = 0
                  x1 = 2071
                  y0 = 0
                  y1 = 2067               
               ENDIF ELSE BEGIN
                  
               ENDELSE 
            END 
            'D': BEGIN
               chip_number = 2
               IF four_quad_flag THEN BEGIN
                  x0 = 2072
                  x1 = 4143
                  y0 = 0
                  y1 = 2067
               ENDIF ELSE BEGIN
                  
               ENDELSE
            END 
            ELSE: BEGIN
               error_flag = 1b
               return
            END 
         ENDCASE

         pst = 3212.0 ; parallel shift time (us)
         sst = 22.0 ; serial shift period (us)
         
         nbc = 0   ; num bad cols to patch at start of each row
         nos = 0    ; number of overscan columns at each end of array
         osoff = 0
      END 

      ELSE: BEGIN
         MESSAGE, 'Invalid detector: "' + detector + '"', /CONTINUE
         return
      END 
   ENDCASE

   PRINT, 'READING ACS_LOG entry '+STRTRIM(entry[0],2)+'...'
   ACS_READ, entry[0], header, image, CHIP=chip_number, /NO_ABORT, $
    ROTATE=0, /WAIT, MESSAGE=error_message
   IF N_ELEMENTS(image) LE 0 THEN error_flag=1b

   IF (N_ELEMENTS(x0) GT 0) AND (subarray EQ 'FULL') THEN BEGIN
      image = (TEMPORARY( image ))[x0:x1,y0:y1]
   ENDIF

;                    ; flip about horiz axis
;   IF (amp EQ 'C') OR (amp EQ 'D') THEN image = ROTATE( image, 7 ) 

;                    ; flip about vert axis
;   IF (amp EQ 'B') OR (amp EQ 'D') THEN image = REVERSE( image )

   detector = STRUPCASE(STRTRIM(detector, 2))
   amp      = STRUPCASE(STRTRIM(amp, 2))
   PRINT, '   read amplifier '+amp
   mjd_time = DBVAL( entry, 'EXPSTART' )
   mebid    = DBVAL( entry, 'MEBID' )
   ccd_gain   = DBVAL( entry, 'CCDGAIN' )
   ccd_offset = DBVAL( entry, 'CCDOFF' )

   sct0 = get_time_stamp(mjd_time[0], /MJD)

   strTitleFormat = '(A,1X,"Side ",I1," noise analysis - Amp ",A,", Gain ",I1,", Offset ",I1)'
   strTitle  = STRING( FORMAT=strTitleFormat, $
                       detector, mebid, amp, ccd_gain, ccd_offset )

   strSubTitle = STRING( FORMAT='("Start ",A,1X,"Entry ",A)', $
                         sct0, STRTRIM(entry,2) )

END 

; _____________________________________________________________________________

PRO dino_read_acs_fits, filename, image, pst, sst, bad_columns, AMP=amp, $
                        TITLE=strTitle, SUBTITLE=strSubTitle, ERROR=error_flag,$
                        MESSAGE=error_message, WIDGET_MESSAGE=wMessage
   error_flag = 0b

                    ; ACS_READ now handles both pre and post launch
                    ; data formats
   ACS_READ, filename, header, /NODATA

   detector = STRUPCASE( STRTRIM( SXPAR( header, 'detector' ), 2 ) )
   ccdamp   = STRUPCASE( STRTRIM( SXPAR( header, 'ccdamp' ), 2 ) )

                    ; subarray is a boolean value
   subarray = SXPAR(header, 'subarray')
   IF N_ELEMENTS(amp) LE 0 THEN BEGIN
      valid_widget = 0
      IF N_ELEMENTS(wMessage) GT 0 THEN BEGIN
         IF WIDGET_INFO(wMessage,/VALID) THEN BEGIN
            valid_widget = 1
            WIDGET_CONTROL, wMessage, SET_VALUE='select amplifier...'
         ENDIF
      ENDIF 
      amp = STRUPCASE(dino_select_amp(ccdamp))
      IF valid_widget EQ 1 THEN WIDGET_CONTROL, wMessage, SET_VALUE='reading '+filename+'...'
   ENDIF 
   IF amp EQ '' THEN BEGIN
      error_flag=1b
      error_message = 'error: amp not specified.'
      return
   ENDIF 

   IF ccdamp EQ 'ABCD' THEN four_quad_flag = 1b ELSE four_quad_flag = 0b

   CASE detector OF
      'HRC': BEGIN
         IF four_quad_flag THEN BEGIN
            CASE amp OF
               'A': BEGIN
                  x0 = 0
                  x1 = 530
                  y0 = 0
                  y1 = 521
               END 
               'B': BEGIN
                  x0 = 531
                  x1 = 1061
                  y0 = 0
                  y1 = 521
               END 
               'C': BEGIN
                  x0 = 0
                  x1 = 530
                  y0 = 522
                  y1 = 1043
               END 
               'D': BEGIN
                  x0 = 531
                  x1 = 1061
                  y0 = 522
                  y1 = 1043
               END 
               ELSE: BEGIN
                  error_flag = 1b
                  return
               END 
            ENDCASE
         ENDIF

         pst = 1892.0 ;1408.0 ; parallel shift time (us)
         sst = 22.0 ; serial shift period (us)
         
         nbc = 6    ; num bad cols to patch at start of each row
         nos = 19   ; number of overscan columns at each end of array
         osoff = 2.5
      END 

      'WFC': BEGIN

         CASE amp OF
            'A': BEGIN
               chip_number = 1
               IF four_quad_flag THEN BEGIN
                  x0 = 0
                  x1 = 2071
                  y0 = 0
                  y1 = 2067
               ENDIF ELSE BEGIN
                  
               ENDELSE
            END
            'B': BEGIN
               chip_number = 1
               IF four_quad_flag THEN BEGIN
                  x0 = 2072
                  x1 = 4143
                  y0 = 0
                  y1 = 2067
               ENDIF ELSE BEGIN
                  
               ENDELSE
            END 
            'C': BEGIN
               chip_number = 2
               IF four_quad_flag THEN BEGIN
                  x0 = 0
                  x1 = 2071
                  y0 = 0
                  y1 = 2067               
               ENDIF ELSE BEGIN
                  
               ENDELSE 
            END 
            'D': BEGIN
               chip_number = 2
               IF four_quad_flag THEN BEGIN
                  x0 = 2072
                  x1 = 4143
                  y0 = 0
                  y1 = 2067
               ENDIF ELSE BEGIN
                  
               ENDELSE
            END 
            ELSE: BEGIN
               error_flag = 1b
               return
            END 
         ENDCASE

         pst = 3212.0 ; parallel shift time (us)
         sst = 22.0 ; serial shift period (us)
         
         nbc = 0   ; num bad cols to patch at start of each row
         nos = 0    ; number of overscan columns at each end of array
         osoff = 0
      END 

      ELSE: BEGIN
         MESSAGE, 'Invalid detector: "' + detector + '"', /CONTINUE
         return
      END 
   ENDCASE

   PRINT, 'READING ACS FITS file '+STRTRIM(filename[0],2)+'...'
   ACS_READ, filename[0], header, image, CHIP=chip_number, /NO_ABORT, $
    ROTATE=0, /WAIT, MESSAGE=error_message
   IF N_ELEMENTS(image) LE 0 THEN error_flag=1b

   IF !prelaunch EQ 0 THEN BEGIN
      subarray_full = (subarray EQ 0) ? 1 : 0
      ccd_offset_keyword = 'CCDOFST'+STRUPCASE(STRTRIM(amp, 2))
   ENDIF ELSE BEGIN
      subarray_full = (STRTRIM(subarray,2) EQ 'FULL') ? 1 : 0
      ccd_offset_keyword = 'CCDOFF'
   ENDELSE

   IF (N_ELEMENTS(x0) GT 0) AND (subarray_full EQ 1) THEN BEGIN
      image = (TEMPORARY( image ))[x0:x1,y0:y1]
   ENDIF

   detector = STRUPCASE(STRTRIM(detector, 2))
   amp      = STRUPCASE(STRTRIM(amp, 2))
   PRINT, '   read amplifier '+amp
   mjd_time = SXPAR( header, 'EXPSTART' )
   mebid    = SXPAR( header, 'MEBID' )
   ccd_gain   = SXPAR( header, 'CCDGAIN' )
   ccd_offset = SXPAR( header, ccd_offset_keyword )

   sct0 = get_time_stamp(mjd_time[0], /MJD)

   strTitleFormat = '(A,1X,"Side ",I1," noise analysis - Amp ",A,", Gain ",I1,", Offset ",I1)'
   strTitle  = STRING( FORMAT=strTitleFormat, $
                       detector, mebid, amp, ccd_gain, ccd_offset )

   FDECOMP, filename[0], fdisk, fdir, fname, fext, fversion
   strSubTitle = STRING( FORMAT='("Start ",A,1X,"Filename ",A,".",A)', $
                         sct0, fname, fext )
END 

; _____________________________________________________________________________

PRO dino_put_bad_columns, sState, bad_columns

   IF N_ELEMENTS( bad_columns ) LE 0 THEN string = '' $
   ELSE IF bad_columns[0] EQ -1 THEN string = '' $
   ELSE string = STRJOIN( STRTRIM(bad_columns,2), ",", /SINGLE )

   WIDGET_CONTROL, sState.wBadColumnsField, SET_VALUE=string[0]

END

; _____________________________________________________________________________

PRO dino_get_bad_columns, sState, bad_columns

   WIDGET_CONTROL, sState.wBadColumnsField, GET_VALUE=string
   IF string[0] EQ '' THEN bad_columns = [-1] $
   ELSE BEGIN
      fields = STRTRIM(STRSPLIT( string[0], ",", /EXTRACT ),2)
      bad_columns = [-1]
      FOR i=0,N_ELEMENTS(fields)-1 DO BEGIN
         IF STRPOS(fields[i],':') GE 0 THEN BEGIN
            range = LONG( STRTRIM(STRSPLIT( fields[i], ":", /EXTRACT ),2) )
            cols = LINDGEN( range[1]-range[0]+1 ) + range[0]
            bad_columns = [bad_columns,cols]
         ENDIF ELSE bad_columns = [bad_columns,LONG(fields[i])]
      ENDFOR
      IF N_ELEMENTS(bad_columns) GT 1 THEN bad_columns = bad_columns[1:*]
   ENDELSE
   
END

; _____________________________________________________________________________

PRO dino_open, sState, type, value, AMP=amp, ERROR=error_flag

   error_flag = 0b
   
   CASE STRUPCASE(type) OF
      'ACS_LOG': BEGIN
                    ; Read an entry number
         input_title = 'Input ACS_LOG entry number'
         input_label = 'Entry number: '
         DBOPEN, 'acs_log'
         IF N_ELEMENTS(value) GT 0 THEN BEGIN
            status = 0b
            entry_number = LONG(value)
         ENDIF ELSE BEGIN
            value = db_info( 'entries' )
            entry_number = x_get_input( STATUS=status, $
                                        TITLE=input_title, $
                                        LABEL=input_label, /LONG, $
                                        VALUE=value, GROUP=sState.wRoot )
         ENDELSE
         
         IF status EQ 0 THEN BEGIN
            IF (entry_number GT 0) THEN BEGIN
               strMessage = $
                STRING( FORMAT='("reading ACS_LOG entry ",I0,"...")', $
                        entry_number )
               dino_wmessage, sState, strMessage

               dino_read_acslog, entry_number, data, pst, sst, bad_columns, $
                TITLE=plot_title, SUBTITLE=plot_subtitle, ERROR=error_flag, $
                MESSAGE=error_message, AMP=amp, WIDGET_MESSAGE=sState.wMessageText

               dino_wmessage, sState, 'ready'
               IF error_flag NE 1 THEN BEGIN
                  n_pixels = N_ELEMENTS( data )
                  IF n_pixels GT 2 THEN BEGIN
                  ENDIF ELSE BEGIN
                     strMessage = 'error: no data read from ACS_LOG database'
                     dino_wmessage, sState, strMessage
                     error_flag = 1b
                     return
                  ENDELSE          
               ENDIF ELSE BEGIN
                  error_flag = 1b
                  IF N_ELEMENTS(error_message) GT 0 THEN $
                   strMessage = STRTRIM(error_message,2) $
                  ELSE strMessage = 'error: no data read from ACS_LOG database'
                  dino_wmessage, sState, strMessage
                  return
               ENDELSE          
            ENDIF ELSE BEGIN
               error_flag = 1b
               strMessage = 'error: entry number must be greater than zero'
               dino_wmessage, sState, strMessage
               return
            ENDELSE
         ENDIF ELSE BEGIN
            error_flag = 1b
            strMessage = 'error: open cancelled'
            dino_wmessage, sState, strMessage
            return
         ENDELSE

      END

      'ACS_FITS': BEGIN
         IF N_ELEMENTS(value) GT 0 THEN BEGIN
            filename = STRTRIM(value,2)
         ENDIF ELSE BEGIN 
            filename = DIALOG_PICKFILE( PATH=sState.last_file_path, /READ, $
                                        GET_PATH=new_path, /MUST_EXIST )
         ENDELSE 
         IF N_ELEMENTS( filename ) EQ 1 THEN BEGIN
            IF filename[0] EQ '' THEN BEGIN
               error_flag = 1b
               return
            ENDIF
         ENDIF
         
         FDECOMP, filename[0], fdisk, fdir, fname, fext, fversion
         strMessage = $
          STRING( FORMAT='("reading file ",A,".",A,"...")', fname, fext )
         dino_wmessage, sState, strMessage

         WIDGET_CONTROL, /HOURGLASS
         dino_read_acs_fits, filename[0], data, pst, sst, bad_columns, $
          TITLE=plot_title, SUBTITLE=plot_subtitle, ERROR=error_flag, $
          AMP=amp, WIDGET_MESSAGE=sState.wMessageText
         dino_wmessage, sState, 'ready'
         IF error_flag NE 1 THEN BEGIN
            n_pixels = N_ELEMENTS( data )
            IF n_pixels GT 2 THEN BEGIN
               
            ENDIF ELSE BEGIN
               strMessage = 'error: no data read from SDI file'
               dino_wmessage, sState, strMessage
               error_flag = 1b
               return
            ENDELSE          
         ENDIF ELSE BEGIN
            strMessage = 'error: no data read from SDI file'
            dino_wmessage, sState, strMessage
            error_flag = 1b
            return
         ENDELSE          

      END 

      'ACS_SDI': BEGIN
         IF N_ELEMENTS(value) GT 0 THEN BEGIN
            filename = STRTRIM(value,2)
         ENDIF ELSE BEGIN 
            filename = DIALOG_PICKFILE( PATH=sState.last_file_path, /READ, $
                                        GET_PATH=new_path, /MUST_EXIST )
         ENDELSE 
         IF N_ELEMENTS( filename ) EQ 1 THEN BEGIN
            IF filename[0] EQ '' THEN BEGIN
               error_flag = 1b
               return
            ENDIF
         ENDIF
         
         FDECOMP, filename[0], fdisk, fdir, fname, fext, fversion
         strMessage = $
          STRING( FORMAT='("reading file ",A,".",A,"...")', fname, fext )
         dino_wmessage, sState, strMessage

         WIDGET_CONTROL, /HOURGLASS
         dino_read_acssdi, filename[0], data, pst, sst, bad_columns, $
          TITLE=plot_title, SUBTITLE=plot_subtitle, ERROR=error_flag, $
          AMP=amp, WIDGET_MESSAGE=sState.wMessageText
         dino_wmessage, sState, 'ready'
         IF error_flag NE 1 THEN BEGIN
            n_pixels = N_ELEMENTS( data )
            IF n_pixels GT 2 THEN BEGIN
               
            ENDIF ELSE BEGIN
               strMessage = 'error: no data read from SDI file'
               dino_wmessage, sState, strMessage
               error_flag = 1b
               return
            ENDELSE          
         ENDIF ELSE BEGIN
            strMessage = 'error: no data read from SDI file'
            dino_wmessage, sState, strMessage
            error_flag = 1b
            return
         ENDELSE          

      END 

      ;; ADD YOUR TYPE HERE

      ELSE: BEGIN
         error_flag = 1b
         dino_wmessage, sState, 'error: unknown data type: '+STRTRIM(type,2)
         return
      END 

   ENDCASE
   

                    ; at this point we should have defined: 
                    ;     data, pst, sst, bad_columns
                    ; and optionally plot_title, plot_subtitle

                    ; Data should be in time order

   IF N_ELEMENTS(data) LE 0 THEN BEGIN
      dino_wmessage, sState, 'Could not read data.'
      error_flag = 1b
      return
   ENDIF 
   IF N_ELEMENTS(pst) LE 0 THEN BEGIN
      dino_wmessage, sState, 'Parallel shift time not defined.'
      error_flag = 1b
      return
   ENDIF 
   IF N_ELEMENTS(sst) LE 0 THEN BEGIN
      dino_wmessage, sState, 'Serial shift time not defined.'
      error_flag = 1b
      return
   ENDIF 
   IF N_ELEMENTS(bad_columns) LE 0 THEN bad_columns = [-1]

   image_sz = SIZE( data )
   strMessage = $
    STRING( FORMAT='("Read ",' + STRTRIM( image_sz[0]-1, 2 ) + $
            '(I0," x "),I0," array")', $
            image_sz[1:image_sz[0]] )
   dino_wmessage, sState, strMessage
   sState.parallel_shift_time = pst
   sState.serial_shift_time = sst

   IF N_ELEMENTS( plot_title ) GT 0 THEN sState.plot_title = plot_title
   IF N_ELEMENTS( plot_subtitle ) GT 0 THEN $
    sState.plot_subtitle = plot_subtitle

   PTR_FREE, sState.ptrData
   sState.ptrData = PTR_NEW( data, /NO_COPY )

   IF N_ELEMENTS( new_path ) GT 0 THEN sState.last_file_path = new_path[0]

                    ; beep to alert the user
   PRINT, FORMAT='(A,A,$)', STRING(7b)
   PRINT, FORMAT='(A,A,$)', STRING(7b)
                    ; update the display
   WIDGET_CONTROL, sState.wParallelShiftField, SET_VALUE=pst[0]
   WIDGET_CONTROL, sState.wSerialShiftField, SET_VALUE=sst[0]
   dino_put_bad_columns, sState, bad_columns
   PTR_FREE, sState.ptrBadColumns
   sState.ptrBadColumns = PTR_NEW( bad_columns, /NO_COPY )
   
                    ; make the button display sensitive
   WIDGET_CONTROL, sState.wButtonBase, SENSITIVE=1
END 

; _____________________________________________________________________________

PRO dino_save_lines, sState, ERROR=error_code, FILENAME=svname

   error_code = 0b
   IF PTR_VALID(sState.ptrLineIndex) THEN BEGIN
      dino_wmessage, sState, 'save peaks to file...'
      IF N_ELEMENTS(svname) LE 0 THEN BEGIN
         CD, CURRENT=currdir
         dialog_file = currdir+'/dino_peaks.txt'
         svname = DIALOG_PICKFILE(FILE=dialog_file, /WRITE, $
                                  GET_PATH=writepath)
      ENDIF
      IF svname[0] NE '' THEN BEGIN
         junk = FINDFILE(svname[0], COUNT=fcnt)
         WIDGET_CONTROL, /HOURGLASS
         dino_get_lines, sState, line_freq, line_power
         OPENW, lun, svname[0], /GET_LUN, ERROR=open_error
         IF open_error EQ 0 THEN BEGIN
            PRINTF, lun, sState.plot_title, FORMAT='("# ",A)'
            PRINTF, lun, sState.plot_subtitle, FORMAT='("# ",A)'
            PRINTF, lun, 'Freq', STRING(9b), 'Power', $
             FORMAT='("# ",15A,A,15A)'
            FOR i = 0l, N_ELEMENTS(line_freq)-1 DO BEGIN
               PRINTF, lun, line_freq[i], STRING(9b), line_power[i], $
                FORMAT='(F,A,F)'
            ENDFOR
            FREE_LUN, lun
            dino_wmessage, sState, 'done.'
         ENDIF ELSE BEGIN
            error_code = 1b
            dino_wmessage, sState, $
             'error opening '+svname[0]+': '+!ERR_STRING
         ENDELSE
      ENDIF ELSE dino_wmessage, sState, 'save cancelled.'
   ENDIF ELSE dino_wmessage, sState, 'no peaks defined.'

   return
END 

; _____________________________________________________________________________

PRO dino_plot_data, plot_x, plot_y, plot_mjd_time, $
                    TITLE=strTitle, SUBTITLE=strSubTitle, $
                    XMIN=xmin, XMAX=xmax, YMIN=ymin, YMAX=ymax, $
                    PLOT_TYPE=plot_type, POSITION=position, $
                    THRESHOLD=threshold_value, $
                    FONT=font_type, CHARSIZE=charsize, CHARTHICK=charthick

   IF N_ELEMENTS( plot_type ) LE 0 THEN plot_type = 0

   strXTitle = 'Frequency (Hz)'

                    ; Take care of X RANGE _____________________________
   IF N_ELEMENTS( xmin ) LE 0 THEN xmin = MIN( plot_x )
   IF N_ELEMENTS( xmax ) LE 0 THEN xmax = MAX( plot_x )

   xstyle = 1
                    ; If they are both zero assume they have not been set
   IF (xmin EQ 0) AND (xmax EQ 0) THEN BEGIN
      xmin = MIN( plot_x )
      xmax = MAX( plot_x )
      xstyle = 3
   ENDIF 
                    ; if the max is less than the min
   IF (xmax LT xmin) THEN xmax = MAX( plot_x )
   xrange = [xmin, xmax]

                    ; Take care of plot type ___________________________
   min_index = WHERE( plot_x LE xmin, min_count )
   IF min_count GT 0 THEN x0 = MAX( min_index ) ELSE x0 = 0

   max_index = WHERE( plot_x GE xmax, max_count )
   IF max_count GT 0 THEN x1 = MIN( max_index ) ELSE x1 = N_ELEMENTS(plot_x)-1

   CASE plot_type OF
      1: BEGIN
         strYTitle = 'Magnitude in dB'
         y_value = 20.0 * ALOG10(plot_y[x0:x1])
      END
      2: BEGIN
         strYTitle = 'Power'
         y_value = (plot_y[x0:x1]) ^ 2
      END
      ELSE: BEGIN
         strYTitle = 'Real part of spectrum'
         y_value = plot_y[x0:x1]
      END
   ENDCASE

                    ; Take care of Y RANGE _____________________________
   IF N_ELEMENTS( ymin ) LE 0 THEN ymin = MIN( y_value )
   IF N_ELEMENTS( ymax ) LE 0 THEN ymax = MAX( y_value )

   ystyle = 1
   IF (ymin EQ 0) AND (ymax EQ 0) THEN BEGIN
      ymin = MIN( y_value )
      ymax = MAX( y_value )
      ystyle = 3
   ENDIF

   IF (ymax LT ymin) THEN ymax = MAX( y_value )
   yrange = [ymin, ymax]

   PLOT, plot_x[x0:x1], y_value, PSYM=10, $
    XTITLE=strXTitle, YTITLE=strYTitle, TITLE=strTitle, $
    SUBTITLE=strSubTitle, POSITION=position, $
    XRANGE=xrange, YRANGE=yrange, XSTYLE=xstyle, YSTYLE=ystyle, $
    CHARSIZE=charsize, CHARTHICK=charthick, FONT=font_type

   IF N_ELEMENTS( threshold_value ) GT 0 THEN BEGIN
      OPLOT, !X.CRANGE, [1,1]*threshold_value, LINESTYLE=1, $
       COLOR=!D.N_COLORS/2
   ENDIF

   return
END

; _____________________________________________________________________________

PRO dino_mask_bad_columns, image, bad_columns

   IF N_ELEMENTS( bad_columns ) GT 0 THEN BEGIN
      image_sz = SIZE( image )
                    ; find the "good" bad columns
      good_subs = WHERE( (bad_columns LT image_sz[1]) OR $
                         (bad_columns GE 0), gcount )
      IF gcount GT 0 THEN BEGIN
         PRINT, '   masked bad columns: ', STRTRIM(bad_columns,2)
         bad_columns = bad_columns[good_subs]
         image[bad_columns,*] = 0
      ENDIF 
   ENDIF
END

; _____________________________________________________________________________

PRO dino_median_filter_columns, image, median_width

   image_sz = SIZE( image )
   nc = image_sz[1]
   nr = image_sz[2]

   IF N_ELEMENTS( median_width ) LE 0 THEN median_width = 0
   IF median_width GT 0 THEN BEGIN
      PRINT, 'Median filtering image...'
      image = FLOAT( TEMPORARY( image ) )
                    ; force width to be negative
      IF (median_width MOD 2) EQ 0 THEN median_width = median_width+1
      FOR j=0, nc-1 DO BEGIN
         column = REFORM( image[j,*] )
         col_median = MEDIAN( column, median_width )
         image[j,*] = image[j,*] - col_median
      ENDFOR
   ENDIF
                    ; chop off ends
   PRINT, '   removing first and last '+STRTRIM(median_width/2,2)+' rows to avoid median filter end effects'
   first_i = median_width/2
   last_i  = nr-median_width/2-1
   image = (TEMPORARY( image ))[*,first_i:last_i]
END

; _____________________________________________________________________________

PRO dino_write_image, image, filename, header

                    ; save image to a file for debugging
   OPENW, lun, filename, /GET_LUN, ERROR=open_error
   IF open_error EQ 0 THEN BEGIN
      FREE_LUN, lun
      IF N_ELEMENTS( header ) LE 0 THEN MKHDR, header, image
      WRITEFITS, filename, image, header
   ENDIF 
END 

; _____________________________________________________________________________

PRO dino_view_image, image, header

                    ; view image to a file for debugging
      mview, image, header, /AUTO, TITLE='Median filtered image'
END 

; _____________________________________________________________________________

FUNCTION dino_compute_spectrum, image, pst, sst, $
                                FREQUENCY=frequency, $
                                TIME_SERIES=time_series, $
                                ERROR=error_flag

   IF N_PARAMS() LT 3 THEN BEGIN
      MESSAGE, 'usage: dino_compute_spectrum, image, pst, sst', $
       /CONTINUE, /NONAME
      error_flag = 1b
      return, -1
   ENDIF 

   pst = pst > 0
   sst = sst > 0

   error_flag = 0b

   image_sz = SIZE( image )
   nc = image_sz[1]
   nr = image_sz[2]
   pps = pst / sst  ; number of serial shift intervals in parallel interval

   pps = ROUND(pps) ; OR SHOULD THIS BE FLOOR() ???

                    ; transform image into a vector with equal time
                    ; intervals between samples 
   nx = nc + pps
   PRINT, '   padding each row with '+STRTRIM(pps,2)+' pixels for parallel shift interval'
   PRINT, '   creating time series...'
   time_series = FLTARR(nx,nr)
                    ; assume image already in correct time order
   time_series[0,0] = image
   IF pps GT 0 THEN BEGIN
                    ; patch the pad area with values
      ;;dev = STDDEV( image[nc-16:nc-1,*] )
      ;;HELP, dev
      ;;noise = RANDOMN(seed, pps, nr) * dev

      ;;time_series[nc,0] = noise
   ENDIF

   time_series = REFORM(TEMPORARY(time_series), nx*nr)
   PRINT, '   time series initially has '+STRTRIM(nx*nr,2)+' elements'
   
                    ; trim vector length to power of 2 for fft
   p2 = FIX(ALOG(nx*nr) / ALOG(2))
   n_ts = 2L ^ p2
   time_series = (TEMPORARY(time_series))[0:n_ts-1]
   PRINT, '   time series trimmed to power of 2 has '+STRTRIM(n_ts,2)+' elements'

                    ; get real part of Fourier transform
   nt = n_ts / 2
   PRINT, '   computing FFT...'
   fft_output = FFT(time_series, -1)
   ;;magnitude = (ABS( fft_output ))[0:nt-1]

                    ; make frequency vector (Hz) corresponding to transform
   resolution = 1 / (2 * nt * sst * 1.0e-6)
   PRINT, '   frequency resolution is '+STRTRIM(resolution,2)+' Hz'
   freq = FINDGEN(nt) * resolution
   frequency = [freq, -1*REVERSE(freq)]

   return, fft_output
END

; _____________________________________________________________________________

FUNCTION dino_revert_spectrum, transform, xsize, ysize

   IF N_PARAMS( transform ) NE 3 THEN return, -1
   IF N_ELEMENTS( transform ) LT 2 THEN return, -1

   time_series = FLOAT( FFT( transform, 1 ) )
                    ; pad time series with zeros up to image size
   nt = N_ELEMENTS( time_series )
   ni = xsize*ysize
   IF nt LT ni THEN BEGIN
      zeros = MAKE_ARRAY( ni - nt )
      time_series = [TEMPORARY(time_series),zeros]
   ENDIF ELSE IF nt GT ni THEN BEGIN
      time_series = (TEMPORARY(time_series))[0:ni-1]
   ENDIF

   array = REFORM( time_series, xsize, ysize )

   return, array
END 

; _____________________________________________________________________________

PRO dino_process_data, sState, ERROR=error_flag

   error_flag = 0b
   CASE STRUPCASE(!VERSION.OS_FAMILY) OF
      'WINDOWS': gdevice = 'WIN'
      'MACOS': gdevice = 'MAC'
      ELSE: gdevice = 'X'
   ENDCASE
   SET_PLOT, gdevice
   saved_window = !D.WINDOW
   WSET, sState.draw_index

   IF NOT PTR_VALID( sState.ptrData ) THEN BEGIN
      dino_wmessage, sState, 'No data defined.'
      error_flag = 1b
      WSET, saved_window
      return
   ENDIF 

   dino_wmessage, sState, 'reading parameters...'
   WIDGET_CONTROL, sState.wParallelShiftField, GET_VALUE=pst
   WIDGET_CONTROL, sState.wSerialShiftField, GET_VALUE=sst
   WIDGET_CONTROL, sState.wMedianFilterField, GET_VALUE=median_width
   dino_get_bad_columns, sState, bad_columns
   WIDGET_CONTROL, sState.wViewImageButton, GET_VALUE=view_image_flag
   WIDGET_CONTROL, sState.wCRSigmaField, GET_VALUE=cr_sigma

                    ; Save the values that were used to process data
   sState.parallel_shift_time = pst
   sState.serial_shift_time = sst
   sState.median_width = median_width

   image = *sState.ptrData

   IF N_ELEMENTS( bad_columns ) GT 0 THEN BEGIN
      IF bad_columns[0] NE -1 THEN BEGIN
                    ; mask bad columns
         dino_wmessage, sState, 'masking bad columns...'
         PRINT, 'Masking bad columns...'
         dino_mask_bad_columns, image, bad_columns
      ENDIF 
   ENDIF 

   IF N_ELEMENTS( median_width ) GT 0 THEN BEGIN
      IF median_width[0] GT 0 THEN BEGIN
                    ; Perform a median filter on each column
         dino_wmessage, sState, 'median filtering image...'
         dino_median_filter_columns, image, median_width
         
                    ; cosmic ray rejection
         IF cr_sigma[0] GT 0 THEN BEGIN
            dino_wmessage, sState, 'cosmic ray rejection...'
            PRINT, 'Cosmic ray rejection...'
            image_sz = SIZE( image )
            nc = image_sz[1]
            dev = STDDEV( image[nc-16:nc-1,*] )
            bad = WHERE( image GT dev*cr_sigma, bcount )
            PRINT, '   FOUND '+STRTRIM(N_ELEMENTS(bad),2)+' pixels above '+STRTRIM(dev*cr_sigma,2)+' DN'
            IF bcount GT 0 THEN image[bad] = 0
         ENDIF 

                    ; View filtered image
         IF view_image_flag[0] EQ 1 THEN BEGIN
            dino_wmessage, sState, 'viewing filtered image...'
            MKHDR, header, image
            SXADDPAR, header, 'TITLE', sState.plot_title
            SXADDPAR, header, 'SUBTITLE', sState.plot_subtitle
            SXADDPAR, header, 'MEDWIDTH', median_width, 'Median filter width used on each column'
            IF N_ELEMENTS( bad_columns ) GT 0 THEN BEGIN
               IF bad_columns[0] NE -1 THEN BEGIN
                  max_bad = N_ELEMENTS( bad_columns ) < 98
                  FOR i=0, N_ELEMENTS( bad_columns )-1 DO BEGIN
                     name = STRING( FORMAT='(A,I2.2)', 'BADCOL', i+1 )
                     SXADDPAR, header, name, bad_columns[i], $
                      'Bad column number'
                  ENDFOR 
               ENDIF 
            ENDIF 
            SXADDPAR, header, 'COMMENT', 'Trimmed, median filtered array in time order'
            dino_view_image, image, header
         ENDIF
      ENDIF
   ENDIF
   
   dino_wmessage, sState, 'computing spectrum...'
   PRINT, 'Computing spectrum...'
   transform = dino_compute_spectrum( image, pst[0], sst[0], $
                                      ERROR=error_flag, $
                                      FREQUENCY=frequency, $
                                      TIME_SERIES=time_series )

   IF error_flag NE 0 THEN BEGIN
      WSET, saved_window
      return
   ENDIF 

   PTR_FREE, sState.ptrTransform, sState.ptrFrequency, sState.ptrTimeSeries, $
    sState.ptrLineIndex

   sState.ptrTransform = PTR_NEW( transform, /NO_COPY )
   sState.ptrFrequency = PTR_NEW( frequency, /NO_COPY )
   result = 0
   sState.ptrTimeSeries = PTR_NEW( time_series, /NO_COPY )
   sState.ptrLineIndex = PTR_NEW()

   dino_wmessage, sState, 'done.'
   PRINT, 'done.'
   WSET, saved_window

   return
END

; _____________________________________________________________________________

FUNCTION dino_convert_threshold, threshold_value, FROM=from_type, TO=to_type

                    ; Convert last plot type to linear
   CASE from_type OF
      1: BEGIN
         threshold_linear = 10 ^ ( threshold_value / 20.0 )
      END
      2: BEGIN
         threshold_linear = SQRT( threshold_value )
      END 
      ELSE: threshold_linear = threshold_value
   ENDCASE
   
   CASE to_type OF
      1: BEGIN
         threshold_value = 20.0 * ALOG10( threshold_linear )
      END 
      2: BEGIN
         threshold_value = threshold_linear ^ 2  
      END 
      ELSE: threshold_value = threshold_linear
   ENDCASE

   return, threshold_value
END 

; _____________________________________________________________________________

PRO dino_set_threshold_display, sState, FROM=from_type, TO=to_type

   WIDGET_CONTROL, sState.wThresholdField, GET_VALUE=threshold_value

   threshold_value = dino_convert_threshold( threshold_value, $
                                             FROM=from_type, TO=to_type )

   WIDGET_CONTROL, sState.wThresholdField, SET_VALUE=threshold_value

   return
END

; _____________________________________________________________________________

PRO dino_calculate_threshold, sState

   IF NOT PTR_VALID( sState.ptrTransform ) THEN BEGIN
      return
   ENDIF 
   
   dino_wmessage, sState, 'calculating threshold...'

   WIDGET_CONTROL, sState.wThresholdSigmaField, GET_VALUE=sigma
   sigma = sigma > 0.1
   nt = N_ELEMENTS( *sState.ptrTransform ) / 2
   median_value = MEDIAN( ABS((*sState.ptrTransform)[0:nt-1]) )
   stdev_value = STDDEV( ABS((*sState.ptrTransform)[0:nt-1]) )

   threshold_value = median_value + sigma * stdev_value

   WIDGET_CONTROL, sState.wThresholdField, SET_VALUE=FLOAT(threshold_value)
   dino_set_threshold_display, sState, FROM=0b, TO=sState.plot_type

   dino_wmessage, sState, 'done.'

   return
END

; _____________________________________________________________________________

PRO dino_get_lines, sState, line_freq, line_power

   IF ( NOT PTR_VALID( sState.ptrLineIndex ) ) THEN return

   line_freq = (*sState.ptrFrequency)[*sState.ptrLineIndex]
   line_power = ABS( (*sState.ptrTransform)[*sState.ptrLineIndex] ) ^ 2

END 

; _____________________________________________________________________________

PRO dino_update_line_display, sState

   dino_get_lines, sState, line_freq, line_power

   line_count = N_ELEMENTS( line_freq )
   IF line_count GT 0 THEN BEGIN
      CASE BYTE(sState.sort_flag) OF
         1: BEGIN
            sort_index = REVERSE( SORT( line_power ) )
            line_freq = ( TEMPORARY( line_freq ) )[sort_index]
            line_power = ( TEMPORARY( line_power ) )[sort_index]
         END 
         ELSE:
      ENDCASE
      aOutput = MAKE_ARRAY( line_count, /STRING )

      strFormat = '(5X,F12.4,15X,F12.6)'
      FOR i=0l, line_count-1 DO BEGIN
         aOutput[i] = STRING( FORMAT=strFormat, line_freq[i], line_power[i] )
      ENDFOR 
   ENDIF ELSE aOutput = ['']

   WIDGET_CONTROL, sState.wLineList, SET_VALUE=aOutput
END 

; _____________________________________________________________________________

PRO dino_get_hilighted_lines, sState, freq

                    ; get the selected lines
   index = WIDGET_INFO( sState.wLineList, /LIST_SELECT )
   freq = -1
   IF index[0] EQ -1 THEN return

   dino_get_lines, sState, line_freq, line_power
   CASE BYTE(sState.sort_flag) OF
      1: BEGIN
         sort_index = REVERSE( SORT( line_power ) )
         ;;HELP, sort_index
         line_freq = ( TEMPORARY( line_freq ) )[sort_index]
      END 
      ELSE:
   ENDCASE

   freq = line_freq[index]
END

; _____________________________________________________________________________

PRO dino_find_lines, sState, ERROR=error_flag
                    ; error flag: 
                    ;    0 - no error
                    ;    1 - error
                    ;    2 - no peaks above threshold
                    ;    3 - too many peaks found
   error_flag = 0b

   IF NOT PTR_VALID( sState.ptrTransform ) THEN BEGIN
      error_flag = 1b
      return
   ENDIF 

   WIDGET_CONTROL, sState.wThresholdField, GET_VALUE=threshold_value
   threshold_linear = dino_convert_threshold( threshold_value, $
                                              FROM=sState.plot_type, TO=0b )
   IF threshold_linear EQ 0 THEN BEGIN
      dino_wmessage, sState, 'error: threshold value is zero'
   ENDIF 

   dino_wmessage, sState, 'finding frequencies above threshold...'
   nt = N_ELEMENTS( *sState.ptrTransform ) / 2
   line_list = WHERE(ABS((*sState.ptrTransform)[0:nt-1]) GT threshold_linear, $
                      line_count )

   IF line_count LE 0 THEN BEGIN
      dino_wmessage, sState, 'no peaks found above threshold.'
      error_flag = 2b
      return
   ENDIF

   IF line_count GT 500 THEN BEGIN
      dino_wmessage, sState, 'too many peaks found - adjust threshold.'
      error_flag = 3b
      return
   ENDIF 

   PTR_FREE, sState.ptrLineIndex
   sState.ptrLineIndex = PTR_NEW( line_list, /NO_COPY )

   dino_update_line_display, sState

   dino_wmessage, sState, 'done.'

   return
END 

; _____________________________________________________________________________

PRO dino_wmessage, sState, strMessage

   IF N_ELEMENTS( strMessage ) GT 0 THEN $
    WIDGET_CONTROL, sState.wMessageText, SET_VALUE=strMessage

   return
END 

; _____________________________________________________________________________

PRO dino_show_about_event, sEvent

   WIDGET_CONTROL, sEvent.id, GET_UVALUE = event_uval
   
   CASE event_uval OF

      'OK_BUTTON': BEGIN
         IF WIDGET_INFO( sEvent.top, /VALID_ID ) THEN $
          WIDGET_CONTROL, sEvent.top, /DESTROY
      END 

      ELSE: BEGIN
         IF WIDGET_INFO( sEvent.top, /VALID_ID ) THEN $
          WIDGET_CONTROL, sEvent.top, /DESTROY
      END

   ENDCASE

END

PRO dino_show_about, sState

   version = sState.version
   version_date = sState.version_date

   wintitle =  STRING( FORMAT='("About Dino (v",A,")")', version )

   message = [ STRING( FORMAT='("Dino version",1X,A)', version ), $
               'written by: William Jon McCann', $
               'JHU Advanced Camera for Surveys', $
               version_date ]

   wBase = WIDGET_BASE( TITLE=wintitle, GROUP=sState.wRoot, /COLUMN )

   wLabels = LONARR( N_ELEMENTS( message ) )

   wLabels[0] = WIDGET_LABEL( wBase, VALUE = message[0], $
                        FONT = 'helvetica*20', /ALIGN_CENTER )
   FOR i = 1, N_ELEMENTS( message ) - 1 DO BEGIN
      wLabels[i] = WIDGET_LABEL( wBase, VALUE = message[i], $
                           FONT = 'helvetica*14', /ALIGN_CENTER )
   ENDFOR

   wButton = WIDGET_BUTTON( wBase, VALUE = 'OK', /ALIGN_CENTER, $
                          UVALUE = 'OK_BUTTON' )

   WIDGET_CONTROL, wBase, /REALIZE

   XMANAGER, 'dino_show_about', wBase, /NO_BLOCK

END

; _____________________________________________________________________________

PRO dino_show_help_event, sEvent

   WIDGET_CONTROL, sEvent.id, GET_UVALUE = event_uval
   
   CASE event_uval OF

      'OK_BUTTON': BEGIN
         IF WIDGET_INFO( sEvent.top, /VALID_ID ) THEN $
          WIDGET_CONTROL, sEvent.top, /DESTROY
      END 

      ELSE: BEGIN
         IF WIDGET_INFO( sEvent.top, /VALID_ID ) THEN $
          WIDGET_CONTROL, sEvent.top, /DESTROY
      END

   ENDCASE

END

PRO dino_show_help, sState

   version = sState.version
   version_date = sState.version_date

   wintitle =  STRING( FORMAT='("Dino Help (v",A,")")', version )

   aMessage=[STRING( FORMAT='("Dino version",1X,A)', version ) ]
   
   wBase = WIDGET_BASE( TITLE=wintitle, GROUP=sState.wRoot, /COLUMN )

   wLabels = LONARR( N_ELEMENTS( aMessage ) )

   wLabels[0] = WIDGET_LABEL( wBase, VALUE = aMessage[0], $
                        FONT = 'helvetica*20', /ALIGN_CENTER )
   FOR i = 1, N_ELEMENTS( aMessage ) - 1 DO BEGIN
      wLabels[i] = WIDGET_LABEL( wBase, VALUE = aMessage[i], $
                           FONT = 'helvetica*14', /ALIGN_CENTER )
   ENDFOR

   wButton = WIDGET_BUTTON( wBase, VALUE = 'OK', /ALIGN_CENTER, $
                          UVALUE = 'OK_BUTTON' )

   WIDGET_CONTROL, wBase, /REALIZE

   XMANAGER, 'dino_show_help', wBase, /NO_BLOCK

END 

; _____________________________________________________________________________

PRO plot_widget_event, sEvent

   wLocalStateHandler = WIDGET_INFO( sEvent.handler, /CHILD )
   WIDGET_CONTROL, wLocalStateHandler, GET_UVALUE=sLocalState, /NO_COPY

   struct_name = TAG_NAMES( sEvent, /STRUCTURE_NAME)
   
   IF STRUPCASE( struct_name ) EQ 'WIDGET_BASE' THEN BEGIN
      screen_size = GET_SCREEN_SIZE()
      newx = (sEvent.x-10) < (screen_size[0]-30)
      newy = (sEvent.y-10) < (screen_size[1]-30)

      WIDGET_CONTROL, sLocalState.wDraw, XSIZE = newx, YSIZE = newy

   ENDIF ELSE BEGIN

      WIDGET_CONTROL, sEvent.id, GET_UVALUE = event_uval

      CASE STRUPCASE( event_uval ) OF

         'PLOT_DRAW': BEGIN
            CASE STRUPCASE(!VERSION.OS_FAMILY) OF
               'WINDOWS': gdevice = 'WIN'
               'MACOS': gdevice = 'MAC'
               ELSE: gdevice = 'X'
            ENDCASE
            SET_PLOT, gdevice
            saved_window = !D.WINDOW
            WSET, sLocalState.draw_index
            data_coord = CONVERT_COORD(sEvent.x, sEvent.y, /DEVICE, /TO_DATA)
            strOut = STRING( FORMAT='("Noise debug",5X,"[",F12.4,",",F12.6,"]")',$
                             data_coord[0], data_coord[1] )
            WIDGET_CONTROL, sLocalState.wBase, TLB_SET_TITLE=strOut[0]
            WSET, saved_window
            CASE sEvent.type OF
               0: BEGIN
                    ; BUTTON PRESS
                  
               END

               2: BEGIN
                    ; MOTION EVENT

               END               
               ELSE: 
            ENDCASE 
         END 
         ELSE:
      ENDCASE
   ENDELSE

   WIDGET_CONTROL, wLocalStateHandler, SET_UVALUE=sLocalState, /NO_COPY

END

; _____________________________________________________________________________

PRO plot_widget, TopLevelBase, wPlotDraw, $
                 STATE_HANDLER = wStateHandler

   wRoot = WIDGET_BASE( GROUP_LEADER=TopLevelBase, /COLUMN, $
                        TITLE='Noise debug', $
                        UVALUE='PLOT_BASE', $
                        TLB_FRAME_ATTR=8, $
                        /TLB_SIZE_EVENTS )
   wBase = WIDGET_BASE( wRoot, XPAD=0, YPAD=0, SPACE=0, /COLUMN, /ALIGN_CENTER )

   wPlotBase = WIDGET_BASE( wBase, XPAD=0, YPAD=0, SPACE=0, /COLUMN )
   screen_size = GET_SCREEN_SIZE()
   wPlotDraw = WIDGET_DRAW( wPlotBase, XSIZE=screen_size[0]-30, YSIZE=400, $
                            /MOTION_EVENTS, /BUTTON_EVENTS, $
                            UVALUE='PLOT_DRAW', COLORS=-2, RETAIN=2 )

   WIDGET_CONTROL, /REALIZE, wRoot
   WIDGET_CONTROL, wRoot, TLB_SET_XOFFSET=0, TLB_SET_YOFFSET=0
   WIDGET_CONTROL, GET_VALUE=draw_index, wPlotDraw
   WSHOW, draw_index

   sState = { wRoot: wRoot, $
              wBase: wBase, $
              wDraw: wPlotDraw, $
              wStateHandler: wStateHandler, $
              draw_index: draw_index }

   WIDGET_CONTROL, wBase, SET_UVALUE=sState, /NO_COPY

   XMANAGER, 'plot_widget', wRoot, /NO_BLOCK
   
END

; _____________________________________________________________________________

PRO dino_plot_printer, sState

   WIDGET_CONTROL, sState.wPlotXminField, GET_VALUE=fPlotXmin
   WIDGET_CONTROL, sState.wPlotXmaxField, GET_VALUE=fPlotXmax
   WIDGET_CONTROL, sState.wPlotYminField, GET_VALUE=fPlotYmin
   WIDGET_CONTROL, sState.wPlotYmaxField, GET_VALUE=fPlotYmax
   WIDGET_CONTROL, sState.wPlotTypeButtons, GET_VALUE=plot_type
   WIDGET_CONTROL, sState.wThresholdField, GET_VALUE=threshold_value

   IF PTR_VALID( sState.ptrTransform ) THEN BEGIN
      dino_wmessage, sState, 'plotting data...'
      WIDGET_CONTROL, /HOURGLASS

      saved_device = !D.NAME
      SET_PLOT, 'PS'
      strPSfile = (sState.last_plot EQ 1) ? 'dino_spectrum.ps' : 'dino_time.ps'
      DEVICE, FILENAME=strPSfile, /LANDSCAPE

      nt = N_ELEMENTS( *sState.ptrTransform ) / 2

      IF sState.last_plot EQ 1 THEN BEGIN
         dino_plot_data, (*sState.ptrFrequency)[0:nt-1], $
          ABS((*sState.ptrTransform)[0:nt-1]), $
          XMIN=fPlotXmin[0], XMAX=fPlotXmax[0], $
          YMIN=fPlotYmin[0], YMAX=fPlotYmax[0], $
          TITLE=sState.plot_title, SUBTITLE=sState.plot_subtitle, $
          PLOT_TYPE=plot_type, FONT=0
      ENDIF ELSE IF sState.last_plot EQ 2 THEN BEGIN
         dino_plot_time, sState
      ENDIF 

      DEVICE, /CLOSE
      SET_PLOT, saved_device
      WSET, sState.draw_index

      dino_wmessage, sState, 'executing print command...'
      strCmd = dino_get_lp_command(strPSfile)
      SPAWN, strCmd

      dino_wmessage, sState, 'plot sent to printer.'

      IF sState.last_plot EQ 1 THEN BEGIN
         dino_plot_data, (*sState.ptrFrequency)[0:nt-1], $
          ABS((*sState.ptrTransform)[0:nt-1]), $
          XMIN=fPlotXmin[0], XMAX=fPlotXmax[0], $
          YMIN=fPlotYmin[0], YMAX=fPlotYmax[0], $
          TITLE=sState.plot_title, SUBTITLE=sState.plot_subtitle, $
          PLOT_TYPE=plot_type, THRESHOLD=threshold_value
      ENDIF ELSE IF sState.last_plot EQ 2 THEN BEGIN
         dino_plot_time, sState
      ENDIF 
   ENDIF

   return
END 

; _____________________________________________________________________________

PRO dino_plot_time, sState

   WIDGET_CONTROL, sState.wPlotXminField, GET_VALUE=xmin
   WIDGET_CONTROL, sState.wPlotXmaxField, GET_VALUE=xmax
   WIDGET_CONTROL, sState.wPlotYminField, GET_VALUE=ymin
   WIDGET_CONTROL, sState.wPlotYmaxField, GET_VALUE=ymax

   IF PTR_VALID( sState.ptrTimeSeries ) THEN BEGIN
      dino_wmessage, sState, 'plotting time series...'
      sState.last_plot = 2
      WIDGET_CONTROL, /HOURGLASS
      
      strXTitle = 'Time step'
      strYTitle = 'Value'
      strTitle  = 'Time series'
      strSubTitle = ''
      
      image_size = SIZE( *sState.ptrData )
      nc = image_size[1]
      nx = nc + (sState.parallel_shift_time / sState.serial_shift_time)

      plot_y = (*sState.ptrTimeSeries)
      ystyle = 3
      
      plot_x = LINDGEN( N_ELEMENTS(plot_y) )

      IF N_ELEMENTS( xmin ) LE 0 THEN xmin = MIN( plot_x ) ELSE xmin=xmin[0]
      IF N_ELEMENTS( xmax ) LE 0 THEN xmax = MAX( plot_x ) ELSE xmax=xmax[0]
      IF N_ELEMENTS( ymin ) LE 0 THEN ymin = MIN( plot_y ) ELSE ymin=ymin[0]
      IF N_ELEMENTS( ymax ) LE 0 THEN ymax = MAX( plot_y ) ELSE ymax=ymax[0]

      xstyle = 1
      ystyle = 1
      xrange_set = 1b
      yrange_set = 1b
                    ; If they are both zero assume they have not been set
      IF (xmin EQ 0) AND (xmax EQ 0) THEN BEGIN
         xrange_set = 0b
         xmin = MIN( plot_x )
         xmax = MAX( plot_x )
         xstyle = 3
      ENDIF 
                    ; if the max is less than the min
      IF (xmax LT xmin) THEN xmax = MAX( plot_x )
      xmin = xmin < (N_ELEMENTS(plot_y)-1)
      xmax = xmax < (N_ELEMENTS(plot_y)-1)

      IF (ymin EQ 0) AND (ymax EQ 0) THEN BEGIN
         yrange_set = 0b
         ymin = MIN( plot_y[xmin:xmax] )
         ymax = MAX( plot_y[xmin:xmax] )
         ystyle = 3
      ENDIF
                    ; if the max is less than the min
      IF (ymax LT ymin) THEN ymax = MAX( plot_y )
      ymin = ymin < (N_ELEMENTS(plot_y)-1)
      ymax = ymax < (N_ELEMENTS(plot_y)-1)

      xrange = [xmin, xmax]
      yrange = [ymin, ymax]

      subs = WHERE( (plot_x GE xmin) AND (plot_x LE xmax), xcount )
      IF xcount GT 0 THEN BEGIN
         plot_x = plot_x[subs]
         plot_y = plot_y[subs]
      ENDIF 

      PLOT, plot_x, plot_y, PSYM=10, $
       XTITLE=strXTitle, YTITLE=strYTitle, TITLE=strTitle, $
       SUBTITLE=strSubTitle, XSTYLE=xstyle, YSTYLE=ystyle, $
       XRANGE=xrange, YRANGE=yrange

                    ; plot row markers
      FOR i=1, 20 DO OPLOT, [1,1]*nx*i, !Y.CRANGE, LINESTYLE=1

      dino_wmessage, sState, 'ready.'
   ENDIF 

END 

; _____________________________________________________________________________

PRO dino_plot_screen, sState

   WIDGET_CONTROL, sState.wPlotXminField, GET_VALUE=fPlotXmin
   WIDGET_CONTROL, sState.wPlotXmaxField, GET_VALUE=fPlotXmax
   WIDGET_CONTROL, sState.wPlotYminField, GET_VALUE=fPlotYmin
   WIDGET_CONTROL, sState.wPlotYmaxField, GET_VALUE=fPlotYmax
   WIDGET_CONTROL, sState.wPlotTypeButtons, GET_VALUE=plot_type
   WIDGET_CONTROL, sState.wThresholdField, GET_VALUE=threshold_value

   CASE STRUPCASE(!VERSION.OS_FAMILY) OF
      'WINDOWS': gdevice = 'WIN'
      'MACOS': gdevice = 'MAC'
      ELSE: gdevice = 'X'
   ENDCASE
   SET_PLOT, gdevice
   saved_window = !D.WINDOW
   WSET, sState.draw_index
   IF PTR_VALID( sState.ptrTransform ) THEN BEGIN
      dino_wmessage, sState, 'plotting data...'
      WIDGET_CONTROL, /HOURGLASS

      nt = N_ELEMENTS( *sState.ptrTransform ) / 2
      sState.last_plot = 1
      dino_plot_data, (*sState.ptrFrequency)[0:nt-1], $
       ABS((*sState.ptrTransform)[0:nt-1]), $
       XMIN = fPlotXmin[0], XMAX = fPlotXmax[0], $
       YMIN = fPlotYmin[0], YMAX = fPlotYmax[0], $
       TITLE=sState.plot_title, SUBTITLE=sState.plot_subtitle, $
       PLOT_TYPE=plot_type, THRESHOLD=threshold_value[0]

      dino_wmessage, sState, 'done.'
   ENDIF
   WSET, saved_window

   return
END 

; _____________________________________________________________________________

PRO dino_filter_lines, sState, PASS=pass, REJECT=reject

   IF KEYWORD_SET( pass ) THEN type = 'PASS' ELSE type = 'REJECT'

   IF PTR_VALID( sState.ptrTransform ) THEN BEGIN
      transform = *sState.ptrTransform
      IF PTR_VALID(sState.ptrLineIndex) THEN BEGIN
         dino_wmessage, sState, 'finding lines and harmonics...'
         WIDGET_CONTROL, /HOURGLASS
         nt = N_ELEMENTS( transform )
         dino_get_hilighted_lines, sState, freq
         IF freq[0] NE -1 THEN BEGIN
            n_toler = 3
            all_lines = [-1l]
            FOR i=0l, N_ELEMENTS(freq)-1 DO BEGIN
               line_i = (WHERE( (*sState.ptrFrequency) EQ freq[i], lcount ))[0]
               IF lcount GT 0 THEN BEGIN
                  n_harm = nt / (2 * line_i)
                    ; make the 1D array for centers of each harmonic
                  centers = (INDGEN(n_harm-1)+1) * line_i
                    ; make the 2D array for centers
                  centera = TRANSPOSE( centers # REPLICATE(1,n_toler) )
                    ; make the tolerance 1D array ie. [-2,-1,0,1,2]
                  toler   = INDGEN( n_toler )-FIX(n_toler/2)
                    ; make the tolerance 2D array
                  tolera  = toler # REPLICATE(1,n_harm-1)

                    ; make the 2d line array
                  lines = centera + tolera
                  n_elem = N_ELEMENTS( lines )
                    ; make into 1D array
                  lines = REFORM(TEMPORARY(lines),n_elem)
                  ;;HELP, lines
                  all_lines = [all_lines,lines]
                  ;;HELP, all_lines
               ENDIF
            ENDFOR 
            IF N_ELEMENTS(all_lines) GT 1 THEN BEGIN
               CASE type OF
                  'REJECT': BEGIN
                     transform[all_lines[1:*]] = 0 ;COMPLEX(0,IMAGINARY(transform[lines]))
                     transform[nt-1-all_lines[1:*]] = 0 ;COMPLEX(0,IMAGINARY(transform[nt-1-lines]))
                  END
                  'PASS': BEGIN
                     mask = transform * 0
                     mask[all_lines[1:*]] = 1
                     mask[nt-1-all_lines[1:*]] = 1
                     transform = TEMPORARY( transform ) * TEMPORARY( mask )
                  END 
                  ELSE:
               ENDCASE
            ENDIF 
         ENDIF
      ENDIF
      dino_wmessage, sState, 'reverting spectrum...'
      pps = sState.parallel_shift_time / sState.serial_shift_time
      image_sz = SIZE( *sState.ptrData )
      xsize = image_sz[1] + pps
      ysize = image_sz[2]
      WIDGET_CONTROL, /HOURGLASS
      image = dino_revert_spectrum( transform, xsize, ysize )
      ;;HELP, image
      IF N_ELEMENTS( image ) GT 2 THEN BEGIN
         mview, image, /AUTO, TITLE='Inverse transform'
      ENDIF 
      dino_wmessage, sState, 'done.'
   ENDIF

END 

; _____________________________________________________________________________

PRO dino_show_profile, sState

    IF PTR_VALID( sState.ptrTransform ) THEN BEGIN
      transform = *sState.ptrTransform
      IF PTR_VALID(sState.ptrLineIndex) THEN BEGIN
         WIDGET_CONTROL, /HOURGLASS
         nt = N_ELEMENTS( transform )
         dino_get_hilighted_lines, sState, freq
         IF freq[0] NE -1 THEN BEGIN
            dino_wmessage, sState, 'computing pulse profile...'
                    ; convert freq to period
            freq = freq[0]
            sst = sState.serial_shift_time * 1e-6
            period = 1 / (freq * sst)
            period_pix = LONG( ROUND( period) )

                    ; create profile
            nt = N_ELEMENTS( *sState.ptrTimeSeries )
            n_profs = FLOOR(nt / period)

;            trimmed_length = period_pix * n_profs
;            tst = (*sState.ptrTimeSeries)[0:trimmed_length-1]
;            tst = REFORM( tst, period_pix, n_profs, /OVERWRITE )
            profiles = MAKE_ARRAY( period_pix, n_profs, /DOUBLE )
            FOR i=0l, n_profs-1 DO BEGIN
               start = FLOOR( i * period )
               t0 = start
               t1 = start+period_pix-1
               profiles[0,i] = (*sState.ptrTimeSeries)[t0:t1]
            ENDFOR 

            profile = TOTAL( profiles, 2, /DOUBLE ) / n_profs

            mean = TOTAL(profile)/period_pix
            sq = TOTAL(profile^2)/period_pix
            rms = SQRT((sq - mean^2) > 0.)

            strTitle = STRING( FORMAT='("Pulse Profile ",G," Hz   ",F5.3," rms")',$
                               freq, rms )
            pplot, profile, WTITLE='Dino Pulse Profile', XTITLE='Pixels', $
             YTITLE='Average value (DN)', TITLE=strTitle, $
             SUBTITLE=sState.plot_subtitle
            dino_wmessage, sState, 'done.'
         ENDIF ELSE dino_wmessage,sState,'No lines selected.'
      ENDIF ELSE dino_wmessage,sState,'No lines defined.'
   ENDIF ELSE dino_wmessage,sState,'No spectrum defined.'
END 

; _____________________________________________________________________________

PRO dino_plot_regions, ptr, ccdamps, amp
   
   image_sz = SIZE(*ptr)
   n_regions = 5

   font_type = 0

   ny = (image_sz[2] - 30) / n_regions
   nx = image_sz[1] - 100
   start_y = 0.48
   FOR i=0,n_regions DO BEGIN
      IF i EQ n_regions THEN BEGIN
         x0 = 6
         x1 = 16
         y0 = 30
         y1 = image_sz[2] - 30
      ENDIF ELSE BEGIN
         x0 = 50
         x1 = x0+nx-1
         y0 = ny*i
         y1 = y0+ny-1
      ENDELSE

      IF i LT 3 THEN BEGIN
         xpos0 = 0.35
         xpos1 = 0.45
         ypos0 = 0.32 - 0.15 * i
      ENDIF ELSE BEGIN        
         xpos0 = 0.70
         xpos1 = 0.80
         ypos0 = 0.32 - 0.15 * (i-3)
      ENDELSE
      ypos1 = ypos0 + 0.12
      
      median = MEDIAN((*ptr)[x0:x1,y0:y1])
      stddev = STDDEV((*ptr)[x0:x1,y0:y1])
      IF stddev EQ 0 THEN BEGIN
         MESSAGE, 'Standard deviation is zero in region.', /CONTINUE
         GOTO, ENDLOOP
      ENDIF 
      cutoff = median+20*stddev
      region = (*ptr)[x0:x1,y0:y1]
      good = WHERE(region LT cutoff, gcount)
      IF gcount LT 5 THEN BEGIN
         MESSAGE, 'NOT enough good pixels found below '+STRTRIM(cutoff,2),$
          /CONTINUE
         GOTO, ENDLOOP
      ENDIF 
      n_bad = N_ELEMENTS(region)-gcount
      PRINT, 'Rejecting '+STRTRIM(n_bad,2)+' pixels above '+STRTRIM(cutoff,2)
      median = MEDIAN(region[good])
      stddev = STDDEV(region[good])
      mean = MEAN(region[good])
      min = MIN(region[good])
      max = MAX(region[good])
      charsize = 0.65
      charthick = 2.0
      delta_y = 0.023 * charsize

      xoff = 0.02
      IF i EQ n_regions THEN label = 'Overscan region' ELSE label='Image region'
      XYOUTS, xpos1+xoff, ypos1-delta_y/2, label+' ('+STRTRIM(x0,2)+':'+ $
       STRTRIM(x1,2)+','+STRTRIM(y0,2)+':'+STRTRIM(y1,2)+')', /NORMAL, $
       CHARTHICK=charthick, CHARSIZE=charsize, FONT=font_type
      XYOUTS, xpos1+xoff, ypos1-3*delta_y,/NORMAL,ALIGN=0,CHARSIZE=charsize, $
       CHARTHICK=charthick, FONT=font_type, $
       STRING(FORMAT='(A,1X,I5)', 'Min    :', min)
      XYOUTS, xpos1+xoff, ypos1-4*delta_y,/NORMAL,ALIGN=0,CHARSIZE=charsize, $
       CHARTHICK=charthick, FONT=font_type, $
       STRING(FORMAT='(A,1X,I5)', 'Max    :', max)
      XYOUTS, xpos1+xoff, ypos1-5*delta_y,/NORMAL,ALIGN=0,CHARSIZE=charsize, $
       CHARTHICK=charthick, FONT=font_type, $
       STRING(FORMAT='(A,1X,F8.2)', 'Mean   :', mean)
      XYOUTS, xpos1+xoff, ypos1-6*delta_y,/NORMAL,ALIGN=0,CHARSIZE=charsize, $
       CHARTHICK=charthick, FONT=font_type, $
       STRING(FORMAT='(A,1X,I5)', 'Median :', median)
      XYOUTS, xpos1+xoff, ypos1-7*delta_y,/NORMAL,ALIGN=0,CHARSIZE=charsize, $
       CHARTHICK=charthick, FONT=font_type, $
       STRING(FORMAT='(A,1X,F7.2)', 'Stdev :', stddev)
      
      binsize = 1
      hist = HISTOGRAM((*ptr)[x0:x1,y0:y1], OMIN=o_min, OMAX=o_max, $
                       BINSIZE=binsize)
      IF N_ELEMENTS(hist) GT 2 THEN BEGIN
         xrange = [median-5*stddev,median+5*stddev]
         hist_x = LINDGEN( LONG((o_max-o_min+1)/binsize) ) * binsize + o_min

                    ; fit a gaussian to the histogram
         hfit = GAUSSFIT(hist_x,hist,a)
         IF TOTAL(FINITE(xrange)) NE N_ELEMENTS(xrange) THEN BEGIN
            PLOT, hist_x, hist, PSYM=10, XTICKS=1, FONT=font_type, $
             POSITION=[xpos0,ypos0,xpos1,ypos1], XSTYLE=3
         ENDIF ELSE BEGIN
            PLOT, hist_x, hist, PSYM=10, XTICKS=1, XRANGE=xrange, $
             FONT=font_type, POSITION=[xpos0,ypos0,xpos1,ypos1], XSTYLE=3
         ENDELSE
         OPLOT, hist_x, hfit, /LINESTYLE
         XYOUTS, xpos1+xoff, ypos1-8*delta_y,/NORMAL,ALIGN=0,$
          CHARTHICK=charthick, CHARSIZE=charsize, FONT=font_type, $
          STRING(FORMAT='(A,1X,F7.2)', 'Fit sigma :', a[2])
         
      ENDIF ELSE BEGIN
         PLOT, [0,1], XTICKS=1, FONT=font_type, $
          POSITION=[xpos0,ypos0,xpos1,ypos1], XSTYLE=3
      ENDELSE 
ENDLOOP:
   ENDFOR 

   return
END 

; _____________________________________________________________________________

PRO dino_auto_plot, sState, ccdamps, amp, value, LINES_ERROR=lines_error

   IF N_ELEMENTS(lines_error) LE 0 THEN lines_error = 0

   WIDGET_CONTROL, sState.wPlotXminField, GET_VALUE=fPlotXmin
   WIDGET_CONTROL, sState.wPlotXmaxField, GET_VALUE=fPlotXmax
   WIDGET_CONTROL, sState.wPlotYminField, GET_VALUE=fPlotYmin
   WIDGET_CONTROL, sState.wPlotYmaxField, GET_VALUE=fPlotYmax
   WIDGET_CONTROL, sState.wPlotTypeButtons, GET_VALUE=plot_type
   WIDGET_CONTROL, sState.wThresholdField, GET_VALUE=threshold_value

   HELP, threshold_value

   IF PTR_VALID( sState.ptrTransform ) THEN BEGIN
      dino_wmessage, sState, 'auto plotting data...'
      WIDGET_CONTROL, /HOURGLASS

      pmulti_saved = !P.MULTI
      saved_device = !D.NAME
      SET_PLOT, 'PS'
      charthick = 3.0
      charsize = 2.0
      font_type = 0
      !P.MULTI = [0,1,7]
      strPSfile = dino_get_ps_filename(value,amp)
      DEVICE, FILENAME=strPSfile, /LANDSCAPE

      nt = N_ELEMENTS(*sState.ptrTransform) / 2
      
                    ; Draw plot
      position = [0.05,0.55,1,0.95]
      dino_plot_data, (*sState.ptrFrequency)[0:nt-1], $
       ABS((*sState.ptrTransform)[0:nt-1]), $
       XMIN=fPlotXmin[0], XMAX=fPlotXmax[0], $
       YMIN=fPlotYmin[0], YMAX=fPlotYmax[0], $
       TITLE=sState.plot_title, SUBTITLE=sState.plot_subtitle, $
       PLOT_TYPE=plot_type, POSITION=position, $
       FONT=font_type, CHARSIZE=charsize, CHARTHICK=charthick

                    ; Write lines
      IF PTR_VALID( sState.ptrLineIndex ) THEN BEGIN
         dino_get_lines, sState, line_freq, line_power
         good = WHERE(line_freq NE 0, n_lines)
         IF n_lines GT 0 THEN BEGIN
            line_power = (TEMPORARY(line_power))[good]
            line_freq = (TEMPORARY(line_freq))[good]
            sort_index = REVERSE(SORT(line_power))
            line_freq = (TEMPORARY(line_freq))[sort_index]
            line_power = (TEMPORARY(line_power))[sort_index]

            delta_y = 0.023
            start_y = .43
            charsize = 0.65
            charthick = 2.0
            strout = STRING(FORMAT='(A,1X,G10.4)','Peak frequencies above',$
                            threshold_value)
            XYOUTS, .15, start_y, /NORMAL, strout, CHARSIZE=charsize, $
             ALIGN=0.5, FONT=font_type, CHARTHICK=charthick
            strout = STRING(FORMAT='(A14,2X,A12)','Frequency (Hz)','Power')
            XYOUTS, .15, start_y-delta_y, /NORMAL, strout, CHARSIZE=charsize, $
             ALIGN=0.5, FONT=font_type, CHARTHICK=charthick
            strFormat = '(2X,F12.4,2X,F12.6)'
            n_lines = n_lines < 30
            delta_x = 0.15
            xoffset = 0
            yoffset = 4 * delta_y*charsize
            FOR i=0l,n_lines-1 DO BEGIN
               freq = line_freq[i]
               power = line_power[i]
               outstr = STRING(FORMAT=strFormat,freq,power)
               XYOUTS, .15+xoffset, start_y-yoffset, outstr, $
                /NORMAL, ALIGN=0.5, CHARSIZE=charsize, FONT=font_type
               yoffset = yoffset + delta_y*charsize
            ENDFOR
         ENDIF ELSE BEGIN
            start_y = .43
            charsize = 0.65
            strout = STRING(FORMAT='(A,1X,G10.4)','No peak frequencies above',$
                            threshold_value)
            XYOUTS, .15, start_y, /NORMAL, strout, CHARSIZE=charsize+0.2, $
             ALIGN=0.5, FONT=font_type, CHARTHICK=charthick
         ENDELSE
      ENDIF ELSE BEGIN
         start_y = .43
         charsize = 0.65
                    ; error flag: 
                    ;    0 - no error
                    ;    1 - error
                    ;    2 - no peaks above threshold
                    ;    3 - too many peaks found
         CASE lines_error OF
            3: BEGIN
               strout = STRING(FORMAT='(A,1X,G10.4)','Too many peaks found above',$
                               threshold_value)
            END 
            2: BEGIN
               strout = STRING(FORMAT='(A,1X,G10.4)','No peak frequencies above',$
                               threshold_value)
            END 
            ELSE: BEGIN
               strout = STRING(FORMAT='(A)','Problem identifying peak frequencies')
            END 
         ENDCASE 
         XYOUTS, .15, start_y, /NORMAL, strout, CHARSIZE=charsize+0.2, $
          ALIGN=0.5, FONT=font_type, CHARTHICK=charthick
      ENDELSE

                    ; Plot regions
      dino_plot_regions, sState.ptrData, ccdamps, amp

                    ; Print out the entry/filename
      XYOUTS, 1, -0.05, /NORMAL, ALIGN=1.0, STRTRIM(value,2)+' '+amp, $
       CHARSIZE=1.5, CHARTHICK=3.0, FONT=font_type

      DEVICE, /CLOSE
      SET_PLOT, saved_device
      WSET, sState.draw_index
      !P.MULTI = pmulti_saved

      dino_wmessage, sState, 'executing print command...'
      strCmd = dino_get_lp_command(strPSfile)
      SPAWN, strCmd

      dino_wmessage, sState, 'plot sent to printer.'

      IF sState.last_plot EQ 1 THEN BEGIN
         dino_plot_data, (*sState.ptrFrequency)[0:nt-1], $
          ABS((*sState.ptrTransform)[0:nt-1]), $
          XMIN=fPlotXmin[0], XMAX=fPlotXmax[0], $
          YMIN=fPlotYmin[0], YMAX=fPlotYmax[0], $
          TITLE=sState.plot_title, SUBTITLE=sState.plot_subtitle, $
          PLOT_TYPE=plot_type, THRESHOLD=threshold_value
      ENDIF ELSE IF sState.last_plot EQ 2 THEN BEGIN
         dino_plot_time, sState
      ENDIF 
   ENDIF
   
END 

; _____________________________________________________________________________

PRO dino_auto_remove_ps, type, value

   env_template = GETENV('DINO_AUTO_PS_FILE')
   default_template = 'dino_%v%a_plot.ps'
   strTemplate = (env_template[0] EQ '') ? default_template : env_template[0]

   strTempl1 = STRJOIN(STRSPLIT(strTemplate,'%v',/REGEX,/EXTRACT), '*') 
   strPattern = STRJOIN(STRSPLIT(strTempl1,'%a',/REGEX,/EXTRACT), '?')

   directory_list = FINDFILE(strPattern, COUNT=dir_count)
   IF dir_count LE 0 THEN return
   CASE type OF
      'ACS_LOG': BEGIN
         last_good = 'dino_'+STRTRIM(LONG(value)-20,2)
      END
      'ACS_SDI': BEGIN
         prefix = STRMID(value,0,11) + '0000'
         last_good = 'dino_'+STRTRIM(prefix,2)
      END
      ELSE: return
   ENDCASE
   lg_len = STRLEN(last_good)
   rm_list = WHERE(STRMID(directory_list,0,lg_len) LT last_good, rcount)
   IF rcount GT 0 THEN BEGIN
      list = directory_list[rm_list]
      PRINT, 'Removing old PostScript files: ', list
      aCmd = dino_get_rm_command(list)
      FOR i=0,N_ELEMENTS(list)-1 DO SPAWN, aCmd[i]
   ENDIF 
END

; _____________________________________________________________________________

PRO dino_auto_process, sState, type, value, ERROR=error_flag, $
                       PRINT=print, SAVE_LINES=save_lines

   error_flag = 1b
   IF N_ELEMENTS(type) LE 0 THEN return
   IF N_ELEMENTS(value) LE 0 THEN return
   error_flag = 0b

   ccdamps = dino_get_amps(type,value)
   IF STRTRIM(ccdamps[0],2) EQ '-1' THEN BEGIN
      error_flag = 1b
      return
   ENDIF 

                    ; Remove old postscript files
   IF KEYWORD_SET(print) THEN $
    dino_auto_remove_ps, type, value

   n_amps = STRLEN(STRTRIM(ccdamps,2))
   FOR i=0,n_amps-1 DO BEGIN
      amp = STRMID(ccdamps,i,1)
      dino_wmessage, sState, 'loading new data (amp '+amp+')'
      PRINT, 'Loading new data (amp '+amp+')'
      WIDGET_CONTROL, /HOURGLASS
      dino_open, sState, type, value, ERROR=error_flag, AMP=amp
      IF error_flag NE 0 THEN return
      
      dino_wmessage, sState, 'processing data...'
      WIDGET_CONTROL, /HOURGLASS
      dino_process_data, sState, ERROR=error_flag
      IF error_flag NE 0 THEN return
      
      ;;dino_wmessage, sState, 'calculating threshold...'
      ;;dino_calculate_threshold, sState
      
      IF sState.last_plot EQ 2 THEN BEGIN
         WIDGET_CONTROL, sState.wPlotXminField, SET_VALUE=0
         WIDGET_CONTROL, sState.wPlotXmaxField, SET_VALUE=1000
         WIDGET_CONTROL, sState.wPlotYminField, SET_VALUE=0
         WIDGET_CONTROL, sState.wPlotYmaxField, SET_VALUE=0
         sState.last_plot = 1
      ENDIF 
      dino_plot_screen, sState
      dino_update_line_display, sState
   
      dino_find_lines, sState, ERROR=error_flag
      
      IF KEYWORD_SET(print) THEN $
       dino_auto_plot, sState, ccdamps, amp, value, LINES_ERROR=error_flag

      IF KEYWORD_SET(save_lines) THEN BEGIN
         lines_filename = dino_get_peak_filename(value,amp)
         dino_save_lines, sState, FILENAME=lines_filename, ERROR=error_code
      ENDIF 
   ENDFOR

   dino_wmessage, sState, 'done.'
END 

; _____________________________________________________________________________

PRO dino_event, sEvent

                    ; get state information from first child of root
   wChildBase = WIDGET_INFO( sEvent.handler, /CHILD )
   wStateHandler = WIDGET_INFO( wChildBase, /SIBLING )
   WIDGET_CONTROL, wStateHandler, GET_UVALUE=sState

   junk = WHERE( 'UVALUE' EQ TAG_NAMES( sEvent ), uvcount )
   IF uvcount LE 0 THEN $
    WIDGET_CONTROL, sEvent.id, GET_UVALUE = event_uval $
   ELSE event_uval = sEvent.UVALUE

   CASE STRUPCASE( event_uval ) OF

      'ROOT': BEGIN
         IF TAG_NAMES( sEvent, /STRUCTURE_NAME) EQ 'WIDGET_KILL_REQUEST' $
          THEN BEGIN
            dino_free_pointers, sState
            WIDGET_CONTROL, sEvent.top, /DESTROY
            return
         ENDIF
      END 

      'THRESHOLD_LOCK_BUTTON': BEGIN
         select = sEvent.select
         IF select EQ 1 THEN BEGIN
            WIDGET_CONTROL, sState.wThresholdSigmaField, SENSITIVE=0
            WIDGET_CONTROL, sState.wRecomputeThresholdButton, SENSITIVE=0
         ENDIF ELSE BEGIN
            WIDGET_CONTROL, sState.wThresholdSigmaField, SENSITIVE=1
            WIDGET_CONTROL, sState.wRecomputeThresholdButton, SENSITIVE=1
         ENDELSE
      END

      'RECOMPUTE_THRESHOLD_BUTTON': BEGIN
         dino_calculate_threshold, sState
      END

      'VIEW_IMAGE_BUTTON':

      'PLOT_BUTTON': BEGIN
         IF sState.last_plot EQ 2 THEN BEGIN
                    ; if the last plot was temporal then use default
                    ; range values
            WIDGET_CONTROL, sState.wPlotXminField, SET_VALUE=0
            WIDGET_CONTROL, sState.wPlotXmaxField, SET_VALUE=1000
            WIDGET_CONTROL, sState.wPlotYminField, SET_VALUE=0
            WIDGET_CONTROL, sState.wPlotYmaxField, SET_VALUE=0
         ENDIF 
         dino_plot_screen, sState
      END

      'HARDCOPY_BUTTON': BEGIN
         dino_plot_printer, sState
      END

      'TIME_PLOT_BUTTON': BEGIN
         IF sState.last_plot EQ 1 THEN BEGIN
                    ; if the last plot was spectral then use default
                    ; range values
            WIDGET_CONTROL, sState.wPlotXminField, SET_VALUE=0
            WIDGET_CONTROL, sState.wPlotXmaxField, SET_VALUE=2e4
            WIDGET_CONTROL, sState.wPlotYminField, SET_VALUE=0
            WIDGET_CONTROL, sState.wPlotYmaxField, SET_VALUE=0
         ENDIF
         CASE STRUPCASE(!VERSION.OS_FAMILY) OF
            'WINDOWS': gdevice = 'WIN'
            'MACOS': gdevice = 'MAC'
            ELSE: gdevice = 'X'
         ENDCASE
         SET_PLOT, gdevice
         saved_window = !D.WINDOW
         WSET, sState.draw_index
         dino_plot_time, sState
         WSET, saved_window
      END

      'CALCULATE_BUTTON': BEGIN
         WIDGET_CONTROL, /HOURGLASS
         dino_process_data, sState, ERROR=error
         IF ( error EQ 0 ) THEN BEGIN
            WIDGET_CONTROL, sState.wThresholdLockButton, GET_VALUE=threshold_lock
            IF threshold_lock NE 1 THEN $
             dino_calculate_threshold, sState

            IF sState.last_plot EQ 2 THEN BEGIN
               WIDGET_CONTROL, sState.wPlotXminField, SET_VALUE=0
               WIDGET_CONTROL, sState.wPlotXmaxField, SET_VALUE=1000
               WIDGET_CONTROL, sState.wPlotYminField, SET_VALUE=0
               WIDGET_CONTROL, sState.wPlotYmaxField, SET_VALUE=0
               sState.last_plot = 1
            ENDIF 
            dino_plot_screen, sState
            dino_update_line_display, sState
         ENDIF 
      END

      'FIND_LINES_BUTTON': BEGIN
         dino_find_lines, sState
      END

      'DINO_LOAD': BEGIN
                    ; process in an automated fashion
         dino_wmessage, sState, 'received DINO_LOAD event'
         WIDGET_CONTROL, /HOURGLASS
         error_flag = 0b
         type = sEvent.type
         data = sEvent.value
         WIDGET_CONTROL, wStateHandler, SET_UVALUE=sState
         print = sEvent.print
         save_lines = sEvent.save_lines
         FOR i=0,N_ELEMENTS(data)-1 DO BEGIN
            dino_auto_process, sState, type, data[i], ERROR=error_flag, $
             PRINT=print, SAVE_LINES=save_lines
            IF error_flag EQ 0 THEN dino_wmessage, sState, 'ready.'
         ENDFOR
      END

      'MENU': BEGIN
         CASE sEvent.value OF

            'File.Open.ACS_LOG': BEGIN
               WIDGET_CONTROL, wStateHandler, SET_UVALUE=sState
               dino_open, sState, 'ACS_LOG'
            END 

            'File.Open.ACS SDI': BEGIN
               WIDGET_CONTROL, wStateHandler, SET_UVALUE=sState
               dino_open, sState, 'ACS_SDI'
            END

            'File.Open.ACS FITS': BEGIN
               WIDGET_CONTROL, wStateHandler, SET_UVALUE=sState
               dino_open, sState, 'ACS_FITS'
            END 

            'File.Open.FITS': BEGIN
               WIDGET_CONTROL, wStateHandler, SET_UVALUE=sState
               dino_open, sState, 'FITS'
            END 

            ;; ADD YOUR TYPE HERE

            'File.Save.Peaks': BEGIN
               dino_save_lines, sState
            END 

            'File.Exit': BEGIN
               dino_free_pointers, sState
               WIDGET_CONTROL, sEvent.top, /DESTROY
               return
            END

            'Lines.Sort.Frequency': BEGIN
               sState.sort_flag = 0b
               dino_update_line_display, sState
            END

            'Lines.Sort.Power': BEGIN
               sState.sort_flag = 1b
               dino_update_line_display, sState
            END 

            'Lines.Pass filter': BEGIN
               dino_filter_lines, sState, /PASS
            END 

            'Lines.Reject filter': BEGIN
               dino_filter_lines, sState, /REJECT
            END 

            'Lines.Show profile': BEGIN
               dino_show_profile, sState
            END 

            'Help.About': dino_show_about, sState

            'Help.Help': dino_show_help, sState
            
            ELSE:

         ENDCASE 

      END

      'PLOT_TYPE_BUTTON': BEGIN
         dino_set_threshold_display, sState, FROM=sState.plot_type, $
          TO=BYTE( sEvent.value )
         sState.plot_type = BYTE( sEvent.value )
      END 

      'TIMER_EVENT': BEGIN
      END

      'LINE_LIST':

      ELSE: HELP, /STR, sEvent
   ENDCASE

   IF WIDGET_INFO( wStateHandler, /VALID_ID ) EQ 1 THEN BEGIN
                    ; restore state information
      ;;WIDGET_CONTROL, sState.wRoot, /CLEAR_EVENTS
      WIDGET_CONTROL, wStateHandler, SET_UVALUE=sState, /NO_COPY
   ENDIF 

   return
END

; _____________________________________________________________________________

PRO dino, data, PST=pst, SST=sst, MEDIAN_WIDTH=median_width, $
          PLOT_TITLE=plot_title, PLOT_SUBTITLE=plot_subtitle, $
          CR_SIGMA=cr_sigma, BAD_COLS=bad_cols, $
          THRESHOLD_VALUE=threshold_value, THRESHOLD_LOCK=threshold_lock, $
          CALCULATE=calculate_event, FIND_LINES=find_lines_event, $
          GROUP_LEADER=group_leader

   COMMON DINO, handler

; ______________________________________
;
; Check input
; ______________________________________

   instance_number = XREGISTERED('dino')
   IF instance_number GT 0 THEN BEGIN
      return
   ENDIF

   LOADCT, 39       ; Rainbow + white color table
   WINDOW, /FREE, XSIZE=2, YSIZE=2
   temp_window = !D.WINDOW

   IF N_ELEMENTS( data ) GT 2 THEN ptrData=PTR_NEW(data) ELSE ptrData=PTR_NEW()
   IF N_ELEMENTS( pst ) GT 0 THEN pst=FLOAT(pst) ELSE pst=1892.0 ;pst=1408.0
   IF N_ELEMENTS( sst ) GT 0 THEN sst=FLOAT(sst) ELSE sst=22.0
   IF N_ELEMENTS(cr_sigma) GT 0 THEN cr_sigma=FLOAT(cr_sigma) ELSE cr_sigma=20.0
   IF N_ELEMENTS(threshold_value) GT 0 THEN threshold_value=FLOAT(threshold_value) $
   ELSE threshold_value=0.002
   IF KEYWORD_SET(threshold_lock) THEN threshold_lock=1 ELSE threshold_lock=0
   IF N_ELEMENTS(bad_cols) GT 0 THEN $
    bad_cols=STRTRIM(bad_cols,2) ELSE bad_cols=''
   IF N_ELEMENTS( median_width ) GT 0 THEN median_width=FIX(median_width>1) $
   ELSE median_width=50
   IF N_ELEMENTS( plot_title ) GT 0 THEN plot_title=STRTRIM(plot_title,2) $
   ELSE plot_title=''
   IF N_ELEMENTS( plot_subtitle ) GT 0 THEN plot_subtitle=STRTRIM(plot_subtitle,2) $
   ELSE plot_subtitle=''

; ______________________________________

; Define some stuff
; ______________________________________

   strVersion = rcs_revision( ' $Revision: 1.23 $ ' )
   strVersion_date = rcs_date( ' $Date: 2002/03/15 02:00:59 $ ' )

   strTLBTitle = STRING( FORMAT='("Dino (v",A,")")', strVersion )

   aMenuList = [ '1\File', '1\Open', $
                 '0\ACS_LOG', '0\ACS SDI', '0\ACS FITS', '2\FITS', $ ; ADD YOUR TYPE HERE
                 '1\Save', '2\Peaks', $
                 '2\Exit', $
                 '1\Lines', '1\Sort', '0\Frequency', '2\Power', $
                 '0\Pass filter', '0\Reject filter', '2\Show profile', $
                 '1\Help', '0\Help', '2\About' ]

   default_parallel_shift = pst
   default_serial_shift = sst
   default_bad_columns = bad_cols
   default_median_width = median_width
   default_cr_sigma = cr_sigma
   default_view_image = 0
   default_plot_xmin = 0
   default_plot_xmax = 1000
   default_threshold = threshold_value
   default_plot_ymin = 0
   default_plot_ymax = 2.5 * threshold_value
   default_threshold_lock = threshold_lock
   default_threshold_sigma = 5.0
   strListLabel = STRING( FORMAT='(A20,2X,A20,2X,A20)', $
                          "Frequency", "Power", "Total Power" )
; ______________________________________

; Build Widget
; ______________________________________


   wRoot = WIDGET_BASE( GROUP_LEADER=group_leader, UVALUE='ROOT', $
                        TITLE=strTLBTitle, $
                        /COLUMN, /MAP, MBAR=wMbar, /TLB_KILL_REQUEST_EVENTS, $
                        RESOURCE_NAME='dino', RNAME_MBAR='menubar' )

   wBase = WIDGET_BASE( wRoot, /COLUMN )

   wMenuBar = CW_PDMENU( wMbar, /RETURN_FULL_NAME, /MBAR, /HELP, $
                         aMenuList, UVALUE='MENU' )

   wLineListLabel = WIDGET_LABEL( wBase, VALUE=strListLabel, FONT='fixed', $
                                  /ALIGN_LEFT )
   wLineList = WIDGET_LIST( wBase, UVALUE='LINE_LIST', XSIZE=30, YSIZE=10, $
                            /MULTIPLE, FONT='fixed' )

   wButtonBase = WIDGET_BASE( wBase, /ROW, UVALUE='BUTTON_BASE' )

   wCalculateButton = WIDGET_BUTTON( wButtonBase, VALUE='Calculate', $
                                     UVALUE='CALCULATE_BUTTON' )
   wFindLinesButton = WIDGET_BUTTON( wButtonBase, VALUE='Peaks', $
                                     UVALUE='FIND_LINES_BUTTON' )
   wPlotButton = WIDGET_BUTTON( wButtonBase, VALUE='Plot transform', $
                                UVALUE='PLOT_BUTTON' )
   wHardcopyButton = WIDGET_BUTTON( wButtonBase, VALUE='Hardcopy', $
                                    UVALUE='HARDCOPY_BUTTON' )
   wTimePlotButton = WIDGET_BUTTON( wButtonBase, VALUE='Plot time', $
                                UVALUE='TIME_PLOT_BUTTON' )

   wDummyBase = WIDGET_BASE( wBase, UVALUE='TIMER_EVENT' )

                     ; CALCULATE PARAMETERS
   wCalcLabel = WIDGET_LABEL( wBase, FONT='fixed', /ALIGN_LEFT, VALUE='Calculate parameters' )
   wCalcParamBase = WIDGET_BASE( wBase, /COLUMN, /FRAME, UVALUE='CALC_PARAM_BASE' )

   wCalcParamGridBase = WIDGET_BASE( wCalcParamBase, /ROW )
   wCalcParamCol1Base = WIDGET_BASE( wCalcParamGridBase, /COLUMN, $
                                     /BASE_ALIGN_RIGHT, UVALUE='CALC_PARAMC1_BASE' )
   wCalcParamCol2Base = WIDGET_BASE( wCalcParamGridBase, /COLUMN, $
                                     /BASE_ALIGN_RIGHT, UVALUE='CALC_PARAMC2_BASE' )

   wParallelShiftField = CW_FIELD( wCalcParamCol1Base, /FLOAT, FONT='fixed',  $
                                   VALUE=default_parallel_shift, $
                                   XSIZE=6, UVALUE='PARALLELSHIFT_FIELD', $
                                   TITLE='Parallel shift time (µs)' )

   wSerialShiftField = CW_FIELD( wCalcParamCol2Base, /FLOAT, FONT='fixed', $
                                 VALUE=default_serial_shift, $
                                 XSIZE=6, UVALUE='SERIALSHIFT_FIELD', $
                                 TITLE='Serial shift time (µs)' )

   wBadColumnsField = CW_FIELD( wCalcParamCol1Base, /STRING, FONT='fixed',  $
                                VALUE=default_bad_columns, $
                                XSIZE=10, UVALUE='BADCOLUMNS_FIELD', $
                                TITLE='Bad column list (comma sep)' )

   wMedianFilterField = CW_FIELD( wCalcParamCol2Base, /INT, FONT='fixed',  $
                                   VALUE=default_median_width, $
                                   XSIZE=6, UVALUE='MEDIAN_FILTER_FIELD', $
                                   TITLE='Column median filter width' )

   wCRSigmaField = CW_FIELD( wCalcParamCol1Base, /FLOAT, FONT='fixed',  $
                             VALUE=default_cr_sigma, $
                             XSIZE=6, UVALUE='CR_SIGMA_FIELD', $
                             TITLE='cosmic ray rejection sigma' )

   wViewImageButton=CW_BGROUP(wCalcParamCol2Base, 'View median filtered image',$
                              /NONEXCLUSIVE, /NO_RELEASE, FONT='fixed', $
                              UVALUE='VIEW_IMAGE_BUTTON', $
                              SET_VALUE=[default_view_image EQ 1] )


                    ; PEAKS PARAMETERS
   wPeakLabel = WIDGET_LABEL( wBase, FONT='fixed', /ALIGN_LEFT, VALUE='Peaks parameters' )
   wPeakParamBase = WIDGET_BASE( wBase, /COLUMN, /FRAME, UVALUE='PEAK_PARAM_BASE' )

   wThresholdBase = WIDGET_BASE( wPeakParamBase, /ROW )
   wThresholdField = CW_FIELD( wThresholdBase, /FLOAT, FONT='fixed', $
                               VALUE=default_threshold, $
                               XSIZE=12, UVALUE='THRESHOLD_FIELD', $
                               TITLE='Threshold value     ' )
   wThresholdLockButton=CW_BGROUP(wThresholdBase, 'Threshold lock',$
                                  /NONEXCLUSIVE, FONT='fixed', $
                                  UVALUE='THRESHOLD_LOCK_BUTTON', $
                                  SET_VALUE=[default_threshold_lock EQ 1] )

   wThresholdSigmaBase = WIDGET_BASE( wPeakParamBase, /ROW )
   wThresholdSigmaField = CW_FIELD( wThresholdSigmaBase, /FLOAT, FONT='fixed', $
                                    VALUE=default_threshold_sigma, $
                                    XSIZE=4, UVALUE='THRESHOLD_SIGMA_FIELD', $
                                    TITLE='Threshold sigma              ' )
   wRecomputeThresholdButton=WIDGET_BUTTON(wThresholdSigmaBase, FONT='fixed',$
                                           VALUE='Recompute threshold', $
                                           UVALUE='RECOMPUTE_THRESHOLD_BUTTON')

   wPlotBase = WIDGET_BASE( wBase, /COLUMN, UVALUE='PLOT_BASE' )
   wPlotGridBase = WIDGET_BASE( wPlotBase, /ROW )
   wPlotCol1Base = WIDGET_BASE(wPlotGridBase,/COLUMN, UVALUE='PLOTC1_BASE' )
   wPlotCol2Base = WIDGET_BASE(wPlotGridBase,/COLUMN, UVALUE='PLOTC2_BASE' )

   wPlotXminField = CW_FIELD( wPlotCol1Base, /FLOAT, FONT='fixed', $
                              VALUE=default_plot_xmin, $
                              XSIZE=8, UVALUE='PLOT_XMIN_FIELD', $
                              TITLE='Plot X min     ' )

   wPlotXmaxField = CW_FIELD( wPlotCol2Base, /FLOAT, FONT='fixed', $
                              VALUE=default_plot_xmax, $
                              XSIZE=8, UVALUE='PLOT_XMAX_FIELD', $
                              TITLE='Plot X max     ' )

   wPlotYminField = CW_FIELD( wPlotCol1Base, /FLOAT, FONT='fixed', $
                              VALUE=default_plot_ymin, $
                              XSIZE=8, UVALUE='PLOT_YMIN_FIELD', $
                              TITLE='Plot Y min     ' )

   wPlotYmaxField = CW_FIELD( wPlotCol2Base, /FLOAT, FONT='fixed', $
                              VALUE=default_plot_ymax, $
                              XSIZE=8, UVALUE='PLOT_YMAX_FIELD', $
                              TITLE='Plot Y max     ' )

   aPlotTypes = [ 'Linear', 'Magnitude', 'Power' ]
   strLabel = 'Spectral plot type:'
   default_plot_type = 2b
   wPlotTypeButtons = CW_BGROUP( wBase, aPlotTypes, FONT='fixed', $
                                 /EXCLUSIVE, /NO_RELEASE, $
                                 UVALUE='PLOT_TYPE_BUTTON', $
                                 SET_VALUE=default_plot_type, $
                                 /ROW, LABEL_LEFT=strLabel )

   IF NOT PTR_VALID( ptrData ) THEN $
    strMessage = 'Use File->Open to load a data set.' $
   ELSE strMessage = 'Data set loaded.'
   wMessageText = WIDGET_TEXT( wBase, YSIZE=1, UVALUE='MESSAGE_TEXT', $
                               VALUE=strMessage )

   plot_widget, wRoot, wPlotDraw, STATE_HANDLER=wBase
   WIDGET_CONTROL, wPlotDraw, GET_VALUE=draw_index

   WIDGET_CONTROL, /REALIZE, wBase

   IF NOT PTR_VALID( ptrData ) THEN WIDGET_CONTROL, wButtonBase, SENSITIVE=0

; ______________________________________

; Setup Widget State
; ______________________________________

   CD, CURRENT=current_working_directory

; ______________________________________

; Define Widget State Structure
; ______________________________________

   sState = { $
             wRoot: wRoot, $ ;  ______________________ Widgets
             wBase: wBase, $
             wLineList: wLineList, $
             wCalcParamBase: wCalcParamBase, $
             wBadColumnsField: wBadColumnsField, $
             wPeakParamBase: wPeakParamBase, $
             wButtonBase: wButtonBase, $
             wNewDataTimer: wDummyBase, $
             wThresholdField: wThresholdField, $
             wThresholdLockButton: wThresholdLockButton, $
             wThresholdSigmaField: wThresholdSigmaField, $
             wRecomputeThresholdButton: wRecomputeThresholdButton, $
             wPlotButton: wPlotButton, $
             wHardcopyButton: wHardcopyButton, $
             wTimePlotButton: wTimePlotButton, $
             wFindLinesButton: wFindLinesButton, $
             wMedianFilterField: wMedianFilterField, $
             wParallelShiftField: wParallelShiftField, $
             wSerialShiftField: wSerialShiftField, $
             wCRSigmaField: wCRSigmaField, $
             wViewImageButton: wViewImageButton, $
             wPlotXminField: wPlotXminField, $
             wPlotXmaxField: wPlotXmaxField, $
             wPlotYminField: wPlotYminField, $
             wPlotYmaxField: wPlotYmaxField, $
             wPlotTypeButtons: wPlotTypeButtons, $
             wMessageText: wMessageText, $
             wPlotDraw: wPlotDraw, $
             ptrTransform: PTR_NEW(), $ ;  _______________ Pointers
             ptrFrequency: PTR_NEW(), $
             ptrLineIndex: PTR_NEW(), $
             ptrTimeSeries: PTR_NEW(), $
             ptrBadColumns: PTR_NEW(), $
             ptrData: ptrData, $
             plot_type: BYTE(default_plot_type), $
             sort_flag: 0b, $
             plot_title: plot_title, $
             plot_subtitle: plot_subtitle, $
             parallel_shift_time: pst, $
             serial_shift_time: sst, $
             median_width: median_width, $
             last_plot: 0, $
             last_file_path: current_working_directory, $
             version: strVersion, $
             version_date: strVersion_date, $
             draw_index: draw_index $
            }

; ______________________________________

; Update Widget and hand off
; ______________________________________
                    ; If not defined or valid
                    ; set the common block variable
   IF N_ELEMENTS( handler ) LE 0 THEN handler = sState.wRoot $
   ELSE BEGIN      
      IF NOT WIDGET_INFO( handler, /VALID ) THEN handler = sState.wRoot
   ENDELSE

                    ; restore state information
   WIDGET_CONTROL, wBase, SET_UVALUE=sState, /NO_COPY

   WDELETE, temp_window

   IF threshold_lock EQ 1 THEN BEGIN
      WIDGET_CONTROL, wThresholdSigmaField, SENSITIVE=0
      WIDGET_CONTROL, wRecomputeThresholdButton, SENSITIVE=0
   ENDIF

   IF KEYWORD_SET(calculate_event) THEN BEGIN
      sSendEvent = { ID: wRoot, $
                     TOP: wRoot, $
                     HANDLER: wRoot, $
                     UVALUE: 'CALCULATE_BUTTON', $
                     VALUE: 1 }
   
      WIDGET_CONTROL, wRoot, SEND_EVENT=sSendEvent
   ENDIF 
   IF KEYWORD_SET(find_lines_event) THEN BEGIN
      sSendEvent = { ID: wRoot, $
                     TOP: wRoot, $
                     HANDLER: wRoot, $
                     UVALUE: 'FIND_LINES_BUTTON', $
                     VALUE: 1 }
   
      WIDGET_CONTROL, wRoot, SEND_EVENT=sSendEvent
   ENDIF 
   ;;WIDGET_CONTROL, wRoot, /CLEAR_EVENTS
   XMANAGER, 'dino', wRoot, /NO_BLOCK

END

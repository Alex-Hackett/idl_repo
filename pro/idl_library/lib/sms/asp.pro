;+
; $Id: asp.pro,v 1.21 2001/02/19 23:28:58 mccannwj Exp $
;
; NAME:
;     ASP - ACS SMS Parser
;
; PURPOSE:
;     Interpret and present the activities in an Advanced Camera for
;     Surveys stored command file.
;
; CATEGORY:
;     ACS/HST
;
; CALLING SEQUENCE:
;     asp, filename [, OBSREV=revfile, ACTLOG=actfile, $
;                      /FILES, /OVER, /NON_STD, VERBOSE=verb, /WIDE]
;
; INPUTS:
;     filename - SMS file name
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     WIDE      - (BOOLEAN) set to produce a observation review file
;                       in a table format.
;     FILES     - (BOOLEAN) set to output both files to their default
;                       file names, unless overridden by OBSREV and
;                       ACTLOG keywords.
;     OVER      - (BOOLEAN) overwrite output files if they already exist
;     NON_STD   - (BOOLEAN) set to allow non-standard SMS files (those
;                       not in the 72 character per line format).
;     OBSREV    - (BOOLEAN/STRING) output the observation review file.
;                       Set to output to default location, or specify
;                       a string filename.
;                       The default location when the FILES keyword is
;                       set is to the sms filename with a '.rev' extension.
;                       Otherwise output will be directed to the screen.
;     ACTLOG    - (BOOLEAN/STRING) ouput the activities log.  The
;                       behavior mirrors that of the OBSREV keyword.  The
;                       default location when the FILES keyword is set
;                       is to the sms filename with a '.act' extension.
;
; OUTPUTS:
;     Print to screen.
;
; OPTIONAL OUTPUTS:
;     Observation review file.
;     Activities log file.
;
; COMMON BLOCKS:
;     none.
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;     SMS file must be a fixed format ASCII file of 71 character lines unless
;     the /NON_STD keyword is set.
;
; PROCEDURES:
;     Various GSFC ASTROlib routines.
;
; EXAMPLE:
;     To spit both the activities log and the observation review to
;     the screen (for sms file './jhrc.sms'):
;          asp, 'jhrc.sms'
;
;     To spit the observation review to a file named acstest.rev:
;          asp, 'jhrc.sms', OBSREV='acstest.rev'
;
;     To spit both files to their default file names:
;          asp, 'jhrc.sms', /FILES
;
; MODIFICATION HISTORY:
;
;    Fri Sep 11 10:29:03 1998, William Jon McCann <mccannwj@acs14>
;		Written.
;-

; _____________________________________________________________________________

FUNCTION asp_print_duration, diff, DEBUG=debug

   IF KEYWORD_SET(debug) THEN HELP, diff
   days = diff
   hours = (days MOD 1) * 24.0
   minutes = (hours MOD 1) * 60.0
   seconds = (minutes MOD 1) * 60.0
   IF KEYWORD_SET(debug) THEN HELP, days, hours, minutes, seconds

   strFormat = '(I2.2,"d ",I2.2,"h ",I2.2,"m ",I2.2,"s")'
   strTime = STRING(FORMAT=strFormat,days,hours,minutes,seconds)

   return, strTime
END 

; _____________________________________________________________________________

FUNCTION asp_parse_time, time_stamp, UTC=utc, MJD=mjd, DEBUG=debug

   IF N_ELEMENTS( time_stamp ) LE 0 THEN BEGIN
      MESSAGE, 'time stamp not specified', /CONTINUE
      return, -1
   ENDIF 

   n_times = N_ELEMENTS(time_stamp)
   IF n_times GT 1 THEN julian_date = MAKE_ARRAY(n_times,/DOUBLE) $
   ELSE julian_date = 0.0

   FOR i=0,n_times-1 DO BEGIN
      time_string = time_stamp[i]
      tokens = STRSPLIT(time_string, ':', /EXTRACT)
   
      yr = STRSPLIT(tokens[0], '.', /EXTRACT)
      year = DOUBLE(yr[0])
      day_of_year = DOUBLE(yr[1])
      hour = DOUBLE( STRMID( tokens[1], 0, 2 ) )
      minute = DOUBLE( STRMID( tokens[2], 0, 2 ) )
      second = DOUBLE( STRMID( tokens[3], 0, 2 ) )
      
      monthdays = [0,31,59,90,120,151,181,212,243,273,304,334,366]
      
      leap_year = DOUBLE( (((year MOD 4) EQ 0) AND ((year MOD 100) NE 0)) $
                          OR ((year MOD 400) EQ 0) AND (day_of_year GE 90) )
      
      month = DOUBLE( MIN( WHERE( monthdays GE (day_of_year - leap_year))))
      
      day = DOUBLE( day_of_year - monthdays[month-1] - leap_year )
      
      IF KEYWORD_SET(debug) THEN HELP, month, day, year, hour, minute, second
      julian_date[i] = JULDAY( month, day, year, hour, minute, second )
      
   ENDFOR
   IF KEYWORD_SET( mjd ) THEN BEGIN
      mjd = DOUBLE(julian_date) - DOUBLE(2.4e6) - 0.5d
      return, mjd
   ENDIF

   return, julian_date
END 

; _____________________________________________________________________________

FUNCTION strpad, number

   IF n_elements( number ) LE 0 THEN BEGIN
      MESSAGE, 'number not specified', /CONT
      return, ''
   ENDIF
   
   IF number LE 0 THEN return, ''
   IF number GT 256 THEN number = 256

   return, STRING( ' ', FORMAT='(A'+strtrim(number,2)+')' )

END 
; _____________________________________________________________________________

FUNCTION asp_parse_calendar, calendar, DEBUG=debug

   IF KEYWORD_SET(debug) THEN HELP, calendar
   IF N_ELEMENTS(calendar) LE 0 THEN return, ''

   cal_regex = '([0-9]+)Y([0-9]+)D([0-9]+)H([0-9]+)M([.0-9]+)S'
   subs = STREGEX(STRTRIM(calendar,2),cal_regex,/FOLD_CASE,/EXTRACT,/SUBEXPR)
   IF N_ELEMENTS(subs) GT 1 THEN BEGIN
      year = subs[1]
      iyear = FIX(year)
      IF iyear GT 50 AND iyear LT 100 THEN year = STRTRIM(1900 + iyear,2)
      doy = subs[2]
      hour = subs[3]
      minute = subs[4]
      second = subs[5]
   ENDIF ELSE BEGIN
      year = '0000'
      doy = '000'
      hour = '00'
      minute = '00'
      second = '00.000'
   ENDELSE

   strFormat = '(A,".",A,":",A,":",A,":",A)'
   strDate = STRING( FORMAT=strFormat, year, doy, hour, minute, second )
   IF KEYWORD_SET(debug) THEN HELP, strDate

   return, strDate
END 

; _____________________________________________________________________________

FUNCTION asp_parse_inparen, line, key

                    ; Look for key
   pos = -1
   pos = STRPOS( line, key )
   IF (pos EQ -1) THEN return, ''
   
                    ; get string from key to end of line
   line2 = STRMID( line, pos, STRLEN(line)-pos )

   pos = STRPOS( line2, '(' )
   IF (pos NE -1) THEN BEGIN 
                    ; If the key and paren is found
                    ; get string from open paren to end of line
      strval = STRMID( line2, pos + 1, $
                       strlen(line2)-pos )

      pos = STRPOS( strval, ')' )
                    ; set value to all text between the parens
      value = STRMID( strval, 0, pos )

      pos = STRPOS( value, "'" )+1
      rpos = STRPOS( value, "'", /REVERSE_SEARCH )
                    ; if the value has single quotes at the first and last
                    ; position then remove them
      IF ((pos NE -1) AND (rpos NE -1) AND (pos EQ (STRLEN(value)-rpos))) $
                                           THEN $
         value = STRMID( value, pos, rpos-pos )

      pos = STRPOS( value, '"' )+1
      rpos = STRPOS( value, '"', /REVERSE_SEARCH )
                    ; if the value has double quotes at the first and last
                    ; position then remove them
      IF ((pos NE -1) AND (rpos NE -1) AND (pos EQ (STRLEN(value)-rpos))) $
                                           THEN $
         value = STRMID( value, pos, rpos-pos )

   ENDIF ELSE value = '' ; if the key is not found

   return, value
END

; _____________________________________________________________________________


FUNCTION asp_parse_smstime, line

   pos = -1
   key = 'SMSTIME'
   pos = STRPOS( line, key )
   IF (pos EQ -1) THEN return, ''

                    ; get string from key to end of line
   line2 = STRMID( line, pos, STRLEN(line)-pos )

   pos = STRPOS( line2, '=' )
   IF ( pos NE -1 ) THEN BEGIN
                    ; time SHOULD always be 21 char
                    ; YYYY.DOY:HH:MM:SS.mmm
                    ; YYYY - year; DOY - day of year
                    ; HH - hour; MM - minute; SS - second; mmm - fractional sec
      smstime = STRMID( line2, pos + 1, 21 )
   ENDIF ELSE smstime = ''

   return, smstime

END 

; _____________________________________________________________________________

FUNCTION asp_pix2bytes, n_pixels, DATA=data
   n_pixels = LONG( n_pixels )

   bits_per_pixel = 16
   bytes_per_bit = 1 / 8e
   bytes_per_pixel = bytes_per_bit * bits_per_pixel
   n_image_bytes = LONG( n_pixels * bytes_per_pixel )
   words_per_byte = 1 / 2e
   
   n_image_words = n_image_bytes * words_per_byte
   n_data_lines = 1 + ( ( LONG( n_image_words + 964 ) ) / 965 )
   n_data_bytes = LONG( n_data_lines * 1024 / words_per_byte )

   IF KEYWORD_SET(data) THEN return, n_data_bytes
   return, n_image_bytes
END

; _____________________________________________________________________________

FUNCTION asp_words2bytes, n_words
   n_words = LONG( n_words )
   bytes_per_word = 4e
   n_bytes = LONG( n_words * bytes_per_word )
   return, n_bytes
END 

; _____________________________________________________________________________

FUNCTION asp_what_fwheel, filter_name
  
   filter_sz = SIZE( filter_name )
   var_type = filter_sz[ filter_sz[0] + 1 ]

   IF var_type EQ 7 THEN BEGIN
                    ; We have a STRING

      wheel1 = ['CLEAR1L','F555W','F775W','F625W','F658N','F850LP', $
                'CLEAR1S','POL0UV','POL60UV','POL120UV','F892N','F606W', $
                'F502N','G800L','F550M','F475W']
      wheel2 = ['CLEAR2L','F660N','F814W','FR388N','FR423N','FR462N', $
                'F435W','FR656N','FR716N','FR782N','CLEAR2S', $
                'POL0V','F330W','POL60V','F250W','POL120V','PR200L', $
                'F344N','F220W','FR853N','FR914M','FR931N', $
                'FR647M','FR459M','FR1016N','FR505N','FR551N','FR601N']
      wheel3 = ['BLOCK1','F165LP','F150LP','BLOCK2','F140LP','F125LP', $
                'BLOCK3','F122M','F115LP','BLOCK4','PR130L','PR110L']

      wheels = ['',wheel1,wheel2,wheel3]

      filter_number = (WHERE( filter_name EQ wheels, count ))[0]

      IF count LE 0 THEN BEGIN
         byte_array = BYTE( STRTRIM( filter_name, 2 ) )

         IF (byte_array[0] GE 48b) AND (byte_array[0] LE 57b) THEN BEGIN
                    ; this is a number
            filter_number = LONG( STRTRIM( filter_name, 2 ) )
         ENDIF ELSE BEGIN
            filter_number = -1
         ENDELSE
      ENDIF
   ENDIF ELSE BEGIN
                    ; We have a number
      filter_number = filter_name
   ENDELSE

   IF filter_number LE 0 THEN return, -1
   IF filter_number LE 16 THEN return, 1
   IF filter_number LE 44 THEN return, 2
   IF filter_number LE 56 THEN return, 3

   return, -1

END

; _____________________________________________________________________________

FUNCTION asp_skel_act

   sAct = { ASP_SMS_ACTIVITY, $
            smstime: '', $
            type: '', $
            activity: STRARR(5) }

   return, sAct
END

; _____________________________________________________________________________

FUNCTION asp_make_acts, CCD=aCCDExp, MAMA=aMamaExp, $
                        LAMP=aLamps, DUMP=aDumps, RECON=aRecons, $
                        SLEW=aSlews, CORRECTOR=aCorrs, $
                        DOOR=aDoors, FOLD=aFolds, MIE=aMIEs

                    ; ------------------------------------------
                    ; Extract activities from each type of oper.
                    ; ------------------------------------------

   sAct = asp_skel_act()

   IF N_ELEMENTS( aCCDExp ) GT 0 THEN BEGIN
      FOR i=0, N_ELEMENTS( aCCDExp )-1 DO BEGIN 

         IF (aCCDExp[i].full_array EQ 1) THEN array="FULL" ELSE array="SUB"

         sAct.activity[0] = $
          STRING( $
                 FORMAT='(A3,1X,F6.1,1X,"s",1X,A8,1X,A8,1X,A4,1X,A10)', $
                 aCCDExp[i].detector, $
                 aCCDExp[i].exp_time, $
                 aCCDExp[i].opmode, $
                 aCCDExp[i].target_type, $
                 array, $
                 'J'+aCCDExp[i].progid+aCCDExp[i].obset+aCCDExp[i].obsid )

         IF (aCCDExp[i].target_type EQ 'EXTERNAL') AND $
          (aCCDExp[i].ext_target NE '') THEN BEGIN
            sAct.activity(1) = STRING( FORMAT='(25X,"TARGET:",1X,A30)', $
                                       aCCDExp[i].ext_target )
         ENDIF

         sAct.smstime = aCCDExp[i].smstime
         sAct.type = 'JCCDEXP'

         IF N_ELEMENTS( aActs ) LE 0 THEN aActs = [sAct] $
         ELSE aActs = [aActs,sAct]
         sAct.activity(1) = ''

      ENDFOR 
   ENDIF 

   sAct = asp_skel_act()

   IF N_ELEMENTS( aMamaExp ) GT 0 THEN BEGIN
      FOR i=0, N_ELEMENTS( aMamaExp )-1 DO BEGIN 

         sAct.activity(0) = $
          STRING( $
                 FORMAT='("SBC",1X,F6.1,1X,"s",8X,A10,6X,A10)',$
                 aMamaExp[i].exp_time, $
                 aMamaExp[i].target_type, $
                 'J'+aMamaExp[i].progid+aMamaExp[i].obset+aMamaExp[i].obsid )
         
         IF (aMamaExp[i].target_type EQ 'EXTERNAL') AND $
          (aMamaExp[i].ext_target NE '') THEN BEGIN
            sAct.activity(1) = $
             STRING( FORMAT='(25X,"TARGET:",1X,A30)', aMamaExp[i].ext_target )
         ENDIF 
         
         sAct.smstime = aMamaExp[i].smstime
         sAct.type = 'JMAEXP'
         
         IF N_ELEMENTS( aActs ) LE 0 THEN aActs = [sAct] $
         ELSE aActs = [aActs,sAct]
         
         sAct.activity(1) = ''
      ENDFOR 
   ENDIF 

   sAct = asp_skel_act()

   IF N_ELEMENTS( aMIEs ) GT 0 THEN BEGIN
      FOR i=0, N_ELEMENTS( aMIEs )-1 DO BEGIN

         sAct.activity(0) = $
          STRING( FORMAT='(A25,11X,A10)', $
                  'Memory dump or rate check', $
                  'J'+aMIEs[i].progid+aMIEs[i].obset+aMIEs[i].obsid )

         sAct.smstime = aMIEs[i].smstime
         sAct.type = 'JMIE2RAM'

         IF N_ELEMENTS( aActs ) LE 0 THEN aActs = [sAct] $
         ELSE aActs = [aActs,sAct]
      ENDFOR

   ENDIF 

   sAct = asp_skel_act()

   IF N_ELEMENTS( aLamps ) GT 0 THEN BEGIN 
      FOR i=0, N_ELEMENTS( aLamps )-1 DO BEGIN

         sAct.activity(0) = $
          STRING( $
                 FORMAT='(A10,1X,I1,1X,A5)', $
                 aLamps[i].lamp, strtrim(aLamps[i].bulb,2), $
                 aLamps[i].power )
         
         sAct.smstime = aLamps[i].smstime
         sAct.type = 'LAMP'

         IF N_ELEMENTS( aActs ) LE 0 THEN aActs = [sAct] $
         ELSE aActs = [aActs,sAct]

      ENDFOR
   ENDIF 

   sAct = asp_skel_act()

   IF N_ELEMENTS( aDumps ) GT 0 THEN BEGIN 
      FOR i=0, N_ELEMENTS( aDumps )-1 DO BEGIN
         
         id_code = aDumps[i].progid+aDumps[i].obset+aDumps[i].obsid
         IF STRCOMPRESS( id_code, /REM ) NE '' THEN id_code = 'J'+id_code

         sAct.activity(0) = $
          STRING( $
                 FORMAT='(I2,1X,"images",5X,A4,18X,A10)', $
                 aDumps[i].number, $                         
                 aDumps[i].availability, $
                 id_code )
         
         sAct.smstime = aDumps[i].smstime
         sAct.type = 'JDUMPSD'

         IF N_ELEMENTS( aActs ) LE 0 THEN aActs = [sAct] $
         ELSE aActs = [aActs,sAct]

      ENDFOR
   ENDIF 

   sAct = asp_skel_act()

   IF N_ELEMENTS( aRecons ) GT 0 THEN BEGIN
      
      FOR i=0, N_ELEMENTS( aRecons )-1 DO BEGIN
         
         sAct.activity(0) = aRecons[i].mode
         sAct.smstime = aRecons[i].smstime
         sAct.type = "RECON"
         
         IF N_ELEMENTS( aActs ) LE 0 THEN aActs = [sAct] $
         ELSE aActs = [aActs,sAct]
         
      ENDFOR
   ENDIF 

   sAct = asp_skel_act()

   IF N_ELEMENTS( aDoors ) GT 0 THEN BEGIN

      FOR i=0, N_ELEMENTS( aDoors )-1 DO BEGIN

         sAct.activity(0) = STRING( FORMAT='(A,2X,A)', aDoors[i].motor, $
                                    aDoors[i].position )
         sAct.smstime = aDoors[i].smstime
         sAct.type = 'JDOOR'

         IF N_ELEMENTS( aActs ) LE 0 THEN aActs = [sAct] $
         ELSE aActs = [aActs,sAct]

      ENDFOR

   ENDIF 

   sAct = asp_skel_act()

   IF N_ELEMENTS( aFolds ) GT 0 THEN BEGIN

      FOR i=0, N_ELEMENTS( aFolds )-1 DO BEGIN

         sAct.activity(0) = STRING( FORMAT='(A)', aFolds[i].position )
         sAct.smstime = aFolds[i].smstime
         sAct.type = 'JFOLD'

         IF N_ELEMENTS( aActs ) LE 0 THEN aActs = [sAct] $
         ELSE aActs = [aActs,sAct]

      ENDFOR

   ENDIF 
   
   sAct = asp_skel_act()
   
   IF N_ELEMENTS( aSlews ) GT 0 THEN BEGIN
      
      FOR i=0, N_ELEMENTS( aSlews )-1 DO BEGIN

         CASE aSlews[i].type OF 
            1: BEGIN 
               sAct.activity(0) = ''
               sAct.activity(1) = ''
               sAct.activity(2) = ''
               sAct.activity(3) = ''
               sAct.activity(4) = ''
            END

            2: BEGIN
               sAct.activity(0) = $
                STRING( $
                       FORMAT='("APEREID:",1X,A8)', $
                       aSlews[i].aper_eid )
               sAct.activity(1) = $
                STRING( $
                       FORMAT='(37X,"END - DEC:",1X,D20)', $
                       aSlews[i].end_dec )
               sAct.activity(2) = $
                STRING( $
                       FORMAT='(43X," RA:",1X,D20)', $
                       aSlews[i].end_ra )
               sAct.activity(3) = ''
               sAct.activity(4) = ''
            END
            
            3: BEGIN 
               sAct.activity(0) = ''
               sAct.activity(1) = ''
               sAct.activity(2) = ''
               sAct.activity(3) = ''
               sAct.activity(4) = ''
            END

            4: BEGIN 
               sAct.activity(0) = $
                STRING( $
                       FORMAT='(2X,"APERSID:",1X,A12,2X,"APEREID:",1X,A12)', $
                       aSlews[i].aper_sid, aSlews[i].aper_eid )
               sAct.activity(1) = $
                STRING( $
                       FORMAT='(35X,"START - DEC:",1X,D20)', $
                       aSlews[i].strt_dec )
               sAct.activity(2) = $
                STRING( $
                       FORMAT='(43X," RA:",1X,D20)', $
                       aSlews[i].strt_ra )
               sAct.activity(3) = $
                STRING( $
                       FORMAT='(37X,"END - DEC:",1X,D20)', $
                       aSlews[i].end_dec )
               sAct.activity(4) = $
                STRING( $
                       FORMAT='(43X," RA:",1X,D20)', $
                       aSlews[i].end_ra )

            END 
            ELSE:  
         ENDCASE 

         sAct.smstime = aSlews[i].smstime
         sAct.type = "SLEW"         

         IF N_ELEMENTS( aActs ) LE 0 THEN aActs = [sAct] $
         ELSE aActs = [aActs,sAct]
         
      ENDFOR
   ENDIF

   sAct = asp_skel_act()

   IF N_ELEMENTS( aCorrs ) GT 0 THEN BEGIN
      FOR i=0, N_ELEMENTS( aCorrs )-1 DO BEGIN

         CASE aCorrs[i].mode OF
            'RELATIVE': sAct.type = 'JCORREL'
            'ABSOLUTE': sAct.type = 'JCORABS'
            ELSE: sAct.type = 'UNKNOWN'
         ENDCASE 
         
         sAct.activity(0) = STRING( FORMAT='(A3,2X,A5,2X,F8.2," steps")', $
                                    aCorrs[i].channel, aCorrs[i].motor, $
                                    aCorrs[i].steps )

         sAct.smstime = aCorrs[i].smstime
 
        IF N_ELEMENTS( aActs ) LE 0 THEN aActs = [sAct] $
         ELSE aActs = [aActs,sAct]
 
      ENDFOR
   ENDIF 
   
   return, aActs
END 

; _____________________________________________________________________________

FUNCTION asp_make_page_header, smsfile, HEADER_STRUCT=sHeader,$
                               DURATION=duration,$
                               CCD_STRUCT=aCCDexp, MAMA_STRUCT=aMamaExp

   page_header = MAKE_ARRAY(3, /STRING)

   IF N_TAGS(sHeader) GT 1 THEN BEGIN
      strFormat = '(1X,"Created: ",A17,3X,"Name: ",A8,".SMS",3X,"Side: ",I1,3X,"Database: ",A)'
      page_header[0] = STRING( FORMAT=strFormat, sHeader.calendar, sHeader.sms_id, $
                               sHeader.mebid, sHeader.db_id )
   ENDIF ELSE BEGIN
      FDECOMP, smsfile, disk, dir, name, qual, vers
      file = name + '.' + qual + vers
      page_header[0] = STRING( FORMAT='(1X,"Date: ",A30,14X,"File: ",A20,/)', $
                               SYSTIME(), file )
   ENDELSE

   total_size = 0l
   IF N_TAGS(aCCDExp) GT 1 THEN total_size=total_size+TOTAL(aCCDExp.data_size)
   IF N_TAGS(aMamaExp) GT 1 THEN total_size=total_size+TOTAL(aMamaExp.data_size)

   IF N_ELEMENTS(duration) GT 0 THEN BEGIN
      IF duration[0] GT 0 THEN $
       total_duration = asp_print_duration(duration) $
      ELSE total_duration = 'unknown'
   ENDIF ELSE total_duration = 'unknown'
   strFormat = '(1X,"Duration: ",A16,24X,"Size: ",I," kb",/)'
   page_header[1] = STRING(FORMAT=strFormat, total_duration, total_size/1024)

   return, page_header
END 

; _____________________________________________________________________________

PRO asp_write_act, filename, smsfile, ACTS=aActs, VERBOSE=verbose, $
                   OVER=over, SCREEN=screen, HEADER=aHeader

   IF (N_ELEMENTS( aActs ) LE 0) THEN BEGIN
      PRINTF, -2, STRING( 7b )
      MESSAGE, 'warning: no activity log output.', /INFO, /NONAME
      return
   ENDIF

   IF KEYWORD_SET(screen) THEN BEGIN
      act_lun = -1
      stdout = FSTAT(-1)
      IF stdout.isatty THEN more=1 ELSE more=0
      OPENW, act_lun, FILEPATH(/TERMINAL), MORE=more, /GET_LUN
   ENDIF ELSE BEGIN
      IF N_ELEMENTS(filename) LE 0 THEN MESSAGE, 'filename not specified.'

      IF NOT KEYWORD_SET(over) THEN BEGIN
                    ; check for file existence
         file_list = FINDFILE( filename, COUNT=file_count )

         IF file_count GT 0 THEN BEGIN

            MESSAGE, 'warning: activity log file exists, skipping.', $
             /INFO, /NONAME
            return
         ENDIF
      ENDIF
                    ; OPEN Activity Summary file
      OPENW, act_lun, filename, /GET_LUN
   ENDELSE

   FDECOMP, smsfile, disk, dir, name, qual, vers
   file = name + '.' + qual + vers
   
   PRINTF, act_lun, FORMAT='(A,/)', strpad(25)+'ACS ACTIVITIES SUMMARY'
   IF N_ELEMENTS(aHeader) GT 0 THEN BEGIN
      FOR i=0,N_ELEMENTS(aHeader)-1 DO BEGIN
         PRINTF, act_lun, aHeader[i]
      ENDFOR 
   ENDIF 

   PRINTF, act_lun, FORMAT='(/,80A1,/)',REPLICATE('_',80)

                    ; ------------------------------------------
                    ; Print out all activities.
                    ; ------------------------------------------

   sorted_indices = SORT( aActs.smstime )
   
   IF N_ELEMENTS( sorted_indices ) GT 0 THEN BEGIN
      
      aSorted_acts = aActs( sorted_indices )
      line_count = 6
      FOR i=0, N_ELEMENTS( aSorted_acts )-1 DO BEGIN
         
         PRINTF, act_lun, aSorted_acts[i].smstime + '  ' + $
          STRING( FORMAT='(A8)',aSorted_acts[i].type) + '  ' + $
          aSorted_acts[i].activity(0)

         line_count = line_count + 1

         IF aSorted_acts[i].activity(1) NE '' THEN BEGIN
            PRINTF, act_lun, strpad(11)+aSorted_acts[i].activity(1)
            line_count = line_count + 1
            IF aSorted_acts[i].activity(2) NE '' THEN BEGIN
               PRINTF, act_lun, strpad(11)+aSorted_acts[i].activity(2)
               line_count = line_count + 1
               IF aSorted_acts[i].activity(3) NE '' THEN BEGIN
                  PRINTF, act_lun, strpad(11)+aSorted_acts[i].activity(3)
                  line_count = line_count + 1
                  IF aSorted_acts[i].activity(4) NE '' THEN BEGIN
                     PRINTF, act_lun, strpad(11)+aSorted_acts[i].activity(4)
                     line_count = line_count + 1
                  ENDIF 
               ENDIF
            ENDIF 
         ENDIF 
         
         IF line_count GE 55 THEN BEGIN
            PRINTF,act_lun,STRING(12B)
            line_count = 0
         ENDIF 

      ENDFOR

   ENDIF 

   FREE_LUN, act_lun

   IF NOT KEYWORD_SET( screen ) THEN BEGIN
      IF (verbose GE 1) THEN PRINTF, -2, FORMAT='("wrote ",A)', filename
   ENDIF

END

; _____________________________________________________________________________

   
PRO asp_write_rev, filename, smsfile, CCD=aCCDExp, MAMA=aMamaExp, $
                   SCREEN=screen, VERBOSE=verbose, OVER=over, HEADER=aHeader, $
                   WIDE=wide

   IF (N_ELEMENTS( aCCDExp ) LE 0) AND (N_ELEMENTS( aMamaExp ) LE 0) THEN BEGIN
      PRINTF, -2, STRING(7b)
      MESSAGE, 'warning: no observation review output.', /INFO, /NONAME
      return
   ENDIF 

   IF KEYWORD_SET( screen ) THEN BEGIN
      rev_lun = -1
      stdout = FSTAT(-1)
      IF stdout.isatty THEN more=1 ELSE more=0
      OPENW, rev_lun, FILEPATH(/TERMINAL), MORE=more, /GET_LUN
   ENDIF ELSE BEGIN
      IF NOT KEYWORD_SET( over ) THEN BEGIN
         file_list = FINDFILE( filename, COUNT=file_count )
         
         IF file_count GT 0 THEN BEGIN
            MESSAGE, 'warning: observation review file exists, skipping.', $
             /INFO, /NONAME
            return
         ENDIF
      ENDIF

      IF N_ELEMENTS( filename ) LE 0 THEN MESSAGE, 'filename not specified.'
                    ; OPEN Observation Review file
      OPENW, rev_lun, filename, /GET_LUN
   ENDELSE
   
   PRINTF, rev_lun, FORMAT='(A,/)', strpad(25)+'ACS OBSERVATION SUMMARY'
   IF N_ELEMENTS(aHeader) GT 0 THEN BEGIN
      FOR i=0,N_ELEMENTS(aHeader)-1 DO BEGIN
         PRINTF, rev_lun, aHeader[i]
      ENDFOR 
   ENDIF 
   line_count = 4
   
   IF N_ELEMENTS( aCCDExp ) GT 0 THEN BEGIN
      PRINTF, rev_lun, 'CCD Exposures'

      IF KEYWORD_SET(wide) THEN BEGIN
         PRINTF, rev_lun, FORMAT='(191A1,/)', REPLICATE('_',191)
         strFormat = '(A17,2X,A3,2X,A6,2X,A9,2X,A3,2X,A8,$)'
         PRINTF, rev_lun, FORMAT=strFormat, $
          'SMSTIME','DET','OPMODE','OBSTYPE','ARR','ROOTNAME'
         strFormat = '(2X,A6,2X,A5,2X,A3,$)'
         PRINTF, rev_lun, FORMAT=strFormat, $
          'ETIME', 'AMP', 'G/O'
         strFormat = '(2X,A4,2X,A4,2X,A4,2X,A4,$)'
         PRINTF, rev_lun, FORMAT=strFormat, $
          'XSIZ', 'YSIZ', 'XCOR', 'YCOR'
         strFormat = '(2X,A8,":",A4,2X,A8,":",A4,$)'
         PRINTF, rev_lun, FORMAT=strFormat, $
          'FILT1', 'OF', 'FILT2', 'OF'
         strFormat = '(2X,A7,2X,A8,1X,A4,$)'
         PRINTF, rev_lun, FORMAT=strFormat, $
          'FLASH', 'CALDOOR', 'FOLD'
         strFormat = '(2X,A8,2X,A8,2X,A8,2X,A5,/)'
         PRINTF, rev_lun, FORMAT=strFormat, $
          'CORIN', 'COROUT', 'CORFOC', 'COMPR'
      ENDIF ELSE PRINTF, rev_lun, FORMAT='(80A1,/)', REPLICATE('_',80)

      line_count = line_count + 3

      FOR i=0L, N_ELEMENTS(aCCDExp)-1 DO BEGIN
         
         IF (aCCDExp[i].full_array EQ 1) THEN array="FULL" ELSE array="SUB"

         IF KEYWORD_SET(wide) THEN BEGIN
            strFormat = '(A17,2X,A3,2X,A6,2X,A9,2X,A3,2X,A8,$)'
         ENDIF ELSE BEGIN
            strFormat = '(A21,3X,A5,2X,A6,2X,A9,2X,A4,2X,A8)'
            line_count = line_count + 1
         ENDELSE
         CASE aCCDExp[i].target_type OF
            'TUNGSTEN': target_type = STRTRIM(aCCDExp[i].int_target,2)
            'D2': target_type = 'DEUTERIUM'
            ELSE: target_type = aCCDExp[i].target_type
         ENDCASE
         PRINTF, rev_lun, FORMAT=strFormat, $
          aCCDExp[i].smstime,$
          aCCDExp[i].detector,$
          aCCDExp[i].opmode,$
          target_type,$
          array, $
          'J'+aCCDExp[i].progid+aCCDExp[i].obset+aCCDExp[i].obsid

         IF (aCCDExp[i].target_type EQ 'EXTERNAL') AND (NOT KEYWORD_SET(wide)) AND $
          (aCCDExp[i].ext_target NE '') THEN BEGIN
            PRINTF,rev_lun,FORMAT='(10X,"TARGET:",1X,A30)', aCCDExp[i].ext_target
            line_count = line_count + 1
         ENDIF 

         filter1 = aCCDExp[i].filter1
         filter2 = aCCDExp[i].filter2
         filter1_off = aCCDExp[i].filter1_offset
         filter2_off = aCCDExp[i].filter2_offset

         IF filter1 EQ '' THEN filter1 = 'none'
         IF filter2 EQ '' THEN filter2 = 'none'
         
         IF KEYWORD_SET(wide) THEN BEGIN
            strFormat = '(2X,F6.1,2X,A5,2X,I1,"/",I1,$)'
         ENDIF ELSE BEGIN
            strFormat = '(10X,"ETIME:",F8.1,2X,"AMP:",A5,7X,"GAIN:",1X,I2,10X,"OFFSET:",1X,I2)'
            line_count = line_count + 1
         ENDELSE
         PRINTF, rev_lun, FORMAT=strFormat, $
          aCCDExp[i].exp_time, $
          aCCDExp[i].ccd_amp, $
          aCCDExp[i].ccd_gain, $
          aCCDExp[i].ccd_offset

         IF KEYWORD_SET(wide) THEN BEGIN
            strFormat='(2X,I4,2X,I4,2X,I4,2X,I4,$)'
            PRINTF, rev_lun, FORMAT=strFormat, $
             aCCDExp[i].xsize, aCCDExp[i].ysize, aCCDExp[i].xcorner, aCCDExp[i].ycorner
         ENDIF ELSE BEGIN
            IF array EQ 'SUB' THEN BEGIN
               strFormat='(10X,"XSIZE:",I5,5X,"YSIZE:",I5,5X,"XCORNER:",I5,5X,"YCORNER:",I5)'
               line_count = line_count + 1
               PRINTF, rev_lun, FORMAT=strFormat, $
                aCCDExp[i].xsize, aCCDExp[i].ysize, aCCDExp[i].xcorner, aCCDExp[i].ycorner
            ENDIF 
         ENDELSE

         IF KEYWORD_SET(wide) THEN BEGIN
            strFormat = '(2X,A8,":",I4,2X,A8,":",I4,$)'
         ENDIF ELSE BEGIN 
            strFormat = '(10X,"FILT1:",A8,2X,"OFFSET:",1X,I4,4X,"FILT2:",1X,A8,3X,"OFFSET:",1X,I4)'
            line_count = line_count + 1
         ENDELSE
         PRINTF, rev_lun, FORMAT=strFormat, $
          filter1, filter1_off, filter2, filter2_off 

         IF aCCDExp[i].opmode EQ 'TARACQ' AND (NOT KEYWORD_SET(wide)) THEN BEGIN
            PRINTF,rev_lun,FORMAT='(10X,"TA_SPOT:",1X,A8,15X,"TA_BOXSIZE:",2X,I3)',$
             aCCDExp[i].ta_spot, aCCDExp[i].ta_boxsize
            line_count = line_count + 1
         ENDIF

         IF KEYWORD_SET(wide) THEN BEGIN
            strFormat = '(2X,F6.2,A1,2X,A8,2X,A3,$)'
         ENDIF ELSE BEGIN 
            strFormat = '(10X,"FLASH:",1X,F6.2,1X,A1,6X,"CALDOOR:",1X,A8,6X,"FOLD:",1X,A4)'
            line_count = line_count + 1
         ENDELSE
         PRINTF, rev_lun, FORMAT=strFormat, $
          aCCDExp[i].flash_dur, aCCDExp[i].flash_cur, aCCDExp[i].door, aCCDExp[i].fold

         IF KEYWORD_SET(wide) THEN BEGIN
            strFormat = '(2X,F8.2,2X,F8.2,2X,F8.2,$)'
         ENDIF ELSE BEGIN 
            strFormat = '(10X,"CORIN:",1X,F8.2,6X,"COROUT:",1X,F8.2,7X,"CORFOC:",1X,F8.2)'
            line_count = line_count + 1
         ENDELSE
         PRINTF, rev_lun, FORMAT=strFormat, $
          aCCDExp[i].corinn, aCCDExp[i].corout, aCCDExp[i].corfoc

         IF KEYWORD_SET(wide) THEN BEGIN
            strFormat = '(2X,I4,A1)'
            PRINTF, rev_lun, FORMAT=strFormat, $
             aCCDExp[i].compress, aCCDExp[i].comptype
         ENDIF ELSE BEGIN 
            IF aCCDExp[i].compress GT 0 THEN BEGIN
               strFormat = '(10X,"COMPRESS:",1X,I4,7X,"COMPTYPE:",1X,A5,/)'
               line_count = line_count + 1
               PRINTF, rev_lun, FORMAT=strFormat, $
                aCCDExp[i].compress, aCCDExp[i].comptype
            ENDIF ELSE PRINTF, rev_lun, '' 
         ENDELSE
         
         line_count = line_count + 1

         IF line_count GE 54 THEN BEGIN 
            PRINTF, rev_lun, STRING(12b)
            line_count = 0
         ENDIF 

      ENDFOR
   ENDIF 

   IF line_count GE 50 THEN BEGIN 
      PRINTF,rev_lun,STRING(12B)
      line_count = 0
   ENDIF 

   IF N_ELEMENTS( aMamaExp ) GT 0 THEN BEGIN
      PRINTF, rev_lun, FORMAT='(/,/,A)', 'MAMA Exposures'

      IF KEYWORD_SET(wide) THEN BEGIN
         PRINTF, rev_lun, FORMAT='(191A1,/)', REPLICATE('_',191)
         strFormat = '(A17,2X,A3,2X,A6,2X,A8,2X,A10,$)'
         PRINTF, rev_lun, FORMAT=strFormat, $
          'SMSTIME','DET','ETIME','OBSTYPE','ROOTNAME'
         strFormat = '(2X,A8,":",A3,$)'
         PRINTF, rev_lun, FORMAT=strFormat, $
          'FILTER', 'OF'
         strFormat = '(2X,A8,2X,A4,$)'
         PRINTF, rev_lun, FORMAT=strFormat, $
          'CALDOOR', 'FOLD'
         strFormat = '(2X,A8,2X,A8,2X,A8,/)'
         PRINTF, rev_lun, FORMAT=strFormat, $
          'CORIN', 'COROUT', 'CORFOC'
      ENDIF ELSE PRINTF, rev_lun, FORMAT='(80A1,/)', REPLICATE('_',80)


      line_count = line_count + 5

      FOR i=0L, N_ELEMENTS(aMamaExp)-1 DO BEGIN

         IF KEYWORD_SET(wide) THEN BEGIN
            strFormat = '(A17,2X,A3,2X,F6.1,2X,A8,2X,A10,$)'
         ENDIF ELSE BEGIN
            strFormat = '(A22,2X,A5,10X,F6.1,1X,"sec",2X,A10,2X,A10)'
            line_count = line_count + 1
         ENDELSE 
         PRINTF, rev_lun, FORMAT=strFormat, $
          aMamaExp[i].smstime, 'SBC', $
          aMamaExp[i].exp_time, $
          aMamaExp[i].target_type, $
          'J'+aMamaExp[i].progid+aMamaExp[i].obset+aMamaExp[i].obsid
         
         IF (aMamaExp[i].target_type EQ 'EXTERNAL') AND (NOT KEYWORD_SET(wide)) AND $
          (aMamaExp[i].ext_target NE '') THEN BEGIN
            PRINTF,rev_lun,FORMAT='(10X,"TARGET:",1X,A30)', aMamaExp[i].ext_target
            line_count = line_count + 1
         ENDIF 

         IF KEYWORD_SET(wide) THEN BEGIN
            strFormat = '(2X,A8,":",I3,$)'
         ENDIF ELSE BEGIN
            strFormat = '(10X,"FILTER:",1X,A8,5X,"OFFSET:",1X,I3)'
            line_count = line_count + 1
         ENDELSE 
         PRINTF, rev_lun, FORMAT=strFormat, $
          aMamaExp[i].filter, aMamaExp[i].filter_offset
         
         IF KEYWORD_SET(wide) THEN BEGIN
            strFormat = '(2X,A8,2X,A4,$)'
         ENDIF ELSE BEGIN
            strFormat = '(10X,"CALDOOR:",1X,A8,4X,"FOLD:",1X,A4)'
            line_count = line_count + 1
         ENDELSE 
         PRINTF, rev_lun, FORMAT=strFormat, $
          aMamaExp[i].door, aMamaExp[i].fold
         
         IF KEYWORD_SET(wide) THEN BEGIN
            strFormat = '(2X,F8.2,2X,F8.2,2X,F8.2)'
         ENDIF ELSE BEGIN
            strFormat = '(10X,"CORIN:",1X,F8.2,6X,"COROUT:",1X,F8.2,7X,"CORFOC:",1X,F8.2,/)'
            line_count = line_count + 1
         ENDELSE 
         line_count = line_count + 1
         PRINTF, rev_lun, FORMAT=strFormat, $
          aMamaExp[i].corinn, aMamaExp[i].corout, aMamaExp[i].corfoc

         IF line_count GE 55 THEN BEGIN 
            PRINTF,rev_lun,STRING(12B)
            line_count = 0
         ENDIF 

      ENDFOR 
   ENDIF

   FREE_LUN, rev_lun
   IF NOT KEYWORD_SET( screen ) THEN BEGIN
      IF (verbose GE 1) THEN PRINTF, -2, FORMAT='("wrote ",A)', filename
   ENDIF
END

; _____________________________________________________________________________

FUNCTION asp_get_new_line, line_num, LUN=lun, REC=rec_array

   line = ''

   IF N_ELEMENTS( rec_array ) GT 0 THEN BEGIN

      line = rec_array( line_num ) ; get a line from the file
      line = STRING( line ) ; convert the line to a string
      line_num = line_num + 1

   ENDIF ELSE BEGIN

;      PRINTF, -2, FORMAT='("READF ",$)'
      IF NOT EOF( lun ) THEN BEGIN
         line = ' '
         READF, lun, line
         line_num = line_num + 1
      ENDIF ELSE line = ''

   ENDELSE


   return, line
END 

; _____________________________________________________________________________

FUNCTION asp_skel_amps

   sCCDAmps = { ASP_AMP_STATE, $
                wfc: { ASP_AMP_WFC, gain: { ASP_AMP_WFC_GAIN, a:-1, b:-1, c:-1, d:-1 }, $
                       offset: {ASP_AMP_WFC_OFFSET, a:-1, b:-1, c:-1, d:-1 } }, $
                hrc: { ASP_AMP_HRC, gain: { ASP_AMP_HRC_GAIN, a:-1, b:-1, c:-1, d:-1 }, $
                       offset: {ASP_AMP_HRC_OFFSET, a:-1, b:-1, c:-1, d:-1 } } }
   
   return, sCCDAmps
END 

FUNCTION asp_skel_header

   sHeader = { ASP_HEADER, $
               mebid: 0, $
               sms_id: '', $
               calendar: '', $
               created: '', $
               db_id: '', $
               start_time: '', $
               end_time: '' }

   return, sHeader
END 

FUNCTION asp_skel_size
   sCCDSize = { ASP_SIZE_STATE, $
                wfc: { ASP_SIZE_WFC, $
                       data_size: -1l, $
                       full_array: -1, $
                       xcorner: -1, ycorner: -1, $
                       xsize: -1, ysize: -1 }, $
                hrc: { ASP_SIZE_HRC, $
                       data_size: -1l, $
                       full_array: -1, $
                       xcorner: -1, ycorner: -1, $
                       xsize: -1, ysize: -1 } }
   return, sCCDSize
END

FUNCTION asp_skel_mech
   sMech = { ASP_MECH, $
             wfc: { ASP_MECH_WFC, corinn: 0.0, corout: 0.0, corfoc: 0.0 }, $
             hrc: { ASP_MECH_HRC, corinn: 0.0, corout: 0.0, corfoc: 0.0 } }
   return, sMech
END 

FUNCTION asp_skel_ccd

   sCCDExposure = { ASP_CCD_EXPOSURE, $
                    smstime: '', $
                    detector: '', $
                    opmode: '', $
                    target_type: '', $
                    full_array: -1, $
                    data_size: 0l, $
                    progid: '', $
                    obset: '', $
                    obsid: '', $
                    exp_time: -1.0, $
                    ccd_amp: '', $
                    ccd_gain: -1, $
                    ccd_offset: -1, $
                    ccd_config: '', $
                    xcorner: -1, $
                    ycorner: -1, $
                    xsize: -1, $
                    ysize: -1, $
                    flash_cur: 'OFF', $
                    flash_dur: -1.0, $
                    flash_det: '', $
                    compress: 0, $
                    comptype: 'NONE', $
                    filter1: '', $
                    filter1_offset: -1, $
                    filter2: '', $
                    filter2_offset: -1, $
                    int_target: 'INTERNAL', $
                    ext_target: 'EXTERNAL', $
                    ta_spot: '', $
                    ta_boxsize: '', $
                    fold: '', $
                    door: '', $
                    corfoc: 0.0, $
                    corinn: 0.0, $
                    corout: 0.0 }
   return, sCCDExposure

END 

FUNCTION asp_skel_mama

   sMamaExposure = { ASP_MAMA_EXPOSURE, $
                     smstime: '', $
                     data_size: 0l, $
                     exp_time: -1.0, $
                     obset: '', $
                     obsid: '', $
                     progid: '', $
                     fold: '', $
                     door: '', $
                     target_type: '', $
                     int_target: 'INTERNAL', $
                     ext_target: 'EXTERNAL', $
                     filter: '', $
                     filter_offset: -1, $
                     corfoc: 0.0, $
                     corinn: 0.0, $
                     corout: 0.0 }

   return, sMamaExposure
END 

FUNCTION asp_skel_lamp

   sLamp = { ASP_LAMP, $
             lamp: '', $
             bulb: -1, $
             power: '', $
             smstime: '' }

   return, sLamp
END

FUNCTION asp_skel_mie

   sMIE = { ASP_MIE, $
            progid: '', $
            obset: '', $
            obsid: '', $
            smstime: '' }

   return, sMIE
END

FUNCTION asp_skel_dump

   sDump = { ASP_DUMP, $
             availability: '', $
             progid: '', $
             obset: '', $
             obsid: '', $
             compression: '', $
             csmode: '', $
             number: -1, $
             rate: -1.0, $
             service: '', $
             tapeopt: '', $
             smstime: '' }

   return, sDump
END

FUNCTION asp_skel_corrector

   sCorrector = { ASP_CORRECTOR, $
                  channel: '', $ ; HRC/WFC
                  mode: '', $ ; RELATIVE/ABSOLUTE
                  motor: '', $ ; FOCUS/INNER/OUTER
                  steps: 0.0, $
                  smstime: '' }

   return, sCorrector
END 

FUNCTION asp_skel_recon

   sRecon = { ASP_RECON, $
              mode: '', $
              smstime: '' }

   return, sRecon
END

FUNCTION asp_skel_macro

   sRecon_macro = { ASP_RECON_MACRO, $
                    name: '', $
                    mode: '' }

   return, sRecon_macro
END

FUNCTION asp_skel_door

   sDoor = { ASP_CALDOOR, $
             position: '', $
             motor: '', $
             speed: '', $
             smstime: '' }

   return, sDoor
END

FUNCTION asp_skel_fold

   sFold = { ASP_FOLD_MIRROR, $
             position: '', $
             smstime: '' }

   return, sFold
END

FUNCTION asp_skel_slew

   sSlew = { ASP_SLEW, $
             aper_eid: '', $
             aper_sid: '', $
             end_dec: -1.0D, $
             end_pa: -1.0D, $
             end_ra: -1.0D, $
             strt_dec: -1.0D, $
             strt_pa: -1.0D, $
             strt_ra: -1.0D, $
             off_era: -1.0D, $
             off_ede: -1.0D, $
             type: -1, $
             cpname: '', $
             smstime: '' }

   return, sSlew
END

; _____________________________________________________________________________


PRO asp, files, VERBOSE=verbose, OBSREV=revinput, ACTLOG=actinput, $
         ALL=all, NON_STD=non_std, FILES=to_file, OVER=over, WIDE=wide

   ON_ERROR, 2

                    ; Set nominal array sizes
   wfc_xsize = 4146l
   wfc_ysize = 4136l
   hrc_xsize = 1064l
   hrc_ysize = 1044l
   sbc_xsize = 1024l
   sbc_ysize = 1024l

   targacq_xsize = 200l
   targacq_ysize = 200l

                    ; -------------------------------------
                    ; Check input
                    ; -------------------------------------

   IF N_ELEMENTS( verbose ) LE 0 THEN verbose = 0

   IF N_ELEMENTS( files ) EQ 0 THEN BEGIN
      MESSAGE, 'usage: ASP, filename', /NONAME, /CONTINUE 
      return
   ENDIF

;   CATCH, Error_status
;   IF Error_status NE 0 THEN BEGIN
;      MESSAGE, 'Caught error index: ' + STRTRIM(Error_status,2), /INFO, /NONAME
;      MESSAGE, 'Caught error message: ' + !ERR_STRING, /INFO, /NONAME
   
;      return
;   ENDIF 

   IF N_ELEMENTS( files ) GT 1 THEN BEGIN
      file_list = files
   ENDIF ELSE BEGIN

      file_list = FINDFILE( files, COUNT = file_count )

      IF file_count LE 0 THEN BEGIN
         MESSAGE, "error: could not find file " + files, /CONT, /NONAME
         return
      ENDIF

   ENDELSE

   FOR file_i = 0, N_ELEMENTS( file_list ) - 1 DO BEGIN

      file = file_list[ file_i ]
      FDECOMP,  file, disk, dir, name, qual, vers

      sms_file = disk + dir + name + '.' + qual + vers

                    ; output all by default
      do_rev = 1b
      do_act = 1b

      IF KEYWORD_SET( to_file ) THEN BEGIN
         to_screen = 0b
         ; To current directory or not ?
;         revfile = disk + dir + name + '.rev'
;         actfile = disk + dir + name + '.act'
         revfile = name + '.rev'
         actfile = name + '.act'
      ENDIF ELSE BEGIN
         to_screen = 1b
         revfile = ''
         actfile = ''
      ENDELSE

      IF N_ELEMENTS( revinput ) GT 0 THEN BEGIN
         rev_sz = SIZE( revinput )
         
         type = rev_sz( rev_sz(0)+1 )
         IF type EQ 7 THEN BEGIN
            revfile = revinput
            to_screen = 0b
         ENDIF

         do_rev = 1b
         do_act = 0b
         
      ENDIF

      IF N_ELEMENTS( actinput ) GT 0 THEN BEGIN
         act_sz = SIZE( actinput )
         
         type = act_sz( act_sz(0)+1 )
         IF type EQ 7 THEN BEGIN
            to_screen = 0b
            actfile = actinput
         ENDIF

         do_act = 1b
         IF N_ELEMENTS( revinput ) LE 0 THEN do_rev = 0b
      ENDIF

                    ; -------------------------------------
                    ; Open Files
                    ; -------------------------------------

                    ; OPEN SMS FILE
      OPENR, sms_lun, sms_file, /GET_LUN, ERROR = open_error

      IF open_error NE 0 THEN BEGIN
         MESSAGE, "error: can't read SMS file: "+sms_file, /CONT, /NONAME
      ENDIF ELSE BEGIN

         IF NOT KEYWORD_SET( non_std ) THEN BEGIN

            fstatus = FSTAT( sms_lun )

            line_length = 71b
            IF fstatus.size MOD line_length NE 0 THEN BEGIN
               MESSAGE, $
                "error: SMS not in standard format.  Use /NON_STD switch.", $
                /CONT, /NONAME
               return
            ENDIF
                    ; associate SMS with variable
            rec = ASSOC( sms_lun, BYTARR(line_length) ) 

         ENDIF
                    ; OPEN Observation list file
         OPENR, otr_lun, disk + dir + name + '.potr', $
          ERROR=err, /GET_LUN
         IF ( err NE 0 ) THEN OPENR, otr_lun, disk + dir + name + $
          '.otr', ERROR=err, /GET_LUN
         IF ( err NE 0 ) THEN $
          MESSAGE, "warning: can't open observation list file.", $
          /NONAME, /INFO

                    ; -------------------------------------
                    ; Variable initialization
                    ; -------------------------------------

         sHeader = asp_skel_header()
         sCCDSize = asp_skel_size()
         sMech = asp_skel_mech()
         sCCDAmps = asp_skel_amps()
         sCCDExposure = asp_skel_ccd()
         sMamaExposure = asp_skel_mama()
         sLamp = asp_skel_lamp()
         sDump = asp_skel_dump()
         sMIE = asp_skel_mie()
         sCorrector = asp_skel_corrector()
         sRecon = asp_skel_recon()
         sRecon_macro = asp_skel_macro()
         sDoor = asp_skel_door()
         sFold = asp_skel_fold()
         sSlew = asp_skel_slew()

                    ; -------------------------------------
                    ; Parse SMS file
                    ; -------------------------------------

         IF (verbose GE 1) THEN PRINTF, -2, FORMAT='("parsing ",A,"...")',sms_file
         
         rec_i = 0
         line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )

         WHILE NOT EOF(sms_lun) DO BEGIN
                    ; There should be a new 'line' to process on each
                    ; iteration of this loop
            
            id = STRMID( line, 1, 10 )

                    ; skip ahead to the start of next sms command
            WHILE (STRCOMPRESS( id, /REMOVE ) EQ '') AND NOT EOF(sms_lun) DO BEGIN

               IF (verbose GT 10) THEN PRINTF, -2, 'skipping: ' + line

               line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )

                    ; extract 10 characters starting at the 1st position
               id = STRMID( line, 1, 10 )

            ENDWHILE

                    ; extract 5 characters starting at the 11th position
            a = STRMID( line, 11, 5 )
            
            IF (verbose GE 3) THEN PRINTF, -2, 'got key: '+STRTRIM(a,2)

            CASE 1 OF
                    ; for efficiency keys should be in order of
                    ; most->least used
               (a EQ ':TABL'): BEGIN

                  junk = GETTOK( line, ',' )
                  table_key = GETTOK( line, ',' )
                  IF (verbose GE 2) THEN PRINTF, -2, "processing: "+STRTRIM( a, 2 )+ $
                   ' '+table_key+' @ line '+STRTRIM(rec_i, 2)
                  
                  CASE table_key OF 
                     

                     'JHRCCFG1': BEGIN
                        sCCDExposure.ccd_config = 'HRC1'
                        FOR i=0,N_TAGS(sCCDAmps.hrc.gain)-1 DO BEGIN
                           sCCDAmps.hrc.gain.(i) = 1
                           sCCDAmps.hrc.offset.(i) = 0
                        ENDFOR

                        line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                     END 
                     'JHRCCFG2': BEGIN
                        sCCDExposure.ccd_config = 'HRC2'
                        FOR i=0,N_TAGS(sCCDAmps.hrc.gain)-1 DO BEGIN
                           sCCDAmps.hrc.gain.(i) = 2
                           sCCDAmps.hrc.offset.(i) = 0
                        ENDFOR

                        line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                     END 
                     'JHRCCFG4': BEGIN
                        sCCDExposure.ccd_config = 'HRC4'
                        FOR i=0,N_TAGS(sCCDAmps.hrc.gain)-1 DO BEGIN
                           sCCDAmps.hrc.gain.(i) = 4
                           sCCDAmps.hrc.offset.(i) = 0
                        ENDFOR

                        line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                     END 
                     'JHRCCFG8': BEGIN
                        sCCDExposure.ccd_config = 'HRC8'
                        FOR i=0,N_TAGS(sCCDAmps.hrc.gain)-1 DO BEGIN
                           sCCDAmps.hrc.gain.(i) = 8
                           sCCDAmps.hrc.offset.(i) = 0
                        ENDFOR

                        line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                     END 

                     'JWFCCFG1': BEGIN
                        sCCDExposure.ccd_config = 'WFC1' 
                        FOR i=0,N_TAGS(sCCDAmps.wfc.gain)-1 DO BEGIN
                           sCCDAmps.wfc.gain.(i) = 1
                           sCCDAmps.wfc.offset.(i) = 0
                        ENDFOR

                        line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                     END 
                     'JWFCCFG2': BEGIN
                        sCCDExposure.ccd_config = 'WFC2'
                        FOR i=0,N_TAGS(sCCDAmps.wfc.gain)-1 DO BEGIN
                           sCCDAmps.wfc.gain.(i) = 2
                           sCCDAmps.wfc.offset.(i) = 0
                        ENDFOR

                        line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                     END 
                     'JWFCCFG4': BEGIN
                        sCCDExposure.ccd_config = 'WFC4'
                        FOR i=0,N_TAGS(sCCDAmps.wfc.gain)-1 DO BEGIN
                           sCCDAmps.wfc.gain.(i) = 4
                           sCCDAmps.wfc.offset.(i) = 0
                        ENDFOR

                        line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                     END 
                     'JWFCCFG8': BEGIN
                        sCCDExposure.ccd_config = 'WFC8'
                        FOR i=0,N_TAGS(sCCDAmps.wfc.gain)-1 DO BEGIN
                           sCCDAmps.wfc.gain.(i) = 8
                           sCCDAmps.wfc.offset.(i) = 0
                        ENDFOR

                        line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                     END 

                     'JCCDGAIN': BEGIN
                        amp = ''
                        detector = ''
                        gain = ''
                        sCCDExposure.ccd_config = ''
                        REPEAT BEGIN
                           value = asp_parse_inparen( line, 'AMP' )
                           IF value NE '' THEN amp = value
                           value = asp_parse_inparen( line, 'DET' )
                           IF value NE '' THEN detector = value
                           value = asp_parse_inparen( line, 'GAIN' )
                           IF value NE '' THEN gain = value
                           line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                        IF amp NE '' AND detector NE '' AND gain NE '' THEN BEGIN
                           n_det = WHERE( STRUPCASE(TAG_NAMES(sCCDAmps)) EQ $
                                          STRUPCASE(detector), wc )
                           IF wc GT 0 THEN BEGIN
                              n_amp = WHERE( STRUPCASE(TAG_NAMES(sCCDAmps.(n_det[0]).gain)) EQ $
                                             STRUPCASE(amp), wc )
                              IF wc GT 0 THEN BEGIN
                                 sCCDAmps.(n_det[0]).gain.(n_amp[0]) = FIX(gain)
                              ENDIF ELSE BEGIN
                                 MESSAGE, 'warning: unknown amp in JCCDGAIN: '+amp, $
                                  /CONT, /NONAME                              
                              ENDELSE
                           ENDIF ELSE BEGIN
                              MESSAGE, 'warning: unknown detector in JCCDGAIN: '+detector, $
                               /CONT, /NONAME
                           ENDELSE
                        ENDIF ELSE BEGIN
                           MESSAGE, 'warning: could not parse JCCDGAIN activity', $
                            /CONT, /NONAME
                        ENDELSE 
                     END

                     'JCCDOFST': BEGIN
                        sCCDExposure.ccd_config = ''
                        amp = ''
                        detector = ''
                        offset = ''
                        REPEAT BEGIN
                           value = asp_parse_inparen( line, 'AMP' )
                           IF value NE '' THEN amp = value
                           value = asp_parse_inparen( line, 'DET' )
                           IF value NE '' THEN detector = value
                           value = asp_parse_inparen( line, 'DN' )
                           IF value NE '' THEN offset = value
                           line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                        IF amp NE '' AND detector NE '' AND offset NE '' THEN BEGIN
                           n_det = WHERE( STRUPCASE(TAG_NAMES(sCCDAmps)) EQ $
                                          STRUPCASE(detector), wc )
                           IF wc GT 0 THEN BEGIN
                              n_amp = WHERE( STRUPCASE(TAG_NAMES(sCCDAmps.(n_det[0]).offset)) EQ $
                                             STRUPCASE(amp), wc )
                              IF wc GT 0 THEN BEGIN
                                 sCCDAmps.(n_det[0]).offset.(n_amp[0]) = FIX(offset)
                              ENDIF ELSE BEGIN
                                 MESSAGE, 'warning: unknown amp in JCCDOFST: '+amp, $
                                  /CONT, /NONAME                              
                              ENDELSE
                           ENDIF ELSE BEGIN
                              MESSAGE, 'warning: unknown detector in JCCDOFST: '+detector, $
                               /CONT, /NONAME
                           ENDELSE
                        ENDIF ELSE BEGIN
                           MESSAGE, 'warning: could not parse JCCDOFST activity', $
                            /CONT, /NONAME
                        ENDELSE 
                     END

                     'JHRCFULL': BEGIN
                        sCCDSize.hrc.data_size = $
                         asp_pix2bytes(hrc_xsize*hrc_ysize, /DATA)
                        sCCDSize.hrc.full_array = 1
                        sCCDSize.hrc.xcorner = -1
                        sCCDSize.hrc.ycorner = -1
                        sCCDSize.hrc.xsize = -1
                        sCCDSize.hrc.ysize = -1

                        REPEAT BEGIN
                           value = asp_parse_inparen( line, 'AMP' )
                           IF value NE '' THEN sCCDExposure.ccd_amp = value
                           value = asp_parse_inparen( line, 'TARGTYPE' )
                           IF value NE '' THEN sCCDExposure.target_type = value
                           line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                     END 

                     'JWFCFULL': BEGIN
                        sCCDSize.wfc.data_size = $
                         asp_pix2bytes(wfc_xsize*wfc_ysize, /DATA)

                        sCCDSize.wfc.full_array = 1
                        sCCDSize.wfc.xcorner = -1
                        sCCDSize.wfc.ycorner = -1
                        sCCDSize.wfc.xsize = -1
                        sCCDSize.wfc.ysize = -1

                        REPEAT BEGIN
                           value = asp_parse_inparen( line, 'AMP' )
                           IF value NE '' THEN sCCDExposure.ccd_amp = value
                           value = asp_parse_inparen( line, 'TARGTYPE' )
                           IF value NE '' THEN sCCDExposure.target_type = value
                           line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                     END 

                     'JCCDSET': BEGIN
                        detector = ''
                        xcorner = ''
                        ycorner = ''
                        xsize = ''
                        ysize = ''
                        REPEAT BEGIN
                           value = asp_parse_inparen( line, 'AMP' )
                           IF value NE '' THEN sCCDExposure.ccd_amp = value
                           value = asp_parse_inparen( line, 'TARGTYPE' )
                           IF value NE '' THEN sCCDExposure.target_type = value
                           value = asp_parse_inparen( line, 'DET' )
                           IF value NE '' THEN detector = value
                           value = asp_parse_inparen( line, 'XCORNER' )
                           IF value NE '' THEN xcorner = value
                           value = asp_parse_inparen( line, 'YCORNER' )
                           IF value NE '' THEN ycorner = value
                           value = asp_parse_inparen( line, 'XSIZE' )
                           IF value NE '' THEN xsize = value
                           value = asp_parse_inparen( line, 'YSIZE' )
                           IF value NE '' THEN ysize = value
                           line = asp_get_new_line(rec_i,LUN=sms_lun,REC=rec)
                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                        CASE STRUPCASE( detector ) OF

                           'HRC': BEGIN
                              IF xcorner NE '' THEN $
                               sCCDSize.hrc.xcorner=LONG(xcorner)
                              IF ycorner NE '' THEN $
                               sCCDSize.hrc.ycorner=LONG(ycorner)
                              IF xsize NE '' THEN $
                               sCCDSize.hrc.xsize=LONG(xsize)
                              IF ysize NE '' THEN $
                               sCCDSize.hrc.ysize=LONG(ysize)
                              IF (xsize NE '') AND (ysize NE '') THEN BEGIN
                                 sCCDSize.hrc.data_size = $
                                  asp_pix2bytes(LONG(xsize)*LONG(ysize), /DATA)
                              ENDIF 
                              sCCDSize.hrc.full_array = 0
                           END

                           'WFC': BEGIN
                              IF xcorner NE '' THEN $
                               sCCDSize.wfc.xcorner=LONG(xcorner)
                              IF ycorner NE '' THEN $
                               sCCDSize.wfc.ycorner=LONG(ycorner)
                              IF xsize NE '' THEN $
                               sCCDSize.wfc.xsize=LONG(xsize)
                              IF ysize NE '' THEN $
                               sCCDSize.wfc.ysize=LONG(ysize)
                              IF (xsize NE '') AND (ysize NE '') THEN BEGIN
                                 sCCDSize.wfc.data_size = $
                                  asp_pix2bytes(LONG(xsize)*LONG(ysize), /DATA)
                              ENDIF 
                              sCCDSize.wfc.full_array = 0
                           END
                           
                           ELSE: 
                        ENDCASE
                     END 

                     'JCCDGEN': BEGIN

                        REPEAT BEGIN

                           value = asp_parse_inparen( line, 'AMP' )
                           IF value NE '' THEN sCCDExposure.ccd_amp = value

                           value = asp_parse_inparen( line, 'TARGTYPE' )
                           IF value NE '' THEN sCCDExposure.target_type = value
                           
                           value = asp_parse_inparen( line, 'DET' )
                           IF value NE '' THEN detector = value
                           
                           line = asp_get_new_line(rec_i, LUN=sms_lun, REC=rec)

                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                           
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                        CASE STRUPCASE( detector ) OF

                           'HRC': BEGIN
                              sCCDSize.hrc.full_array = 1
                              sCCDSize.hrc.xcorner = -1
                              sCCDSize.hrc.ycorner = -1
                              sCCDSize.hrc.xsize = -1
                              sCCDSize.hrc.ysize = -1
                           END

                           'WFC': BEGIN
                              sCCDSize.wfc.full_array = 1
                              sCCDSize.wfc.xcorner = -1
                              sCCDSize.wfc.ycorner = -1
                              sCCDSize.wfc.xsize = -1
                              sCCDSize.wfc.ysize = -1
                           END
                           
                           ELSE: 
                        ENDCASE

                     END

                     'JFILTER': BEGIN
                        
                        det_str = GETTOK( line, ',' )
                        detector = asp_parse_inparen( det_str, 'DET' )

                        REPEAT BEGIN 
                           
                           value = asp_parse_inparen( line, 'FILTER' )
                           IF value NE '' THEN BEGIN
                              CASE detector OF
                                 'HRC': BEGIN
                                    wheel = asp_what_fwheel( value )
                                    CASE wheel OF
                                       1: sCCDExposure.filter1 = value
                                       2: sCCDExposure.filter2 = value
                                       ELSE: BEGIN
                                          IF (verbose GE 1) THEN $
                                           PRINTF, -2, 'HRC filter: '+value
                                          MESSAGE, 'warning: INVALID JFILTER HRC FILTER: '+value, $
                                           /CONT, /NONAME
                                       END
                                    ENDCASE 
                                 END 
                                 'WFC': BEGIN
                                    wheel = asp_what_fwheel( value )
                                    CASE wheel OF
                                       1: sCCDExposure.filter1 = value
                                       2: sCCDExposure.filter2 = value
                                       ELSE: BEGIN
                                          IF (verbose GE 1) THEN $
                                           PRINTF, -2, 'WFC filter: '+value
                                          MESSAGE, 'warning: INVALID JFILTER WFC FILTER: '+value, $
                                           /CONT, /NONAME
                                       END
                                    ENDCASE
                                 END 
                                 'SBC': sMamaExposure.filter = value
                                 ELSE: MESSAGE, 'warning: INVALID JFILTER DETECTOR', $
                                  /CONT, /NONAME
                              ENDCASE 
                           ENDIF 

                           value = asp_parse_inparen( line, 'OFFSET' )
                           IF value NE '' THEN BEGIN
                              CASE detector OF
                                 'SBC': sMamaExposure.filter_offset = value
                                 ELSE: BEGIN
                                    CASE wheel OF
                                       1: sCCDExposure.filter1_offset = value
                                       2: sCCDExposure.filter2_offset = value
                                       ELSE: MESSAGE, 'warning: INVALID FILTER Wheel', $
                                        /CONT, /NONAME
                                    ENDCASE 
                                 END
                              ENDCASE
                           ENDIF 

                           line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )

                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                           
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                     END 

                     'JCCDFLSH': BEGIN
                        detector = ''
                        current = ''
                        duration = ''
                        REPEAT BEGIN
                           value = asp_parse_inparen( line, 'CURRENT' )
                           IF value NE '' THEN current = value

                           value = asp_parse_inparen( line, 'DURATION' )
                           IF value NE '' THEN duration = value
                           
                           value = asp_parse_inparen( line, 'DET' )
                           IF value NE '' THEN detector = value
                           
                           line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''
                        IF detector NE '' THEN sCCDExposure.flash_det=STRTRIM(detector,2)
                        IF duration NE '' THEN sCCDExposure.flash_dur=FLOAT(duration)
                        IF current  NE '' THEN sCCDExposure.flash_cur=STRTRIM(current,2)
                     END 

                     'JCCDEXP': BEGIN
                        sCCDExposure.opmode = 'ACCUM'
                        REPEAT BEGIN
                           detector = asp_parse_inparen( line, 'DET' )
                           IF detector NE '' THEN sCCDExposure.detector = detector
                           exptime = asp_parse_inparen( line, 'EXPTIME' )
                           IF exptime NE '' THEN sCCDExposure.exp_time = exptime
                           obset = asp_parse_inparen( line, 'OBSET' )
                           IF obset NE '' THEN sCCDExposure.obset = obset
                           obsid = asp_parse_inparen( line, 'OBSID' )
                           IF obsid NE '' THEN sCCDExposure.obsid = obsid
                           progid = asp_parse_inparen( line, 'PROGID' )
                           IF progid NE '' THEN sCCDExposure.progid = progid
                           smstime = asp_parse_smstime( line )
                           IF smstime NE '' THEN sCCDExposure.smstime = smstime

                           line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                    ; Pull in the CCD amp / size / corrector information
                        n_det = WHERE( STRUPCASE(TAG_NAMES(sCCDAmps)) EQ $
                                       STRUPCASE(sCCDExposure.detector), wc )
                    ; only look at first amp - should all be the same anyway
                        ccd_amp = STRMID( sCCDExposure.ccd_amp, 0, 1 )
                        IF wc GT 0 THEN BEGIN
                           sCCDExposure.full_array = sCCDSize.(n_det[0]).full_array
                           sCCDExposure.data_size = sCCDSize.(n_det[0]).data_size
                           sCCDExposure.xsize = sCCDSize.(n_det[0]).xsize
                           sCCDExposure.ysize = sCCDSize.(n_det[0]).ysize
                           sCCDExposure.xcorner = sCCDSize.(n_det[0]).xcorner
                           sCCDExposure.ycorner = sCCDSize.(n_det[0]).ycorner
                           sCCDExposure.corinn = sMech.(n_det[0]).corinn
                           sCCDExposure.corout = sMech.(n_det[0]).corout
                           sCCDExposure.corfoc = sMech.(n_det[0]).corfoc

                           n_amp=WHERE(STRUPCASE(TAG_NAMES(sCCDAmps.(n_det[0]).gain)) EQ $
                                       STRUPCASE(ccd_amp), wc)
                           IF wc GT 0 THEN BEGIN
                              gain = sCCDAmps.(n_det[0]).gain.(n_amp[0])
                              offset = sCCDAmps.(n_det[0]).offset.(n_amp[0])
                              sCCDExposure.ccd_gain = gain
                              sCCDExposure.ccd_offset = offset
                           ENDIF ELSE BEGIN
                              MESSAGE, 'warning: unknown amp in JCCDEXP: '+$
                               sCCDExposure.ccd_amp, /CONT, /NONAME
                           ENDELSE
                        ENDIF ELSE BEGIN
                           MESSAGE, 'warning: unknown detector in JCCDEXP: '+$
                            sCCDExposure.detector, /CONT, /NONAME
                        ENDELSE
                    ; Zero correl values
                     END
                     
                     'JWFCREAD': BEGIN
                        compress = ''
                        comptype = ''
                        REPEAT BEGIN
                           value = asp_parse_inparen( line, 'COMPRESS' )
                           IF value NE '' THEN compress = value
                           value = asp_parse_inparen( line, 'COMPTYPE' )
                           IF value NE '' THEN comptype = value
                           line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''
                        IF compress NE '' THEN sCCDExposure.compress = FIX(compress)
                        IF comptype NE '' THEN sCCDExposure.comptype = STRTRIM(comptype,2)

                        IF (verbose GT 6) THEN HELP, /STR, sCCDExposure

                        IF N_ELEMENTS( aCCDExposures ) LE 0 THEN $
                         aCCDExposures = [sCCDExposure] $
                        ELSE aCCDExposures = [aCCDExposures,sCCDExposure]
                    ; clear the flash and compression status
                        sCCDExposure.flash_det = ''
                        sCCDExposure.flash_cur = 'OFF'
                        sCCDExposure.flash_dur = -1.0
                        sCCDExposure.compress = 0
                        sCCDExposure.comptype = 'NONE'
                     END
                     
                     'JHRCREAD': BEGIN
                        IF (verbose GT 6) THEN HELP, /STR, sCCDExposure

                        IF N_ELEMENTS( aCCDExposures ) LE 0 THEN $
                         aCCDExposures = [sCCDExposure] $
                        ELSE aCCDExposures = [aCCDExposures,sCCDExposure]
                    ; clear the flash
                        sCCDExposure.flash_det = ''
                        sCCDExposure.flash_cur = 'OFF'
                        sCCDExposure.flash_dur = -1.0
                     END

                     'JDUMPSD': BEGIN
                        REPEAT BEGIN
                           value = asp_parse_inparen( line, 'OBSET' )
                           IF value NE '' THEN sDump.obset = value
                           value = asp_parse_inparen( line, 'OBSID' )
                           IF value NE '' THEN sDump.obsid = value
                           value = asp_parse_inparen( line, 'PROGID' )
                           IF value NE '' THEN sDump.progid = value
                           value = asp_parse_inparen( line, 'CSMODE' )
                           IF value NE '' THEN sDump.csmode = value
                           value = asp_parse_inparen( line, 'NUMBER' )
                           IF value NE '' THEN sDump.number = value
                           value = asp_parse_smstime( line )
                           IF value NE '' THEN sDump.smstime = value
                           line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                        IF N_ELEMENTS( aDumps ) LE 0 THEN $
                         aDumps = [sDump] $
                        ELSE aDumps = [aDumps,sDump]
                     END

                     'JTARACQ': BEGIN

                        sCCDExposure.detector = 'HRC'
                        sCCDExposure.opmode = 'TARACQ'

                        REPEAT BEGIN
                           value = asp_parse_inparen( line, 'BOXSIZE' )
                           IF value NE '' THEN sCCDExposure.ta_boxsize = value
                           value = asp_parse_inparen( line, 'SPOT' )
                           IF value NE '' THEN sCCDExposure.ta_spot = value
                           exptime = asp_parse_inparen( line, 'EXPTIME' )
                           IF exptime NE '' THEN sCCDExposure.exp_time = exptime
                           obset = asp_parse_inparen( line, 'OBSET' )
                           IF obset NE '' THEN sCCDExposure.obset = obset
                           obsid = asp_parse_inparen( line, 'OBSID' )
                           IF obsid NE '' THEN sCCDExposure.obsid = obsid
                           progid = asp_parse_inparen( line, 'PROGID' )
                           IF progid NE '' THEN sCCDExposure.progid = progid
                           smstime = asp_parse_smstime( line )
                           IF smstime NE '' THEN sCCDExposure.smstime = smstime
                           line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''
                        IF N_ELEMENTS( aCCDExposures ) LE 0 THEN $
                         aCCDExposures = [sCCDExposure] $
                        ELSE aCCDExposures = [aCCDExposures,sCCDExposure]

                     END 

                     'JTLAMPWR': BEGIN
                    ; TUNGSTEN lamp
                        REPEAT BEGIN
                           sLamp.lamp = 'TUNGSTEN'
                           value = asp_parse_inparen( line, 'BULB' )
                           IF value NE '' THEN sLamp.bulb = value
                           value = asp_parse_inparen( line, 'POWER' )
                           IF value NE '' THEN sLamp.power = value
                           smstime = asp_parse_smstime( line )
                           IF smstime NE '' THEN sLamp.smstime = smstime
                           
                           line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                           
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                        
                        IF N_ELEMENTS( aLamps ) LE 0 THEN aLamps = [sLamp] $
                        ELSE aLamps = [aLamps,sLamp]
                        
                    ; only need to set in CCD exp since Mama can't see Tung.
                        IF sLamp.power EQ 'ON' THEN $
                         sCCDExposure.int_target=sLamp.lamp+strtrim(sLamp.bulb,2) $
                        ELSE sCCDExposure.int_target=''
                     END 

                     'JDLAMPWR': BEGIN
                    ; D2 lamp
                        REPEAT BEGIN
                           sLamp.lamp = 'DEUTERIUM'
                           sLamp.bulb = 1
                           value = asp_parse_inparen( line, 'POWER' )
                           IF value NE '' THEN sLamp.power = value
                           smstime = asp_parse_smstime( line )
                           IF smstime NE '' THEN sLamp.smstime = smstime
                           line=asp_get_new_line(rec_i,LUN=sms_lun,REC=rec)
                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''
                        IF N_ELEMENTS( aLamps ) LE 0 THEN aLamps = [sLamp] $
                        ELSE aLamps = [aLamps,sLamp]

                        IF sLamp.power EQ 'ON' THEN BEGIN
                           sCCDExposure.int_target=sLamp.lamp
                           sMamaExposure.int_target=sLamp.lamp
                        ENDIF ELSE BEGIN
                           sCCDExposure.int_target=''
                           sMamaExposure.int_target=''                     
                        ENDELSE
                     END 

                     'JDOOR': BEGIN
                        
                        REPEAT BEGIN 
                           value = asp_parse_inparen( line, 'MOTOR' )
                           IF value NE '' THEN BEGIN
                              sDoor.motor = value
                           ENDIF
                           value = asp_parse_inparen( line, 'POSITION' )
                           IF value NE '' THEN BEGIN
                              sDoor.position = value
                              sMamaExposure.door = value
                              sCCDExposure.door = value
                           ENDIF

                           value = asp_parse_smstime( line )
                           IF value NE '' THEN sDoor.smstime = value

                           line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                           
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                        IF N_ELEMENTS( aDoors ) LE 0 THEN $
                         aDoors = [sDoor] $
                        ELSE aDoors = [aDoors,sDoor]

                     END 

                     'JDOORINI': BEGIN
                        
                        REPEAT BEGIN 
                           
                           value = asp_parse_inparen( line, 'HOME' )
                           IF value NE '' THEN BEGIN
                              IF value EQ 'YES' THEN BEGIN
                                 sMamaExposure.door = 'HOME'
                                 sCCDExposure.door = 'HOME'
                              ENDIF ELSE BEGIN
                                 sMamaExposure.door = 'INIT'
                                 sCCDExposure.door = 'INIT'
                              ENDELSE 
                           ENDIF 

                           value = asp_parse_inparen( line, 'SPEED' )
                           IF value NE '' THEN BEGIN
                              sDoor.speed = value
                           ENDIF
                           
                           line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )

                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                           
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                     END 


                     'JFOLD': BEGIN
                        
                        REPEAT BEGIN 
                           
                           value = asp_parse_inparen( line, 'POSITION' )
                           IF value NE '' THEN BEGIN
                              sFold.position = value
                              sMamaExposure.fold = value
                              sCCDExposure.fold = value
                           ENDIF 

                           value = asp_parse_smstime( line )
                           IF value NE '' THEN sFold.smstime = value
                           
                           line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )

                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                           
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                        IF N_ELEMENTS( aFolds ) LE 0 THEN $
                         aFolds = [sFold] $
                        ELSE aFolds = [aFolds,sFold]

                     END 

                     'JFOLDINI': BEGIN
                        
                        REPEAT BEGIN 
                           
                           value = asp_parse_inparen( line, 'HOME' )
                           IF value NE '' THEN BEGIN
                              IF value EQ 'YES' THEN BEGIN
                                 sFold.position = 'HOME'
                                 sMamaExposure.fold = 'HOME'
                                 sCCDExposure.fold = 'HOME'
                              ENDIF ELSE BEGIN
                                 sFold.position = 'INIT'
                                 sMamaExposure.fold = 'INIT'
                                 sCCDExposure.fold = 'INIT'
                              ENDELSE 
                           ENDIF 

                           line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )

                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                           
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                     END 

                     'JCORREL': BEGIN
                        
                        REPEAT BEGIN 
                           value = asp_parse_inparen( line, 'MOTOR' )
                           IF value NE '' THEN motor = value
                           value = asp_parse_inparen( line, 'STEPS' )
                           IF value NE '' THEN steps = value
                           smstime = asp_parse_smstime( line )
                           IF smstime NE '' THEN sCorrector.smstime = smstime

                           line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''
                        
                        sCorrector.steps = FLOAT(steps)
                        sCorrector.mode = 'RELATIVE'

                        CASE motor OF 

                           'HCORFOC': BEGIN
                              sCorrector.channel = 'HRC'
                              sCorrector.motor = 'FOCUS'
                              sMech.hrc.corfoc = sMech.hrc.corfoc + FLOAT(steps)
                           END
                           'HCORINNR': BEGIN
                              sCorrector.channel = 'HRC'
                              sCorrector.motor = 'INNER'
                              sMech.hrc.corinn = sMech.hrc.corinn + FLOAT(steps)
                           END 
                           'HCOROUTR': BEGIN
                              sCorrector.channel = 'HRC'
                              sCorrector.motor = 'OUTER'
                              sMech.hrc.corout = sMech.hrc.corout + FLOAT(steps)
                           END

                           'WCORFOC': BEGIN
                              sCorrector.channel = 'WFC'
                              sCorrector.motor = 'FOCUS'
                              sMech.wfc.corfoc = sMech.wfc.corfoc + FLOAT(steps)
                           END
                           'WCORINNR': BEGIN
                              sCorrector.channel = 'WFC'
                              sCorrector.motor = 'INNER'
                              sMech.wfc.corinn = sMech.wfc.corinn + FLOAT(steps)
                           END 
                           'WCOROUTR': BEGIN
                              sCorrector.channel = 'WFC'
                              sCorrector.motor = 'OUTER'
                              sMech.wfc.corout = sMech.wfc.corout + FLOAT(steps)
                           END

                           ELSE: BEGIN
                              PRINTF, -2, 'warning: JCORREL motor value unknown'
                           END 
                        ENDCASE 

                        IF N_ELEMENTS( aCorrectors ) LE 0 THEN $
                         aCorrectors = [sCorrector] $
                        ELSE aCorrectors = [aCorrectors,sCorrector]

                     END 
                     
                     'JMAEXP': BEGIN

                        REPEAT BEGIN 
                           exptime = asp_parse_inparen( line, 'EXPTIME' )
                           IF exptime NE '' THEN sMamaExposure.exp_time = exptime
                           obset = asp_parse_inparen( line, 'OBSET' )
                           IF obset NE '' THEN sMamaExposure.obset = obset
                           obsid = asp_parse_inparen( line, 'OBSID' )
                           IF obsid NE '' THEN sMamaExposure.obsid = obsid
                           progid = asp_parse_inparen( line, 'PROGID' )
                           IF progid NE '' THEN sMamaExposure.progid = progid
                           smstime = asp_parse_smstime( line )
                           IF smstime NE '' THEN sMamaExposure.smstime = smstime

                           line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''
                        
                    ; this seems to be the only indication of a dark
                    ; ie. that a blocking filter is in place
                        fpos = STRPOS( sMamaExposure.filter, 'BLOCK' )
                        IF fpos NE -1 THEN sMamaExposure.target_type = 'DARK' $
                        ELSE IF sMamaExposure.door EQ 'RETRACT' THEN $
                         sMamaExposure.target_type = 'EXTERNAL' $
                        ELSE sMamaExposure.target_type = sMamaExposure.int_target
                        sMamaExposure.data_size = $
                         asp_pix2bytes(sbc_xsize*sbc_ysize, /DATA)

                        IF N_ELEMENTS( aMamaExposures ) LE 0 THEN $
                         aMamaExposures = [sMamaExposure] $
                        ELSE aMamaExposures = [aMamaExposures,sMamaExposure]

                     END

                     'JMIE2RAM': BEGIN

                        REPEAT BEGIN
                           value = asp_parse_inparen( line, 'OBSET' )
                           IF value NE '' THEN sMIE.obset = value
                           value = asp_parse_inparen( line, 'OBSID' )
                           IF value NE '' THEN sMIE.obsid = value
                           value = asp_parse_inparen( line, 'PROGID' )
                           IF value NE '' THEN sMIE.progid = value
                           value = asp_parse_smstime( line )
                           IF value NE '' THEN sMIE.smstime = value
                           
                           line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                        IF N_ELEMENTS( aMIEs ) LE 0 THEN $
                         aMIEs = [sMIE] $
                        ELSE aMIEs = [aMIEs,sMIE]

                     END

                     'JCCDPROT': BEGIN

                        smstime = ''
                        recon = ''
                        REPEAT BEGIN
                           
                           value = asp_parse_inparen( line, 'STATE' )
                           IF value EQ 'PROT' THEN $
                            recon = 'CCD Oper To Standby' $
                           ELSE IF value EQ 'NOPROT' THEN $
                            recon = 'CCD Standby To Oper' $
                           ELSE recon = ''
                           
                           value = asp_parse_smstime( line )
                           IF value NE '' THEN smstime = value

                           line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )

                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                           
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                        IF recon NE '' THEN BEGIN
                           sRecon.smstime = smstime
                           sRecon.mode = recon
                        ENDIF 

                        IF N_ELEMENTS( aRecons ) LE 0 THEN aRecons = [sRecon] $
                        ELSE aRecons = [aRecons,sRecon]
                        
                     END 

                     ELSE: line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                  ENDCASE 
               END

               (a EQ ':GROU'): BEGIN

                  junk = GETTOK( line, ',' )
                  
                  group_key = GETTOK( line, ',' )
                  IF ( verbose GE 2 ) THEN PRINTF, -2, "processing: "+strtrim(a,2)+$
                   ' '+group_key+' @ line '+strtrim(rec_i,2)
                  
                  CASE group_key OF 
                     
                     'PJIFUP': BEGIN
                        recon = 'WFC/HRC Oper to WFC/HRC Obs or WFC/MA LVon'
                        sRecon.mode = recon
                        REPEAT BEGIN

                           value = asp_parse_smstime( line )
                           IF value NE '' THEN sRecon.smstime = value

                           line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )

                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                           
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                        IF N_ELEMENTS( aRecons ) LE 0 THEN aRecons = [sRecon] $
                        ELSE aRecons = [aRecons,sRecon]
                        
                     END

                     'PJIFDOWN': BEGIN
                        recon='WFC/HRC Obs or WFC/MA LVon to WFC/HRC Oper'
                        sRecon.mode = recon
                        REPEAT BEGIN

                           value = asp_parse_smstime( line )
                           IF value NE '' THEN sRecon.smstime = value

                           line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )

                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                           
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                        IF N_ELEMENTS( aRecons ) LE 0 THEN aRecons = [sRecon] $
                        ELSE aRecons = [aRecons,sRecon]
                     END 

                     ELSE: line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                  ENDCASE 

               END

               (a EQ ':RTSC'): BEGIN

                  do_macro = 0
                  macro_name = ''
                  smstime = ''
                  REPEAT BEGIN
                     
                     value = asp_parse_inparen( line, 'FUNC' )
                     IF value EQ 'ACT' THEN do_macro = 1

                     value = asp_parse_inparen( line, 'RTSID' )
                     IF value NE '' THEN macro_name = value
                     
                     value = asp_parse_smstime( line )
                     IF value NE '' THEN smstime = value

                     line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )

                    ; extract 10 characters starting at the 1st position
                     id = STRMID( line, 1, 10 )
                     
                  ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''
                  
                  IF N_ELEMENTS( aRecon_macros ) GT 0 THEN BEGIN
                     IF do_macro EQ 1 THEN BEGIN
                        names = aRecon_macros.name
                        wmac = WHERE( macro_name EQ names, mcount )
                        IF mcount GT 0 THEN BEGIN
                           sRecon.mode = aRecon_macros(wmac(0)).mode
                           sRecon.smstime = smstime
                           
                           IF N_ELEMENTS( aRecons ) LE 0 THEN aRecons = [sRecon] $
                           ELSE aRecons = [aRecons,sRecon]

                        ENDIF 
                     ENDIF 
                  ENDIF 
               END 

               (a EQ ':RTS,'): BEGIN

                  junk = GETTOK( line, ',' )
                  
                  rts_key = GETTOK( line, ',' )

                  IF ( verbose GE 2 ) THEN PRINTF, -2, "processing: " + STRTRIM( a, 2 )+$
                   ' '+rts_key+' @ line ' + STRTRIM( rec_i, 2 )
                  
                  CASE rts_key OF 

                     'PJHLDBOO': BEGIN 
                        recon = 'Hold To Boot'
                        mebid = ''
                        sRecon.mode = recon
                        REPEAT BEGIN
                           value = asp_parse_inparen( line, 'SIDE' )
                           IF value NE '' THEN mebid = value

                           value = asp_parse_smstime( line )
                           IF value NE '' THEN sRecon.smstime = value

                           line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''
                        IF mebid NE '' THEN sHeader.mebid = FIX(mebid)

                        IF N_ELEMENTS( aRecons ) LE 0 THEN aRecons = [sRecon] $
                        ELSE aRecons = [aRecons,sRecon]
                     END 
                     
                     'PJCEBON1': BEGIN ; is this a unique recon identifier
                        recon = 'Boot to WFC/HRC Oper'
                        sRecon.mode = recon
                        REPEAT BEGIN
                           value = asp_parse_smstime( line )
                           IF value NE '' THEN sRecon.smstime = value
                           line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                        IF N_ELEMENTS( aRecons ) LE 0 THEN aRecons = [sRecon] $
                        ELSE aRecons = [aRecons,sRecon]
                     END 

                     'PJCEBON2': BEGIN ; is this a unique recon identifier
                        recon = 'Boot to WFC/HRC Oper'
                        sRecon.mode = recon
                        REPEAT BEGIN
                           value = asp_parse_smstime( line )
                           IF value NE '' THEN sRecon.smstime = value
                           line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                        IF N_ELEMENTS( aRecons ) LE 0 THEN aRecons = [sRecon] $
                        ELSE aRecons = [aRecons,sRecon]
                     END 

                     ELSE: BEGIN
                    ; This may be a macro of some kind
                        macro_name = rts_key

                        line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )

                        REPEAT BEGIN 

                    ; extract 5 characters starting at the 11th position
                           macro_key = STRMID( line, 11, 5 )
                           IF (verbose GE 4) THEN PRINTF, -2, '   macro: '+macro_key
                           CASE macro_key OF 

                              'TABLE': BEGIN 

                                 line2 = line
                                 junk = GETTOK( line2, ',' )
                                 tbl_key = GETTOK( line2, ',' )
                                 IF (verbose GE 4) THEN PRINTF, -2, '      table:'+tbl_key

                                 CASE tbl_key OF
                                    'JMAHVOFF': BEGIN
                                       recon = 'WFC/MA HVon to WFC/MA LVon'
                                       sRecon_macro.mode = recon
                                       sRecon_macro.name = macro_name
                                       IF N_ELEMENTS( aRecon_macros ) LE 0 THEN $
                                        aRecon_macros = [sRecon_macro] $
                                       ELSE aRecon_macros = [aRecon_macros,sRecon_macro]
                                    END
                                    'JMAHVON': BEGIN
                                       recon = 'WFC/MA LVon to WFC/MA HVon'
                                       sRecon_macro.mode = recon
                                       sRecon_macro.name = macro_name
                                       IF N_ELEMENTS( aRecon_macros ) LE 0 THEN $
                                        aRecon_macros = [sRecon_macro] $
                                       ELSE aRecon_macros = [aRecon_macros,sRecon_macro]
                                    END 
                                    
                                    ELSE:
                                 ENDCASE
                              END 

                              'INCLU': BEGIN
                                 line2 = line
                                 junk = GETTOK( line2, ',' )
                                 incl_key = GETTOK( line2, ',' )
                                 IF (verbose GE 4) THEN PRINTF, -2, '      include:'+incl_key                           
                                 CASE incl_key OF
;                              'PJMAOFF': BEGIN 
;                                 recon = 'WFC/MA LVon to WFC/HRC Oper'
;                                 sRecon_macro.mode = recon
;                                 sRecon_macro.name = macro_name
;                                 IF N_ELEMENTS( aRecon_macros ) LE 0 THEN $
;                                  aRecon_macros = [sRecon_macro] $
;                                 ELSE aRecon_macros = [aRecon_macros,sRecon_macro]
;                              END 

                                    'PJMAON': BEGIN 
                                       recon = 'WFC/HRC Oper to WFC/MA LVon'
                                       sRecon_macro.mode = recon
                                       sRecon_macro.name = macro_name
                                       IF N_ELEMENTS( aRecon_macros ) LE 0 THEN $
                                        aRecon_macros = [sRecon_macro] $
                                       ELSE aRecon_macros = [aRecon_macros,sRecon_macro]
                                       value = asp_parse_inparen( line, 'SIDE' )
                                       IF value NE '' THEN sHeader.mebid = FIX(value)
                                    END
                                    ELSE:
                                 ENDCASE

                              END 

                              ELSE: 

                           ENDCASE

                           line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )

                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                     END
                  ENDCASE

               END

               (a EQ ':TAPE'): BEGIN
                  
                  value = asp_parse_inparen( line, 'INST_ID' )
                  IF value EQ 'ACS' THEN BEGIN
                     sDump.availability = 'TAPE RECORDER'
                     REPEAT BEGIN
                        value = asp_parse_inparen( line, 'OBS_SET' )
                        IF value NE '' THEN sDump.obset = value
                        value = asp_parse_inparen( line, 'OBS_ID' )
                        IF value NE '' THEN sDump.obsid = value
                        value = asp_parse_inparen( line, 'PROG_ID' )
                        IF value NE '' THEN sDump.progid = value
                        value = asp_parse_inparen( line, 'RATE' )
                        IF value NE '' THEN sDump.rate = value
                        
                        line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                    ; extract 10 characters starting at the 1st position
                        id = STRMID( line, 1, 10 )
                        
                     ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''
                     
                  ENDIF ;;ELSE rec_i = rec_i + 1
               END 

               (a EQ ':COMC'): BEGIN
                  
                  value = asp_parse_inparen( line, 'INST_ID' )
                  IF value EQ 'ACS' THEN BEGIN
                     sDump.availability = 'REAL TIME'
                     REPEAT BEGIN
                        value = asp_parse_inparen( line, 'OBSET' )
                        IF value NE '' THEN sDump.obset = value
                        value = asp_parse_inparen( line, 'OBSID' )
                        IF value NE '' THEN sDump.obsid = value
                        value = asp_parse_inparen( line, 'PROGID' )
                        IF value NE '' THEN sDump.progid = value
                        value = asp_parse_inparen( line, 'RATE' )
                        IF value NE '' THEN sDump.rate = value
                        value = asp_parse_inparen( line, 'SERVICE' )
                        IF value NE '' THEN sDump.service = value
                        value = asp_parse_inparen( line, 'TAPE_OPT' )
                        IF value NE '' THEN sDump.tapeopt = value
                        
                        line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                    ; extract 10 characters starting at the 1st position
                        id = STRMID( line, 1, 10 )
                        
                     ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''
                     
                  ENDIF ELSE line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )

               END 

               (a EQ ':SLEW'): BEGIN
                  IF ( verbose GE 2 ) THEN PRINTF, -2, "processing: "+strtrim(a,2)

                  REPEAT BEGIN 
                     value = asp_parse_inparen( line, 'APER_EID' )
                     IF value NE '' THEN sSlew.aper_eid = value
                     value = asp_parse_inparen( line, 'APER_SID' )
                     IF value NE '' THEN sSlew.aper_sid = value
                     value = asp_parse_inparen( line, 'STRT_DEC' )
                     IF value NE '' THEN sSlew.strt_dec = value
                     value = asp_parse_inparen( line, 'STRT_PA' )
                     IF value NE '' THEN sSlew.strt_pa = value
                     value = asp_parse_inparen( line, 'STRT_RA' )
                     IF value NE '' THEN sSlew.strt_ra = value
                     value = asp_parse_inparen( line, 'END_DEC' )
                     IF value NE '' THEN sSlew.end_dec = value
                     value = asp_parse_inparen( line, 'END_PA' )
                     IF value NE '' THEN sSlew.end_pa = value
                     value = asp_parse_inparen( line, 'END_RA' )
                     IF value NE '' THEN sSlew.end_ra = value
                     value = asp_parse_inparen( line, 'OFF_ERA' )
                     IF value NE '' THEN sSlew.off_era = value
                     value = asp_parse_inparen( line, 'OFF_EDE' )
                     IF value NE '' THEN sSlew.off_ede = value
                     value = asp_parse_inparen( line, 'TYPE' )
                     IF value NE '' THEN sSlew.type = value
                     value = asp_parse_inparen( line, 'CPNAME' )
                     IF value NE '' THEN sSlew.cpname = value
                     value = asp_parse_smstime( line )
                     IF value NE '' THEN sSlew.smstime = value
                     
                     line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                    ; extract 10 characters starting at the 1st position
                     id = STRMID( line, 1, 10 )

                  ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                  IF N_ELEMENTS( aSlews ) LE 0 THEN aSlews = [sSlew] $
                  ELSE aSlews = [aSlews,sSlew]
                  
               END

               (a EQ ':GSAC'): BEGIN
                  IF ( verbose GE 2 ) THEN PRINTF, -2, "processing: "+strtrim(a,2)

               END

               (a EQ ':SMSH'): BEGIN
                  sms_id = ''
                  calendar = ''
                  created = ''
                  db_id = ''
                  REPEAT BEGIN
                     value = asp_parse_inparen( line, 'SMS_ID' )
                     IF value NE '' THEN sms_id = value
                     
                     value = asp_parse_inparen( line, 'CALENDAR' )
                     IF value NE '' THEN calendar = value
                     
                     value = asp_parse_inparen( line, 'CREATED' )
                     IF value NE '' THEN created = value
                     
                     value = asp_parse_inparen( line, 'PDB_ID' )
                     IF value NE '' THEN db_id = value

                     line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )
                    ; extract 10 characters starting at the 1st position
                     id = STRMID( line, 1, 10 )
                  ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''
                  IF sms_id NE '' THEN sHeader.sms_id = STRTRIM(sms_id,2)
                  IF calendar NE '' THEN BEGIN
                     sHeader.calendar = asp_parse_calendar(STRTRIM(calendar,2))
                  ENDIF 
                  IF created NE '' THEN sHeader.created = STRTRIM(created,2)
                  IF db_id NE '' THEN sHeader.db_id = STRTRIM(db_id,2)
               END
               
               ELSE: line = asp_get_new_line( rec_i, LUN=sms_lun, REC=rec )

            ENDCASE 

         ENDWHILE 

         IF (verbose GT 2) THEN HELP, aCCDExposures, aMamaExposures, aDumps, $
          aLamps, aSlews, aCorrectors, aDoors, aFolds
         
         IF N_ELEMENTS(aCCDExposures) GT 0 OR $
          N_ELEMENTS(aMamaExposures) GT 0 OR $
          N_ELEMENTS(aDumps) OR $
          N_ELEMENTS(aLamps) OR $
          N_ELEMENTS(aSlews) OR $
          N_ELEMENTS(aCorrectors) OR $
          N_ELEMENTS(aDoors) OR $
          N_ELEMENTS(aFolds) THEN BEGIN
            aActs = asp_make_acts( CCD=aCCDExposures, MAMA=aMamaExposures, $
                                   LAMP=aLamps, CORR=aCorrectors, $
                                   DUMP=aDumps, RECON=aRecons, SLEW=aSlews, $
                                   FOLD=aFolds, DOOR=aDoors, MIE=aMIEs )
         ENDIF

         n_ccds = N_ELEMENTS(aCCDExposures)
         IF n_ccds GT 0 THEN BEGIN
            first_ccd = asp_parse_time(aCCDexposures[0].smstime)
         ENDIF 
         n_mamas = N_ELEMENTS(aMamaExposures)
         IF n_mamas GT 0 THEN BEGIN
            first_sbc = asp_parse_time(aMamaExposures[0].smstime)
         ENDIF
         n_acts = N_ELEMENTS(aActs)
         IF n_ccds GT 0 AND n_mamas GT 0 THEN BEGIN
            first_time = first_ccd < first_sbc
         ENDIF ELSE IF n_ccds GT 0 AND n_mamas LE 0 THEN BEGIN
            first_time = first_ccd
         ENDIF ELSE IF n_mamas GT 0 AND n_ccds LE 0 THEN BEGIN
            first_time = first_sbc
         ENDIF ELSE IF n_acts GT 0 THEN BEGIN
            first_time = asp_parse_time(aActs[0].smstime)
         ENDIF ELSE first_time = 0
         
         IF n_acts GT 0 THEN BEGIN
            act_times = asp_parse_time(aActs.smstime)
            last_time = MAX(act_times)
            first_time = MIN(act_times)
         ENDIF ELSE last_time = first_time

         IF verbose GT 2 THEN PRINT, 'Time diff: ', last_time-first_time
         page_header = asp_make_page_header(sms_file, CCD=aCCDExposures, $
                                            MAMA=aMamaExposures, $
                                            HEADER=sHeader, $
                                            DURATION=last_time-first_time )
         IF do_rev EQ 1 THEN BEGIN 
            asp_write_rev, revfile, sms_file, CCD=aCCDExposures, $
             MAMA=aMamaExposures, SCREEN=to_screen, VERBOSE=verbose, $
             WIDE=wide, HEADER=page_header, OVER=over
         ENDIF

         IF do_act EQ 1 THEN BEGIN 
            asp_write_act, actfile, sms_file, OVER=over, ACTS=aActs, $
             SCREEN=to_screen, VERBOSE=verbose, HEADER=page_header
         ENDIF 

         IF N_ELEMENTS(sms_lun) GT 0 THEN FREE_LUN, sms_lun

                    ; Get rid of accumulated struct arrays
         IF N_ELEMENTS( aCCDExposures ) GT 0 THEN $
          junk = TEMPORARY( aCCDExposures )
         IF N_ELEMENTS( aMamaExposures ) GT 0 THEN $
          junk = TEMPORARY( aMamaExposures )
         IF N_ELEMENTS( aLamps ) GT 0 THEN $
          junk = TEMPORARY( aLamps )
         IF N_ELEMENTS( aMIEs ) GT 0 THEN $
          junk = TEMPORARY( aMIEs )
         IF N_ELEMENTS( aCorrectors ) GT 0 THEN $
          junk = TEMPORARY( aCorrectors )
         IF N_ELEMENTS( aDumps ) GT 0 THEN $
          junk = TEMPORARY( aDumps )
         IF N_ELEMENTS( aRecons ) GT 0 THEN $
          junk = TEMPORARY( aRecons )
         IF N_ELEMENTS( aDoors ) GT 0 THEN $
          junk = TEMPORARY( aDoors )
         IF N_ELEMENTS( aFolds ) GT 0 THEN $
          junk = TEMPORARY( aFolds )
         IF N_ELEMENTS( aSlews ) GT 0 THEN $
          junk = TEMPORARY( aSlews )
         junk = 0b
      ENDELSE 
   ENDFOR

   return
END

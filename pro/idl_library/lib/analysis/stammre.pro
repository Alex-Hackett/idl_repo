;+
; $Id: stammre.pro,v 1.15 2002/01/14 18:03:31 mccannwj Exp $
;
; NAME:
;     STAMMRE
;
; PURPOSE:
;     Stability And Mind-numbing Mechanical REpetability testing.
;
; CATEGORY:
;     JHU/ACS
;
; CALLING SEQUENCE:
;     STAMMRE [, /WRITE ]
; 
; INPUTS:
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
;     uses ASTROLIB, TIMEZONE()
;
; PROCEDURE:
;     Environment variables may be used to override default behavior.
;
;     [variable]                         [default]
;     STMR_LP_COMMAND                    lp %s
;     STMR_UPDATE_LP_COMMAND             none
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;       Tue May 25 10:39:01 1999, William Jon McCann
;       <mccannwj@acs13.+hst.nasa.gov>
;
;		written.
;
;-

; _____________________________________________________________________________

PRO stmr_free_data_pointers, sState
   PTR_FREE, sState.pEntries, $
    sState.pTimes,sState.pXcoords,sState.pYcoords
END 

PRO stmr_free_event_pointers, sState
   PTR_FREE, sState.pTimeList,sState.pEventList
END 
; _____________________________________________________________________________

PRO stmr_free_pointers, sState
   stmr_free_event_pointers, sState
   stmr_free_data_pointers, sState
END 

PRO stmr_zero_pointers, sState
   sState.pEntries = PTR_NEW()
   sState.pTimes = PTR_NEW()
   sState.pXcoords = PTR_NEW()
   sState.pYcoords = PTR_NEW()
   sState.pEventList = PTR_NEW()
   sState.pTimeList = PTR_NEW()
END 
; _____________________________________________________________________________

FUNCTION stmr_has_state_data, sState
   valid = PTR_VALID(sState.pEntries) AND $
    PTR_VALID(sState.pTimes) AND $
    PTR_VALID(sState.pXcoords) AND $
    PTR_VALID(sState.pYcoords)
   return, valid
END 
; _____________________________________________________________________________

FUNCTION stmr_get_state_entries, sState
   return, *sState.pEntries
END 
; _____________________________________________________________________________

FUNCTION stmr_get_state_times, sState
   return, *sState.pTimes
END 
; _____________________________________________________________________________

FUNCTION stmr_get_state_xcoords, sState
   return, *sState.pXcoords
END 

FUNCTION stmr_get_state_ycoords, sState
   return, *sState.pYcoords
END 
; _____________________________________________________________________________

PRO stmr_set_state_entries, sState, value, NO_COPY=no_copy
   PTR_FREE, sState.pEntries
   sState.pEntries = PTR_NEW(value,NO_COPY=no_copy)
END 
; _____________________________________________________________________________

PRO stmr_set_state_times, sState, value, NO_COPY=no_copy
   PTR_FREE, sState.pTimes
   sState.pTimes = PTR_NEW(value,NO_COPY=no_copy)
END 
; _____________________________________________________________________________

PRO stmr_set_state_xcoords, sState, value, NO_COPY=no_copy
   PTR_FREE, sState.pXcoords
   sState.pXcoords = PTR_NEW(value,NO_COPY=no_copy)
END 
; _____________________________________________________________________________

PRO stmr_set_state_ycoords, sState, value, NO_COPY=no_copy
   PTR_FREE, sState.pYcoords
   sState.pYcoords = PTR_NEW(value,NO_COPY=no_copy)
END 

; _____________________________________________________________________________

FUNCTION stmr_get_detector_of_entries, entries, ERROR=error_code

   error_code = 0b
   unavailable=0b
   DBOPEN, 'acs_log', UNAVAIL=unavailable
   IF unavailable[0] EQ 0 THEN $
    DBEXT, entries, 'DETECTOR', detector $
   ELSE BEGIN
      error_code = 1b
      detector = 'HRC'
   ENDELSE 
   return, detector
END
; _____________________________________________________________________________

FUNCTION stmr_get_time_of_entries, entries, ERROR=error_code

   error_code = 0b
   unavailable=0b
   DBOPEN, 'acs_log', UNAVAIL=unavailable
   IF unavailable[0] EQ 0 THEN $
    DBEXT, entries, 'EXPSTART', times $
   ELSE BEGIN
      error_code = 1b
      times = entries * 0.0d
   ENDELSE 
   return, times
END
; _____________________________________________________________________________

FUNCTION stmr_get_event_filename, first_id
   IF N_ELEMENTS(first_id) LE 0 THEN first_id = '00000'
   strFilename = 'stability_test_' + STRTRIM(first_id[0], 2) + $
    '.events'
   return, strFilename
END

; _____________________________________________________________________________

FUNCTION stmr_get_config_filename, first_id
   IF N_ELEMENTS(first_id) LE 0 THEN first_id = '00000'
   strFilename = 'stability_test_' + STRTRIM(first_id[0], 2) + $
    '.config'
   return, strFilename
END
; _____________________________________________________________________________

FUNCTION stmr_get_latest_entry, ERROR=error_code
   error_code = 0b
   unavailable=0b
   DBOPEN, 'acs_log', UNAVAIL=unavailable
   IF unavailable[0] EQ 1 THEN BEGIN
      error_code = 1b
      latest_entry = -1
   ENDIF ELSE BEGIN
      latest_entry = DB_INFO('entries')
      latest_entry = LONG(latest_entry[0])
   ENDELSE
   return, latest_entry
END 
; _____________________________________________________________________________

FUNCTION stmr_get_detector_of_entries, entries, ERROR=error_code

   error_code = 0b
   unavailable=0b
   DBOPEN, 'acs_log', UNAVAIL=unavailable
   IF unavailable[0] EQ 0 THEN $
    DBEXT, entries, 'DETECTOR', detector $
   ELSE BEGIN
      error_code = 1b
      detector = 'HRC'
   ENDELSE 
   return, detector
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

FUNCTION stmr_get_update_lp_command, strPSfile, detector
   env_command = GETENV('STMR_UPDATE_LP_COMMAND')
   default_command = 'echo'
   template = (env_command[0] EQ '') ? default_command : env_command[0]
   map = {s:strPSfile,d:detector}
   strCmd = fill_template_string(template+' %s',map)
   return, strCmd
END 
; _____________________________________________________________________________

FUNCTION stmr_get_lp_command, strPSfile, detector
   env_command = GETENV('STMR_LP_COMMAND')
   default_command = 'lp %s'
   template = (env_command[0] EQ '') ? default_command : env_command[0]
   map = {s:strPSfile,d:detector}
   strCmd = fill_template_string(template+' %s',map)
   return, strCmd
END 
; _____________________________________________________________________________

FUNCTION stmr_get_first_id_from_filename, strFilename
   IF N_ELEMENTS(strFilename) LE 0 THEN return, 0

   regex = 'stability_test_([0-9]+)\.[a-z]+$'
   subs = STREGEX(strFilename,regex,/FOLD_CASE,/EXTRACT,/SUBEXPR)
   first_id = (N_ELEMENTS(subs) GT 1) ? LONG(subs[1]) : 0

   return, first_id
END

; _____________________________________________________________________________

FUNCTION stmr_get_ps_filename, first_id
   IF N_ELEMENTS(first_id) LE 0 THEN first_id = '00000'
   strFilename = 'stability_test_' + STRTRIM(first_id[0], 2) + $
    '.ps'
   return, strFilename
END
; _____________________________________________________________________________

FUNCTION stmr_get_log_filename, first_id
   IF N_ELEMENTS(first_id) LE 0 THEN first_id = '00000'
   strFilename = 'stability_test_' + STRTRIM(first_id[0], 2) + $
    '.dat'
   return, strFilename
END
; _____________________________________________________________________________

FUNCTION stmr_get_log_file_size, first_entry
   
   strFilename = stmr_get_log_filename(first_entry[0])
   OPENR, lun, strFilename, ERROR=error_flag, /GET_LUN
   size = 0l
   IF error_flag[0] EQ 0 THEN BEGIN
      stat = FSTAT(lun)
      size = stat.size
      FREE_LUN, lun
   ENDIF
   
   return, size
END 
; _____________________________________________________________________________

FUNCTION parse_time_stamp, time_stamp, UTC=utc, MJD=mjd

   IF N_ELEMENTS( time_stamp ) LE 0 THEN BEGIN
      MESSAGE, 'time stamp not specified', /CONTINUE
      return, -1
   ENDIF 

   tokens = STR_SEP( time_stamp, ':', /TRIM )

   CASE N_ELEMENTS( tokens ) OF
      5: BEGIN
         year = DOUBLE( STRMID( tokens[0], 0, 4 ) )
         day_of_year = DOUBLE( STRMID( tokens[1], 0, 3 ) )
         hour = DOUBLE( STRMID( tokens[2], 0, 2 ) )
         minute = DOUBLE( STRMID( tokens[3], 0, 2 ) )
         second = DOUBLE( STRMID( tokens[4], 0, 2 ) )
      END
      4: BEGIN
         year = DOUBLE( STRMID( tokens[0], 0, 4 ) )
         day_of_year = DOUBLE( STRMID( tokens[1], 0, 3 ) )
         hour = DOUBLE( STRMID( tokens[2], 0, 2 ) )
         minute = DOUBLE( STRMID( tokens[3], 0, 2 ) )
         second = 0d
      END
      3: BEGIN
         year = DOUBLE( STRMID( tokens[0], 0, 4 ) )
         day_of_year = DOUBLE( STRMID( tokens[1], 0, 3 ) )
         hour = DOUBLE( STRMID( tokens[2], 0, 2 ) )
         minute = 0d
         second = 0d
      END
      2: BEGIN
         year = DOUBLE( STRMID( tokens[0], 0, 4 ) )
         day_of_year = DOUBLE( STRMID( tokens[1], 0, 3 ) )
         hour = 0d
         minute = 0d
         second = 0d
      END
      1: BEGIN
         year = DOUBLE( STRMID( tokens[0], 0, 4 ) )
         day_of_year = 1d
         hour = 0d
         minute = 0d
         second = 0d
      END
      ELSE: BEGIN
         bindate = DOUBLE( BIN_DATE( SYSTIME() ) )
         year    = bindate[0]
         month   = bindate[1]
         day     = bindate[2]
         hour   = tokens[0]
         minute = tokens[1]
         second = tokens[2]
      END
   ENDCASE

   IF N_ELEMENTS( day ) LE 0 THEN BEGIN
      monthdays = [0,31,59,90,120,151,181,212,243,273,304,334,366]
      
      leap_year = DOUBLE( (((year MOD 4) EQ 0) AND ((year MOD 100) NE 0)) $
                          OR ((year MOD 400) EQ 0) AND (day_of_year GE 90) )
      
      month = DOUBLE( MIN( WHERE( monthdays GE (day_of_year - leap_year))))
      
      day = DOUBLE( day_of_year - monthdays[month-1] - leap_year )
   ENDIF

   julian_date = JULDAY( month, day, year, hour, minute, second )

   IF KEYWORD_SET( mjd ) THEN BEGIN
      mjd = DOUBLE(julian_date) - DOUBLE(2.4e6) - 0.5d
      return, mjd
   ENDIF

   return, julian_date
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
   ENDIF ELSE julian_date = DOUBLE( SYSTIME(/JULIAN) )

   IF KEYWORD_SET( utc ) THEN julian_date = julian_date - (time_zone / 24d)

   CALDAT, DOUBLE(julian_date), month, day, year, hour, minute, second

;   DAYCNV, julian_date, year, month, day, fHour
;   hour = FIX( fHour )
;   fDate = (fHour - hour) * 60.0
;   minute = FIX( fDate )
;   second = FLOAT( (fDate - minute ) * 60.0 )

   ;;HELP, month, day, year, hour, minute, second

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

PRO x_get_event_event, sEvent

   wStateHandler = WIDGET_INFO( sEvent.handler, /CHILD )
   WIDGET_CONTROL, wStateHandler, GET_UVALUE=sState, /NO_COPY 

   WIDGET_CONTROL, sEvent.id, GET_UVALUE=event_uval

   CASE STRUPCASE( event_uval ) OF

      'EVENT_FIELD': BEGIN

      END 

      'BUTTON_PRESS': BEGIN
         CASE STRUPCASE( sEvent.value ) OF

            'OK_BUTTON': BEGIN
               WIDGET_CONTROL, sState.wEventField, GET_VALUE=event_value
               WIDGET_CONTROL, sState.wTimeField, GET_VALUE=time_value
               status = 1b
               WIDGET_CONTROL, /DESTROY, sEvent.top
            END 

            'CANCEL_BUTTON': BEGIN
               value = ''
               status = 0b
               WIDGET_CONTROL, /DESTROY, sEvent.top
            END 

            'RESET_BUTTON': BEGIN
               value = sState.original_value
               WIDGET_CONTROL, sState.wEventField, SET_VALUE=value
            END

            'NOW_BUTTON': BEGIN
               
               value = get_time_stamp( /UTC )
               WIDGET_CONTROL, sState.wTimeField, SET_VALUE=value
            END

            ELSE: BEGIN
               value = ''
               status = 0b
               WIDGET_CONTROL, /DESTROY, sEvent.top
            END 
         END
      END

      ELSE: BEGIN
      END

   ENDCASE 

   IF N_ELEMENTS( status ) LE 0 THEN status = 1b
   IF N_ELEMENTS( event_value ) LE 0 THEN event_value = ''
   IF N_ELEMENTS( time_value ) LE 0 THEN time_value = ''

   sReturn = { value: event_value, time: time_value, status: status }

   IF WIDGET_INFO( sState.wInfo, /VALID_ID ) EQ 1 THEN $
    WIDGET_CONTROL, sState.wInfo, SET_UVALUE=sReturn
   
   IF WIDGET_INFO( wStateHandler, /VALID_ID ) EQ 1 THEN BEGIN
      ;;WIDGET_CONTROL, sState.wRoot, /CLEAR_EVENTS
                    ; restore state information
      WIDGET_CONTROL, wStateHandler, SET_UVALUE=sState, /NO_COPY
   ENDIF 

   return
END

; _____________________________________________________________________________


FUNCTION x_get_event, parent, TITLE=title, $
                      STATUS=exit_status, VALUE=event_value, $
                      TIME_VALUE=time_value, $
                      GROUP_LEADER=group, DEBUG=debug, $
                      STRUCTURE=structure

   instance_number = XREGISTERED( 'x_get_event' )
   IF KEYWORD_SET(debug) THEN HELP, instance_number
   IF instance_number GT 0 THEN BEGIN
      exit_status = 0b
      return, -1
   ENDIF
   
   IF N_ELEMENTS( event_value ) LE 0 THEN event_value = ''
   IF N_ELEMENTS( time_value ) LE 0 THEN time_value = get_time_stamp(/UTC)
   
   IF N_ELEMENTS( title ) LE 0 THEN title = 'X_GET_EVENT'

   IF KEYWORD_SET(debug) THEN HELP, parent
   IF N_ELEMENTS( parent ) GT 0 THEN BEGIN
      wRoot = WIDGET_BASE( parent, /COLUMN, /MODAL, TITLE=title, GROUP=group )
      parent_id = parent
   ENDIF ELSE BEGIN
      wRoot = WIDGET_BASE( /COLUMN, /MODAL, TITLE=title, GROUP=group )
      parent_id = -1L
   ENDELSE

   wBase = WIDGET_BASE( wRoot, /COLUMN )

   wReturnInfo = WIDGET_BASE( UVALUE='JUNK' )

   strTimeLabel = 'Time (UTC):'
   wTimeField = CW_FIELD( wBase, $
                          /STRING, /FRAME, UVALUE='TIME_FIELD', $
                          /RETURN_EVENTS, TITLE = strTimeLabel, $
                          VALUE=time_value )
   
   strEventLabel = 'Event:'
   wEventField = CW_FIELD( wBase, $
                           /STRING, /FRAME, UVALUE='EVENT_FIELD', $
                           /RETURN_EVENTS, TITLE = strEventLabel, $
                           VALUE=event_value, XSIZE=40 )

   aButtons = ['OK','Cancel', 'Reset', 'Now' ]
   aButtonUvals = ['OK_BUTTON', 'CANCEL_BUTTON', 'RESET_BUTTON', 'NOW_BUTTON' ]
   wButtons = CW_BGROUP( wBase, aButtons, $
                         BUTTON_UVALUE=aButtonUvals, $
                         /ROW, /NO_RELEASE, UVALUE='BUTTON_PRESS' )

   WIDGET_CONTROL, /REALIZE, wRoot

   sState = { wRoot: wRoot, $
              wBase: wBase, $
              wInfo: wReturnInfo, $
              wTimeField: wTimeField, $
              wEventField: wEventField, $
              wButtons: wButtons, $
              wParent: parent_id, $
              original_time: time_value, $
              original_value: event_value }

   WIDGET_CONTROL, wBase, SET_UVALUE=sState, /NO_COPY
   
   XMANAGER, 'x_get_event', wRoot

   WIDGET_CONTROL, wReturnInfo, GET_UVALUE=sReturn
   WIDGET_CONTROL, /DESTROY, wReturnInfo

   IF N_TAGS( sReturn ) GT 1 THEN BEGIN
      IF KEYWORD_SET( structure ) THEN value = sReturn $
      ELSE value = sReturn.value
      exit_status = sReturn.status
   ENDIF ELSE BEGIN
      value = ''
      exit_status = 0b
   ENDELSE 

   return, value
END 

; _____________________________________________________________________________

PRO stmr_update_state_from_logfile, sState, strFilename, ERROR=error_code

   error_code = 0b
   stmr_wmessage, sState, 'reading log file...'
   stmr_read_log_file, strFilename, aEntries, aTimes, x, y,  ERROR=error_code
   stmr_wmessage, sState, 'setting state...'
   IF error_code[0] EQ 0 THEN BEGIN
      stmr_set_state_entries, sState, aEntries, /NO_COPY
      stmr_set_state_times, sState, aTimes, /NO_COPY
      stmr_set_state_xcoords, sState, x, /NO_COPY
      stmr_set_state_ycoords, sState, y, /NO_COPY
   ENDIF ELSE BEGIN
      stmr_free_data_pointers, sState
   ENDELSE 
END 

; _____________________________________________________________________________

PRO stmr_update_event_display, sState
   
   IF PTR_VALID( sState.pEventList ) THEN BEGIN

      aEventList = *sState.pEventList
      aTimeList = *sState.pTimeList

      sort_index = SORT( aTimeList )
      aTimeList = aTimeList[sort_index]
      aEventList = aEventList[sort_index]

      PTR_FREE, sState.pEventList, sState.pTimeList
      sState.pEventList = PTR_NEW( aEventList )
      sState.pTimeList = PTR_NEW( aTimeList )

      n_events = N_ELEMENTS( aEventList )
      aList = MAKE_ARRAY( n_events, /STRING )
      FOR i=0L, n_events-1 DO BEGIN
         event = aEventList[i]
         time  = aTimeList[i]
         strEvent = STRING( FORMAT='(A17,2X,A0)', time, event )
         aList[i] = strEvent
      ENDFOR 
      WIDGET_CONTROL, sState.wEventList, SET_VALUE=aList
   ENDIF ELSE BEGIN
      strEvent = STRING( FORMAT='(A17,2X,A0)', '', '' )
      aList = [strEvent]
      WIDGET_CONTROL, sState.wEventList, SET_VALUE=aList      
   ENDELSE

   return
END 

; _____________________________________________________________________________

PRO stmr_new_session, sState, template_id

   latest_entry = stmr_get_latest_entry(ERROR=error_code)
   IF error_code[0] NE 0 THEN BEGIN
      stmr_wmessage, sState, 'Database is unavailable.'
      return
   ENDIF 
   default_config = 'Square/dolly'
   
   IF N_ELEMENTS(template_id) GT 0 THEN $
    default_template_id = template_id $
   ELSE default_template_id = latest_entry

   default_first_id = default_template_id
   default_last_id = -1
   default_centerx = 527
   default_centery = 455
   default_width = 20
   default_search_width = 11
   default_swath_width = 5
   default_template_width = 3
   default_fit_type = 0

   stmr_free_pointers, sState
   stmr_zero_pointers, sState
   stmr_update_event_display, sState

   sState.session_has_data = 0b
   sState.data_file_size = 0l
   sState.data_interval = 0l

   WIDGET_CONTROL, sState.wConfigField, SET_VALUE=default_config
   WIDGET_CONTROL, sState.wTemplateIdField, SET_VALUE=default_template_id
   WIDGET_CONTROL, sState.wFitTypeButton, SET_VALUE=default_fit_type
   WIDGET_CONTROL, sState.wFirstIdField, SET_VALUE=default_first_id
   WIDGET_CONTROL, sState.wLastIdField, SET_VALUE=default_last_id
   WIDGET_CONTROL, sState.wCenterXField, SET_VALUE=default_centerx
   WIDGET_CONTROL, sState.wCenterYField, SET_VALUE=default_centery
   WIDGET_CONTROL, sState.wWidthTemplateField, SET_VALUE=default_template_width
   WIDGET_CONTROL, sState.wWidthSearchField, SET_VALUE=default_search_width
   WIDGET_CONTROL, sState.wWidthSwathField, SET_VALUE=default_swath_width
   WIDGET_CONTROL, sState.wWidthField, SET_VALUE=default_width

   stmr_wmessage, sState, 'new session for entry '+STRTRIM(default_template_id,2)

   return
END 

; _____________________________________________________________________________

PRO stmr_update_widget_from_configfile, sState, strFilename

   aHeader = HEADFITS(strFilename[0])
   strConfig = SXPAR( aHeader, 'CONFIG' )
   iTemplateId = SXPAR( aHeader, 'TEMPLATE' )
   bFitType = SXPAR( aHeader, 'FITTYPE' )
   iFirstId = SXPAR( aHeader, 'FIRSTID' )
   iLastId = SXPAR( aHeader, 'LASTID' )
   iCenterX = SXPAR( aHeader, 'XCENTER' )
   iCenterY = SXPAR( aHeader, 'YCENTER' )
   iWidthTemplate = SXPAR( aHeader, 'WTEMPL' )
   iWidthSearch = SXPAR( aHeader, 'WSEARCH' )
   iWidthSwath = SXPAR( aHeader, 'WSWATH' )
   iWidth = SXPAR( aHeader, 'WIDTH' )

   WIDGET_CONTROL, sState.wTemplateIdField, SET_VALUE=iTemplateId
   WIDGET_CONTROL, sState.wConfigField, SET_VALUE=strConfig
   WIDGET_CONTROL, sState.wFitTypeButton, SET_VALUE=bFitType[0]
   WIDGET_CONTROL, sState.wFirstIdField, SET_VALUE=iFirstId
   WIDGET_CONTROL, sState.wLastIdField, SET_VALUE=iLastId
   WIDGET_CONTROL, sState.wCenterXField, SET_VALUE=iCenterX
   WIDGET_CONTROL, sState.wCenterYField, SET_VALUE=iCenterY
   WIDGET_CONTROL, sState.wWidthTemplateField, SET_VALUE=iWidthTemplate
   WIDGET_CONTROL, sState.wWidthSearchField, SET_VALUE=iWidthSearch
   WIDGET_CONTROL, sState.wWidthSwathField, SET_VALUE=iWidthSwath
   WIDGET_CONTROL, sState.wWidthField, SET_VALUE=iWidth
   
END

; _____________________________________________________________________________

PRO stmr_open_session, sState, template_id, ERROR=error_flag

   error_flag = 0b

   IF N_ELEMENTS(template_id) LE 0 THEN BEGIN
      strFilename = DIALOG_PICKFILE(/READ, /MUST_EXIST, GROUP=sState.wBase)
      IF strFilename[0] EQ '' THEN BEGIN
         error_flag = 1b
         return
      ENDIF
      template_id = stmr_get_first_id_from_filename(strFilename[0])
      strFilename = stmr_get_config_filename(template_id)
      file = FINDFILE(strFilename, COUNT=fcount)
      IF fcount LE 0 THEN BEGIN
         error_flag = 1b
         return
      ENDIF 
   ENDIF ELSE BEGIN
      strFilename = stmr_get_config_filename(template_id)
      file = FINDFILE(strFilename, COUNT=fcount)
      IF fcount LE 0 THEN BEGIN
         error_flag = 1b
         return
      ENDIF
   ENDELSE
   stmr_update_widget_from_configfile, sState, strFilename
   
                    ; Read the event file
   strFilename = stmr_get_event_filename(template_id)
   file = FINDFILE( strFilename, COUNT = fcount )

   IF fcount GT 0 THEN BEGIN
      stmr_read_event_file, strFilename, aTimeList, aEventList, ERROR=error
      IF error EQ 0 THEN BEGIN
         PTR_FREE, sState.pTimeList, sState.pEventList
         sState.pEventList = PTR_NEW( aEventList, /NO_COPY )
         sState.pTimeList = PTR_NEW( aTimeList, /NO_COPY )
      ENDIF ELSE BEGIN
         PTR_FREE, sState.pTimeList, sState.pEventList
         sState.pEventList = PTR_NEW()
         sState.pTimeList = PTR_NEW()
      ENDELSE
   ENDIF ELSE BEGIN
      PTR_FREE, sState.pTimeList, sState.pEventList
      sState.pEventList = PTR_NEW()
      sState.pTimeList = PTR_NEW()
   ENDELSE

   strFilename = stmr_get_log_filename(template_id)
   stmr_update_state_from_logfile, sState, strFilename, ERROR=error_code

   sState.session_has_data = (error[0] EQ 0) ? 1b : 0b

   stmr_update_event_display, sState
  
   log_size = stmr_get_log_file_size(template_id)
   sState.data_file_size = LONG(log_size)
   sState.data_interval = 0l
   yesno = (sState.session_has_data) ? '' : 'no '
   stmr_wmessage, sState, 'Session '+STRTRIM(template_id,2)+' has '+yesno+'data'
   return
END

; _____________________________________________________________________________

PRO stmr_save_session, sState

   WIDGET_CONTROL, sState.wTemplateIdField, GET_VALUE=iTemplateId
   WIDGET_CONTROL, sState.wConfigField, GET_VALUE=strConfig
   WIDGET_CONTROL, sState.wFitTypeButton, GET_VALUE=bFitType
   WIDGET_CONTROL, sState.wFirstIdField, GET_VALUE=iFirstId
   WIDGET_CONTROL, sState.wLastIdField, GET_VALUE=iLastId
   WIDGET_CONTROL, sState.wCenterXField, GET_VALUE=iCenterX
   WIDGET_CONTROL, sState.wCenterYField, GET_VALUE=iCenterY
   WIDGET_CONTROL, sState.wWidthTemplateField, GET_VALUE=iWidthTemplate
   WIDGET_CONTROL, sState.wWidthSearchField, GET_VALUE=iWidthSearch
   WIDGET_CONTROL, sState.wWidthSwathField, GET_VALUE=iWidthSwath
   WIDGET_CONTROL, sState.wWidthField, GET_VALUE=iWidth

                    ; Write config file
   MKHDR, aHeader, ''
   strFilename = 'stability_test_' + STRTRIM( iTemplateId, 2 ) + '.config'
   SXADDPAR, aHeader, 'TEMPLATE', iTemplateId[0]
   SXADDPAR, aHeader, 'CONFIG', strConfig[0]
   SXADDPAR, aHeader, 'FITTYPE', bFitType[0]
   SXADDPAR, aHeader, 'FIRSTID', iFirstId[0]
   SXADDPAR, aHeader, 'LASTID', iLastId[0]
   SXADDPAR, aHeader, 'XCENTER', iCenterX[0]
   SXADDPAR, aHeader, 'YCENTER', iCenterY[0]
   SXADDPAR, aHeader, 'WTEMPL', iWidthTemplate[0]
   SXADDPAR, aHeader, 'WSEARCH', iWidthSearch[0]
   SXADDPAR, aHeader, 'WSWATH', iWidthSwath[0]
   SXADDPAR, aHeader, 'WIDTH', iWidth[0]

                    ; test write with OPENW
   OPENW, lun, strFilename, /GET_LUN, ERROR=open_error_flag
   IF open_error_flag NE 0 THEN BEGIN
      PRINTF, -2, !ERR_STRING
      stmr_wmessage, sState, 'error writing config file: '+!ERROR_STATE.SYS_MSG
      PRINT, STRING(7b)
      WAIT, 5
      return
   ENDIF ELSE BEGIN
      FREE_LUN, lun
      WRITEFITS, strFilename, 0, aHeader
   ENDELSE

   strFilename = 'stability_test_' + STRTRIM( iTemplateId, 2 )+'.events'
   IF PTR_VALID( sState.pEventList ) THEN BEGIN
                    ; Write event file
      aEventList = *sState.pEventList
      aTimeList = *sState.pTimeList
      stmr_write_event_file, strFilename, aTimeList, aEventList, ERROR=error

   ENDIF ELSE BEGIN
      aEventList = ''
      aTimeList = ''
      stmr_write_event_file, strFilename, aTimeList, aEventList, /BLANK, ERROR=error

   ENDELSE

   IF error NE 0 THEN BEGIN
      stmr_wmessage, sState, 'error writing event file: '+strFilename
   ENDIF 

   stmr_wmessage, sState, 'saved session for template '+STRTRIM(iTemplateId[0],2)

   return
END

; _____________________________________________________________________________

PRO stmr_read_event_file, strFilename, aTimeList, aEventList, ERROR=error

   error = 0b
   OPENR, lun, strFilename, /GET_LUN, ERROR=open_error_flag

   fTime = 0.0d
   strEvent = ''
   aTimeList = ''
   aEventList = ''

   IF open_error_flag EQ 0 THEN BEGIN
      WHILE NOT EOF(lun) DO BEGIN

         READF, lun, fTime, strEvent, FORMAT='(F15.8,2X,A)'

         IF fTime GT 0 THEN BEGIN
            strTime = get_time_stamp( fTime, /MJD )
            aTimeList = [aTimeList,strTime]
            aEventList = [aEventList,strEvent]
         ENDIF

      ENDWHILE
   ENDIF ELSE BEGIN
      error = open_error_flag
      PRINTF, -2, !ERR_STRING
   ENDELSE

   FREE_LUN, lun

   IF N_ELEMENTS( aTimeList ) GT 1 THEN BEGIN
                    ; trim off dummy 0th index
      aTimeList = aTimeList[1:*]
      aEventList = aEventList[1:*]
   ENDIF ELSE BEGIN
      IF aEventList[0] EQ '' THEN BEGIN
         error = 1b
         aTimeList = ''
         aEventList = ''
      ENDIF
   ENDELSE
   
   return
END 
; _____________________________________________________________________________

PRO stmr_write_event_file, strFilename, aTimeList, aEventList, BLANK=blank, $
                           ERROR=open_error_flag

   OPENW, lun, strFilename, /GET_LUN, ERROR=open_error_flag

   IF open_error_flag EQ 0 THEN BEGIN
      IF KEYWORD_SET( blank ) THEN BEGIN
         PRINTF, lun, '', '', FORMAT='(A15,2X,A)'
      ENDIF ELSE BEGIN
         FOR i=0, N_ELEMENTS( aEventList )-1 DO BEGIN
            mjd = parse_time_stamp( aTimeList[i], /MJD )
            PRINTF, lun, mjd, aEventList[i], FORMAT='(F15.8,2X,A)'
         ENDFOR
      ENDELSE
      FREE_LUN, lun
   ENDIF ELSE BEGIN
      PRINTF, -2, !ERR_STRING
   ENDELSE

   return
END 

; _____________________________________________________________________________

PRO stmr_read_log_file, filename, id, mjd, x, y, ERROR=error

   error = 0b
   file = FINDFILE(filename, COUNT=fcount)
   PRINT, 'Reading log file '+filename
   IF fcount LE 0 THEN BEGIN
      MESSAGE, 'file not found '+filename, /CONTINUE
      error = 1b
      return
   ENDIF

   OPENR, lun, filename, /GET_LUN, ERROR=open_error_flag
   IF open_error_flag EQ 0 THEN BEGIN
      x = 0.0e
      y = 0.0e
      id = 0l
      mjd = 0.0d
      
      entry = id
      dx = x
      dy = y
      time = mjd
      
      WHILE NOT EOF(lun) DO BEGIN
         READF, lun, entry, dx, dy, time, FORMAT='(i5,2(f8.3),f15.8)'
         id = [id,entry]
         x = [x,dx]
         y = [y,dy]
         mjd = [mjd,time]
      ENDWHILE
                    ; trim off dummy 0th index
      IF N_ELEMENTS( id ) GT 1 THEN BEGIN
         id = id[1:*]
         x = x[1:*]
         y = y[1:*]
         mjd = mjd[1:*]
      ENDIF
   ENDIF ELSE BEGIN
      error = open_error_flag
      PRINTF, -2, !ERR_STRING
   ENDELSE 
   FREE_LUN, lun

   return
END

; _____________________________________________________________________________

PRO stmr_write_log_file, filename, id, mjd, x, y, ERROR=error_code, $
                         APPEND=append
   error_code = 0b
   
   IF N_ELEMENTS(id) LE 0 THEN BEGIN
      error_code = 1b
      return
   ENDIF 

   OPENW, lun, filename, /GET_LUN, ERROR=open_error_flag, APPEND=append
   IF open_error_flag EQ 0 THEN BEGIN
      FOR i=0, N_ELEMENTS(id)-1 DO $
       PRINTF, lun, id[i], x[i], y[i], mjd[i], FORMAT='(i5,2(f8.3),f15.8)'
      FREE_LUN, lun
   ENDIF ELSE BEGIN
      error_code = open_error_flag
      PRINTF, -2, !ERR_STRING
   ENDELSE 

   return
END 

; _____________________________________________________________________________

PRO stmr_plot_data, plot_id, plot_dx, plot_dy, plot_mjd_time, $
                    CONFIG=strConfig, FIRST=firstid, LAST=lastid, $
                    EVENT_TIMES=event_times, EVENT_VALUES=event_values, $
                    XMIN=xmin, XMAX=xmax, YMIN=ymin, YMAX=ymax, $
                    TEMPLATEID=templateid, XCENTER=xcenter, YCENTER=ycenter, $
                    FIT_TYPE=fit_type, FONT=font_type

   IF N_ELEMENTS(strConfig) LE 0 THEN strConfig = ''

   IF N_ELEMENTS(firstid) LE 0 THEN firstid = MIN(plot_id)
   IF N_ELEMENTS(lastid) LE 0 THEN lastid = MAX(plot_id)

   IF firstid LE 0 THEN firstid = MIN(plot_id)
   IF lastid LE 0 THEN lastid = MAX(plot_id)

   pindex = WHERE((plot_id LE lastid) AND (plot_id GE firstid), pcount )
   IF pcount LE 0 THEN BEGIN
      MESSAGE, 'no data to plot.', /CONTINUE
      return
   ENDIF
   id = plot_id[pindex]
   dx = plot_dx[pindex]
   dy = plot_dy[pindex]
   mjd_time = plot_mjd_time[pindex]
   t0jd = mjd_time[0] + 2400000.5
   sct0 = get_time_stamp(mjd_time[0], /MJD)
   h = ((mjd_time - LONG(mjd_time[0])) * 24.0)

   IF N_ELEMENTS(templateid) GT 0 THEN BEGIN
                    ; set the zero-point
      tindex = WHERE(id EQ templateid, tcount)
      IF tcount GT 0 THEN BEGIN
         dx = dx - dx[tindex[0]]
         dy = dy - dy[tindex[0]]
      ENDIF
      ;;dx = dx - dx[0]
      ;;dy = dy - dy[0]

      DBOPEN, 'acs_log'
      template_detector = DBVAL( templateid, 'DETECTOR' )
      template_subarray = DBVAL( templateid, 'SUBARRAY' )
      template_xcorner  = DBVAL( templateid, 'CCDXCOR' )
      template_ycorner  = DBVAL( templateid, 'CCDYCOR' )
      DBCLOSE

                    ; Coordinate transformation
      CASE STRUPCASE(template_detector) OF
         'HRC': BEGIN
         END 
         'SBC': BEGIN
            dy = -1.0 * dy
         END
         'WFC': BEGIN
            dx = -1.0 * dx
            dy = -1.0 * dy            
         END
         ELSE:
      ENDCASE

   ENDIF

   dr = SQRT( dx^2 + dy^2 )

                    ; If they are not defined
   IF N_ELEMENTS( xmin ) LE 0 THEN xmin = MIN( h )
   IF N_ELEMENTS( xmax ) LE 0 THEN xmax = MAX( h )
   IF N_ELEMENTS( ymin ) LE 0 THEN ymin = ( MIN( dx ) < MIN( dy ) < MIN( dr ) )
   IF N_ELEMENTS( ymax ) LE 0 THEN ymax = ( MAX( dx ) > MAX( dy ) > MAX( dr ) )

   xstyle = 1
   ystyle = 1
                    ; If they are both zero assume they have not been set
   IF (xmin EQ 0) AND (xmax EQ 0) THEN BEGIN
      xmin = MIN( h )
      xmax = MAX( h )
      xstyle = 3
   ENDIF 
   IF (ymin EQ 0) AND (ymax EQ 0) THEN BEGIN
      ymin = ( MIN( dx ) < MIN( dy ) < MIN( dr ) )
      ymax =  ( MAX( dx ) > MAX( dy ) > MAX( dr ) )
      ystyle = 3
   ENDIF

                    ; if the max is less than the min
   IF (xmax LT xmin) THEN xmax = MAX( h )
   IF (ymax LT ymin) THEN ymax = ( MAX( dx ) > MAX( dy ) > MAX( dr ) )

   xrange = [xmin, xmax]
   yrange = [ymin, ymax]

   strDate = STRING(FORMAT='(c(CDI,X,CMoA,CYI5))',t0jd)

   IF N_ELEMENTS(fit_type) GT 0 THEN BEGIN
      CASE fit_type OF
         0: strType = 'Correlation'
         1: strType = 'Gaussian Fit'
         ELSE: strType = 'Image Stability'
      ENDCASE
   ENDIF ELSE BEGIN
      strType = 'Image Stability'
   ENDELSE

   strTitle = STRUPCASE(template_detector)+' '+strType+' '+strDate+$
    '  '+strConfig
   strXTitle = 'UTC Time of day (hrs)'
   strYTitle = 'Relative position (px)'

   strSubTitleFormat='("Start ",A,1X,"Entries ",I0,":",I0,1X,"Template ",I0)'
   strSubTitle = STRING( FORMAT=strSubTitleFormat, $
                         sct0, firstid, lastid, templateid )

   IF !D.NAME NE 'PS' THEN BEGIN
      LOADCT, 39, /SILENT ; Rainbow + white color table
      x_color = !D.N_COLORS / 4
      y_color = 2 * !D.N_COLORS / 4
      r_color = 7 * !D.N_COLORS / 8
   ENDIF ELSE BEGIN
      TVLCT, [0,255,0,0], [0,0,255,0], [0,0,0,25]
      x_color = 3
      y_color = 2
      r_color = 1
   ENDELSE

   IF (xmax - xmin) GT 2 THEN BEGIN
      tick_intervals = ROUND( FLOOR(xmax) - CEIL(xmin) )
      tick_spacing = FIX( tick_intervals / 30 ) + 1
      n_ticks = (tick_intervals/tick_spacing) + 1
      tick_values = CEIL(xmin) + FINDGEN( n_ticks ) * tick_spacing
      tick_labels = STRTRIM( FIX(tick_values MOD 24), 2 )
      tick_minor = FIX( 4 / tick_spacing )

      ;;HELP, tick_intervals, tick_spacing, n_ticks, tick_minor
      ;;PRINT, 'tick values: ', tick_values
      ;;PRINT, 'tick labels: ', tick_labels

      PLOT, h, dx, XSTYLE=xstyle, YSTYLE=ystyle, $
       YRANGE=yrange, XRANGE=xrange, FONT=font_type, $
       TITLE=strTitle, SUBTITLE=strSubTitle, $
       XTITLE=strXTitle, YTITLE=strYTitle, $
       XTICKS=n_ticks-1, XMINOR=tick_minor, $
       XTICKV=tick_values, XTICKNAME=tick_labels, /NODATA
   ENDIF ELSE BEGIN
      PLOT, h, dx, XSTYLE=xstyle, YSTYLE=ystyle, $
       YRANGE=yrange, XRANGE=xrange, FONT=font_type, $
       TITLE=strTitle, SUBTITLE=strSubTitle, $
       XTITLE=strXTitle, YTITLE=strYTitle
   ENDELSE 

   OPLOT, h, dx, PSYM=-4, COLOR=x_color
   OPLOT, h, dy, PSYM=-5, COLOR=y_color
   OPLOT, h, dr, COLOR=r_color

   PLOTS, .2, .025, PSYM=4, /NORMAL, COLOR=x_color
   XYOUTS, .22, .02, 'X offset', CHARS=.75, /NORMAL, COLOR=x_color
   PLOTS, .2, 0.005, PSYM=5, /NORMAL, COLOR=y_color
   XYOUTS, .22, 0.0, 'Y offset', CHARS=.75, /NORMAL, COLOR=y_color, $
    FONT=font_type

   IF N_ELEMENTS(xcenter) GT 0 THEN BEGIN
      IF STRUPCASE(STRMID(template_subarray,0,3)) EQ 'SUB' THEN $
       det_xcenter = xcenter + template_ycorner $
      ELSE det_xcenter = xcenter
      XYOUTS, .85, .02, 'X center: '+STRTRIM(det_xcenter,2), CHARS=.75, $
       /NORMAL, COLOR=x_color
   ENDIF 
   IF N_ELEMENTS( ycenter ) GT 0 THEN BEGIN
      IF STRUPCASE(STRMID(template_subarray,0,3)) EQ 'SUB' THEN $
       det_ycenter = ycenter + template_xcorner $
      ELSE det_ycenter = ycenter
      XYOUTS, .85, 0.0, 'Y center: '+STRTRIM(det_ycenter,2), CHARS=.75, $
       /NORMAL, COLOR=y_color
   ENDIF 

   IF N_ELEMENTS(event_times) GT 0 THEN BEGIN
                    ; annotations
                    ; y position of time labels
      y_label_pos = !Y.CRANGE[0] + 0.02 * (!Y.CRANGE[1] - !Y.CRANGE[0])
      x_label_offset = 0.0025 * (!X.CRANGE[1] - !X.CRANGE[0])

      FOR i = 0, (N_ELEMENTS(event_times) - 1) DO BEGIN
         event_mjd = parse_time_stamp( event_times[i], /MJD )
         evtime = (event_mjd - LONG(mjd_time[0])) * 24.0

         strEvent = event_values[i]
         old_bang_pos = 0
bang_loop_point:
         bang_pos = STRPOS( strEvent, '!', old_bang_pos )
         IF bang_pos NE -1 THEN BEGIN
            byte_string = BYTE( strEvent )
            IF bang_pos EQ 0 THEN BEGIN
               byte_string = [33b,byte_string] 
            ENDIF ELSE IF bang_pos EQ N_ELEMENTS(byte_string)-1 THEN BEGIN
               byte_string = [byte_string,33b]
            ENDIF ELSE BEGIN
               byte_string = [ byte_string[0:bang_pos], 33b, $
                               byte_string[bang_pos+1:*] ]
            ENDELSE
            
            strEvent = STRING( byte_string )
            old_bang_pos = bang_pos + 2
            GOTO, bang_loop_point
         ENDIF

         OPLOT, [1,1]*evtime, !Y.CRANGE, LINES=1
         
         XYOUTS, evtime - x_label_offset, y_label_pos, strEvent, $
          CHARS=0.7, ORIENT=90.0, FONT=font_type
      END
   ENDIF

   return
END

; _____________________________________________________________________________

PRO stmr_get_slices, entry, xslice, yslice, XCENTER=xcenter, YCENTER=ycenter, $
                     WIDTH=width, SWATH_WIDTH=width_swath, ERROR=error_code

   error_code = 0b
   strMessage = ''
   ACS_READ, entry, h, d, hudl, udl, heng1, /NO_ABORT, $ ;;,/OVERSCAN
    MESSAGE=strMessage, /SILENT, /WAIT
   IF N_ELEMENTS(strMessage) GT 0 THEN BEGIN
      IF strMessage[0] NE '' THEN BEGIN
         error_code=1b
         return
      ENDIF
   ENDIF 

   d = d[xcenter-width:xcenter+width,ycenter-width:ycenter+width]
   ps = 2 * width + 1
   xslice = REBIN( d[*,width-width_swath:width+width_swath], ps, 1 )
   yslice = TRANSPOSE(REBIN(d[width-width_swath:width+width_swath,*],1,ps))

   bx = INDGEN( 20 )
   bx[10] = INDGEN( 10 ) + (2*width - 9)

   cfx = POLY_FIT( FLOAT(bx), xslice[bx], 1 )
   xsb = POLY( FINDGEN( 2*width + 1 ), cfx )
   xslice = xslice - xsb

   cfy = POLY_FIT( FLOAT(bx), yslice[bx], 1 )
   ysb = POLY( FINDGEN( 2*width + 1), cfy )
   yslice = yslice - ysb

   ;;yslice = ( MIN(yslice) - yslice ) / MIN(yslice)
   ;;xslice = ( MIN(xslice) - xslice ) / MIN(xslice)

   xslice = xslice / ( MAX( xslice ) - MIN( xslice ) )
   yslice = yslice / ( MAX( yslice ) - MIN( yslice ) )

   return
END

; _____________________________________________________________________________

PRO stmr_get_template, entry, xtemplate, ytemplate, ERROR=error_code, $
                       XCENTER=xcenter, YCENTER=ycenter, $
                       WIDTH=width, SWATH_WIDTH=width_swath, $
                       TEMPLATE_WIDTH=width_template, SMOOTH=smooth

   stmr_get_slices, entry, xslice, yslice, XCENTER=xcenter, YCENTER=ycenter, $
    WIDTH=width, SWATH_WIDTH=width_swath, ERROR=error_code
   IF error_code NE 0 THEN return

   ytemplate = yslice[width-width_template:width+width_template]
   xtemplate = xslice[width-width_template:width+width_template]
   
   IF KEYWORD_SET( smooth ) THEN BEGIN
      ytemplate = SMOOTH( ytemplate, 3 )
      ytemplate = SMOOTH( ytemplate, 3 )
      xtemplate = SMOOTH( xtemplate, 3 )
      xtemplate = SMOOTH( xtemplate, 3 )
   ENDIF 

   saved_pmulti = !P.MULTI
   !P.MULTI = [0, 1, 2]
   
   PLOT, xslice[width-width_template:width+width_template], $
    TITLE='X template', /XSTYLE
   OPLOT, xtemplate, LINESTYLE=1

   PLOT, yslice[width-width_template:width+width_template], $
    TITLE='Y template', /XSTYLE
   OPLOT, ytemplate, LINESTYLE=1

   !P.MULTI = saved_pmulti

   return
END

; _____________________________________________________________________________

PRO stmr_gaussfit_slices, template, entry, dx, dy, ERROR=error_code, $
                          SILENT=silent, DEBUG=debug, $
                          XCENTER=xcenter, YCENTER=ycenter, $
                          WIDTH=width, SWATH_WIDTH=width_swath, $
                          SEARCH_WIDTH=width_search, $
                          TEMPLATE_WIDTH=width_template

   saved_pmulti = !P.MULTI
   !P.MULTI = [0, 1, 2]

;  stmr_get_template, template, xtemplate, ytemplate, $
;    XCENTER=xcenter, YCENTER=ycenter, $
;    WIDTH=width, SWATH_WIDTH=width_swath, $
;    TEMPLATE_WIDTH=width_template

   stmr_get_slices, template, xtemplate, ytemplate, $
    XCENTER=xcenter, YCENTER=ycenter, $
    WIDTH=width, SWATH_WIDTH=width_swath, ERROR=error_code
   IF error_code NE 0 THEN return

   DBOPEN, 'acs_log'
   detector = DBVAL( template, 'DETECTOR' )
   caldoor_pos = DBVAL( template, 'CALDOOR' )
   CASE STRUPCASE( STRMID(detector,0,3) ) OF
      'WFC': BEGIN
         aEstimate = [1.0,FLOAT(width),2.0,0.0,0.0]
;         aEstimateT = [1.0,FLOAT(width_template),2.0,0.0,0.0]
      END 
      ELSE: BEGIN
         CASE caldoor_pos OF
            'CORONAGRAPH': BEGIN
               aEstimate = [-1.0,FLOAT(width),FLOAT(width_template),0.0,0.0]
;               aEstimateT = [ -1.0,FLOAT(width_template), $
;                              FLOAT(width_template/2),0.0,0.0 ]
            END
            ELSE: BEGIN
               aEstimate = [1.0,FLOAT(width),FLOAT(width_template),0.0,0.0]
;               aEstimateT = [ 1.0,FLOAT(width_template), $
;                              FLOAT(width_template/2),0.0,0.0 ]
            END 
         ENDCASE
      END
   ENDCASE 

                    ; ________________________________
   
                    ; Set up X template estimates
                    ; ________________________________

   max_index = WHERE( xtemplate EQ MAX( xtemplate ), max_count )
   min_index = WHERE( xtemplate EQ MIN( xtemplate ), min_count )
   IF aEstimate[0] LT 0 THEN BEGIN
      IF min_count GT 0 THEN aEstimate[1] = min_index[0]
   ENDIF ELSE BEGIN
      IF max_count GT 0 THEN aEstimate[1] = max_index[0]
   ENDELSE

   xt_index = LINDGEN( N_ELEMENTS( xtemplate ) )
;   xt_fit = GAUSSFIT( xt_index, xtemplate, xt_a, NTERMS=5, ESTIMATE=aEstimateT)
   xt_fit = GAUSSFIT( xt_index, xtemplate, xt_a, NTERMS=5, ESTIMATE=aEstimate )
   xt_fit = GAUSSINT_FIT( xt_index, xtemplate, xt_a, NTERMS=5, ESTIMATE=xt_a )

   PRINT, 'template x estimate: ', aEstimate, $
    FORMAT='(A,F8.3,1X,F8.3,1X,F8.3,1X,F8.3,1X,F8.3)'
   PRINT, 'template x coeff   : ', xt_a, $
    FORMAT='(A,F8.3,1X,F8.3,1X,F8.3,1X,F8.3,1X,F8.3)'

   PLOT, xt_index, xtemplate, TITLE='X template', PSYM=10, /XSTYLE
   OPLOT, xt_fit, LINESTYLE=1

                    ; ________________________________
   
                    ; Set up Y template estimates
                    ; ________________________________

   max_index = WHERE( ytemplate EQ MAX( ytemplate ), max_count )
   min_index = WHERE( ytemplate EQ MIN( ytemplate ), min_count )
   IF aEstimate[0] LT 0 THEN BEGIN
      IF min_count GT 0 THEN aEstimate[1] = min_index[0]
   ENDIF ELSE BEGIN
      IF max_count GT 0 THEN aEstimate[1] = max_index[0]
   ENDELSE

   yt_index = LINDGEN( N_ELEMENTS( ytemplate ) )
;   yt_fit = GAUSSFIT( yt_index, ytemplate, yt_a, NTERMS=5, ESTIMATE=aEstimateT)
   yt_fit = GAUSSFIT( yt_index, ytemplate, yt_a, NTERMS=5, ESTIMATE=aEstimate )
   yt_fit = GAUSSINT_FIT( yt_index, ytemplate, yt_a, NTERMS=5, ESTIMATE=yt_a )

   PRINT, 'template y estimate: ', aEstimate, $
    FORMAT='(A,F8.3,1X,F8.3,1X,F8.3,1X,F8.3,1X,F8.3)'
   PRINT, 'template y coeff   : ', yt_a, $
    FORMAT='(A,F8.3,1X,F8.3,1X,F8.3,1X,F8.3,1X,F8.3)'

   PLOT, yt_index, ytemplate, TITLE='Y template', PSYM=10, /XSTYLE
   OPLOT, yt_fit, LINESTYLE=1
   WAIT, 1

   dx = MAKE_ARRAY( N_ELEMENTS( entry ), /FLOAT )
   dy = MAKE_ARRAY( N_ELEMENTS( entry ), /FLOAT )

   FOR i=0L, N_ELEMENTS( entry )-1 DO BEGIN
      IF NOT KEYWORD_SET( silent ) THEN $
       PRINT, 'Processing entry number ' + STRTRIM(entry[i],2)

      stmr_get_slices, entry[i], xslice, yslice, $
       XCENTER=xcenter, YCENTER=ycenter, $
       WIDTH=width, SWATH_WIDTH=width_swath, ERROR=error_code
      IF error_code NE 0 THEN return

                    ; ________________________________
      
                    ; Set up X estimates
                    ; ________________________________

      max_index = WHERE( xslice EQ MAX( xslice ), max_count )
      min_index = WHERE( xslice EQ MIN( xslice ), min_count )
      IF aEstimate[0] LT 0 THEN BEGIN
         IF min_count GT 0 THEN aEstimate[1] = min_index[0]
      ENDIF ELSE BEGIN
         IF max_count GT 0 THEN aEstimate[1] = max_index[0]
      ENDELSE

      xindex = LINDGEN( N_ELEMENTS( xslice ) )
      PLOT, xslice, TITLE = 'entry '+STRTRIM(entry[i],2)+': X slice', PSYM=10,$
       /XSTYLE
      x_fit = GAUSSFIT( xindex, xslice, x_a0, NTERMS=5, ESTIMATE=aEstimate )
      x_fit = GAUSSINT_FIT( xindex, xslice, x_a, NTERMS=5, ESTIMATE=x_a0 )
      OPLOT, x_fit, LINESTYLE=1

      PRINT, 'X estimate0: ', aEstimate, $
       FORMAT='(A,F8.3,1X,F8.3,1X,F8.3,1X,F8.3,1X,F8.3)'
      PRINT, 'X estimate1: ', x_a0, $
       FORMAT='(A,F8.3,1X,F8.3,1X,F8.3,1X,F8.3,1X,F8.3)'
      PRINT, 'X coeff    : ', x_a, $
       FORMAT='(A,F8.3,1X,F8.3,1X,F8.3,1X,F8.3,1X,F8.3)'

                    ; ________________________________
      
                    ; Set up Y estimates
                    ; ________________________________

      max_index = WHERE( yslice EQ MAX( yslice ), max_count )
      min_index = WHERE( yslice EQ MIN( yslice ), min_count )
      IF aEstimate[0] LT 0 THEN BEGIN
         IF min_count GT 0 THEN aEstimate[1] = min_index[0]
      ENDIF ELSE BEGIN
         IF max_count GT 0 THEN aEstimate[1] = max_index[0]
      ENDELSE

      yindex = LINDGEN( N_ELEMENTS( yslice ) )
      PLOT, yslice, TITLE = 'entry '+STRTRIM(entry[i],2)+': Y slice', PSYM=10,$
       /XSTYLE
      y_fit = GAUSSFIT( yindex, yslice, y_a0, NTERMS=5, ESTIMATE=aEstimate )
      y_fit = GAUSSINT_FIT( yindex, yslice, y_a, NTERMS=5, ESTIMATE=y_a0 )
      OPLOT, y_fit, LINESTYLE=1

      PRINT, 'Y estimate0: ', aEstimate, $
       FORMAT='(A,F8.3,1X,F8.3,1X,F8.3,1X,F8.3,1X,F8.3)'
      PRINT, 'Y estimate1: ', y_a0, $
       FORMAT='(A,F8.3,1X,F8.3,1X,F8.3,1X,F8.3,1X,F8.3)'
      PRINT, 'Y coeff    : ', y_a, $
       FORMAT='(A,F8.3,1X,F8.3,1X,F8.3,1X,F8.3,1X,F8.3)'

      xoffset = x_a[1] - xt_a[1]
      yoffset = y_a[1] - yt_a[1]
      template_size = N_ELEMENTS( xtemplate )
      slice_size = N_ELEMENTS( xslice )
      size_diff = width - width_template

;      PRINT, 'offset   (x,y):', xoffset - size_diff, yoffset - size_diff
      PRINT, 'offset   (x,y):', xoffset, yoffset

      dx[i] = xoffset; - size_diff
      dy[i] = yoffset; - size_diff
   ENDFOR

   !P.MULTI = saved_pmulti
   return
END 

; _____________________________________________________________________________

PRO stmr_correlate_slices, template, entry, dx, dy, ERROR=error_code, $
                           SILENT=silent, DEBUG=debug, $
                           XCENTER=xcenter, YCENTER=ycenter, $
                           WIDTH=width, SWATH_WIDTH=width_swath, $
                           SEARCH_WIDTH=width_search, $
                           TEMPLATE_WIDTH=width_template

   stmr_get_template, template, xtemplate, ytemplate, $
    XCENTER=xcenter, YCENTER=ycenter, $
    WIDTH=width, SWATH_WIDTH=width_swath, $
    TEMPLATE_WIDTH=width_template, /SMOOTH

   dx = MAKE_ARRAY( N_ELEMENTS( entry ), /FLOAT )
   dy = MAKE_ARRAY( N_ELEMENTS( entry ), /FLOAT )

   saved_pmulti = !P.MULTI
   !P.MULTI = [0, 1, 2]

   y_label_pos = !Y.CRANGE[0] + 0.02 * ( !Y.CRANGE[1] - !Y.CRANGE[0] )
   x_label_offset = 0.005 * ( !X.CRANGE[1] - !X.CRANGE[0] )
   FOR i=0L, N_ELEMENTS( entry )-1 DO BEGIN
      IF NOT KEYWORD_SET( silent ) THEN $
       PRINT, 'Processing entry number ' + STRTRIM(entry[i],2)

      stmr_get_slices, entry[i], xslice, yslice, $
       XCENTER=xcenter, YCENTER=ycenter, $
       WIDTH=width, SWATH_WIDTH=width_swath, ERROR=error_code
      IF error_code NE 0 THEN return

      xcor, width, xslice, xtemplate, width_search*2, width_search, xoffset, $
       PFW=width_template

      strXTitle = 'entry '+STRTRIM(entry[i],2)+': Correlation X slice'
      PLOT, xslice, PSYM=10, /XSTYLE, YSTYLE=3, TITLE=strXTitle
      OPLOT, [1,1]*xoffset, !Y.CRANGE, LINES=1
      strXLabel = STRTRIM( xoffset, 2 ) 
      XYOUTS, xoffset - x_label_offset, y_label_pos, strXLabel, $
       CHARS=1.0, ORIENT=0.0

      xcor, width, yslice, ytemplate, width_search*2, width_search, yoffset, $
       PFW=width_template

      strYTitle = 'entry '+STRTRIM(entry[i],2)+': Correlation Y slice'
      PLOT, yslice, PSYM=10, /XSTYLE, YSTYLE=3, TITLE=strYTitle
      OPLOT, [1,1]*yoffset, !Y.CRANGE, LINES=1
      strYLabel = STRTRIM( yoffset, 2 )
      XYOUTS, yoffset - x_label_offset, y_label_pos, strYLabel, $
       CHARS=1.0, ORIENT=0.0

      dx[i] = xoffset - width
      dy[i] = yoffset - width
   ENDFOR

   !P.MULTI = saved_pmulti
   return
END

; _____________________________________________________________________________

FUNCTION stmr_find_new_entries, first_entry, latest_entry, $
                                APPEND=append_data, $
                                DETECTOR=first_detector

   HELP, first_entry, latest_entry
   IF first_entry GT latest_entry THEN return, 0

   new_entries = LINDGEN(latest_entry[0]-first_entry[0]+1)+first_entry[0]
   PRINT, 'NEW:', new_entries

                    ; Ignore images that aren't on the same
                    ; detector as the first image
   IF N_ELEMENTS(first_detector) GT 0 THEN BEGIN
      DBEXT, new_entries, 'DETECTOR', aDetectors
      good = WHERE(STRTRIM(aDetectors,2) EQ first_detector, gcount)
      new_entries = (gcount GT 0) ? new_entries[good] : 0
   ENDIF

                    ; if we don't have any new data then return
   IF new_entries[0] EQ 0 THEN return, 0

                    ; Ignore images that aren't external or coronagraph
   DBEXT, new_entries, 'OBSTYPE', aObstypes
   aObstypes = STRTRIM(aObstypes,2)
   good = WHERE(aObstypes EQ 'EXTERNAL' OR aObstypes EQ 'CORON', gcount)
   new_entries = (gcount GT 0) ? new_entries[good] : 0

   return, new_entries
END 
; _____________________________________________________________________________

PRO stmr_process_readonly, sState, ERROR=error_code
                    ; could potentially just read from
                    ; sState.data_file_size to end of file
   error_code = 0b
   WIDGET_CONTROL, sState.wTemplateIdField, GET_VALUE=iTemplateId
   stmr_open_session, sState, iTemplateId[0], ERROR=error_code
END 
; _____________________________________________________________________________

PRO stmr_process_data, sState, RECALCULATE=recalculate, UPDATE=update, $
                       ERROR=error_code

   error_code = 0b
   update=0b

   saved_window = !D.WINDOW
   WSET, sState.draw_index

   stmr_wmessage, sState, 'reading parameters...'
   WIDGET_CONTROL, sState.wTemplateIdField, GET_VALUE=iTemplateId
   WIDGET_CONTROL, sState.wConfigField, GET_VALUE=strConfig
   WIDGET_CONTROL, sState.wFitTypeButton, GET_VALUE=bFitType
   WIDGET_CONTROL, sState.wFirstIdField, GET_VALUE=iFirstId
   WIDGET_CONTROL, sState.wLastIdField, GET_VALUE=iLastId
   WIDGET_CONTROL, sState.wCenterXField, GET_VALUE=iCenterX
   WIDGET_CONTROL, sState.wCenterYField, GET_VALUE=iCenterY
   WIDGET_CONTROL, sState.wWidthTemplateField, GET_VALUE=iWidthTemplate
   WIDGET_CONTROL, sState.wWidthSearchField, GET_VALUE=iWidthSearch
   WIDGET_CONTROL, sState.wWidthSwathField, GET_VALUE=iWidthSwath
   WIDGET_CONTROL, sState.wWidthField, GET_VALUE=iWidth

   WIDGET_CONTROL, sState.wPlotXminField, GET_VALUE=fPlotXmin
   WIDGET_CONTROL, sState.wPlotXmaxField, GET_VALUE=fPlotXmax
   WIDGET_CONTROL, sState.wPlotYminField, GET_VALUE=fPlotYmin
   WIDGET_CONTROL, sState.wPlotYmaxField, GET_VALUE=fPlotYmax

   DBOPEN, 'acs_log', UNAVAIL=unavailable
   IF unavailable[0] EQ 1 THEN BEGIN
      strMessage = 'Database is unavailable.'
      MESSAGE, strMessage, /CONTINUE
      error_code = 1b
      stmr_wmessage, sState, strMessage
      return
   ENDIF
   template_detector = (stmr_get_detector_of_entries(iTemplateId[0]))[0]
   latest_entry = stmr_get_latest_entry(ERROR=error_code)
   IF error_code[0] NE 0 THEN return

   IF iLastId[0] NE -1 THEN $
    last_entry = latest_entry < iLastId[0] $
   ELSE last_entry = latest_entry

   strFilename = stmr_get_log_filename(iTemplateId)
   append_data = 0
   first_entry = iFirstId[0]
   IF NOT KEYWORD_SET(recalculate) THEN BEGIN
                    ; use existing data
      IF stmr_has_state_data(sState) THEN BEGIN
         ids = stmr_get_state_entries(sState)
         mjd = stmr_get_state_times(sState)
         x = stmr_get_state_xcoords(sState)
         y = stmr_get_state_ycoords(sState)
         first_entry = MAX(ids)+1
         append_data = 1

         IF iLastId NE -1 AND iLastId LE first_entry THEN BEGIN
            stmr_turn_auto_off, sState
            stmr_wmessage, sState, $
             'warning: end of sequence reached (see last id)'
            return
         ENDIF
      ENDIF
   ENDIF

   stmr_wmessage, sState, 'finding new entries...'
   new_entries = stmr_find_new_entries(first_entry,last_entry,$
                                       APPEND=append_data,$
                                       DETECTOR=template_detector)
   IF new_entries[0] EQ 0 THEN BEGIN
      sState.last_entry = latest_entry
      stmr_wmessage, sState, 'no new data available.'
      return
   ENDIF 

                    ; process the new data
   IF (bFitType EQ 1) THEN BEGIN
      stmr_wmessage, sState, 'fitting gaussian to images...'
      stmr_gaussfit_slices, iTemplateId[0], new_entries, dx, dy, $
       XCENTER=iCenterX[0], YCENTER=iCenterY[0], $
       WIDTH=iWidth[0], $
       SEARCH_WIDTH=iWidthSearch[0], $
       SWATH_WIDTH=iWidthSwath[0], $
       TEMPLATE_WIDTH=iWidthTemplate[0], ERROR=error_code
      IF error_code NE 0 THEN return
   ENDIF ELSE BEGIN
      stmr_wmessage, sState, 'correlating images...'
      stmr_correlate_slices, iTemplateId[0], new_entries, dx, dy, $
       XCENTER=iCenterX[0], YCENTER=iCenterY[0], $
       WIDTH=iWidth[0], $
       SEARCH_WIDTH=iWidthSearch[0], $
       SWATH_WIDTH=iWidthSwath[0], $
       TEMPLATE_WIDTH=iWidthTemplate[0], ERROR=error_code
      IF error_code NE 0 THEN return
   ENDELSE
   
                    ; append to old data (if exists)
   new_times = stmr_get_time_of_entries(new_entries,ERROR=error_code)
   IF error_code[0] NE 0 THEN return
   IF KEYWORD_SET(append_data) THEN BEGIN
      ids = [ids,new_entries]
      x = [x,dx]
      y = [y,dy]
      mjd = [mjd,new_times]
   ENDIF ELSE BEGIN
      ids = new_entries
      x = dx
      y = dy
      mjd = new_times
   ENDELSE

   IF N_ELEMENTS(ids) LE 0 THEN BEGIN
      stmr_wmessage, sState, 'no entries to plot'
      return
   ENDIF

                    ; find good ones
   ;;good = WHERE( (ABS(x) LT iWidth[0]/2) AND (ABS(y) LT iWidth[0]/2), ngood )
   good = WHERE( (ABS(x) LT iWidth[0]) AND (ABS(y) LT iWidth[0]), ngood )
   IF ngood GT 0 THEN BEGIN
      ids = ids[good]
      x  = x[good]
      y  = y[good]
      mjd = mjd[good]
   ENDIF ELSE BEGIN
      stmr_wmessage, sState, 'nothing to plot'
      return
   ENDELSE

   update = 1b
                    ; update the last entry flag
   last_done = MAX(ids)
   sState.last_entry = latest_entry
   stmr_set_state_entries, sState, ids, /NO_COPY
   stmr_set_state_times, sState, mjd, /NO_COPY
   stmr_set_state_xcoords, sState, x, /NO_COPY
   stmr_set_state_ycoords, sState, y, /NO_COPY

   IF KEYWORD_SET(sState.write_permission) THEN BEGIN
                    ; write a new log file
      stmr_wmessage, sState, 'writing log file...'
      stmr_write_log_file, strFilename, new_entries, new_times, dx, dy, $
       ERROR=error_code, APPEND=append_data
   ENDIF

   return
END

; _____________________________________________________________________________

FUNCTION stmr_is_recalc_required, sState

                    ; Compare each param that effects the data to the
                    ; value in session config file 
   map_array = [ ['wFitTypeButton','FITTYPE','num'], $
                 ['wCenterXField','XCENTER','num'], $
                 ['wCenterYField','YCENTER','num'] ]

   WIDGET_CONTROL, sState.wTemplateIdField, GET_VALUE=template_id
   strFilename = stmr_get_config_filename(template_id[0])
   header = HEADFITS(strFilename)
   IF STRTRIM(header[0],2) EQ '-1' THEN return, 1b
   stags = STRUPCASE(TAG_NAMES(sState))
   FOR i=0,N_ELEMENTS(map_array[0,*])-1 DO BEGIN
      hval = SXPAR(header,map_array[1,i])
      wtagname = STRUPCASE(map_array[0,i])

      tag_i = WHERE(stags EQ wtagname, count)
      IF count GT 0 THEN BEGIN
         WIDGET_CONTROL, sState.(tag_i[0]), GET_VALU=wval
         IF hval[0] NE wval[0] THEN return, 1b
      ENDIF
   ENDFOR 

   return, 0b
END 
; _____________________________________________________________________________

PRO stmr_wmessage, sState, strMessage

   IF N_ELEMENTS( strMessage ) GT 0 THEN $
    WIDGET_CONTROL, sState.wMessageText, SET_VALUE=strMessage

   return
END 

; _____________________________________________________________________________

PRO stmr_turn_auto_on, sState
   IF sState.write_permission THEN BEGIN
                    ; check if a recalculation is required
      recalc = stmr_is_recalc_required(sState)
      IF KEYWORD_SET(recalc) THEN BEGIN
         aMessage = ['The configuration has changed so', $
                     'existing data must be recalculated.', '',$
                     'Do you wish to continue?']
         result = DIALOG_MESSAGE(aMessage,/QUESTION,/DEFAULT_NO,$
                                 DIALOG_PARENT=sState.wRoot)
         IF result NE 'Yes' THEN BEGIN
            stmr_turn_auto_off, sState
            return
         ENDIF
      ENDIF
                    ; save session
      stmr_save_session, sState
   ENDIF
                    ; remove button sensitivity
   WIDGET_CONTROL, sState.wRoot, UPDATE=0
   WIDGET_CONTROL, sState.wParamBase, SENSITIVE=0
                    ; reset last time
   sState.last_time = -1d
                    ; set auto track flag
   sState.auto_track = 1b
                    ; toggle droplist
   WIDGET_CONTROL, sState.wAutoDropList, SET_DROPLIST_SELECT=1
                    ; display start message
   WIDGET_CONTROL, sState.wMessageText, SET_VALUE='Start Auto'
   WIDGET_CONTROL, sState.wRoot, UPDATE=1

   error_code = 0b
   IF sState.write_permission GT 0 THEN BEGIN
      stmr_process_data, sState, RECALCULATE=recalc, UPDATE=update, $
       ERROR=error_code
   ENDIF
   IF error_code[0] EQ 0 THEN BEGIN
      IF KEYWORD_SET(update) THEN BEGIN
         stmr_update_plot, sState
         IF sState.hardcopy_on_update THEN BEGIN
            stmr_update_plot, sState, /PS, /UPDATE, /PRINT
         ENDIF 
      ENDIF
                    ; generate a timer event
      WIDGET_CONTROL, sState.wNewDataTimer, TIMER=5
   ENDIF ELSE BEGIN
      stmr_turn_auto_off, sState
      ;;stmr_wmessage, sState, 'Database is not available.'
   ENDELSE
   return
END

; _____________________________________________________________________________

PRO stmr_turn_auto_off, sState
                    ; clear all (timer) events
   WIDGET_CONTROL, sState.wBase, /CLEAR_EVENTS
                    ; unset auto track flag
   sState.auto_track = 0b
                    ; toggle droplist
   WIDGET_CONTROL, sState.wAutoDropList, SET_DROPLIST_SELECT=0
                    ; make buttons sensitive
   WIDGET_CONTROL, sState.wParamBase, SENSITIVE=1
                    ; display stop message
   ;;WIDGET_CONTROL, sState.wMessageText, SET_VALUE='Auto Off'
   return
END

; _____________________________________________________________________________

FUNCTION stmr_config_is_good, sState, ERROR=error_code

   status = 1b
   error_code = 0b

   WIDGET_CONTROL, sState.wConfigField, GET_VALUE=strConfig
   WIDGET_CONTROL, sState.wTemplateIdField, GET_VALUE=iTemplateId
   WIDGET_CONTROL, sState.wFirstIdField, GET_VALUE=iFirstId
   WIDGET_CONTROL, sState.wLastIdField, GET_VALUE=iLastId
   WIDGET_CONTROL, sState.wCenterXField, GET_VALUE=iCenterX
   WIDGET_CONTROL, sState.wCenterYField, GET_VALUE=iCenterY
   WIDGET_CONTROL, sState.wWidthTemplateField, GET_VALUE=iWidthTemplate
   WIDGET_CONTROL, sState.wWidthSearchField, GET_VALUE=iWidthSearch
   WIDGET_CONTROL, sState.wWidthSwathField, GET_VALUE=iWidthSwath
   WIDGET_CONTROL, sState.wWidthField, GET_VALUE=iWidth

   unavailable=0b
   DBOPEN, 'acs_log', UNAVAIL=unavailable
   IF unavailable[0] EQ 1 THEN BEGIN
      status= 0b
      GOTO, done
   ENDIF 

   detector = DBVAL( iTemplateId[0], 'DETECTOR' )
   obstype = DBVAL(iTemplateId[0], 'OBSTYPE')
   obstype = STRTRIM(obstype,2)
   subarray = DBVAL( iTemplateId[0], 'SUBARRAY' )
   ccdxsiz = DBVAL( iTemplateId[0], 'CCDXSIZ' )
   ccdysiz = DBVAL( iTemplateId[0], 'CCDYSIZ' )
   DBCLOSE

   CASE STRUPCASE(detector) OF 
      'SBC': BEGIN
         xsize = 1024
         ysize = 1024
      END
      'HRC': BEGIN
         xsize = 1062
         ysize = 1044
      END
      'WFC': BEGIN
         xsize = 4144
         ysize = 4136
      END 
      ELSE: BEGIN
         strMessage, 'unknown detector'
         stmr_wmessage, sState, strMessage
         status = 0b
         GOTO, done
      END
   ENDCASE

   IF obstype NE 'CORON' AND obstype NE 'EXTERNAL' THEN BEGIN
      status = 0b
      strMessage = 'Template id must be coronagraph or external image.'
      stmr_wmessage, sState, strMessage
      GOTO, done
   ENDIF

   IF STRMID(subarray, 0, 3) EQ 'SUB' THEN BEGIN
      xsize = ccdxsiz
      ysize = ccdysiz
   ENDIF 

   IF ( iCenterX LE 0 ) THEN BEGIN
      strMessage = 'X center must be greater than zero'
      stmr_wmessage, sState, strMessage
      status = 0b
      GOTO, done
   ENDIF

   IF ( iCenterY LE 0 ) THEN BEGIN
      strMessage = 'Y center must be greater than zero'
      stmr_wmessage, sState, strMessage
      status = 0b
      GOTO, done
   ENDIF 

   IF ( iCenterX GE xsize ) THEN BEGIN
      strMessage = 'X center must be less than image x size'
      stmr_wmessage, sState, strMessage
      status = 0b
      GOTO, done
   ENDIF

   IF ( iCenterY GE ysize ) THEN BEGIN
      strMessage = 'Y center must be less than image y size'
      stmr_wmessage, sState, strMessage
      status = 0b
      GOTO, done
   ENDIF   

   IF ( iWidth LE 0 ) THEN BEGIN
      strMessage = 'Width must be greater than zero'
      stmr_wmessage, sState, strMessage
      status = 0b
      GOTO, done
   ENDIF 

   IF ( iWidth GE xsize ) THEN BEGIN
      strMessage = 'Width must be less than image x size'
      stmr_wmessage, sState, strMessage
      status = 0b
      GOTO, done
   ENDIF 

   IF ( iWidth GE ysize ) THEN BEGIN
      strMessage = 'Width must be less than image y size'
      stmr_wmessage, sState, strMessage
      status = 0b
      GOTO, done
   ENDIF 

   IF ( iWidthTemplate LE 2 ) THEN BEGIN
      strMessage = 'Template width must be greater than two'
      stmr_wmessage, sState, strMessage
      status = 0b
      GOTO, done
   ENDIF 
   IF ( iWidthSearch LE 0 ) THEN BEGIN
      strMessage = 'Search width must be greater than zero'
      stmr_wmessage, sState, strMessage
      status = 0b
      GOTO, done
   ENDIF 
   IF ( iWidthSwath LE 0 ) THEN BEGIN
      strMessage = 'Swath width must be greater than zero'
      stmr_wmessage, sState, strMessage
      status = 0b
      GOTO, done
   ENDIF 

;  check for this thing:
;   d = d[xcenter-width:xcenter+width,ycenter-width:ycenter+width]

   IF ( iCenterX - iWidth ) LT 0 THEN BEGIN
      strMessage = 'X center - Width must be greater than zero'
      stmr_wmessage, sState, strMessage
      status = 0b
      GOTO, done
   ENDIF 
   IF ( iCenterY - iWidth ) LT 0 THEN BEGIN
      strMessage = 'Y center - Width must be greater than zero'
      stmr_wmessage, sState, strMessage
      status = 0b
      GOTO, done
   ENDIF 
   IF ( iCenterX + iWidth ) GE xsize THEN BEGIN
      strMessage = 'X center + Width must be less than image x size'
      stmr_wmessage, sState, strMessage
      status = 0b
      GOTO, done
   ENDIF 
   IF ( iCenterY + iWidth ) GE ysize THEN BEGIN
      strMessage = 'Y center + Width must be less than image y size'
      stmr_wmessage, sState, strMessage
      status = 0b
      GOTO, done
   ENDIF 

   IF ( iWidth LE (iWidthSearch+iWidthTemplate) ) THEN BEGIN
      strMessage = 'Width must be larger than search width plus template width'
      stmr_wmessage, sState, strMessage
      status = 0b
      GOTO, done
   ENDIF
   
   IF ( iWidth LE iWidthSwath ) THEN BEGIN
      strMessage = 'Width must be larger than swath width'
      stmr_wmessage, sState, strMessage
      status = 0b
      GOTO, done
   ENDIF
      
done:
   return, status
END 

; _____________________________________________________________________________

PRO stmr_auto_configure, sState, ERROR=error_code
   
   error_code = 0b
   saved_window = !D.WINDOW
   saved_pmulti = !P.MULTI

   WIDGET_CONTROL, sState.wTemplateIdField, GET_VALUE=iTemplateId
   WIDGET_CONTROL, sState.wFirstIdField, GET_VALUE=iFirstId
   WIDGET_CONTROL, sState.wLastIdField, GET_VALUE=iLastId

   stmr_wmessage, sState, 'Reading template file...'
   strMessage = ''
   ACS_READ, iTemplateId[0], header, data, /NO_ABORT, $
    MESSAGE=strMessage, /SILENT, /WAIT
   IF N_ELEMENTS(strMessage) GT 0 THEN BEGIN
      IF strMessage[0] NE '' THEN BEGIN
         stmr_wmessage, sState, strMessage
         error_code=1b
         return
      ENDIF
   ENDIF

   caldoor_pos = SXPAR( header, 'CALDOOR' )
   detector = SXPAR( header, 'DETECTOR' )
   ccdxcor = SXPAR( header, 'CCDXCOR' )
   ccdycor = SXPAR( header, 'CCDYCOR' )

   CASE STRUPCASE( STRMID(detector,0,3) ) OF
      'WFC': BEGIN
         width = 20.0
         aEstimate = [1.0,width,2.0,0.0]
         fit_type = 1
      END 
      ELSE: BEGIN
         fit_type = 0
         CASE caldoor_pos OF
            'CORONAGRAPH': BEGIN
               width = 70.0
               aEstimate = [-1.0,width,width/2.0,0.0]
            END
            ELSE: BEGIN
               fit_type = 1
               width = 30.0
               aEstimate = [1.0,width,2.0,0.0]
            END 
         ENDCASE
      END
   ENDCASE 

   data_sz = SIZE(data)

   xsize = data_sz[1]
   ysize = data_sz[2]

   WINDOW, /FREE, XSIZE=xsize, YSIZE=ysize, TITLE='Select center:', $
    COLORS = 256
   IF aEstimate[0] GT 0 THEN BEGIN
      imin = 0.0
      imax = MAX( data )
      TV, BYTSCL( HIST_EQUAL( data, MINV=imin, MAXV=imax ) )
   ENDIF ELSE BEGIN
      imin = 0.0
      imax = MAX( data )
      TV, BYTSCL( HIST_EQUAL( data, MINV=imin, MAXV=imax ) )
   ENDELSE 

   stmr_wmessage, sState, 'Select approximate image center'
   CURSOR, xcenter, ycenter, /UP, /DEVICE

   ;;HELP, x0, y0, x1, y1, xcenter, ycenter

   WDELETE
   WSET, sState.draw_index

   swath_width = width / 2
   
   ;;HELP, xcenter, ycenter, width, swath_width

   !P.MULTI = [0, 1, 2]
   stmr_wmessage, sState, 'configuring...'
   ERASE

   stmr_get_slices, iTemplateId[0], xslice, yslice, $
    XCENTER=xcenter, YCENTER=ycenter, $
    WIDTH=width, SWATH_WIDTH=swath_width, ERROR=error_code
   IF error_code NE 0 THEN return

   xindex = LINDGEN( N_ELEMENTS( xslice ) )
   PLOT, xindex, xslice, TITLE='X slice', PSYM=10, /XSTYLE

   max_index = WHERE( xslice EQ MAX( xslice ), max_count )
   min_index = WHERE( xslice EQ MIN( xslice ), min_count )
   IF aEstimate[0] LT 0 THEN BEGIN
      IF min_count GT 0 THEN aEstimate[1] = min_index[0] ELSE $
       aEstimate[1] = width
   ENDIF ELSE BEGIN
      IF max_count GT 0 THEN aEstimate[1] = max_index[0] ELSE $
       aEstimate[1] = width
   ENDELSE

   x_estimate = aEstimate
   PRINT, 'X estimate: ', x_estimate, $
    FORMAT='(A,F8.3,1X,F8.3,1X,F8.3,1X,F8.3,1X,F8.3)'
   x_gfit = GAUSSFIT( xindex, xslice, x_a, NTERMS=4, ESTIMATE=x_estimate )
   x_gfit = GAUSSINT_FIT( xindex, xslice, x_a, NTERMS=4, ESTIMATE=x_a )
   OPLOT, x_gfit, LINESTYLE=2

   yindex = LINDGEN( N_ELEMENTS( yslice ) )
   PLOT, yindex, yslice, TITLE='Y slice', PSYM=10, /XSTYLE

   max_index = WHERE( yslice EQ MAX( yslice ), max_count )
   min_index = WHERE( yslice EQ MIN( yslice ), min_count )
   IF aEstimate[0] LT 0 THEN BEGIN
      IF min_count GT 0 THEN aEstimate[1] = min_index[0]
   ENDIF ELSE BEGIN
      IF max_count GT 0 THEN aEstimate[1] = max_index[0]
   ENDELSE

   y_estimate = aEstimate
   PRINT, 'Y estimate: ', y_estimate, $
    FORMAT='(A,F8.3,1X,F8.3,1X,F8.3,1X,F8.3,1X,F8.3)'
   y_gfit = GAUSSFIT( yindex, yslice, y_a, NTERMS=4, ESTIMATE=y_estimate  )
   y_gfit = GAUSSINT_FIT( yindex, yslice, y_a, NTERMS=4, ESTIMATE=y_a  )
   OPLOT, y_gfit, LINESTYLE=2

   PRINT, 'X coeff: ', x_a, $
    FORMAT='(A,F8.3,1X,F8.3,1X,F8.3,1X,F8.3,1X,F8.3)'
   PRINT, 'Y coeff: ', y_a, $
    FORMAT='(A,F8.3,1X,F8.3,1X,F8.3,1X,F8.3,1X,F8.3)'


   cx_center = x_a[1] + ( xcenter - width )
   cy_center = y_a[1] + ( ycenter - width )
   
   c_swath_width = FIX( (x_a[2] > y_a[2]) * 1.5 ) > 3
   c_template_width = c_swath_width
   c_width = width
   c_search_width = (c_width - c_template_width) - 1

   WIDGET_CONTROL, sState.wFitTypeButton, SET_VALUE=fit_type
   WIDGET_CONTROL, sState.wCenterXField, SET_VALUE=cx_center
   WIDGET_CONTROL, sState.wCenterYField, SET_VALUE=cy_center
   WIDGET_CONTROL, sState.wWidthTemplateField, SET_VALUE=c_template_width
   WIDGET_CONTROL, sState.wWidthSearchField, SET_VALUE=c_search_width
   WIDGET_CONTROL, sState.wWidthSwathField, SET_VALUE=c_swath_width
   WIDGET_CONTROL, sState.wWidthField, SET_VALUE=c_width

   det_xcenter = cx_center + ccdycor
   det_ycenter = cy_center + ccdxcor
   strFormat = '("configuration done, center: [",I0,",",I0,"]")'
   strMessage = STRING( FORMAT=strFormat, det_xcenter, det_ycenter )
   stmr_wmessage, sState, strMessage

   !P.MULTI = saved_pmulti
   WSET, saved_window

   return
END 

; _____________________________________________________________________________

PRO stmr_show_about_event, sEvent

   WIDGET_CONTROL, sEvent.id, GET_UVALUE=event_uval
   
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

PRO stmr_show_about, sState

   version = sState.version
   version_date = sState.version_date

   wintitle =  STRING( FORMAT='("About Stammre (v",A,")")', version )

   message = [ STRING( FORMAT='("Stammre version",1X,A)', version ), $
               'written by: William Jon McCann', $
               'JHU Advanced Camera for Surveys', $
               version_date ]

   wBase = WIDGET_BASE( TITLE=wintitle, GROUP=sState.wRoot, /COLUMN )

   wLabels = LONARR( N_ELEMENTS( message ) )

   wLabels[0] = WIDGET_LABEL( wBase, VALUE=message[0], $
                        FONT='helvetica*20', /ALIGN_CENTER )
   FOR i = 1, N_ELEMENTS( message ) - 1 DO BEGIN
      wLabels[i] = WIDGET_LABEL( wBase, VALUE=message[i], $
                           FONT='helvetica*14', /ALIGN_CENTER )
   ENDFOR

   wButton = WIDGET_BUTTON( wBase, VALUE='OK', /ALIGN_CENTER, $
                          UVALUE='OK_BUTTON' )

   WIDGET_CONTROL, wBase, /REALIZE

   XMANAGER, 'stmr_show_about', wBase, /NO_BLOCK

END

; _____________________________________________________________________________

PRO stmr_show_help_event, sEvent

   WIDGET_CONTROL, sEvent.id, GET_UVALUE=event_uval
   
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

PRO stmr_show_help, sState

   version = sState.version
   version_date = sState.version_date

   wintitle =  STRING( FORMAT='("Stammre Help (v",A,")")', version )

   aMessage=[STRING( FORMAT='("Stammre version",1X,A)', version ), $
             'To open an existing session enter the database entry number of the first', $
             '   image in the sequence into the Template entry field and hit RETURN or', $
             '   select one of the session files from the File/Open dialog.', $
             'To start a new session enter the database entry of the initial image', $
             '   into the Template entry field and hit RETURN.', $
             'To start tracking set the Last entry to -1 and turn Auto track ON.' ]
   
   wBase = WIDGET_BASE( TITLE=wintitle, GROUP=sState.wRoot, /COLUMN )

   wLabels = LONARR( N_ELEMENTS( aMessage ) )

   wLabels[0] = WIDGET_LABEL( wBase, VALUE=aMessage[0], $
                        FONT='helvetica*20', /ALIGN_CENTER )
   FOR i = 1, N_ELEMENTS( aMessage ) - 1 DO BEGIN
      wLabels[i] = WIDGET_LABEL( wBase, VALUE=aMessage[i], $
                           FONT='helvetica*14', /ALIGN_LEFT )
   ENDFOR

   wButton = WIDGET_BUTTON( wBase, VALUE='OK', /ALIGN_CENTER, $
                            UVALUE='OK_BUTTON' )

   WIDGET_CONTROL, wBase, /REALIZE

   XMANAGER, 'stmr_show_help', wBase, /NO_BLOCK

END 

; _____________________________________________________________________________

PRO stmr_plot_widget_event, sEvent

   wLocalStateHandler = WIDGET_INFO( sEvent.handler, /CHILD )
   WIDGET_CONTROL, wLocalStateHandler, GET_UVALUE=sLocalState, /NO_COPY

;   WIDGET_CONTROL, sLocalState.wStateHandler, $
;    GET_UVALUE=sGlobalState, /NO_COPY

   struct_name = TAG_NAMES( sEvent, /STRUCTURE_NAME)
   
   IF STRUPCASE( struct_name ) EQ 'WIDGET_BASE' THEN BEGIN
      screen_size = GET_SCREEN_SIZE()
      newx = (sEvent.x-10) < (screen_size[0]-30)
      newy = (sEvent.y-10) < (screen_size[1]-30)

      WIDGET_CONTROL, sLocalState.wDraw, XSIZE=newx, YSIZE=newy

   ENDIF ELSE BEGIN

      WIDGET_CONTROL, sEvent.id, GET_UVALUE=event_uval

      CASE STRUPCASE( event_uval ) OF

         'PLOT_DRAW': BEGIN
            saved_window = !D.WINDOW
            WSET, sLocalState.draw_index
            data_coord = CONVERT_COORD( sEvent.x, sEvent.y, /DEVICE, /TO_DATA )
            strOut = STRING( FORMAT='("Image stability",5X,"[",F9.3,",",F9.3,"]")', $
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

;   WIDGET_CONTROL, sLocalState.wStateHandler, $
;    SET_UVALUE=sGlobalState, /NO_COPY
   
   WIDGET_CONTROL, wLocalStateHandler, SET_UVALUE=sLocalState, /NO_COPY
END

; _____________________________________________________________________________

PRO stmr_plot_widget, TopLevelBase, wPlotDraw, $
                 STATE_HANDLER = wStateHandler

   wRoot = WIDGET_BASE( GROUP_LEADER=TopLevelBase, /COLUMN, $
                        TITLE='Image stability', $
                        UVALUE='PLOT_BASE', $
                        TLB_FRAME_ATTR=8, $
                        /TLB_SIZE_EVENTS )
   wBase = WIDGET_BASE(wRoot, XPAD=0, YPAD=0, SPACE=0, /COLUMN, /ALIGN_CENTER)

   wPlotBase = WIDGET_BASE(wBase, XPAD=0, YPAD=0, SPACE=0, /COLUMN)
   screen_size = GET_SCREEN_SIZE()
   wPlotDraw = WIDGET_DRAW( wPlotBase, XSIZE=screen_size[0]-30, YSIZE=400, $
                            /MOTION_EVENTS, /BUTTON_EVENTS, $
                            UVALUE='PLOT_DRAW', COLORS=-2, RETAIN=2 )

   WIDGET_CONTROL, /REALIZE, wRoot
   WIDGET_CONTROL, wRoot, TLB_SET_XOFFSET=0, TLB_SET_YOFFSET=0
   WIDGET_CONTROL, GET_VALUE=draw_index, wPlotDraw
   WSHOW, draw_index

   ;;PLOT, [0,1], [0,1], /NODATA

   sState = { wRoot: wRoot, $
              wBase: wBase, $
              wDraw: wPlotDraw, $
              wStateHandler: wStateHandler, $
              draw_index: draw_index }

   WIDGET_CONTROL, wBase, SET_UVALUE=sState, /NO_COPY

   XMANAGER, 'stmr_plot_widget', wRoot, /NO_BLOCK
   
END

; _____________________________________________________________________________

PRO stmr_update_plot, sState, PS=postscript, PRINT=print, $
                      UPDATE=update

   output_device = (KEYWORD_SET(postscript)) ? 'PS' : 'X'

   WIDGET_CONTROL, sState.wConfigField, GET_VALUE=strConfig
   WIDGET_CONTROL, sState.wFitTypeButton, GET_VALUE=bFitType
   WIDGET_CONTROL, sState.wTemplateIdField, GET_VALUE=iTemplateId
   WIDGET_CONTROL, sState.wFirstIdField, GET_VALUE=iFirstId
   WIDGET_CONTROL, sState.wLastIdField, GET_VALUE=iLastId
   WIDGET_CONTROL, sState.wCenterXField, GET_VALUE=iCenterX
   WIDGET_CONTROL, sState.wCenterYField, GET_VALUE=iCenterY

   WIDGET_CONTROL, sState.wPlotXminField, GET_VALUE=fPlotXmin
   WIDGET_CONTROL, sState.wPlotXmaxField, GET_VALUE=fPlotXmax
   WIDGET_CONTROL, sState.wPlotYminField, GET_VALUE=fPlotYmin
   WIDGET_CONTROL, sState.wPlotYmaxField, GET_VALUE=fPlotYmax

                    ; read existing log file
   IF stmr_has_state_data(sState) THEN BEGIN
      ids = stmr_get_state_entries(sState)
      mjd = stmr_get_state_times(sState)
      x = stmr_get_state_xcoords(sState)
      y = stmr_get_state_ycoords(sState)

      IF output_device EQ 'PS' THEN BEGIN
         saved_device = !D.NAME
         SET_PLOT, 'PS'
         strPSfile = stmr_get_ps_filename(iTemplateId[0])
         DEVICE, FILENAME=strPSfile, /LANDSCAPE, /COLOR, BITS_PER_PIXEL=8
         font_type = 0
      ENDIF ELSE BEGIN
         saved_window = !D.WINDOW
         WSET, sState.draw_index
      ENDELSE 
                    ; plot data
      IF PTR_VALID( sState.pEventList ) THEN BEGIN
         event_times = *sState.pTimeList
         event_values = *sState.pEventList
      ENDIF

      stmr_plot_data, ids, x, y, mjd, CONFIG=strConfig[0], $
       EVENT_TIMES=event_times, EVENT_VALUES=event_values, $
       FIRST=iFirstId[0], LAST=iLastId[0], FONT=font_type, $
       XMIN=fPlotXmin, XMAX=fPlotXmax, YMIN=fPlotYmin, YMAX=fPlotYmax, $
       TEMPLATEID=iTemplateId[0], $
       XCENTER=iCenterX[0], YCENTER=iCenterY[0], $
       FIT_TYPE=bFitType

      IF output_device EQ 'PS' THEN BEGIN
         DEVICE, /CLOSE
         SET_PLOT, saved_device
         IF KEYWORD_SET(print) THEN BEGIN
            stmr_wmessage, sState, 'Executing print command...'
            detector =  stmr_get_detector_of_entries(iTemplateId[0])
            IF KEYWORD_SET(update) THEN $
             strCmd = stmr_get_update_lp_command(strPSfile,detector) $
            ELSE strCmd = stmr_get_lp_command(strPSfile,detector)
            SPAWN, strCmd
            stmr_wmessage, sState, 'done.'
         ENDIF
      ENDIF ELSE BEGIN
         WSET, saved_window
      ENDELSE
   ENDIF ELSE stmr_wmessage, sState, 'no data to plot'

END

; _____________________________________________________________________________

PRO stmr_event_add, sState, time, value
   mjd = parse_time_stamp(time, /MJD)
   IF mjd GT 0 THEN BEGIN
      new_time = get_time_stamp(mjd, /MJD)
      IF PTR_VALID(sState.pEventList) THEN BEGIN
         aEventList = *sState.pEventList
         aEventList = [aEventList,value]
         aTimeList = *sState.pTimeList
         aTimeList = [aTimeList, new_time]
      ENDIF ELSE BEGIN
         aEventList = value
         aTimeList = new_time
      ENDELSE
      PTR_FREE, sState.pEventList, sState.pTimeList

      sState.pEventList = PTR_NEW(aEventList, /NO_COPY)
      sState.pTimeList = PTR_NEW(aTimeList, /NO_COPY)
      stmr_update_event_display, sState
      stmr_save_session, sState
      stmr_update_plot, sState
   ENDIF ELSE BEGIN
      strMessage = 'error parsing time stamp'
      stmr_wmessage, sState, strMessage
   ENDELSE 
END 

; _____________________________________________________________________________

FUNCTION stmr_get_data_interval, first_entry, latest_entry, detector

                    ; Get the difference between the start times of
                    ; the last 5 dumps for this detector
   search = 'entry>'+STRTRIM(first_entry,2)+',detector='+STRTRIM(detector,2)
   list = dbfind(search,/SILENT)
   IF list[0] LE 0 THEN return, 0
   DBEXT, list, 'expstart,filename', aExpStart, aFilename
   aFilename = STRTRIM(aFilename,2)
                    ; get first images
   regex = '_1$'
   first = STREGEX(aFilename,regex)
   good = WHERE(first NE -1, ngood)
   data_interval = 0.0
   IF ngood GT 1 THEN BEGIN
      times = aExpStart[good]
      
      aIntervals = SHIFT(times, -1) - times
      good = WHERE(aIntervals GT 0, ngood)
      IF ngood GT 0 THEN BEGIN
         data_interval = MEDIAN(aIntervals[good])
      ENDIF
   ENDIF ELSE data_interval = 0

   return, data_interval
END 

; _____________________________________________________________________________

FUNCTION stmr_get_countdown_message, INTERVAL=data_interval, $
                                     LAST_TIME=last_time

   IF N_ELEMENTS(data_interval) GT 0 THEN BEGIN
      current_time = SYSTIME(/JULIAN)
      IF N_ELEMENTS(last_time) LE 0 THEN last_time = current_time
      next_time = last_time + data_interval
      delta_time = next_time - current_time
      IF ABS(delta_time) GT 1.0 THEN time_unit = 'days' ELSE BEGIN
         delta_time = delta_time * 24.0
         IF ABS(delta_time) GT 1.0 THEN time_unit = 'hours' ELSE BEGIN
            delta_time = delta_time * 60.0
            IF ABS(delta_time) GT 1.0 THEN time_unit = 'minutes' ELSE BEGIN
               delta_time = delta_time * 60.0
               time_unit = 'seconds'
            ENDELSE
         ENDELSE
      ENDELSE
      
      IF time_unit EQ 'seconds' THEN BEGIN
         strFormat = '("expect data in",1X,I0,1X,A)'
      ENDIF ELSE BEGIN
         delta_time = STRING(FORMAT='(F6.2)', delta_time)
         delta_time = STRTRIM(delta_time, 2)
         strFormat = '("expect data in",1X,A,1X,A)'
      ENDELSE
      strMessage = STRING(FORMAT=strFormat, delta_time, time_unit)
   ENDIF ELSE BEGIN
      strMessage = 'waiting for new data...'
   ENDELSE

   return, strMessage
END
; _____________________________________________________________________________

PRO stammre_event, sEvent

                    ; get state information from first child of root
   wChildBase = WIDGET_INFO( sEvent.handler, /CHILD )
   wStateHandler = WIDGET_INFO( wChildBase, /SIBLING )
   WIDGET_CONTROL, wStateHandler, GET_UVALUE=sState, /NO_COPY 

   junk = WHERE( 'UVALUE' EQ TAG_NAMES( sEvent ), uvcount )
   IF uvcount LE 0 THEN $
    WIDGET_CONTROL, sEvent.id, GET_UVALUE=event_uval $
   ELSE event_uval = sEvent.UVALUE

   CASE STRUPCASE( event_uval ) OF

      'ROOT': BEGIN
         IF TAG_NAMES( sEvent, /STRUCTURE_NAME) EQ 'WIDGET_KILL_REQUEST' $
          THEN BEGIN
            IF sState.auto_track NE 1b THEN BEGIN
               stmr_free_pointers, sState
               WIDGET_CONTROL, sEvent.top, /DESTROY
               return
            ENDIF 
         ENDIF
      END 

      'EVENT_LIST':

      'TEMPLATEID_FIELD': BEGIN
         template_id = sEvent.value
         IF template_id GT 0 THEN BEGIN
            stmr_open_session, sState, template_id, ERROR=error_flag
            IF error_flag GT 0 THEN stmr_new_session, sState, template_id $
            ELSE stmr_update_plot, sState
         ENDIF
      END 

      'PLOT_BUTTON': BEGIN
         stmr_update_plot, sState
      END

      'HARDCOPY_BUTTON': BEGIN
         stmr_update_plot, sState, /PS, /PRINT
      END

      'CONFIGURE_BUTTON': BEGIN
         IF sState.auto_track NE 1b THEN BEGIN
            IF stmr_config_is_good(sState) THEN $
             stmr_auto_configure, sState
         ENDIF
      END 

      'RECALCULATE_BUTTON': BEGIN
         IF sState.auto_track NE 1b THEN BEGIN
            aMessage = ['Do you really wish to recalculate', $
                        'the entire data set?', '',$
                        'Warning, existing data will be lost.']
            result = DIALOG_MESSAGE(aMessage,/QUESTION,/DEFAULT_NO,$
                                    DIALOG_PARENT=sState.wRoot)
            IF stmr_config_is_good(sState) AND result EQ 'Yes' THEN BEGIN
               stmr_save_session, sState
               stmr_process_data, sState, /RECALCULATE, UPDATE=update, $
                ERROR=error_code
               IF error_code[0] NE 0 THEN BEGIN
                  update = 0b
                  ;;stmr_wmessage, sState, 'Database is not available.'
               ENDIF 
               IF update[0] EQ 1 THEN BEGIN
                  stmr_update_plot, sState
                  IF sState.hardcopy_on_update THEN BEGIN
                     stmr_update_plot, sState, /PS, /UPDATE, /PRINT
                  ENDIF 
               ENDIF
            ENDIF
         ENDIF
      END 

      'MENU': BEGIN
         CASE sEvent.value OF

            'File.New': BEGIN
               IF sState.auto_track NE 1b THEN stmr_new_session, sState
            END

            'File.Open': BEGIN
               IF sState.auto_track NE 1b THEN BEGIN
                  stmr_open_session, sState, ERROR=error_flag
                  IF error_flag EQ 0 THEN BEGIN
                     stmr_update_plot, sState
                  ENDIF 
               ENDIF 
            END

            'File.Save': BEGIN
               IF sState.write_permission GT 0 THEN BEGIN
                  stmr_save_session, sState
               ENDIF ELSE BEGIN
                  strMessage = "error: don't have write permission"
                  stmr_wmessage, sState, strMessage
               ENDELSE
            END

            'File.Exit': BEGIN
               IF sState.auto_track NE 1b THEN BEGIN
                  stmr_free_pointers, sState
                  WIDGET_CONTROL, sEvent.top, /DESTROY
                  return
               ENDIF
            END 

            'Event.Add': BEGIN
               index = WIDGET_INFO( sState.wEventList, /LIST_SELECT )
               IF index[0] NE -1 THEN BEGIN
                  IF PTR_VALID( sState.pEventList ) THEN BEGIN
                     time = (*sState.pTimeList)[index[0]]
                     ;;value = (*sState.pEventList)[index[0]]
                  ENDIF ELSE BEGIN
                  ENDELSE
               ENDIF ELSE BEGIN
               ENDELSE 

               strTitle = 'Enter new event'
               sNewEvent = x_get_event( GROUP=sEvent.top, VALUE=value, $
                                        TIME_VALUE=time, $
                                        STATUS=error_status, /STRUCTURE, $
                                        TITLE=strTitle )
               IF error_status EQ 1 THEN BEGIN
                  new_time = sNewEvent.time
                  stmr_event_add, sState, sNewEvent.time, sNewEvent.value
               ENDIF
            END
            
            'Event.Edit': BEGIN
               index = WIDGET_INFO( sState.wEventList, /LIST_SELECT )

               IF index[0] NE -1 THEN BEGIN
                  IF PTR_VALID( sState.pEventList ) THEN BEGIN
                     aEventList = *sState.pEventList
                     aTimeList = *sState.pTimeList

                     time = aTimeList[index[0]]
                     value = aEventList[index[0]]
                     
                     strTitle = 'Edit event'
                     sNewEvent = x_get_event( GROUP=sEvent.top, $
                                              VALUE=value, $
                                              TIME_VALUE=time, $
                                              STATUS=error_status, $
                                              /STRUCTURE, TITLE=strTitle )
                     IF error_status EQ 1 THEN BEGIN

                        aEventList[index[0]] = sNewEvent.value
                        aTimeList[index[0]] = sNewEvent.time

                        PTR_FREE, sState.pEventList, sState.pTimeList
                        sState.pEventList = PTR_NEW( aEventList, /NO_COPY )
                        sState.pTimeList = PTR_NEW( aTimeList, /NO_COPY )

                        stmr_update_event_display, sState
                        stmr_save_session, sState
                     ENDIF
                  ENDIF
               ENDIF
            END
            
            'Event.Remove': BEGIN
               index = WIDGET_INFO( sState.wEventList, /LIST_SELECT )
               
               IF index[0] NE -1 THEN BEGIN
                  IF PTR_VALID( sState.pEventList ) THEN BEGIN
                     aEventList = *sState.pEventList
                     aTimeList = *sState.pTimeList

                     all_index = LINDGEN( N_ELEMENTS( aEventList ) )
                     good_index = WHERE( all_index NE index, wcount )

                     IF wcount GT 0 THEN BEGIN                        
                        aEventList = aEventList[good_index]
                        aTimeList = aTimeList[good_index]
                        PTR_FREE, sState.pEventList, sState.pTimeList
                        sState.pEventList = PTR_NEW( aEventList, /NO_COPY )
                        sState.pTimeList = PTR_NEW( aTimeList, /NO_COPY )
                     ENDIF ELSE BEGIN
                    ; could be only one event in list
                        IF index[0] EQ 0 THEN BEGIN
                           PTR_FREE, sState.pEventList, sState.pTimeList
                           sState.pEventList = PTR_NEW()
                           sState.pTimeList = PTR_NEW()
                        ENDIF
                     ENDELSE
                     stmr_update_event_display, sState
                     stmr_save_session, sState
                  ENDIF
               ENDIF
            END 
            'Help.About': stmr_show_about, sState
            'Help.Help': stmr_show_help, sState
            ELSE:
         ENDCASE 

      END
      
      'AUTO_DROPLIST': BEGIN
         IF WIDGET_INFO(sState.wAutoDropList, /DROPLIST_SELECT) EQ 1 THEN BEGIN
            IF stmr_config_is_good(sState) THEN BEGIN
               stmr_turn_auto_on,sState
            ENDIF ELSE stmr_turn_auto_off,sState
         ENDIF ELSE BEGIN
            
            stmr_turn_auto_off, sState
            stmr_wmessage, sState, ' '
         ENDELSE
      END

      'TIMER_EVENT': BEGIN
         IF sState.auto_track EQ 1 THEN BEGIN
            
            WIDGET_CONTROL, sState.wFirstIdField, GET_VALUE=iFirstId
            WIDGET_CONTROL, sState.wTemplateIdField, GET_VALUE=iTemplateId
            
            latest_entry = stmr_get_latest_entry(ERROR=error_code)
            IF error_code[0] NE 0 THEN GOTO, done
            n_entries = latest_entry - iFirstId[0]
            last_entry = sState.last_entry

            IF sState.write_permission GT 0 THEN BEGIN
               data_ready = latest_entry GT last_entry
               check_times = stmr_get_time_of_entries([iTemplateId[0],$
                                                       latest_entry[0]])
               time_is_right = check_times[0] LT check_times[1]
               IF NOT time_is_right THEN BEGIN
                  strMessage = 'Time for new entries is not correct.'
                  PRINT, strMessage
                  stmr_wmessage, sState, strMessage
               ENDIF 
               data_ready = data_ready AND time_is_right
            ENDIF ELSE BEGIN
               last_size = sState.data_file_size
               log_size = stmr_get_log_file_size(iTemplateId)
               data_ready = last_size NE log_size
            ENDELSE 

            latest_entry = LONG(latest_entry[0])
            IF data_ready THEN BEGIN
               stmr_wmessage, sState, 'Processing new data...'
               current_time = SYSTIME(/JULIAN)
               IF sState.write_permission GT 0 THEN BEGIN
                  stmr_process_data, sState, UPDATE=update, ERROR=error_code
               ENDIF ELSE BEGIN
                  stmr_process_readonly, sState, ERROR=error_code
               ENDELSE 

               IF KEYWORD_SET(update) THEN BEGIN
                  sState.last_time = current_time
                  stmr_update_plot, sState
                  IF sState.hardcopy_on_update THEN BEGIN
                     stmr_update_plot, sState, /PS, /PRINT, /UPDATE
                  ENDIF

                  IF (n_entries GT 5) AND (sState.last_time GT 0) THEN BEGIN
                    ; update data interval
                     detector = stmr_get_detector_of_entries(iFirstId[0])
                     data_interval = stmr_get_data_interval(iFirstId[0],$
                                                            latest_entry[0],$
                                                            detector[0])
                     sState.data_interval = DOUBLE(data_interval)
                  ENDIF
                  
               ENDIF
                    ; update file size for readonly
               IF N_ELEMENTS(log_size) GT 0 THEN BEGIN
                  sState.data_file_size = LONG(log_size)
               ENDIF

            ENDIF ELSE BEGIN
               IF sState.data_interval GT 0 THEN $
                data_interval=sState.data_interval
               strMessage=stmr_get_countdown_message(INTERVAL=data_interval,$
                                                     LAST_TIME=sState.last_time)
               stmr_wmessage, sState, strMessage
            ENDELSE
                    ; generate a timer event
            WIDGET_CONTROL, sState.wBase, /CLEAR_EVENTS
            WIDGET_CONTROL, sState.wNewDataTimer, TIMER=5
         ENDIF
      END

      ELSE: HELP, /STR, sEvent
   ENDCASE
done:

   IF WIDGET_INFO( wStateHandler, /VALID_ID ) EQ 1 THEN BEGIN
                    ; restore state information
      WIDGET_CONTROL, wStateHandler, SET_UVALUE=sState, /NO_COPY
   ENDIF 

   return
END

; _____________________________________________________________________________

PRO stammre, entry, GROUP_LEADER=group_leader, WRITE=write_permission

; ______________________________________
;
; Check input
; ______________________________________

   instance_number = XREGISTERED( 'stammre' )
   IF instance_number GT 0 THEN BEGIN
      return
   ENDIF

   LOADCT, 39       ; Rainbow + white color table
   WINDOW, /FREE, XSIZE=2, YSIZE=2, COLORS=64
   temp_window = !D.WINDOW
; ______________________________________

; Define some stuff
; ______________________________________

   strVersion = rcs_revision( ' $Revision: 1.15 $ ' )
   strVersion_date = rcs_date( ' $Date: 2002/01/14 18:03:31 $ ' )

   strTLBTitle = STRING( FORMAT='("Stammre (v",A,")")', strVersion )

   IF KEYWORD_SET( write_permission ) THEN BEGIN
      aMenuList = [ '1\File', $
                    '0\New', '0\Open', '0\Save', '2\Exit', $
                    '1\Event', '0\Add', '0\Edit', '2\Remove', $
                    '1\Help', '0\Help', '2\About' ]
   ENDIF ELSE BEGIN
      strTLBTitle = strTLBTitle + ' - read only' 
      aMenuList = [ '1\File', $
                    '0\New', '0\Open', '2\Exit', $
                    '1\Help', '0\Help', '2\About' ]
   ENDELSE 

   latest_entry = stmr_get_latest_entry(ERROR=error_code)
   IF error_code[0] NE 0 THEN BEGIN
      MESSAGE, 'Database not available', /CONTINUE
      return
   ENDIF 
   
   default_config = 'Square/dolly'

   IF N_ELEMENTS( entry ) GT 0 THEN $
    default_templateid = entry $
   ELSE default_templateid = latest_entry

   default_centerx = 100
   default_centery = 100
   default_width = 70
   default_search_width = 15
   default_swath_width = 39
   default_template_width = 39

; ______________________________________

; Build Widget
; ______________________________________


   wRoot = WIDGET_BASE( GROUP_LEADER=group_leader, UVALUE='ROOT', $
                        TITLE=strTLBTitle, $
                        /COLUMN, /MAP, MBAR=wMbar, /TLB_KILL_REQUEST_EVENTS, $
                        RESOURCE_NAME='stammre', RNAME_MBAR='menubar' )

   wBase = WIDGET_BASE( wRoot, /COLUMN )

   wMenuBar = CW_PDMENU( wMbar, /RETURN_FULL_NAME, /MBAR, /HELP, $
                         aMenuList, UVALUE='MENU' )

   wEventList = WIDGET_LIST( wBase, UVALUE='EVENT_LIST', XSIZE=30, YSIZE=5, $
                             /MULTIPLE )

   wButtonBase = WIDGET_BASE( wBase, /ROW, UVALUE='BUTTON_BASE' )

   wPlotButton = WIDGET_BUTTON( wButtonBase, VALUE='Plot', $
                                UVALUE='PLOT_BUTTON' )
   wHardcopyButton = WIDGET_BUTTON( wButtonBase, VALUE='Hardcopy', $
                                    UVALUE='HARDCOPY_BUTTON' )
   wAutoDropList = WIDGET_DROPLIST( wButtonBase, VALUE=['Off','On'], $
                                    UVALUE='AUTO_DROPLIST', /FRAME, $
                                    TITLE='Auto track' )

   wConfigureButton = WIDGET_BUTTON( wButtonBase, VALUE='Configure', $
                                    UVALUE='CONFIGURE_BUTTON' )
   wRecalculateButton = WIDGET_BUTTON( wButtonBase, VALUE='Recalculate', $
                                    UVALUE='RECALCULATE_BUTTON' )


   wDummyBase = WIDGET_BASE( wBase, UVALUE='TIMER_EVENT' )

   wParamBase = WIDGET_BASE( wBase, /COLUMN, /FRAME, UVALUE='PARAM_BASE' )

   wTemplateIdField = CW_FIELD( wParamBase, /LONG, VALUE=latest_entry, $
                                XSIZE=6, UVALUE='TEMPLATEID_FIELD', $
                                TITLE='Template entry ', FONT='courier', $
                                /RETURN_EVENTS )
   
   strValue = default_config
   wConfigField = CW_FIELD( wParamBase, /STRING, VALUE=strValue, $
                            UVALUE='CONFIG_FIELD', XSIZE=45, FONT='courier', $
                            TITLE='Configuration  ' )

   aFitTypeButtons = [ 'Cross correlation', 'Gaussian fit' ]
   wFitTypeButton = CW_BGROUP( wParamBase, aFitTypeButtons, /EXCLUSIVE, FONT='courier', $
                               UVALUE='FIT_TYPE_BUTTON', /ROW, SET_VALUE=0 )

   wParamGridBase = WIDGET_BASE( wParamBase, /ROW )
   wParamCol1Base = WIDGET_BASE(wParamGridBase,/COLUMN, UVALUE='PARAMC1_BASE' )
   wParamCol2Base = WIDGET_BASE(wParamGridBase,/COLUMN, UVALUE='PARAMC2_BASE' )


   wFirstIdField = CW_FIELD( wParamCol1Base, /LONG, VALUE=latest_entry, $
                             XSIZE=6, UVALUE='FIRSTID_FIELD', FONT='courier', $
                             TITLE='First entry           ' )

   wLastIdField = CW_FIELD( wParamCol2Base, /LONG, VALUE='-1', FONT='courier', $
                             XSIZE=6, UVALUE='LASTID_FIELD', $
                             TITLE='Last entry        ' )

   iValue = default_centerx
   wCenterXField = CW_FIELD( wParamCol1Base, /INTEGER, VALUE=iValue, $
                             XSIZE=6, UVALUE='CENTERX_FIELD', FONT='courier', $
                             TITLE='X center              ' )
   iValue = default_centery
   wCenterYField = CW_FIELD( wParamCol2Base, /INTEGER, VALUE=iValue, $
                             XSIZE=6, UVALUE='CENTERY_FIELD', FONT='courier', $
                             TITLE='Y center          ' )

   iValue = default_template_width
   wWidthTemplateField = CW_FIELD( wParamCol1Base, /INTEGER, VALUE=iValue, $
                                   XSIZE=6, UVALUE='TEMPLATE_WIDTH_FIELD', $
                                   TITLE='Template width (half) ', FONT='courier' )
   iValue = default_width
   wWidthField = CW_FIELD( wParamCol2Base, /INTEGER, VALUE=iValue, $
                           XSIZE=6, UVALUE='WIDTH_FIELD', FONT='courier', $
                           TITLE='Width (half)      ' )

   iValue = default_search_width
   wWidthSearchField = CW_FIELD( wParamCol1Base, /INTEGER, VALUE=iValue, $
                                 XSIZE=6, UVALUE='SEARCH_WIDTH_FIELD', FONT='courier', $
                                 TITLE='Search width (half)   ' )

   iValue = default_swath_width
   wWidthSwathField = CW_FIELD( wParamCol2Base, /INTEGER, VALUE=iValue, $
                                XSIZE=6, UVALUE='SWATH_WIDTH_FIELD', FONT='courier', $
                                TITLE='Swath width (half)' )

   wPlotBase = WIDGET_BASE( wBase, /COLUMN, UVALUE='PLOT_BASE' )
   wPlotGridBase = WIDGET_BASE( wPlotBase, /ROW )
   wPlotCol1Base = WIDGET_BASE(wPlotGridBase,/COLUMN, UVALUE='PLOTC1_BASE' )
   wPlotCol2Base = WIDGET_BASE(wPlotGridBase,/COLUMN, UVALUE='PLOTC2_BASE' )

   wPlotXminField = CW_FIELD( wPlotCol1Base, /FLOAT, FONT='courier', $
                              VALUE=default_plot_xmin, $
                              XSIZE=6, UVALUE='PLOT_XMIN_FIELD', $
                              TITLE='Plot X min            ' )

   wPlotXmaxField = CW_FIELD( wPlotCol2Base, /FLOAT, FONT='courier', $
                              VALUE=default_plot_xmax, $
                              XSIZE=6, UVALUE='PLOT_XMAX_FIELD', $
                              TITLE='Plot X max        ' )

   wPlotYminField = CW_FIELD( wPlotCol1Base, /FLOAT, FONT='courier', $
                              VALUE=default_plot_ymin, $
                              XSIZE=6, UVALUE='PLOT_YMIN_FIELD', $
                              TITLE='Plot Y min            ' )

   wPlotYmaxField = CW_FIELD( wPlotCol2Base, /FLOAT, FONT='courier', $
                              VALUE=default_plot_ymax, $
                              XSIZE=6, UVALUE='PLOT_YMAX_FIELD', $
                              TITLE='Plot Y max        ' )

   wMessageText = WIDGET_TEXT( wBase, YSIZE = 1, UVALUE='MESSAGE_TEXT' )

   stmr_plot_widget, wRoot, wPlotDraw, STATE_HANDLER=wBase
   WIDGET_CONTROL, wPlotDraw, GET_VALUE=draw_index

   WIDGET_CONTROL, /REALIZE, wBase

; ______________________________________

; Setup Widget State
; ______________________________________

   IF NOT KEYWORD_SET( write_permission ) THEN BEGIN
      ;;WIDGET_CONTROL, wConfigureButton, SENSITIVE=0
      WIDGET_CONTROL, wRecalculateButton, SENSITIVE=0
   ENDIF 

; ______________________________________

; Define Widget State Structure
; ______________________________________

   sState = { $
             wRoot: wRoot, $ ;  ______________________ Widgets
             wBase: wBase, $
             wParamBase: wParamBase, $
             wNewDataTimer: wDummyBase, $
             wEventList: wEventList, $
             wAutoDropList: wAutoDropList, $
             wPlotButton: wPlotButton, $
             wHardcopyButton: wHardcopyButton, $
             wConfigureButton: wConfigureButton, $
             wRecalculateButton: wRecalculateButton, $
             wConfigField: wConfigField, $
             wTemplateIdField: wTemplateIdField, $
             wFirstIdField: wFirstIdField, $
             wFitTypeButton: wFitTypeButton, $
             wLastIdField: wLastIdField, $
             wCenterXField: wCenterXField, $
             wCenterYField: wCenterYField, $
             wWidthTemplateField: wWidthTemplateField, $
             wWidthField: wWidthField, $
             wWidthSearchField: wWidthSearchField, $
             wWidthSwathField: wWidthSwathField, $
             wPlotXminField: wPlotXminField, $
             wPlotXmaxField: wPlotXmaxField, $
             wPlotYminField: wPlotYminField, $
             wPlotYmaxField: wPlotYmaxField, $
             wMessageText: wMessageText, $
             wPlotDraw: wPlotDraw, $
             pTimeList: PTR_NEW(), $ ;  _______________ Pointers
             pEventList: PTR_NEW(), $
             pEntries: PTR_NEW(), $
             pTimes: PTR_NEW(), $
             pXcoords: PTR_NEW(), $
             pYcoords: PTR_NEW(), $
             version: strVersion, $
             version_date: strVersion_date, $
             draw_index: draw_index, $
             auto_track: 0b, $
             write_permission: BYTE(KEYWORD_SET(write_permission)), $
             hardcopy_on_update: BYTE(KEYWORD_SET(write_permission)), $
             data_file_size: 0l, $
             data_interval: 0d, $
             session_has_data: 0b, $
             last_time: -1d, $
             last_entry: LONG(latest_entry) $
            }

; ______________________________________

; Update Widget and hand off
; ______________________________________

   IF N_ELEMENTS( entry ) GT 0 THEN BEGIN
      stmr_open_session, sState, entry
      stmr_update_plot, sState
   ENDIF 

                    ; restore state information
   WIDGET_CONTROL, wBase, SET_UVALUE=sState, /NO_COPY   

   WDELETE, temp_window
   WIDGET_CONTROL, wRoot, /CLEAR_EVENTS
   XMANAGER, 'stammre', wRoot, /NO_BLOCK

END

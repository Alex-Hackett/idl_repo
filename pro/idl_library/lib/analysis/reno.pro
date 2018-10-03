;+
; $Id: reno.pro,v 1.14 2002/01/28 21:57:29 mccannwj Exp $
;
; NAME:
;     RENO
;
; PURPOSE:
;     Detector read noise monitor.
;
; CATEGORY:
;     ACS/analysis
;
; CALLING SEQUENCE:
;     RENO [, /WRITE ]
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
;     RENO_LP_COMMAND                    lp %s
;     RENO_UPDATE_LP_COMMAND             none
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

PRO reno_free_data_pointers, sState
   PTR_FREE, sState.pEntries, $
    sState.pTimes,sState.pNoise,sState.pAmps,sState.pBiaslevel
END 

PRO reno_free_event_pointers, sState
   PTR_FREE, sState.pTimeList,sState.pEventList
END 
; _____________________________________________________________________________

PRO reno_free_pointers, sState
   reno_free_event_pointers, sState
   reno_free_data_pointers, sState
END 

PRO reno_zero_pointers, sState
   sState.pEntries = PTR_NEW()
   sState.pTimes = PTR_NEW()
   sState.pNoise = PTR_NEW()
   sState.pAmps = PTR_NEW()
   sState.pBiaslevel = PTR_NEW()
   sState.pEventList = PTR_NEW()
   sState.pTimeList = PTR_NEW()
END 
; _____________________________________________________________________________

FUNCTION reno_has_state_data, sState
   valid = PTR_VALID(sState.pEntries) AND $
    PTR_VALID(sState.pTimes) AND $
    PTR_VALID(sState.pNoise) AND $
    PTR_VALID(sState.pBiaslevel) AND $
    PTR_VALID(sState.pAmps)
   return, valid
END 
; _____________________________________________________________________________

FUNCTION reno_get_state_entries, sState
   return, *sState.pEntries
END 
; _____________________________________________________________________________

FUNCTION reno_get_state_times, sState
   return, *sState.pTimes
END 
; _____________________________________________________________________________

FUNCTION reno_get_state_noise, sState
   return, *sState.pNoise
END 
; _____________________________________________________________________________

FUNCTION reno_get_state_bias, sState
   return, *sState.pBiaslevel
END 
; _____________________________________________________________________________

FUNCTION reno_get_state_amps, sState
   return, *sState.pAmps
END 
; _____________________________________________________________________________

PRO reno_set_state_entries, sState, value, NO_COPY=no_copy
   PTR_FREE, sState.pEntries
   sState.pEntries = PTR_NEW(value,NO_COPY=no_copy)
END 
; _____________________________________________________________________________

PRO reno_set_state_times, sState, value, NO_COPY=no_copy
   PTR_FREE, sState.pTimes
   sState.pTimes = PTR_NEW(value,NO_COPY=no_copy)
END 
; _____________________________________________________________________________

PRO reno_set_state_noise, sState, value, NO_COPY=no_copy
   PTR_FREE, sState.pNoise
   sState.pNoise = PTR_NEW(value,NO_COPY=no_copy)
END 
; _____________________________________________________________________________

PRO reno_set_state_bias, sState, value, NO_COPY=no_copy
   PTR_FREE, sState.pBiaslevel
   sState.pBiaslevel = PTR_NEW(value,NO_COPY=no_copy)
END 
; _____________________________________________________________________________

PRO reno_set_state_amps, sState, value, NO_COPY=no_copy
   PTR_FREE, sState.pAmps
   sState.pAmps = PTR_NEW(value,NO_COPY=no_copy)
END 
; _____________________________________________________________________________

FUNCTION reno_get_chip_number, detector, amp, ERROR=error_code

   ccdamp = STRUPCASE(STRTRIM(amp,2))
   CASE STRUPCASE(STRTRIM(detector,2)) OF
      'WFC': BEGIN
         IF ccdamp EQ 'A' OR ccdamp EQ 'B' THEN chip=1 ELSE chip=2
      END
      ELSE: chip = 1
   ENDCASE
   return, chip
END 
; _____________________________________________________________________________

FUNCTION reno_get_detector_of_entries, entries, ERROR=error_code

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

FUNCTION reno_get_time_of_entries, entries, ERROR=error_code

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

FUNCTION reno_get_xsize_of_entries, entries, ERROR=error_code
   error_code = 0b
   unavailable=0b
   DBOPEN, 'acs_log', UNAVAIL=unavailable
   IF unavailable[0] EQ 0 THEN $
    DBEXT, entries, 'naxis1', xsize $
   ELSE BEGIN
      error_code = 1b
      xsize=0
   ENDELSE 
   return, xsize
END 
; _____________________________________________________________________________

FUNCTION reno_get_ysize_of_entries, entries, ERROR=error_code
   error_code = 0b
   unavailable=0b
   DBOPEN, 'acs_log', UNAVAIL=unavailable
   IF unavailable[0] EQ 0 THEN $
    DBEXT, entries, 'naxis2', ysize $
   ELSE BEGIN
      error_code = 1b
      ysize=0
   ENDELSE 
   return, ysize
END 
; _____________________________________________________________________________

FUNCTION reno_get_subarray_of_entries, entries, ERROR=error_code
   error_code = 0b
   unavailable=0b
   DBOPEN, 'acs_log', UNAVAIL=unavailable
   IF unavailable[0] EQ 0 THEN $
    DBEXT, entries, 'SUBARRAY', sub $
   ELSE BEGIN
      error_code = 1b
      sub=''
   ENDELSE 
   return, sub
END 
; _____________________________________________________________________________

FUNCTION reno_get_amp_of_entries, entries, ERROR=error_code

   error_code = 0b
   unavailable=0b
   DBOPEN, 'acs_log', UNAVAIL=unavailable
   IF unavailable[0] EQ 0 THEN $
    DBEXT, entries, 'CCDAMP', amps $
   ELSE BEGIN
      error_code = 1b
      amps=''
   ENDELSE 
   return, amps
END
; _____________________________________________________________________________

FUNCTION reno_get_region_from_widget, sState
   WIDGET_CONTROL, sState.wRegionX0Field, GET_VALUE=fRegionX0
   WIDGET_CONTROL, sState.wRegionX1Field, GET_VALUE=fRegionX1
   WIDGET_CONTROL, sState.wRegionY0Field, GET_VALUE=fRegionY0
   WIDGET_CONTROL, sState.wRegionY1Field, GET_VALUE=fRegionY1
   region = [fRegionX0[0],fRegionX1[0],fRegionY0[0],fRegionY1[0]]
   return, LONG(region)
END
; _____________________________________________________________________________

FUNCTION reno_get_default_region, first_id, edge, ERROR=error_code

   error_code = 0b
   unavailable=0b
   DBOPEN, 'acs_log', UNAVAIL=unavailable
   IF unavailable[0] EQ 1 THEN BEGIN
      error_code = 1b
      return, [0,0,0,0]
   ENDIF 

   detector = STRUPCASE(STRTRIM(DBVAL(first_id,'detector'),2))
   ccdamp = STRTRIM(DBVAL(first_id, 'ccdamp'),2)
   n_lead = LONG(DBVAL(first_id,'over_ac'))
   n_trail = n_lead
   n_chips = (detector EQ 'WFC') ? 2 : 1

   ledge_kludge = (detector EQ 'WFC') ? 10 : 8

   n_x = LONG(DBVAL(first_id,'naxis1'))
   n_y = LONG(DBVAL(first_id,'naxis2')) / n_chips
   xbuffer = (detector EQ 'WFC') ? 2 : 1
   ybuffer = 20
   IF edge[0] EQ 1 THEN BEGIN
      x0 = n_x - n_trail + xbuffer
      x1 = n_x - 1 - xbuffer
   ENDIF ELSE BEGIN
      x0 = xbuffer + ledge_kludge ; leading edge ramp kludge
      x1 = n_lead - 1 - xbuffer
   ENDELSE
   y0 = ybuffer
   y1 = n_y - 1 - ybuffer
   region = [x0,x1,y0,y1]
   return, region
END

; _____________________________________________________________________________

FUNCTION reno_get_first_id_from_filename, strFilename
   IF N_ELEMENTS(strFilename) LE 0 THEN return, 0

   regex = 'reno_([0-9]+)\.[a-z]+$'
   subs = STREGEX(strFilename,regex,/FOLD_CASE,/EXTRACT,/SUBEXPR)
   first_id = (N_ELEMENTS(subs) GT 1) ? LONG(subs[1]) : 0

   return, first_id
END

; _____________________________________________________________________________

FUNCTION reno_get_ps_filename, first_id
   IF N_ELEMENTS(first_id) LE 0 THEN first_id = '00000'
   strFilename = 'reno_' + STRTRIM(first_id[0], 2) + $
    '.ps'
   return, strFilename
END
; _____________________________________________________________________________

FUNCTION reno_get_log_filename, first_id
   IF N_ELEMENTS(first_id) LE 0 THEN first_id = '00000'
   strFilename = 'reno_' + STRTRIM(first_id[0], 2) + $
    '.dat'
   return, strFilename
END

; _____________________________________________________________________________

FUNCTION reno_get_log_file_size, first_entry
   
   strFilename = reno_get_log_filename(first_entry[0])
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

FUNCTION reno_get_event_filename, first_id
   IF N_ELEMENTS(first_id) LE 0 THEN first_id = '00000'
   strFilename = 'reno_' + STRTRIM(first_id[0], 2) + $
    '.events'
   return, strFilename
END

; _____________________________________________________________________________

FUNCTION reno_get_config_filename, first_id
   IF N_ELEMENTS(first_id) LE 0 THEN first_id = '00000'
   strFilename = 'reno_' + STRTRIM(first_id[0], 2) + $
    '.config'
   return, strFilename
END

; _____________________________________________________________________________

FUNCTION reno_get_latest_entry, ERROR=error_code
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

FUNCTION reno_get_update_lp_command, strPSfile, detector
   env_command = GETENV('RENO_UPDATE_LP_COMMAND')
   default_command = 'echo'
   template = (env_command[0] EQ '') ? default_command : env_command[0]
   map = {s:strPSfile,d:detector}
   strCmd = fill_template_string(template+' %s',map)
   return, strCmd
END 
; _____________________________________________________________________________

FUNCTION reno_get_lp_command, strPSfile, detector
   env_command = GETENV('RENO_LP_COMMAND')
   default_command = 'lp %s'
   template = (env_command[0] EQ '') ? default_command : env_command[0]
   map = {s:strPSfile,d:detector}
   strCmd = fill_template_string(template+' %s',map)
   return, strCmd
END 
; _____________________________________________________________________________

PRO reno_update_overscan_fields, sState, first_id, edge, ERROR=error_code

   region = reno_get_default_region(first_id,edge[0],ERROR=error_code)
   IF error_code[0] NE 0 THEN return

   WIDGET_CONTROL, sState.wRegionX0Field, SET_VALUE=region[0]
   WIDGET_CONTROL, sState.wRegionX1Field, SET_VALUE=region[1]
   WIDGET_CONTROL, sState.wRegionY0Field, SET_VALUE=region[2]
   WIDGET_CONTROL, sState.wRegionY1Field, SET_VALUE=region[3]
END
; _____________________________________________________________________________

FUNCTION parse_time_stamp, time_stamp, UTC=utc, MJD=mjd

   IF N_ELEMENTS(time_stamp) LE 0 THEN BEGIN
      MESSAGE, 'time stamp not specified', /CONTINUE
      return, -1
   ENDIF 

   tokens = STRSPLIT(time_stamp, ':', /EXTRACT)

   CASE N_ELEMENTS(tokens) OF
      5: BEGIN
         year = DOUBLE(STRMID(tokens[0], 0, 4))
         day_of_year = DOUBLE(STRMID(tokens[1], 0, 3))
         hour = DOUBLE(STRMID(tokens[2], 0, 2))
         minute = DOUBLE(STRMID(tokens[3], 0, 2))
         second = DOUBLE(STRMID(tokens[4], 0, 2))
      END
      4: BEGIN
         year = DOUBLE(STRMID(tokens[0], 0, 4))
         day_of_year = DOUBLE(STRMID(tokens[1], 0, 3))
         hour = DOUBLE(STRMID(tokens[2], 0, 2))
         minute = DOUBLE(STRMID(tokens[3], 0, 2))
         second = 0d
      END
      3: BEGIN
         year = DOUBLE(STRMID(tokens[0], 0, 4))
         day_of_year = DOUBLE(STRMID(tokens[1], 0, 3))
         hour = DOUBLE(STRMID(tokens[2], 0, 2))
         minute = 0d
         second = 0d
      END
      2: BEGIN
         year = DOUBLE(STRMID(tokens[0], 0, 4))
         day_of_year = DOUBLE(STRMID(tokens[1], 0, 3))
         hour = 0d
         minute = 0d
         second = 0d
      END
      1: BEGIN
         year = DOUBLE(STRMID(tokens[0], 0, 4))
         day_of_year = 1d
         hour = 0d
         minute = 0d
         second = 0d
      END
      ELSE: BEGIN
         bindate = DOUBLE(BIN_DATE(SYSTIME()))
         year    = bindate[0]
         month   = bindate[1]
         day     = bindate[2]
         hour   = tokens[0]
         minute = tokens[1]
         second = tokens[2]
      END
   ENDCASE

   IF N_ELEMENTS(day) LE 0 THEN BEGIN
      monthdays = [0,31,59,90,120,151,181,212,243,273,304,334,366]
      
      leap_year = DOUBLE((((year MOD 4) EQ 0) AND ((year MOD 100) NE 0)) $
                          OR ((year MOD 400) EQ 0) AND (day_of_year GE 90))
      
      month = DOUBLE(MIN(WHERE(monthdays GE (day_of_year - leap_year))))
      
      day = DOUBLE(day_of_year - monthdays[month-1] - leap_year)
   ENDIF

   julian_date = JULDAY(month, day, year, hour, minute, second)

   IF KEYWORD_SET(mjd) THEN BEGIN
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

   IF N_ELEMENTS(julian_date) GT 0 THEN BEGIN
      IF KEYWORD_SET(mjd) THEN $
       julian_date = DOUBLE(2.4e6) + DOUBLE(julian_date) + 0.5d
   ENDIF ELSE julian_date = DOUBLE(SYSTIME(/JULIAN))

   IF KEYWORD_SET(utc) THEN julian_date = julian_date - (time_zone / 24d)

   CALDAT, DOUBLE(julian_date), month, day, year, hour, minute, second

;   DAYCNV, julian_date, year, month, day, fHour
;   hour = FIX(fHour)
;   fDate = (fHour - hour) * 60.0
;   minute = FIX(fDate)
;   second = FLOAT((fDate - minute) * 60.0)

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

   IF KEYWORD_SET(time_only) THEN BEGIN
      strStamp = STRING(FORMAT='(3(I2.2,:,":"))', $
                         hour, minute, second)      
   ENDIF ELSE BEGIN
      strStamp = STRING(FORMAT='(I4.4,":",I3.3,3(":",I2.2))', $
                         year, day_of_year, hour, minute, second)
   ENDELSE 

   return, strStamp
END
; _____________________________________________________________________________

PRO x_get_event_event, sEvent

   wStateHandler = WIDGET_INFO(sEvent.handler, /CHILD)
   WIDGET_CONTROL, wStateHandler, GET_UVALUE=sState, /NO_COPY 

   WIDGET_CONTROL, sEvent.id, GET_UVALUE=event_uval

   CASE STRUPCASE(event_uval) OF

      'EVENT_FIELD': BEGIN

      END 

      'BUTTON_PRESS': BEGIN
         CASE STRUPCASE(sEvent.value) OF

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
               
               value = get_time_stamp(/UTC)
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

   IF N_ELEMENTS(status) LE 0 THEN status = 1b
   IF N_ELEMENTS(event_value) LE 0 THEN event_value = ''
   IF N_ELEMENTS(time_value) LE 0 THEN time_value = ''

   sReturn = { value: event_value, time: time_value, status: status }

   IF WIDGET_INFO(sState.wInfo, /VALID_ID) EQ 1 THEN $
    WIDGET_CONTROL, sState.wInfo, SET_UVALUE=sReturn
   
   IF WIDGET_INFO(wStateHandler, /VALID_ID) EQ 1 THEN BEGIN
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

   instance_number = XREGISTERED('x_get_event')
   IF KEYWORD_SET(debug) THEN HELP, instance_number
   IF instance_number GT 0 THEN BEGIN
      exit_status = 0b
      return, -1
   ENDIF
   
   IF N_ELEMENTS(event_value) LE 0 THEN event_value = ''
   IF N_ELEMENTS(time_value) LE 0 THEN time_value = get_time_stamp(/UTC)
   
   IF N_ELEMENTS(title) LE 0 THEN title = 'X_GET_EVENT'

   IF KEYWORD_SET(debug) THEN HELP, parent
   IF N_ELEMENTS(parent) GT 0 THEN BEGIN
      wRoot = WIDGET_BASE(parent, /COLUMN, /MODAL, TITLE=title, GROUP=group)
      parent_id = parent
   ENDIF ELSE BEGIN
      wRoot = WIDGET_BASE(/COLUMN, /MODAL, TITLE=title, GROUP=group)
      parent_id = -1L
   ENDELSE

   wBase = WIDGET_BASE(wRoot, /COLUMN)

   wReturnInfo = WIDGET_BASE(UVALUE='JUNK')

   strTimeLabel = 'Time (UTC):'
   wTimeField = CW_FIELD(wBase, $
                          /STRING, /FRAME, UVALUE='TIME_FIELD', $
                          /RETURN_EVENTS, TITLE = strTimeLabel, $
                          VALUE=time_value)
   
   strEventLabel = 'Event:'
   wEventField = CW_FIELD(wBase, $
                           /STRING, /FRAME, UVALUE='EVENT_FIELD', $
                           /RETURN_EVENTS, TITLE = strEventLabel, $
                           VALUE=event_value, XSIZE=40)

   aButtons = ['OK','Cancel', 'Reset', 'Now' ]
   aButtonUvals = ['OK_BUTTON', 'CANCEL_BUTTON', 'RESET_BUTTON', 'NOW_BUTTON' ]
   wButtons = CW_BGROUP(wBase, aButtons, $
                         BUTTON_UVALUE=aButtonUvals, $
                         /ROW, /NO_RELEASE, UVALUE='BUTTON_PRESS')

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

   IF N_TAGS(sReturn) GT 1 THEN BEGIN
      IF KEYWORD_SET(structure) THEN value = sReturn $
      ELSE value = sReturn.value
      exit_status = sReturn.status
   ENDIF ELSE BEGIN
      value = ''
      exit_status = 0b
   ENDELSE 

   return, value
END 
; _____________________________________________________________________________


PRO reno_update_event_display, sState
   
   IF PTR_VALID(sState.pEventList) THEN BEGIN

      aEventList = *sState.pEventList
      aTimeList = *sState.pTimeList

      sort_index = SORT(aTimeList)
      aTimeList = aTimeList[sort_index]
      aEventList = aEventList[sort_index]

      PTR_FREE, sState.pEventList, sState.pTimeList
      sState.pEventList = PTR_NEW(aEventList)
      sState.pTimeList = PTR_NEW(aTimeList)

      n_events = N_ELEMENTS(aEventList)
      aList = MAKE_ARRAY(n_events, /STRING)
      FOR i=0L, n_events-1 DO BEGIN
         event = aEventList[i]
         time  = aTimeList[i]
         strEvent = STRING(FORMAT='(A17,2X,A0)', time, event)
         aList[i] = strEvent
      ENDFOR 
      WIDGET_CONTROL, sState.wEventList, SET_VALUE=aList
   ENDIF ELSE BEGIN
      strEvent = STRING(FORMAT='(A17,2X,A0)', '', '')
      aList = [strEvent]
      WIDGET_CONTROL, sState.wEventList, SET_VALUE=aList      
   ENDELSE

   return
END 

; _____________________________________________________________________________

PRO reno_new_session, sState, first_id, ERROR=error_code

   CASE STRUPCASE(!VERSION.OS_FAMILY) OF
      'WINDOWS': gdevice = 'WIN'
      'MACOS': gdevice = 'MAC'
      ELSE: gdevice = 'X'
   ENDCASE
   SET_PLOT, gdevice
   WSET, sState.draw_index
   ERASE
   latest_entry = reno_get_latest_entry(ERROR=error_code)
   IF error_code[0] NE 0 THEN BEGIN
      reno_wmessage, sState, 'Database is unavailable.'
      return
   ENDIF 

   default_comment = ''
   
   IF N_ELEMENTS(first_id) GT 0 THEN $
    first_id = first_id $
   ELSE first_id = latest_entry

   default_last_id = -1
   default_allamps = 1

   reno_free_pointers, sState
   reno_zero_pointers, sState
   reno_update_event_display, sState

   sState.session_has_data = 0b
   sState.data_file_size = 0l
   sState.data_interval = 0l

   WIDGET_CONTROL, sState.wCommentField, SET_VALUE=default_comment
   WIDGET_CONTROL, sState.wProcessAmpsButton, SET_VALUE=default_allamps
   WIDGET_CONTROL, sState.wFirstIdField, SET_VALUE=first_id
   WIDGET_CONTROL, sState.wLastIdField, SET_VALUE=default_last_id

   ccdamps = reno_get_amp_of_entries(first_id[0],ERROR=error_code)
   IF STRLEN(STRTRIM(ccdamps,2)) EQ 4 THEN BEGIN
      default_overscan = 0
      OR_sense = 0
   ENDIF ELSE BEGIN
      default_overscan = 1
      OR_sense = 1
   ENDELSE 
   WIDGET_CONTROL, sState.wOverscanRegionButton, SET_VALUE=default_overscan
   WIDGET_CONTROL, sState.wOverscanRegionButton, SENSITIVE=OR_sense
   reno_update_overscan_fields, sState, first_id, default_overscan[0]
   reno_wmessage, sState, 'new session for entry '+STRTRIM(first_id,2)
   return
END 

; _____________________________________________________________________________

PRO reno_update_widget_from_configfile, sState, strFilename

   aHeader = HEADFITS(strFilename[0])
   strComment = SXPAR(aHeader, 'DESCRIPT')
   bAllAmps = SXPAR(aHeader,'ALLAMPS')
   bOverscanRegion = SXPAR(aHeader, 'OREGION')
   x0 = SXPAR(aHeader,'X0')
   x1 = SXPAR(aHeader,'X1')
   y0 = SXPAR(aHeader,'Y0')
   y1 = SXPAR(aHeader,'Y1')
   iFirstId = SXPAR(aHeader, 'FIRSTID')
   iLastId = SXPAR(aHeader, 'LASTID')
   strFindExpr = SXPAR(aHeader, 'FINDEXPR',COUNT=find_count)
   IF find_count LE 0 THEN strFindExpr = ''

   WIDGET_CONTROL, sState.wCommentField, SET_VALUE=strComment
   WIDGET_CONTROL, sState.wProcessAmpsButton, SET_VALUE=bAllAmps[0]

   WIDGET_CONTROL, sState.wOverscanRegionButton, SET_VALUE=bOverscanRegion[0]
   WIDGET_CONTROL, sState.wFirstIdField, SET_VALUE=iFirstId
   WIDGET_CONTROL, sState.wLastIdField, SET_VALUE=iLastId

   WIDGET_CONTROL, sState.wFindExprField, SET_VALUE=strFindExpr

   WIDGET_CONTROL, sState.wRegionX0Field, SET_VALUE=FIX(x0[0])
   WIDGET_CONTROL, sState.wRegionX1Field, SET_VALUE=FIX(x1[0])
   WIDGET_CONTROL, sState.wRegionY0Field, SET_VALUE=FIX(y0[0])
   WIDGET_CONTROL, sState.wRegionY1Field, SET_VALUE=FIX(y1[0])

END

; _____________________________________________________________________________

PRO reno_update_state_from_logfile, sState, strFilename, ERROR=error_code

   error_code = 0b
   reno_wmessage, sState, 'reading log file...'
   reno_read_log_file, strFilename, aEntries, aTimes, aNoise, $
    aBiaslevel, aAmps, ERROR=error_code
   reno_wmessage, sState, 'setting state...'
   IF error_code[0] EQ 0 THEN BEGIN
      reno_set_state_entries, sState, aEntries, /NO_COPY
      reno_set_state_times, sState, aTimes, /NO_COPY
      reno_set_state_noise, sState, aNoise, /NO_COPY
      reno_set_state_bias, sState, aBiaslevel, /NO_COPY
      reno_set_state_amps, sState, aAmps, /NO_COPY
   ENDIF ELSE BEGIN
      reno_free_data_pointers, sState
   ENDELSE 
END 

; _____________________________________________________________________________

PRO reno_open_session, sState, first_id, ERROR=error_flag

   error_flag = 0b

   IF N_ELEMENTS(first_id) LE 0 THEN BEGIN
      strFilename = DIALOG_PICKFILE(/READ, FILTER='reno_*', /FIX_FILTER, $
                                    /MUST_EXIST, GROUP=sState.wBase)
      IF strFilename[0] EQ '' THEN BEGIN
         error_flag = 1b
         return
      ENDIF
      first_id = reno_get_first_id_from_filename(strFilename[0])
      strFilename = reno_get_config_filename(first_id)
      file = FINDFILE(strFilename, COUNT=fcount)
      IF fcount LE 0 THEN BEGIN
         error_flag = 1b
         return
      ENDIF 
   ENDIF ELSE BEGIN
      strFilename = reno_get_config_filename(first_id)
      file = FINDFILE(strFilename, COUNT=fcount)
      IF fcount LE 0 THEN BEGIN
         error_flag = 1b
         return
      ENDIF
   ENDELSE
   reno_update_widget_from_configfile, sState, strFilename

                    ; Read the event file
   strFilename = reno_get_event_filename(first_id)
   file = FINDFILE(strFilename, COUNT=fcount)

   IF fcount GT 0 THEN BEGIN
      reno_read_event_file, strFilename, aTimeList, aEventList, ERROR=error
      IF error EQ 0 THEN BEGIN
         PTR_FREE, sState.pTimeList, sState.pEventList
         sState.pEventList = PTR_NEW(aEventList, /NO_COPY)
         sState.pTimeList = PTR_NEW(aTimeList, /NO_COPY)
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

   strFilename = reno_get_log_filename(first_id)
   reno_update_state_from_logfile, sState, strFilename, ERROR=error_code

   sState.session_has_data = (error[0] EQ 0) ? 1b : 0b

   reno_update_event_display, sState

   log_size = reno_get_log_file_size(first_id)
   sState.data_file_size = LONG(log_size)
   sState.data_interval = 0l
   yesno = (sState.session_has_data) ? '' : 'no '
   reno_wmessage, sState, 'Session '+STRTRIM(first_id,2)+' has '+yesno+'data'
   return
END

; _____________________________________________________________________________

PRO reno_save_widget_to_configfile, sState
   WIDGET_CONTROL, sState.wCommentField, GET_VALUE=strComment
   WIDGET_CONTROL, sState.wProcessAmpsButton, GET_VALUE=bAllAmps
   WIDGET_CONTROL, sState.wOverscanRegionButton, GET_VALUE=bOverscanRegion
   WIDGET_CONTROL, sState.wFirstIdField, GET_VALUE=iFirstId
   WIDGET_CONTROL, sState.wLastIdField, GET_VALUE=iLastId
   WIDGET_CONTROL, sState.wFindExprField, GET_VALUE=strFindExpr

   WIDGET_CONTROL, sState.wRegionX0Field, GET_VALUE=x0
   WIDGET_CONTROL, sState.wRegionX1Field, GET_VALUE=x1
   WIDGET_CONTROL, sState.wRegionY0Field, GET_VALUE=y0
   WIDGET_CONTROL, sState.wRegionY1Field, GET_VALUE=y1

                    ; convert logical values
   all_amps = (bAllAmps[0] EQ 0) ? 'F' : 'T'

                    ; check if this is a custom run (ie. with a find expression)
   custom_run = 0
   IF N_ELEMENTS(strFindExpr) GT 0 THEN BEGIN
      strFindExpr = STRTRIM(strFindExpr[0],2)
      IF strFindExpr NE '' THEN BEGIN
         custom_run = 1
      ENDIF 
   ENDIF 

                    ; Write config file
   MKHDR, aHeader, ''
   strFilename = reno_get_config_filename(iFirstId)
   SXADDPAR, aHeader, 'DESCRIPT', strComment[0], $
    ' Description of data set'
   SXADDPAR, aHeader, 'ALLAMPS',all_amps, $
    ' Process all amps for this detector'
   SXADDPAR, aHeader, 'OREGION',bOverscanRegion[0], $
    ' Overscan region (0 = leading, 1 = trailing)'
   SXADDPAR, aHeader, 'FIRSTID', iFirstId[0], $
    ' First entry number in range'
   SXADDPAR, aHeader, 'LASTID', iLastId[0], $
    ' Last entry number in range (-1 = no limit)'

   SXADDPAR, aHeader, 'X0', FIX(x0[0])
   SXADDPAR, aHeader, 'X1', FIX(x1[0])
   SXADDPAR, aHeader, 'Y0', FIX(y0[0])
   SXADDPAR, aHeader, 'Y1', FIX(y1[0])

   SXADDPAR, aHeader, 'FINDEXPR', strFindExpr

                    ; test write with OPENW
   OPENW, lun, strFilename, /GET_LUN, ERROR=open_error_flag
   IF open_error_flag NE 0 THEN BEGIN
      PRINTF, -2, !ERR_STRING
      reno_wmessage, sState, 'error writing config file: '+!ERROR_STATE.SYS_MSG
      PRINT, STRING(7b)
      WAIT, 5
      return
   ENDIF ELSE BEGIN
      FREE_LUN, lun
      WRITEFITS, strFilename, 0, aHeader
   ENDELSE

END 

; _____________________________________________________________________________

PRO reno_save_session, sState

   WIDGET_CONTROL, sState.wFirstIdField, GET_VALUE=iFirstId
   reno_save_widget_to_configfile, sState

   strFilename = reno_get_event_filename(iFirstId)
   IF PTR_VALID(sState.pEventList) THEN BEGIN
                    ; Write event file
      aEventList = *sState.pEventList
      aTimeList = *sState.pTimeList
      reno_write_event_file, strFilename, aTimeList, aEventList, ERROR=error
   ENDIF ELSE BEGIN
      aEventList = ''
      aTimeList = ''
      reno_write_event_file, strFilename, aTimeList, aEventList, /BLANK, ERROR=error
   ENDELSE

   IF error NE 0 THEN BEGIN
      reno_wmessage, sState, 'error writing event file: '+strFilename
   ENDIF 

   reno_wmessage, sState, 'saved session for entry '+STRTRIM(iFirstId[0],2)
   return
END

; _____________________________________________________________________________

PRO reno_read_event_file, strFilename, aTimeList, aEventList, ERROR=error

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
            strTime = get_time_stamp(fTime, /MJD)
            aTimeList = [aTimeList,strTime]
            aEventList = [aEventList,strEvent]
         ENDIF
      ENDWHILE
      FREE_LUN, lun
   ENDIF ELSE BEGIN
      error = open_error_flag
      PRINTF, -2, !ERR_STRING
   ENDELSE

   IF N_ELEMENTS(aTimeList) GT 1 THEN BEGIN
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

PRO reno_write_event_file, strFilename, aTimeList, aEventList, BLANK=blank, $
                           ERROR=open_error_flag

   OPENW, lun, strFilename, /GET_LUN, ERROR=open_error_flag

   IF open_error_flag EQ 0 THEN BEGIN
      IF KEYWORD_SET(blank) THEN BEGIN
         PRINTF, lun, '', '', FORMAT='(A15,2X,A)'
      ENDIF ELSE BEGIN
         FOR i=0, N_ELEMENTS(aEventList)-1 DO BEGIN
            mjd = parse_time_stamp(aTimeList[i], /MJD)
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

PRO reno_read_log_file, filename, aEntries, aTimes, aNoise, aBiaslevel, $
                        aAmps, ERROR=error
   error = 0b
   file = FINDFILE(filename, COUNT=fcount)

   IF fcount LE 0 THEN BEGIN
      MESSAGE, 'file not found '+filename, /CONTINUE
      error = 1b
      return
   ENDIF

   OPENR, lun, filename, /GET_LUN, ERROR=open_error_flag
   IF open_error_flag EQ 0 THEN BEGIN
      aNoise = 0.0e
      aBiaslevel = 0.0e
      aEntries = 0l
      aTimes = 0.0d
      aAmps = ''

      entry = aEntries
      time = aTimes
      bias = aBiaslevel
      time = aTimes
      amp = aAmps
      
      WHILE NOT EOF(lun) DO BEGIN
         READF, lun, entry, time, noise, bias, amp, FORMAT='(i5,2X,f15.8,2X,2(f10.3,2X),A)'
         aEntries = [aEntries,entry]
         aTimes = [aTimes,time]
         aNoise = [aNoise,noise]
         aBiaslevel = [aBiaslevel,bias]
         aAmps = [aAmps,amp]
      ENDWHILE
      
                    ; trim off dummy 0th index
      IF N_ELEMENTS(aEntries) GT 1 THEN BEGIN
         aEntries = aEntries[1:*]
         aTimes = aTimes[1:*]
         aNoise = aNoise[1:*]
         aBiaslevel = aBiaslevel[1:*]
         aAmps = aAmps[1:*]
      ENDIF

      FREE_LUN, lun
   ENDIF ELSE BEGIN
      error = open_error_flag
      PRINTF, -2, !ERR_STRING
   ENDELSE 

   return
END

; _____________________________________________________________________________

PRO reno_write_log_file, filename, aEntries, aTimes, aNoise, aBiaslevel, $
                         aAmps, ERROR=error_code, APPEND=append
   error_code = 0b
   
   IF N_ELEMENTS(aEntries) LE 0 THEN BEGIN
      error_code = 1b
      return
   ENDIF 

   OPENW, lun, filename, /GET_LUN, ERROR=open_error_flag, APPEND=append
   IF open_error_flag EQ 0 THEN BEGIN
      FOR i=0, N_ELEMENTS(aEntries)-1 DO $
       PRINTF, lun, aEntries[i], aTimes[i], aNoise[i], aBiaslevel[i], $
       aAmps[i], FORMAT='(i5,2X,f15.8,2X,2(f10.3,2X),A)'
      FREE_LUN, lun
   ENDIF ELSE BEGIN
      error_code = open_error_flag
      PRINTF, -2, !ERR_STRING
   ENDELSE 

   return
END 

; _____________________________________________________________________________

PRO reno_plot_data, plot_id, plot_time, plot_noise, plot_bias, plot_amp, $
                    COMMENT=strComment, FIRST=firstid, LAST=lastid, $
                    EVENT_TIMES=event_times, EVENT_VALUES=event_values, $
                    XMIN=xmin, XMAX=xmax, YMIN=ymin, YMAX=ymax, $
                    OVERSCAN_EDGE=overscan_edge, FONT=font_type

   IF N_ELEMENTS(strComment) LE 0 THEN strComment=''

   IF N_ELEMENTS(firstid) LE 0 THEN firstid = MIN(plot_id)
   IF N_ELEMENTS(lastid) LE 0 THEN lastid = MAX(plot_id)

   IF firstid LE 0 THEN firstid = MIN(plot_id)
   IF lastid LE 0 THEN lastid = MAX(plot_id)

   pindex = WHERE((plot_id LE lastid) AND (plot_id GE firstid), pcount)
   IF pcount LE 0 THEN BEGIN
      MESSAGE, 'no data to plot.', /CONTINUE
      return
   ENDIF

   id = plot_id[pindex]
   y = plot_noise[pindex]
   mjd_time = plot_time[pindex]
   t0jd = mjd_time[0] + 2400000.5
   t1jd = MAX(mjd_time) + 2400000.5
   sct0 = get_time_stamp(mjd_time[0], /MJD)
   h = ((mjd_time - LONG(mjd_time[0])) * 24.0)

                    ; If they are not defined
   IF N_ELEMENTS(xmin) LE 0 THEN xmin = MIN(h)
   IF N_ELEMENTS(xmax) LE 0 THEN xmax = MAX(h)
   IF N_ELEMENTS(ymin) LE 0 THEN ymin = (MIN(y) > 0.0 < 15.0)
   IF N_ELEMENTS(ymax) LE 0 THEN ymax = (MAX(y) > 0.0 > 15.0)

   xstyle = 1
   ystyle = 1
                    ; If they are both zero assume they have not been set
   IF (xmin EQ 0) AND (xmax EQ 0) THEN BEGIN
      xmin = MIN(h)
      xmax = MAX(h)
      xstyle = 3
   ENDIF 
   IF (ymin EQ 0) AND (ymax EQ 0) THEN BEGIN
                    ; pad the ymin with 20%
      ymin = (MIN(y) > 0 < 15)
      ymax =  (MAX(y) > 0 < 15)
      ymin = ymin - (ymax - ymin)*0.2 > 0
      ystyle = 3
   ENDIF

                    ; if the max is less than the min
   IF (xmax LT xmin) THEN xmax = MAX(h)
   IF (ymax LT ymin) THEN ymax = (MAX(y) > 0 < 15)

   xrange = [xmin, xmax]
   yrange = [ymin, ymax]

   strDate0 = STRING(FORMAT='(c(CDI,X,CMoA,CYI5))',t0jd)
   strDate1 = STRING(FORMAT='(c(CDI,X,CMoA,CYI5))',t1jd)

   IF (MAX(h)-MIN(h)) GT 36 THEN BEGIN
                    ; if the range is greater than N display the end
                    ; date
      strDate = strDate0 + '-' + strDate1
   ENDIF ELSE strDate = strDate0

   IF N_ELEMENTS(overscan_edge) GT 0 THEN BEGIN
      CASE overscan_edge[0] OF
         0: strType = 'leading overscan'
         1: strType = 'trailing overscan'
         ELSE: strType = 'Overscan'
      ENDCASE
   ENDIF ELSE BEGIN
      strType = 'Overscan'
   ENDELSE

   first_detector = reno_get_detector_of_entries(firstid,ERROR=error_code)
   IF error_code[0] NE 0 THEN return

   strTitle = STRUPCASE(first_detector[0])+' Read noise - '+strType+' '+strDate+$
    '  '+strComment
   strXTitle = 'UTC Time (hrs)'
   strYTitle = 'Read noise (DN)'

   strSubTitleFormat='("Start ",A,1X,"Entries ",I0,":",I0)'
   strSubTitle = STRING(FORMAT=strSubTitleFormat, $
                        sct0, firstid, lastid)

   IF !D.NAME NE 'PS' THEN BEGIN
      LOADCT, 39, /SILENT ; Rainbow + white color table
      color_diff = !D.N_COLORS / 5
      colors = (INDGEN(4) + 1) * color_diff
   ENDIF ELSE BEGIN
      TVLCT, [0,255,0,0], [0,0,255,0], [0,0,0,25]
      colors = INDGEN(4) + 1
   ENDELSE
   symbols = [-4,-5,-6,-7]

   counts = [0,0,0,0]
                    ; separate amps
   ampa_i = WHERE(STRUPCASE(plot_amp) EQ 'A', cts)
   counts[0] = TEMPORARY(cts)
   ampb_i = WHERE(STRUPCASE(plot_amp) EQ 'B', cts)
   counts[1] = TEMPORARY(cts)
   ampc_i = WHERE(STRUPCASE(plot_amp) EQ 'C', cts)
   counts[2] = TEMPORARY(cts)
   ampd_i = WHERE(STRUPCASE(plot_amp) EQ 'D', cts)
   counts[3] = TEMPORARY(cts)

                    ; set up axis
   IF (xmax - xmin) GT 2 THEN BEGIN
      tick_intervals = ROUND(FLOOR(xmax) - CEIL(xmin))
      IF (xmax-xmin) GT 1000 THEN nt0 = 15 ELSE nt0 = 30
      tick_spacing = FIX(tick_intervals / nt0) + 1
      n_ticks = (tick_intervals/tick_spacing) + 1
      tick_values = CEIL(xmin) + FINDGEN(n_ticks) * tick_spacing
      IF (xmax-xmin) GT 120 THEN tick_labels = STRTRIM(FIX(tick_values),2) $
      ELSE tick_labels = STRTRIM(FIX(tick_values MOD 24), 2)
      tick_minor = FIX(4 / tick_spacing)

      ;;HELP, tick_intervals, tick_spacing, n_ticks, tick_minor
      ;;PRINT, 'tick values: ', tick_values
      ;;PRINT, 'tick labels: ', tick_labels
      PLOT, h, y, XSTYLE=xstyle, YSTYLE=ystyle, $
       YRANGE=yrange, XRANGE=xrange, FONT=font_type, $
       TITLE=strTitle, SUBTITLE=strSubTitle, $
       XTITLE=strXTitle, YTITLE=strYTitle, $
       XTICKS=n_ticks-1, XMINOR=tick_minor, $
       XTICKV=tick_values, XTICKNAME=tick_labels, /NODATA
   ENDIF ELSE BEGIN
      PLOT, h, y, XSTYLE=xstyle, YSTYLE=ystyle, $
       YRANGE=yrange, XRANGE=xrange, FONT=font_type, $
       TITLE=strTitle, SUBTITLE=strSubTitle, $
       XTITLE=strXTitle, YTITLE=strYTitle, /NODATA
   ENDELSE 

                    ; plot each amp
   loff = 0.075
   FOR i=0,3 DO BEGIN
      IF counts[i] GT 0 THEN BEGIN
         strAmp = STRING(97b+BYTE(i))
         strExec = 'index = amp'+strAmp+'_i'
         ret=EXECUTE(strExec)
         IF ret EQ 1 THEN BEGIN
            OPLOT, h[index], y[index], PSYM=symbols[i], COLOR=colors[i]
            PLOTS, .05+loff*i, .02, PSYM=symbols[i], /NORMAL, $
             COLOR=colors[i]
            strOut = STRUPCASE(strAmp) + ' amp'
            charheight = !D.Y_CH_SIZE / FLOAT(!D.Y_SIZE)
            XYOUTS, .06+loff*i, .02-charheight/2, strOut, CHARSIZE=.75, $
             /NORMAL, FONT=font_type, $
             COLOR=colors[i]
         ENDIF 
      ENDIF
   ENDFOR

                    ; xyout median value of all noise
                    ; xyout stdev of all noise

   IF N_ELEMENTS(event_times) GT 0 THEN BEGIN
                    ; annotations
                    ; y position of time labels
      y_label_pos = !Y.CRANGE[0] + 0.02 * (!Y.CRANGE[1] - !Y.CRANGE[0])
      x_label_offset = 0.0025 * (!X.CRANGE[1] - !X.CRANGE[0])

      FOR i = 0, (N_ELEMENTS(event_times) - 1) DO BEGIN
         event_mjd = parse_time_stamp(event_times[i], /MJD)
         evtime = (event_mjd - LONG(mjd_time[0])) * 24.0

         strEvent = event_values[i]
         old_bang_pos = 0
bang_loop_point:
         bang_pos = STRPOS(strEvent, '!', old_bang_pos)
         IF bang_pos NE -1 THEN BEGIN
            byte_string = BYTE(strEvent)
            IF bang_pos EQ 0 THEN BEGIN
               byte_string = [33b,byte_string] 
            ENDIF ELSE IF bang_pos EQ N_ELEMENTS(byte_string)-1 THEN BEGIN
               byte_string = [byte_string,33b]
            ENDIF ELSE BEGIN
               byte_string = [ byte_string[0:bang_pos], 33b, $
                               byte_string[bang_pos+1:*] ]
            ENDELSE
            
            strEvent = STRING(byte_string)
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

FUNCTION reno_read_data, entry, CHIP=chip, ERROR=error_code, $
                         MESSAGE=strMessage

   error_code = 0b
   strMessage = ''
   ACS_READ, entry[0], header, data, CHIP=chip[0], ROTATE=0, /NO_ABORT, $
    MESSAGE=strMessage, /SILENT, /WAIT
   IF N_ELEMENTS(strMessage) GT 0 THEN BEGIN
      IF strMessage[0] NE '' THEN BEGIN
         error_code=1b
         return, -1
      ENDIF
   ENDIF
   return, data
END

; _____________________________________________________________________________

FUNCTION reno_read_region, data, region, ERROR=error_code, $
                           MESSAGE=strMessage
   error_code = 0b
   strMessage = ''
   overscan = data[region[0]:region[1],region[2]:region[3]]
   return, TEMPORARY(overscan)
END

; _____________________________________________________________________________

PRO reno_compute_noise, entries, noise, biaslevel, amp, $
                        REGION=region, $
                        CHIP=chip_numbers, ERROR=error_code, $
                        MESSAGE=strMessage
   error_code = 0b
   strMessage=''
   n_entries = N_ELEMENTS(entries)
   n_chips = N_ELEMENTS(chip_numbers)
   ccdamps = reno_get_amp_of_entries(entries,ERROR=error_code)
   IF error_code[0] NE 0 THEN return
   n_amps = STRLEN(STRTRIM(ccdamps[0],2))
   noise = MAKE_ARRAY(n_entries*n_amps,/FLOAT)
   biaslevel = noise
   amp = MAKE_ARRAY(n_entries*n_amps,/STRING)
   amps_per_chip = FIX(n_amps / n_chips)

   FOR i=0,n_entries-1 DO BEGIN
      FOR j=0,n_chips-1 DO BEGIN
         PRINT, FORMAT='("processing entry ",I5," chip ",I1)', $
          entries[i], j+1
         data = reno_read_data(entries[i],CHIP=chip_numbers[j],$
                               ERROR=error_code,MESSAGE=strMessage)
         data_sz = SIZE(data)
         amp_xoffset = data_sz[1] / amps_per_chip
         FOR k=0,amps_per_chip-1 DO BEGIN
            this_amp = STRMID(ccdamps[i],j*amps_per_chip+k,1)
            PRINT, FORMAT='(" ",A)', this_amp
            index = n_amps*i+amps_per_chip*j+k
            amp[index] = this_amp[0]
            this_region = region
            this_region[0] = region[0]+amp_xoffset*k
            this_region[1] = region[1]+amp_xoffset*k
            overscan = reno_read_region(data, this_region, $
                                        ERROR=error_code, $
                                        MESSAGE=strMessage)
            IF error_code[0] EQ 0 THEN BEGIN
                    ; Try to reject the odd cosmic ray or other
                    ; deviation
               nsigma = 5
               cutoff_value = MEDIAN(overscan)+nsigma*STDDEV(overscan)
               goodpix = WHERE(overscan LE cutoff_value,ngood)
               IF ngood LE 0 THEN BEGIN
                  PRINT, 'WARNING: there were no pixels found '
               ENDIF
               nrejected = N_ELEMENTS(overscan) - ngood
               PRINT, 'Rejecting ', nrejected, ' pixels over ', cutoff_value
               noise[index] = STDDEV(overscan[goodpix])
               biaslevel[index] = MEDIAN(overscan[goodpix])
               PRINT, "   Noise ", noise[index], "   Bias  ", biaslevel[index]
            ENDIF ELSE BEGIN
               return
            ENDELSE
         ENDFOR
         PRINT, ''
      ENDFOR
   ENDFOR
END

; _____________________________________________________________________________

FUNCTION reno_find_new_entries, first_entry, latest_entry, $
                                APPEND=append_data, ALL_AMPS=all_amps, $
                                DETECTOR=first_detector, AMP=first_amp, $
                                FIND_EXPR=find_expr

   IF first_entry GT latest_entry THEN return, 0

   IF N_ELEMENTS(find_expr) GT 0 THEN BEGIN
      strFind = STRING(FORMAT='(I,"<","entry","<",I,",",A)',$
                       first_entry,latest_entry,find_expr)
      PRINT, 'Using custom search: '+strFind
      new_entries = DBFIND(strFind,ERRMSG=find_error,COUNT=find_count)
      IF find_count LE 0 THEN return, 0
   ENDIF ELSE $
    new_entries = LINDGEN(latest_entry[0]-first_entry[0]+1)+first_entry[0]

                    ; Ignore images that aren't on the same
                    ; detector as the first image
   IF N_ELEMENTS(first_detector) GT 0 THEN BEGIN
      DBEXT, new_entries, 'DETECTOR', aDetectors
      good = WHERE(STRTRIM(aDetectors,2) EQ first_detector, gcount)
      new_entries = (gcount GT 0) ? new_entries[good] : 0
   ENDIF
                    ; Ignore subarray images
   DBEXT, new_entries, 'SUBARRAY', aSubarrays
   good = WHERE(STRMID(STRTRIM(aSubarrays,2),0,3) NE 'SUB', gcount)
   new_entries = (gcount GT 0) ? new_entries[good] : 0

   
   IF N_ELEMENTS(first_amp) GT 0 THEN BEGIN
                    ; If set, ignore other amplifiers
      IF NOT KEYWORD_SET(all_amps) THEN BEGIN
         DBEXT, new_entries, 'CCDAMP', aCCDamps
         good = WHERE(STRMID(STRTRIM(aCCDamps,2),0,1) EQ first_amp, gcount)
         new_entries = (gcount GT 0) ? new_entries[good] : 0
      ENDIF
   ENDIF

   return, new_entries
END 

; _____________________________________________________________________________

PRO reno_process_readonly, sState, ERROR=error_code
                    ; could potentially just read from
                    ; sState.data_file_size to end of file
   error_code = 0b
   WIDGET_CONTROL, sState.wFirstIdField, GET_VALUE=iFirstId
   reno_open_session, sState, iFirstId[0], ERROR=error_code
END 
; _____________________________________________________________________________

PRO reno_process_data, sState, RECALCULATE=recalculate, UPDATE=update, $
                       ERROR=error_code
                    ; this routine is only run in write mode
   error_code = 0b
   update=0b
   saved_window = !D.WINDOW
   WSET, sState.draw_index

   reno_wmessage, sState, 'reading parameters...'
   WIDGET_CONTROL, sState.wCommentField, GET_VALUE=strComment
   WIDGET_CONTROL, sState.wFirstIdField, GET_VALUE=iFirstId
   WIDGET_CONTROL, sState.wLastIdField, GET_VALUE=iLastId
   WIDGET_CONTROL, sState.wProcessAmpsButton, GET_VALUE=all_amps

   WIDGET_CONTROL, sState.wFindExprField, GET_VALUE=find_expr

   region = reno_get_region_from_widget(sState)

   unavailable=0b
   DBOPEN, 'acs_log', UNAVAIL=unavailable
   IF unavailable[0] EQ 1 THEN BEGIN
      strMessage = 'Database is unavailable.'
      MESSAGE, strMessage, /CONTINUE
      error_code = 1b
      reno_wmessage, sState, strMessage
      return
   ENDIF 
   latest_entry = reno_get_latest_entry(ERROR=error_code)
   IF error_code[0] NE 0 THEN return

   IF iLastId[0] NE -1 THEN $
    last_entry = latest_entry < iLastId[0] $
   ELSE last_entry = latest_entry

   first_detector = STRTRIM(DBVAL(iFirstId[0], 'DETECTOR'),2)
   first_amp = STRTRIM(DBVAL(iFirstId[0], 'CCDAMP'),2)

   strFilename = reno_get_log_filename(iFirstId)
   append_data = 0
   first_entry = iFirstId[0]
   IF NOT KEYWORD_SET(recalculate) THEN BEGIN
                    ; use existing data
      IF reno_has_state_data(sState) THEN BEGIN
         aEntries = reno_get_state_entries(sState)
         aTimes = reno_get_state_times(sState)
         aNoise = reno_get_state_noise(sState)
         aBiaslevel = reno_get_state_bias(sState)
         aAmps = reno_get_state_amps(sState)
         first_entry = MAX(aEntries)+1
         append_data = 1

         IF iLastId NE -1 AND iLastId LE first_entry THEN BEGIN
            reno_turn_auto_off, sState
            reno_wmessage, sState, $
             'warning: end of sequence reached (see last id)'
            return
         ENDIF
      ENDIF
   ENDIF

   reno_wmessage, sState, 'finding new entries...'
   new_entries = reno_find_new_entries(first_entry,last_entry,$
                                       APPEND=append_data,$
                                       ALL_AMPS=all_amps[0],$
                                       DETECTOR=first_detector,$
                                       AMP=first_amp, $
                                       FIND_EXPR=find_expr)
   PRINT, 'New entries: ',new_entries
   IF new_entries[0] EQ 0 THEN BEGIN
      reno_wmessage, sState, 'no new data available.'
      return
   ENDIF 

   IF KEYWORD_SET(all_amps) THEN $
    chip_numbers = (first_detector EQ 'WFC') ? [1,2] : [1] $
   ELSE chip_numbers = reno_get_chip_number(iFirstId[0],first_amp)

                    ; process the new data
   reno_wmessage, sState, 'processing new entries...'
   reno_compute_noise, new_entries, noise, biaslevel, amp, $
    REGION=region, $
    CHIP=chip_numbers, ERROR=error_code, MESSAGE=strMessage
   IF error_code[0] NE 0 THEN BEGIN
      PRINT, STRING(7b)
      reno_wmessage, sState, strMessage
      return
   ENDIF

   n_noise = N_ELEMENTS(noise)
   n_entries = N_ELEMENTS(new_entries)
   IF n_noise GT n_entries THEN BEGIN
                    ; we have multiple amps per entry
      n_amps = ROUND(n_noise / n_entries)
      pentries = MAKE_ARRAY(n_noise,/LONG)
                    ; duplicate entry numbers
      FOR i=0,n_amps-1 DO pentries[INDGEN(n_entries)*n_amps+i] = new_entries
      new_entries = TEMPORARY(pentries)
   ENDIF 
                    ; append to old data (if exists)
   new_times = reno_get_time_of_entries(new_entries,ERROR=error_code)
   IF error_code[0] NE 0 THEN return
   new_amps = reno_get_amp_of_entries(new_entries,ERROR=error_code)
   IF error_code[0] NE 0 THEN return
   IF append_data THEN BEGIN
      aEntries = [aEntries,new_entries]
      aNoise = [aNoise,noise]
      aBiaslevel = [aBiaslevel,biaslevel]
      aTimes = [aTimes,new_times]
      aAmps = [aAmps,amp]
   ENDIF ELSE BEGIN
      aEntries = new_entries
      aNoise = noise
      aBiaslevel = biaslevel
      aTimes = new_times
      aAmps = amp
   ENDELSE

   IF N_ELEMENTS(aEntries) LE 0 THEN BEGIN
      reno_wmessage, sState, 'no entries to plot'
      return
   ENDIF

   update = 1b
                    ; update the last entry flag
   last_done = MAX(aEntries)
   sState.last_entry = latest_entry
   reno_set_state_entries, sState, aEntries, /NO_COPY
   reno_set_state_times, sState, aTimes, /NO_COPY
   reno_set_state_noise, sState, aNoise, /NO_COPY
   reno_set_state_bias, sState, aBiaslevel, /NO_COPY
   reno_set_state_amps, sState, aAmps, /NO_COPY
   
   IF KEYWORD_SET(sState.write_permission) THEN BEGIN
                    ; write a new log file
      reno_wmessage, sState, 'writing log file...'
      reno_write_log_file, strFilename, new_entries, new_times, noise, $
       biaslevel, amp, ERROR=error, APPEND=append_data
   ENDIF
   return
END

; _____________________________________________________________________________

PRO reno_wmessage, sState, strMessage
   IF N_ELEMENTS(strMessage) GT 0 THEN $
    WIDGET_CONTROL, sState.wMessageText, SET_VALUE=strMessage
   return
END 

; _____________________________________________________________________________

FUNCTION reno_is_recalc_required, sState

                    ; Compare each param that effects the data to the
                    ; value in session config file 
   map_array = [ ['wProcessAmpsButton','ALLAMPS','bool'], $
                 ['wOverscanRegionButton','OREGION','num'], $
                 ['wFirstIdField','FIRSTID','num'], $
                 ['wRegionX0Field','X0','num'], $
                 ['wRegionX1Field','X1','num'], $
                 ['wRegionY0Field','Y0','num'], $
                 ['wRegionY1Field','Y1','num'] ]

   WIDGET_CONTROL, sState.wFirstIdField, GET_VALUE=first_id
   strFilename = reno_get_config_filename(first_id[0])
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

PRO reno_turn_auto_on, sState

                    ; remove button sensitivity
   WIDGET_CONTROL, sState.wRoot, UPDATE=0
   WIDGET_CONTROL, sState.wParamBase, SENSITIVE=0
   WIDGET_CONTROL, sState.wRegionBase, SENSITIVE=0
   WIDGET_CONTROL, sState.wRecalculateButton, SENSITIVE=0
   WIDGET_CONTROL, sState.wResetButton, SENSITIVE=0
   
   IF sState.write_permission THEN BEGIN
                    ; check if a recalculation is required
      recalc = reno_is_recalc_required(sState)
      IF KEYWORD_SET(recalc) THEN BEGIN
         aMessage = ['The configuration has changed so', $
                     'existing data must be recalculated.', '',$
                     'Do you wish to continue?']
         result = DIALOG_MESSAGE(aMessage,/QUESTION,/DEFAULT_NO,$
                                 DIALOG_PARENT=sState.wRoot)
         IF result NE 'Yes' THEN BEGIN
            reno_turn_auto_off, sState
            return
         ENDIF
      ENDIF
                    ; save session
      reno_save_session, sState
   ENDIF
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
      reno_process_data, sState, UPDATE=update, RECALCULATE=recalc, $
       ERROR=error_code
   ENDIF
   IF error_code[0] EQ 0 THEN BEGIN
      IF KEYWORD_SET(update) THEN BEGIN
         reno_update_plot, sState
         IF sState.hardcopy_on_update THEN BEGIN
            reno_update_plot, sState, /PS, /UPDATE, /PRINT
         ENDIF 
      ENDIF
                    ; generate a timer event
      WIDGET_CONTROL, sState.wNewDataTimer, TIMER=5
   ENDIF ELSE BEGIN
      reno_turn_auto_off, sState
      ;;reno_wmessage, sState, 'Database is not available.'
   ENDELSE 
   return
END

; _____________________________________________________________________________

PRO reno_turn_auto_off, sState

                    ; clear all (timer) events
   WIDGET_CONTROL, sState.wBase, /CLEAR_EVENTS
                    ; unset auto track flag
   sState.auto_track = 0b
                    ; toggle droplist
   WIDGET_CONTROL, sState.wRoot, UPDATE=0
   WIDGET_CONTROL, sState.wAutoDropList, SET_DROPLIST_SELECT=0
                    ; make buttons sensitive
   WIDGET_CONTROL, sState.wParamBase, SENSITIVE=1
   WIDGET_CONTROL, sState.wRegionBase, SENSITIVE=1
   IF KEYWORD_SET(write_permission) THEN sense = 1 ELSE sense = 0
   WIDGET_CONTROL, sState.wRecalculateButton, SENSITIVE=sense
   WIDGET_CONTROL, sState.wResetButton, SENSITIVE=1
                    ; display stop message
   ;;WIDGET_CONTROL, sState.wMessageText, SET_VALUE='Auto Off'
   WIDGET_CONTROL, sState.wRoot, UPDATE=1
   return
END

; _____________________________________________________________________________

FUNCTION reno_config_is_good, sState, ERROR=error_code

   error_code = 0b
   status = 1b

   WIDGET_CONTROL, sState.wCommentField, GET_VALUE=strComment
   WIDGET_CONTROL, sState.wFirstIdField, GET_VALUE=iFirstId
   WIDGET_CONTROL, sState.wLastIdField, GET_VALUE=iLastId
   region = reno_get_region_from_widget(sState)

   IF iLastId[0] LT iFirstId[0] AND iLastId[0] NE -1 THEN BEGIN
      WIDGET_CONTROL, sState.wLastIdField, SET_VALUE=iFirstId[0]
      reno_wmessage, sState, $
       'Last entry must be greater than or equal to first'
      status = 0b
      GOTO, done
   ENDIF 

   unavailable=0b
   DBOPEN, 'acs_log', UNAVAIL=unavailable
   IF unavailable[0] EQ 1 THEN BEGIN
      status= 0b
      GOTO, done
   ENDIF 

   detector = reno_get_detector_of_entries(iFirstId[0])
   subarray = reno_get_subarray_of_entries(iFirstId[0])
   ccdxsiz = reno_get_xsize_of_entries(iFirstId[0])
   ccdysiz = reno_get_ysize_of_entries(iFirstId[0])

   CASE STRUPCASE(detector[0]) OF 
      'SBC': BEGIN
         strMessage = 'Cannot process SBC images'
         reno_wmessage, sState, strMessage
         status = 0b
         GOTO, done
      END
      'HRC': BEGIN
      END
      'WFC': BEGIN
      END 
      ELSE: BEGIN
         strMessage = 'Cannot process unknown detector "'+detector[0]+'"'
         reno_wmessage, sState, strMessage
         status = 0b
         GOTO, done
      END
   ENDCASE

   IF (region[1] GE ccdxsiz[0]) OR (region[1] LT 1) THEN BEGIN
      strMessage = 'x1 must be greater than zero and less than n_cols'
      reno_wmessage, sState, strMessage
      status = 0b
      GOTO, done
   ENDIF

   IF (region[0] LT 0) OR (region[0] GE region[1]) THEN BEGIN
      strMessage = 'x0 must be greater than zero and less than x1'
      reno_wmessage, sState, strMessage
      status = 0b
      GOTO, done
   ENDIF
   IF (region[3] GE ccdysiz[0]) OR (region[3] LT 1) THEN BEGIN
      strMessage = 'y1 must be greater than zero and less than n_cols'
      reno_wmessage, sState, strMessage
      status = 0b
      GOTO, done
   ENDIF

   IF (region[2] LT 0) OR (region[2] GE region[3]) THEN BEGIN
      strMessage = 'y0 must be greater than zero and less than y1'
      reno_wmessage, sState, strMessage
      status = 0b
      GOTO, done
   ENDIF

   IF STRMID(subarray[0], 0, 3) EQ 'SUB' THEN BEGIN
      strMessage = 'Cannot process subarray images'
      reno_wmessage, sState, strMessage
      status = 0b
      GOTO, done
   ENDIF

done:
   return, status
END 

; _____________________________________________________________________________

PRO reno_show_about_event, sEvent

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

PRO reno_show_about, sState

   version = sState.version
   version_date = sState.version_date

   wintitle =  STRING(FORMAT='("About Reno (v",A,")")', version)

   message = [ STRING(FORMAT='("Reno version",1X,A)', version), $
               'written by: William Jon McCann', $
               'JHU Advanced Camera for Surveys', $
               version_date ]

   wBase = WIDGET_BASE(TITLE=wintitle, GROUP=sState.wRoot, /COLUMN)

   wLabels = LONARR(N_ELEMENTS(message))

   wLabels[0] = WIDGET_LABEL(wBase, VALUE=message[0], $
                        FONT='helvetica*20', /ALIGN_CENTER)
   FOR i = 1, N_ELEMENTS(message) - 1 DO BEGIN
      wLabels[i] = WIDGET_LABEL(wBase, VALUE=message[i], $
                           FONT='helvetica*14', /ALIGN_CENTER)
   ENDFOR

   wButton = WIDGET_BUTTON(wBase, VALUE='OK', /ALIGN_CENTER, $
                          UVALUE='OK_BUTTON')

   WIDGET_CONTROL, wBase, /REALIZE

   XMANAGER, 'reno_show_about', wBase, /NO_BLOCK

END

; _____________________________________________________________________________

PRO reno_show_help_event, sEvent

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

PRO reno_show_help, sState

   version = sState.version
   version_date = sState.version_date

   wintitle =  STRING(FORMAT='("Reno Help (v",A,")")', version)

   aMessage=[STRING(FORMAT='("Reno version",1X,A)', version), $
             'To open an existing session enter the database entry number of the first', $
             '   image in the sequence into the "First entry" field and hit RETURN or', $
             '   select one of the session files from the File/Open dialog.', $
             'To start a new session enter the database entry of the initial image', $
             '   into the "First entry" field and hit RETURN.', $
             'To start tracking set the "Last entry" to -1 and turn Auto track on.' ]
   
   wBase = WIDGET_BASE(TITLE=wintitle, GROUP=sState.wRoot, /COLUMN)

   wLabels = LONARR(N_ELEMENTS(aMessage))

   wLabels[0] = WIDGET_LABEL(wBase, VALUE=aMessage[0], $
                        FONT='helvetica*20', /ALIGN_CENTER)
   FOR i = 1, N_ELEMENTS(aMessage) - 1 DO BEGIN
      wLabels[i] = WIDGET_LABEL(wBase, VALUE=aMessage[i], $
                           FONT='helvetica*14', /ALIGN_LEFT)
   ENDFOR

   wButton = WIDGET_BUTTON(wBase, VALUE='OK', /ALIGN_CENTER, $
                            UVALUE='OK_BUTTON')

   WIDGET_CONTROL, wBase, /REALIZE

   XMANAGER, 'reno_show_help', wBase, /NO_BLOCK

END 

; _____________________________________________________________________________

PRO reno_plot_widget_event, sEvent

   wLocalStateHandler = WIDGET_INFO(sEvent.handler, /CHILD)
   WIDGET_CONTROL, wLocalStateHandler, GET_UVALUE=sLocalState, /NO_COPY

;   WIDGET_CONTROL, sLocalState.wStateHandler, $
;    GET_UVALUE=sGlobalState, /NO_COPY

   struct_name = TAG_NAMES(sEvent, /STRUCTURE_NAME)
   
   IF STRUPCASE(struct_name) EQ 'WIDGET_BASE' THEN BEGIN
      screen_size = GET_SCREEN_SIZE()
      newx = (sEvent.x-10) < (screen_size[0]-30)
      newy = (sEvent.y-10) < (screen_size[1]-30)

      WIDGET_CONTROL, sLocalState.wDraw, XSIZE=newx, YSIZE=newy

   ENDIF ELSE BEGIN

      WIDGET_CONTROL, sEvent.id, GET_UVALUE=event_uval

      CASE STRUPCASE(event_uval) OF

         'PLOT_DRAW': BEGIN
            saved_window = !D.WINDOW
            WSET, sLocalState.draw_index
            data_coord = CONVERT_COORD(sEvent.x, sEvent.y, /DEVICE, /TO_DATA)
            strOut = STRING(FORMAT='("Read noise",5X,"[",F9.3,",",F9.3,"]")', $
                             data_coord[0], data_coord[1])
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

PRO reno_plot_widget, TopLevelBase, wPlotDraw, $
                 STATE_HANDLER = wStateHandler

   wRoot = WIDGET_BASE(GROUP_LEADER=TopLevelBase, /COLUMN, $
                        TITLE='Read Noise', $
                        UVALUE='PLOT_BASE', $
                        TLB_FRAME_ATTR=8, $
                        /TLB_SIZE_EVENTS)
   wBase = WIDGET_BASE(wRoot, XPAD=0, YPAD=0, SPACE=0, /COLUMN, /ALIGN_CENTER)

   wPlotBase = WIDGET_BASE(wBase, XPAD=0, YPAD=0, SPACE=0, /COLUMN)
   screen_size = GET_SCREEN_SIZE()
   wPlotDraw = WIDGET_DRAW(wPlotBase, XSIZE=screen_size[0]-30, YSIZE=400, $
                            /MOTION_EVENTS, /BUTTON_EVENTS, $
                            UVALUE='PLOT_DRAW', COLORS=-2, RETAIN=2)

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

   XMANAGER, 'reno_plot_widget', wRoot, /NO_BLOCK
   
END

; _____________________________________________________________________________

PRO reno_update_plot, sState, SCREEN=screen, PS=postscript, PRINT=print, $
                      UPDATE=update

   output_device = (KEYWORD_SET(postscript)) ? 'PS' : 'X'

   WIDGET_CONTROL, sState.wCommentField, GET_VALUE=strComment
   WIDGET_CONTROL, sState.wFirstIdField, GET_VALUE=iFirstId
   WIDGET_CONTROL, sState.wLastIdField, GET_VALUE=iLastId
   WIDGET_CONTROL, sState.wOverscanRegionButton, GET_VALUE=bOverscanRegion

   WIDGET_CONTROL, sState.wPlotXminField, GET_VALUE=fPlotXmin
   WIDGET_CONTROL, sState.wPlotXmaxField, GET_VALUE=fPlotXmax
   WIDGET_CONTROL, sState.wPlotYminField, GET_VALUE=fPlotYmin
   WIDGET_CONTROL, sState.wPlotYmaxField, GET_VALUE=fPlotYmax

   IF reno_has_state_data(sState) THEN BEGIN
      aEntries = reno_get_state_entries(sState)
      aTimes = reno_get_state_times(sState)
      aNoise = reno_get_state_noise(sState)
      aBiaslevel = reno_get_state_bias(sState)
      aAmps = reno_get_state_amps(sState)
      first_entry = MAX(aEntries)+1
      
      IF output_device EQ 'PS' THEN BEGIN
         saved_device = !D.NAME
         SET_PLOT, 'PS'
         strPSfile = reno_get_ps_filename(iFirstId[0])
         DEVICE, FILENAME=strPSfile, /LANDSCAPE, /COLOR, BITS_PER_PIXEL=8
         font_type = 0
      ENDIF ELSE BEGIN
         saved_window = !D.WINDOW
         WSET, sState.draw_index
      ENDELSE 
                    ; plot data
      IF PTR_VALID(sState.pEventList) THEN BEGIN
         event_times = *sState.pTimeList
         event_values = *sState.pEventList
      ENDIF 

      reno_wmessage, sState, 'fixing times...'
      ;;aTimes = reno_get_time_of_entries(aEntries)
      good = WHERE(aTimes GE aTimes[0], gcount)
      IF gcount LE 0 THEN return
      PRINT, FORMAT='(I4," of ",I4," entries have valid times")', $
       gcount, N_ELEMENTS(aTimes)
      bad = WHERE(aTimes LT aTimes[0],bcount)
      IF bcount GT 0 THEN PRINT, 'Entries with wrong times:', aEntries[bad]

      reno_wmessage, sState, 'plotting data...'
      reno_plot_data, aEntries[good], aTimes[good], aNoise[good], $
       aBiaslevel[good], aAmps[good], $
       COMMENT=strComment[0], FONT=font_type, $
       EVENT_TIMES=event_times, EVENT_VALUES=event_values, $
       FIRST=iFirstId[0], LAST=iLastId[0], $
       XMIN=fPlotXmin, XMAX=fPlotXmax, YMIN=fPlotYmin, YMAX=fPlotYmax, $
       OVERSCAN=bOverscanRegion
      
      reno_wmessage, sState, 'done.'

      IF output_device EQ 'PS' THEN BEGIN
         DEVICE, /CLOSE
         SET_PLOT, saved_device
         IF KEYWORD_SET(print) THEN BEGIN
            reno_wmessage, sState, 'Executing print command...'
            detector =  reno_get_detector_of_entries(iFirstId[0])
            IF KEYWORD_SET(update) THEN $
             strCmd = reno_get_update_lp_command(strPSfile,detector) $
            ELSE strCmd = reno_get_lp_command(strPSfile,detector)
            SPAWN, strCmd
            reno_wmessage, sState, 'done.'
         ENDIF
      ENDIF ELSE BEGIN
         WSET, saved_window
      ENDELSE
   ENDIF ELSE reno_wmessage, sState, 'no data to plot'

END

; _____________________________________________________________________________

PRO reno_event_add, sState, time, value
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
      reno_update_event_display, sState
      reno_save_session, sState
      reno_update_plot, sState
   ENDIF ELSE BEGIN
      strMessage = 'error parsing time stamp'
      reno_wmessage, sState, strMessage
   ENDELSE 

END 

; _____________________________________________________________________________

FUNCTION reno_get_data_interval, first_entry, latest_entry, detector

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

FUNCTION reno_get_countdown_message, INTERVAL=data_interval, $
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
PRO reno_event, sEvent

                    ; get state information from first child of root
   wChildBase = WIDGET_INFO(sEvent.handler, /CHILD)
   wStateHandler = WIDGET_INFO(wChildBase, /SIBLING)
   WIDGET_CONTROL, wStateHandler, GET_UVALUE=sState, /NO_COPY 

   junk = WHERE('UVALUE' EQ TAG_NAMES(sEvent), uvcount)
   IF uvcount LE 0 THEN $
    WIDGET_CONTROL, sEvent.id, GET_UVALUE=event_uval $
   ELSE event_uval = sEvent.uvalue

   CASE STRUPCASE(event_uval) OF

      'ROOT': BEGIN
         IF TAG_NAMES(sEvent, /STRUCTURE_NAME) EQ 'WIDGET_KILL_REQUEST' $
          THEN BEGIN
            IF sState.auto_track NE 1b THEN BEGIN
               reno_free_pointers, sState
               WIDGET_CONTROL, sEvent.top, /DESTROY
               return
            ENDIF 
         ENDIF
      END 

      'EVENT_LIST':

      'OVERSCAN_REGION_BUTTON': BEGIN
         sState.overscan_region = sEvent.value
         WIDGET_CONTROL, sState.wFirstIdField, GET_VALUE=firstid
         reno_update_overscan_fields, sState, firstid[0], $
          sState.overscan_region
      END

      'FIRSTID_FIELD': BEGIN
         first_id = sEvent.value
         IF first_id GT 0 THEN BEGIN
            reno_open_session, sState, first_id, ERROR=error_flag
            IF error_flag GT 0 THEN BEGIN
               reno_new_session, sState, first_id, ERROR=error_code
               IF error_code[0] NE 0 THEN $
                reno_wmessage, sState, 'Database is unavailable.'
            ENDIF ELSE reno_update_plot, sState
         ENDIF ELSE BEGIN
            reno_wmessage, sState, 'First entry must be greater than zero.'
         ENDELSE
      END 

      'RESET_BUTTON': BEGIN
        IF sState.auto_track NE 1b THEN BEGIN
           WIDGET_CONTROL, sState.wFirstIdField, GET_VALUE=firstid
           reno_open_session, sState, firstid[0]
        ENDIF 
      END

      'PLOT_BUTTON': BEGIN
         reno_update_plot, sState
      END

      'HARDCOPY_BUTTON': BEGIN
         reno_update_plot, sState, /PS, /PRINT
      END

      'RECALCULATE_BUTTON': BEGIN
         IF sState.auto_track NE 1b THEN BEGIN
            aMessage = ['Do you really wish to recalculate', $
                        'the entire data set?', '',$
                        'Warning, existing data will be lost.']
            result = DIALOG_MESSAGE(aMessage,/QUESTION,/DEFAULT_NO,$
                                    DIALOG_PARENT=sState.wRoot)
            IF reno_config_is_good(sState) AND result EQ 'Yes' THEN BEGIN
               reno_save_session, sState
               reno_process_data, sState, /RECALCULATE, UPDATE=update, $
                ERROR=error_code
               IF error_code[0] NE 0 THEN BEGIN
                  update = 0b
                  ;;reno_wmessage, sState, 'Database is not available.'
               ENDIF 
               IF update[0] EQ 1 THEN BEGIN
                  reno_update_plot, sState
                  IF sState.hardcopy_on_update THEN BEGIN
                     reno_update_plot, sState, /PS, /UPDATE, /PRINT
                  ENDIF 
               ENDIF
            ENDIF
         ENDIF
      END 

      'MENU': BEGIN
         CASE sEvent.value OF

            'File.New': BEGIN
               IF sState.auto_track NE 1b THEN BEGIN
                  reno_new_session, sState, ERROR=error_code
                  IF error_code[0] NE 0 THEN $
                   reno_wmessage, sState, 'Database is not available.'
               ENDIF 
            END

            'File.Open': BEGIN
               IF sState.auto_track NE 1b THEN BEGIN
                  reno_open_session, sState, ERROR=error_flag
                  IF error_flag EQ 0 THEN BEGIN
                     reno_update_plot, sState
                  ENDIF 
               ENDIF 
            END

            'File.Save': BEGIN
               IF sState.write_permission GT 0 THEN BEGIN
                  reno_save_session, sState
               ENDIF ELSE BEGIN
                  strMessage = "error: don't have write permission"
                  reno_wmessage, sState, strMessage
               ENDELSE
            END

            'File.Exit': BEGIN
               IF sState.auto_track NE 1b THEN BEGIN
                  reno_free_pointers, sState
                  WIDGET_CONTROL, sEvent.top, /DESTROY
                  return
               ENDIF
            END 

            'Event.Add': BEGIN
               index = WIDGET_INFO(sState.wEventList, /LIST_SELECT)
               IF index[0] NE -1 THEN BEGIN
                  IF PTR_VALID(sState.pEventList) THEN BEGIN
                     time = (*sState.pTimeList)[index[0]]
                     ;;value = (*sState.pEventList)[index[0]]
                  ENDIF ELSE BEGIN
                  ENDELSE
               ENDIF ELSE BEGIN
               ENDELSE 

               strTitle = 'Enter new event'
               sNewEvent = x_get_event(GROUP=sEvent.top, VALUE=value, $
                                        TIME_VALUE=time, $
                                        STATUS=error_status, /STRUCTURE, $
                                        TITLE=strTitle)
               IF error_status EQ 1 THEN BEGIN
                  new_time = sNewEvent.time
                  reno_event_add, sState, sNewEvent.time, sNewEvent.value
               ENDIF
            END
            
            'Event.Edit': BEGIN
               index = WIDGET_INFO(sState.wEventList, /LIST_SELECT)

               IF index[0] NE -1 THEN BEGIN
                  IF PTR_VALID(sState.pEventList) THEN BEGIN
                     aEventList = *sState.pEventList
                     aTimeList = *sState.pTimeList

                     time = aTimeList[index[0]]
                     value = aEventList[index[0]]
                     
                     strTitle = 'Edit event'
                     sNewEvent = x_get_event(GROUP=sEvent.top, $
                                              VALUE=value, $
                                              TIME_VALUE=time, $
                                              STATUS=error_status, $
                                              /STRUCTURE, TITLE=strTitle)
                     IF error_status EQ 1 THEN BEGIN

                        aEventList[index[0]] = sNewEvent.value
                        aTimeList[index[0]] = sNewEvent.time

                        PTR_FREE, sState.pEventList, sState.pTimeList
                        sState.pEventList = PTR_NEW(aEventList, /NO_COPY)
                        sState.pTimeList = PTR_NEW(aTimeList, /NO_COPY)

                        reno_update_event_display, sState
                        reno_save_session, sState
                        reno_update_plot, sState
                     ENDIF
                  ENDIF
               ENDIF
            END
            
            'Event.Remove': BEGIN
               index = WIDGET_INFO(sState.wEventList, /LIST_SELECT)
               
               IF index[0] NE -1 THEN BEGIN
                  IF PTR_VALID(sState.pEventList) THEN BEGIN
                     aEventList = *sState.pEventList
                     aTimeList = *sState.pTimeList

                     all_index = LINDGEN(N_ELEMENTS(aEventList))
                     good_index = WHERE(all_index NE index, wcount)

                     IF wcount GT 0 THEN BEGIN                        
                        aEventList = aEventList[good_index]
                        aTimeList = aTimeList[good_index]
                        PTR_FREE, sState.pEventList, sState.pTimeList
                        sState.pEventList = PTR_NEW(aEventList, /NO_COPY)
                        sState.pTimeList = PTR_NEW(aTimeList, /NO_COPY)
                     ENDIF ELSE BEGIN
                    ; could be only one event in list
                        IF index[0] EQ 0 THEN BEGIN
                           PTR_FREE, sState.pEventList, sState.pTimeList
                           sState.pEventList = PTR_NEW()
                           sState.pTimeList = PTR_NEW()
                        ENDIF
                     ENDELSE
                     reno_update_event_display, sState
                     reno_save_session, sState
                     reno_update_plot, sState
                  ENDIF
               ENDIF
            END 
            'Help.About': reno_show_about, sState
            'Help.Help': reno_show_help, sState
            ELSE:
         ENDCASE 

      END
      
      'AUTO_DROPLIST': BEGIN
         IF WIDGET_INFO(sState.wAutoDropList, /DROPLIST_SELECT) EQ 1 THEN BEGIN
            IF reno_config_is_good(sState) THEN BEGIN
               reno_turn_auto_on,sState
            ENDIF ELSE reno_turn_auto_off,sState
         ENDIF ELSE BEGIN
            reno_turn_auto_off, sState
            reno_wmessage, sState, ' '
         ENDELSE
      END

      'TIMER_EVENT': BEGIN
         IF sState.auto_track EQ 1 THEN BEGIN
            
            WIDGET_CONTROL, sState.wFirstIdField, GET_VALUE=iFirstId
            latest_entry = reno_get_latest_entry(ERROR=error_code)
            IF error_code[0] NE 0 THEN GOTO, done
            n_entries = latest_entry - iFirstId[0]
            last_entry = sState.last_entry
            IF sState.write_permission GT 0 THEN BEGIN
               data_ready = latest_entry GT last_entry
               check_times = reno_get_time_of_entries([iFirstId[0],$
                                                       latest_entry[0]])
               time_is_right = check_times[0] LE check_times[1]
               IF NOT time_is_right THEN BEGIN
                  strMessage = 'Time for new entries is not correct.'
                  PRINT, strMessage
                  reno_wmessage, sState, strMessage
               ENDIF 
               data_ready = data_ready AND time_is_right
            ENDIF ELSE BEGIN
               last_size = sState.data_file_size
               log_size = reno_get_log_file_size(iFirstId)
               data_ready = last_size NE log_size
            ENDELSE 

            IF data_ready THEN BEGIN
               reno_wmessage, sState, 'Processing new data...'
               current_time = SYSTIME(/JULIAN)
               IF sState.write_permission GT 0 THEN BEGIN
                  reno_process_data, sState, UPDATE=update, ERROR=error_code
               ENDIF ELSE BEGIN
                  reno_process_readonly, sState, ERROR=error_code
               ENDELSE 
               IF error_code[0] NE 0 THEN BEGIN
                  update = 0b
                  ;;reno_wmessage, sState, 'Database is not available.'
               ENDIF 

               IF KEYWORD_SET(update) THEN BEGIN
                  sState.last_time = current_time
                  reno_update_plot, sState
                  IF sState.hardcopy_on_update THEN BEGIN
                     reno_update_plot, sState, /PS, /PRINT, /UPDATE
                  ENDIF
                  
                  IF (n_entries GT 5) AND (sState.last_time GT 0) THEN BEGIN
                    ; update data interval
                     detector = reno_get_detector_of_entries(iFirstId[0])
                     data_interval = reno_get_data_interval(iFirstId[0],$
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
               strMessage=reno_get_countdown_message(INTERVAL=data_interval,$
                                                     LAST_TIME=sState.last_time)
               reno_wmessage, sState, strMessage
            ENDELSE

                    ; generate a timer event
            WIDGET_CONTROL, sState.wBase, /CLEAR_EVENTS
            WIDGET_CONTROL, sState.wNewDataTimer, TIMER=5
         ENDIF
      END

      ELSE:
   ENDCASE
done:
   IF WIDGET_INFO(wStateHandler, /VALID_ID) EQ 1 THEN BEGIN
                    ; restore state information
      WIDGET_CONTROL, wStateHandler, SET_UVALUE=sState, /NO_COPY
   ENDIF 

   return
END

; _____________________________________________________________________________

PRO reno, entry, GROUP_LEADER=group_leader, WRITE=write_permission

; ______________________________________
;
; Check input
; ______________________________________

   instance_number = XREGISTERED('reno')
   IF instance_number GT 0 THEN BEGIN
      return
   ENDIF

   LOADCT, 39       ; Rainbow + white color table
   WINDOW, /FREE, XSIZE=2, YSIZE=2, COLORS=64
   temp_window = !D.WINDOW
; ______________________________________

; Define some stuff
; ______________________________________

   strVersion = rcs_revision(' $Revision: 1.14 $ ')
   strVersion_date = rcs_date(' $Date: 2002/01/28 21:57:29 $ ')

   strTLBTitle = STRING(FORMAT='("Reno (v",A,")")', strVersion)

   IF KEYWORD_SET(write_permission) THEN BEGIN
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

   latest_entry = reno_get_latest_entry(ERROR=error_code)
   IF error_code[0] NE 0 THEN BEGIN
      MESSAGE, 'Database not available', /CONTINUE
      return
   ENDIF 
   
   default_config = ''

   IF N_ELEMENTS(entry) GT 0 THEN $
    default_firstid = entry $
   ELSE default_firstid = latest_entry

   default_overscan = 1b
   default_process_amps = 1b
; ______________________________________

; Build Widget
; ______________________________________


   wRoot = WIDGET_BASE(GROUP_LEADER=group_leader, UVALUE='ROOT', $
                       TITLE=strTLBTitle, $
                       /COLUMN, /MAP, MBAR=wMbar, /TLB_KILL_REQUEST_EVENTS, $
                       RESOURCE_NAME='reno', RNAME_MBAR='menubar')

   wBase = WIDGET_BASE(wRoot, /COLUMN)

   wMenuBar = CW_PDMENU(wMbar, /RETURN_FULL_NAME, /MBAR, /HELP, $
                        aMenuList, UVALUE='MENU')

   wEventList = WIDGET_LIST(wBase, UVALUE='EVENT_LIST', XSIZE=30, YSIZE=5, $
                            /MULTIPLE)

   wButtonBase = WIDGET_BASE(wBase, /ALIGN_CENTER, /ROW, UVALUE='BUTTON_BASE')

   wResetButton = WIDGET_BUTTON(wButtonBase, VALUE='Reset', $
                               UVALUE='RESET_BUTTON')
   wPlotButton = WIDGET_BUTTON(wButtonBase, VALUE='Plot', $
                               UVALUE='PLOT_BUTTON')
   wHardcopyButton = WIDGET_BUTTON(wButtonBase, VALUE='Hardcopy', $
                                   UVALUE='HARDCOPY_BUTTON')
   wAutoDropList = WIDGET_DROPLIST(wButtonBase, VALUE=['Off','On'], $
                                   UVALUE='AUTO_DROPLIST', /FRAME, $
                                   TITLE='Auto track')

   wRecalculateButton = WIDGET_BUTTON(wButtonBase, VALUE='Recalculate', $
                                      UVALUE='RECALCULATE_BUTTON')


   wDummyBase = WIDGET_BASE(wBase, UVALUE='TIMER_EVENT')

   wParamBase = WIDGET_BASE(wBase, /COLUMN, /FRAME, UVALUE='PARAM_BASE')

   strValue = default_config
   wCommentField = CW_FIELD(wParamBase, /STRING, VALUE=strValue, $
                            UVALUE='COMMENT_FIELD', XSIZE=45, FONT='courier', $
                            TITLE='Comment  ')

   strAmpLabel = 'Process all amps for this detector'
   wProcessAmpsButton=CW_BGROUP(wParamBase, strAmpLabel, $
                                /NONEXCLUSIVE, FONT='fixed', $
                                UVALUE='PROCESS_AMPS_BUTTON', $
                                SET_VALUE=[default_process_amps EQ 1])
   aOverscanRegionButtons = [ 'Leading     ', 'Trailing' ]
   wOverscanRegionButton = CW_BGROUP(wParamBase, aOverscanRegionButtons, /EXCLUSIVE, $
                                     FONT='courier', /NO_RELEASE, $
                                     UVALUE='OVERSCAN_REGION_BUTTON', /ROW, $
                                     SET_VALUE=default_overscan, $
                                     LABEL_LEFT='Overscan region        ')

   wParamGridBase = WIDGET_BASE(wParamBase, /ROW)
   wParamCol1Base = WIDGET_BASE(wParamGridBase,/COLUMN, UVALUE='PARAMC1_BASE')
   wParamCol2Base = WIDGET_BASE(wParamGridBase,/COLUMN, UVALUE='PARAMC2_BASE')


   wFirstIdField = CW_FIELD(wParamCol1Base, /LONG, VALUE=default_firstid, $
                            XSIZE=6, UVALUE='FIRSTID_FIELD', FONT='courier', $
                            TITLE='    First entry  ', /RETURN_EVENTS)

   wLastIdField = CW_FIELD(wParamCol2Base, /LONG, VALUE='-1', FONT='courier', $
                           XSIZE=6, UVALUE='LASTID_FIELD', $
                           TITLE='     Last entry  ')

   wFindExprField = CW_FIELD(wParamBase, /STRING, VALUE='', FONT='courier', $
                           XSIZE=25, UVALUE='FINDEXPR_FIELD', $
                           TITLE='optional DBFIND expression')

   wRegionLabel = WIDGET_LABEL(wBase, FONT='fixed', /ALIGN_LEFT, VALUE='Overscan region (of each unrotated ampliflier)')
   wRegionBase = WIDGET_BASE(wBase, /COLUMN, UVALUE='REGION_BASE', /FRAME)
   wRegionGridBase = WIDGET_BASE(wRegionBase, /ROW)
   wRegionCol1Base = WIDGET_BASE(wRegionGridBase,/COLUMN, UVALUE='REGIONC1_BASE')
   wRegionCol2Base = WIDGET_BASE(wRegionGridBase,/COLUMN, UVALUE='REGIONC2_BASE')
   wRegionX0Field = CW_FIELD(wRegionCol1Base, /INTEGER, VALUE=0, $
                             XSIZE=6, UVALUE='REGION_X0_FIELD', FONT='courier', $
                             TITLE='             x0  ')

   wRegionX1Field = CW_FIELD(wRegionCol2Base, /INTEGER, VALUE=0, FONT='courier', $
                             XSIZE=6, UVALUE='REGION_X1_FIELD', $
                             TITLE='             x1  ')
   wRegionY0Field = CW_FIELD(wRegionCol1Base, /INTEGER, VALUE=0, $
                             XSIZE=6, UVALUE='REGION_Y0_FIELD', FONT='courier', $
                             TITLE='             y0  ')

   wRegionY1Field = CW_FIELD(wRegionCol2Base, /INTEGER, VALUE=0, FONT='courier', $
                             XSIZE=6, UVALUE='REGION_Y1_FIELD', $
                             TITLE='             y1  ')

   wPlotLabel = WIDGET_LABEL(wBase, FONT='fixed', /ALIGN_LEFT, VALUE='Plot')
   wPlotBase = WIDGET_BASE(wBase, /COLUMN, UVALUE='PLOT_BASE', /FRAME)
   wPlotGridBase = WIDGET_BASE(wPlotBase, /ROW)
   wPlotCol1Base = WIDGET_BASE(wPlotGridBase,/COLUMN, UVALUE='PLOTC1_BASE')
   wPlotCol2Base = WIDGET_BASE(wPlotGridBase,/COLUMN, UVALUE='PLOTC2_BASE')

   wPlotXminField = CW_FIELD(wPlotCol1Base, /FLOAT, FONT='courier', $
                             VALUE=default_plot_xmin, $
                             XSIZE=6, UVALUE='PLOT_XMIN_FIELD', $
                             TITLE='     Plot X min  ')

   wPlotXmaxField = CW_FIELD(wPlotCol2Base, /FLOAT, FONT='courier', $
                             VALUE=default_plot_xmax, $
                             XSIZE=6, UVALUE='PLOT_XMAX_FIELD', $
                             TITLE='     Plot X max  ')

   wPlotYminField = CW_FIELD(wPlotCol1Base, /FLOAT, FONT='courier', $
                             VALUE=default_plot_ymin, $
                             XSIZE=6, UVALUE='PLOT_YMIN_FIELD', $
                             TITLE='     Plot Y min  ')

   wPlotYmaxField = CW_FIELD(wPlotCol2Base, /FLOAT, FONT='courier', $
                             VALUE=default_plot_ymax, $
                             XSIZE=6, UVALUE='PLOT_YMAX_FIELD', $
                             TITLE='     Plot Y max  ')

   wMessageText = WIDGET_TEXT(wBase, YSIZE=1, UVALUE='MESSAGE_TEXT')

   reno_plot_widget, wRoot, wPlotDraw, STATE_HANDLER=wBase
   WIDGET_CONTROL, wPlotDraw, GET_VALUE=draw_index

   WIDGET_CONTROL, /REALIZE, wBase

; ______________________________________

; Setup Widget State
; ______________________________________

   IF NOT KEYWORD_SET(write_permission) THEN BEGIN
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
             wResetButton: wResetButton, $
             wPlotButton: wPlotButton, $
             wHardcopyButton: wHardcopyButton, $
             wRecalculateButton: wRecalculateButton, $
             wCommentField: wCommentField, $
             wProcessAmpsButton: wProcessAmpsButton, $
             wFirstIdField: wFirstIdField, $
             wOverscanRegionButton: wOverscanRegionButton, $
             wLastIdField: wLastIdField, $
             wFindExprField: wFindExprField, $
             wRegionBase: wRegionBase, $
             wRegionX0Field: wRegionX0Field, $
             wRegionX1Field: wRegionX1Field, $
             wRegionY0Field: wRegionY0Field, $
             wRegionY1Field: wRegionY1Field, $
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
             pNoise: PTR_NEW(), $
             pAmps: PTR_NEW(), $
             pBiaslevel: PTR_NEW(), $
             version: strVersion, $
             version_date: strVersion_date, $
             draw_index: draw_index, $
             auto_track: 0b, $
             write_permission: BYTE(KEYWORD_SET(write_permission)), $
             hardcopy_on_update: BYTE(KEYWORD_SET(write_permission)), $
             last_time: -1d, $
             data_file_size: 0l, $
             data_interval: 0d, $
             session_has_data: 0b, $
             overscan_region: default_overscan, $
             last_entry: LONG(latest_entry) $
            }

; ______________________________________

; Update Widget and hand off
; ______________________________________

   IF N_ELEMENTS(entry) GT 0 THEN BEGIN
      reno_open_session, sState, entry
      reno_update_plot, sState
   ENDIF 

   reno_new_session, sState, default_firstid, ERROR=error_code
   IF error_code[0] NE 0 THEN MESSAGE, 'Database is not available', /CONTINUE

                    ; restore state information
   WIDGET_CONTROL, wBase, SET_UVALUE=sState, /NO_COPY   

   WDELETE, temp_window
   WIDGET_CONTROL, wRoot, /CLEAR_EVENTS
   XMANAGER, 'reno', wRoot, /NO_BLOCK

END

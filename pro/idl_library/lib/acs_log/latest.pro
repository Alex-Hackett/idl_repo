;+
; $Id: latest.pro,v 1.10 2001/11/05 22:47:55 mccannwj Exp $
;
; NAME:
;     LATEST
;
; PURPOSE:
;     Notify when the user when a database has been updated.
;
; CATEGORY:
;     ACS
;
; CALLING SEQUENCE:
;     LATEST [, db_name, /LOOP, /BEEP, /ALTBEEP, CMD=, /MVIEW_UPDATE ]
;
; INPUTS:
;
; OPTIONAL INPUTS:
;     db_name   - (STRING) database name to open (defaults to acs_log)
;      
; KEYWORD PARAMETERS:
;     LOOP      - (BOOLEAN) loop continuously.
;     BEEP      - (INTEGER) specify the number of bells to sound when the
;                  database is modified.
;     ALTBEEP   - (INTEGER) specify the number of times to ring the
;                  alternate bell when the database is modified.
;     FREQUENCY - (FLOAT) specify the frequency in Hz for the
;                  alternate bell (implies ALTBEEP=1).
;     CMD       - (STRING) specify an IDL command to be executed upon
;                  the arrival of each new database entry.  The latest
;                  database entry number is available to this command
;                  in the 'entry' variable.  A vector of new entry
;                  numbers since the previous entry number is
;                  available via the 'entries' variable.
;     MVIEW_UPDATE - (BOOLEAN) execute the command 'MVIEW_LOAD, LATEST_ENTRY()'
;                  when a new entry is added to the database.
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
;     Requires IDL version 5.4
;     /ALTBEEP uses SND_PLAY.PRO
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;    Thu Apr 15 19:23:37 1999, William Jon McCann
;-

PRO latest_scale_time, intime, delta_time, time_unit
   delta_time = intime
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
END

FUNCTION latest_format_time, intime

   latest_scale_time, intime, delta_time, time_unit
   IF time_unit EQ 'seconds' THEN BEGIN
      strFormat = '(I6,  1X,A)'
   ENDIF ELSE BEGIN
      strFormat = '(F6.2,1X,A)'
   ENDELSE

   return, STRING(FORMAT=strFormat,delta_time,time_unit)
END 

; _____________________________________________________________________________

FUNCTION latest_format_entry, entry

   return, '#'+STRTRIM(entry,2)
END 

; _____________________________________________________________________________

FUNCTION latest_format_output, last, intime, DBNAME=db_name, $
                               SPINNER=spin_char, NO_SPIN=no_spin
   
   IF N_ELEMENTS( db_name ) LE 0 THEN db_name = "ACS_LOG"

   strTime = latest_format_time(intime)
   strEntry = latest_format_entry(last)
   strFormat = '("Latest ",A," entry is ",A,", installed",1X,A,1X,"ago."'

   IF KEYWORD_SET( no_spin ) THEN BEGIN
      strFormat = strFormat + ')'
      strMessage = STRING( FORMAT=strFormat, db_name, strEntry, strTime )
   ENDIF ELSE BEGIN
      strFormat = strFormat + ',5X,A)'
      strMessage = STRING( FORMAT=strFormat, db_name, strEntry, strTime, $
                           spin_char )
   ENDELSE

   return, strMessage
END

; _____________________________________________________________________________

FUNCTION get_modtime, filename, ERROR=error_flag

   error_flag = 0b

   IF N_ELEMENTS( filename ) LE 0 THEN BEGIN
      MESSAGE, 'filename not specified', /CONT
      error_flag = 1b
      return, -1
   ENDIF

   OPENR, lun, filename, /GET_LUN
   stat = FSTAT(lun)
   FREE_LUN, lun
                    ; check for implementation of MTIME
   junk = WHERE(STRUPCASE(TAG_NAMES(stat)) EQ 'MTIME', count)
   IF count GT 0 THEN $
    delta_time = (SYSTIME(0,/SECONDS) - FLOAT(stat.mtime)) / 3600.0 / 24.0 $
   ELSE delta_time = 0
   return, delta_time[0]
END 

; _____________________________________________________________________________

PRO latest_exec, aExec, entry, prev_entry
   entries = LINDGEN(entry - prev_entry) + prev_entry + 1
   IF N_PARAMS() LT 2 THEN return
   FOR i=0, N_ELEMENTS(aExec)-1 DO retval = EXECUTE( aExec[i] )
END 

; _____________________________________________________________________________

PRO latest_event, sEvent
                    ; get state information from first child of root
                    ; don't use NO_COPY since we might be CNTRL-C'ed
   wStateHandler = WIDGET_INFO( sEvent.handler, /CHILD )
   WIDGET_CONTROL, wStateHandler, GET_UVALUE=sState

   WIDGET_CONTROL, sEvent.id, GET_UVALUE=uvalue
   CASE STRUPCASE(uvalue) OF
      'STOP_BUTTON': BEGIN
         WIDGET_CONTROL, sState.wRoot, /DESTROY
      END
      'PAUSE_BUTTON': BEGIN
         IF sState.pause_on EQ 0 THEN BEGIN
            WIDGET_CONTROL, sState.wPauseButton, SET_VALUE="Resume"
            sState.pause_on = 1
         ENDIF ELSE BEGIN
            WIDGET_CONTROL, sState.wPauseButton, SET_VALUE="Pause "
            sState.pause_on = 0
            WIDGET_CONTROL, sState.wTimer, TIMER=0.0
         ENDELSE
      END
      'TIMER_EVENT': BEGIN
         IF sState.pause_on EQ 0 THEN BEGIN
            DBOPEN, sState.db_name
            last_entry = DB_INFO('entries', 0)

            aSpinners = [ '-', '\', '|', '/' ]
            sState.spinner_index = (sState.spinner_index + 1) MOD $
             N_ELEMENTS( aSpinners )
            spin_value = aSpinners[sState.spinner_index]

            delta_time = get_modtime( sState.filename )
            strEntry = latest_format_entry(last_entry)
            strTime = latest_format_time( delta_time )
            WIDGET_CONTROL, sState.wMessageLabel, SET_VALUE=""
            IF strTime NE sState.prev_time THEN BEGIN
                    ; to prevent flashing if it doesn't change
               WIDGET_CONTROL, sState.wTimeLabel, SET_VALUE=strTime
               sState.prev_time = strTime
            ENDIF 
            WIDGET_CONTROL, sState.wSpinLabel, SET_VALUE=spin_value

            IF last_entry NE sState.prev_entry THEN BEGIN
               WIDGET_CONTROL, sState.wEntryLabel, SET_VALUE=strEntry
               prev_entry = sState.prev_entry
               sState.prev_entry = LONG( last_entry )
               FOR i = 0, sState.number_of_beeps-1 DO BEGIN
                  IF sState.alternate_beep GT 0 THEN BEGIN
                     SND_PLAY, sState.alt_beep_signal, sState.alt_beep_rate
                  ENDIF ELSE BEGIN
                     PRINT, STRING(13b) + STRING(7b), FORMAT='(A,$)'
                  ENDELSE
                  WAIT, .5
               ENDFOR
               IF sState.mview_update GT 0 THEN BEGIN
                  mview_load, last_entry
               ENDIF
               IF sState.aCmd[0] NE '' THEN BEGIN
                  strMessage = 'exec '+sState.aCmd
                  WIDGET_CONTROL, sState.wMessageLabel, SET_VALUE=strMessage
                  latest_exec, sState.aCmd, last_entry, prev_entry
                  WIDGET_CONTROL, sState.wMessageLabel, SET_VALUE="done."
               ENDIF 
            ENDIF
            WIDGET_CONTROL, sState.wTimer, TIMER=1.0
         ENDIF
      END
      ELSE:
   ENDCASE

   IF WIDGET_INFO( wStateHandler, /VALID_ID ) EQ 1 THEN $
    WIDGET_CONTROL, wStateHandler, SET_UVALUE=sState

END
; _____________________________________________________________________________

PRO latest, db_name, LOOP=do_loop, BEEP=beep, DB_DIR=db_dir, $
            ALTBEEP=altbeep, FREQUENCY=frequency, $
            XPOS=x_screen_pos, YPOS=y_screen_pos, $
            MVIEW_UPDATE=mview_update, CMD=exec_cmd

   IF N_ELEMENTS( exec_cmd ) LE 0 THEN exec_cmd = ''
   IF N_ELEMENTS( db_name ) LT 1 THEN db_name = 'acs_log'
   IF N_ELEMENTS( db_dir ) LT 1 THEN db_dir = GETENV( 'ZDBASE' )

   do_beeps_flag = 0b
   number_of_beeps = 0
   IF N_ELEMENTS(beep) GT 0 THEN BEGIN
      number_of_beeps = beep
      do_beeps_flag = 1b
   ENDIF ELSE IF N_ELEMENTS(altbeep) GT 0 THEN BEGIN
      number_of_beeps = altbeep
      do_beeps_flag = 1b
   ENDIF ELSE IF N_ELEMENTS(freq) GT 0 THEN BEGIN
      altbeep = 1
      IF number_of_beeps LE 0 THEN number_of_beeps = 1
      do_beeps_flag = 1b
   ENDIF 

   old_last = 0.
   
   IF N_ELEMENTS(altbeep) GT 0 THEN BEGIN
      alternate_beep_flag = 1b ; set a flag

      ab_amp  = 8e3 ; (amplitude)
      ab_env  = 1e  ; (envelope)
      ab_rate = 8000l ; samples / second
      ab_time = .15 ; second
      
      IF N_ELEMENTS(frequency) EQ 1 THEN BEGIN
         IF (frequency[0] GT 30) AND (frequency[0] LT 4000) THEN $
          ab_freq = frequency[0] $
         ELSE ab_freq = 1000e ; cycles / second
      ENDIF ELSE IF N_ELEMENTS(frequency) GT 1 THEN BEGIN
         ab_freq = frequency > 30 < 4000
      ENDIF ELSE ab_freq = INDGEN(5)*200+200 ; cycles / second
      
      ab_x =  (2*!PI) * ( FINDGEN(ab_rate*ab_time) / (ab_rate*ab_time) )
      
      FOR i = 0, N_ELEMENTS( ab_freq )-1 DO BEGIN
         IF i EQ 0 THEN ab_wave = SIN((ab_freq[i] * ab_time) * ab_x) $
         ELSE ab_wave = [TEMPORARY(ab_wave),SIN((ab_freq[i]*ab_time) * ab_x)]
      ENDFOR

      alt_beep_signal = ab_amp * ab_env * ab_wave

   ENDIF ELSE BEGIN
      alternate_beep_flag = 0b
      alt_beep_signal = 0
      ab_rate = 0
   ENDELSE

   aSpinners = [ '-', '\', '|', '/' ]
   spin_count = 0

LOOP_POINT:

   DBOPEN, db_name
   last_entry = DB_INFO( 'entries', 0 )

   filename = db_dir + '/' + db_name + '.dbf'
   delta_time = get_modtime( filename )

   IF KEYWORD_SET( do_loop ) THEN BEGIN
      IF (!D.FLAGS AND 65536) NE 0 THEN BEGIN
         strTime = latest_format_time(delta_time)
         strEntry = latest_format_entry(last_entry)
         label_font = 'Helvetica*bold*14'
         button_font = 'fixed'
         strLabel1 = 'Latest '+STRUPCASE(db_name)+' entry is '
         strLabel2 = ', installed '
         strLabel3 = ' ago.'

         wRoot = WIDGET_BASE( /COLUMN, TITLE="latest", $
                              TLB_FRAME_ATTR=4 )
         wBase = WIDGET_BASE( wRoot, /COLUMN, XPAD=0, YPAD=0, SPACE=0 )
         wLabelBase = WIDGET_BASE( wBase, /ROW, /FRAME )
         wTextlabel1 = WIDGET_LABEL(wLabelBase,VALUE=strLabel1,$
                                    FONT=label_font)
         wEntryLabel = WIDGET_LABEL( wLabelBase, VALUE=strEntry, $
                                     FONT=label_font, $
                                     /DYNAMIC_RESIZE, UVALUE="TIMER_EVENT" )
         wTextLabel2 = WIDGET_LABEL( wLabelBase, VALUE=strLabel2, $
                                     FONT=label_font)
         wTimeLabel = WIDGET_LABEL( wLabelBase, VALUE=strTime, $
                                    /DYNAMIC_RESIZE, FONT=label_font)
         wTextLabel3 = WIDGET_LABEL( wLabelBase, VALUE=strLabel3, $
                                     FONT=label_font)
         wSpinLabel = WIDGET_LABEL( wLabelBase, VALUE='-' )
         wButtonBase = WIDGET_BASE( wBase, /ROW, /ALIGN_RIGHT, $
                                    XPAD=0, YPAD=0, SPACE=0 )
         wMessageLabel = WIDGET_LABEL( wButtonBase, VALUE='', $
                                       FONT=button_font,/DYNAMIC)
         wPauseButton = WIDGET_BUTTON( wButtonBase, VALUE="Pause ", $
                                       FONT=button_font, $
                                       UVALUE="PAUSE_BUTTON" )
         wStopButton = WIDGET_BUTTON( wButtonBase, VALUE="Stop", $
                                      FONT=button_font, $
                                      UVALUE="STOP_BUTTON" )
         WIDGET_CONTROL, wRoot, /REALIZE
         IF N_ELEMENTS( x_screen_pos ) LE 0 THEN x_screen_pos = 0
         IF N_ELEMENTS( y_screen_pos ) LE 0 THEN y_screen_pos = 0
         WIDGET_CONTROL, wRoot, TLB_SET_XOFF=x_screen_pos, $
          TLB_SET_YOFF=y_screen_pos
         WIDGET_CONTROL, wEntryLabel, TIMER = 1.0

         sState = { wRoot: wRoot, $
                    wEntryLabel: wEntryLabel, $
                    wTimeLabel: wTimeLabel, $
                    wSpinLabel: wSpinLabel, $
                    wTimer: wEntryLabel, $
                    wMessageLabel: wMessageLabel, $
                    wPauseButton: wPauseButton, $
                    wStopButton: wStopButton, $
                    db_name: db_name, $
                    do_beeps: do_beeps_flag, $
                    number_of_beeps: number_of_beeps, $
                    alternate_beep: alternate_beep_flag, $
                    alt_beep_signal: alt_beep_signal, $
                    alt_beep_rate: ab_rate, $
                    mview_update: KEYWORD_SET( mview_update ), $
                    aCmd: exec_cmd, $
                    spinner_index: 0, $
                    pause_on: 0, $
                    filename: filename, $
                    prev_time: strTime, $
                    prev_entry: LONG(last_entry) }
         WIDGET_CONTROL, wBase, SET_UVALUE=sState
         XMANAGER, 'latest', wRoot, /NO_BLOCK
         return
      ENDIF ELSE BEGIN
         strMessage = latest_format_output( last_entry, delta_time, $
                                            SPIN=aSpinners[spin_count] )
         strPrint = STRING( 13b ) + strMessage

         saved_quiet = !QUIET
         !QUIET = 1 ; so the looping won't be interrupted by messages
      
         PRINT, strPrint, FORMAT='(A,$)'
         IF (last GT old_last) AND ( do_beeps EQ 1 ) THEN BEGIN

            FOR i = 0, number_of_beeps-1 DO BEGIN

               IF N_ELEMENTS( altbeep ) GT 0 THEN BEGIN
                  SND_PLAY, alt_beep_signal, ab_rate
               ENDIF ELSE BEGIN
                  PRINT, STRING( 13b ) + STRING( 7b ), FORMAT='(A,$)'
               ENDELSE
               WAIT, .5

            ENDFOR
            old_last = last

         ENDIF
         spin_count = (spin_count + 1) MOD N_ELEMENTS( aSpinners )
         !QUIET = saved_quiet
         WAIT, 2
         GOTO, LOOP_POINT
      ENDELSE

   ENDIF ELSE BEGIN
      strMessage = latest_format_output( last_entry, delta_time, $
                                         SPIN=aSpinners[spin_count] )
      PRINT, strMessage
   ENDELSE

   !QUIET = 0
   return
END

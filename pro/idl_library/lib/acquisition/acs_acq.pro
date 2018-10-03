;+
; $Id: acs_acq.pro,v 1.24 2002/03/05 02:47:48 mccannwj Exp $
;
; NAME:
;     ACS_ACQ
;
; PURPOSE:
;     ACS data acquisition tool.
;
; CATEGORY:
;     ACS
;
; CALLING SEQUENCE:
;     ACS_ACQ
; 
; INPUTS:
;     none.
;
; OPTIONAL INPUTS:
;     none.
;      
; KEYWORD PARAMETERS:
;     ACSVU       - (BOOLEAN) specify the initial "log to acsvu"
;                    status.
;     AUTO_TIME_WINDOW - (FLOAT) specify the initial auto time window.

;     COMMENT     - (STRING) specify the initial comment.
;     INPUT_PATH  - (STRING) specify the initial input (aka incoming)
;                    directory.
;     OUTPUT_PATH - (STRING) specify the initial output directory.
;     PRINT_EVAL  - (BOOLEAN) specify the initial "Print eval" button
;                    status.
;     PRINT_PS    - (BOOLEAN) specify the initial "Print PS" button
;                    status.
;     REACQUIRE   - (BOOLEAN) specify the initial "Reacquire" button
;                    status.
;
; OUTPUTS:
;     none.
;
; OPTIONAL OUTPUTS:
;     none.
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;     Uses environment variables to override default behaviour.
;     [variable]                      [default]
;     ACS_ACQ_LP_COMMAND              lp %s
;     ACS_ACQ_EVAL_LP_COMMAND         lp %s
;
;     Uses ACS_ACQ_NOTIFY environment variable for forced stop email
;     notify list.  Then uses /usr/ucb/Mail to send it.
;
; PROCEDURE:
;	1) Select STIMULUS and ENVIRONMENT with Droplist if change required.
;	2) Enter new INDIR and OUTDIR if required.
;	3) Turn on/off desired desired hardcopy output, reacquisition, or
;		multiple acquisition.
;       4) Operate in Automatic or Manual mode.
;          Automatic (real-time) acquisition looks for new files with a
;          timestamp within 24 hours the current time and logs all
;          subsequent data into the ACS_LOG database and optionally
;          the ACSVU database.
;
;          a) Push the Auto Acquire ON radio button.
;
;          Manual acquisition should be used to selectively log files.
;
;	   a) Start by clicking the 'Acquire data' button.  A file selection
;             dialog will appear.
;	   b) Select the desired files and click OK.  Multiple files
;	      may be selected using the shift and control keys in
;	      combination with a mouse click.
;          c) File selection widget will come back up after data
;             processing is complete.
;          d) If you need to change any of the main widget parameters
;	      push Cancel in the file selection widget. Make the
;	      changes and click the 'Acquire data' button again.
;          e) If you are done, click CANCEL in the file selection dialog.
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;	Version 1, D. Lindler,  March 4, 1999
;               2, W.J.McCann,  March 5, 1999
;-

;______________________________________________________________________________

PRO acs_acq_forced_stop, sState, error_code

   IF N_ELEMENTS(sState) LE 0 THEN STOP
   IF N_ELEMENTS(error_code) LE 0 THEN error_code = 1b

   acs_acq_turn_auto, sState, /OFF

   strMessage1='Auto forced stop - received error code '+STRTRIM(FIX(error_code),2)
   WIDGET_CONTROL, sState.wMessageText, SET_VALUE=strMessage1, /APPEND
   strMessage2 = !ERR_STRING
   WIDGET_CONTROL, sState.wMessageText, SET_VALUE=strMessage2, /APPEND
   IF !JOURNAL NE 0 THEN BEGIN
      JOURNAL, '; '+strMessage1
      JOURNAL, '; '+strMessage2
      FLUSH, !JOURNAL
   ENDIF 
                    ; Make some noise
   n_beeps = 5
   FOR i=0,n_beeps-1 DO BEGIN
      PRINT, STRING(7b)
      WAIT, .5
   ENDFOR 
                    ; Error handling and notification
   notify_email = GETENV('ACS_ACQ_NOTIFY')
   IF notify_email[0] NE '' THEN BEGIN
      email_list = STRSPLIT(notify_email,':',/EXTRACT)
      strSubject = 'ACS Acquire needs attention'
      ;; XXXX THIS IS NOT CROSS PLATFORM XXXX
      FOR i=0,N_ELEMENTS(email_list)-1 DO BEGIN
         strExec = "(echo '"+strMessage1+"'; echo '"+strMessage2+$
          "') | /usr/ucb/Mail -s '"+strSubject+"' "+notify_email[i]
         SPAWN, strExec, /SH
      ENDFOR
   ENDIF

   return
END 

;______________________________________________________________________________

PRO check_file_size, file

                    ; return if SHP file.
   FDECOMP, file, disk, dir, name, ext
   IF ext EQ 'SHP' THEN RETURN

; Routine that checks file size and returns after 5 seconds of no changes
; in the size.

   newsize = -1
   PRINT, file

   REPEAT BEGIN
      lastsize = newsize		
      OPENR, unit, file, /GET_LUN

      f = FSTAT(unit)
      newsize = f.size
      FREE_LUN, unit
      IF (newsize NE lastsize) OR (newsize LE 1) THEN BEGIN
         PRINT, 'size = ', newsize, $
          '  Waiting 5 seconds to see if file is complete'
         WAIT, 5.0
      ENDIF ELSE PRINT, 'size = ', newsize
   ENDREP UNTIL newsize EQ lastsize

   return
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

FUNCTION acs_acq_get_eval_lp_command, strfile
   env_command = GETENV('ACS_ACQ_EVAL_LP_COMMAND')
   default_command = 'lp %s'
   template = (env_command[0] EQ '') ? default_command : env_command[0]
   strCmd = fill_template_string(template+' %s',{s:strfile})
   return, strCmd
END 
; _____________________________________________________________________________

FUNCTION acs_acq_get_lp_command, strPSfile
   env_command = GETENV('ACS_ACQ_LP_COMMAND')
   default_command = 'lp %s'
   template = (env_command[0] EQ '') ? default_command : env_command[0]
   strCmd = fill_template_string(template+' %s',{s:strPSfile})
   return, strCmd
END 

; _____________________________________________________________________________

pro acs_acq_products, id, EVAL=eval, PS=ps, PRINT_PS=print_ps, $
                      PRINT_EVAL=print_eval

; generate standard print products

   IF KEYWORD_SET(eval) THEN BEGIN
      eval_doc, id, /FILE
      IF KEYWORD_SET(print_eval) THEN BEGIN
         strFilename = 'eval_' + STRTRIM(id,2) + '.txt'
         strCmd = acs_acq_get_eval_lp_command(strFilename)
         SPAWN, strCmd
      ENDIF
   ENDIF

   IF KEYWORD_SET(ps) THEN BEGIN
      rashoms_ps, id
      DBOPEN, 'acs_log'
      IF KEYWORD_SET(print_ps) THEN BEGIN
         strFilename = STRTRIM(DBVAL(id,'filename'))+'.ps'
         strCmd = acs_acq_get_lp_command(strFilename)
         SPAWN, strCmd
      ENDIF 
   ENDIF

   return

END

;______________________________________________________________________________

PRO extra_info_fun

   COMMON random, seed

   random_num = RANDOMU( seed )

   LOADCT, 3, /SILENT
   WINDOW, /FREE, XSIZE=1, YSIZE=1
   this_win = !D.WINDOW
   wBase = WIDGET_BASE( TLB_FRAME_ATTR=6 )
   screen_size = GET_SCREEN_SIZE()
   wDraw = WIDGET_DRAW( wBase, XSIZE=screen_size[0], YSIZE=screen_size[1],$
                        RETAIN=2 )
   WIDGET_CONTROL, /REALIZE, wBase
   ERASE
   n_loops = 200

   FOR i=0,n_loops DO BEGIN
      ;ERASE
      IF random_num GE 0.75 THEN BEGIN
         csize = ( 18.0 / FLOAT(n_loops)^2 ) * FLOAT(i)^2 > 1e-4
         orient = ( 720.0 / FLOAT(n_loops) ) * i
         xpos = 0.5
         ypos = 0.5
         align = 0.5
      ENDIF ELSE IF random_num GE 0.50 THEN BEGIN
         csize = ( 18.0 / FLOAT(n_loops)^2 ) * FLOAT(i)^2 > 1e-4
         orient = 0.0
         xpos = ( 0.5 / FLOAT(n_loops) ) * i
         ypos = 0.5
         align = 0.5
      ENDIF ELSE IF random_num GT 0.25 THEN BEGIN
         csize = ( 9.0 / FLOAT(n_loops)^2 ) * FLOAT(i)^2 > 1e-4
         orient = ( 720.0 / FLOAT(n_loops) ) * i
         xpos = ( 0.8 / FLOAT(n_loops) ) * i
         ypos = 0.5
         align = 1.0
      ENDIF ELSE BEGIN
         csize = ( 18.0 / FLOAT(n_loops)^2 ) * FLOAT(i)^2 > 1e-4
         orient = 0.0
         xpos = ( 0.5 / FLOAT(n_loops) ) * i
         ypos = ( 0.5 / FLOAT(n_loops) ) * i
         align = 0.5
      ENDELSE

      color_index = ( !D.N_COLORS / (2*FLOAT(n_loops)) ) * i $
       + !D.N_COLORS/2.0

      strMessage = "Don't do that."
      XYOUTS, xpos, ypos, /NORMAL, strMessage, ALIGN=align, $
       CHARSIZE=csize, CHARTHICK=1.0, ORIENTATION=orient, $
       COLOR=color_index, FONT=-1

      factor = ( 1 + ( (-1.0*SQRT(FLOAT(i))) / SQRT(FLOAT(n_loops)) ) )
      wait_time = 0.05 * factor

      WAIT, wait_time
   ENDFOR 
   XYOUTS, .5, .5, /NORMAL, strMessage, ALIGN=0.5, $
    CHARSIZE=18, CHARTHICK=8.0, ORIENTATION=0, $
    COLOR=!D.N_COLORS, FONT=-1
   WAIT, 3
   ERASE
   n_loops = 50
   n_points = 200
   PLOT, /NODATA, /POLAR, REPLICATE(1.0,n_points), $
    FINDGEN( n_points / (2*!PI) ), XSTYLE=4, YSTYLE=4
   FOR i=0,n_loops DO BEGIN
      rpos = ( 1.0 / FLOAT(n_loops) ) * i
      r = REPLICATE( rpos, n_points )
      theta = FINDGEN( n_points / (2*!PI) )
      color_index = ( !D.N_COLORS / (2*FLOAT(n_loops)) ) * i $
       + !D.N_COLORS/2.0
      OPLOT, /POLAR, r, theta, COLOR=color_index
      WAIT, 0.000000001
   ENDFOR 
   IF WIDGET_INFO( wBase, /VALID ) THEN WIDGET_CONTROL, /DESTROY, wBase
   IF !D.WINDOW EQ this_win THEN WDELETE

END

;______________________________________________________________________________

PRO acs_acq_toggle_widget_sensitivity, sState, ON=on, OFF=off

   IF N_ELEMENTS(sState) LE 0 THEN return

   value = 1
   IF KEYWORD_SET(off) THEN value=0

   WIDGET_CONTROL, sState.wButtons, SENSITIVE=value
   WIDGET_CONTROL, sState.wIndirField, SENSITIVE=value
   WIDGET_CONTROL, sState.wOutdirField, SENSITIVE=value
   WIDGET_CONTROL, sState.wCommentField, SENSITIVE=value
   WIDGET_CONTROL, sState.wStimulusDropList, SENSITIVE=value
   WIDGET_CONTROL, sState.wEnvironmentDropList, SENSITIVE=value
   WIDGET_CONTROL, sState.wAutoTimeWindowField, SENSITIVE=value
   WIDGET_CONTROL, sState.wExitButton, SENSITIVE=value
   WIDGET_CONTROL, sState.wAcquireButton, SENSITIVE=value
   WIDGET_CONTROL, sState.wCheckButton, SENSITIVE=value

   return
END 

;______________________________________________________________________________

PRO acs_acq_turn_auto, sState, ON=on, OFF=off

   IF N_ELEMENTS(sState) LE 0 THEN return

   value = 'OFF'
   IF KEYWORD_SET(on) THEN value='ON'

   CASE value OF
      'ON': BEGIN
                    ; remove button sensitivity
         acs_acq_toggle_widget_sensitivity, sState, /OFF
         
                    ; set auto acquire flag
         sState.auto_acquire = 1b
         
         WIDGET_CONTROL, sState.wAutoButton, SET_VALUE=1

                    ; display start message
         strValue = 'Start Auto: ' + SYSTIME()
         IF !JOURNAL NE 0 THEN BEGIN
            JOURNAL, '; '+strValue
            FLUSH, !JOURNAL
         ENDIF
         WIDGET_CONTROL, sState.wMessageText, SET_VALUE=strValue, /APPEND
         strTitle = STRING( FORMAT='(A0,2X,"[",A0,"]")', 'ACS data acquisition', 'ON' )
         WIDGET_CONTROL, sState.wBase, TLB_SET_TITLE=strTitle
         
                    ; generate a timer event
         WIDGET_CONTROL, sState.wTopLabel, TIMER=5
      END
      'OFF': BEGIN
                    ; clear all (timer) events
         WIDGET_CONTROL, sState.wBase, /CLEAR_EVENTS

                    ; unset auto acquire flag
         sState.auto_acquire = 0b

                    ; make buttons sensitive
         acs_acq_toggle_widget_sensitivity, sState, /ON

         WIDGET_CONTROL, sState.wAutoButton, SET_VALUE=0

                    ; display stop message
         strValue = 'Stop Auto:  ' + SYSTIME()
         IF !JOURNAL NE 0 THEN BEGIN
            JOURNAL, '; '+strValue
            FLUSH, !JOURNAL
         ENDIF 
         WIDGET_CONTROL, sState.wMessageText, SET_VALUE=strValue, /APPEND
         strTitle = STRING( FORMAT='(A0,2X,"[",A0,"]")', 'ACS data acquisition', 'OFF' )
         WIDGET_CONTROL, sState.wBase, TLB_SET_TITLE=strTitle
      END
      ELSE:
   ENDCASE

   return
END 

; _____________________________________________________________________________

FUNCTION acs_acq_mjd_from_filename, filenames

   n_files = N_ELEMENTS(filenames)
   mjd = MAKE_ARRAY(n_files, /DOUBLE)

   current_year = LONG((BIN_DATE(SYSTIME()))[0] )
   year_range = LONG(current_year + FINDGEN(100) - 50)
   last_two_range = STRMID(STRTRIM(year_range,2), 2, 2)
   FOR i=0l,n_files-1 DO BEGIN
      FDECOMP, filenames[i], disk, dir, name
      init_offset = 4
      year = STRMID(name,init_offset,2)
      year_index = WHERE( year EQ last_two_range )
      year_four = (year_range[year_index])[0]
      yday = STRMID(name,init_offset+2,3)
      hour = STRMID(name,init_offset+5,2)
      min  = STRMID(name,init_offset+7,2)
      sec  = STRMID(name,init_offset+9,2)
      date = LONG([ year_four, yday, hour, min, sec ])
      mjd[i] = JUL_DATE(DATE_CONV(date,'S')) - 0.5
   ENDFOR

   IF n_files EQ 1 THEN mjd = mjd[0]
   return, mjd
END

; _____________________________________________________________________________

FUNCTION acs_acq_auto_find_files, indir, last_file, $
                                  WINDOW=nday_window, COUNT=count

   IF N_ELEMENTS(indir) LE 0 THEN indir='.'
   IF N_ELEMENTS(nday_window) LE 0 THEN nday_window = 3.0

   count = 0
   files = ''
                    ; determine mjds for the files
   directory_list = FINDFILE(indir+'*.S*', COUNT=dir_count)
   IF dir_count LE 0 THEN return, ''
   
   dir_mjd = acs_acq_mjd_from_filename(directory_list)
   
   current_mjd = JUL_DATE(DATE_CONV(!STIME, 'S')) - 0.5
   diff_mjd = dir_mjd - current_mjd

   good = WHERE(ABS(diff_mjd) LE nday_window, gcount)

   IF gcount GT 0 THEN BEGIN
      list = directory_list[good]
   ENDIF ELSE return, ''

                    ; select only a subset of the available files
                    ; within a +/- 1 day window of the current time
   list_mjd = dir_mjd[good]

                    ; sort the list in order of MJD
                    ; NOT by filename since it has a 2 digit year
   sort_index = SORT(list_mjd)
   list_mjd = list_mjd[sort_index]
   list     = list[sort_index]

   IF N_ELEMENTS(last_file) GT 0 THEN BEGIN
      IF last_file NE '' THEN BEGIN
                    ; Here's an important special case:
                    ; If the last file acquired is an SDI file and
                    ; there exists an SHP file with the same filename
                    ; then only look for files with different timestamps.
         FDECOMP, last_file, last_disk, last_dir, last_name, last_ext
         skip_shp = 0b
         IF STRUPCASE(STRTRIM(last_ext,2)) EQ 'SDI' THEN BEGIN
            shp_filename = last_disk+last_dir+last_name+'.'+'SHP'
            junk=FINDFILE(shp_filename,COUNT=last_c)
            IF last_c GT 0 THEN BEGIN
               PRINT, 'notice: skipping SHP since SDI was already acquired.'
               skip_shp = 1b
            ENDIF 
         ENDIF
                    ; get the MJD of the last_file
         last_mjd = acs_acq_mjd_from_filename(last_file)

                    ; find where the timestamp is greater than or
                    ; equal but the filename is not equal
         list = STRTRIM(list,2)
         last_file = STRTRIM(last_file,2)
         IF skip_shp EQ 1 THEN BEGIN
            found = WHERE((list_mjd GT last_mjd), nfound)
         ENDIF ELSE BEGIN
            found = WHERE((list_mjd GE last_mjd) AND (list NE last_file),$
                          nfound)
         ENDELSE

         IF nfound GT 0 THEN file_i = found ELSE return, ''
      ENDIF ELSE file_i = INDGEN(N_ELEMENTS(list))
   ENDIF ELSE file_i = INDGEN(N_ELEMENTS(list))

   files = list[file_i]

   count = N_ELEMENTS(files)
   return, files
END

; _____________________________________________________________________________

FUNCTION acs_acq_get_next_file, indir, last_file, $
                                WINDOW=nday_window, IS_LAST=is_last

   is_last = 1b
                    ; Shift a file off the queue
   list = acs_acq_auto_find_files(indir, last_file, $
                                  WINDOW=nday_window, COUNT=count)
   IF count[0] LE 0 THEN next_file='' ELSE BEGIN
      next_file=list[0]
      IF count[0] GT 1 THEN is_last=0b
   ENDELSE

   return, next_file
END 

; _____________________________________________________________________________

PRO acs_acq_autolog_next, indir, outdir, stimulus, environment, $
                          PRINT_PS=print_ps, $
                          PRINT_EVAL=print_eval, $
                          LAST_FILE=last_file, $
                          IS_LAST=is_last, $
                          DO_ACSVU=do_acsvu, $
                          FORCE=force, $
                          COMMENT=comment, $
                          WINDOW=nday_window, $
                          ERROR=error_code, TEXT_MESSAGE=strMessage

   strMessage = ''
   error_code = 0b
                    ; auto acquire next file from the incoming directory
   !PRIV = 2
   
   file = acs_acq_get_next_file(indir, last_file, $
                                WINDOW=nday_window, IS_LAST=is_last)
   IF file[0] EQ '' THEN return

   FDECOMP, file, disk, dir, name, ext

   CASE STRUPCASE(ext) OF
         
      'SDI': BEGIN

                    ; check recent entries for file

         DBOPEN, 'acs_log'
         nentry = DB_INFO( 'entries' )
         IF nentry[0] GT 500 THEN entry_window=500 ELSE entry_window=0
         dblist = DBFIND( /SILENT, $
                          'entry>'+STRTRIM(nentry[0]-entry_window,2)+$
                          ',filename='+name)

         IF dblist[0] GT 0 THEN BEGIN
            PRINT, 'File '+name+'.SDI was previously acquired'
            IF NOT KEYWORD_SET(force) THEN BEGIN
               strMessage = name+'.SDI previously acquired'
               GOTO, DONE
            ENDIF ELSE BEGIN
               PRINT, '   forced acquisition'
            ENDELSE 
         ENDIF

                    ; check to see if file is complete if it is the
                    ; last file.
         IF is_last THEN check_file_size, file

         shp_file_with_same_name = disk+dir+name+'.SHP'
         junk = FINDFILE(shp_file_with_same_name, COUNT=fshp_count)
         IF fshp_count GT 0 THEN BEGIN
                    ; Acquire SHP first if it has same filestamp as SDI
            acs_acquire, shp_file_with_same_name, /LOG, OUTDIR=outdir, $
             STIMULUS_IN=stimulus, ENVIRONMENT=environment, $
             ID1=id1, ID2=id2, ERROR=error_code
            IF error_code[0] NE 0 THEN strMessage=shp_file_with_same_name+'     error!' $
            ELSE strMessage=shp_file_with_same_name
            
            IF error_code[0] NE 0 THEN return
         ENDIF

                    ; check that SDI file still exists
         junk = FINDFILE( file, COUNT=f_count )
         IF (f_count LE 0) THEN BEGIN
            MESSAGE, 'file mysteriously disappeared: '+file, /INFO
            GOTO, DONE
         ENDIF

                    ; Acquire it
         acs_acquire, file, /LOG, OUTDIR=OUTDIR, STIMULUS_IN=stimulus, $
          ENVIRONMENT=environment, ID1=id1, ID2=id2, ERROR=error_code

                    ; If no ids are updated or an error occurred
         IF (N_ELEMENTS(id1) LE 0) OR (N_ELEMENTS(id2) LE 0) $
          OR (error_code[0] NE 0) THEN BEGIN
            strMessage = name+'.'+ext+'     error!'
            return
         ENDIF

                    ; For each of the ids generated, create paper products
         FOR id=LONG(id1), id2 DO BEGIN
            acs_acq_products, id, EVAL=print_eval, PS=print_ps, $
             PRINT_PS=print_ps, PRINT_EVAL=print_eval
         ENDFOR

         strMessage = name+'.'+ext+STRING(id1,FORMAT='(I7)')+STRING(id2,FORMAT='(i7)')

         IF KEYWORD_SET(do_acsvu) THEN BEGIN
                    ; Log into ACSVU
            net_pos = STRPOS( file, '/net' )
            IF net_pos NE -1 THEN acsvu_file = STRMID(file, net_pos+11) $
            ELSE acsvu_file = file

            PRINT, 'sending to ACSVU: ' + acsvu_file
            log_acsvu, acsvu_file, COMMENT=comment
         ENDIF

      END

      'SHP': BEGIN
                    ; check to see that the last file was not an SDI
                    ; with the same timestamp
         sdi_file = disk+dir+name+'.SDI'
         IF (sdi_file NE STRTRIM(last_file,2)) THEN BEGIN
                    ; Acquire it
            acs_acquire, file, /LOG, OUTDIR=OUTDIR, STIMULUS_IN=stimulus, $
             ENVIRONMENT=environment, ID1=id1, ID2=id2, ERROR=error_code

            IF error_code NE 0 THEN strMessage=name+'.'+ext+'     error!' $
            ELSE strMessage=name+'.'+ext

            IF error_code[0] NE 0 THEN return
         ENDIF
      END 

      ELSE: BEGIN
                    ; check to see if file is complete if last on the list
         IF is_last THEN check_file_size, file

                    ; check that file still exists
         junk = FINDFILE(file, COUNT=f_count)
         IF (f_count LE 0) THEN BEGIN
            MESSAGE, 'file mysteriously disappeared: '+file, /INFO
            GOTO, DONE
         ENDIF

         IF KEYWORD_SET(do_acsvu) THEN BEGIN
                    ; Log into ACSVU
            net_pos = STRPOS(file, '/net')
            IF net_pos NE -1 THEN acsvu_file = STRMID(file, net_pos+11) $
            ELSE acsvu_file = file

            PRINT, 'sending to ACSVU: ' + acsvu_file
            log_acsvu, acsvu_file, COMMENT=comment
         ENDIF
            
         strMessage = name+'.'+ext
      END

   ENDCASE

   PRINT, STRJOIN(REPLICATE('_',80))

DONE:

   last_file = file

   return
END

;______________________________________________________________________________

PRO acs_acq_event, sEvent

   wStateHandler = WIDGET_INFO(sEvent.handler, /CHILD)
   WIDGET_CONTROL, wStateHandler, GET_UVALUE=sState

   WIDGET_CONTROL, sEvent.id, GET_UVALUE=event_uval

   CASE event_uval OF

      'EXIT_BUTTON': BEGIN
         WIDGET_CONTROL, sEvent.top, /DESTROY
         return
      END

      'CHECK_BUTTON': BEGIN
         WIDGET_CONTROL, sState.wIndirField, GET_VALUE=indir
         WIDGET_CONTROL, sState.wAutoTimeWindowField, GET_VALUE=nday_window
         indir = STRTRIM(indir[0],0)
         last_file = sState.last_file
         list = acs_acq_auto_find_files(indir, last_file, $
                                        WINDOW=nday_window, COUNT=count)
         IF count[0] GT 0 THEN BEGIN
            x_display_list, list, TITLE='Files Auto will acquire', $
             GROUP=sState.wRoot
         ENDIF ELSE PRINT, 'Auto acquire found no new files.'
      END

      'ACQUIRE_BUTTON': BEGIN
                    ; get control parameters for acs_data

         WIDGET_CONTROL, sState.wButtons, GET_VALUE=bval
         
         strStimulus = sState.aStimuli(WIDGET_INFO(sState.wStimulusDropList, $
                                                   /DROPLIST_SELECT ) )
         strEnviron = $
          sState.aEnvironments(WIDGET_INFO(sState.wEnvironmentDropList, $
                                           /DROPLIST_SELECT))
         WIDGET_CONTROL, sState.wIndirField, GET_VALUE=indir
         WIDGET_CONTROL, sState.wOutdirField, GET_VALUE=outdir
         strMessage = strStimulus + '   ' + strEnviron
         WIDGET_CONTROL, sState.wMessageText, SET_VALUE=strMessage, /APPEND
         IF !JOURNAL NE 0 THEN BEGIN
            JOURNAL, '; '+strMessage
            FLUSH, !JOURNAL
         ENDIF 

                    ; remove button sensitivity
         acs_acq_toggle_widget_sensitivity, sState, /OFF

                    ; begin data acquisition

         outdir = STRTRIM( outdir[0] )
         IF STRMID(outdir,STRLEN(outdir)-1,1) NE '/' THEN outdir = outdir+'/'
         acs_data, REACQUIRE=bval[1], MULTIPLE=bval[0], $
          STIMULUS=strStimulus[0], ENVIRONMENT=strEnviron[0], $
          INDIR=indir[0], OUTDIR=outdir[0], PS=bval[2], $
          PRINT_PS=bval[2], EVAL=bval[3], LAST_FILE=this_file, $
          PRINT_EVAL=bval[3], TEXT_BASE=sState.wMessageText, $
          SELECTED=selected

                    ; Optionally log selected files into ACSVU
         IF bval[4] GT 0 THEN BEGIN
            good = WHERE(STRTRIM(selected,2) NE '',gcount)
            IF gcount GT 0 THEN BEGIN
               WIDGET_CONTROL, sState.wCommentField, GET_VALUE=comment
               log_acsvu, selected[good], COMMENT=comment[0]
            ENDIF
         ENDIF 

                    ; make buttons sensitive
         acs_acq_toggle_widget_sensitivity, sState, /ON
      END

      'INFO_BUTTON': BEGIN
         extra_info_fun
      END

      'AUTO_BUTTON': BEGIN
         IF STRUPCASE(sEvent.value) EQ 'AUTO_ON' THEN BEGIN
            acs_acq_turn_auto, sState, /ON
         ENDIF ELSE BEGIN
            acs_acq_turn_auto, sState, /OFF
         ENDELSE
      END

      'TIMER_EVENT': BEGIN 

         IF sState.auto_acquire EQ 1 THEN BEGIN
                    ; get control parameters for acs_data

            WIDGET_CONTROL, sState.wButtons, GET_VALUE=bval
            strStimulus = $
             sState.aStimuli( WIDGET_INFO( sState.wStimulusDropList, $
                                           /DROPLIST_SELECT ) )
            strEnviron = $
             sState.aEnvironments( WIDGET_INFO( sState.wEnvironmentDropList, $
                                                /DROPLIST_SELECT ) )

            WIDGET_CONTROL, sState.wIndirField, GET_VALUE=indir
            WIDGET_CONTROL, sState.wOutdirField, GET_VALUE=outdir
            WIDGET_CONTROL, sState.wCommentField, GET_VALUE=comment
            WIDGET_CONTROL, sState.wAutoTimeWindowField, GET_VALUE=nday_window

            outdir = STRTRIM( outdir[0] )

            IF STRMID( outdir, STRLEN(outdir)-1, 1 ) NE '/' THEN $
             outdir = outdir+'/'
            indir = STRTRIM( indir[0] )
            IF STRMID( indir, STRLEN(indir)-1,1) NE '/' THEN $
             indir = indir+'/'

                    ; begin auto data acquisition

            last_file = sState.last_file
            acs_acq_autolog_next, indir,outdir, strStimulus[0],strEnviron[0], $
             PRINT_PS=bval[2], PRINT_EVAL=bval[3], IS_LAST=is_last, $
             LAST_FILE=last_file, DO_ACSVU=bval[4], FORCE=bval[5], $
             COMMENT=comment, $
             ERROR=error_code, TEXT_MESSAGE=strMessage, WINDOW=nday_window

            IF strMessage[0] NE '' THEN BEGIN
               WIDGET_CONTROL, sState.wMessageText, SET_VALUE=strMessage, $
                /APPEND
               IF !JOURNAL NE 0 THEN BEGIN
                  JOURNAL, '; '+strMessage
                  FLUSH, !JOURNAL
               ENDIF 
            ENDIF 
            IF error_code[0] NE 0 THEN BEGIN
               acs_acq_forced_stop, sState, error_code
            ENDIF 

            sState.last_file=last_file
            
                    ; If there are more files then we should 
                    ; come back quickly
            IF NOT is_last THEN timer_delay=0.0 ELSE timer_delay=5.0

                    ; generate a timer event
            WIDGET_CONTROL, sState.wTopLabel, TIMER=timer_delay
         ENDIF
      END
      
      ELSE: 

   ENDCASE

   IF WIDGET_INFO( wStateHandler, /VALID_ID ) EQ 1 THEN BEGIN
                    ; restore state information
      WIDGET_CONTROL, wStateHandler, SET_UVALUE=sState, /NO_COPY
   ENDIF 
   
   return
END

; _____________________________________________________________________________

PRO acs_acq, INPUT_PATH=in_input_path, OUTPUT_PATH=in_output_path, $
             COMMENT=in_comment, ACSVU=in_acsvu, REACQUIRE=in_reacquire, $
             PRINT_PS=in_print_ps, PRINT_EVAL=in_print_eval, $
             AUTO_TIME_WINDOW=in_auto_time_window

   IF N_ELEMENTS(in_input_path) LE 0 THEN BEGIN
      strInputDir = '/net/bigdog/usr/home/bigdog1/scidata/images/incoming/'
   ENDIF ELSE BEGIN
                    ; check that it is valid
      in_input_test = FILE_TEST(in_input_path,/DIRECTORY)
      IF in_input_test EQ 1 THEN BEGIN
         strInputDir = STRTRIM(in_input_path,2)
      ENDIF ELSE BEGIN
         MESSAGE, 'Specified input directory not found: '+in_input_path
      ENDELSE
   ENDELSE 

   IF N_ELEMENTS(in_output_path) LE 0 THEN BEGIN
      strOutputDir = '/acs/data1/jdata/'
   ENDIF ELSE BEGIN
                    ; check that it is valid
      in_output_test = FILE_TEST(in_output_path,/DIRECTORY)
      IF in_output_test EQ 1 THEN BEGIN
         strOutputDir = STRTRIM(in_output_path,2)
      ENDIF ELSE BEGIN
         MESSAGE, 'Specified output directory not found: '+in_output_path
      ENDELSE
   ENDELSE 

   IF N_ELEMENTS(in_comment) LE 0 THEN BEGIN
      strComment   = 'Science data'
   ENDIF ELSE strComment = in_comment

   initial_multiple_file_button_state = 1

   IF N_ELEMENTS(in_reacquire) GT 0 THEN $
    initial_reacquire_button_state = KEYWORD_SET(in_reacquire) $
   ELSE initial_reacquire_button_state = 0

   IF N_ELEMENTS(in_print_ps) GT 0 THEN $
    initial_print_ps_button_state = KEYWORD_SET(in_print_ps) $
   ELSE initial_print_ps_button_state = 1

   IF N_ELEMENTS(in_acsvu) GT 0 THEN $
    initial_acsvu_button_state = KEYWORD_SET(in_acsvu) $
   ELSE initial_acsvu_button_state = 1

   IF N_ELEMENTS(in_print_eval) GT 0 THEN $
    initial_print_eval_button_state = KEYWORD_SET(in_print_eval) $
   ELSE initial_print_eval_button_state = 0

   initial_force_button_state = 0

   IF N_ELEMENTS(in_auto_time_window) GT 0 THEN $
    initial_auto_time_window = FLOAT(in_auto_time_window) $
   ELSE initial_auto_time_window = 3.0

                    ; create widget layout

   strTitle = STRING( FORMAT='(A0,2X,"[",A0,"]")', 'ACS data acquisition', 'OFF' )

   wRoot = WIDGET_BASE(/COLUMN, TITLE=strTitle)

   wBase = WIDGET_BASE(wRoot, /COLUMN)

   strIndirLabel    = 'Input Dir  '
   strOutdirLabel   = 'Output Dir '
   strCommentLabel  = 'Comment    '
   strStimulusLabel = 'Stimulus   '
   strEnvironLabel  = 'Environment'
   strTitleLabel = 'ACS Data Acquisition     '
   title_font = 'Helvetica*bold*18'
   selection_font = 'Courier'
   strAutoWindowLabel = 'Auto time window (days) '

   wTopLabel = WIDGET_LABEL(wBase, VALUE=strTitleLabel, $
                            FONT=title_font, /ALIGN_RIGHT, $
                            UVALUE='TIMER_EVENT')

   wIndirField = CW_FIELD(wBase, /ROW, XSIZE=65, TITLE=strIndirLabel, $
                          FONT=selection_font, $
                          UVALUE='INDIR_FIELD', $
                          VALUE=strInputDir)
   
   wOutdirField = CW_FIELD(wBase, /ROW, XSIZE=65, TITLE=strOutdirLabel, $
                           FONT=selection_font, $
                           UVALUE='OUTDIR_FIELD', VALUE=strOutputDir)

   wCommentField = CW_FIELD(wBase, /ROW, TITLE=strCommentLabel, XSIZE=25, $
                            FONT=selection_font, $
                            UVALUE='COMMENT_FIELD', VALUE=strComment)
   
   wBase1 = WIDGET_BASE(wBase, /ROW, XPAD=0)
   wBase1a = WIDGET_BASE(wBase1, /COL, XPAD=0)
   wBase1b = WIDGET_BASE(wBase1, /COL, XPAD=0)

   astrStimulus = ['NONE','STUFF','RASCAL','MONOHOMS','RAS/HOMS','INT_SPHR','SPECIAL']
   wStimulusDropList = WIDGET_DROPLIST(wBase1a, VALUE=astrStimulus, $
                                       FONT=selection_font, $
                                       UVALUE='STIMULUS_DROPLIST', $
                                       TITLE=strStimulusLabel)

   astrEnvironments = ['AMBIENT','VACUUM','PURGE','SMOG']
   wEnvironmentDropList = WIDGET_DROPLIST(wBase1a, VALUE=astrEnvironments, $
                                          FONT=selection_font, $
                                          UVALUE='ENVIRONMENT_DROPLIST', $
                                          TITLE=strEnvironLabel)
   
   wAutoTimeWindowField = CW_FIELD(wBase1a, /ROW, XSIZE=5, $
                                   TITLE=strAutoWindowLabel, $
                                   FONT=selection_font, $
                                   /FLOAT, $
                                   UVALUE='AUTOWINDOW_FIELD', $
                                   VALUE=initial_auto_time_window)

   astrButtonNames = ['Enable Multiple File Selection', 'Reacquire Data', $
                      'Print PS file', 'Print Evaluation Form', $
                      'Log into ACSVU', 'Force acquisition' ]
   astrButtonUvalues = ['MULTIPLE_BUTTON', 'REACQUIRE_BUTTON', $
                        'PRINTPS_BUTTON', 'EVAL_BUTTON', 'ACSVU_BUTTON', 'FORCE_BUTTON' ]
   initial_button_state = [initial_multiple_file_button_state, $
                           initial_reacquire_button_state, $
                           initial_print_ps_button_state, $
                           initial_print_eval_button_state, $
                           initial_acsvu_button_state, $
                           initial_force_button_state]

   wButtons = CW_BGROUP( wBase1a, astrButtonNames, /NONEXCL, /COLUMN, $
                         SET_VALUE=initial_button_state, $
                         BUTTON_UVALUE=astrButtonUvalues,$
                         UVALUE='BUTTON_GROUP' )
   
   wAcquireButton = WIDGET_BUTTON(wBase1a, VALUE='Acquire Data', $
                                  UVALUE='ACQUIRE_BUTTON')

   wInfoButton = WIDGET_BUTTON( wBase1a, VALUE='Fill in extra information', $
                                UVALUE='INFO_BUTTON' )
   wExitButton = WIDGET_BUTTON( wBase1a, VALUE='EXIT', UVALUE='EXIT_BUTTON')

   wBase1b1 = WIDGET_BASE(wBase1b, /ROW, /FRAME, XPAD=0, YPAD=0, SPACE=0)

   aAutoButtonNames = ['off','on']
   aAutoButtonUvalues = ['AUTO_OFF', 'AUTO_ON']
   wAutoButton = CW_BGROUP( wBase1b1, aAutoButtonNames, /EXCL, /ROW, $
                            SET_VALUE=0, BUTTON_UVALUE=aAutoButtonUvalues, $
                            UVALUE='AUTO_BUTTON', LABEL_LEFT='Auto Acquire', $
                            /NO_RELEASE )
   wCheckButton = WIDGET_BUTTON(wBase1b1,VALUE='Check',UVALUE='CHECK_BUTTON',$
                                FONT=selection_font)

   wMessageText = WIDGET_TEXT( wBase1b, XSIZE=40, YSIZE=18, /SCROLL, $
                               UVALUE='MESSAGE_TEXT' )

                    ; create widget

   WIDGET_CONTROL, wBase, /REALIZE
   WIDGET_CONTROL, wMessageText, SET_VALUE='Check STIMULUS and ENVIRONMENT'

   setup_file = FIND_WITH_DEF( 'acs_setup.txt', 'JAUX' )
   stimulus = ' '
   environ = ' '
   IF setup_file NE '' THEN BEGIN
      OPENR, setup_lun, setup_file, /GET_LUN
      st = ' '
      READF, setup_lun, st & stimulus=GETTOK(st, ' ')
      READF, setup_lun, st & environ=GETTOK(st, ' ')
      
      stimulus_i = WHERE( stimulus EQ astrStimulus, st_count )
      environ_i = WHERE( environ EQ astrEnvironments, environ_count )

      IF st_count GT 0 THEN $
       WIDGET_CONTROL, wStimulusDropList, SET_DROPLIST_SELECT=stimulus_i[0]

      IF environ_count GT 0 THEN $
       WIDGET_CONTROL, wEnvironmentDropList, SET_DROPLIST_SELECT=environ_i[0]

      strComment = STRTRIM(stimulus, 2)+' test'
      WIDGET_CONTROL, wCommentField, SET_VALUE=strComment
   ENDIF

   sState = { wRoot: wRoot, $
              wBase: wBase, $
              wTopLabel: wTopLabel, $
              wIndirField: wIndirField, $
              wOutdirField: wOutdirField, $
              wCommentField: wCommentField, $
              wStimulusDropList: wStimulusDropList, $
              wEnvironmentDropList: wEnvironmentDropList, $
              wAutoTimeWindowField: wAutoTimeWindowField, $
              wButtons: wButtons, $
              wAcquireButton: wAcquireButton, $
              wInfoButton: wInfoButton, $
              wExitButton: wExitButton, $
              wAutoButton: wAutoButton, $
              wCheckButton: wCheckButton, $
              wMessageText: wMessageText, $
              aButtonNames: astrButtonNames, $
              aStimuli: astrStimulus, $
              aEnvironments: astrEnvironments, $
              auto_acquire: 0b, $
              last_file: '' }

   WIDGET_CONTROL, wBase, SET_UVALUE=sState

   XMANAGER, 'acs_acq', wRoot, /NO_BLOCK

   return
END

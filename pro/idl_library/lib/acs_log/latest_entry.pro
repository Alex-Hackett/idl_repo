;+
; $Id: latest_entry.pro,v 1.2 1999/07/23 17:22:43 mccannwj Exp $
;
; NAME:
;     LATEST_ENTRY
;
; PURPOSE:
;     Return the latest database entry number.  Wraps around DB_INFO.
;
; CATEGORY:
;     JHU/ACS
;
; CALLING SEQUENCE:
;     result = LATEST_ENTRY( [/WAIT, DB_NAME=] )
; 
; INPUTS:
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     DB_NAME - (STRING) use an alternate database name.  Defaults to ACS_LOG.
;     WAIT    - (BOOLEAN) wait for the next database entry.
;
; OUTPUTS:
;     result - (LONG) the latest (last) database entry number.
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
;    Mon May 10 11:53:32 1999, William Jon McCann
;    <mccannwj@acs13.+hst.nasa.gov>
;
;		written.
;
;-

PRO latest_entry_event, sEvent
                    ; get state information from first child of root
                    ; don't use NO_COPY since we might be CNTRL-C'ed
   wStateHandler = WIDGET_INFO( sEvent.handler, /CHILD )
   WIDGET_CONTROL, wStateHandler, GET_UVALUE=sState

   WIDGET_CONTROL, sEvent.id, GET_UVALUE=uvalue
   CASE STRUPCASE(uvalue) OF
      'STOP_BUTTON': BEGIN
         WIDGET_CONTROL, sState.wRoot, /DESTROY
      END
      'TIMER_EVENT': BEGIN
         DBOPEN, sState.db_name
         last_entry = DB_INFO( 'entries', 0 )
         IF last_entry NE sState.init_entry THEN BEGIN
            WIDGET_CONTROL, sState.wRoot, /CLEAR_EVENTS
            WIDGET_CONTROL, sState.wRoot, /DESTROY
         ENDIF ELSE BEGIN
            aSpinners = [ '-', '\', '|', '/' ]
            sState.spinner_index = (sState.spinner_index + 1) MOD $
             N_ELEMENTS( aSpinners )
            spin_value = aSpinners[sState.spinner_index]
            WIDGET_CONTROL, sState.wSpinLabel, SET_VALUE=spin_value
            WIDGET_CONTROL, sState.wTimer, TIMER=1.0
         ENDELSE
      END
      ELSE:
   ENDCASE

   IF WIDGET_INFO( wStateHandler, /VALID_ID ) EQ 1 THEN $
      WIDGET_CONTROL, wStateHandler, SET_UVALUE=sState

END
; _____________________________________________________________________________

FUNCTION latest_entry, DB_NAME = db_name, WAIT = wait_for_next, $
                       XPOS = x_screen_pos, YPOS = y_screen_pos

   IF N_ELEMENTS( db_name ) LE 0 THEN db_name = 'ACS_LOG'

loop_point:

   DBOPEN, db_name
   last_entry = DB_INFO( 'entries', 0 )

   IF KEYWORD_SET( wait_for_next ) THEN BEGIN

      IF (!D.FLAGS AND 65536) NE 0 THEN BEGIN
         
         wRoot = WIDGET_BASE( /COLUMN, TITLE="latest_entry", $
                              TLB_FRAME_ATTR=4 )
         wBase = WIDGET_BASE( wRoot, /COLUMN )
         wLabel1Base = WIDGET_BASE( wBase, /ROW )
         strValue = "Latest entry is " + STRTRIM( last_entry, 2 )
         wLabel1 = WIDGET_LABEL( wLabel1Base, VALUE=strValue )
         wLabel2Base = WIDGET_BASE( wBase, /ROW )
         wLabel2 = WIDGET_LABEL( wLabel2Base, VALUE="Waiting for new entry ", $
                                 UVALUE="TIMER_EVENT" )
         wSpinLabel = WIDGET_LABEL( wLabel2Base, VALUE='-' )
         wButton = WIDGET_BUTTON( wBase, VALUE="Stop", UVALUE="STOP_BUTTON" )
         WIDGET_CONTROL, wRoot, /REALIZE
         IF N_ELEMENTS( x_screen_pos ) LE 0 THEN x_screen_pos = 0
         IF N_ELEMENTS( y_screen_pos ) LE 0 THEN y_screen_pos = 0
         WIDGET_CONTROL, wRoot, TLB_SET_XOFF=x_screen_pos, $
          TLB_SET_YOFF=y_screen_pos
         WIDGET_CONTROL, wLabel2, TIMER = 1.0
         sState = { wRoot: wRoot, $
                    wLabel1: wLabel1, $
                    wLabel2: wLabel2, $
                    wSpinLabel: wSpinLabel, $
                    wTimer: wLabel2, $
                    db_name: db_name, $
                    spinner_index: 0, $
                    init_entry: last_entry }
         WIDGET_CONTROL, wBase, SET_UVALUE=sState
         XMANAGER, 'latest_entry', wRoot
         DBOPEN, db_name
         last_entry = DB_INFO( 'entries', 0 )
      ENDIF ELSE BEGIN
         IF N_ELEMENTS( init_entry ) LE 0 THEN init_entry = last_entry
         
         IF last_entry EQ init_entry THEN BEGIN
            WAIT, 1
            GOTO, loop_point
         ENDIF
      ENDELSE

   ENDIF

   IF N_ELEMENTS( last_entry ) LE 0 THEN BEGIN
      MESSAGE, 'unknown error', /CONT
      return, -1L
   ENDIF 

   return, last_entry
END 

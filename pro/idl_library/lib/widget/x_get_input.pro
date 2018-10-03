;+
; $Id: x_get_input.pro,v 1.1 2001/11/05 22:12:16 mccannwj Exp $
;
; NAME:
;     X_GET_INPUT
;
; PURPOSE:
;     Create a blocking widget to get input from the user.
;
; CATEGORY:
;     ACS/Widget
;
; CALLING SEQUENCE:
;     input = X_GET_INPUT( [parent, LABEL=label, TITLE=title, $
;                          /LONG, /INTEGER, /FLOATING, /STRING, $
;                          STATUS=exit_status, VALUE=value, $
;                          GROUP_LEADER=group ] )
; 
; INPUTS:
;
; OPTIONAL INPUTS:
;     parent - (WIDGET) widget identifier to use as parent
;      
; KEYWORD PARAMETERS:
;     LABEL  - (STRING) text to display left of the entry box
;     TITLE  - (STRING) text to display on window title bar
;     STATUS - (OUTPUT) specify a named variable to get the exit status.
;               A non-zero exit status indicates an error.
;     VALUE  - Specify the initial value of the input widget.  This
;               value is automatically converted to the appropriate type.
;     FLOAT  - (BOOLEAN) set this keyword to accept only floating point values
;     INTEGER- (BOOLEAN) set this keyword to accept only integer values
;     LONG   - (BOOLEAN) set this keyword to accept only long integer values
;     STRING - (BOOLEAN) set this keyword to accept only string values
;               
; OUTPUTS:
;     input - value entered by the user converted to the appropriate type
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
;       Thu Jun 15 21:17:44 2000, William Jon McCann
;       <mccannwj@acs13.+ball.com>
;-

PRO x_get_input_event, sEvent
   COMPILE_OPT IDL2, HIDDEN

   wStateHandler = WIDGET_INFO( sEvent.handler, /CHILD )
   WIDGET_CONTROL, wStateHandler, GET_UVALUE=sState, /NO_COPY 

   WIDGET_CONTROL, sEvent.id, GET_UVALUE=event_uval

   CASE STRUPCASE( event_uval ) OF

      'FIELD': BEGIN
         WIDGET_CONTROL, sState.wField, GET_VALUE=value
         status = 0b

         WIDGET_CONTROL, /DESTROY, sEvent.top
      END 

      'BUTTON_PRESS': BEGIN
         CASE STRUPCASE( sEvent.value ) OF

            'OK_BUTTON': BEGIN
               WIDGET_CONTROL, sState.wField, GET_VALUE=value
               status = 0b
               WIDGET_CONTROL, /DESTROY, sEvent.top
            END 

            'CANCEL_BUTTON': BEGIN
               value = ''
               status = 1b
               WIDGET_CONTROL, /DESTROY, sEvent.top
            END 

            'PLUS_BUTTON': BEGIN
               IF sState.is_number EQ 1 THEN BEGIN
                  WIDGET_CONTROL, sState.wField, GET_VALUE=value
                  
                  status = 0b
                  value = value + 1
                  
                  WIDGET_CONTROL, sState.wField, SET_VALUE=value
               ENDIF
            END 

            'MINUS_BUTTON': BEGIN
               IF sState.is_number EQ 1 THEN BEGIN
                  WIDGET_CONTROL, sState.wField, GET_VALUE=value
                  
                  status = 0b
                  value = value - 1
                  
                  WIDGET_CONTROL, sState.wField, SET_VALUE=value
               ENDIF
            END
            
            'HALF_BUTTON': BEGIN
               IF sState.is_number EQ 1 THEN BEGIN
                  WIDGET_CONTROL, sState.wField, GET_VALUE=value
                  
                  status = 0b
                  value = value / 2d

                  IF sState.is_float NE 1 THEN value=LONG( value )

                  WIDGET_CONTROL, sState.wField, SET_VALUE=value
               ENDIF
            END 

            'DOUBLE_BUTTON': BEGIN
               IF sState.is_number EQ 1 THEN BEGIN
                  WIDGET_CONTROL, sState.wField, GET_VALUE=value
                  
                  status = 0b
                  value = value * 2d

                  IF sState.is_float NE 1 THEN value=LONG( value )

                  WIDGET_CONTROL, sState.wField, SET_VALUE=value
               ENDIF
            END

            'RESET_BUTTON': BEGIN
               value = sState.original_value
               WIDGET_CONTROL, sState.wField, SET_VALUE=value               
            END

            ELSE: BEGIN
               value = ''
               status = 1b
               WIDGET_CONTROL, /DESTROY, sEvent.top
            END 
         END
      END

      ELSE: BEGIN
         value = ''
         status = 1b
         WIDGET_CONTROL, /DESTROY, sEvent.top
      END

   ENDCASE 

   IF N_ELEMENTS( status ) LE 0 THEN status = 0b
   sReturn = { value: value, status: status }

   IF WIDGET_INFO( sState.wInfo, /VALID_ID ) EQ 1 THEN $
    WIDGET_CONTROL, sState.wInfo, SET_UVALUE=sReturn
   
   IF WIDGET_INFO( wStateHandler, /VALID_ID ) EQ 1 THEN BEGIN
      ;;WIDGET_CONTROL, sState.wRoot, /CLEAR_EVENTS
                    ; restore state information
      WIDGET_CONTROL, wStateHandler, SET_UVALUE=sState, /NO_COPY
   ENDIF 

END

; _____________________________________________________________________________


FUNCTION x_get_input, parent, TITLE=title, LABEL=label, FLOATING=float, $
                      LONG=long, INTEGER=integer, STRING=string, $
                      STATUS=exit_status, VALUE=value, $
                      GROUP_LEADER=group, DEBUG=debug
   COMPILE_OPT IDL2, HIDDEN

   instance_number = XREGISTERED( 'x_get_input' )
   IF KEYWORD_SET(debug) THEN HELP, instance_number
   IF instance_number GT 0 THEN BEGIN
      exit_status = 1b
      return, -1
   ENDIF

   IF N_ELEMENTS( title ) LE 0 THEN title = 'X_GET_INPUT'
   IF N_ELEMENTS( label ) LE 0 THEN label = 'Value:'

   IF KEYWORD_SET(debug) THEN HELP, parent

   modal_flag = N_ELEMENTS(group) GE 1
   IF N_ELEMENTS( parent ) GT 0 THEN BEGIN
      wRoot = WIDGET_BASE( parent, /COLUMN, MODAL=modal_flag, $
                           TITLE=title, GROUP=group )
      parent_id = parent
   ENDIF ELSE BEGIN
      wRoot = WIDGET_BASE( /COLUMN, MODAL=modal_flag, $
                           TITLE=title, GROUP=group )
      parent_id = -1L
   ENDELSE

   wBase = WIDGET_BASE( wRoot, /COLUMN )

   wReturnInfo = WIDGET_BASE( UVALUE='JUNK' )

   wField = CW_FIELD( wBase, FLOAT=float, LONG=long, INTEGER=integer, $
                      STRING=string, /FRAME, UVALUE='FIELD', $
                      /RETURN_EVENTS, TITLE=label, VALUE=value )
   aButtons = ['OK','Cancel', '-', '+', '/2', 'x2', 'Reset' ]
   aButtonUvals = ['OK_BUTTON', 'CANCEL_BUTTON', $
                   'MINUS_BUTTON', 'PLUS_BUTTON', $
                   'HALF_BUTTON', 'DOUBLE_BUTTON', 'RESET_BUTTON' ]
   wButtons = CW_BGROUP( wBase, aButtons, $
                         BUTTON_UVALUE=aButtonUvals, $
                         /ROW, /NO_RELEASE, UVALUE='BUTTON_PRESS' )

   WIDGET_CONTROL, /REALIZE, wRoot

   WIDGET_CONTROL, /HOURGLASS

   IF NOT KEYWORD_SET( string ) THEN is_number = 1b ELSE is_number = 0b
   IF KEYWORD_SET( float ) THEN is_float = 1b ELSE is_float = 0b

   sState = { wRoot: wRoot, $
              wBase: wBase, $
              wInfo: wReturnInfo, $
              wField: wField, $
              wButtons: wButtons, $
              wParent: parent_id, $
              is_number: is_number, $
              is_float: is_float, $
              original_value: value }

   WIDGET_CONTROL, wBase, SET_UVALUE=sState, /NO_COPY
   
   XMANAGER, 'x_get_input', wRoot

   WIDGET_CONTROL, wReturnInfo, GET_UVALUE=sReturn
   WIDGET_CONTROL, /DESTROY, wReturnInfo

   IF N_TAGS( sReturn ) GT 1 THEN BEGIN
      value = sReturn.value 
      exit_status = sReturn.status
   ENDIF ELSE BEGIN
      value = ''
      exit_status = 0b
   ENDELSE 

   return, value
END 

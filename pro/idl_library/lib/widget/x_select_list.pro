;+
; $Id: x_select_list.pro,v 1.1 2001/11/05 22:12:16 mccannwj Exp $
;
; NAME:
;     X_SELECT_LIST
;
; PURPOSE:
;     Create a blocking widget to select an item from a list.
;
; CATEGORY:
;     ACS/Widget
;
; CALLING SEQUENCE:
;     index = X_SELECT_LIST( list [, LABEL=label, TITLE=title, $
;                            STATUS=exit_status, INITIAL=initial, $
;                            GROUP_LEADER=group] )
; INPUTS:
;     list - (VECTOR) list of items to select from
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     LABEL  - (STRING) text to display left of the entry box
;     TITLE  - (STRING) text to display on window title bar
;     STATUS - (OUTPUT) specify a named variable to get the exit status.
;               A non-zero exit status indicates an error.
;     INITIAL- (INTEGER) specify the initial selected index 
;
; OUTPUTS:
;     index  - index number of the selected list item
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
;       Thu Jun 15 21:20:29 2000, William Jon McCann
;       <mccannwj@acs13.+ball.com>
;-

PRO x_select_list_event, sEvent
   COMPILE_OPT IDL2, HIDDEN

   wInfo = WIDGET_INFO( sEvent.handler, /CHILD )

   WIDGET_CONTROL, wInfo, GET_UVALUE=sState, /NO_COPY 

   struct_name = TAG_NAMES( sEvent, /STRUCTURE_NAME)

   IF STRUPCASE( struct_name ) EQ 'WIDGET_BASE' THEN BEGIN
      newx = sEvent.x - 10
      newy = sEvent.y - 50
      WIDGET_CONTROL, sState.wList, SCR_XSIZE=newx, SCR_YSIZE=newy

   ENDIF ELSE BEGIN

      WIDGET_CONTROL, sEvent.id, GET_UVALUE=event_uval

      CASE event_uval OF
         'LIST': BEGIN
            ;;HELP, /STR, sEvent
            IF sEvent.clicks GT 1 THEN BEGIN
               value = WIDGET_INFO( sState.wList, /LIST_SELECT )
               status = 0b
               WIDGET_CONTROL, /DESTROY, sEvent.top               
            ENDIF
         END 

         'BUTTON_PRESS': BEGIN
            CASE STRUPCASE( sEvent.value ) OF

               'OK_BUTTON': BEGIN
                  value = WIDGET_INFO( sState.wList, /LIST_SELECT )
                  status = 0b
                  WIDGET_CONTROL, /DESTROY, sEvent.top
               END 

               'CANCEL_BUTTON': BEGIN
                  value = -1
                  status = 1b
                  WIDGET_CONTROL, /DESTROY, sEvent.top
               END 
               
               'RESET_BUTTON': BEGIN
                  WIDGET_CONTROL, sState.wList, SET_LIST_SELECT=-1
                  value = -1
                  status = 1b                  
               END

               ELSE: BEGIN
                  value = -1
                  status = 1b
                  WIDGET_CONTROL, /DESTROY, sEvent.top
               END
               
            ENDCASE
         END
         
         ELSE: BEGIN
            value = -1
            status = 1b
            WIDGET_CONTROL, /DESTROY, sEvent.top
         END

      ENDCASE 

   ENDELSE

   IF N_ELEMENTS( value ) LE 0 THEN value = 0
   IF N_ELEMENTS( status ) LE 0 THEN status = 0b
   sReturn = { value: value, status: status }
   
   IF WIDGET_INFO( sState.wReturnInfo, /VALID_ID ) EQ 1 THEN $
    WIDGET_CONTROL, sState.wReturnInfo, SET_UVALUE = sReturn

   IF WIDGET_INFO( sEvent.top, /VALID_ID ) EQ 1 THEN BEGIN
                    ; restore state information
      WIDGET_CONTROL, wInfo, SET_UVALUE = sState, /NO_COPY
   ENDIF 


   return
END

; _____________________________________________________________________________

FUNCTION x_select_list, list, TITLE=title, GROUP_LEADER=group, $
                        STATUS=exit_status, LABEL=label, INITIAL=initial
   COMPILE_OPT IDL2

   exit_status = 0b
   IF N_ELEMENTS( list ) LE 0 THEN BEGIN
      exit_status = 1b
      return, -1
   ENDIF
   
   IF N_ELEMENTS( initial ) LE 0 THEN initial = 0 
   IF N_ELEMENTS( title ) LE 0 THEN title = 'Select item(s):'

   modal_flag = N_ELEMENTS(group) GE 1
   wRoot = WIDGET_BASE( /COLUMN, TITLE=title, MODAL=modal_flag, GROUP=group, $
                        /TLB_SIZE_EVENTS, UVALUE='ROOT', $
                        /BASE_ALIGN_CENTER, XPAD=0, YPAD=0 )
   
   wBase = WIDGET_BASE( wRoot, /COLUMN )

   IF N_ELEMENTS( label ) GT 0 THEN BEGIN
      wLabel = WIDGET_LABEL( wBase, VALUE=label, FONT='fixed', $
                             /ALIGN_LEFT )
   ENDIF

   wReturnInfo = WIDGET_BASE( UVALUE='JUNK' )

   ysize = N_ELEMENTS(list) > 1 < 20

   IF N_ELEMENTS( !VERSION.RELEASE ) LE 0 THEN allow_multiple = 0b $
   ELSE BEGIN
      major_version = FLOAT( STRMID( !VERSION.RELEASE, 0, 3 ) )
      IF major_version GE 5.1 THEN use_multiple = 1b ELSE use_multiple = 0b
   ENDELSE

   aList = STRING(list)
   IF use_multiple NE 0 THEN BEGIN
      wList = WIDGET_LIST( wBase, VALUE=aList, YSIZE=ysize, FONT='fixed',$
                           UVALUE='LIST', MULTIPLE=use_multiple )
   ENDIF ELSE BEGIN
      wList = WIDGET_LIST( wBase, VALUE=aList, YSIZE=ysize, FONT='fixed',$
                           UVALUE='LIST' )
   ENDELSE
   
   wButtonBase = WIDGET_BASE( wBase, /ROW, /ALIGN_CENTER, XPAD=0, YPAD=0 )
   aButtons = ['OK','Cancel','Reset']
   aButtonUvals = ['OK_BUTTON', 'CANCEL_BUTTON', 'RESET_BUTTON']
   wButtons = CW_BGROUP( wButtonBase, aButtons, XPAD=0, YPAD=0, SPACE=0, $
                         BUTTON_UVALUE = aButtonUvals, $
                         /ROW, /NO_RELEASE, UVALUE='BUTTON_PRESS' )

   WIDGET_CONTROL, /REALIZE, wRoot
   WIDGET_CONTROL, wList, SET_LIST_SELECT=FIX(initial) 
   
   sState = { wRoot: wRoot, $
              wBase: wBase, $
              wList: wList, $
              wButton: wButtons, $
              wReturnInfo: wReturnInfo, $
              allow_multiple: use_multiple }

   WIDGET_CONTROL, wBase, SET_UVALUE=sState, /NO_COPY
   
   XMANAGER, 'x_select_list', wRoot

   WIDGET_CONTROL, wReturnInfo, GET_UVALUE=sReturn
   WIDGET_CONTROL, /DESTROY, wReturnInfo

   IF N_TAGS( sReturn ) GT 1 THEN BEGIN
      value = sReturn.value 
      exit_status = sReturn.status
   ENDIF ELSE BEGIN
      value = -1
      exit_status = 1b
   ENDELSE 

   return, value
END

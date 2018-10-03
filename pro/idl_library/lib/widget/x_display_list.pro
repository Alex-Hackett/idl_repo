;+
; $Id: x_display_list.pro,v 1.1 2001/11/05 22:12:16 mccannwj Exp $
;
; NAME:
;     X_DISPLAY_LIST
;
; PURPOSE:
;     Create a widget to display a list
;
; CATEGORY:
;     ACS/Widgets
;
; CALLING SEQUENCE:
;     X_DISPLAY_LIST, list [, TITLE=title, GROUP=group]
; 
; INPUTS:
;     list - (VECTOR) list of items to select from
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     TITLE    - (STRING) text to display on window title bar
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;     Save to a text file.
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
;       Thu Jun 15 21:19:36 2000, William Jon McCann
;       <mccannwj@acs13.+ball.com>
;-

PRO x_display_list_event, sEvent
   COMPILE_OPT IDL2, HIDDEN

   wChild = WIDGET_INFO( sEvent.handler, /CHILD )
   wInfo = WIDGET_INFO( wChild, /SIBLING )

   WIDGET_CONTROL, wInfo, GET_UVALUE = sState, /NO_COPY 

   struct_name = TAG_NAMES( sEvent, /STRUCTURE_NAME)

   IF STRUPCASE(struct_name) EQ 'WIDGET_KILL_REQUEST' THEN BEGIN
      PTR_FREE, sState.pList
      WIDGET_CONTROL, sEvent.top, /DESTROY
      return
   ENDIF
   IF STRUPCASE(struct_name) EQ 'WIDGET_BASE' THEN BEGIN
      sGeoRoot = WIDGET_INFO( sState.wRoot, /GEOMETRY )
      sGeoList = WIDGET_INFO( sState.wList, /GEOMETRY )
      xoffset = sGeoRoot.scr_xsize - sGeoList.scr_xsize
      yoffset = (sGeoRoot.scr_ysize - sGeoList.scr_ysize) * 2
      xsize = sEvent.x - LONG(xoffset)
      ysize = sEvent.y - LONG(yoffset)
      WIDGET_CONTROL, sState.wList, SCR_XSIZE=xsize, SCR_YSIZE=ysize
   ENDIF ELSE BEGIN

      WIDGET_CONTROL, sEvent.id, GET_UVALUE=event_uval

      CASE event_uval OF

         'DISMISS_BUTTON': BEGIN
            PTR_FREE, sState.pList
            WIDGET_CONTROL, /DESTROY, sEvent.top
         END 

         'MENU': BEGIN
            CASE sEvent.value OF
               'File.Print': BEGIN
                  CD, CURRENT=currdir
                  svname = currdir+'/list_tmp.txt'
                  IF svname NE '' THEN BEGIN
                     junk = FINDFILE( svname, COUNT=fcnt )
                     
                     IF (fcnt LE 0) AND PTR_VALID(sState.pList) THEN BEGIN
                        error = 0
                        OPENW, lun, svname, /GET_LUN, ERROR=error
                        IF error EQ 0 THEN BEGIN
                           FOR i = 0, N_ELEMENTS(*sState.pList)-1 DO BEGIN
                              PRINTF, lun, (*sState.pList)[i]
                           ENDFOR

                           FREE_LUN, lun
                           strPrintCmd = 'lp '+svname
                           SPAWN, strPrintCmd
                           strRemoveCmd = '/usr/bin/rm -f '+svname
                           SPAWN, strRemoveCmd
                        ENDIF ELSE PRINTF, -2, !ERR_STRING
                     ENDIF 
                  ENDIF
               END

               'File.Print selected': BEGIN
                  CD, CURRENT=currdir
                  svname = currdir+'/list_tmp.txt'
                  IF svname NE '' THEN BEGIN
                     junk = FINDFILE( svname, COUNT=fcnt )
                     
                     IF (fcnt LE 0) AND PTR_VALID(sState.pList) THEN BEGIN
                     
                        OPENW, lun, svname, /GET_LUN, ERROR=error
                        IF error EQ 0 THEN BEGIN
                           indices = WIDGET_INFO( sState.wList, /LIST_SELECT )
                           
                           FOR i=0, N_ELEMENTS( indices ) - 1 DO BEGIN
                              index = indices[i]
                              PRINTF, lun, (*sState.pList)[index]
                           ENDFOR
                           
                           FREE_LUN, lun
                           
                           strPrintCmd = 'lp '+svname
                           SPAWN, strPrintCmd
                           strRemoveCmd = '/usr/bin/rm -f '+svname
                           SPAWN, strRemoveCmd
                        ENDIF ELSE PRINTF, -2, !ERR_STRING
                     ENDIF
                  ENDIF
               END

               'File.Save': BEGIN
                  CD, CURRENT=currdir
                  dialog_file = currdir+'/header.txt'
                  svname = DIALOG_PICKFILE( FILE=dialog_file, /WRITE, $
                                            GET_PATH=writepath )
                  IF svname NE '' THEN BEGIN
                     junk = FINDFILE( svname, COUNT=fcnt )
                     
                     IF (fcnt LE 0) AND PTR_VALID(sState.pList) THEN BEGIN
                        OPENW, lun, svname, /GET_LUN, ERROR=error
                        IF error EQ 0 THEN BEGIN
                           FOR i=0, N_ELEMENTS( *sState.pList ) - 1 DO BEGIN
                              PRINTF, lun, (*sState.pList)[i]
                           ENDFOR
                           FREE_LUN, lun
                        ENDIF ELSE PRINTF, -2, !ERR_STRING
                     ENDIF
                  ENDIF
               END 

               'File.Save selected': BEGIN
                  CD, CURRENT=currdir
                  dialog_file = currdir+'/header.txt'
                  svname = DIALOG_PICKFILE( FILE=dialog_file, /WRITE, $
                                            GET_PATH=writepath )
                  IF svname NE '' THEN BEGIN
                     junk = FINDFILE( svname, COUNT=fcnt )
                  
                     IF (fcnt LE 0) AND PTR_VALID(sState.pList) THEN BEGIN
                     
                        OPENW, lun, svname, /GET_LUN, ERROR=error
                        IF error EQ 0 THEN BEGIN
                           indices = WIDGET_INFO( sState.wList, /LIST_SELECT )
                           FOR i=0, N_ELEMENTS( indices ) - 1 DO BEGIN
                              index = indices[i]
                              PRINTF, lun, (*sState.pList)[index]
                           ENDFOR
                           FREE_LUN, lun
                        ENDIF ELSE PRINTF, -2, !ERR_STRING
                     ENDIF
                  ENDIF
               END

               'File.Exit': BEGIN
                  PTR_FREE, sState.pList
                  WIDGET_CONTROL, /DESTROY, sEvent.top
               END
               ELSE:
            ENDCASE
         END
         ELSE: 
      ENDCASE
   ENDELSE 

   IF WIDGET_INFO( sEvent.top, /VALID_ID ) EQ 1 THEN BEGIN
                    ; restore state information
      WIDGET_CONTROL, wInfo, SET_UVALUE=sState, /NO_COPY
   ENDIF 
END

; _____________________________________________________________________________

PRO x_display_list, list, TITLE=title, GROUP=group, FILENAME=filename
   COMPILE_OPT IDL2

   IF N_ELEMENTS( list ) LE 0 THEN return
   IF N_ELEMENTS( filename ) LE 0 THEN filename = 'list.txt'

   wRoot = WIDGET_BASE( /COLUMN, TITLE=title, GROUP=group, $
                        /TLB_KILL_REQUEST_EVENTS, /TLB_SIZE_EVENTS, $
                        UVALUE='ROOT', MBAR=mbar, $
                        XPAD=0, YPAD=0, XOFFSET=0, YOFFSET=0, SPACE=0 )
   
   MenuList = ['1\File','0\Print','0\Print selected', $
               '0\Save','0\Save selected','2\Exit']

   wMenuBar = CW_PDMENU( mbar, /RETURN_FULL_NAME, /MBAR, $
                         MenuList, UVALUE='MENU' )

   wBase = WIDGET_BASE( wRoot, /COLUMN, YPAD=0, $
                        YOFFSET=0, SPACE=0  )

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
   
   wButtonBase = WIDGET_BASE( wBase, /ROW, /ALIGN_CENTER )
   wButton = WIDGET_BUTTON( wButtonBase, /ALIGN_CENTER, /NO_RELEASE, $
                            UVALUE='DISMISS_BUTTON', VALUE='DISMISS' )

   WIDGET_CONTROL, /REALIZE, wRoot

   list_ptr = PTR_NEW( list )

   sState = { wRoot: wRoot, $
              wBase: wBase, $
              wList: wList, $
              wButton: wButton, $
              pList: list_ptr, $
              filename: filename, $
              allow_multiple: use_multiple }

   WIDGET_CONTROL, wBase, SET_UVALUE=sState, /NO_COPY
   
   XMANAGER, 'x_display_list', wRoot, /NO_BLOCK

END

;+
; NAME:
;     ACS_FIND
;
; PURPOSE:
;     Graphical interface for simplifying ACS preflight database
;     searches.
;
; CATEGORY:
;     ACS/Log
;
; CALLING SEQUENCE:
;     ACS_FIND
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
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;	version 1  D. Lindler 1998
;	 6 Feb 1999, D. Lindler, Added more CCDAMP choices, added
;		/FULLSTRING keyword to dbfind.
;	22 Jun 2000, D. Lindler, removed filename search
;       28 Sep 2000, McCann - rewrite.
;-

PRO acs_find_free_pointers, sState

   PTR_FREE, sState.pListEntries, sState.pListItems
   return
END 

PRO acs_find_search, sState

   st = ''          ;search parameters
;
; detector
;
   i = WIDGET_INFO(sState.wDetectorList,/DROPLIST_SELECT)
   v = sState.aDetectors
   if i ne 0 then st = st+',detector='+v[i]
;
; obstype
;
   v = sState.aObstypes
   i = WIDGET_INFO(sState.wObstypeList,/DROPLIST_SELECT)
   if i ne 0 then st = st + ',obstype='+v[i]
;
; stimulus
;	
   v = sState.aStimuli
   i = WIDGET_INFO(sState.wStimulusList,/DROPLIST_SELECT)
   if i ne 0 then st = st + ',stimulus='+v[i]
;
; environ
;
   v = sState.aEnvirons
   i = WIDGET_INFO(sState.wEnvironList,/DROPLIST_SELECT)
   if i ne 0 then st = st + ',environ='+v[i]
;
; ccd amp
;
   v = sState.aCcdAmps
   i = WIDGET_INFO(sState.wCcdampList,/DROPLIST_SELECT)
   if i ne 0 then st = st + ',ccdamp='+v[i]
;
; sclamp
;
   v = sState.aSclamps
   i = WIDGET_INFO(sState.wSclampList,/DROPLIST_SELECT)
   if i ne 0 then st = st + ',sclamp='+v[i]
;
; FILTER1
;
   v = sState.aFilter1
   i = WIDGET_INFO(sState.wFilter1List,/DROPLIST_SELECT)
   if i ne 0 then st = st + ',filter1='+v[i]
;
; Filter2
;
   v = sState.aFilter2
   i = WIDGET_INFO(sState.wFilter2List,/DROPLIST_SELECT)
   if i ne 0 then st = st + ',filter2='+v[i]
;
; filter3
;
   v = sState.aFilter3
   i = WIDGET_INFO(sState.wFilter3List,/DROPLIST_SELECT)
   if i ne 0 then st = st + ',filter3='+v[i]
;
; Time
;
   months = sState.aMonths
   years = ['1900',sState.aYears]
   min_month = months[WIDGET_INFO(sState.wMinMonthList,/DROPLIST_SELECT)]
   max_month = months[WIDGET_INFO(sState.wMaxMonthList,/DROPLIST_SELECT)]
   min_year = years[WIDGET_INFO(sState.wMinYearList,/DROPLIST_SELECT)]
   max_year = years[WIDGET_INFO(sState.wMaxYearList,/DROPLIST_SELECT)+1]

   WIDGET_CONTROL,sState.wMinDayField,GET_VALUE=min_day
   WIDGET_CONTROL,sState.wMaxDayField,GET_VALUE=max_day
   min_day = STRTRIM(min_day(0),2)
   max_day = STRTRIM(max_day(0),2)

   WIDGET_CONTROL,sState.wMinTimeField,GET_VALUE=min_time
   WIDGET_CONTROL,sState.wMaxTimeField,GET_VALUE=max_time
   min_time = min_time(0) & max_time = max_time(0)	
   min_hour = STRING(FIX(GETTOK(min_time,':'))>0<24,format='(i2)')
   min_min = STRING(FIX(GETTOK(min_time,':'))>0<59,format='(i2)')
   min_sec = STRING(FIX(GETTOK(min_time,':'))>0<59,format='(i2)')
   max_hour = STRING(FIX(GETTOK(max_time,':'))>0<24,format='(i2)')
   max_min = STRING(FIX(GETTOK(max_time,':'))>0<59,format='(i2)')
   max_sec = STRING(FIX(GETTOK(max_time,':'))>0<59,format='(i2)')

   date = min_day+'-'+min_month+'-'+min_year+' '+min_hour+':'+min_min+ $
    ':'+min_sec
   min_mjd = jul_date(date)-0.5
   date = max_day+'-'+max_month+'-'+max_year+' '+max_hour+':'+max_min+ $
    ':'+max_sec
   max_mjd = jul_date(date)-0.5
   st = st +','+strtrim(min_mjd,2)+'<expstart<'+strtrim(max_mjd,2)
   
;
; Other Parameters
;
   FOR i=0,N_ELEMENTS(sState.wItemLabels)-1 DO BEGIN
      WIDGET_CONTROL,sState.wItemLabels[i],GET_VALUE=name
      IF name[0] NE 'NONE' THEN BEGIN
         WIDGET_CONTROL, sState.wItemMinFields[i], GET_VALUE=minv
         WIDGET_CONTROL, sState.wItemMaxFields[i], GET_VALUE=maxv
         IF STRTRIM(minv[0],2) EQ STRTRIM(maxv[0],2) THEN $
          st = st+','+name[0] + '='+STRTRIM(minv[0],2) $
         ELSE IF STRTRIM(minv[0]) EQ '' THEN $
          st = st+','+name[0] + '<'+STRTRIM(maxv[0],2) $
         ELSE IF STRTRIM(maxv[0]) EQ '' THEN $
          st = st+','+name(0) + '>' + STRTRIM(minv[0],2) $
         ELSE st = st+','+STRTRIM(minv[0],2)+'<'+name[0] + $
          '<'+STRTRIM(maxv[0],2)
      ENDIF
   ENDFOR

   IF STRMID(st,0,1) EQ ',' THEN st = STRMID(st,1,STRLEN(st)-1)
   PRINT, st
   dbopen, 'acs_log'
   list_entries = dbfind(st,/FULLSTRING)
   strMessage = STRTRIM(N_ELEMENTS(list_entries),2) + ' entries found'
   PTR_FREE, sState.pListEntries
   IF list_entries[0] EQ 0 THEN BEGIN
      strMessage = 'NO entries found'
      sState.pListEntries = PTR_NEW()
   ENDIF ELSE BEGIN
      sState.pListEntries = PTR_NEW(list_entries, /NO_COPY)
   ENDELSE
   WIDGET_CONTROL, sState.wMessageText, SET_VALUE=strMessage
   return
END

; ______________________________________________________________________________

PRO acs_find_print, sState, PRINT=print,LANDSCAPE=landscape,SELECTED=selected

   IF NOT PTR_VALID(sState.pListEntries) THEN return
   list_entries = *sState.pListEntries

   textout = 2
   items = 'entry,filename,obstype,detector,ccdamp,filter1,filter2,' + $
    'filter3,exptime'
   IF KEYWORD_SET(landscape) THEN items = 'entry,date-obs,filename,' + $
    'stimulus,obstype,detector,ccdamp,filter1,filter2,filter3,'+ $
    'exptime,naxis1,naxis2,ccdxcor,ccdycor'
   IF KEYWORD_SET(selected) THEN BEGIN
      IF PTR_VALID(sState.pListItems) THEN items = *sState.pListItems
   ENDIF 
   IF KEYWORD_SET(print) THEN BEGIN
      WIDGET_CONTROL, sState.wOutputFileField, GET_VALUE=filename
      OPENW, unit, filename[0], /GET_LUN, ERROR=open_error
      IF (open_error NE 0) THEN BEGIN
         PRINTF, -2, !ERR_STRING
         error_flag = 1b
         return
      ENDIF

      !TEXTUNIT = unit
      textout=5
   ENDIF
   dbprint, list_entries, items, TEXTOUT=textout
   IF KEYWORD_SET(print) THEN BEGIN
      !TEXTUNIT = 0
      FREE_LUN, unit
      strMessage = 'Text output placed into file '+filename[0]
      WIDGET_CONTROL, sState.wMessageText, SET_VALUE=strMessage
   ENDIF
   return
END

; ______________________________________________________________________________

PRO acs_find_select_item, sState, number

   dbopen, 'acs_log'

   items = ['NONE',STRTRIM(db_item_info('name'))]
   select_w, items, isel, items, 'Select Item', 1, GROUP=sState.wRoot

   WIDGET_CONTROL, sState.wItemLabels[number[0]], SET_VALUE=items[isel[0]]
   WIDGET_CONTROL, sState.wItemMinFields[number[0]], SET_VALUE=' '
   WIDGET_CONTROL, sState.wItemMaxFields[number[0]], SET_VALUE=' '

   return
END 

; ______________________________________________________________________________

PRO acs_find_reset_selections, sState

   WIDGET_CONTROL, sState.wRoot, UPDATE=0

                    ; Reset the parameter pulldowns
   droplists = [sState.wDetectorList,sState.wObstypeList,sState.wStimulusList, $
                sState.wEnvironList, sState.wCcdAmpList, sState.wSclampList, $
                sState.wFilter1List, sState.wFilter2List, sState.wFilter3List,$
                sState.wMinMonthList, sState.wMaxMonthList, $
                sState.wMinYearList ]

   FOR i=0,N_ELEMENTS(droplists)-1 DO $
    WIDGET_CONTROL, droplists[i], SET_DROPLIST_SELECT=0
                    ; special case
   n_years = N_ELEMENTS(sState.aYears)
   WIDGET_CONTROL, sState.wMaxYearList, SET_DROPLIST_SELECT=n_years-1

                    ; Reset the TIME fields
   WIDGET_CONTROL, sState.wMinDayField, SET_VALUE=1
   WIDGET_CONTROL, sState.wMaxDayField, SET_VALUE=1
   WIDGET_CONTROL, sState.wMinTimeField, SET_VALUE='00:00'
   WIDGET_CONTROL, sState.wMaxTimeField, SET_VALUE='00:00'

                    ; Reset the OTHER fields
   FOR i=0,N_ELEMENTS(sState.wItemLabels)-1 DO BEGIN
      WIDGET_CONTROL, sState.wItemLabels[i], SET_VALUE='NONE'
      WIDGET_CONTROL, sState.wItemMinFields[i], SET_VALUE=' '
      WIDGET_CONTROL, sState.wItemMaxFields[i], SET_VALUE=' '      
   ENDFOR

   WIDGET_CONTROL, sState.wMessageText, SET_VALUE='ready.'
   WIDGET_CONTROL, sState.wRoot, UPDATE=1
   return
END

; ______________________________________________________________________________

PRO acs_find_event, sEvent

   wStateHandler = WIDGET_INFO(sEvent.handler, /CHILD)
   WIDGET_CONTROL, wStateHandler, GET_UVALUE=sState, /NO_COPY

   WIDGET_CONTROL, sEvent.id, GET_UVALUE=event_uvalue
   
   IF N_ELEMENTS(event_uvalue) EQ 0 THEN event_uvalue='NONE' 
   CASE event_uvalue OF
      'ROOT_BASE': BEGIN
         IF TAG_NAMES(sEvent, /STRUCTURE_NAME) EQ 'WIDGET_KILL_REQUEST' $
          THEN BEGIN
            acs_find_free_pointers, sState
            WIDGET_CONTROL, sEvent.top, /DESTROY
            return
         ENDIF
      END 
      'EXIT_BUTTON': BEGIN
         acs_find_free_pointers, sState
         WIDGET_CONTROL, sEvent.top, /DESTROY
         return
      END
      'RESET_BUTTON': BEGIN
         acs_find_reset_selections, sState
         acs_find_free_pointers, sState
      END
      'LIST_BUTTON': BEGIN
         CASE sEvent.value OF
            'List.80 Column': acs_find_print, sState
            'List.132 Column': acs_find_print, sState, /LANDSCAPE
            'List.Selected': acs_find_print, sState, /SELECTED
            ELSE:
         ENDCASE
      END
      'PRINT_BUTTON': BEGIN
         CASE sEvent.value OF
            'Print.80 Column': acs_find_print, sState, /PRINT
            'Print.132 Column': acs_find_print, sState, /LANDSCAPE, /PRINT
            'Print.Selected': acs_find_print, sState, /SELECTED, /PRINT
            ELSE:
         ENDCASE
      END
      'SEARCH_BUTTON': acs_find_search, sState
      'SELECT_ITEMS_BUTTON': BEGIN
         dbopen, 'acs_log'
         items = STRUPCASE(STRTRIM(db_item_info('name')))
         iselin = INTARR(1000)
         n = 0

         IF PTR_VALID(sState.pListItems) THEN $
          list_items = *sState.pListItems $
         ELSE list_items = 'entry'
         
         list_items = STRUPCASE(list_items)
         WHILE list_items NE '' DO BEGIN
            iselin(n) = WHERE(items EQ gettok(list_items,','))
            n = n+1
         ENDWHILE
         iselin = iselin[0:n-1]
         select_w,items,isel,'','Select Print Items',0, $
          GROUP=sEvent.top,SELECTIN=iselin
         n = N_ELEMENTS(isel)
         IF n GT 0 THEN BEGIN
            list_items = items[isel[0]]
            FOR i=1,n-1 DO list_items = list_items + ',' + $
             items[isel[i]]
         ENDIF ELSE list_items = 'entry'
         PTR_FREE, sState.pListItems
         sState.pListItems = PTR_NEW(list_items,/NO_COPY)
      END
      'ITEM1_BUTTON': BEGIN
         acs_find_select_item, sState, 0
      END
      'ITEM2_BUTTON': BEGIN
         acs_find_select_item, sState, 1
      END
      'ITEM3_BUTTON': BEGIN
         acs_find_select_item, sState, 2
      END

      ELSE:
   ENDCASE

   WIDGET_CONTROL, sState.wBase, SET_UVALUE=sState, /NO_COPY

   return
END

; ______________________________________________________________________________

PRO acs_find, list

   strTitle = 'ACS database search'

   aDetectors = ['ANY','HRC','WFC','SBC']
   aObstypes = ['ANY','DARK','BIAS','INTERNAL','EXTERNAL','CORON','TARG_ACQ']
   aStimuli = ['ANY','RASCAL','RAS/HOMS','MONOHOMS','INT_SPHR','SPECIAL','STUFF']
   aEnvirons = ['ANY','AMBIENT','VACUUM','PURGE']
   aCcdAmps = ['ANY','A','B','C','D','AB','AC','AD','BC','BD','CD','ABCD']
   aSclamps = ['ANY','NONE','DEUTERIUM',$
               'TUNGSTEN-1','TUNGSTEN-2','TUNGSTEN-3','TUNGSTEN-4']
   aFilter1 = ['ANY','CLEAR1L','F555W','F775W','F625W','F550M','F850LP', $
               'CLEAR1S','POL0UV','POL60UV','POL120UV','F892N','F606W', $
               'F502N','G800L','F658N','F475W']
   aFilter2 = ['ANY','CLEAR2L','F660N','F814W','FR388N','F435W','FR656N', $
               'CLEAR2S','POL0V','F330W','POL60V','F250W','POL120V','PR200L', $
               'F344N','F220W','FR914M','FR459M','FR505N']
   aFilter3 = ['ANY','BLOCK1','F115LP','F125LP','BLOCK2','F140LP','F150LP', $
               'BLOCK3','F165LP','F122M','BLOCK4','PR130L','PR110L']

   aMonths = ['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP', $
              'OCT','NOV','DEC']
   aYears = STRTRIM(INDGEN(5)+1998,2)

                    ; define widget
   wRoot = WIDGET_BASE(/COLUMN, TITLE=strTitle, UVALUE='ROOT_BASE', $
                       /TLB_KILL_REQUEST_EVENTS)
   wBase = WIDGET_BASE(wRoot, /COLUMN)

                    ; button bar
   wButtonBarBase = WIDGET_BASE(wBase, /ROW, /FRAME)
   wExitButton = WIDGET_BUTTON(wButtonBarBase,$
                               UVALUE='EXIT_BUTTON',VALUE='Exit')
   wSearchButton = WIDGET_BUTTON(wButtonBarBase,$
                                 UVALUE='SEARCH_BUTTON',VALUE='Search')
   wItemsButton = WIDGET_BUTTON(wButtonBarBase,VALUE='Select Print Items',$
                                UVALUE='SELECT_ITEMS_BUTTON')
   aListDesc = ['1\List','0\80 Column','0\132 Column','2\Selected']
   wListButton = CW_PDMENU(wButtonBarBase,aListDesc,UVALUE='LIST_BUTTON',$
                           /RETURN_FULL_NAME)
   aPrintDesc = ['1\Print','0\80 Column','0\132 Column','2\Selected']
   wPrintButton = CW_PDMENU(wButtonBarBase,aPrintDesc,UVALUE='PRINT_BUTTON',$
                            /RETURN_FULL_NAME)	
   wOutputFileField = CW_FIELD(wButtonBarBase,/ROW, $
                               VALUE='acs_log.prt',TITLE='Output Text File: ',$
                               XSIZE=20)
   wResetButton = WIDGET_BUTTON(wButtonBarBase,$
                               UVALUE='RESET_BUTTON',VALUE='Reset')

                    ; drop list search parameters
   wCommonParamBase = WIDGET_BASE(wBase,/ROW,YPAD=20)
   wCommonParamCol1Base = WIDGET_BASE(wCommonParamBase,/COLUMN)
   wCommonParamCol2Base = WIDGET_BASE(wCommonParamBase,/COLUMN,XPAD=10)
   wCommonParamCol3Base = WIDGET_BASE(wCommonParamBase,/COLUMN,XPAD=10)

   wDetectorList = WIDGET_DROPLIST(wCommonParamCol1Base,$
                                   VALUE=aDetectors,TITLE='DETECTOR  ')
   wObstypeList = WIDGET_DROPLIST(wCommonParamCol1Base,$
                                  VALUE=aObstypes,TITLE='OBSTYPE  ')
   wStimulusList = WIDGET_DROPLIST(wCommonParamCol1Base,$
                                   VALUE=aStimuli,TITLE='STIMULUS ')


   wEnvironList = WIDGET_DROPLIST(wCommonParamCol2Base,$
                                  VALUE=aEnvirons,title='ENVIRON  ')
   wCcdampList = WIDGET_DROPLIST(wCommonParamCol2Base,$
                                 VALUE=aCcdAmps,TITLE='CCDAMP   ')
   wSclampList = WIDGET_DROPLIST(wCommonParamCol2Base,$
                                 VALUE=aSclamps,TITLE='SCLAMP   ')


   wFilter1List = WIDGET_DROPLIST(wCommonParamCol3Base,$
                                  VALUE=aFilter1,title='FILTER1   ')
   wFilter2List = WIDGET_DROPLIST(wCommonParamCol3Base,$
                                  VALUE=aFilter2,title='FILTER2   ')
   wFilter3List = WIDGET_DROPLIST(wCommonParamCol3Base,$
                                  VALUE=aFilter3,title='FILTER3   ')


                    ; time search parameters
   wTimeParamBase = WIDGET_BASE(wBase,/ROW,/FRAME,YPAD=5)

   wMinMonthList = WIDGET_DROPLIST(wTimeParamBase,$
                                   VALUE=aMonths, TITLE='EXPSTART: ')
   wMinDayField = CW_FIELD(wTimeParamBase, /ROW, $
                           VALUE='1', TITLE=' ', XSIZE=2)
   wMinYearList = WIDGET_DROPLIST(wTimeParamBase, $
                                  VALUE=['1900',aYears], TITLE=',')
   wMinTimeField = CW_FIELD(wTimeParamBase, /ROW, $
                            VALUE='00:00', TITLE=' ', XSIZE=6)
   wMaxMonthList = WIDGET_DROPLIST(wTimeParamBase, $
                                   VALUE=aMonths, TITLE='  To  ')
   wMaxDayField = CW_FIELD(wTimeParamBase, /ROW,$
                           VALUE='1', TITLE=' ', XSIZE=2)
   wMaxYearList = WIDGET_DROPLIST(wTimeParamBase, $
                                  VALUE=aYears, TITLE=',')
   WIDGET_CONTROL, wMaxYearList, SET_DROPLIST_SELECT=N_ELEMENTS(aYears)-1
   wMaxTimeField = CW_FIELD(wTimeParamBase, /ROW,$
                            VALUE='00:00', TITLE=' ', XSIZE=5)

                    ; Other searchs
   wOtherParamBase = WIDGET_BASE(wBase,/COL,/FRAME)
   wOtherParamLabel = WIDGET_LABEL(wOtherParamBase,$
                                   VALUE='Other Search Parameters')
   wOtherParamRow1Base = WIDGET_BASE(wOtherParamBase,/ROW)
   wOtherParamRow2Base = WIDGET_BASE(wOtherParamBase,/ROW)
   wOtherParamRow3Base = WIDGET_BASE(wOtherParamBase,/ROW)

   wItem1Button = WIDGET_BUTTON(wOtherParamRow1Base,UVALUE='ITEM1_BUTTON',$
                                VALUE='Select Item')
   wItem1Label = WIDGET_LABEL(wOtherParamRow1Base,VALUE='NONE',XSIZE=150)
   wItem1MinField = CW_FIELD(wOtherParamRow1Base,/ROW,VALUE=' ',$
                             TITLE='Min:',xsize=12)
   wItem1MaxField = CW_FIELD(wOtherParamRow1Base,/ROW,VALUE=' ',$
                             TITLE='    Max:',xsize=12)

   wItem2Button = WIDGET_BUTTON(wOtherParamRow2Base,UVALUE='ITEM2_BUTTON',$
                                VALUE='Select Item')
   wItem2Label = widget_label(wOtherParamRow2Base,VALUE='NONE',xsize=150)
   wItem2MinField = CW_FIELD(wOtherParamRow2Base,/ROW,VALUE=' ',$
                             TITLE='Min:',xsize=12)
   wItem2MaxField = CW_FIELD(wOtherParamRow2Base,/ROW,VALUE=' ',$
                             TITLE='    Max:',xsize=12)

   wItem3Button = WIDGET_BUTTON(wOtherParamRow3Base,UVALUE='ITEM3_BUTTON',$
                                VALUE='Select Item')
   wItem3Label = WIDGET_LABEL(wOtherParamRow3Base,VALUE='NONE',xsize=150)
   wItem3MinField = CW_FIELD(wOtherParamRow3Base,/ROW,VALUE=' ',$
                             TITLE='Min:',xsize=12)
   wItem3MaxField = CW_FIELD(wOtherParamRow3Base,/ROW,VALUE=' ',$
                             TITLE='    Max:',xsize=12)
   
   wMessageText = WIDGET_TEXT(wBase,VALUE=' ')

   wItemLabels = [wItem1Label,wItem2Label,wItem3Label]
   wItemMinFields = [wItem1MinField,wItem2MinField,wItem3MinField]
   wItemMaxFields = [wItem1MaxField,wItem2MaxField,wItem3MaxField]

   pListItems = PTR_NEW('entry')
   pListEntries = PTR_NEW()
   
   sState = { wRoot: wRoot, $
              wBase: wBase, $
              wOutputFileField: wOutputFileField, $
              wDetectorList: wDetectorList, $
              wObstypeList: wObstypeList, $
              wStimulusList: wStimulusList, $
              wEnvironList: wEnvironList, $
              wCcdampList: wCcdampList, $
              wSclampList: wSclampList, $
              wFilter1List: wFilter1List, $
              wFilter2List: wFilter2List, $
              wFilter3List: wFilter3List, $
              wMinMonthList: wMinMonthList, $
              wMinDayField: wMinDayField, $
              wMinYearList: wMinYearList, $
              wMinTimeField: wMinTimeField, $
              wMaxMonthList: wMaxMonthList, $
              wMaxDayField: wMaxDayField, $
              wMaxYearList: wMaxYearList, $
              wMaxTimeField: wMaxTimeField, $
              wItemLabels: wItemLabels, $
              wItemMinFields: wItemMinFields, $
              wItemMaxFields: wItemMaxFields, $
              aDetectors: aDetectors, $
              aObstypes: aObstypes, $
              aStimuli: aStimuli, $
              aEnvirons: aEnvirons, $
              aCcdAmps: aCcdAmps, $
              aSclamps: aSclamps, $
              aFilter1: aFilter1, $
              aFilter2: aFilter2, $
              aFilter3: aFilter3, $
              aMonths: aMonths, $
              aYears: aYears, $
              pListItems: pListItems, $
              pListEntries: pListEntries, $
              wMessageText: wMessageText }

                    ; create the widget
   WIDGET_CONTROL, wRoot, /REALIZE
   WIDGET_CONTROL, wBase, SET_UVALUE=sState
   XMANAGER, 'acs_find', wRoot, /NO_BLOCK
   return
END

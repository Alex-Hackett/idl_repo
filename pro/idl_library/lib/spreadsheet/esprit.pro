;+
; $Id: esprit.pro,v 1.1 1999/08/17 23:52:27 mccannwj Exp $
;
; NAME:
;     ESPRIT
;
; PURPOSE:
;     Spreadsheet for X
;
; CATEGORY:
;     Spreadsheet
;
; CALLING SEQUENCE:
;     ESPRIT [, aSheet, aFormat ]
; 
; INPUTS:
;
; OPTIONAL INPUTS:
;     aSheet  - (2D ARRAY) array of spreadsheet value cells
;     aFormat - (2D ARRAY) array of spreadsheet format cells
;      
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;     Save spreadsheet to SYLK format file.
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;     SYLK, Lotus(tm) 123, and BIFF5 file formats are supported.
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;       Thu Jan 14 21:27:19 1999, William Jon McCann <mccannwj@acs10>
;
;		created.
;
;-
; _____________________________________________________________________________

PRO esprit_free_pointers, sState
   PTR_FREE, sState.ptrCopyBuffer, sState.ptrUndoBuffer, $
    sState.ptrFormatBuffer, sState.ptrFormulaUndoBuffer, $
    sState.ptrFormulaBuffer
   return
END 

; _____________________________________________________________________________

PRO esprit_clean_exit, sState
   esprit_free_pointers, sState
   return
END 

; _____________________________________________________________________________

FUNCTION write_ascii_sheet, filename, sheet, FORMAT = format

   IF N_ELEMENTS( sheet ) LE 2 THEN BEGIN
      MESSAGE, 'no data', /CONT
      return, 0b
   ENDIF

   OPENW, lun, filename, /GET_LUN, ERROR = open_error

   IF open_error NE 0 THEN BEGIN
      MESSAGE, 'error opening file: ' + filename, /CONT
      return, 0b
   ENDIF

   sheet_sz = SIZE( sheet )

   IF N_ELEMENTS( format ) LE 0 THEN $
    format = REPLICATE( 'A', sheet_sz[1], sheet_sz[2] )

   strTab = STRING(9b)
   FOR j = 0, sheet_sz[2] - 1L DO BEGIN

      FOR i = 0, sheet_sz[1] - 1L DO BEGIN

         strFormat = '(' + format[i,j] + ',A,$)'
         PRINTF, lun, sheet[i,j], strTab, FORMAT = strFormat

      ENDFOR

      PRINTF, lun, ''
   ENDFOR

   FREE_LUN, lun

   return, 1b
END

; _____________________________________________________________________________

FUNCTION write_html_sheet, filename, sheet, FORMAT = format

   IF N_ELEMENTS( sheet ) LE 2 THEN BEGIN
      MESSAGE, 'no data', /CONT
      return, 0b
   ENDIF

   OPENW, lun, filename, /GET_LUN, ERROR = open_error

   IF open_error NE 0 THEN BEGIN
      MESSAGE, 'error opening file: ' + filename, /CONT
      return, 0b
   ENDIF

   sheet_sz = SIZE( sheet )

   IF N_ELEMENTS( format ) LE 0 THEN $
    format = REPLICATE( 'A', sheet_sz[1], sheet_sz[2] )

   PRINTF, lun, "<HTML>"
   PRINTF, lun, "   <HEAD>"
   PRINTF, lun, "      <TITLE>IDL Spreadsheet</TITLE>"
   PRINTF, lun, "   </HEAD>"
   PRINTF, lun, "<BODY>"
   
   PRINTF, lun, "<TABLE border = '1'>"
   PRINTF, lun, "<COLGROUP span = '" + STRTRIM( sheet_sz[1], 2 ) + $
    "' width = '100%'>"
   PRINTF, lun, "<THEAD valign = 'top'>
   PRINTF, lun, "   <TR>

   FOR i = 0, sheet_sz[1] - 1L DO BEGIN
      
      strFormat = '(6X,"<TH>",' + format[i,0] + ',"</TH>")'
      PRINTF, lun, sheet[i,0], FORMAT = strFormat

   ENDFOR
   
   PRINTF, lun, "   </TR>"
   PRINTF, lun, "</THEAD>"
   PRINTF, lun, "<TBODY>"

   FOR j = 1, sheet_sz[2] - 1L DO BEGIN

      PRINTF, lun, "   <TR>"
      FOR i = 0, sheet_sz[1] - 1L DO BEGIN

         strFormat = '(6X,"<TD>",' + format[i,j] + ',"</TD>")'
         PRINTF, lun, sheet[i,j], FORMAT = strFormat

      ENDFOR
      PRINTF, lun, '   </TR>'
   ENDFOR
   
   PRINTF, lun, "</TABLE><BR>"

   PRINTF, lun, "Created " + STRTRIM( SYSTIME(), 2 ) + " by IDL"

   PRINTF, lun, '</BODY>'
   PRINTF, lun, '</HTML>'

   FREE_LUN, lun

   return, 1b
END 

; _____________________________________________________________________________

PRO wmessage, sState, strMessage

   IF N_ELEMENTS( strMessage ) GT 0 THEN $
    WIDGET_CONTROL, sState.wMessageText, SET_VALUE = strMessage

   return
END

; _____________________________________________________________________________


FUNCTION make_column_labels_ascii, number

                    ; NOTE: ASCII A-Z == BYTE 90-65

   IF N_ELEMENTS( number ) LE 0 THEN number = 256

   index = LINDGEN( number )
   
   index_sz = N_ELEMENTS( index )
   
   labels = $
    STRING( REFORM( BYTE( 65b + index / 26 ), 1, index_sz ) ) + $
    STRING( REFORM( BYTE( 65b + index MOD 26 ), 1, index_sz ) )
   
   return, labels
END

; _____________________________________________________________________________


FUNCTION make_column_labels, number

   IF N_ELEMENTS( number ) LE 0 THEN number = 16

   index = LINDGEN( number )
   
   labels = STRTRIM( index, 2 )

   return, labels
END

; _____________________________________________________________________________


FUNCTION make_row_labels, number

   IF N_ELEMENTS( number ) LE 0 THEN number = 256

   index = LINDGEN( number )
   
   labels = STRTRIM( index, 2 )

   return, labels
END
; _____________________________________________________________________________


FUNCTION get_row_heights, sheet

   sheet_sz = SIZE( sheet )

   heightChar = (!D.Y_CH_SIZE + 10) > 12
   
   row_heights = REPLICATE( heightChar, sheet_sz[2] )

   return, row_heights
END

; _____________________________________________________________________________


FUNCTION get_column_widths, sheet, USE_MAX = use_max, USE_MEDIAN = use_median

   IF KEYWORD_SET( use_median ) THEN use_median = 1b ELSE use_median = 0b

   sheet_sz = SIZE( sheet )

   numChars = MAKE_ARRAY( sheet_sz[1], /LONG )
   
   FOR i=0, sheet_sz[1]-1 DO BEGIN
      
      IF use_median THEN BEGIN
         column_size = MEDIAN( STRLEN( STRTRIM(sheet[i,*],2) ) )
      ENDIF ELSE BEGIN
         column_size = MAX( STRLEN( STRTRIM(sheet[i,*],2) ) )
      ENDELSE

      numChars[i] = ( column_size + 1 ) > 4 < 50

   ENDFOR
   
   widthChar = (!D.X_CH_SIZE) + 3

   col_widths = (2 + widthChar) * numChars

   return, col_widths
END 

; _____________________________________________________________________________


FUNCTION new_table, wBase, sheet, ROW_LABELS = row_labels, $
                    COLUMN_LABELS = column_labels, FORMAT = format, $
                    SCR_XSIZE=scr_xsize, SCR_YSIZE=scr_ysize

   IF N_ELEMENTS( scr_xsize ) LE 0 THEN scr_xsize = 600
   IF N_ELEMENTS( scr_ysize ) LE 0 THEN scr_ysize = 300
   IF N_ELEMENTS( sheet ) LE 1 THEN sheet = MAKE_ARRAY( 10, 25, /STRING )

   sheet_sz = SIZE( sheet )

   IF sheet_sz[0] NE 2 THEN sheet = MAKE_ARRAY( 10, 25, /STRING )

   sheet_sz = SIZE( sheet )

   IF N_ELEMENTS( row_labels ) LE 0 THEN BEGIN
      row_labels = make_row_labels( sheet_sz[2] )
   ENDIF

   IF N_ELEMENTS( column_labels ) LE 0 THEN BEGIN
      column_labels = make_column_labels( sheet_sz[1] )
   ENDIF

   IF N_ELEMENTS( format ) LE 0 THEN BEGIN      
      format = REPLICATE( '(A)', sheet_sz[1], sheet_sz[2] )
   ENDIF

   IF N_ELEMENTS( row_heights ) LE 0 THEN BEGIN
      row_heights = get_row_heights( sheet )
   ENDIF

   IF N_ELEMENTS( col_widths ) LE 0 THEN BEGIN
      col_widths = get_column_widths( sheet )
   ENDIF

   wTable = WIDGET_TABLE( wBase, VALUE=sheet, /EDITABLE, UNITS=0, $
                          ROW_HEIGHT=row_heights, COLUMN_WIDTH=col_widths, $
                          /RESIZEABLE_COLUMNS, /RESIZEABLE_ROWS, /SCROLL, $
                          X_SCROLL_SIZE=10, Y_SCROLL_SIZE=20, $
                          ROW_LABELS = row_labels, FONT='fixed', $
                          COLUMN_LABELS = column_labels, $
                          ;FORMAT = format, $
                          /ALL_EVENTS, UVALUE='TABLE', $
                          SCR_XSIZE=scr_xsize, SCR_YSIZE=scr_ysize )

   return, wTable

END

; _____________________________________________________________________________


PRO Save_For_Undo, sState

   WIDGET_CONTROL, sState.wTable, GET_VALUE = sheet
   PTR_FREE, sState.ptrUndoBuffer
   sState.ptrUndoBuffer = PTR_NEW( sheet, /NO_COPY )

   IF PTR_VALID( sState.ptrFormulaBuffer ) THEN BEGIN
      sState.ptrFormulaUndoBuffer = PTR_NEW( *sState.ptrFormulaBuffer )
   ENDIF 

END

; _____________________________________________________________________________

PRO Resize_Columns, sState

   Get_Sheet, sState, sheet
   
   col_widths = get_column_widths( sheet )

   WIDGET_CONTROL, sState.wTable, COLUMN_WIDTHS = col_widths, UNITS = 0

END

; _____________________________________________________________________________

PRO Resize_Rows, sState

   Get_Sheet, sState, sheet
   
   row_heights = get_row_heights( sheet )

   WIDGET_CONTROL, sState.wTable,  ROW_HEIGHTS = row_heights, UNITS = 0

END

; _____________________________________________________________________________


PRO Get_Sheet, sState, sheet

   WIDGET_CONTROL, sState.wTable, GET_VALUE = sheet

END

; _____________________________________________________________________________

PRO Put_Sheet, sState, sheet

   IF N_ELEMENTS( sheet ) GT 0 THEN BEGIN
      WIDGET_CONTROL, sState.wTable, SET_VALUE = sheet, /NO_COPY
   ENDIF

END

; _____________________________________________________________________________


PRO Get_Selection, sState, region

   selection = WIDGET_INFO( sState.wTable, /TABLE_SELECT )
   WIDGET_CONTROL, sState.wTable, SET_TABLE_SELECT = selection
   IF TOTAL( selection ) GE 0 THEN BEGIN

                    ; IDL bug
      ;;WIDGET_CONTROL, sState.wTable, GET_VALUE = region, /USE_TABLE_SELECT
      
      Get_Sheet, sState, sheet
      region = sheet[ selection[0]:selection[2],selection[1]:selection[3] ]
   ENDIF

   IF N_ELEMENTS( region ) LE 0 THEN region = ['']

END 

; _____________________________________________________________________________

PRO Get_Formula_Selection, sState, region

   selection = WIDGET_INFO( sState.wTable, /TABLE_SELECT )
   
   IF TOTAL( selection ) GE 0 THEN BEGIN
      region = (*sState.ptrFormulaBuffer)[ selection[0]:selection[2], $
                                           selection[1]:selection[3] ]
   ENDIF 
   IF N_ELEMENTS( region ) LE 0 THEN region = ['']

END 

; _____________________________________________________________________________

PRO Put_Formula_Selection, sState, strFormula

   selection = WIDGET_INFO( sState.wTable, /TABLE_SELECT )

   IF TOTAL( selection ) GE 0 THEN BEGIN
      IF NOT PTR_VALID( sState.ptrFormulaBuffer ) THEN BEGIN
         Get_Sheet, sState, sheet
         formula_sheet = MAKE_ARRAY( SIZE=SIZE(sheet) )
      ENDIF ELSE BEGIN
         formula_sheet = *sState.ptrFormulaBuffer
         PTR_FREE, sState.ptrFormulaBuffer
      ENDELSE 

      formula_sheet[ selection[0]:selection[2], $
                     selection[1]:selection[3]] = strFormula[0]
      sState.ptrFormulaBuffer = PTR_NEW( formula_sheet, /NO_COPY )
   ENDIF 

   return
END

; _____________________________________________________________________________

PRO Put_Selection, sState, region

   ;;WIDGET_CONTROL, sState.wTable, SET_VALUE = region, /USE_TABLE_SELECT

   selection = WIDGET_INFO( sState.wTable, /TABLE_SELECT )
   IF TOTAL( selection ) GE 0 THEN BEGIN
      Get_Sheet, sState, sheet
      sheet[ selection[0],selection[1] ] = region
      Put_Sheet, sState, sheet
   ENDIF 
END

; _____________________________________________________________________________

PRO Clear_Selection, sState

   Get_Selection, sState, old_region
   new_region = MAKE_ARRAY( SIZE = SIZE(old_region) )
   
   Put_Selection, sState, new_region

END 

; _____________________________________________________________________________

PRO Clear_Selection_Format, sState

   IF PTR_VALID( sState.ptrFormatBuffer ) THEN BEGIN

      HELP, sState.ptrFormatBuffer
      
      format = *sState.ptrFormatBuffer

;      format[ sState.aSelection[0] : sState.aSelection[2], $
;              sState.aSelection[1] : sState.aSelection[3] ] = '(A)'
      
      WIDGET_CONTROL, sState.wTable, FORMAT = format
      PTR_FREE, sState.ptrFormatBuffer
      sState.ptrFormatBuffer = PTR_NEW( format, /NO_COPY )

   ENDIF

END 
; _____________________________________________________________________________

PRO Clear_Selection_Formula, sState

   IF PTR_VALID( sState.ptrFormulaBuffer ) THEN BEGIN

      Put_Formula_Selection, sState, ''
   ENDIF

END 

; _____________________________________________________________________________


PRO FileNew, sState

   WIDGET_CONTROL, sState.wTableBase, UPDATE=0

   WIDGET_CONTROL, sState.wTable, /DESTROY

   new_sheet = MAKE_ARRAY( 10, 25, /STRING )

   sheet_sz = SIZE( new_sheet )
   sState.xsize = sheet_sz[1]
   sState.ysize = sheet_sz[2]

   sState.wTable = new_table( sState.wTableBase, new_sheet, $
                              SCR_XSIZE = sState.table_xsize, $
                              SCR_YSIZE = sState.table_ysize )

   WIDGET_CONTROL, sState.wTableBase, UPDATE=1

   wMessage, sState, 'loaded new sheet [25,10]'

END 

; _____________________________________________________________________________


PRO FileOpen, sState, TYPE = type

   IF N_ELEMENTS( type ) LE 0 THEN type = ''

   wmessage, sState, 'select file to read...'

   strTitle = STRING( FORMAT='("Select ",A0," file:")', type )
   new_file = DIALOG_PICKFILE( TITLE = strTitle, /MUST_EXIST )

   IF new_file NE '' THEN BEGIN

      CASE type OF
         
         'SLK': BEGIN
      
            wmessage, sState, 'reading SYLK file...'

            new_sheet = READ_SYLK( new_file, /ARRAY )

                    ; Look for formula
            first_char = STRMID( STRTRIM( new_sheet, 2 ), 0, 1 )
            valid_formula = WHERE( first_char EQ '=', valid_count )
            IF valid_count GT 0 THEN BEGIN
               formula_sheet = MAKE_ARRAY( SIZE=SIZE(new_sheet) )
               formula_sheet[valid_formula] = new_sheet[valid_formula]
               new_sheet[valid_formula] = ''
            ENDIF 
         END

         'XLS': BEGIN

            wmessage, sState, 'reading BIFF5 file...'

            new_sheet = READ_BIFF5( new_file, format )

         END

         'WK1': BEGIN

            wmessage, sState, 'reading 123 file...'

            new_sheet = READ_123( new_file, format )

         END
         
         ELSE:

      ENDCASE

      IF N_ELEMENTS( new_sheet ) GT 2 THEN BEGIN

         WIDGET_CONTROL, sState.wTableBase, UPDATE=0

         WIDGET_CONTROL, sState.wCommandText, SET_VALUE = ''
         esprit_free_pointers, sState

         WIDGET_CONTROL, sState.wTable, /DESTROY

         sheet_sz = SIZE( new_sheet )
         sState.xsize = sheet_sz[1]
         sState.ysize = sheet_sz[2]

         wmessage, sState, 'creating new table...'
         sState.wTable = new_table( sState.wTableBase, new_sheet, $
                                    FORMAT = format, $
                                    SCR_XSIZE = sState.table_xsize, $
                                    SCR_YSIZE = sState.table_ysize )

         IF N_ELEMENTS( formula_sheet ) EQ N_ELEMENTS( new_sheet ) THEN BEGIN

            sState.ptrFormulaBuffer = PTR_NEW( formula_sheet, /NO_COPY )

         ENDIF
         
         WIDGET_CONTROL, sState.wTableBase, UPDATE=1
         
         strMessage = $
          STRING( FORMAT='("loaded new sheet [",I0,",",I0,"]")', $
                  sheet_sz[1], sheet_sz[2] )
         wmessage, sState, strMessage

         save_for_undo, sState
         RecalculateSheet, sState

      ENDIF ELSE BEGIN

         wmessage, sState, 'no data'
      ENDELSE

   ENDIF ELSE wmessage, sState, ''

END

; _____________________________________________________________________________


PRO FileSave, sState, TYPE = type, OVERWRITE = overwrite, FORMULA = formula

   IF N_ELEMENTS( type ) LE 0 THEN type = 'SLK'

   wmessage, sState, 'select file to write...'

   strFile = 'sheet.' + STRLOWCASE( type )
   save_file = DIALOG_PICKFILE( TITLE=' Select file for writing:', $
                                GROUP=sState.wRoot, FILE=strFile )

   path = FINDFILE( save_file, COUNT = scount )

   IF save_file EQ '' THEN BEGIN
      wmessage, sState, 'write cancelled'
      return
   ENDIF
      
   IF (scount EQ 0) OR KEYWORD_SET( overwrite ) THEN BEGIN

      Get_Sheet, sState, sheet

      IF KEYWORD_SET( formula ) THEN BEGIN
         IF PTR_VALID( sState.ptrFormulaBuffer ) THEN BEGIN
            valid_formula = WHERE( *sState.ptrFormulaBuffer NE '', valid_count )
            IF valid_count GT 0 THEN BEGIN
               sheet[ valid_formula ] = (*sState.ptrFormulaBuffer)[valid_formula]
            ENDIF
         ENDIF 
      ENDIF 

      CASE STRUPCASE( type ) OF
         
         'SLK': BEGIN
      
            wmessage, sState, 'writing SYLK file...'
            
            status = WRITE_SYLK( save_file, sheet )
         END

         'TXT': BEGIN
            status = write_ascii_sheet( save_file, sheet )
         END

         'HTML': BEGIN
            status = write_html_sheet( save_file, sheet )
         END
         
         ELSE: status = 0b

      ENDCASE

      IF status EQ 1 THEN BEGIN

         strMessage = 'wrote sheet to ' + save_file
         wmessage, sState, strMessage

      ENDIF ELSE BEGIN
         
         wmessage, sState, 'no data written'

      ENDELSE

   ENDIF ELSE wmessage, sState, 'write cancelled: file exists'

END

; _____________________________________________________________________________


PRO EditCut, sState
   
   Get_Selection, sState, region
   
   save_for_undo, sState
   Clear_Selection, sState

   PTR_FREE, sState.ptrCopyBuffer
   sState.ptrCopyBuffer = PTR_NEW( region, /NO_COPY )
   
   wmessage, sState, 'selection cut to clipboard'

END

; _____________________________________________________________________________


PRO EditCopy, sState, FORMULA = formula

   IF KEYWORD_SET( formula ) THEN BEGIN
      IF NOT PTR_VALID( sState.ptrFormulaBuffer ) THEN BEGIN
         wmessage, sState, 'no formula defined'
         return
      ENDIF 
      selection = WIDGET_INFO( sState.wTable, /TABLE_SELECT )
      IF TOTAL(selection) LT 0 THEN BEGIN
         wmessage, sState, 'no cells selected'
         return
      ENDIF

      Get_Formula_Selection, sState, region
      sState.copy_formula = 1b
   ENDIF ELSE BEGIN
      Get_Selection, sState, region
      sState.copy_formula = 0b
   ENDELSE 

   PTR_FREE, sState.ptrCopyBuffer
   sState.ptrCopyBuffer = PTR_NEW( region, /NO_COPY )

   wmessage, sState, 'selection copied to clipboard'

END

; _____________________________________________________________________________


PRO EditPaste, sState

   IF PTR_VALID( sState.ptrCopyBuffer ) THEN BEGIN

      Save_For_Undo, sState
      IF sState.copy_formula EQ 0 THEN BEGIN
         Put_Selection, sState, (*sState.ptrCopyBuffer)
      ENDIF ELSE BEGIN
         Put_Formula_Selection, sState, (*sState.ptrCopyBuffer)
      ENDELSE 

   ENDIF

END

; _____________________________________________________________________________


PRO EditFillDown, sState

   Get_Selection, sState, region

   region_sz = SIZE( region )

   IF region_sz[0] NE 2 THEN return

   new_region = MAKE_ARRAY( SIZE = region_sz )

   top_row = region[*,0]

   FOR j=0, region_sz[2]-1 DO BEGIN
      new_region[*,j] = top_row
   ENDFOR

   Save_For_Undo, sState
   Put_Selection, sState, new_region

END

; _____________________________________________________________________________


PRO EditFillRight, sState

   Get_Selection, sState, region

   region_sz = SIZE( region )

   IF region_sz[1] LT 2 THEN return

   new_region = MAKE_ARRAY( SIZE = region_sz )

   left_col = region[0,*]

   FOR i=0, region_sz[1]-1 DO BEGIN
      new_region[i,*] = left_col
   ENDFOR

   Save_For_Undo, sState
   Put_Selection, sState, new_region

END

; _____________________________________________________________________________

PRO EditClearAll, sState

   Save_For_Undo, sState
   Clear_Selection, sState
   Clear_Selection_Formula, sState

END

; _____________________________________________________________________________

PRO EditClearFormats, sState

   Save_For_Undo, sState
   Clear_Selection_Format, sState

END
; _____________________________________________________________________________

PRO EditClearFormula, sState

   Save_For_Undo, sState
   Clear_Selection_Formula, sState

END

; _____________________________________________________________________________

PRO EditClearValue, sState

   Save_For_Undo, sState
   Clear_Selection, sState

END

; _____________________________________________________________________________

PRO DeleteCells, sState, UP = up, LEFT = left

   sel = WIDGET_INFO( sState.wTable, /TABLE_SELECT )

   IF TOTAL( sel ) LE 0 THEN return

   Get_Sheet, sState, sheet
   sheet_sz = SIZE( sheet )

   sheet[ sel[0]:sel[2], sel[1]:sel[3] ] = ''

   IF PTR_VALID( sState.ptrFormulaBuffer ) THEN BEGIN
      formula_sheet = *sState.ptrFormulaBuffer
      formula_sheet[ sel[0]:sel[2], sel[1]:sel[3] ] = ''
      valid_formula = 1b
   ENDIF ELSE valid_formula = 0b

   IF KEYWORD_SET( left ) THEN BEGIN

      shift_x = sel[2] - sel[0] + 1
      shift_y = 0L
      
      reform_x = sheet_sz[1] - sel[2]
      reform_y = sel[3] - sel[1] + 1
      
      slot = sheet[ sel[0]:*, sel[1]:sel[3] ]

      IF valid_formula THEN $
       formula_slot = formula_sheet[ sel[0]:*, sel[1]:sel[3] ]
   ENDIF ELSE BEGIN
      shift_x = 0L
      shift_y = sel[3] - sel[1] + 1
      
      reform_x = sel[2] - sel[0] + 1
      reform_y = sheet_sz[2] - sel[3]
      
      slot = sheet[ sel[0]:sel[2], sel[1]:* ]
      IF valid_formula THEN $
       formula_slot = formula_sheet[ sel[0]:sel[2], sel[1]:* ]
      
   ENDELSE
   
   slot_sz = SIZE( slot )

   IF slot_sz[0] NE 2 THEN BEGIN
      slot = REFORM( slot, reform_x, reform_y )
      IF valid_formula THEN $
       formula_slot = REFORM( formula_slot, reform_x, reform_y )
      slot_sz = SIZE( slot )
   ENDIF 

   shifted_slot = SHIFT( slot, -1 * shift_x, -1 * shift_y )
   IF valid_formula THEN $
    shifted_formula_slot = SHIFT( formula_slot, -1 * shift_x, -1 * shift_y )

   sheet[ sel[0], sel[1] ] = shifted_slot
   IF valid_formula THEN $
    formula_sheet[ sel[0], sel[1] ] = shifted_formula_slot

   WIDGET_CONTROL, sState.wTable, UPDATE = 0

   Save_For_Undo, sState
   Put_Sheet, sState, sheet

   IF valid_formula THEN BEGIN
      PTR_FREE, sState.ptrFormulaBuffer
      sState.ptrFormulaBuffer = PTR_NEW( formula_sheet, /NO_COPY )
   ENDIF 

   Resize_Columns, sState

   WIDGET_CONTROL, sState.wTable, UPDATE = 1

END

; _____________________________________________________________________________

PRO InsertCells, sState, DOWN = down, RIGHT = right

   sel = WIDGET_INFO( sState.wTable, /TABLE_SELECT )

   IF TOTAL( sel ) LT 0 THEN return

   Get_Sheet, sState, sheet
   sheet_sz = SIZE( sheet )

   IF PTR_VALID( sState.ptrFormulaBuffer ) THEN BEGIN
      formula_sheet = *sState.ptrFormulaBuffer
      valid_formula = 1b
   ENDIF ELSE valid_formula = 0b

   IF KEYWORD_SET( right ) THEN BEGIN

      shift_x = sel[2] - sel[0] + 1
      shift_y = 0L

      reform_x = sheet_sz[1] - sel[0]
      reform_y = sel[3] - sel[1] + 1

      slot = sheet[ sel[0]:*, sel[1]:sel[3] ]
      IF valid_formula THEN $
       formula_slot = formula_sheet[ sel[0]:*, sel[1]:sel[3] ]

   ENDIF ELSE BEGIN
      shift_x = 0L
      shift_y = sel[3] - sel[1] + 1

      reform_x = sel[2] - sel[0] + 1
      reform_y = sheet_sz[2] - sel[1]

      slot = sheet[ sel[0]:sel[2], sel[1]:* ]
      IF valid_formula THEN $
       formula_slot = formula_sheet[ sel[0]:sel[2], sel[1]:* ]

   ENDELSE

   slot_sz = SIZE( slot )

   IF slot_sz[0] NE 2 THEN BEGIN
      slot = REFORM( slot, reform_x, reform_y )
      IF valid_formula THEN $
       formula_slot = REFORM( formula_slot, reform_x, reform_y )     
      slot_sz = SIZE( slot )
   ENDIF 

   new_slot = MAKE_ARRAY( slot_sz[1] + shift_x, slot_sz[2] + shift_y, $
                          /STRING )

                    ; Make sure new_slot is 2D
   new_slot = REFORM( new_slot, reform_x + shift_x, reform_y + shift_y )
   new_slot[0,0] = slot

   sState.xsize = sState.xsize + shift_x
   sState.ysize = sState.ysize + shift_y

   new_sheet = MAKE_ARRAY( sheet_sz[1] + shift_x, sheet_sz[2] + shift_y, $
                           /STRING )
   new_sheet[0,0] = TEMPORARY( sheet )   
   new_sheet[ sel[0], sel[1] ] = SHIFT( new_slot, shift_x, shift_y )

   IF valid_formula THEN BEGIN
      new_formula_sheet = MAKE_ARRAY( sheet_sz[1] + shift_x, sheet_sz[2] + shift_y, $
                                      /STRING )
      new_formula_sheet[0,0] = TEMPORARY( formula_sheet )   
      new_formula_sheet[ sel[0], sel[1] ] = SHIFT( new_slot, shift_x, shift_y )
      PTR_FREE, sState.ptrFormulaBuffer
      sState.ptrFormulaBuffer = PTR_NEW( new_formula_sheet, /NO_COPY )
   ENDIF

   WIDGET_CONTROL, sState.wTable, UPDATE = 0
   WIDGET_CONTROL, sState.wTable, INSERT_COLUMN = shift_x
   WIDGET_CONTROL, sState.wTable, INSERT_ROW = shift_y
   
   Save_For_Undo, sState
   Put_Sheet, sState, new_sheet

   Resize_Columns, sState

   column_labels = make_column_labels( sState.xsize )
   WIDGET_CONTROL, sState.wTable, COLUMN_LABELS = column_labels
   row_labels = make_row_labels( sState.ysize )
   WIDGET_CONTROL, sState.wTable, ROW_LABELS = ROW_labels

   WIDGET_CONTROL, sState.wTable, UPDATE = 1

END

; _____________________________________________________________________________

PRO InsertRow, sState

   selection = WIDGET_INFO( sState.wTable, /TABLE_SELECT )
   IF TOTAL( selection ) LT 0 THEN return

   num_rows = selection[3] - selection[1] + 1

   sState.ysize = sState.ysize + num_rows

   Save_For_Undo, sState
   WIDGET_CONTROL, sState.wTable, UPDATE = 0
   WIDGET_CONTROL, sState.wTable, INSERT_ROW=num_rows, /USE_TABLE_SELECT

   row_labels = make_row_labels( sState.ysize )
   WIDGET_CONTROL, sState.wTable, ROW_LABELS = row_labels

   IF PTR_VALID( sState.ptrFormulaBuffer ) THEN BEGIN
      formula_sheet = MAKE_ARRAY( sState.xsize, sState.ysize, /STRING )
      IF selection[1] GT 0 THEN $
       formula_sheet[0,0] = (*sState.ptrFormulaBuffer)[*,0:selection[1]-1]
      formula_sheet[0,selection[3]+1] = $
       (*sState.ptrFormulaBuffer)[*,selection[1]:*]
      PTR_FREE, sState.ptrFormulaBuffer
      sState.ptrFormulaBuffer = PTR_NEW( formula_sheet, /NO_COPY )
   ENDIF

   WIDGET_CONTROL, sState.wTable, UPDATE = 1

END

; _____________________________________________________________________________

PRO InsertColumn, sState

   selection = WIDGET_INFO( sState.wTable, /TABLE_SELECT )
   IF TOTAL( selection ) LT 0 THEN return

   num_cols = selection[2] - selection[0] + 1

   sState.xsize = sState.xsize + num_cols

   Save_For_Undo, sState
   WIDGET_CONTROL, sState.wTable, UPDATE = 0
   WIDGET_CONTROL, sState.wTable, INSERT_COLUMN=num_cols, /USE_TABLE_SELECT
   
;   Resize_Columns, sState

   column_labels = make_column_labels( sState.xsize )
   WIDGET_CONTROL, sState.wTable, COLUMN_LABELS = column_labels

   IF PTR_VALID( sState.ptrFormulaBuffer ) THEN BEGIN
      formula_sheet = MAKE_ARRAY( sState.xsize, sState.ysize, /STRING )

      IF selection[0] GT 0 THEN $
       formula_sheet[0,0] = (*sState.ptrFormulaBuffer)[0:selection[0]-1,*]
      formula_sheet[selection[2]+1,0] = $
       (*sState.ptrFormulaBuffer)[selection[0]:*,*]
      PTR_FREE, sState.ptrFormulaBuffer
      sState.ptrFormulaBuffer = PTR_NEW( formula_sheet, /NO_COPY )
   ENDIF

   WIDGET_CONTROL, sState.wTable, UPDATE = 1

END

; _____________________________________________________________________________

PRO DeleteRow, sState

   selection = WIDGET_INFO( sState.wTable, /TABLE_SELECT )
   IF TOTAL( selection ) LT 0 THEN return

   num_rows = selection[3] - selection[1] + 1

   sState.ysize = sState.ysize - num_rows

   Save_For_Undo, sState
   WIDGET_CONTROL, sState.wTable, UPDATE = 0
   WIDGET_CONTROL, sState.wTable, /DELETE_ROW, /USE_TABLE_SELECT

   row_labels = make_row_labels( sState.ysize )
   WIDGET_CONTROL, sState.wTable, ROW_LABELS = row_labels

   IF PTR_VALID( sState.ptrFormulaBuffer ) THEN BEGIN
      formula_sheet = MAKE_ARRAY( sState.xsize, sState.ysize, /STRING )

      IF selection[1] GT 0 THEN $
       formula_sheet[0,0] = (*sState.ptrFormulaBuffer)[*,0:selection[1]-1]
      formula_sheet[0,selection[1]] = $
       (*sState.ptrFormulaBuffer)[*,selection[3]+1:*]

      PTR_FREE, sState.ptrFormulaBuffer
      sState.ptrFormulaBuffer = PTR_NEW( formula_sheet, /NO_COPY )
   ENDIF

   WIDGET_CONTROL, sState.wTable, UPDATE = 1

END

; _____________________________________________________________________________

PRO DeleteColumn, sState

   selection = WIDGET_INFO( sState.wTable, /TABLE_SELECT )
   IF TOTAL( selection ) LT 0 THEN return

   num_cols = selection[2] - selection[0] + 1

   sState.xsize = sState.xsize - num_cols

   Save_For_Undo, sState
   WIDGET_CONTROL, sState.wTable, UPDATE = 0
   WIDGET_CONTROL, sState.wTable, /DELETE_COLUMN, /USE_TABLE_SELECT
   
;   Resize_Columns, sState

   column_labels = make_column_labels( sState.xsize )
   WIDGET_CONTROL, sState.wTable, COLUMN_LABELS = column_labels

   IF PTR_VALID( sState.ptrFormulaBuffer ) THEN BEGIN
      formula_sheet = MAKE_ARRAY( sState.xsize, sState.ysize, /STRING )

      IF selection[0] GT 0 THEN $
       formula_sheet[0,0] = (*sState.ptrFormulaBuffer)[0:selection[0]-1,*]
      formula_sheet[selection[0],0] = $
       (*sState.ptrFormulaBuffer)[selection[2]+1:*,*]

      PTR_FREE, sState.ptrFormulaBuffer
      sState.ptrFormulaBuffer = PTR_NEW( formula_sheet, /NO_COPY )
   ENDIF

   WIDGET_CONTROL, sState.wTable, UPDATE = 1

END

; _____________________________________________________________________________

FUNCTION esprit_execute_command, strCommand, sheet, i, j

   return, EXECUTE( strCommand[0] )
   
END 

; _____________________________________________________________________________

FUNCTION check_command, strCommand, ERROR_STRING = strError

   IF strCommand[0] EQ '' THEN return, 0b
   IF STRPOS( strCommand[0], '=', 1 ) NE -1 THEN BEGIN
      strError = 'illegal "=" character in command'
      return, 0b
   ENDIF
   IF STRPOS( strCommand[0], '$' ) NE -1 THEN BEGIN
      strError = 'illegal "$" character in command'
      return, 0b
   ENDIF
;   IF STRPOS( strCommand[0], '(' ) EQ -1 THEN BEGIN
;      strError = 'not a valid function'
;      return, 0b
;   ENDIF
;   IF RSTRPOS( strCommand[0], ')' ) EQ -1 THEN BEGIN
;      strError = 'not a valid function'
;      return, 0b
;   ENDIF

   return, 1b
END 

; _____________________________________________________________________________

FUNCTION construct_command, strCommand, selection

   IF N_ELEMENTS( selection ) EQ 4 THEN BEGIN
      strFormat = '("sheet[",I0,":",I0,",",I0,":",I0,"] ")'
      command_prefix = STRING(FORMAT=strFormat,$
                              selection[0], selection[2], $
                              selection[1], selection[3] )
   ENDIF ELSE BEGIN
      strFormat = '("sheet[",I0,",",I0,"] ")'
      command_prefix = STRING( FORMAT=strFormat,$
                               selection[0], selection[1] )
   ENDELSE 

   strExec = command_prefix + strCommand[0]
   
   return, strExec
END 

; _____________________________________________________________________________

PRO RunCommand, sState, strCommand

   IF check_command( strCommand, ERROR=strError ) NE 1 THEN BEGIN
      wmessage, sState, strError
      return
   ENDIF 
   selection = WIDGET_INFO( sState.wTable, /TABLE_SELECT )
   IF TOTAL( selection ) LT 0 THEN BEGIN
      wmessage, sState, 'no cells selected'
   ENDIF 

   Get_Sheet, sState, sheet
   
   error_flag = 0b
   FOR j=selection[1],selection[3] DO BEGIN
      FOR i=selection[0],selection[2] DO BEGIN
         strExec = construct_command(strCommand,selection)

         result = esprit_execute_command( strExec, sheet, i, j )

         IF result NE 1 THEN BEGIN
            strFormat = '("ERROR in Formula: Cell [",I0,",",I0,"]")'
            PRINT, FORMAT=strFormat, i, j
            error_flag = 1b
         ENDIF 
      ENDFOR 
   ENDFOR 
   
   IF error_flag EQ 0 THEN BEGIN
      wmessage, sState, 'command completed successfully.'
      save_for_undo, sState
      Put_Sheet, sState, sheet
   ENDIF ELSE BEGIN
      wmessage, sState, 'command execution failed.'
   ENDELSE 

   return
END 

; _____________________________________________________________________________

PRO RecalculateSheet, sState

   IF PTR_VALID( sState.ptrFormulaBuffer ) THEN BEGIN
      Get_Sheet, sState, sheet
      sheet_sz = SIZE( sheet )
      wmessage, sState, 'recalculating sheet...'
      WIDGET_CONTROL, /HOURGLASS
      error_flag = 0b
      FOR j=0, sheet_sz[2]-1 DO BEGIN
         FOR i=0, sheet_sz[1]-1 DO BEGIN
            formula = (*sState.ptrFormulaBuffer)[i,j]
            IF formula NE '' THEN BEGIN
               strExec = construct_command(formula,[i,j])
               result = esprit_execute_command( strExec, sheet, i, j )
               IF result NE 1 THEN BEGIN
                  strFormat = '("ERROR in Formula: Cell [",I0,",",I0,"]")'
                  PRINT, FORMAT=strFormat, i, j
                  error_flag = 1b
               ENDIF 
            ENDIF 
         ENDFOR 
      ENDFOR 
      IF error_flag EQ 0b THEN BEGIN
         save_for_undo, sState
         Put_Sheet, sState, sheet
      ENDIF 
      wmessage, sState, 'done.'
   ENDIF 
END 
; _____________________________________________________________________________


PRO show_about_event, sEvent

   WIDGET_CONTROL, sEvent.id, GET_UVALUE = event_uval
   
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

PRO show_about, sState

   version = sState.version
   version_date = sState.version_date

   wintitle =  STRING( FORMAT='("About Esprit (v",A,")")', version )

   message = [ STRING( FORMAT='("Esprit version",1X,A)', version ), $
               'written by: William Jon McCann', $
               'JHU Advanced Camera for Surveys', $
               version_date ]

   wBase = WIDGET_BASE( TITLE=wintitle, GROUP=sState.wRoot, /COLUMN )

   wLabels = LONARR( N_ELEMENTS( message ) )

   wLabels[0] = WIDGET_LABEL( wBase, VALUE = message[0], $
                        FONT = 'times-bold*24', /ALIGN_CENTER )
   FOR i = 1, N_ELEMENTS( message ) - 1 DO BEGIN
      wLabels[i] = WIDGET_LABEL( wBase, VALUE = message[i], $
                           FONT = 'times-bold*14', /ALIGN_CENTER )
   ENDFOR

   wButton = WIDGET_BUTTON( wBase, VALUE = 'OK', /ALIGN_CENTER, $
                          UVALUE = 'OK_BUTTON' )

   WIDGET_CONTROL, wBase, /REALIZE

   XMANAGER, 'show_about', wBase, /NO_BLOCK

END

; _____________________________________________________________________________

PRO show_help_event, sEvent

   WIDGET_CONTROL, sEvent.id, GET_UVALUE = event_uval
   
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

PRO show_help, sState

   version = sState.version
   version_date = sState.version_date

   wintitle =  STRING( FORMAT='("Esprit Help (v",A,")")', version )

   message=[ STRING( FORMAT='("Esprit version",1X,A)', version ), $
             'Equations may only be entered via the value input box.', $
             'They take the form "=COMMAND".', $
             'Where COMMAND may be either a constant or a function.', $
             'The command has access to the following variables:', $
             '     sheet - the spreadsheet array', $
             '         i - the x (column) index of the cell', $
             '         j - the y (row) index of the cell', $
             '', $
             'Click the "Enter" button to place the result of the', $
             ' equation into the selected cell(s).', $
             'Click the "Associate" button to associate the equation', $
             ' with the selected cell(s).' ]
   
   wBase = WIDGET_BASE( TITLE=wintitle, GROUP=sState.wRoot, /COLUMN )

   wLabels = LONARR( N_ELEMENTS( message ) )

   wLabels[0] = WIDGET_LABEL( wBase, VALUE = message[0], $
                              FONT = 'times-bold*24', /ALIGN_CENTER )
   FOR i = 1, N_ELEMENTS( message ) - 1 DO BEGIN
      wLabels[i] = WIDGET_LABEL( wBase, VALUE = message[i], $
                           FONT = 'times-bold*14', /ALIGN_LEFT )
   ENDFOR

   wButton = WIDGET_BUTTON( wBase, VALUE = 'OK', /ALIGN_CENTER, $
                          UVALUE = 'OK_BUTTON' )

   WIDGET_CONTROL, wBase, /REALIZE

   XMANAGER, 'show_help', wBase, /NO_BLOCK

END 

; _____________________________________________________________________________

PRO esprit_event, sEvent

                    ; get state information from first child of root
   child = WIDGET_INFO( sEvent.handler, /CHILD )
   infobase = WIDGET_INFO( child, /SIBLING )
   WIDGET_CONTROL, infobase, GET_UVALUE=sState, /NO_COPY 

   WIDGET_CONTROL, sEvent.id, GET_UVALUE=event_uval

   CASE STRUPCASE( event_uval ) OF

      'COMMAND_TEXT': BEGIN
         WIDGET_CONTROL, sState.wCommandText, GET_VALUE=strCommand
         RunCommand, sState, strCommand[0]
      END 
      'ENTER_BUTTON': BEGIN
         WIDGET_CONTROL, sState.wCommandText, GET_VALUE=strCommand
         strCommand = STRTRIM( strCommand[0], 2 )
         equal_pos = STRPOS( strCommand, '=' )
         save_for_undo, sState
         IF equal_pos EQ 0 THEN BEGIN
                    ; it is an IDL command
            RunCommand, sState, strCommand[0]
         ENDIF ELSE BEGIN
                    ; it is a string value
            Put_Selection, sState, strCommand[0]
         ENDELSE 

      END 
      'RESET_BUTTON': BEGIN
         WIDGET_CONTROL, sState.wCommandText, SET_VALUE=''
      END
      'ASSOC_BUTTON': BEGIN
         WIDGET_CONTROL, sState.wCommandText, GET_VALUE=strCommand
         strCommand = STRTRIM( strCommand[0], 2 )
         IF STRPOS( strCommand, '=' ) EQ 0 THEN BEGIN
            IF check_command( strCommand[0], ERROR=strError ) NE 1 THEN BEGIN
               wmessage, sState, strError
               return
            ENDIF 
            
            Put_Formula_Selection, sState, strCommand[0]
            RecalculateSheet, sState
         ENDIF 
      END

      'MENU': BEGIN

         CASE sEvent.value OF
            
            'Tools.Recalculate': BEGIN
               RecalculateSheet, sState
            END 

            'File.New': BEGIN
               FileNew, sState
            END

            'File.Open.SYLK': BEGIN
               FileOpen, sState, TYPE = 'SLK'
            END

            'File.Open.BIFF5': BEGIN
               FileOpen, sState, TYPE = 'XLS'
            END

            'File.Open.123': BEGIN
               FileOpen, sState, TYPE = 'WK1'
            END

            'File.Save.SYLK': BEGIN
               FileSave, sState, TYPE = 'SLK'
            END

            'File.Save.SYLK w/formula': BEGIN
               FileSave, sState, TYPE = 'SLK', /FORMULA
            END
            
            'File.Save.ASCII': BEGIN
               FileSave, sState, TYPE = 'TXT', /OVER
            END

            'File.Save.HTML': BEGIN
               FileSave, sState, TYPE = 'HTML', /OVER
            END

            'File.Exit': BEGIN
               esprit_clean_exit, sState

               WIDGET_CONTROL, sEvent.top, /DESTROY

               return
            END 

            'Edit.Undo': BEGIN
               
               IF PTR_VALID( sState.ptrUndoBuffer ) THEN BEGIN
                  
                  IF N_ELEMENTS( *sState.ptrUndoBuffer ) GT 2 THEN BEGIN
                     WIDGET_CONTROL, sState.wTable, $
                      SET_VALUE=(*sState.ptrUndoBuffer)
                     
                     sheet_sz = SIZE( *sState.ptrUndoBuffer )
                     sState.xsize = sheet_sz[1]
                     sState.ysize = sheet_sz[2]
                     
                     PTR_FREE, sState.ptrUndoBuffer
                     sState.ptrUndoBuffer = PTR_NEW()

                     wmessage, sState, "undone"
                  ENDIF

                  IF PTR_VALID( sState.ptrFormulaUndoBuffer ) THEN BEGIN
                     formula_undo = *sState.ptrFormulaUndoBuffer
                     PTR_FREE, sState.ptrFormulaUndoBuffer, sState.ptrFormulaBuffer
                     sState.ptrUndoBuffer = PTR_NEW()
                     sState.ptrFormulaBuffer = PTR_NEW( formula_undo, /NO_COPY )
                  ENDIF 

                  Resize_Columns, sState

               ENDIF ELSE wmessage, sState, "can't undo"

            END
            
            'Edit.Cut': BEGIN
               EditCut, sState
            END
            
            'Edit.Copy': BEGIN
               EditCopy, sState
            END

            'Edit.Copy formula': BEGIN
               EditCopy, sState, /FORMULA
            END

            'Edit.Paste': BEGIN
               EditPaste, sState
            END

            'Edit.Fill.Down': BEGIN
               EditFillDown, sState
            END

            'Edit.Fill.Right': BEGIN
               EditFillRight, sState
            END

            'Edit.Clear.All': BEGIN
               EditClearAll, sState
            END

            'Edit.Clear.Formula': BEGIN
               EditClearFormula, sState
               WIDGET_CONTROL, sState.wCommandText, SET_VALUE = ''
            END
            
            'Edit.Clear.Value': BEGIN
               EditClearValue, sState
            END
            
            'Insert.Cells.Shift right': BEGIN
               InsertCells, sState, /RIGHT
            END

            'Insert.Cells.Shift down': BEGIN
               InsertCells, sState, /DOWN
            END

            'Insert.Row': BEGIN
               InsertRow, sState
            END

            'Insert.Column': BEGIN
               InsertColumn, sState
            END 

            'Delete.Cells.Shift up': BEGIN
               DeleteCells, sState, /UP
            END

            'Delete.Cells.Shift left': BEGIN
               DeleteCells, sState, /LEFT
            END

            'Delete.Row': BEGIN
               DeleteRow, sState
            END

            'Delete.Column': BEGIN
               DeleteColumn, sState
            END 

            'Help.About': show_about, sState

            'Help.Help': show_help, sState
            
            ELSE:

         ENDCASE 

      END

      'TABLE': BEGIN
         
         CASE TAG_NAMES( sEvent, /STRUCTURE_NAME) OF
            
            'WIDGET_TABLE_CELL_SEL': BEGIN
               selection = WIDGET_INFO( sState.wTable, /TABLE_SELECT )
               x0 = selection[0]
               y0 = selection[1]
               x1 = selection[2]
               y1 = selection[3]
               logic = (x0 NE -1) AND (y0 NE -1) AND $
                (x1-x0 EQ 0) AND (y1-y0 EQ 0)
               IF logic EQ 1 THEN BEGIN
                  IF PTR_VALID( sState.ptrFormulaBuffer ) THEN BEGIN
                     strValue = (*sState.ptrFormulaBuffer)[x0,y0]
                  ENDIF ELSE strValue = ''
                  
                  IF strValue EQ '' THEN BEGIN
                     Get_Selection, sState, region
                     strValue = region[0,0]
                  ENDIF 
                  WIDGET_CONTROL, sState.wCommandText, SET_VALUE=strValue[0]
               ENDIF
            END
            
            'WIDGET_TABLE_CH': BEGIN

               IF (sEvent.ch EQ 13b) OR (sEvent.ch EQ 9b) THEN BEGIN

                    ; on CR or TAB save for undoing

                  save_for_undo, sState

               ENDIF

            END 

            'WIDGET_TABLE_INVALID_ENTRY': BEGIN

               WIDGET_CONTROL, sState.wTable, GET_VALUE = sheet

               x = sEvent.x
               y = sEvent.y

               sheet[x,y] = ''

               WIDGET_CONTROL, sState.wTable, SET_VALUE = sheet, /NO_COPY

               PRINT, STRING( 7b )
               wmessage, sState, 'invalid entry'

            END 

            ELSE:

         ENDCASE

      END 

      'ROOT': BEGIN
         
         CASE TAG_NAMES( sEvent, /STRUCTURE_NAME) OF
            
            'WIDGET_KILL_REQUEST': BEGIN

               esprit_clean_exit, sState
               
               WIDGET_CONTROL, sEvent.top, /DESTROY
               return

            END

            ELSE: BEGIN
               
               tags = TAG_NAMES( sEvent )
               EQE = WHERE( STRUPCASE( tags ) EQ 'X', ecount )
               
               IF ecount GT 0 THEN BEGIN
                    ; this is a resize event
                  newx = (sEvent.x) > 550
                  newy = (sEvent.y - 100) > 50

                  WIDGET_CONTROL, sState.wTable, $
                   SCR_XSIZE = newx, SCR_YSIZE = newy
                  
                  sState.table_xsize = newx
                  sState.table_ysize = newy
               ENDIF

            END

         ENDCASE

      END 

      ELSE: PRINTF, -2, 'Case match not found'

   ENDCASE

   IF WIDGET_INFO( infobase, /VALID_ID ) EQ 1 THEN BEGIN
                    ; restore state information
      WIDGET_CONTROL, infobase, SET_UVALUE=sState, /NO_COPY
   ENDIF

END

; _____________________________________________________________________________

FUNCTION rcs_revision, strRevision, DEBUG = debug

   IF N_ELEMENTS( strRevision ) LE 0 THEN return, '0.0'

   colon_pos = STRPOS( strRevision, ':' )

   dollar_pos = RSTRPOS( strRevision, '$' )

   IF KEYWORD_SET( debug ) THEN HELP, colon_pos, dollar_pos

   IF (colon_pos EQ -1) OR (dollar_pos EQ -1) OR (dollar_pos LE colon_pos) $
    THEN return, '0.0'

   version = STRTRIM( STRMID( strRevision, colon_pos+1, $
                              dollar_pos - colon_pos - 1 ), 2 )

   return, version

END 

; _____________________________________________________________________________


FUNCTION rcs_date, strDate, DEBUG = debug

   ; sample = ' $Date: 1999/08/17 23:52:27 $ '

   IF N_ELEMENTS( strDate ) LE 0 THEN return, '1999/00/00 00:00:00'

   colon_pos = STRPOS( strDate, ':' )

   dollar_pos = RSTRPOS( strDate, '$' )

   IF KEYWORD_SET( debug ) THEN HELP, colon_pos, dollar_pos

   IF (colon_pos EQ -1) OR (dollar_pos EQ -1) OR (dollar_pos LE colon_pos) $
    THEN return, '1999/00/00 00:00:00'

   version_date = STRMID( strDate, colon_pos + 1, dollar_pos - colon_pos - 1 )

   return, version_date

END 

; _____________________________________________________________________________


PRO esprit, sheet, format, GROUP_LEADER=group, TITLE=WinTitle, $
             XLS = xls, WK1 = wk1

; ---------------------------------------
; Check input
; ---------------------------------------

   instance_number = XREGISTERED( 'esprit', /NOSHOW ) + 1L
   strVersion = rcs_revision( ' $Revision: 1.1 $ ' )
   strVersion_date = rcs_date( ' $Date: 1999/08/17 23:52:27 $ ' )

   IF N_ELEMENTS( group ) LE 0 THEN group = 0
   IF NOT KEYWORD_SET( WinTitle ) THEN WinTitle = $
    STRING( FORMAT='("Esprit (v",F3.1,") [",I0,"]")', $
            strVersion, instance_number )


   IF N_ELEMENTS( sheet ) LE 0 THEN sheet = MAKE_ARRAY( 10, 25, /STRING )

; ---------------------------------------
; Define some stuff
; ---------------------------------------
   
   MenuList = [ '1\File', '0\New', '1\Open', $
                '0\SYLK', '0\BIFF5', '2\123', $
                '1\Save', '0\SYLK', '0\SYLK w/formula', '0\ASCII', '2\HTML', $
                '2\Exit', $
                '1\Edit', '0\Undo', '0\Cut', '0\Copy', '0\Copy formula', '0\Paste', $
                '1\Fill', '0\Down', '2\Right', $
                '3\Clear', '0\All', '0\Formula', '2\Value', $
                '1\Insert', '1\Cells', '0\Shift right', '2\Shift down', $
                '0\Row', '2\Column', $
                '1\Delete', '1\Cells', '0\Shift left', '2\Shift up', $
                '0\Row', '2\Column', $
                '1\Tools', '2\Recalculate', $
                '1\Help', '0\Help', '2\About' ]

; ---------------------------------------
; Build Widget
; ---------------------------------------

   wRoot = WIDGET_BASE( GROUP_LEADER=Group, UVALUE='ROOT', TITLE=WinTitle, $
                        COLUMN=1, MAP=1, MBAR=wMbar, /TLB_SIZE_EVENTS )
   
   wBase = WIDGET_BASE( wRoot, /COLUMN, FRAME=0, XPAD=1, YPAD=1 )

   wMenuBar = CW_PDMENU( wMbar, /RETURN_FULL_NAME, /MBAR, /HELP, $
                         MenuList, UVALUE='MENU')

   wCommandBase = WIDGET_BASE( wBase, /ROW )
   wCommandLabel = WIDGET_LABEL( wCommandBase, VALUE = 'Value: ', $
                                 FONT = 'fixed' )
   wCommandText = WIDGET_TEXT( wCommandBase, /EDITABLE, FONT='fixed', $
                               UVALUE = 'COMMAND_TEXT', XSIZE = 50 )
   wCommandDoButton = WIDGET_BUTTON( wCommandBase, VALUE='Enter', $
                                     UVALUE='ENTER_BUTTON', $
                                     FONT='fixed' )
   wCommandResetButton = WIDGET_BUTTON( wCommandBase, VALUE='Reset', $
                                        UVALUE='RESET_BUTTON', $
                                        FONT = 'fixed' )
   wCommandAssocButton = WIDGET_BUTTON( wCommandBase, VALUE='Associate', $
                                        UVALUE='ASSOC_BUTTON', $
                                        FONT='fixed' )
   wTableBase = WIDGET_BASE( wBase, /COLUMN )

   IF N_ELEMENTS( format ) GT 0 THEN BEGIN

      wTable = new_table( wTableBase, sheet[1:*,1:*], $
                          ROW_LABELS=sheet[0,1:*], $
                          COLUMN_LABELS=sheet[1:*,0], $
                          FORMAT = format[1:*,1:*], $
                          SCR_XSIZE = table_xsize, $
                          SCR_YSIZE = table_ysize )

   ENDIF ELSE BEGIN
      wTable = new_table( wTableBase, sheet, $
                          SCR_XSIZE = table_xsize, $
                          SCR_YSIZE = table_ysize )
   ENDELSE

   wMessageText = WIDGET_TEXT( wBase, FONT='fixed' )

   WIDGET_CONTROL, /REALIZE, wBase

   sheet_sz = SIZE( sheet )

   IF N_ELEMENTS( format ) GT 1 THEN ptrFormat = PTR_NEW( format ) $
   ELSE ptrFormat = PTR_NEW()

   sState = { wRoot: wRoot, $
              wBase: wBase, $
              wCommandBase: wCommandBase, $
              wCommandText: wCommandText, $
              wTableBase: wTableBase, $
              wTable: wTable, $
              wMessageText: wMessageText, $
              xsize: sheet_sz[1], $
              ysize: sheet_sz[2], $
              ptrCopyBuffer: PTR_NEW(), $
              ptrUndoBuffer: PTR_NEW(), $
              ptrFormulaUndoBuffer: PTR_NEW(), $
              ptrFormatBuffer: ptrFormat, $
              ptrFormulaBuffer: PTR_NEW(), $
              copy_formula: 0b, $
              table_xsize: table_xsize, $
              table_ysize: table_ysize, $
              version: strVersion, $
              version_date: strVersion_date, $
              instance: instance_number }

                    ; save state information
   WIDGET_CONTROL, wBase, SET_UVALUE=sState, /NO_COPY

   XMANAGER, 'esprit', wRoot, /NO_BLOCK

END

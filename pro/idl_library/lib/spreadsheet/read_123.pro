;+
; $Id: read_123.pro,v 1.1 2001/11/05 22:02:59 mccannwj Exp $
;
; NAME:
;     READ_123
;
; PURPOSE:
;     Read into an IDL structure the contents of a Lotus 123 (wk1)
;     format spreadsheet file.
;
; CATEGORY:
;     ACS/JHU
;
; CALLING SEQUENCE:
;     result = READ_123( filename [, /ROW, /DEBUG ] )
; 
; INPUTS:
;     filename - (STRING) path to spreadsheet file
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     ROWS   - (BOOLEAN) output ROW_MAJOR structure (for use with WIDGET_TABLE)
;     DEBUG - (BOOLEAN) show debugging information
;
; OUTPUTS:
;     result - IDL structure
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
;    Thu Oct 22 13:38:13 1998, William Jon McCann <mccannwj@acs10>
;		Created.
;-

; _____________________________________________________________________________


FUNCTION skel_cell

   sCell = { WK1CELL, $
             row: 0L, $
             column: 0L, $
             value: '', $
             type: 0b, $
             format: 0L }

   return, sCell
END 

; _____________________________________________________________________________

FUNCTION get_long, array, PRINT = print

   IF N_ELEMENTS( array ) LE 0 THEN BEGIN
      MESSAGE, 'Array not specified.'
      return, 0L
   ENDIF

   NZE = WHERE( array GT 0, ncount )

   IF ncount LE 0 THEN return, 0L

   vals = 2 ^ ( N_ELEMENTS( array ) - 1 - NZE )

   long = LONG( TOTAL( vals ) )

   IF KEYWORD_SET( print ) THEN PRINT, long

   return, long
END 

; _____________________________________________________________________________


FUNCTION get_bits, value, PRINT = print, VERBOSE = verbose

   IF N_ELEMENTS( value ) LE 0 THEN return, -1

   FOR i=0L, N_ELEMENTS( value ) - 1 DO BEGIN

      value_sz = SIZE( value[i] )
      IF KEYWORD_SET( verbose ) THEN PRINT, "size:", value_sz
      
      type = value_sz[ value_sz[0] + 1 ]
      CASE type OF
         
         1: BEGIN
                    ; BYTE
            one = 1B
            num_bits = 8
         END 

         2: BEGIN
                    ; INT
            one = 1
            num_bits = 16
         END
         
         3: BEGIN
                    ; LONG
            one = 1L
            num_bits = 32
         END 

         ELSE: BEGIN
            MESSAGE, 'Type case not matched', /CONT
            return, -1
         END
         
      ENDCASE 

      mask = ISHFT( one, num_bits-1)
      
      vals = ISHFT( value[i], INDGEN(num_bits) )

      bits = (vals AND mask) 

      NZE = WHERE( bits NE 0, num )
      IF num GT 0 THEN bits[NZE] = 1
      
      IF N_ELEMENTS( result ) LE 0 THEN result = [bits] $
      ELSE result = [result, bits]

   ENDFOR 

   IF KEYWORD_SET( print ) THEN PRINT, STRCOMPRESS( result, /REMOVE_ALL )

   return, result
END 

; _____________________________________________________________________________


FUNCTION type2format, type

   CASE type OF
      
      1: format = 'I' ; Byte

      2: format = 'I' ; Integer

      3: format = 'I' ; Longword integer

      4: format = 'g' ; Floating point

      5: format = 'g' ; Double-precision floating
      
      6: format = 'g' ; Complex floating

      7: format = 'A' ; String

      9: format = 'g' ; Double-precision complex floating

      ELSE: format = 'A'

   ENDCASE

   return, '('+format+')'

END

; _____________________________________________________________________________


FUNCTION make_struct, aLabels, aValues

   ; values assumed to be scalar strings

   labels = aLabels[ UNIQ( aLabels, SORT( aLabels ) ) ]
   values = STRTRIM( aValues[ UNIQ( aLabels, SORT( aLabels ) ) ], 2 )

   number = N_ELEMENTS( labels )

   format_string = '('+STRTRIM(number,2)+'("values[",I2,"]",:,"," ) )'
   str_list = STRING( INDGEN(number), FORMAT = format_string )

   cmd = 'struct = CREATE_STRUCT( labels, ' + str_list + ',NAME="ROW_STRUCT")'

   result = EXECUTE( cmd )

   IF result EQ 1 THEN return, struct ELSE return, -1

END 

; _____________________________________________________________________________


FUNCTION read_b2i, bytes, ERROR = error, LITTLE_ENDIAN = swap, DEBUG = debug

   byte_array = bytes ; copy the input

   IF KEYWORD_SET( swap ) THEN byte_array = REVERSE( byte_array )

   number = FIX( byte_array, 0, 1 )
   
   return, number[0]
END 

; _____________________________________________________________________________

FUNCTION ieee_b2f, bytes, ERROR = error, LITTLE_ENDIAN = swap, DEBUG = debug


   byte_array = bytes ; copy the input

   num = N_ELEMENTS( byte_array )

   IF KEYWORD_SET( swap ) THEN byte_array = REVERSE( byte_array )

   CASE num OF
      4: number = FLOAT( byte_array, 0, 1 )

      8: number = DOUBLE( byte_array, 0, 1 )

      ELSE: BEGIN

         MESSAGE, 'Unknown data type', /CONT
         error = 1
         return, !VALUES.F_NAN

      END

   ENDCASE

   return, number[0]

END

; _____________________________________________________________________________


FUNCTION get_rows, aCells

   num_cols = MAX( aCells.column ) + 1
   num_rows = MAX( aCells.row ) + 1

   aCells = aCells[ SORT( aCells.row ) ]

   FOR i=0L, num_rows DO BEGIN

      CE = WHERE( aCells.row EQ i, ccount )

      IF ccount GT 0 THEN BEGIN

         cols = aCells[CE].column
         vals = aCells[CE].value
         cols = cols[ SORT( cols ) ]
         vals = vals[ SORT( cols ) ]
         cols = cols[ UNIQ( cols ) ]
         vals = vals[ UNIQ( cols ) ]

         index = INDGEN( num_cols )

         index_mask = BYTE( index * 0 ) + 1b
         col_mask = MAKE_ARRAY( N_ELEMENTS( index ), /BYTE )
         col_mask[cols] = 1b

         result_mask = index_mask XOR col_mask

         missing = WHERE( result_mask EQ 1, mcount )

         IF mcount GT 0 THEN BEGIN
            
            ; fill in missing column
            new_vals = STRARR( mcount )
            cols = [TEMPORARY(cols), missing]
            vals = [TEMPORARY(vals), new_vals] ; pad onto end

            new_order = SORT( cols )
            cols = cols( new_order ) ; resort
            vals = vals( new_order )

         ENDIF 

         ;;FOR j=0,N_ELEMENTS(cols)-1 DO print, FORMAT='(I,"->",A)',cols[j],vals[j]

         names = 'COLUMN'+STRING( cols, FORMAT='(I5.5)' )

         sRow = make_struct( names, vals )

         IF N_TAGS( sRow ) LE 0 THEN MESSAGE, "Couldn't create row structure"

         IF N_ELEMENTS( aRows ) LE 0 THEN aRows = [ sRow ] ELSE $
          aRows = [ aRows, sRow ]

      ENDIF ELSE BEGIN

         sRow = make_struct( 'COLUMN'+STRING( INDGEN( num_cols ), $
                                              FORMAT='(I5.5)' ), $
                                              STRARR( num_cols ) )

         IF N_TAGS( sRow ) LE 0 THEN MESSAGE, "Couldn't create row structure"

         IF N_ELEMENTS( aRows ) LE 0 THEN aRows = [ sRow ] ELSE $
          aRows = [ aRows, sRow ]
         
      ENDELSE

   ENDFOR 

   return, aRows
END 

; _____________________________________________________________________________


FUNCTION read_123, filename, DEBUG = debug, ROWS = return_rows

   path = FINDFILE( filename, COUNT=nfiles )

   IF nfiles LE 0 THEN BEGIN
      MESSAGE, "Cannot find "+filename, /CONT
      return, -1
   ENDIF 

   OPENR, lun, filename, /GET_LUN

                    ; get the begin of file record header
   bof_header = INTARR(2)
   READU, lun, bof_header
   bof_header = SWAP_ENDIAN( TEMPORARY( bof_header ) )
   IF bof_header[0] NE 0 THEN BEGIN
      MESSAGE, 'BOF byte not found', /CONT
      return, -1
   ENDIF

                    ; get the begin of file record body
   length = bof_header[1]/2 ; number of ints is half number of bytes
   bof_body = INTARR( length )
   READU, lun, bof_body
   bof_body = SWAP_ENDIAN( TEMPORARY( bof_body ) )

   done_flag = 0
   WHILE( (NOT EOF(lun)) AND (done_flag NE 1) ) DO BEGIN
      
                    ; get next record header
      header = INTARR(2)
      READU, lun, header
      header = SWAP_ENDIAN( TEMPORARY( header ) )


      code = header[0]
      length = header[1] ; in bytes
      IF KEYWORD_SET( debug ) THEN $
       PRINT, FORMAT='("     code: ",Z2.2,"h ", I, " bytes ", $)',code,length

      IF length GT 0 THEN BEGIN
                    ; get next record body
         body = BYTARR( length )
         READU, lun, body

      ENDIF ELSE body = 0

      CASE code OF 
         '1'X: BEGIN
                    ; EOF
            IF KEYWORD_SET( debug ) THEN $
             print, '(EOF): '

            done_flag = 1 ; set loop done flag
         END 

         '2'X: BEGIN
                    ; CALCMODE
            IF KEYWORD_SET( debug ) THEN $
             print, '(CALCMODE): ignored'
            CASE body[0] OF
               'FF'X: ; automatic

               '0'X: ; manual

               ELSE: ; unknown

            ENDCASE 
         END 

         '4'X: BEGIN
                    ; SPLIT - split window type

                    ; 0 = not split 
                    ; 1 = vertical split 
                    ; FF = horizontal split 

            IF KEYWORD_SET( debug ) THEN $
             print, '(SPLIT): ignored'

         END

         '5'X: BEGIN
                    ; SYNC - split window sync (move with cursor)

                    ; 0 = not synchronized 
                    ; FF = synchronized

            IF KEYWORD_SET( debug ) THEN $
             print, '(SYNC): ignored'

         END 

         '6'X: BEGIN
                    ; RANGE

            IF KEYWORD_SET( debug ) THEN $
             print, '(RANGE): ignored'

         END 

         '7'X: BEGIN
                    ; WINDOW1

                    ; Byte Number              Byte Description 

                    ; 0-1                      cursor column position 
                    ; 2-3                      cursor row position 
                    ; 4                        format
                    ; 5                        unused (0) 
                    ; 6-7                      column width 
                    ; 8-9                      number of columns on screen 
                    ; 10-11                    number of rows on screen 
                    ; 12-13                    left column 
                    ; 14-15                    top row 
                    ; 16-17                    number of title columns 
                    ; 18-19                    number of title rows 
                    ; 20-21                    left title column 
                    ; 22-23                    top title row 
                    ; 24-25                    border width column 
                    ; 26-27                    border width row 
                    ; 28-29                    window width 
                    ; 30                       unused (0) 

            IF KEYWORD_SET( debug ) THEN $
             print, '(WINDOW1): ignored'


         END 

         '8'X: BEGIN
                    ; COLW1 - column width window 1

                    ; Byte Number          Byte Description 
                    ; 0-1                  column 
                    ; 2                    width 

            column = read_b2i( body[0:1], /LITTLE_ENDIAN )
            width = body[2]

            IF KEYWORD_SET( debug ) THEN $
             print, $
             FORMAT='("(COLW1): ignored [",I7,",",I7,"]")', column, width

         END 

         '10'X: BEGIN
                    ; FORMULA - formula cell

                    ; Byte Number           Byte Description 
                    ; 0                     format (see Appendix A,
                    ;                        Cell Format Encoding 
                    ; 1-2                   column 
                    ; 3-4                   row 
                    ; 5-12                  formula numeric value (IEEE
                    ;                        long real; see NUMBER)
                    ; 13-14                 formula size (bytes) 
                    ; 15+                   for code (see Table 1,
                    ;                         Formula Opcodes); Reverse
                    ;                         Polish Internal Notation
                    ;                          2048 bytes maximum 

            sCell = SKEL_CELL()

            sCell.format = body[0]
            sCell.column = read_b2i( body[1:2], /LITTLE_ENDIAN )
            sCell.row = read_b2i( body[3:4], /LITTLE_ENDIAN )
            
            value = ieee_b2f( body[5:12], /LITTLE_ENDIAN )

            format_string = '(e)'
            sCell.value = STRING( value, FORMAT=format_string )

            formula = body[15:*]

            IF N_ELEMENTS( aCells ) LE 0 THEN aCells = [ sCell ] ELSE $
            aCells = [ aCells, sCell ]
            
            IF KEYWORD_SET( debug ) THEN $
             print, $
             FORMAT='("(FORMULA): [",I7,",", I7,"]", e, " - fmt ", I3)',$
             sCell.row, sCell.column, value, sCell.format

         END 

         'A'X: BEGIN
                    ; COLW2 - column width window 2

            IF KEYWORD_SET( debug ) THEN $
             print, '(COLW2): ignored'

         END 

         'D'X: BEGIN
                    ; INTEGER - integer cell

                    ; Byte Number          Byte Description 
            
                    ; 0                    format
                    ; 1-2                  column 
                    ; 3-4                  row 
                    ; 5-6                  integer value 

            sCell = SKEL_CELL()

            sCell.format = body[0]
            sCell.column = read_b2i( body[1:2], /LITTLE_ENDIAN )
            sCell.row = read_b2i( body[3:4], /LITTLE_ENDIAN )
            sCell.type = 2b

            integer = read_b2i( body[5:6], /LITTLE_ENDIAN )

            format_bits = get_bits( sCell.format )
            format_type = get_long( format_bits[4:6] )
            format_code = STRTRIM( get_long( format_bits[0:3] ), 2 )
            ;;format_code = type2format( sCell.type )
            
            CASE format_type OF

               7: ; special type
               
               0: format_string = '(I'+format_code+')' ; fixed

               1: format_string = '(e'+format_code+')' ; sci notation

               2: format_string = '("$",I'+format_code+')' ; currency
            
               3: format_string = '(I'+format_code+'" %")' ; percent
               
               4: format_string = '(I'+format_code+')' ; comma
               
               ELSE: format_string = '(I'+format_code+')'

            ENDCASE 

            sCell.value = STRING( integer, FORMAT=format_string )

            IF N_ELEMENTS( aCells ) LE 0 THEN aCells = [ sCell ] ELSE $
            aCells = [ aCells, sCell ]
            
            IF KEYWORD_SET( debug ) THEN $
             print, $
             FORMAT='("(INT): [",I7,",", I7,"]", I7, " - fmt ", I3)',$
             sCell.row, sCell.column, integer, sCell.format

         END 

         'E'X: BEGIN
                    ; NUMBER - floating point number

                    ;Byte Number          Byte Description
            
                    ; 0                    format 
                    ; 1-2                  column 
                    ; 3-4                  row 
                    ; 5-12 value           (IEEE long real; 8087
                    ;      double-precision floating-point format)

            sCell = SKEL_CELL()
            
            sCell.format = body[0]
            sCell.column = read_b2i( body[1:2], /LITTLE_ENDIAN )
            sCell.row = read_b2i( body[3:4], /LITTLE_ENDIAN )
            sCell.type = 5b

            float = ieee_b2f( body[5:12], /LITTLE_ENDIAN )

            format_string = '(e)'
            sCell.value = STRING( float, FORMAT=format_string )

            IF N_ELEMENTS( aCells ) LE 0 THEN aCells = [ sCell ] ELSE $
            aCells = [ aCells, sCell ]
            
            IF KEYWORD_SET( debug ) THEN $
             print, $
             FORMAT='("(NUMBER): [",I7,",", I7,"]", e, " - fmt ", I3)',$
             sCell.row, sCell.column, float, sCell.format

         END 

         'F'X: BEGIN
                    ; LABEL - label cell

                    ;Byte Number        Byte Description

                    ; 0                  format
                    ; 1-2                column 
                    ; 3-4                row 
                    ; 5+                 NULL terminated ASCII string; 
                    ;                    240 bytes maximum 

            sCell = SKEL_CELL()

            sCell.format = body[0]
            sCell.column = read_b2i( body[1:2], /LITTLE_ENDIAN )
            sCell.row = read_b2i( body[3:4], /LITTLE_ENDIAN )
            sCell.type = 7b
            
            label = STRING( body[6:*] )

            ;;sCell.value = PTR_NEW( label )
            sCell.value = label

            IF N_ELEMENTS( aCells ) LE 0 THEN aCells = [ sCell ] ELSE $
            aCells = [ aCells, sCell ]
            
            IF KEYWORD_SET( debug ) THEN $
             print, $
             FORMAT='("(LABEL): [",I7,",",I7,"] ", A, " - fmt: ", I3 )', $
             sCell.row, sCell.column, label, sCell.format

         END 

         '24'X: BEGIN
                    ; PROTEC - global protection

                    ;Byte Number            Byte Description 
                    ; 0                      0 = global protection OFF 
                    ;                        1 = global protection ON 

            protection = body[0]
            
            IF KEYWORD_SET( debug ) THEN $
             print, '(PROTEC): ignored', protection

         END 

         '25'X: BEGIN
                    ; FOOTER - print footer string

                    ; Byte Number       Byte Description 
                    ; 0-242             NULL termination ASCII string 

            footer = STRTRIM( body[0:*], 2 )

            IF KEYWORD_SET( debug ) THEN $
             print, '(FOOTER): ignored ' + footer

         END 

         '26'X: BEGIN
                    ; HEADER - print header string

                    ; Byte Number       Byte Description 
                    ; 0-242             NULL termination ASCII string 

            header = STRTRIM( body[0:*], 2 )

            IF KEYWORD_SET( debug ) THEN $
             print, '(HEADER): ignored ' + header

         END

         '27'X: BEGIN
                    ; SETUP - print setup

                    ; Byte Number          Byte Description 
                    ; 0-40                 NULL terminated ASCII string 

            setup = STRTRIM( body[0:*], 2 )

            IF KEYWORD_SET( debug ) THEN $
             print, '(SETUP): ignored ' + setup

         END 

         '28'X: BEGIN
                    ; MARGINS - print margins code

                    ; Byte Number             Byte Description 
                    ; 0-1                     left margin 
                    ; 2-3                     right margin 
                    ; 4-5                     page length 
                    ; 6-7                     top margin 
                    ; 8-9                     bottom margin 

            left_margin = read_b2i( body[0:1], /LITTLE_ENDIAN )
            right_margin = read_b2i( body[2:3], /LITTLE_ENDIAN )
            page_length = read_b2i( body[4:5], /LITTLE_ENDIAN )
            top_margin = read_b2i( body[6:7], /LITTLE_ENDIAN )
            bottom_margin = read_b2i( body[8:9], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             print, '(MARGINS): ignored '

         END

         '29'X: BEGIN
                    ; LABELFMT - label alignment

                    ; Byte Number          Byte Description 
            
                    ; 0                    27h = left 
                    ;                      22h = right 
                    ;                      5Eh = center 

            label_format = body[0]

            IF KEYWORD_SET( debug ) THEN $
             print, '(LABELFMT): ignored ' + STRTRIM( label_format, 2 )

         END 

         '2A'X: BEGIN
                    ; TITLES - print borders

                    ; Byte          Description 

                    ; 0-1     Row border;       starting column 
                    ; 2-3                       starting row 
                    ; 4-5                       ending column 
                    ; 6-7                       ending row 
                    ; 8-9     Column border;    starting column 
                    ; 10-11                     starting row 
                    ; 12-13                     ending column 
                    ; 14-15                     ending row 

            IF KEYWORD_SET( debug ) THEN $
             print, '(TITLES): ignored '

         END

         '2F'X: BEGIN
                    ; CALCCOUNT - iteration count
            
            iteration = body[0]

            IF KEYWORD_SET( debug ) THEN $
             print, '(CALCCOUNT): ignored '

         END 

         '31'X: BEGIN
                    ; CURSORW12 - cursor location

                    ; Byte Number         Byte Description 

                    ; 0                   1 = cursor in Window 1 
                    ;                     2 = cursor in Window 2 

            IF KEYWORD_SET( debug ) THEN $
             print, '(CURSORW12): ignored '

         END 

         '32'X: BEGIN
                    ; WINDOW - window record structure

            IF KEYWORD_SET( debug ) THEN $
             print, '(WINDOW): ignored '

         END
         
         ELSE: IF KEYWORD_SET( debug ) THEN print, '(UNKNOWN)'

      ENDCASE 

   ENDWHILE

   FREE_LUN, lun
   
   IF N_ELEMENTS( aCells ) LE 0 THEN BEGIN
      MESSAGE, 'No cells read', /CONT
      return, -1
   ENDIF

   IF KEYWORD_SET( return_rows ) THEN BEGIN

      aRows = get_rows( aCells )

      return, aRows

   ENDIF ELSE BEGIN

      num_row = MAX( aCells.row ) + 1
      num_col = MAX( aCells.column ) + 1

      data_sheet = MAKE_ARRAY( num_col, num_row, /STRING )
      format_sheet = MAKE_ARRAY( num_col, num_row, /STRING )

      FOR i=0, N_ELEMENTS( aCells ) - 1 DO BEGIN

         data_sheet[ aCells[i].column, aCells[i].row ] = $
          STRTRIM( aCells[i].value, 2 )

         format = type2format( aCells[i].type )

         format_sheet[ aCells[i].column, aCells[i].row ] = format

      ENDFOR

      return, data_sheet

   ENDELSE
 
   return, -1       ; should never get here

END 

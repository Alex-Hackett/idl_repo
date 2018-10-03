;+
; $Id: read_biff5.pro,v 1.1 1999/08/18 17:30:08 mccannwj Exp $
;
; NAME:
;     READ_BIFF5
;
; PURPOSE:
;     Read a BIFF (Binary Interchange Format File) version 5
;     spreadsheet file.
;
; CATEGORY:
;     Spreadsheet
;
; CALLING SEQUENCE:
;     result = READ_BIFF5( filename [, /ROWS, /DEBUG] )
; 
; INPUTS:
;     filename - (STRING) name of file to be read.
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     ROWS - (BOOLEAN) return vector of row structures.
;     DEBUG - (BOOLEAN) show debug output.
;
; OUTPUTS:
;     result - (1D/2D ARRAY) spreadsheet.
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
;       Thu Jan 14 16:53:30 1999, William Jon McCann <mccannwj@acs10>
;
;		created.
;
;-

; _____________________________________________________________________________


FUNCTION skel_cell

   sCell = { XLSCELL, $
             row: 0L, $
             column: 0L, $
             value: '', $
             type: 0B, $
             format: 0L }

   return, sCell
END

; _____________________________________________________________________________

FUNCTION type_to_format, type

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

   return, '(' + format + '0)'

END

; _____________________________________________________________________________


FUNCTION read_b2l, bytes, ERROR = error, LITTLE_ENDIAN = swap, DEBUG = debug

   byte_array = bytes ; copy the input

   CASE N_ELEMENTS( byte_array ) OF
      
      2: BEGIN
         ; INT
         IF KEYWORD_SET( swap ) THEN byte_array = REVERSE( byte_array )

         number = FIX( byte_array, 0, 1 )
      END 

      4: BEGIN
         ; LONG
         number1 = FIX( byte_array[0:1], 0, 1 )
         number2 = FIX( byte_array[2:3], 0, 1 )

         number = LONG( [number1,number2], 0, 1 )

         IF KEYWORD_SET( swap ) THEN number = SWAP_ENDIAN( number )

      END 
      ELSE: BEGIN
         MESSAGE, "Unknown data type: wrong number of bytes.", /CONT
         number = [0]
      END 
   ENDCASE 
      
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


FUNCTION read_b2rk, bytes, ERROR = error, LITTLE_ENDIAN = swap, DEBUG = debug

   byte_array = bytes ; copy the input

   IF KEYWORD_SET( swap ) THEN byte_array = REVERSE( byte_array )

   rk_number = (LONG( byte_array, 0, 1 ))[0]

   IF (rk_number AND '02'X) GT 0 THEN BEGIN
                    ; INT
      number = LONG( ISHFT( rk_number, -2 ) )
   ENDIF ELSE BEGIN
                    ; IEEE
      number = (DOUBLE( [byte_array,0b,0b,0b,0b], 0, 1 ))[0]
   ENDELSE

   IF rk_number AND '01'XL THEN number = number / 100.0

   return, number
END 

; _____________________________________________________________________________


FUNCTION make_struct, aLabels, aValues, NAME = struct_name

   ; values assumed to be scalar strings

   labels = aLabels[ UNIQ( aLabels, SORT( aLabels ) ) ]
   values = STRTRIM( aValues[ UNIQ( aLabels, SORT( aLabels ) ) ], 2 )

   number = N_ELEMENTS( labels )

   format_string = '('+STRTRIM(number,2)+'("values[",I5,"]",:,"," ) )'
   str_list = STRING( INDGEN(number), FORMAT = format_string )

   IF N_ELEMENTS( struct_name ) LE 0 THEN struct_name = "ROW_STRUCT1"
   cmd = 'struct = CREATE_STRUCT( labels, ' + str_list + $
    ',NAME="' + struct_name + '")'

   result = EXECUTE( cmd )

   IF result EQ 1 THEN return, struct ELSE return, -1

END 

; _____________________________________________________________________________


FUNCTION get_nums, lun, number, FLOAT=float, DOUBLE=double, BYTE=byte, $
                   INT=int, LONG=long, SWAP=swap, ERROR=error

   IF N_ELEMENTS( number ) LE 0 THEN number = 1
   IF number LE 0 THEN BEGIN
      error = 1b
      return, -1
   ENDIF 

   IF KEYWORD_SET( float ) THEN type = 'FLOAT'
   IF KEYWORD_SET( double ) THEN type = 'DOUBLE'
   IF KEYWORD_SET( byte ) THEN type = 'BYTE'
   IF KEYWORD_SET( int ) THEN type = 'INT'
   IF KEYWORD_SET( long ) THEN type = 'LONG'

   CASE type OF 
      'FLOAT': array = FLTARR( number )
      'DOUBLE': array = DBLARR( number )
      'BYTE': array = BYTARR( number )
      'INT': array = INTARR( number )
      'LONG': array = LONARR( number )
      ELSE: array = BYTARR( number )
   ENDCASE 

   IF NOT EOF( lun ) THEN BEGIN

      READU, lun, array 

   ENDIF ELSE BEGIN

      error = 1b
      return, [0]

   ENDELSE

   IF KEYWORD_SET( swap ) THEN array = SWAP_ENDIAN( TEMPORARY(array) )

   error = 0b
   return, array
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

         ;;FOR j=0,N_ELEMENTS(cols)-1 DO PRINTF, -2, FORMAT='(I,"->",A)',cols[j],vals[j]

         names = 'COLUMN'+STRING( cols, FORMAT='(I5.5)' )

         sRow = make_struct( names, vals, NAME=struct_name )

         IF N_TAGS( sRow ) LE 0 THEN MESSAGE, "Couldn't create row structure"

         IF N_ELEMENTS( aRows ) LE 0 THEN aRows = [ sRow ] ELSE $
          aRows = [ aRows, sRow ]

      ENDIF ELSE BEGIN

         sRow = make_struct( 'COLUMN'+STRING( INDGEN( num_cols ), $
                                              FORMAT='(I5.5)' ), $
                                              STRARR( num_cols ), $
                           NAME=struct_name )

         IF N_TAGS( sRow ) LE 0 THEN MESSAGE, "Couldn't create row structure"

         IF N_ELEMENTS( aRows ) LE 0 THEN aRows = [ sRow ] ELSE $
          aRows = [ aRows, sRow ]
         
      ENDELSE

   ENDFOR 

   return, aRows
END 

; _____________________________________________________________________________


FUNCTION decode_unicode, byte_array, NO_LENGTH = no_len, DEBUG = debug

   IF NOT KEYWORD_SET( no_len ) THEN BEGIN
                    ; Count of characters
      cch = read_b2l( byte_array[0:1], /LITTLE_ENDIAN )
      offset = 2
   ENDIF ELSE offset = 0

                    ; option flags
   grbit = byte_array[offset]

   IF grbit AND '01'XB THEN BEGIN
                    ; 2 byte characters

                    ; for now, ignore the high bytes
      sbytes = byte_array[offset+1:*]
      even_ind = WHERE( (INDGEN( N_ELEMENTS( sbytes ) ) $
                         MOD 2 ) EQ 0, ecount )
      IF ecount GT 0 THEN BEGIN
         bytes = sbytes[ even_ind ]
         string = STRING( bytes )
      ENDIF ELSE string = 'UNICODE'

   ENDIF ELSE BEGIN
                    ; 1 byte characters
      string = STRING( byte_array[offset+1:*] )
   ENDELSE

   return, string
END 

; _____________________________________________________________________________


FUNCTION read_biff5, filename, format_sheet, DEBUG = debug, ROWS = return_rows

   path = FINDFILE( filename, COUNT=nfiles )

   IF (nfiles LE 0) OR (filename EQ '') THEN BEGIN
      MESSAGE, "Cannot find file: '" + filename + "'", /CONT
      return, -1
   ENDIF 

   OPENR, lun, path[0], /GET_LUN, ERROR = open_error

   IF open_error NE 0 THEN BEGIN
      MESSAGE, "error opening BIFF5 file: '" + path[0] + "'", /CONT
      return, -1
   ENDIF

   bytes = get_nums( lun, 2, /BYTE, /SWAP, ERROR = read_error )
   bof_code = FIX( REVERSE(bytes), 0, 1 )

   IF bof_code[0] EQ '09'X THEN BEGIN
                    ; This is an Excel v2.1 file
      MESSAGE, "Excel v2.1 file format not supported.", /CONT
      return, -1
      
   ENDIF

   REPEAT BEGIN
                    ; Skip junk at beginning of file

      bytes = get_nums( lun, 2, /BYTE, /SWAP, ERROR = read_error )

      IF read_error NE 0 THEN BEGIN
         MESSAGE, "error reading BIFF5 file: '" + path[0] + "'", /CONT
         return, -1
      ENDIF

      IF KEYWORD_SET( debug ) THEN PRINTF, -2, bytes, FORMAT="(2(Z))"
      bof_code = FIX( REVERSE(bytes), 0, 1 )

      IF N_ELEMENTS( aBegin ) LE 0 THEN aBegin = [bytes] $
      ELSE aBegin = [aBegin, bytes]

   ENDREP UNTIL ( (bof_code[0] EQ 2057) OR EOF(lun) )

   bof_length = get_nums( lun, 1, /INT, /SWAP, ERROR = read_error )
   IF read_error NE 0 THEN BEGIN
      MESSAGE, "error reading BIFF5 file: '" + path[0] + "'", /CONT
      return, -1
   ENDIF

   IF KEYWORD_SET( debug ) THEN $
    PRINTF, -2, FORMAT='(I7," code: ",Z4.4,"h ", I, " bytes ", $)', $
    0, bof_code[0], bof_length[0]

                    ; get the begin of file record body
   bof_body = get_nums( lun, bof_length[0], /BYTE, ERROR = read_error )
   IF read_error NE 0 THEN BEGIN
      MESSAGE, "error reading BIFF5 file: '" + path[0] + "'", /CONT
      return, -1
   ENDIF

   stream_version = read_b2l( bof_body[0:1], /LITTLE_ENDIAN )
   stream_type = read_b2l( bof_body[2:3], /LITTLE_ENDIAN )

   CASE stream_version OF
      '0600'X: BEGIN
         biff8_type = 1
         biff7_type = 0
      END 
      '0500'X: BEGIN
         biff7_type = 1 ; or BIFF5
         biff8_type = 0
      END 
      ELSE: BEGIN
         biff7_type = 1
         biff8_type = 0
      END 
   ENDCASE 

   IF KEYWORD_SET( debug ) THEN $
    PRINTF, -2, FORMAT='("(BOF): version:",Z4.4,"   type:", Z4.4)',$
    stream_version, stream_type

   current_byte_offset = LONG( bof_length + 4 )

   number_of_streams = 0
   stream_number = 1  ; One BOF has been seen
   done_flag = 0
   WHILE( (NOT EOF(lun)) AND (done_flag NE 1) ) DO BEGIN
      
                    ; get next record header
      header = get_nums( lun, 2, /INT, /SWAP, ERROR = read_error )
      IF read_error NE 0 THEN BEGIN
         MESSAGE, "error reading BIFF5 file: '" + path[0] + "'", /CONT
         return, -1
      ENDIF

      code = header[0]
      length = header[1] ; in bytes

      IF KEYWORD_SET( debug ) THEN $
       PRINTF, -2, FORMAT='(I7," code: ",Z4.4,"h ", I, " bytes ", $)', $
       current_byte_offset, code, length

      current_byte_offset = current_byte_offset + length + 4

      IF (length GT 0) AND ( NOT EOF(lun) ) THEN BEGIN
                    ; get next record body
         body = BYTARR( length )
         READU, lun, body

      ENDIF ELSE body = 0

      CASE code OF

                    ; _______________________________________________
         
                    ; Stuff that occurs many times per stream (sheet)
                    ; _______________________________________________

         '204'X: BEGIN
                    ; LABEL - label cell

                    ;Byte Number     Byte Description
                    ;0-1             Row
                    ;2-3             Column
                    ;4-5             index to the XF record
                    ;6-7             Length of string
                    ;8-263           ASCII string, 0 to 255 bytes long

            sCell = SKEL_CELL()

            sCell.row = read_b2l( body[0:1], /LITTLE_ENDIAN )
            sCell.column = read_b2l( body[2:3], /LITTLE_ENDIAN )
            ;;sCell.format = read_b2l( body[4:5], /LITTLE_ENDIAN )
            sCell.type = 7b
            
            IF biff8_type EQ 1 THEN $
             label = decode_unicode( body[8:*], /NO_LEN ) $
            ELSE label = STRING( body[8:*] )

            sCell.value = label

            IF N_ELEMENTS( aCells ) LE 0 THEN aCells = [ sCell ] ELSE $
            aCells = [ aCells, sCell ]
            
            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, $
             FORMAT='("(LABEL): [",I7,",",I7,"] ", A)', $
             sCell.row, sCell.column, label

         END

         'FD'X: BEGIN
                    ; LABELSST - cell value, string constant/SST

            sCell = SKEL_CELL()

            sCell.row = read_b2l( body[0:1], /LITTLE_ENDIAN )
            sCell.column = read_b2l( body[2:3], /LITTLE_ENDIAN )
            sCell.type = 7b

            sst_xf_index = read_b2l( body[4:5], /LITTLE_ENDIAN )

            sst_rec_index = read_b2l( body[6:9], /LITTLE_ENDIAN )

            label = aSST[ sst_rec_index ]
            sCell.value = label

            IF N_ELEMENTS( aCells ) LE 0 THEN aCells = [ sCell ] ELSE $
            aCells = [ aCells, sCell ]

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, $
             FORMAT='("(LABELSST): [",I7,",",I7,"] ", A)', $
             sCell.row, sCell.column, label

         END 

         '27E'X: BEGIN
                    ; RK - cell value, RK number

            sCell = SKEL_CELL()

            sCell.row = read_b2l( body[0:1], /LITTLE_ENDIAN )
            sCell.column = read_b2l( body[2:3], /LITTLE_ENDIAN )
            ;;sCell.format = read_b2l( body[4:5], /LITTLE_ENDIAN )

            rk_val = read_b2rk( body[6:9], /LITTLE_ENDIAN )
            
            decimal = rk_val - LONG( rk_val )

            IF decimal EQ 0 THEN BEGIN
               rk_val = LONG( rk_val )
               sCell.type = 3b
            ENDIF ELSE sCell.type = 5b

            sCell.value = STRTRIM( rk_val, 2 )

            IF N_ELEMENTS( aCells ) LE 0 THEN aCells = [ sCell ] ELSE $
            aCells = [ aCells, sCell ]

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, $
             FORMAT='("(RK): [",I7,",", I7,"] ", A)',$
             sCell.row, sCell.column, sCell.value
            
         END 


         'BD'X: BEGIN
                    ; MULTRK - multiple RK cells

            row = read_b2l( body[0:1], /LITTLE_ENDIAN )
            column_first = read_b2l( body[2:3], /LITTLE_ENDIAN )
            
            last = N_ELEMENTS( body ) - 1
            column_last = read_b2l( body[last-1:last], /LITTLE_ENDIAN )
            
            number_structs = column_last - column_first + 1

            FOR i=0L, number_structs-1 DO BEGIN

               sCell = SKEL_CELL()

               sCell.row = row
               sCell.column = column_first + i

               offset = 4 + i * 6
               ;rk_fmt = read_b2l( body[offset:offset+1], /LITTLE_ENDIAN )
               rk_val = read_b2rk( body[offset+2:offset+5], /LITTLE_ENDIAN )

               decimal = rk_val - LONG( rk_val )
               
               IF decimal EQ 0 THEN BEGIN
                  rk_val = LONG( rk_val )
                  sCell.type = 3b
               ENDIF ELSE sCell.type = 5b

               sCell.value = STRTRIM( rk_val, 2 )
               
               IF N_ELEMENTS( aCells ) LE 0 THEN aCells = [ sCell ] ELSE $
                aCells = [ aCells, sCell ]

               IF KEYWORD_SET( debug ) THEN $
                PRINTF, -2, $
                FORMAT='(/,30X,"(MULTRK): [",I7,",", I3,"] ",A)',$
                sCell.row, sCell.column, sCell.value
            ENDFOR 


         END 

         'E0'X: BEGIN
                    ; XF - extended format

            IF biff8_type EQ 1 THEN BEGIN
               
               ifnt = read_b2l( body[0:1], /LITTLE_ENDIAN )
               ifmt = read_b2l( body[2:3], /LITTLE_ENDIAN )
               
               info1 = read_b2l( body[4:5], /LITTLE_ENDIAN )
               info2 = read_b2l( body[6:7], /LITTLE_ENDIAN )
               info3 = read_b2l( body[8:9], /LITTLE_ENDIAN )
               info4 = read_b2l( body[10:11], /LITTLE_ENDIAN )
               info5 = read_b2l( body[12:13], /LITTLE_ENDIAN )
               info6 = read_b2l( body[14:17], /LITTLE_ENDIAN )
               info7 = read_b2l( body[18:19], /LITTLE_ENDIAN )

               IF info1 AND '0004'X THEN style_xf = 1 ELSE style_xf = 0

            ENDIF ELSE BEGIN
               ifnt = read_b2l( body[0:1], /LITTLE_ENDIAN )
               ifmt = read_b2l( body[2:3], /LITTLE_ENDIAN )
               
               info1 = read_b2l( body[4:5], /LITTLE_ENDIAN )
               info2 = read_b2l( body[6:7], /LITTLE_ENDIAN )
               info3 = read_b2l( body[8:9], /LITTLE_ENDIAN )
               info4 = read_b2l( body[10:11], /LITTLE_ENDIAN )
               info5 = read_b2l( body[12:13], /LITTLE_ENDIAN )
               info6 = read_b2l( body[14:15], /LITTLE_ENDIAN )

            ENDELSE 

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(XF): ignored ",I,2X,Z)', ifnt, ifmt

         END 


         '200'X: BEGIN
                    ; DIMENSIONS - specify dimensions of worksheet

            IF (biff8_type) EQ 1 THEN BEGIN
               first_row = read_b2l( body[0:3], /LITTLE_ENDIAN )
               last_row = read_b2l( body[4:7], /LITTLE_ENDIAN ) - 1
               first_col = read_b2l( body[8:9], /LITTLE_ENDIAN )
               last_col = read_b2l( body[10:11], /LITTLE_ENDIAN ) - 1
            ENDIF ELSE BEGIN
               first_row = read_b2l( body[0:1], /LITTLE_ENDIAN )
               last_row = read_b2l( body[2:3], /LITTLE_ENDIAN ) - 1
               first_col = read_b2l( body[4:5], /LITTLE_ENDIAN )
               last_col = read_b2l( body[6:7], /LITTLE_ENDIAN ) - 1
            ENDELSE 

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(DIMENSIONS): [",I7,":",I7,",",I4,":",I4,"]")',$
             first_row, last_row, first_col, last_col

         END 

         '201'X: BEGIN
                    ; BLANK - empty cell

                    ;Byte Number     Byte Description
                    ;0-1             Row
                    ;2-3             Column
                    ;4-5             Index to the XF record
            
            sCell = SKEL_CELL()

            sCell.row = read_b2l( body[0:1], /LITTLE_ENDIAN )
            sCell.column = read_b2l( body[2:3], /LITTLE_ENDIAN )
            ;;sCell.format = read_b2l( body[4:5], /LITTLE_ENDIAN )
            sCell.type = 7b

            sCell.value = ''

            IF N_ELEMENTS( aCells ) LE 0 THEN aCells = [ sCell ] ELSE $
            aCells = [ aCells, sCell ]
            
            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(BLANK): [",I7,",", I7,"]")',$
             sCell.row, sCell.column

         END 

         '203'X: BEGIN
                    ; NUMBER - fixed floating point cell

                    ;Byte Number     Byte Description
                    ;0-1             Row
                    ;2-3             Column
                    ;4-5             Index to the XF record
                    ;6-13            Floating point number value (IEEE format)

            sCell = SKEL_CELL()

            sCell.row = read_b2l( body[0:1], /LITTLE_ENDIAN )
            sCell.column = read_b2l( body[2:3], /LITTLE_ENDIAN )
            ;;sCell.format = read_b2l( body[4:5], /LITTLE_ENDIAN )
            sCell.type = 5b

            floating = ieee_b2f( body[6:13], /LITTLE_ENDIAN )

            IF (floating LT (2E9)) AND (floating GT (-2E9)) THEN BEGIN
               decimal = floating - LONG( floating )

               IF decimal EQ 0D THEN BEGIN
                  sCell.type = 3b
                  format_string = '(I)'
               ENDIF ELSE BEGIN
                  sCell.type = 5b
                  format_string = '(e)'
               ENDELSE

            ENDIF ELSE BEGIN
               sCell.type = 5b
               format_string = '(e)'
            ENDELSE 

            sCell.value = STRING( floating, FORMAT=format_string )

            IF N_ELEMENTS( aCells ) LE 0 THEN aCells = [ sCell ] ELSE $
            aCells = [ aCells, sCell ]
            
            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, $
             FORMAT='("(NUMBER): [",I7,",", I7,"]", A)', $
             sCell.row, sCell.column, sCell.value

         END             

         '7D'X: BEGIN
                    ; COLINFO - column formatting information

            first_column = read_b2l( body[0:1], /LITTLE_ENDIAN )
            last_column = read_b2l( body[2:3], /LITTLE_ENDIAN )
            column_width = read_b2l( body[4:5], /LITTLE_ENDIAN )
            format_index = read_b2l( body[6:7], /LITTLE_ENDIAN )
            options = read_b2l( body[8:9], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, $
             FORMAT='("(COLINFO): [",I4," - ",I4,"] ", F, 2X, Z2.2)', $
             first_column, last_column, column_width / 256.0, format_index
            
         END 

         '208'X: BEGIN
                    ; ROW - specify a spreadsheet row
            
                    ;Byte     Byte Description               Contents (hex)
                    ;0-1        Row number
                    ;2-3        First defined column in the row
                    ;4-5        Last defined column in the row plus 1
                    ;6-7        Row height
                    ;8-9        RESERVED                                0
                    ;10-11      RESERVED
                    ;12-13      Option flags
                    ;14-15      index to XF record
            
            row_number = read_b2l( body[0:1], /LITTLE_ENDIAN )

            first_col = read_b2l( body[2:3], /LITTLE_ENDIAN )
            last_col = read_b2l( body[4:5], /LITTLE_ENDIAN )

            row_height = read_b2l( body[6:7], /LITTLE_ENDIAN )

            row_option_flags = read_b2l( body[12:13], /LITTLE_ENDIAN )
            
            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(ROW): [",I7,",",I7," - ",I7,"] ", F8.4)', $
             row_number, first_col, last_col, row_height / 20.0

         END 

         '31'X: BEGIN
                    ; FONT

            font_height = (read_b2l( body[0:1], /LITTLE_ENDIAN )) / 20.0
            font_attr = read_b2l( body[2:3], /LITTLE_ENDIAN )

            IF biff8_type EQ 1 THEN $
             font_name = decode_unicode( body[15:*], /NO_LEN ) $
            ELSE font_name = STRING( body[15:*] )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(FONT): ignored ",A,2X,I3)', $
             font_name, font_height
         END

         '41E'X: BEGIN
                    ; FORMAT
            format_index_code = read_b2l( body[0:1], /LITTLE_ENDIAN )

            IF biff8_type EQ 1 THEN $
             format_string = decode_unicode( body[2:*] ) $
            ELSE format_string = STRING( body[3:*] )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, '(FORMAT): ignored '+format_string

         END 

         '85'X: BEGIN
                    ; BOUNDSHEET
            
            sheet_stream_pos = read_b2l( body[0:3], /LITTLE_ENDIAN )
            sheet_option_flags = read_b2l( body[4:5], /LITTLE_ENDIAN )
            
            IF (biff8_type) EQ 1 THEN sheet_name = STRING( body[8:*] ) $
            ELSE IF (biff7_type) EQ 1 THEN sheet_name = STRING( body[7:*] )

            

            number_of_streams = number_of_streams + 1
            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(BOUNDSHEET): ",I6,2X,A,2X,Z4.4,"h")', $
             sheet_stream_pos, sheet_name, sheet_option_flags
            
         END
                    ; __________________________________________

                    ; Stuff that occurs once per stream (sheet)
                    ; __________________________________________

         '809'X: BEGIN
                    ; BOF - BIFF5/BIFF7/BIFF8
            stream_number = stream_number + 1
            number_of_streams = number_of_streams - 1 > 0

            stream_version = read_b2l( body[0:1], /LITTLE_ENDIAN )
            stream_type = read_b2l( body[2:3], /LITTLE_ENDIAN )

                    ; It appears that you cannot trust biff version
                    ; numbers after the first stream
            CASE stream_version OF
               '0600'X: BEGIN
                  ;biff8_type = 1
                  ;biff7_type = 0
               END 
               '0500'X: BEGIN
                  ;biff7_type = 1 ; or BIFF5
                  ;biff8_type = 0
               END 
               ELSE:
            ENDCASE 

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(BOF): version: ",Z4.4," type: ",Z4.4)', $
             stream_version, stream_type

         END 

         '0C'X: BEGIN
                    ; CALCCOUNT - specify iteration count

            cIter = read_b2l( body[0:1], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(CALCCOUNT): ignored ",I3)', $
             cIter
            
         END 

         '0D'X: BEGIN
                    ; CALCMODE - specify the calculation mode

            fAutoRecalc = read_b2l( body[0:1], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(CALCMODE): ignored ",I2)', $
             fAutoRecalc

         END

         '0E'X: BEGIN
                    ; PRECISION - specify precision of calculation for
                    ; document

            fFullPrec = read_b2l( body[0:1], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(PRECISION): ignored ",I2)', $
             fFullPrec
            
         END 
         
         '0F'X: BEGIN
                    ; REFMODE - specify location reference mode

            fRefA1 = read_b2l( body[0:1], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(REFMODE): ignored ",I2)', fRefA1

         END 

         '10'X: BEGIN
                    ; DELTA - maximum change for an iterative model

            numDelta = ieee_b2f( body[0:7], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(DELTA): ignored ",F10.4)', $
             numDelta

         END 

         '11'X: BEGIN
                    ; ITERATION - specify whether iteration is on

            fIter = read_b2l( body[0:1], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(ITERATION): ignored ",I2)', $
             fIter

         END 

         '12'X: BEGIN
                    ; PROTECT
            fLock = read_b2l( body[0:1], /LITTLE_ENDIAN ) ; BOOLEAN

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(PROTECT): ignored ",I2)', $
             fLock

         END 

         '13'X: BEGIN
                    ; PASSWORD - password protection

            wPassword = read_b2l( body[0:1], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(PASSWORD): ignored", 2X, I2)', wPassword

         END 

         '14'X: BEGIN
                    ; HEADER - specify header string

            IF N_ELEMENTS( body ) GT 1 THEN BEGIN
               hlength = body[0]
               IF biff8_type EQ 1 THEN $
                header = decode_unicode( body ) $
               ELSE header = STRING( body[1:*] )
               
               IF KEYWORD_SET( debug ) THEN $
                PRINTF, -2, FORMAT='("(HEADER): ignored ",A)', header
            ENDIF
         END 
         
         '15'X: BEGIN
                    ; FOOTER - specify footer string
            IF N_ELEMENTS( body ) GT 1 THEN BEGIN
               flength = body[0]
               
               IF biff8_type EQ 1 THEN $
                footer = decode_unicode( body ) $
               ELSE footer = STRING( body[1:*] )
               
               IF KEYWORD_SET( debug ) THEN $
                PRINTF, -2, FORMAT='("(FOOTER): ignored ",A)', footer
            ENDIF 
         END 

         '19'X: BEGIN
                    ; WINDOW PROTECT - specify window protection

            fLockWn = read_b2l( body[0:1], /LITTLE_ENDIAN ) ; BOOLEAN

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(WINDOW PROTECT): ignored ",I2)', $
             fLockWn
            
         END 

         '1D'X: BEGIN
                    ; SELECTION - selected cells

            pnn = body[0]
            rwAct = read_b2l( body[1:2], /LITTLE_ENDIAN ) 
            colAct = read_b2l( body[3:4], /LITTLE_ENDIAN ) 
            irefAct = read_b2l( body[5:6], /LITTLE_ENDIAN ) 
            cref = read_b2l( body[7:8], /LITTLE_ENDIAN ) 

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(SELECTION): ignored ",I2,I,I,I,I)', $
             pnn, rwAct, colAct, irefAct, cref

         END 

         '22'X: BEGIN
                    ; 1904 - specify date system

            f1904 = read_b2l( body[0:1], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(1904): ignored ",I2)', f1904
            
         END 

         '26'X: BEGIN
                    ; LEFT MARGIN

            left_margin = ieee_b2f( body[0:7], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(LEFT MARGIN): ignored ",F10.4)', left_margin

         END 

         '27'X: BEGIN
                    ; RIGHT MARGIN

            right_margin = ieee_b2f( body[0:7], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(RIGHT MARGIN): ignored ",F10.4)', right_margin

         END 

         '28'X: BEGIN
                    ; TOP MARGIN

            top_margin = ieee_b2f( body[0:7], /LITTLE_ENDIAN )
            
            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(TOP MARGIN): ignored ",F10.4)', top_margin

         END 

         '29'X: BEGIN
                    ; BOTTOM MARGIN
            
            bottom_margin = ieee_b2f( body[0:7], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(BOTTOM MARGIN): ignored ",F10.4)', $
             bottom_margin

         END 

         '2A'X: BEGIN
                    ; PRINTHEADERS

            fPrintRwCol = read_b2l( body[0:1], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(PRINTHEADERS): ignored ",I2)', $
             fPrintRwCol
            
         END 

         '2B'X: BEGIN
                    ; PRINTGRIDLINES

            fPrintGrid = read_b2l( body[0:1], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(PRINTGRIDLINES): ignored ", I2)', $
             fPrintGrid

         END 

         '3D'X: BEGIN
                    ; WINDOW1 - basic window information
                    
            xWn = read_b2l( body[0:1], /LITTLE_ENDIAN )
            yWn = read_b2l( body[2:3], /LITTLE_ENDIAN )
            dxWn = read_b2l( body[4:5], /LITTLE_ENDIAN )
            dyWn = read_b2l( body[6:7], /LITTLE_ENDIAN )
            win_options = read_b2l( body[8:9], /LITTLE_ENDIAN )
            itabCur = read_b2l( body[10:11], /LITTLE_ENDIAN )
            itabFirst = read_b2l( body[12:13], /LITTLE_ENDIAN )
            ctabSel = read_b2l( body[14:15], /LITTLE_ENDIAN )
            wTabRatio = read_b2l( body[16:17], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, $
             FORMAT='("(WINDOW1): ignored [",I5,":",I5,",",I5,":",I5,"]")', $
             xWn,dxWn,yWn,dyWn

         END 

         '4D'X: BEGIN
                    ; PLS - environment specific print setup

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, '(PLS): ignored '
            
         END 

         '55'X: BEGIN
                    ; DEFCOLWIDTH - default width for columns (characters)
            
            cchdefColWidth = read_b2l( body[0:1], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(DEFCOLWIDTH): ",I3)', cchdefColWidth
            
         END 

         '5C'X: BEGIN
                    ; WRITEACCESS

            IF biff8_type EQ 1 THEN $
             stName = decode_unicode( body ) $
            ELSE stName = STRING( body[1:*] )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(WRITEACCESS): ",A)', stName
         END 

         '5F'X: BEGIN
                    ;SAVERECALC - recalculate before save

            fSaveRecalc = read_b2l( body[0:1], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(SAVERECALC): ignored ", I2)', fSaveRecalc

         END 

         '40'X: BEGIN
                    ; BACKUP
            fBackupFile = read_b2l( body[0:1], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(BACKUP): ignored ",I2)', fBackupFile
            
         END 

         '41'X: BEGIN
                    ; PANE - Windows pain information

            x = read_b2l( body[0:1], /LITTLE_ENDIAN )
            y = read_b2l( body[2:3], /LITTLE_ENDIAN )
            
            rwTop = read_b2l( body[4:5], /LITTLE_ENDIAN )
            colLeft = read_b2l( body[6:7], /LITTLE_ENDIAN )
            pnnAct = read_b2l( body[8:9], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(PANE): ignored ",I,I,I,I,I)', $
             x,y,rwTop,colLeft,pnnAct
            
         END

         '42'X: BEGIN
            ; CODEPAGE - default code page

            codepage = read_b2l( body[0:1], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(CODEPAGE): ignored ",Z)', codepage
            
         END 

         '80'X: BEGIN
                    ; GUTS - size of row and column gutters

            dxRwGut = read_b2l( body[0:1], /LITTLE_ENDIAN )
            dyColGut = read_b2l( body[2:3], /LITTLE_ENDIAN )
            iLevelRwMac = read_b2l( body[4:5], /LITTLE_ENDIAN )
            iLevelColMac = read_b2l( body[6:7], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(GUTS): ignored ",I4,I4,I4,I4)', $
             dxRwGut, iLevelRwMac, dyColGut, iLevelColMac

         END

         '81'X: BEGIN
                    ; WSBOOL - additional workspace information
            wsBool = read_b2l( body[0:1], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(WSBOOL): ignored ", I)', wsBool

         END 
         
         '82'X: BEGIN
                    ; GRIDSET - state change of gridlines option

            fGridSet = read_b2l( body[0:1], /LITTLE_ENDIAN )
            
            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(GRIDSET): ignored ",I2)', fGridSet

         END 

         '8C'X: BEGIN
                    ; COUNTRY

            iCountryDef = read_b2l( body[0:1], /LITTLE_ENDIAN )
            iCountryWinIni = read_b2l( body[2:3], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(COUNTRY): ignored ", I3, 2X, I3)', $
             iCountryDef, iCountryWinIni

         END

         '83'X: BEGIN
                    ; HCENTER - center between horizontal margins

            fHCenter = read_b2l( body[0:1], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(HCENTER): ignored ", I2)', fHCenter

         END 

         '84'X: BEGIN
                    ; VCENTER - center between vertical margins

            fVCenter = read_b2l( body[0:1], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(VCENTER): ignored ", I2)', fVCenter

         END 

         '8D'X: BEGIN
                    ; HIDEOBJ - object display options
            fHideObj = read_b2l( body[0:1], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(HIDEOBJ): ignored ",I2)', fHideObj
            
         END

         '92'X: BEGIN
                    ; PALETTE - color palette definition
            
            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, '(PALETTE): ignored'
            
         END

         '9C'X: BEGIN
            ; FNGROUPCOUNT - built-in function group count
            
            cFrGroup = read_b2l( body[0:1], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(FNGROUPCOUNT): ignored", 2X, I2)', cFrGroup

         END 

         'A1'X: BEGIN
                    ; SETUP - print setup
            iPaperSize = read_b2l( body[0:1], /LITTLE_ENDIAN )
            iScale = read_b2l( body[2:3], /LITTLE_ENDIAN )
            iPageStart = read_b2l( body[4:5], /LITTLE_ENDIAN )
            iFitWidth = read_b2l( body[6:7], /LITTLE_ENDIAN )
            iFitHeight = read_b2l( body[8:9], /LITTLE_ENDIAN )
            options = read_b2l( body[10:11], /LITTLE_ENDIAN )
            iRes = read_b2l( body[12:13], /LITTLE_ENDIAN )
            iVRes = read_b2l( body[14:15], /LITTLE_ENDIAN )
            numHdr = ieee_b2f( body[16:23], /LITTLE_ENDIAN )
            numFtr = ieee_b2f( body[24:31], /LITTLE_ENDIAN )
            iCopies = read_b2l( body[32:33], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(SETUP): ignored ",I,I,I,I,I,I,I,I,F,F,I)', $
             iPaperSize, iScale, iPageStart, iFitWidth, iFitHeight, options,$
             iRes, iVRes, numHdr, numFtr, iCopies

         END

         'AB'X: BEGIN
                    ; GCW - Global column width flags
            
            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, '(GCW): ignored'
            
         END
         
         'C1'X: BEGIN
                    ; MMS: ADDMENU/DELMENU record group count
            caitm = body[0]
            cditm = body[1]

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(MMS: ADDMENU/DELMENU): ignored ",I2,2X,I2)',$
             caitm, cditm
            
         END 

         'DA'X: BEGIN
                    ; BOOKBOOL - workbook option flag

            fNoSaveSupp = read_b2l( body[0:1], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(BOOKBOOL): ignored ",I2)', fNoSaveSupp
            
         END

         'D7'X: BEGIN
                    ; DBCELL - stream offsets
            
            dtRtrw = read_b2l( body[0:3], /LITTLE_ENDIAN )

            index_array = body[4:*]
            num_ints = N_ELEMENTS( index_array ) / 2 > 1
            
            FOR i=0,num_ints-1 DO BEGIN
               offset = 4 + i*2
               int = read_b2l( body[offset:offset+1], /LITTLE_ENDIAN )

               IF N_ELEMENTS( aDBCell ) LE 0 THEN aDBCell = [int] $
               ELSE aDBCell = [aDBCell,int]

            ENDFOR

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(DBCELL): ignored ",I)', dtRtrw
            ;;PRINTF, -2, aDBCell
         END

         'E1'X: BEGIN
                    ; INTERFACEHDR - beginning of user interface
                    ; records
            
            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, '(INTERFACEHDR): ignored'
            
         END

         'E2'X: BEGIN
                    ; INTERFACEEND - beginning of user interface
                    ; records
            
            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, '(INTERFACEEND): ignored'
            
         END

         '13D'X: BEGIN
                    ; TABID

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, '(TABID): ignored ', body

         END 

         '161'X: BEGIN
                    ; DSF - double stream file
            fDSF = read_b2l( body[0:1], /LITTLE_ENDIAN )
            
            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(DSF): ignored",2X, I2)', fDSF
         END 
         
         '1AF'X: BEGIN
                    ; PROT4REV

            fRevLock = read_b2l( body[0:1], /LITTLE_ENDIAN )
            
            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(PROT4REV): ignored",2X, I2)', fRevLock

         END 

         '1BC'X: BEGIN
                    ; PROT4REVPASS

            wRevPass = read_b2l( body[0:1], /LITTLE_ENDIAN )
            
            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(PROT4REVPASS): ignored",2X, I2)', wRevPass

         END 

         '1B7'X: BEGIN
                    ; REFRESHALL - refresh flag
            
            fRefreshAll = read_b2l( body[0:1], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(REFRESHALL): ignored ",I2)', fRefreshAll
            
         END

         '20B'X: BEGIN
                    ; INDEX - index record

            IF biff8_type EQ 1 THEN BEGIN

               first_row = read_b2l( body[4:7], /LITTLE_ENDIAN )
               last_row = read_b2l( body[8:11], /LITTLE_ENDIAN ) - 1

               IF N_ELEMENTS( body ) GT 16 THEN BEGIN
                  index_array = body[16:*]
                  num_longs = N_ELEMENTS( index_array ) / 4

                  FOR na=0,num_longs-1 DO BEGIN
                     offset = 16 + na*4
                     long = read_b2l( body[offset:offset+3], /LITTLE_ENDIAN )
                     IF N_ELEMENTS( aOffsets ) LE 0 THEN aOffsets = [long] $
                     ELSE aOffsets = [aOffsets,long]
                  ENDFOR
               ENDIF 

            ENDIF ELSE BEGIN

               first_row = read_b2l( body[4:5], /LITTLE_ENDIAN )
               last_row = read_b2l( body[6:7], /LITTLE_ENDIAN ) - 1

               IF N_ELEMENTS( body ) GT 12 THEN BEGIN
                  index_array = body[12:*]
                  num_longs = N_ELEMENTS( index_array ) / 4
                  
                  FOR na=0, num_longs-1 DO BEGIN
                     offset = 12 + na*4
                     long = read_b2l( body[offset:offset+3], /LITTLE_ENDIAN )
                     IF N_ELEMENTS( aOffsets ) LE 0 THEN aOffsets = [long] $
                     ELSE aOffsets = [aOffsets,long]
                  ENDFOR
                  
               ENDIF 
            ENDELSE 

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(INDEX): [",I," - ",I,"]")', $
             first_row, last_row
            ;;PRINTF, -2, aOffsets
         END

         '225'X: BEGIN
                    ; DEFAULTROWHEIGHT - default height for rows (points)
            
            miyRw = read_b2l( body[2:3], /LITTLE_ENDIAN )

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(DEFAULTROWHEIGHT): ", F10.4)', $
             miyRw / 20.0
            
         END 

         '23E'X: BEGIN
                    ; WINDOW2

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, '(WINDOW2): ignored'

         END 

         '293'X: BEGIN
                    ; STYLE - style information

            index = read_b2l( body[0:1], /LITTLE_ENDIAN )

            ixfe = index AND 'FFF'X

            IF index AND 'FFFF8000'X THEN BEGIN
                    ; builtin
               builtin = 1

               istyBuiltIn = body[2]

               iLevel = body[3]
            ENDIF ELSE BEGIN
                    ; user def
               builtin = 0

            ENDELSE 

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(STYLE): ignored ", I, 2X, "builtin:",I2)', $
             ixfe, builtin
            
         END

         'FC'X: BEGIN
                    ; SST - shared string table

            cstTotal = read_b2l( body[0:3], /LITTLE_ENDIAN )
            cstUnique = read_b2l( body[4:7], /LITTLE_ENDIAN )

            IF N_ELEMENTS( aSST ) GT 0 THEN junk = TEMPORARY( aSST ) ; undef aSST 
            offset = 8
            FOR nus=0L, cstUnique-1 DO BEGIN
               
               num_chars = read_b2l( body[offset:offset+1], /LITTLE_ENDIAN )
               options = body[offset+2]
               
               IF options AND '01'XB THEN BEGIN
                  string = 'UNICODE'
               ENDIF ELSE BEGIN
                  string = STRING( body[offset+3:offset+3+num_chars-1] )
               ENDELSE 

               IF N_ELEMENTS( aSST ) LE 0 THEN aSST = [string] $
               ELSE aSST = [aSST,string]

               offset = offset + 3 + num_chars
            ENDFOR 

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, FORMAT='("(SST): ",I3,2X,I3)', $
             cstTotal, cstUnique

         END 

         'FF'X: BEGIN
                    ; EXTSST - extended shared string table

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, '(EXTSST): '
            
         END

         '0A'X: BEGIN
                    ; EOF
            stream_number = stream_number - 1 > 0
            IF (stream_number EQ 0) AND (number_of_streams EQ 0) THEN $
             done_flag = 1

            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, '(EOF): '

         END

         ELSE: BEGIN
            IF KEYWORD_SET( debug ) THEN $
             PRINTF, -2, '(Unknown)', body
         END

      ENDCASE 

   ENDWHILE 

                    ; Skip junk at end of file
   WHILE ( NOT EOF(lun) ) DO BEGIN
      bytes = get_nums( lun, 1, /BYTE, /SWAP )
      IF N_ELEMENTS( aEnd ) LE 0 THEN aEnd = [bytes] $
      ELSE aEnd = [aEnd, bytes]
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

         format = type_to_format( aCells[i].type )

         format_sheet[ aCells[i].column, aCells[i].row ] = format

      ENDFOR

      return, data_sheet

   ENDELSE

   return, -1       ; should never get here
END

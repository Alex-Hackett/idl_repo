;+
; $Id: smsize.pro,v 1.2 1999/05/14 13:55:54 mccannwj Exp $
;
; NAME:
;     SMSize
;
; PURPOSE:
;      compute the space / time requirements of an ACS SMS
;
; CATEGORY:
;     ACS/HST
;
; CALLING SEQUENCE:
;     result = smsize( filename [, /NON_STD, /TIME, /SDI] )
;
; INPUTS:
;     filename - SMS file name
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
;     none.
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;     SMS file must be a fixed format ASCII file of 71 columns unless
;     the /NON_STD keyword is set.
;
; PROCEDURES:
;     Various GSFC ASTROlib routines.
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;-

; _____________________________________________________________________________


FUNCTION parse_inparen, line, key

                    ; Look for key
   pos = -1
   pos = STRPOS( line, key )
   IF (pos EQ -1) THEN return, ''
   
                    ; get string from key to end of line
   line2 = STRMID( line, pos, STRLEN(line)-pos )

   pos = STRPOS( line2, '(' )
   IF (pos NE -1) THEN BEGIN 
                    ; If the key and paren is found
                    ; get string from open paren to end of line
      strval = STRMID( line2, pos + 1, $
                       strlen(line2)-pos )

      pos = STRPOS( strval, ')' )
                    ; set value to all text between the parens
      value = STRMID( strval, 0, pos )

      pos = STRPOS( value, "'" )+1
      rpos = RSTRPOS( value, "'" )
                    ; if the value has single quotes at the first and last
                    ; position then remove them
      IF ((pos NE -1) AND (rpos NE -1) AND (pos EQ (STRLEN(value)-rpos))) $
                                           THEN $
         value = STRMID( value, pos, rpos-pos )

      pos = STRPOS( value, '"' )+1
      rpos = RSTRPOS( value, '"' )
                    ; if the value has double quotes at the first and last
                    ; position then remove them
      IF ((pos NE -1) AND (rpos NE -1) AND (pos EQ (STRLEN(value)-rpos))) $
                                           THEN $
         value = STRMID( value, pos, rpos-pos )

   ENDIF ELSE value = '' ; if the key is not found

   return, value
END

; _____________________________________________________________________________


FUNCTION parse_smstime, line

   pos = -1
   key = 'SMSTIME'
   pos = STRPOS( line, key )
   IF (pos EQ -1) THEN return, ''

                    ; get string from key to end of line
   line2 = STRMID( line, pos, STRLEN(line)-pos )

   pos = STRPOS( line2, '=' )
   IF ( pos NE -1 ) THEN BEGIN
                    ; time SHOULD always be 21 char
                    ; YYYY.DOY:HH:MM:SS.mmm
                    ; YYYY - year; DOY - day of year
                    ; HH - hour; MM - minute; SS - second; mmm - fractional sec
      smstime = STRMID( line2, pos + 1, 21 )
   ENDIF ELSE smstime = ''

   return, smstime

END 

; _____________________________________________________________________________


FUNCTION get_new_line, line_num, LUN=lun, REC=rec_array

   line = ''

   IF N_ELEMENTS( rec_array ) GT 0 THEN BEGIN

      line = rec_array( line_num ) ; get a line from the file
      line = STRING( line ) ; convert the line to a string
      line_num = line_num + 1

   ENDIF ELSE BEGIN

;      PRINTF, -2, FORMAT='("READF ",$)'
      IF NOT EOF( lun ) THEN BEGIN
         line = ' '
         READF, lun, line
         line_num = line_num + 1
      ENDIF ELSE line = ''

   ENDELSE


   return, line
END 

; _____________________________________________________________________________


FUNCTION skel_size

   sSize = { SIZE_STRUCT, $
             size: -1L }

   return, sSize
END 

FUNCTION skel_time

   sTime = { TIME_STRUCT, $
             time: '00:00:00.000' }

   return, sTime
END 

FUNCTION skel_root

   sRoot = { ROOT_STRUCT, $
             progid: '', $
             obset: '' }

   return, sRoot
END 

; _____________________________________________________________________________


FUNCTION pix2bytes, n_pixels, DATA = data

   n_pixels = LONG( n_pixels )

   bits_per_pixel = 16
   
   bytes_per_bit = 1 / 8e

   bytes_per_pixel = bytes_per_bit * bits_per_pixel

   n_image_bytes = LONG( n_pixels * bytes_per_pixel )

   words_per_byte = 1 / 2e
   
   n_image_words = n_image_bytes * words_per_byte

   n_data_lines = 1 + ( ( LONG( n_image_words + 964 ) ) / 965 )

   n_data_bytes = LONG( n_data_lines * 1024 / words_per_byte )

   IF KEYWORD_SET( data ) THEN return, n_data_bytes

   return, n_image_bytes
END

; _____________________________________________________________________________

FUNCTION words2bytes, n_words

   n_words = LONG( n_words )

   bytes_per_word = 4e

   n_bytes = LONG( n_words * bytes_per_word )

   return, n_bytes
END 

; _____________________________________________________________________________


FUNCTION smsize, files, VERBOSE=verbose, NON_STD = non_std, PRINT = print,$
                 SDI = sdi, TIME = time, ROOT_NAMES = root_names

   ON_ERROR, 2

   wfc_xsize = 4146l
   wfc_ysize = 4136l

   hrc_xsize = 1064l
   hrc_ysize = 1044l

   sbc_xsize = 1024l
   sbc_ysize = 1024l

   targacq_xsize = 200l
   targacq_ysize = 200l
   
                    ; -------------------------------------
                    ; Check input
                    ; -------------------------------------

   IF N_ELEMENTS( verbose ) LE 0 THEN verbose = 0

   IF N_ELEMENTS( files ) LE 0 THEN BEGIN
      MESSAGE, 'file not specified', /INFO
      return, -1
   ENDIF ELSE IF N_ELEMENTS( files ) GT 1 THEN BEGIN
      file_list = files
   ENDIF ELSE BEGIN

      file_list = FINDFILE( files, COUNT = file_count )

      IF file_count LE 0 THEN BEGIN
         MESSAGE, "error: could not find file " + files, /CONT, /NONAME
         return, -1
      ENDIF

   ENDELSE

   FOR file_i = 0, N_ELEMENTS( file_list ) - 1 DO BEGIN

      file = file_list[ file_i ]
      FDECOMP,  file, disk, dir, name, qual, vers

      sms_file = disk + dir + name + '.' + qual + vers
      filename = name + '.' + qual + vers
                    ; -------------------------------------
                    ; Open Files
                    ; -------------------------------------

                    ; OPEN SMS FILE
      OPENR, sms_lun, sms_file, /GET_LUN, ERROR = open_error

      IF open_error NE 0 THEN BEGIN
         MESSAGE, "error: can't read SMS file: "+sms_file, /CONT, /NONAME
      ENDIF ELSE BEGIN

         IF NOT KEYWORD_SET( non_std ) THEN BEGIN

            fstatus = FSTAT( sms_lun )

            IF fstatus.size MOD 71 NE 0 THEN BEGIN
               MESSAGE, $
                "error: SMS not in standard format.  Use /NON_STD switch.", $
                /CONT, /NONAME
               return, -1
            ENDIF
            rec = ASSOC( sms_lun, BYTARR(71) ) ; associate SMS with variable

         ENDIF

                    ; -------------------------------------
                    ; Variable initialization
                    ; -------------------------------------

         sHRC = skel_size()
         sWFC = skel_size()
         sSBC = skel_size()

         sDump = skel_time()
         sRoot = skel_root()

                    ; -------------------------------------
                    ; Parse SMS file
                    ; -------------------------------------

         IF (verbose GE 1) THEN PRINTF, -2, FORMAT='("parsing ",A,"...")',sms_file
         
         rec_i = 0
         line = get_new_line( rec_i, LUN=sms_lun, REC=rec )

         WHILE NOT EOF(sms_lun) DO BEGIN
                    ; There should be a new 'line' to process on each
                    ; iteration of this loop
            
            id = STRMID( line, 1, 10 )

                    ; skip ahead to the start of next sms command
            WHILE (STRCOMPRESS( id, /REMOVE ) EQ '') AND NOT EOF(sms_lun) DO BEGIN

               IF (verbose GT 10) THEN PRINTF, -2, 'skipping: ' + line

               line = get_new_line( rec_i, LUN=sms_lun, REC=rec )

                    ; extract 10 characters starting at the 1st position
               id = STRMID( line, 1, 10 )

            ENDWHILE

                    ; extract 5 characters starting at the 11th position
            a = STRMID( line, 11, 5 )
            
            IF (verbose GE 3) THEN PRINTF, -2, 'got key: '+strtrim(a,2)

            CASE 1 OF

               (a EQ ':TABL'): BEGIN

                  junk = GETTOK( line, ',' )
                  
                  table_key = GETTOK( line, ',' )
                  IF ( verbose GE 2 ) THEN PRINTF, -2, "processing: " + STRTRIM( a, 2 ) + $
                   ' '+table_key+' @ line ' + STRTRIM( rec_i, 2 )
                  
                  CASE table_key OF 

                     'JHRCFULL': BEGIN

                        sHRC.size = pix2bytes( hrc_xsize * hrc_ysize, $
                                               DATA = sdi )

                        REPEAT BEGIN
                           
                           line = get_new_line( rec_i, LUN=sms_lun, REC=rec )

                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                           
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                     END 

                     'JWFCFULL': BEGIN

                        sWFC.size = pix2bytes( wfc_xsize * wfc_ysize, $
                                               DATA = sdi )

                        REPEAT BEGIN
                           
                           line = get_new_line( rec_i, LUN=sms_lun, REC=rec )

                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                           
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                     END 

                     'JCCDSET': BEGIN

                        REPEAT BEGIN

                           value = parse_inparen( line, 'DET' )
                           IF value NE '' THEN detector = value

                           value = parse_inparen( line, 'XSIZE' )
                           IF value NE '' THEN xsize = value

                           value = parse_inparen( line, 'YSIZE' )
                           IF value NE '' THEN ysize = value

                           line = get_new_line( rec_i, LUN=sms_lun, REC=rec )

                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                           
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                        CASE STRUPCASE( detector ) OF

                           'HRC': BEGIN
                              IF ( N_ELEMENTS( xsize ) GT 0 ) AND $
                               ( N_ELEMENTS( ysize ) GT 0 ) THEN $
                               sHRC.size = LONG(xsize) * LONG(ysize)
                           END

                           'WFC': BEGIN
                              IF ( N_ELEMENTS( xsize ) GT 0 ) AND $
                               ( N_ELEMENTS( ysize ) GT 0 ) THEN $
                               sWFC.size = LONG(xsize) * LONG(ysize)
                           END
                           
                           ELSE: 
                        ENDCASE
                     END 

                     'JCCDGEN': BEGIN

                        REPEAT BEGIN

                           value = parse_inparen( line, 'DET' )
                           IF value NE '' THEN detector = value
                           
                           line = get_new_line( rec_i, LUN=sms_lun, REC=rec )

                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                           
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                        CASE STRUPCASE( detector ) OF

                           'HRC': BEGIN
                              sHRC.size = pix2bytes( hrc_xsize * hrc_ysize, $
                                                     DATA = sdi )
                           END

                           'WFC': BEGIN
                              sWFC.size = pix2bytes( wfc_xsize * wfc_ysize, $
                                                     DATA = sdi )
                           END
                           
                           ELSE: 
                        ENDCASE

                     END

                     'JCCDEXP': BEGIN

                        REPEAT BEGIN
                           
                           value = parse_inparen( line, 'DET' )
                           IF value NE '' THEN detector = value

                           obset = parse_inparen( line, 'OBSET' )
                           IF obset NE '' THEN sRoot.obset = obset
                           
                           progid = parse_inparen( line, 'PROGID' )
                           IF progid NE '' THEN sRoot.progid = progid

                           smstime = parse_smstime( line )

                           line = get_new_line( rec_i, LUN=sms_lun, REC=rec )

                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                           
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                        IF (verbose GT 6) THEN HELP, /STR, sHRC, sWFC, detector

                        IF STRUPCASE( detector ) EQ 'HRC' THEN BEGIN
                           IF N_ELEMENTS( aImages ) LE 0 THEN $
                            aImages = [sHRC] $
                           ELSE aImages = [aImages,sHRC]
                        ENDIF ELSE IF STRUPCASE( detector ) EQ 'WFC' THEN BEGIN
                           IF N_ELEMENTS( aImages ) LE 0 THEN $
                            aImages = [sWFC] $
                           ELSE aImages = [aImages,sWFC]
                        ENDIF

                     END 

                     'JTARACQ': BEGIN

                        sHRC.size = pix2bytes( targacq_xsize * targacq_ysize, $
                                               DATA = sdi )

                        REPEAT BEGIN
                           
                           smstime = parse_smstime( line )

                           line = get_new_line( rec_i, LUN=sms_lun, REC=rec )

                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                           
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''
                        IF N_ELEMENTS( aImages ) LE 0 THEN $
                         aImages = [sHRC] $
                        ELSE aImages = [aImages,sHRC]

                     END 
                     
                     'JMAEXP': BEGIN

                        sSBC.size = sbc_xsize * sbc_ysize

                        REPEAT BEGIN 
                           
                           obset = parse_inparen( line, 'OBSET' )
                           IF obset NE '' THEN sRoot.obset = obset
                           
                           progid = parse_inparen( line, 'PROGID' )
                           IF progid NE '' THEN sRoot.progid = progid
                           
                           smstime = parse_smstime( line )

                           line = get_new_line( rec_i, LUN=sms_lun, REC=rec )

                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                           
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''
                        
                        IF N_ELEMENTS( aImages ) LE 0 THEN $
                         aImages = [sSBC] $
                        ELSE aImages = [aImages,sSBC]

                     END

                     'JMIE2RAM': BEGIN

                        REPEAT BEGIN

                           nwords = parse_inparen( line, 'NWORDS' )

                           obset = parse_inparen( line, 'OBSET' )
                           IF obset NE '' THEN sRoot.obset = obset
                           
                           progid = parse_inparen( line, 'PROGID' )
                           IF progid NE '' THEN sRoot.progid = progid

                           value = parse_smstime( line )
                           
                           line = get_new_line( rec_i, LUN=sms_lun, REC=rec )

                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                           
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                        sSBC.size = words2bytes( nwords )

                        IF N_ELEMENTS( aImages ) LE 0 THEN $
                         aImages = [sSBC] $
                        ELSE aImages = [aImages,sSBC]

                     END

                     'JDUMPSD': BEGIN

                        REPEAT BEGIN
                           
                           value = parse_smstime( line )
                           IF value NE '' THEN $
                            sDump.time = STRMID( value, 9, 13 )
                           
                           line = get_new_line( rec_i, LUN=sms_lun, REC=rec )

                    ; extract 10 characters starting at the 1st position
                           id = STRMID( line, 1, 10 )
                           
                        ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

                     END
                     
                     ELSE:

                  ENDCASE

               END

               (a EQ ':SCIH'): BEGIN

                  REPEAT BEGIN

                     obset = parse_inparen( line, 'OBSET' )
                     IF obset NE '' THEN sRoot.obset = obset
                     
                     progid = parse_inparen( line, 'PROGID' )
                     IF progid NE '' THEN sRoot.progid = progid
                     
                     line = get_new_line( rec_i, LUN=sms_lun, REC=rec )
                     
                    ; extract 10 characters starting at the 1st position
                     id = STRMID( line, 1, 10 )
                     
                  ENDREP UNTIL STRCOMPRESS( id, /REMOVE ) NE ''

               END

               ELSE: line = get_new_line( rec_i, LUN=sms_lun, REC=rec )

            ENDCASE 

         ENDWHILE
         
         IF N_ELEMENTS(sms_lun) GT 0 THEN FREE_LUN, sms_lun

         IF N_ELEMENTS( aImages ) GT 0 THEN $
          n_bytes = LONG( TOTAL( aImages.size, /DOUBLE ) ) $
         ELSE n_bytes = 0L

         IF N_ELEMENTS( aSizes ) LE 0 THEN $
          aSizes = [n_bytes] $
         ELSE aSizes = [aSizes,n_bytes]
         
         IF N_ELEMENTS( aTimes ) LE 0 THEN $
          aTimes = [sDump.time] $
         ELSE aTimes = [aTimes,sDump.time]
         
         rootname = 'J' + sRoot.progid + sRoot.obset

         IF N_ELEMENTS( aRoots ) LE 0 THEN $
          aRoots = [rootname] $
         ELSE aRoots = [aRoots,rootname]

         IF N_ELEMENTS( aNames ) LE 0 THEN $
          aNames = [filename] $
         ELSE aNames = [aNames,filename]
         
                    ; Get rid of accumulated struct arrays
         IF N_ELEMENTS( aImages ) GT 0 THEN $
          junk = TEMPORARY( aImages )
         junk = 0b
         n_bytes = -1L

      ENDELSE 

   ENDFOR

   root_names = aRoots

   IF KEYWORD_SET( print ) THEN BEGIN

      FOR i = 0, N_ELEMENTS( aRoots ) - 1 DO BEGIN
         IF N_ELEMENTS( aSizes ) LE i THEN size_i = ' ' ELSE size_i= aSizes[i] 
         IF N_ELEMENTS( aTimes ) LE i THEN time_i = ' ' ELSE time_i= aTimes[i] 
         
         PRINT, FORMAT='(A,": ",A7,X,A,X,I," bytes")', aNames[i], aRoots[i], $
          time_i, size_i

      ENDFOR

   ENDIF

   IF KEYWORD_SET( time ) THEN return, aTimes

   return, aSizes
   
END

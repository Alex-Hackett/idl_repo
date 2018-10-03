;+
; $Id: read_au.pro,v 1.1 2001/11/05 21:53:19 mccannwj Exp $
;
; NAME:
;     read_au
;
; PURPOSE:
;     Read the contents of a Sun/Next AU format sound file and return
;     the data array.
;
; CATEGORY:
;     Input/Output
;
; CALLING SEQUENCE:
;     result = READ_AU( Filename [, RATE=, CHANNELS=, COMMENT=, $
;                                  /FAST, /LONG, /VERBOSE ] )
;
; INPUTS:
;     Filename - (STRING) name of AU file to be read.
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     RATE     - (named variable) to receive the sampling rate read from
;                the file header.
;     CHANNELS - (named variable) to receive the number of channels read.
;     COMMENT  - (named variable) to receive the comment string read
;                from the file header.
;     SPLIT    - (BOOL) split stereo channels into a 2D array
;     FAST     - (BOOL) use "fast" (table lookup) uLaw/aLaw  conversion.
;     LONG     - (BOOL) scale data up to a long.
;     VERBOSE  - (BOOL) be noisy.
;
; OUTPUTS:
;     result   - (ARRAY) 16 bit linear sample data
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
;    Mon Oct 19 12:44:24 1998, William Jon McCann <mccannwj@acs10>
;
;		Created.
;
;-


; _____________________________________________________________________________

;** This routine converts from ulaw to 16 bit linear.
;**
;** Originally by
;** Craig Reese: IDA/Supercomputing Research Center
;** 29 September 1989
;**
;** Ported to IDL by William Jon McCann JHU/ACS 1998
FUNCTION ulaw_to_linear, byte_array

   exp_lut = [0, 132, 396, 924, 1980, 4092, 8316, 16764 ]

                    ; 1's complement
   byte_array = byte_array XOR -1

   sign = ( byte_array AND '80'XB )

   exponent = ISHFT( byte_array, -4 ) AND '07'X

   mantissa = byte_array AND '0F'X

   sample_array = exp_lut[exponent] + ISHFT( mantissa, (exponent+3) )

   NZE = WHERE( sign NE 0, ncount )
   IF ncount GT 0 THEN sample_array[NZE] = -1 * sample_array[NZE]

   return, FIX( sample_array )
END 

; _____________________________________________________________________________

FUNCTION ulaw_to_linear_fast, byte_array

   pos_table1 = [ $
                 32124, 31100, 30076, 29052, 28028, 27004, 25980, 24956, $
                 23932, 22908, 21884, 20860, 19836, 18812, 17788, 16764, $
                 15996, 15484, 14972, 14460, 13948, 13436, 12924, 12412, $
                 11900, 11388, 10876, 10364,  9852,  9340,  8828,  8316 ]
   pos_table2 = [ $
                 7932,  7676,  7420,  7164,  6908,  6652,  6396,  6140, $
                 5884,  5628,  5372,  5116,  4860,  4604,  4348,  4092, $
                 3900,  3772,  3644,  3516,  3388,  3260,  3132,  3004, $
                 2876,  2748,  2620,  2492,  2364,  2236,  2108,  1980, $
                 1884,  1820,  1756,  1692,  1628,  1564,  1500,  1436, $
                 1372,  1308,  1244,  1180,  1116,  1052,   988,   924 ]
   pos_table3 = [ $
                 876,   844,   812,   780,   748,   716,   684,   652, $
                 620,   588,   556,   524,   492,   460,   428,   396, $
                 372,   356,   340,   324,   308,   292,   276,   260, $
                 244,   228,   212,   196,   180,   164,   148,   132, $
                 120,   112,   104,    96,    88,    80,    72,    64, $
                 56,    48,    40,    32,    24,    16,     8,     0 ]

   pos_table = [pos_table1,pos_table2,pos_table3]

   exp_table = [-1*pos_table,pos_table]

   return, exp_table[ byte_array ]
END 

; _____________________________________________________________________________

FUNCTION alaw_to_linear, byte_array

   exp_lut = [ 0, 264, 528, 1056, 2112, 4224, 8448, 16896 ]

   byte_array = TEMPORARY(byte_array) ^ '55'XB

   sign = ( byte_array AND '80'XB )

   byte_array = byte_array AND '7F'XB
   
   sample_array = MAKE_ARRAY( /INT, SIZE=size(byte_array) )

   GTE = WHERE( byte_array GE 16, ngcount )
   LTE = WHERE( byte_array LT 16, nlcount )
   
   IF ngcount GT 0 THEN BEGIN
      exponent = ISHFT( byte_array, -4 ) AND '07'XB
      mantissa = byte_array AND '0F'XB
      sample_array[GTE] = exp_lut[exponent] + ISHFT( mantissa,(exponent+3) )
   ENDIF

   IF nlcount GT 0 THEN sample_array[LTE] = ISHFT( byte_array, 4 ) + 8

   return, sample_array
END 

; _____________________________________________________________________________

FUNCTION alaw_to_linear_fast, byte_array

   pos_table1 = [ $
           5504,  5248,  6016,  5760,  4480,  4224,  4992,  4736,$
           7552,  7296,  8064,  7808,  6528,  6272,  7040,  6784,$
           2752,  2624,  3008,  2880,  2240,  2112,  2496,  2368,$
           3776,  3648,  4032,  3904,  3264,  3136,  3520,  3392 ]
   pos_table2 = [ $
          22016, 20992, 24064, 23040, 17920, 16896, 19968, 18944,$
          30208, 29184, 32256, 31232, 26112, 25088, 28160, 27136,$
          11008, 10496, 12032, 11520,  8960,  8448,  9984,  9472,$
          15104, 14592, 16128, 15616, 13056, 12544, 14080, 13568 ]
   pos_table3 = [ $
            344,   328,   376,   360,   280,   264,   312,   296,$
            472,   456,   504,   488,   408,   392,   440,   424,$
             88,    72,   120,   104,    24,     8,    56,    40,$
            216,   200,   248,   232,   152,   136,   184,   168 ]
   pos_table4 = [ $
           1376,  1312,  1504,  1440,  1120,  1056,  1248,  1184,$
           1888,  1824,  2016,  1952,  1632,  1568,  1760,  1696,$
            688,   656,   752,   720,   560,   528,   624,   592,$
            944,   912,  1008,   976,   816,   784,   880,   848 ]

   pos_table = [pos_table1,pos_table12,pos_table3,pos_table4]

   exp_table = [-1*pos_table,pos_table]

   
   return, exp_table[ byte_array ]
END 

; _____________________________________________________________________________

FUNCTION get_au_header, lun, number_of_words, VERBOSE=verbose

   IF (N_ELEMENTS( verbose ) LE 0) THEN verbose=0

   sHeader = { magic: 0L, $
               header_size: 0L, $
               data_size: 0L, $
               encoding: 0L, $
               sample_rate: 0L, $
               channels: 0L, $
               comment: '' }

   word = 0L
   READU, lun, word
   sHeader.magic = word

   word = 0L
   READU, lun, word
   sHeader.header_size = word

   word = 0L
   READU, lun, word
   sHeader.data_size = word

   word = 0L
   READU, lun, word
   sHeader.encoding = word

   word = 0L
   READU, lun, word
   sHeader.sample_rate = word

   word = 0L
   READU, lun, word
   sHeader.channels = word

   num_left = (sHeader.header_size - number_of_words)
   IF verbose THEN help,num_left

   IF num_left GT 0 THEN BEGIN
      string = STRING( FORMAT='(A'+STRTRIM(num_left,2)+')', '' )
      readu, lun, string

      sHeader.comment = string
   ENDIF 

   return, sHeader
END 

; _____________________________________________________________________________

FUNCTION raw_read, lun, number_of_samples, size, style, FAST=fast, $
                   LONG=long, VERBOSE=verbose

   IF N_ELEMENTS( number_of_samples ) LE 0 THEN number_of_samples = 0
   IF N_ELEMENTS( verbose ) LE 0 THEN verbose=0

   STDERR = -2

   CASE STRUPCASE(size) OF

      'BYTE': BEGIN
         CASE style OF
            
            'SIGN2': BEGIN

               array = BYTARR( number_of_samples )
               READU, lun, array

               IF KEYWORD_SET( long ) THEN $
                sample_array = ISHFT( LONG( TEMPORARY( array ) ), 16 ) $
               ELSE sample_array = FIX( TEMPORARY( array ) )

            END 

            'UNSIGNED':BEGIN

               array = BYTARR( number_of_samples )
               READU, lun, array
               array = TEMPORARY(array) ^ 128

               IF KEYWORD_SET( long ) THEN $
                sample_array = ISHFT( LONG( TEMPORARY( array ) ), 24 ) $
               ELSE sample_array = FIX( TEMPORARY( array ) )

            END

            'ULAW': BEGIN
               array = BYTARR( number_of_samples )
               READU, lun, array

               IF KEYWORD_SET( fast ) THEN BEGIN
                  IF verbose THEN PRINTF,STDERR,'using fast ulaw conversion'
                  sample_array = ulaw_to_linear_fast(TEMPORARY(array))
               ENDIF ELSE BEGIN 
                  IF verbose THEN PRINTF,STDERR,'using ulaw conversion'
                  sample_array = ulaw_to_linear(TEMPORARY(array))
               ENDELSE

               IF KEYWORD_SET( long ) THEN $
                sample_array = ISHFT( LONG( TEMPORARY( sample_array ) ), 16 )$
               ELSE sample_array = FIX( TEMPORARY( sample_array ) )

            END 

            'ALAW': BEGIN
               array = BYTARR( number_of_samples )
               READU, lun, array

               IF KEYWORD_SET( fast ) THEN BEGIN
                  IF verbose THEN PRINTF,STDERR,'using fast alaw conversion'
                  sample_array = alaw_to_linear_fast(TEMPORARY(array))
               ENDIF ELSE BEGIN
                  IF verbose THEN PRINTF,STDERR,'using alaw conversion'
                  sample_array = alaw_to_linear(TEMPORARY(array))
               ENDELSE

               IF KEYWORD_SET( long ) THEN $
                sample_array = ISHFT( LONG( TEMPORARY( sample_array ) ), 16 )$
               ELSE sample_array = FIX( TEMPORARY( sample_array ) )

            END 

            ELSE: BEGIN

               PRINTF, STDERR, "Style case not matched: "+style
               return, -1

            END 

         ENDCASE   
      END
      
      'WORD': BEGIN

         CASE style OF
            
            'SIGN2': BEGIN
               array = INTARR( number_of_samples )
               READU, lun, array
               
               IF KEYWORD_SET( long ) THEN $
                sample_array = ISHFT( LONG( TEMPORARY( array ) ), 16 ) $
               ELSE sample_array = FIX( TEMPORARY( array ) )

            END 

            'UNSIGNED': BEGIN
               array = INTARR( number_of_samples )
               READU, lun, array

               IF KEYWORD_SET( long ) THEN BEGIN
                  array = LONG( TEMPORARY( array ) ) ^ '8000'XL
                  sample_array = ISHFT( TEMPORARY( array ), 16 )
               ENDIF ELSE sample_array = FIX( TEMPORARY( array ) )

            END

            'ULAW': BEGIN
               PRINTF, STDERR, "No U-Law support for shorts."
               return, -1
            END 

            'ALAW': BEGIN
               PRINTF, STDERR, "No A-Law support for shorts."
               return, -1
            END 

            ELSE: BEGIN
               PRINTF, STDERR, "Style case not matched: "+style
               return, -1
            END 

         ENDCASE   

      END

      'FLOAT': BEGIN
         array = FLTARR( number_of_samples )
         READU, lun, array

         IF KEYWORD_SET( long ) THEN $
          sample_array = ISHFT( TEMPORARY( array ), 16 ) $
         ELSE sample_array = FIX( TEMPORARY( array ) )

      END

      ELSE: BEGIN
         MESSAGE, 'Data size case not matched.', /INFO
         return, -1
      END 

   ENDCASE 

   return, sample_array
END 

; _____________________________________________________________________________

FUNCTION read_au, filename, RATE=rate, CHANNELS=channels, $
                  COMMENT=comment, FAST=fast, LONG=long, $
                  VERBOSE=verbose, SPLIT = split

   IF N_ELEMENTS( verbose ) LE 0 THEN verbose=0

   STDERR = -2

   sMagic = { sun:       '2e736e64'XL, $ ; Really '.snd' 
              sun_inv:   '646e732e'XL, $ ; '.snd' upside-down 
              dec:       '2e736400'XL, $ ; Really '\0ds.' (for DEC) 
              dec_inv:   '0064732e'XL } ; '\0ds.' upside-down 

   sSun = { header_size:   24, $ ; Size of minimal header 
            unspec:    0, $ ; Unspecified data size 
            ulaw:      1, $ ; u-law encoding 
            lin_8:     2, $ ; Linear 8 bits 
            lin_16:    3, $ ; Linear 16 bits 
            lin_24:    4, $ ; Linear 24 bits 
            lin_32:    5, $ ; Linear 32 bits 
            float:     6, $ ; IEEE FP 32 bits 
            double:    7, $ ; IEEE FP 64 bits 
            g721:      23, $ ; CCITT G.721 4-bits ADPCM 
            g723_3:    25, $ ; CCITT G.723 3-bits ADPCM 
            g723_5:    26 } ; CCITT G.723 5-bits ADPCM
   
   sThis = { swap: 0, $
             size: '', $
             style: '' }

   path = FINDFILE( filename, COUNT=nfiles )

   IF nfiles LE 0 THEN BEGIN
      PRINTF, STDERR, "Cannot find "+filename
      return,-1
   ENDIF 

   OPENR, lun, filename, /GET_LUN

   sAu = get_au_header( lun, sSun.header_size, VERBOSE=verbose )
   comment = sAu.comment
   rate = sAu.sample_rate
   channels = sAu.channels

   IF verbose THEN HELP, /STR, sAu

   IF sAu.header_size LT sSun.header_size THEN BEGIN
      PRINTF, STDERR, "Sun/NeXT header size too small."
      return, -1
   ENDIF 

   CASE sAu.magic OF
      sMagic.dec_inv: BEGIN 
         sThis.swap = 1
         if (verbose) then PRINTF, STDERR, "Found inverted DEC magic word" 
      END 
      sMagic.sun_inv: BEGIN 
         sThis.swap = 1
         if (verbose) then PRINTF, STDERR, "Found inverted Sun/NeXT magic word"
      END 
      sMagic.sun: BEGIN 
         sThis.swap = 0
         if (verbose) then PRINTF, STDERR, "Found Sun/NeXT magic word"
      END 
      sMagic.dec: BEGIN 
         sThis.swap = 0
         if (verbose) then PRINTF, STDERR, "Found DEC magic word"
      END
      ELSE: BEGIN 
         PRINTF, STDERR, "Sun/NeXT/DEC header doesn't start with magic word."
         return, -1
      END 
   ENDCASE

   CASE sAu.encoding OF
      sSun.ulaw: BEGIN
         sThis.style = 'ULAW'
         sThis.size = 'BYTE'
      END 

      sSun.lin_8: BEGIN
         sThis.style = 'SIGN2'
         sThis.size = 'BYTE'
      END 

      sSun.lin_16: BEGIN
         sThis.style = 'SIGN2'
         sThis.size = 'WORD'
      END 

      sSun.g721: BEGIN
         sThis.style = 'SIGN2'
         sThis.size = 'WORD'
      END 

      sSun.g723_3: BEGIN
         sThis.style = 'SIGN2'
         sThis.size = 'WORD'
      END 

      sSun.g723_5: BEGIN
         sThis.style = 'SIGN2'
         sThis.size = 'WORD'
      END
         
      ELSE: BEGIN
         PRINTF, STDERR, "Unsupported encoding in Sun/NeXT header: 0x"+$
          STRTRIM(sAu.encoding,2)
         return, -1
      END
   ENDCASE 

   array = raw_read( lun, sAu.data_size, sThis.size, sThis.style, $
                     FAST=fast, LONG=long, VERB=verbose )

   IF verbose THEN PRINTF, STDERR, "Read "+STRTRIM(sAu.data_size,2)+$
    " samples"
   
   FREE_LUN, lun

   IF KEYWORD_SET( split ) AND (channels EQ 2) THEN BEGIN

      index = LINDGEN( N_ELEMENTS( array ) )
      even = WHERE( (index MOD 2) EQ 0 )
      odd = WHERE( (index MOD 2) EQ 1 )

      left = array[even]
      right = array[odd]
      
      array = [[left],[right]]

   ENDIF 

   return, array
END 




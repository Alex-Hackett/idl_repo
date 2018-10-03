;+
; $Id: write_au.pro,v 1.1 2001/11/05 21:57:22 mccannwj Exp $
;
; NAME:
;     WRITE_AU
;
; PURPOSE:
;     Write a 16 bit linear array to a Sun/Next AU format sound file.
;
; CATEGORY:
;     ACS/JHU
;
; CALLING SEQUENCE:
;     result = WRITE_AU( Filename [, RATE=, CHANNELS=, COMMENT=, $
;                                  /FAST, /LONG, /VERBOSE ] )
;
; INPUTS:
;     Filename - (STRING) name of AU file to be read.
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     SIZE     - (STRING) size of data element. ('BYTE' or 'WORD' allowed.)
;     STYLE    - (STRING) style of data encoding. ('ULAW','ALAW','SIGN2')
;     RATE     - (INT) to receive the sampling rate read from
;                the file header.
;     CHANNELS - (INT) to receive the number of channels read.
;     COMMENT  - (STRING) to receive the comment string read
;                from the file header.
;     FAST     - (BOOL) use "fast" (table lookup) uLaw/aLaw conversion.
;                This is very slow and you must have the lookup
;                tables.  Don't use this.
;     LONG     - (BOOL) input data are long integers.
;     OVERWRITE - (BOOL)
;     VERBOSE  - (BOOL) be noisy.
;
; OUTPUTS:
;     result   - (SCALAR) number of samples written.
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
;		Created.
;-


; _____________________________________________________________________________

FUNCTION read_comp, filename, HEX=hex

   IF KEYWORD_SET( hex ) THEN format_string = '( 8(2X,Z2,1X) )' $
   ELSE format_string = '( 8(I3,1X) )'

   path = FINDFILE( filename, COUNT=nfiles )
   
   IF nfiles LE 0 THEN BEGIN
      PRINTF, STDERR, "Cannot find "+filename
      return,-1
   ENDIF 
   
   OPENR, lun, filename, /GET_LUN
   
   WHILE NOT EOF(lun) DO BEGIN

      nums = INTARR(8)

      READF, lun, FORMAT=format_string, nums

      IF N_ELEMENTS( array ) LE 0 THEN $
       array = nums $
      ELSE array = [array,nums]

   ENDWHILE 

   FREE_LUN, lun

   return, array
END 

; _____________________________________________________________________________

;/*
;** This routine converts from linear to ulaw.
;**
;** Craig Reese: IDA/Supercomputing Research Center
;** Joe Campbell: Department of Defense
;** 29 September 1989
;**
;** Input: Signed 16 bit linear sample
;** Output: 8 bit ulaw sample
;**
;** Ported to IDL by WJM.
;*/

FUNCTION linear_to_ulaw, sample, ZEROTRAP = zerotrap, DEBUG = debug

   uBIAS = 132      ;/* define the add-in bias for 16 bit samples */
   uCLIP = 32635

   twos = REPLICATE( 2, 4 )
   threes = REPLICATE( 3, 8 )
   fours = REPLICATE( 4, 16 )
   fives = REPLICATE( 5, 32 )
   sixes = REPLICATE( 6, 64 )
   sevens = REPLICATE( 7, 128 )

   exp_lut = [ 0,0,1,1,twos,threes,fours,fives,sixes,sevens ]
   
   sign = ISHFT(sample, -8) AND '80'XL

   NZE = WHERE( sign NE 0, ncount )
   IF KEYWORD_SET( debug ) THEN PRINTF, -2, 'signs: ', ncount
   IF ncount GT 0 THEN sample[NZE] = -1 * sample[NZE]

   GTE = WHERE( sample GT uClip, gcount )
   IF KEYWORD_SET( debug ) THEN PRINTF, -2, 'clips: ', gcount
   IF gcount GT 0 THEN sample[GTE] = 0 ; clip to zero instead

   sample = TEMPORARY( sample ) + uBias

   exponent = exp_lut[ ISHFT( sample, -7 ) AND 'FF'X ]

   mantissa = ISHFT( sample, -1 * (exponent + 3) ) AND '0F'X

   ulawbytes = ( sign OR ISHFT( exponent, 4 ) OR mantissa ) XOR -1

   IF KEYWORD_SET( zerotrap ) THEN BEGIN
      ZE = WHERE( ulawbytes EQ 0, nzeros )

      IF nzeros GT 0 THEN ulawbytes[ZE] = '02'XB
   ENDIF 

   return, BYTE( ulawbytes )
END 

; _____________________________________________________________________________


FUNCTION linear_to_ulaw_fast, sample

   comp_table = read_comp('ulaw_comp.dat')

   return, comp_table[ (sample / 4) AND '3fff'X ]
END 

; _____________________________________________________________________________


FUNCTION linear_to_alaw, sample

   aClip = 31744

   twos = REPLICATE( 2, 2 )
   threes = REPLICATE( 3, 4 )
   fours = REPLICATE( 4, 8 )
   fives = REPLICATE( 5, 16 )
   sixes = REPLICATE( 6, 32 )
   sevens = REPLICATE( 7, 64 )

   exp_lut = [ 1,1,twos,threes,fours,fives,sixes,sevens ]

   sign = ISHFT( sample XOR -1, -8 ) AND '80'X

   NZE = WHERE( sign EQ 0, ncount )
   IF ncount GT 0 THEN sample[NZE] = -1 * sample[NZE]
   
   GTE = WHERE( sample GT aClip, gcount )
   IF gcount GT 0 THEN sample[GTE] = aClip

   gcount = 0
   GTE = WHERE( sample GE 256, gcount )
   LTE = WHERE( sample LT 256, lcount )
   IF gcount GT 0 THEN BEGIN
      exponent = exp_lut[ ISHFT( sample, -8 ) AND '7F'X ]
      mantissa = ISHFT( sample, -(exponent+3) ) AND '0F'X
      alawbytes = ISHFT( exponent, 4 ) OR mantissa
   ENDIF 
   IF lcount GT 0 THEN BEGIN
      alawbytes = ISHFT( sample, -4 )
   ENDIF 

   alawbytes = TEMPORARY(alawbytes) ^ (sign ^ '55'XB)

   return, alawbytes
END 

; _____________________________________________________________________________


FUNCTION linear_to_alaw_fast, sample

   comp_table = read_comp('alaw_comp.dat')

   return, comp_table[ (sample / 4) AND '3fff'X ]
END 

; _____________________________________________________________________________


FUNCTION put_au_header, lun, sInfo

   IF N_ELEMENTS( comment ) LE 0 THEN comment = ''

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

   sHeader = { magic: 0L, $
               header_size: 0L, $
               data_size: 0L, $
               encoding: 0L, $
               sample_rate: 0L, $
               channels: 0L, $
               comment: '' }

   IF (sInfo.style EQ 'ULAW') AND (sInfo.size EQ 'BYTE') THEN $
    sHeader.encoding = sSun.ulaw $
   ELSE IF (sInfo.style EQ 'SIGN2') AND (sInfo.size EQ 'BYTE') THEN $
    sHeader.encoding = sSun.lin_8 $
   ELSE IF (sInfo.style EQ 'SIGN2') AND (sInfo.size EQ 'WORD') THEN $
    sHeader.encoding = sSun.lin_16 $
   ELSE BEGIN
      IF verbose THEN BEGIN
      PRINTF, STDERR, "Unsupported output style/size for Sun/NeXT header."
      PRINTF, STDERR, "Defaulting to 8khz u-law output."
   ENDIF 
      sHeader.encoding = sSun.ulaw
      sInfo.style = 'ULAW'
      sInfo.size = 'BYTE'
      sInfo.rate = 8000
   ENDELSE

   sHeader.magic = sMagic.sun
   WRITEU, lun, LONG( sHeader.magic )

   sHeader.header_size = LONG( sSun.header_size + STRLEN( sInfo.comment ) )
   WRITEU, lun, sHeader.header_size
   
   sHeader.data_size = LONG( sInfo.data_size )
   WRITEU, lun, sHeader.data_size

   sHeader.encoding = LONG( sHeader.encoding )
   WRITEU, lun, sHeader.encoding

   sHeader.sample_rate = LONG( sInfo.rate )
   WRITEU, lun, sHeader.sample_rate

   sHeader.channels = LONG( sInfo.channels )
   WRITEU, lun, sHeader.channels
   
   sHeader.comment = STRTRIM( sInfo.comment, 2 )
   WRITEU, lun, sHeader.comment

   return, sHeader
END 

; _____________________________________________________________________________


PRO raw_write, lun, sample_array, size, style, FAST=fast, $
               LONG=long, VERBOSE=verbose

   IF N_ELEMENTS( verbose ) LE 0 THEN verbose=0 ELSE verbose=1

   STDERR = -2

   CASE STRUPCASE(size) OF

      'BYTE': BEGIN
         CASE style OF
            
            'SIGN2': BEGIN

               IF KEYWORD_SET( long ) THEN $
                array = BYTE(ISHFT( LONG(TEMPORARY(sample_array)), -24 )) $
               ELSE array = BYTE( TEMPORARY( sample_array ) )

               WRITEU, lun, array

            END 

            'UNSIGNED':BEGIN

               IF KEYWORD_SET( long ) THEN $
                array = BYTE( ISHFT( LONG(TEMPORARY(sample_array)), -24 ) ) $
               ELSE array = BYTE( TEMPORARY( sample_array ) )

               array = TEMPORARY( array ) ^ 128

               WRITEU, lun, array

            END

            'ULAW': BEGIN

               IF KEYWORD_SET( long ) THEN $
                array = ISHFT( LONG(TEMPORARY(sample_array)), -16 ) + '8'XB $
               ELSE array = TEMPORARY( sample_array )

               IF KEYWORD_SET( fast ) THEN BEGIN
                  array = BYTE( linear_to_ulaw_fast( TEMPORARY(array) ) )
               ENDIF ELSE BEGIN
                  array = BYTE( linear_to_ulaw( TEMPORARY(array) ) )
               ENDELSE

               WRITEU, lun, array

            END 

            'ALAW': BEGIN

               IF KEYWORD_SET( long ) THEN $
                array = ISHFT( LONG(TEMPORARY(sample_array)), -16 ) + '8'XB $
               ELSE array = TEMPORARY( sample_array )

               IF KEYWORD_SET( fast ) THEN BEGIN
                  array = BYTE( linear_to_alaw_fast( TEMPORARY(array) ) )
               ENDIF ELSE BEGIN
                  array = BYTE( linear_to_alaw( TEMPORARY(array) ) )
               ENDELSE 

               WRITEU, lun, array

            END 

            ELSE: BEGIN
               PRINTF, STDERR, "Style case not matched: "+style
               return
            END 

         ENDCASE   

      END
      
      'WORD': BEGIN

         CASE style OF
            
            'SIGN2': BEGIN

               IF KEYWORD_SET( long ) THEN $
                array = FIX( ISHFT( LONG(TEMPORARY(sample_array)), -16 ) ) $
               ELSE array = TEMPORARY( sample_array )

               WRITEU, lun, array

            END 

            'UNSIGNED': BEGIN

               IF KEYWORD_SET( long ) THEN $
                array = FIX( ISHFT( LONG( TEMPORARY( sample_array ) ), -16 ) $
                            ^'8000'XL ) $
               ELSE array = TEMPORARY( sample_array )

               WRITEU, lun, array

            END

            'ULAW': BEGIN
               PRINTF, STDERR, "No U-Law support for shorts."
               return
            END 

            'ALAW': BEGIN
               PRINTF, STDERR, "No A-Law support for shorts."
               return
            END 

            ELSE: BEGIN
               PRINTF, STDERR, "Style case not matched: "+style
               return
            END 

         ENDCASE   

      END

      'FLOAT': BEGIN
         IF KEYWORD_SET( long ) THEN $
          array = DOUBLE( ISHFT( TEMPORARY(sample_array), -16 ) ) $
         ELSE array = TEMPORARY( sample_array )

         WRITEU, lun, array

      END

      ELSE: BEGIN
         MESSAGE, 'Data size case not matched.', /INFO
         return
      END 

   ENDCASE 

   return
END 

; _____________________________________________________________________________


PRO write_au, filename, data, SIZE=size, STYLE=style, RATE=rate, $
              CHANNELS=channels, COMMENT=comment, $
              OVERWRITE=overwrite, FAST=fast, LONG=long, $
              COUNT=count, VERBOSE=verbose

   STDERR = -2
   
   IF N_ELEMENTS( data ) LT 2 THEN BEGIN
      PRINTF, STDERR, "Data array not specified."
      return
   ENDIF 

   IF N_ELEMENTS( verbose ) LE 0 THEN verbose=0 ELSE verbose=1
   IF N_ELEMENTS( overwrite ) LE 0 THEN overwrite=0 ELSE overwrite=1

   IF N_ELEMENTS( size ) LE 0 THEN size = 'BYTE'
   IF N_ELEMENTS( style ) LE 0 THEN style = 'ULAW'
   IF N_ELEMENTS( rate ) LE 0 THEN rate = 8000
   IF N_ELEMENTS( channels ) LE 0 THEN channels = 1
   IF N_ELEMENTS( comment ) LE 0 THEN comment = ''

   sInfo = { size: size, $
             style: style, $
             rate: rate, $
             channels: channels, $
             comment: comment, $
             data_size: N_ELEMENTS( data ) }

   IF NOT overwrite THEN BEGIN
      
      path = FINDFILE( filename, COUNT=nfiles )
      
      IF nfiles GT 0 THEN BEGIN
         PRINTF, STDERR, "File "+filename+" exists."
         return
      ENDIF 

   ENDIF 

   OPENW, lun, filename, /GET_LUN

   sAu = put_au_header( lun, sInfo )

   IF verbose THEN HELP, /STR, sAu

   array = data
   raw_write, lun, array, sInfo.size, sInfo.style, FAST=fast, $
    LONG=long

   IF verbose THEN PRINTF, STDERR, "Wrote "+STRTRIM(sAu.data_size,2)+$
    " samples"
   
   FREE_LUN, lun

   count = sAu.data_size

END

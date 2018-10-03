;+
; $Id: snd_play.pro,v 1.1 2001/11/05 21:56:11 mccannwj Exp $
;
; NAME:
;     SND_PLAY
;
; PURPOSE:
;     Play a signal on the Sun audio device.
;
; CATEGORY:
;     ACS
;
; CALLING SEQUENCE:
;     SND_PLAY, signal, rate [, GAIN=, LOOP= ]
; 
; INPUTS:
;     signal - data array
;     rate   - sampling rate of data
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     GAIN - gain to apply to signal
;     LOOP - number of times to loop playback
;
; OUTPUTS:
;     sound at /dev/audio
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
;    Mon Oct 19 18:00:08 1998, William Jon McCann <mccannwj@acs10>
;
;		Created.
;
;-


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


FUNCTION index_to_seconds, index, rate
   
   seconds = index / FLOAT( rate )

   return, seconds
END 

; _____________________________________________________________________________


PRO snd_play, signal, rate, LOOP=loop, GAIN = gain

   IF N_ELEMENTS( loop ) LE 0 THEN loop = 0
   IF N_ELEMENTS( gain ) LE 0 THEN gain = 1.0

   IF N_ELEMENTS( signal ) LE 0 THEN BEGIN
      MESSAGE, 'No signal specified', /INFO
      return
   ENDIF

   IF N_ELEMENTS( rate ) LE 0 THEN BEGIN
      MESSAGE, 'No rate specified', /INFO
      return
   ENDIF

   signal_sz = SIZE( signal )

   type = signal_sz[ signal_sz[0] + 1 ]

   IF type EQ 3 THEN BEGIN
      array = ISHFT( LONG( signal * gain ), -16 ) + '8'XB
   ENDIF ELSE array = FIX( signal * gain )

   sound = linear_to_ulaw( array )
   seconds = index_to_seconds( N_ELEMENTS( sound ), rate )

   OPENW, lun, '/dev/audio', /GET_LUN, /NOSTDIO, ERROR = ioerror

   IF (ioerror EQ 0) THEN BEGIN

      FOR i=0L, loop DO BEGIN 
         
         WRITEU, lun, sound
         WAIT, seconds

      ENDFOR 
      FREE_LUN, lun

   ENDIF ELSE BEGIN

      PRINTF, -2, 'I/O error: ' + !ERR_STRING
   ENDELSE
   
END

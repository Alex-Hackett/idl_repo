;+
; $Id: sigv.pro,v 1.1 2001/11/05 21:55:19 mccannwj Exp $
;
; NAME:
;     SIGV
;
; PURPOSE:
;     To view a signal in both time and frequency domain.
;
; CATEGORY:
;     ACS
;
; CALLING SEQUENCE:
;     SIGV [, signal, RATE=, PSYM ]
; 
; INPUTS:
;
; OPTIONAL INPUTS:
;     signal - signal array
;      
; KEYWORD PARAMETERS:
;     RATE - sample rate of signal
;     PSYM - plot symbol to use
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;     Write Sun/NeXT AU format sound file.
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
;    Mon Oct 19 14:00:17 1998, William Jon McCann <mccannwj@acs10>
;		Created.
;
;-

; _____________________________________________________________________________


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

FUNCTION seconds_to_index, seconds, rate

   index = seconds * rate

   return, index
END 

FUNCTION index_to_hertz, index, elements, rate

   hertz = FLOAT( index * rate ) / ( 2.0 * elements )

   return, hertz
END 

FUNCTION hertz_to_index, hertz, elements, rate
   
   index = LONG( (hertz * 2.0 * elements) / rate )

   return, index
END 

; _____________________________________________________________________________


PRO redraw, sState

   save_win = !D.WINDOW

   min = sState.plot_min 
   max = sState.plot_max

   num = max - min + 1 > 2
   index = LINDGEN( num ) + min

   IF sState.bSignal EQ 1b THEN BEGIN

      IF sState.rate GT 0 THEN BEGIN
         index = index_to_seconds( TEMPORARY( index ), sState.rate )
         xtitle = 'Time (seconds)'
      ENDIF ELSE BEGIN
         xtitle = 'Samples'
      ENDELSE

      IF min LT 0 THEN min = 0
      IF max GT N_ELEMENTS( *sState.pSignal_left )-1 THEN $
       max = N_ELEMENTS( *sState.pSignal_left )-1

      WSET, sState.iDisplayLeft

      PLOT, index, (*sState.pSignal_left)[min:max], XSTYLE=1, $
       PSYM=sState.plot_psym, XTITLE=xtitle

      IF PTR_VALID( sState.pSignal_right ) THEN BEGIN
         WSET, sState.iDisplayRight

         PLOT, index, (*sState.pSignal_right)[min:max], XSTYLE=1, $
          PSYM=sState.plot_psym, XTITLE=xtitle

      ENDIF 

   ENDIF ELSE BEGIN

      IF sState.rate GT 0 THEN BEGIN
         index = index_to_hertz( index, N_ELEMENTS( *sState.pSpectra_left ), $
                                 sState.rate )
         xtitle = 'Frequency (Hz)'
      ENDIF ELSE BEGIN
         xtitle = 'Frequency'
      ENDELSE

      IF min LT 0 THEN min = 0
      IF max GT N_ELEMENTS( *sState.pSpectra_left )-1 THEN $
       max = N_ELEMENTS( *sState.pSpectra_left )-1

      WSET, sState.iDisplayLeft

      PLOT, index, (*sState.pSpectra_left)[min:max], XSTYLE=1, $
       PSYM=sState.plot_psym, XTITLE=xtitle

      IF PTR_VALID( sState.pSpectra_right ) THEN BEGIN

         WSET, sState.iDisplayRight
         
         PLOT, index, (*sState.pSpectra_right)[min:max], XSTYLE=1, $
          PSYM=sState.plot_psym, XTITLE=xtitle
         
      ENDIF
      
   ENDELSE 

   WSET, save_win

END 

; _____________________________________________________________________________


FUNCTION sigv_make_display, parent, STEREO=stereo, XSIZE=xsize, YSIZE=ysize, $
                            LEFT_ID=w_index_left, RIGHT_ID=w_index_right

   IF N_ELEMENTS( xsize ) LE 0 THEN xsize = 600
   IF N_ELEMENTS( ysize ) LE 0 THEN ysize = 200

                    ; if parent has childen then destroy them
   child = WIDGET_INFO( parent, /CHILD )
   IF child NE 0 THEN BEGIN
      
      WHILE ( WIDGET_INFO( child, /SIBLING ) ) NE 0 DO BEGIN
         sib = WIDGET_INFO( child, /SIBLING )
         WIDGET_CONTROL, sib, /DESTROY
      ENDWHILE
      
      WIDGET_CONTROL, child, /DESTROY
   ENDIF

   base = WIDGET_BASE(parent, /COLUMN, XPAD=0, YPAD=0,SPACE=0)

   wDisplayBaseLeft = WIDGET_BASE( base, /COLUMN )
   wDisplayDrawLeft = WIDGET_DRAW( wDisplayBaseLeft, $
                                   XSIZE=xsize, $
                                   YSIZE=ysize, $
                                   /BUTTON_EVENTS, $
                                   UVALUE='DRAW_LEFT' )

   WIDGET_CONTROL, wDisplayDrawLeft, GET_VALUE=w_index_left

   IF KEYWORD_SET( stereo ) THEN BEGIN

      wDisplayBaseRight = WIDGET_BASE( base, /COLUMN )
      wDisplayDrawRight = WIDGET_DRAW( wDisplayBaseRight, $
                                       XSIZE=xsize, $
                                       YSIZE=ysize, $
                                       /BUTTON_EVENTS, $
                                       UVALUE='DRAW_RIGHT' )

      WIDGET_CONTROL, wDisplayDrawRight, GET_VALUE=w_index_right

   ENDIF ELSE BEGIN
      wDisplayDrawRight = -1L
      w_index_right = -1L
   ENDELSE

   handles = [ wDisplayDrawLeft, wDisplayDrawRight ]

   return, handles
END

; _____________________________________________________________________________

PRO sigv_new_buffer, sState, input, rate, channels, FILENAME=filename

   IF N_ELEMENTS(filename) LE 0 THEN window_title='Sound' $
   ELSE window_title=STRTRIM(filename,2)
   IF N_ELEMENTS(input) GT 2 THEN BEGIN
      PTR_FREE, sState.pSignal_left, sState.pSignal_right
      PTR_FREE, sState.pSpectra_left, sState.pSpectra_right
      PTR_FREE, sState.pOutput
      
      IF channels EQ 2 THEN BEGIN
         factor = 8000 / FLOAT(rate)
         sampled_output = CONGRID(REFORM(input[*,0]), $
                                  N_ELEMENTS(input[*,0])*factor)
         HELP, sampled_output
         sState.pOutput = PTR_NEW(sampled_output, /NO_COPY)
         sState.pSignal_left = PTR_NEW( input[*,0], /NO_COPY )
         sState.pSignal_right = PTR_NEW( input[*,1], /NO_COPY )
      ENDIF ELSE BEGIN
         factor = 8000 / FLOAT(rate)
         HELP, factor
         sampled_output = CONGRID( input, $
                                   N_ELEMENTS(input)*factor )
         HELP, sampled_output
         sState.pOutput = PTR_NEW( sampled_output, /NO_COPY )
         sState.pSignal_left = PTR_NEW( input, /NO_COPY )
         sState.pSignal_right = PTR_NEW()
      ENDELSE
      sState.pSpectra_left = PTR_NEW()
      sState.pSpectra_right = PTR_NEW()

      sState.plot_min = 0L
      sState.plot_max = N_ELEMENTS( (*sState.pSignal_left) ) - 1

      WIDGET_CONTROL, sState.wSliderLeft, $
       SET_SLIDER_MAX=sState.plot_max
      WIDGET_CONTROL, sState.wSliderRight, $
       SET_SLIDER_MAX=sState.plot_max
      WIDGET_CONTROL, sState.wSliderLeft, $
       SET_VALUE=sState.plot_min
      WIDGET_CONTROL, sState.wSliderRight, $
       SET_VALUE=sState.plot_max

      sState.window_title = window_title
      WIDGET_CONTROL, sState.wRoot, TLB_SET_TITLE=window_title

      sState.rate = LONG( rate )
      
      WIDGET_CONTROL, sState.wDisplayLabel, SET_VALUE = 'Signal'
      
      IF channels EQ 2 THEN stereo = 1 ELSE stereo = 0

      handles = sigv_make_display( sState.wDisplayDrawBase, $
                                   LEFT_ID=left_id, $
                                   RIGHT_ID=right_id, $
                                   STEREO=stereo )

      sState.wDisplayLeft = handles[0]
      sState.wDisplayRight = handles[1]
      sState.iDisplayLeft = left_id
      sState.iDisplayRight = right_id

      sState.bSignal = 1b
      redraw, sState

   ENDIF
   
END

; _____________________________________________________________________________


PRO sigv_event, sEvent

                    ; get state information from first child of root
   child = WIDGET_INFO( sEvent.handler, /CHILD )
   infobase = WIDGET_INFO( child, /SIBLING )
   WIDGET_CONTROL, infobase, GET_UVALUE=sState, /NO_COPY 

   WIDGET_CONTROL, sEvent.id, GET_UVALUE=event_uval

   CASE STRUPCASE( event_uval ) OF

      'ROOT': BEGIN
         IF TAG_NAMES( sEvent, /STRUCTURE_NAME ) EQ 'WIDGET_KILL_REQUEST' $
          THEN BEGIN
            PTR_FREE, sState.pOutput
            PTR_FREE, sState.pSignal_left, sState.pSignal_right
            PTR_FREE, sState.pSpectra_left, sState.pSpectra_right
            WIDGET_CONTROL, sEvent.top, /DESTROY
         ENDIF 
      END

      'DRAW_LEFT': BEGIN 
         
         IF (sEvent.type EQ 1) THEN BEGIN

            CASE sEvent.release OF

               1: BEGIN

                  xyz = CONVERT_COORD( sEvent.x, sEvent.y, /DEVICE, /TO_DATA )
                  
                  IF sState.rate GT 0 THEN BEGIN

                     IF sState.bSignal EQ 1b THEN BEGIN
                        val = seconds_to_index(xyz[0],sState.rate) > 0 $
                         < (N_ELEMENTS(*sState.pSignal_left)-1)
                     ENDIF ELSE BEGIN
                        val=hertz_to_index(xyz[0], $
                                           N_ELEMENTS(*sState.pSpectra_left), $
                                           sState.rate ) $
                         > 0 < (N_ELEMENTS(*sState.pSpectra_left)-1)
                     ENDELSE

                  ENDIF ELSE val=xyz[0]>0<(N_ELEMENTS(*sState.pSignal_left)-1)

                  IF val LT 0 THEN val = 0
                  sState.plot_min = val
                  
                  IF sState.plot_min GT sState.plot_max THEN $
                   sState.plot_min = sState.plot_max

                  WIDGET_CONTROL, sState.wSliderLeft, SET_VALUE=sState.plot_min

                  redraw, sState
                  
               END 

               4: BEGIN

                  xyz = CONVERT_COORD( sEvent.x, sEvent.y, /DEVICE, /TO_DATA )

                  IF sState.rate GT 0 THEN BEGIN

                     IF sState.bSignal EQ 1b THEN BEGIN
                        val = seconds_to_index(xyz[0],sState.rate) > 0 $
                         < (N_ELEMENTS(*sState.pSignal_left)-1)                         
                     ENDIF ELSE BEGIN
                        val=hertz_to_index(xyz[0], $
                                           N_ELEMENTS(*sState.pSpectra_left), $
                                           sState.rate ) $
                         > 0 < (N_ELEMENTS(*sState.pSpectra_left)-1)
                     ENDELSE                         

                  ENDIF ELSE val=xyz[0]>0<(N_ELEMENTS(*sState.pSignal_left)-1)

                  sState.plot_max = val
                  
                  IF sState.plot_max LT sState.plot_min THEN $
                   sState.plot_max = sState.plot_min
                  
                  WIDGET_CONTROL, sState.wSliderRight,SET_VALUE=sState.plot_max

                  redraw, sState

               END 

               ELSE:

            ENDCASE 

         ENDIF
      END 

      'MENU': BEGIN

         CASE sEvent.value OF
            
            'File.Open.Sun AU': BEGIN
               file = DIALOG_PICKFILE(TITLE='Select Sun/NeXT AU file to read',$
                                      /MUST_EXIST )
               IF file NE '' THEN BEGIN
                  input = read_au( file, /VERBOSE, RATE=rate, $
                                   CHANNELS=channels, /SPLIT )
                  sigv_new_buffer, sState, input, rate, channels, $
                   FILENAME=file
              ENDIF 
            END 
            'File.Open.WAV': BEGIN
               file = DIALOG_PICKFILE(TITLE='Select WAV file to read',$
                                      /MUST_EXIST )
               IF file NE '' THEN BEGIN
                  input = READ_WAV(file, rate)
                  HELP, input
                  input_sz = SIZE(input)
                  channels = input_sz[0]
                  HELP, channels
                  IF channels GT 1 THEN input = TRANSPOSE(TEMPORARY(input))
                  HELP,input
                  ;;IF channels GT 1 THEN input=REFORM(input[0,*])
                  ;;channels=1
                  ;;HELP, input, rate
                  median_value = MEDIAN(input)
                  gain = (32768*0.9) / MAX(ABS(input))
                  HELP, gain
                  input = (TEMPORARY(input)-median_value)*gain
                  sigv_new_buffer, sState, input, rate, channels, $
                   FILENAME=file
              ENDIF 
            END 

            'File.Save': BEGIN
               file = DIALOG_PICKFILE(TITLE='Select Sun/NeXT AU file to write')
               IF file NE '' THEN BEGIN
                  num = write_au( file, (*sState.pSignal_left), /OVER )
                  WIDGET_CONTROL, sState.wRoot, TLB_SET_TITLE=file
               ENDIF

            END 

            'File.Play': BEGIN
               IF sState.rate GT 0 THEN BEGIN
                  signal = (*sState.pOutput)
                  WIDGET_CONTROL, sState.wRoot, TLB_SET_TITLE='Playing...'
                  snd_play, signal, 8000
                  signal = 0
                  WIDGET_CONTROL, sState.wRoot, $
                   TLB_SET_TITLE=sState.window_title
               ENDIF ELSE PRINTF, -2, "Sample rate not specified."
            END 

            'File.Loop': BEGIN
               IF sState.rate GT 0 THEN BEGIN
                  signal = (*sState.pOutput)
                  WIDGET_CONTROL, sState.wRoot, TLB_SET_TITLE='Playing...'
                  snd_play, signal, 8000, LOOP=5
                  signal = 0
                  WIDGET_CONTROL, sState.wRoot, $
                   TLB_SET_TITLE=sState.window_title
               ENDIF ELSE PRINTF, -2, "Sample rate not specified."
            END

            'File.Exit': BEGIN
               PTR_FREE, sState.pOutput
               PTR_FREE, sState.pSignal_left, sState.pSignal_right
               PTR_FREE, sState.pSpectra_left, sState.pSpectra_right
               WIDGET_CONTROL, sEvent.top, /DESTROY
               return
            END 
            
            'Tools.Xloadct': XLOADCT

            'Display.Signal': BEGIN
               sState.bSignal = 1b
               num = LONG( N_ELEMENTS( (*sState.pSignal_left) ) )-1
               WIDGET_CONTROL, sState.wSliderLeft, SET_SLIDER_MAX=num
               WIDGET_CONTROL, sState.wSliderRight, SET_SLIDER_MAX=num
               WIDGET_CONTROL, sState.wSliderLeft, SET_VALUE=0L
               WIDGET_CONTROL, sState.wSliderRight, SET_VALUE=num
               WIDGET_CONTROL, sState.wDisplayLabel, SET_VALUE='Signal'
               sState.plot_min = 0L
               sState.plot_max = num
               WIDGET_CONTROL, HOURGLASS=1
               redraw, sState
               WIDGET_CONTROL, HOURGLASS=0
            END 

            'Display.Spectra': BEGIN

               IF NOT PTR_VALID( sState.pSpectra_left ) THEN BEGIN

                  save_win = !D.WINDOW
                  WSET, sState.iDisplayLeft
                  ERASE
                  WSET, save_win

                  PTR_FREE, sState.pSpectra_left

                  fft = spectrum(*sState.pSignal_left)

                  sState.pSpectra_left = PTR_NEW( fft, /NO_COPY )
               ENDIF

               IF (NOT PTR_VALID( sState.pSpectra_right ) ) AND $
                ( PTR_VALID( sState.pSignal_right ) ) THEN BEGIN

                  save_win = !D.WINDOW
                  WSET, sState.iDisplayRight
                  ERASE
                  WSET, save_win

                  PTR_FREE, sState.pSpectra_right

                  fft = spectrum( *sState.pSignal_right )

                  sState.pSpectra_right = PTR_NEW( fft, /NO_COPY )
               ENDIF

               sState.bSignal = 0b
               
               num = N_ELEMENTS(*sState.pSpectra_left)-1
               
               WIDGET_CONTROL, sState.wSliderLeft, SET_SLIDER_MAX=num
               WIDGET_CONTROL, sState.wSliderRight, SET_SLIDER_MAX=num
               WIDGET_CONTROL, sState.wSliderLeft, SET_VALUE=0L
               WIDGET_CONTROL, sState.wSliderRight, SET_VALUE=num
               WIDGET_CONTROL, sState.wDisplayLabel, SET_VALUE='Spectrum'
               sState.plot_min = 0L
               sState.plot_max = num
               WIDGET_CONTROL, HOURGLASS=1
               redraw, sState
               WIDGET_CONTROL, HOURGLASS=0
            END 

            'Help.About': 

            'Help.Help': 
            
            ELSE:

         ENDCASE 

      END

      'SLIDER_LEFT': BEGIN
         sState.plot_min = sEvent.value

         IF sState.plot_min GT sState.plot_max THEN BEGIN
            sState.plot_min = sState.plot_max
            WIDGET_CONTROL, sState.wSliderLeft, SET_VALUE=sState.plot_min
         ENDIF

         redraw, sState
      END 
      
      'SLIDER_RIGHT': BEGIN
         sState.plot_max = sEvent.value

         IF sState.plot_max LT sState.plot_min THEN BEGIN
            sState.plot_max = sState.plot_min
            WIDGET_CONTROL, sState.wSliderRight, SET_VALUE=sState.plot_max
         ENDIF
         redraw, sState
      END 

      ELSE: MESSAGE, 'Case match not found: '+event_uval, /INFO

   ENDCASE

   IF WIDGET_INFO( infobase, /VALID_ID ) EQ 1 THEN BEGIN
                    ; restore state information
      WIDGET_CONTROL, infobase, SET_UVALUE=sState, /NO_COPY
   ENDIF

END

; _____________________________________________________________________________


PRO sigv, input1, input2, GROUP_LEADER=group, PSYM=psym, RATE=rate, $
          TITLE=window_title

; ---------------------------------------
; Check input
; ---------------------------------------

   IF N_ELEMENTS(window_title) LE 0 THEN window_title='Signal View'
   IF N_ELEMENTS( group ) LE 0 THEN group = 0
   IF N_ELEMENTS( input1 ) LE 0 THEN $
    input1=8e3*SIN(FINDGEN(4000)/20e*2*!PI)*SIN(FINDGEN(4000)/2000e*2*!PI)*$
    FINDGEN(4000)/4000e
   IF N_ELEMENTS( psym ) LE 0 THEN psym = 10
   IF N_ELEMENTS( rate ) LE 0 THEN rate = 8000L

   input_sz = SIZE( input1 )

   IF input_sz[0] EQ 2 THEN BEGIN
      signal2 = input1[*,1]
      signal1 = input1[*,0]
   ENDIF ELSE signal1 = input1

   IF N_ELEMENTS( signal2 ) LE 0 THEN stereo = 0 ELSE stereo = 1

   signal_sz = SIZE( signal1 )

; ---------------------------------------
; Define some stuff
; ---------------------------------------

   MenuList = [ '1\File', '1\Open', '0\Sun AU', '2\WAV', $
                '0\Play', '0\Loop', '0\Save', '2\Exit', $
                '1\Tools', '2\Xloadct', $
                '1\Display', '0\Signal', '2\Spectra', $
                '1\Help', '0\Help', '2\About' ]

   xsize = 600
   ysize = 200

; ---------------------------------------
; Build Widget
; ---------------------------------------

   wRoot = WIDGET_BASE(GROUP_LEADER=Group, UVALUE='ROOT', $
                       TITLE=window_title, $
                       COLUMN=1, MAP=1, MBAR=wMbar, /TLB_KILL_REQUEST_EVENTS)
   
   wBase = WIDGET_BASE(wRoot, /COLUMN, /FRAME, XPAD=0, YPAD=0, SPACE=0)

   wMenuBar = CW_PDMENU(wMbar, /RETURN_FULL_NAME, /MBAR, /HELP, $
                        MenuList, UVALUE='MENU')

   wDisplayBase = WIDGET_BASE(wBase, YPAD=0, XPAD=0, SPACE=0, /COLUMN)
   wDisplayLabel = WIDGET_LABEL(wDisplayBase, VALUE='Signal', $
                                /DYNAMIC_RESIZE )

   wDisplayDrawBase = WIDGET_BASE(wDisplayBase, /COLUMN, $
                                  XPAD=0,YPAD=0,SPACE=0)

   handles = sigv_make_display(wDisplayDrawBase, STEREO=stereo)

   wDisplayDrawLeft = handles[0]
   wDisplayDrawRight = handles[1]
   
   wDisplaySliderBase = WIDGET_BASE( wDisplayBase, /ROW, /ALIGN_CENTER, $
                                     XPAD=0, YPAD=0, SPACE=0)
   wDisplaySliderLeft = WIDGET_SLIDER(wDisplaySliderBase, MAX=signal_sz(1)-1,$
                                      XSIZE=xsize/2, YSIZE=10, VALUE=0L, $
                                      UVALUE='SLIDER_LEFT')
   wDisplaySliderRight = WIDGET_SLIDER(wDisplaySliderBase,MAX=signal_sz(1)-1,$
                                       XSIZE=xsize/2, YSIZE=10, $
                                       VALUE=signal_sz(1)-1,$
                                       UVALUE='SLIDER_RIGHT')

   WIDGET_CONTROL, /REALIZE, wBase

   WIDGET_CONTROL, wDisplayDrawLeft, GET_VALUE=w_index_left

   IF KEYWORD_SET( stereo ) THEN $
    WIDGET_CONTROL, wDisplayDrawRight, GET_VALUE=w_index_right $
   ELSE w_index_right = -1L

   factor = 8000 / FLOAT(rate)
   sampled_output = CONGRID( signal1, N_ELEMENTS(signal1)*factor )

   IF N_ELEMENTS( signal2 ) GT 0 THEN $
    pSignalRight = PTR_NEW( signal2, /NO_COPY ) $
   ELSE pSignalRight = PTR_NEW()

   sState = { wRoot: wRoot, $
              wBase: wBase, $
              wDisplayDrawBase: wDisplayDrawBase, $
              wDisplayLeft: wDisplayDrawLeft, $
              wDisplayRight: wDisplayDrawRight, $
              wDisplayLabel: wDisplayLabel, $
              wSliderLeft: wDisplaySliderLeft, $
              wSliderRight: wDisplaySliderRight, $
              iDisplayLeft: w_index_left, $
              iDisplayRight: w_index_right, $
              plot_min: 0L, $
              plot_max: LONG( signal_sz(1)-1 ), $
              plot_psym: psym, $
              bSignal: 1b, $
              rate: rate, $
              window_title: STRTRIM(window_title,2), $
              pOutput: PTR_NEW( sampled_output, /NO_COPY ), $
              pSignal_left: PTR_NEW( signal1, /NO_COPY ), $
              pSignal_right: pSignalRight, $
              pSpectra_left: PTR_NEW(), $
              pSpectra_right: PTR_NEW() }

   redraw, sState

                    ; save state information
   WIDGET_CONTROL, wBase, SET_UVALUE=sState, /NO_COPY

   XMANAGER, 'sigv', wRoot, /NO_BLOCK
   
END

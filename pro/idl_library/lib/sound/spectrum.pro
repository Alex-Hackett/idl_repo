;+
; $Id: spectrum.pro,v 1.1 2001/11/05 21:59:21 mccannwj Exp $
;
; NAME:
;     SPECTRUM
;
; PURPOSE:
;     Calculate the spectrum of a signal
;
; CATEGORY:
;     ACS/JHU
;
; CALLING SEQUENCE:
;     result = SPECTRUM(wave)
; 
; INPUTS:
;     wave - 1D signal array
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
;
;-
FUNCTION spectrum, wave, ALL=all, DEBUG=debug

   IF N_ELEMENTS( wave ) LT 2 THEN BEGIN
      PRINTF,-2,"Too few samples in array."
      return, -1
   ENDIF

                    ; round size up to power of 2 to make FFTs fast
   nx2 = 2L ^ LONG( ALOG( N_ELEMENTS( wave ) ) / ALOG( 2.0 ) )
   IF nx2 LT N_ELEMENTS( wave ) THEN nx2 = nx2 * 2L

   new_wave = FLTARR( nx2 )
   new_wave[0] = wave

   spectra = FFT(new_wave, -1)

   spectra = [spectra[0:LONG(N_ELEMENTS(wave)/2)],$
              spectra[N_ELEMENTS(spectra)-LONG(N_ELEMENTS(wave)/2)+1:*] ]

   IF NOT KEYWORD_SET( all ) THEN BEGIN
      middle = LONG( (N_ELEMENTS(spectra) - 1 ) / 2 )
      IF KEYWORD_SET( debug ) THEN HELP, middle
      spectra = spectra[ 0: middle ]
   ENDIF

   return, spectra
END 

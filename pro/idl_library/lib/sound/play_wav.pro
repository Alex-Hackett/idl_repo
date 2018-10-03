;+
; $Id: play_wav.pro,v 1.1 2001/11/05 21:52:18 mccannwj Exp $
;
; NAME:
;     PLAY_WAV
;
; PURPOSE:
;     Play a WAV file on Sun audio device
;
; CATEGORY:
;     ACS/Sound
;
; CALLING SEQUENCE:
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
;
;-
PRO PLAY_WAV, filename, LOOP=loop

   files=FINDFILE(filename,COUNT=nfiles)
   IF nfiles LE 0 THEN BEGIN
      MESSAGE, 'File not found: '+filename, /CONTINUE
      return
   ENDIF 
   input = READ_WAV(files[0], rate)

   input_sz = SIZE(input)
   channels = input_sz[0]
   IF channels GT 1 THEN input = TRANSPOSE(TEMPORARY(input))
   median_value = MEDIAN(input)
   gain = (32768*0.9) / MAX(ABS(input))

   input = (TEMPORARY(input)-median_value)*gain

   devrate = 8000
   IF channels EQ 2 THEN BEGIN
      factor = devrate / FLOAT(rate)
      sampled_output = CONGRID(REFORM(input[*,0]), $
                               N_ELEMENTS(input[*,0])*factor)
   ENDIF ELSE BEGIN
      factor = devrate / FLOAT(rate)
      sampled_output = CONGRID(input, N_ELEMENTS(input)*factor)
   ENDELSE

   snd_play, sampled_output, devrate, LOOP=loop
END 

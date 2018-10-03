;+
; $Id: acs_data_size.pro,v 1.1 2001/11/05 20:41:21 mccannwj Exp $
;
; NAME:
;     ACS_DATA_SIZE
;
; PURPOSE:
;     Routine to calculate data volume of a range database entries.
;
; CATEGORY:
;     ACS/JHU
;
; CALLING SEQUENCE:
;     ACS_DATA_SIZE, firstid, lastid
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
;       Mon Nov 5 15:40:34 2001, William Jon McCann <mccannwj@acs10>
;
;		Created header.
;
;-

FUNCTION acs_pix2bytes, n_pixels, DATA=data

   n_pixels = LONG(n_pixels)
   bits_per_pixel = 16
   bytes_per_bit = 1/8e
   bytes_per_pixel = bytes_per_bit * bits_per_pixel
   n_image_bytes = LONG(n_pixels * bytes_per_pixel)
   words_per_byte = 1 / 2e
   n_image_words = n_image_bytes * words_per_byte
   n_data_lines = 1 + ( ( LONG( n_image_words + 964 ) ) / 965 )
   n_data_bytes = LONG( n_data_lines * 1024 / words_per_byte )
   IF KEYWORD_SET( data ) THEN return, n_data_bytes
   return, n_image_bytes
END


FUNCTION acs_data_size, first, last

   IF N_PARAMS() NE 2 THEN BEGIN
      IF N_ELEMENTS(first) GT 1 THEN list=first ELSE list=[first]
   ENDIF ELSE list=LINDGEN(last[0]-first[0]+1)+first[0]

   dbopen,'acs_log'
   dbext, list, 'detector,ccdxsiz,ccdysiz',detector,ccdxsiz,ccdysiz
   
   n_pix = LONG(ccdxsiz)*LONG(ccdysiz)
                    ; patch with correct values
   wlist = WHERE(STRTRIM(detector,2) EQ 'WFC' AND n_pix EQ 0, wct)
   IF wct[0] GT 0 THEN BEGIN
      wpix = 4144*4136l
      n_pix[wlist] = wpix
   ENDIF 
                    ; patch with correct values
   hlist = WHERE(STRTRIM(detector,2) EQ 'HRC' AND n_pix EQ 0, hct)
   IF hct[0] GT 0 THEN BEGIN
      hpix = 1062*1044l
      n_pix[hlist] = hpix
   ENDIF 

   sizes = acs_pix2bytes(n_pix)
   ;;PRINT, sizes
   return, TOTAL(sizes)
END 

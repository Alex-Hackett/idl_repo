;+
; $Id: acs_dust_search.pro,v 1.1 2001/11/05 20:54:09 mccannwj Exp $
;
; NAME:
;     ACS_DUST_SEARCH
;
; PURPOSE:
;     Produce ratio images for analysis of filter dust search
;
; CATEGORY:
;     ACS/Analysis
;
; CALLING SEQUENCE:
;     result = ACS_DUST_SEARCH(entry1, entry2 [,bias_entry1 [,bias_entry2],
;                              /PRINT])
; 
; INPUTS:
;     entry1 - numerator image entry number
;     entry2 - denominator image entry number
;
; OPTIONAL INPUTS:
;     bias_entry1 - bias image entry number to subtract from entry1
;     bias_entry2 - bias image entry number to subtract from entry1
;
; KEYWORD PARAMETERS:
;     PRINT - create PostScript output 
;
; OUTPUTS:
;     result - Ratio image
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;     Uses ACS_IMAGE_PS
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;-
FUNCTION acs_dust_search, image1_id, image2_id, $
                          bias1_id, bias2_id, PRINT=print
   IF N_PARAMS() LT 2 THEN BEGIN
      PRINT, 'usage: div_array = ACS_DUST_SEARCH(id1,id2 [,bias_id1, bias_id2, /PRINT])'
   ENDIF

   ACS_READ, image1_id, h, /NODATA
   IF STRUPCASE(STRTRIM(SXPAR(h,'DETECTOR'),2)) EQ 'WFC' THEN n_chips=2 $
   ELSE n_chips = 1

   FOR chip=1,n_chips DO BEGIN
      PRINT, 'Chip '+STRTRIM(chip,2)
      IF N_ELEMENTS(bias1_id) GT 0 THEN BEGIN
         PRINT, '  reading bias1 '+STRTRIM(bias1_id,2)+'...'
         ACS_READ, bias1_id, h_b, bias1, CHIP=chip
      ENDIF ELSE bias1 = 0
      IF N_ELEMENTS(bias2_id) GT 0 THEN BEGIN
         PRINT, '  reading bias2 '+STRTRIM(bias2_id,2)+'...'
         ACS_READ, bias2_id, h_b, bias2, CHIP=chip
      ENDIF ELSE bias2 = 0
      PRINT, '  reading '+STRTRIM(image1_id,2)+'...'
      ACS_READ, image1_id, h1, d1, CHIP=chip
      PRINT, '  reading '+STRTRIM(image2_id,2)+'...'
      ACS_READ, image2_id, h2, d2, CHIP=chip

      image_sz = SIZE(d1)
      IF chip EQ 1 THEN BEGIN
         xover0 = 2
         xover1 = 16
      ENDIF ELSE BEGIN
         xover0 = image_sz[1] - 17
         xover1 = image_sz[1] - 2
      ENDELSE 

      IF N_ELEMENTS(bias1_id) LE 0 THEN bias1_level = 0 $
      ELSE bias1_level = MEDIAN(bias1[xover0:xover1,*])
      IF N_ELEMENTS(bias2_id) LE 0 THEN bias2_level = bias1_level $
      ELSE bias2_level = MEDIAN(bias2[xover0:xover1,*])

      im1_level = MEDIAN(d1[xover0:xover1,*])
      im2_level = MEDIAN(d2[xover0:xover1,*])

      bo1 = im1_level - bias1_level
      bo2 = im2_level - bias2_level
      HELP, bo1, bo2

      sub1 = TEMPORARY(d1) - (bias1+bo1[0])
      sub2 = TEMPORARY(d2) - (TEMPORARY(bias2)+bo2[0])

      div = TEMPORARY(sub1) / (FLOAT(TEMPORARY(sub2)) > 1e-6)

      IF n_chips GT 1 THEN BEGIN
         s0 = 0 + 2068*(chip-1)
         s1 = 2067 + 2068*(chip-1)
         IF chip EQ 1 THEN div_full = MAKE_ARRAY(image_sz[1],image_sz[2]*2,/FLOAT)
         div_full[0,s0] = TEMPORARY(div)
      ENDIF ELSE div_full = TEMPORARY(div)
   ENDFOR 

   IF KEYWORD_SET(print) THEN BEGIN
      sx0 = image_sz[1]/2 - 50
      sx1 = sx0 + 100
      sy0 = image_sz[2]/2 - 50
      sy1 = sy0 + 100
      PRINT, 'calculating scaling...'
      std = STDDEV(div_full[sx0:sx1,sy0:sy1])*2
      minimum = 1-std > 0
      maximum = 1+std < 2
      title_left = 'Filter Dust Search'
      title_right = 'Entry '+STRTRIM(image1_id,2)+'/'+STRTRIM(image2_id,2)
      label_col1 = MAKE_ARRAY(3, /STRING)
      label_col1[1] = 'Filter1: '+STRTRIM(SXPAR(h1,'FILTER1'),2)
      label_col1[2] = 'Filter2: '+STRTRIM(SXPAR(h2,'FILTER2'),2)
      PRINT, 'creating postscript...'
      HELP, div_full, title_left, title_right, label_col1, minimum, maximum
      filename = 'dust_search.ps'
      acs_image_ps, div_full, TITLE_LEFT=title_left, TITLE_RIGHT=title_right,$
       LABEL_COL1=label_col1, MINIMUM=minimum, MAXIMUM=maximum, $
       FILENAME=filename
      WAIT, .5
      IF STRUPCASE(!VERSION.OS_FAMILY) EQ 'UNIX' THEN $
       SPAWN, 'lp '+filename
   ENDIF 

   return, div_full
END 

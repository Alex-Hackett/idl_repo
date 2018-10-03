;+
; $Id: acs_ratio.pro,v 1.1 2001/11/05 20:58:32 mccannwj Exp $
;
; NAME:
;     ACS_RATIO
;
; PURPOSE:
;     Produce ratio images for analysis
;
; CATEGORY:
;     ACS/Analysis
;
; CALLING SEQUENCE:
;     result = ACS_RATIO(entry1, entry2 [,bias_entry1 [,bias_entry2],
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
FUNCTION acs_ratio, image1_id, image2_id, $
                          bias1_id, bias2_id, PRINT=print, DEBUG=debug
   IF N_PARAMS() LT 2 THEN BEGIN
      PRINT, 'usage: div_array = ACS_RATIO(id1,id2 [,bias_id1, bias_id2, /PRINT])'
   ENDIF

   im1stats = acs_image_stats(image1_id)
   im2stats = acs_image_stats(image2_id)

   ACS_READ, image1_id, h, /NODATA
   detector = STRUPCASE(STRTRIM(SXPAR(h,'DETECTOR'),2))
   ccdamps = STRUPCASE(STRTRIM(SXPAR(h,'CCDAMP'),2))
   IF (detector EQ 'WFC') AND (STRLEN(ccdamps) GT 2) THEN BEGIN
      n_chips=2 
   ENDIF ELSE n_chips = 1

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

      IF KEYWORD_SET(debug) THEN BEGIN
         HELP, d1, d2, xover0, xover1
      ENDIF 
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
      med = MEDIAN(div_full[sx0:sx1,sy0:sy1])
      minimum = med-std > 0
      maximum = med+std < 2
      title_left = 'Ratio Image'
      title_right = 'Entry '+STRTRIM(image1_id,2)+'/'+STRTRIM(image2_id,2)
      label_col1 = MAKE_ARRAY(3, /STRING)
      label_col1[0] = 'Entry '+STRTRIM(image1_id,2)
      label_col1[1] = 'Filter1: '+STRTRIM(SXPAR(h1,'FILTER1'),2)
      label_col1[2] = 'Filter2: '+STRTRIM(SXPAR(h1,'FILTER2'),2)
      label_col2 = MAKE_ARRAY(3, /STRING)
      label_col2[0] = 'Entry '+STRTRIM(image2_id,2)
      label_col2[1] = 'Filter1: '+STRTRIM(SXPAR(h2,'FILTER1'),2)
      label_col2[2] = 'Filter2: '+STRTRIM(SXPAR(h2,'FILTER2'),2)
      PRINT, 'creating postscript...'
      HELP, div_full, title_left, title_right, label_col1, minimum, maximum
      filename = 'acs_ratio.ps'
      acs_image_ps, div_full, TITLE_LEFT=title_left, TITLE_RIGHT=title_right,$
       LABEL_COL1=label_col1, LABEL_COL2=label_col2, $
       MINIMUM=minimum, MAXIMUM=maximum, $
       FILENAME=filename, /NO_INVERT
      WAIT, .5
      IF STRUPCASE(!VERSION.OS_FAMILY) EQ 'UNIX' THEN $
       SPAWN, 'lp '+filename
   ENDIF 

   return, div_full
END 

;
;+
; NAME:
;
;       STACK_FRAMES
;
; PURPOSE:
;
;   Compute the SUM, MEAN, MEDIAN or SIGMA-CLIPPED AVERAGE of a set of 2-D images.
;
; DESCRIPTION:
;
;   Compute the SUM, the MEAN, the MEDIAN or the SIGMA-CLIPPED AVERAGE
;   of a set of 2-D images.
;   Expecially drawn for astronomical pourpses to combine various images
;   with cosmic rays removal.
;   Also returns the cosmic rays mask and the original images with the cosmic rays removed.
;
;
; CATEGORY:
;
;       Image Processing.
;
; CALLING SEQUENCE:
;
;   Result = STACK_FRAMES(Image_Cube, METHOD = METHOD, THRESHOLD = THRESHOLD, FRAMES_NO_CR = FRAMES_NO_CR, $
;           CR_MASKS = CR_MASKS, SUBST_VALUE = SUBST_VALUE, MIN_VALUE)
;
;
; INPUTS:
;
;   Image_Cube: 3-D array which contains all the images to be combined, of size [N, LX, LY],
;     where N is the number of images of size LX*LY.
;
;
; KEYWORD PARAMETERS:
;
;   METHOD: string, one of these:
;     'ADD':          simple pixel to pixel sum of all the images;
;     'AVERAGE':        pixel to pixel arithmetic average of all the images;
;     'MEDIAN':       pixel to pixel median of all the images;
;     'AVERAGE & CR REMOVAL': pixel to pixel average of the only not cosmic rays values (see Procedure).
;
;       THRESHOLD: sigma-clipping threshold for the cosmic rays identification (only with METHOD='AVERAGE & CR REMOVAL').
;
;       FRAMES_NO_CR: output 3-D array which will contain a copy of Image_Cube in which the cosmic rays in each image
;     are replaced with the sigma-clipped average of Image_Cube (only with METHOD='AVERAGE & CR REMOVAL').
;
;   CR_MASKS: output 3-D array of the same size of image_Cube with the cosmic ray masks for each image.
;     The cosmic ray masks are defined as follows: 0 = pixel with cosmic ray, 1 = good pixel.
;
;   SUBST_VALUE: if it happens for a pixel that it is a cosmic ray in all the images, then it is replaced by
;     this value in the combined image; default is 0. (Only with METHOD='AVERAGE & CR REMOVAL').
;
;       MIN_VALUE: pixel value under which the pixel is considered a bad pixel, default = 0.
;     If set, these pixels are also added in the cosmic ray mask and avoided in the computation of the average.
;     (Only with METHOD='AVERAGE & CR REMOVAL').
;
;
; OUTPUTS:
;
;       The function returns a 2-D image whoich is the combination of the images in Image_Cube by the selected METHOD.
;
;
; PROCEDURE:
;
;   When METHOD='AVERAGE & CR REMOVAL' the procedure makes a two-pass iteration:
;   the first step marks as cosmic rays the pixel [*,x,y] if it deviates from the median
;   more than threshold times the median of the root of the median square deviation, i.e. if:
;
;   image[x,y] - median(Image_Cube[*,x,y])  GT  threshold * SQRT( median( (image[x,y] - median(Image_Cube[*,x,y]))^2 ) )
;
;   The second step does the same but respect to the median computed among the only pixels
;   not yet marked as cosmic rays, i.e. the pixel [*,x,y] is marked as cosmic ray if:
;
;
;   image[x,y] - median(Image_Cube[good,x,y])  GT  threshold * SQRT( median( (image[x,y] - median(Image_Cube[good,x,y]))^2 ) )
;
;   where 'good' indicates the images for which [x,y] is not already marcked as cosmic ray.
;   Finally the average of the only not marked pixels are computed.
;
;
; MODIFICATION HISTORY:
;
;       Feb 2004 -  Gianluca Li Causi, INAF - Rome Astronomical Observatory
;         licausi@mporzio.astro.it
;         http://www.mporzio.astro.it/~licausi/
;
;-

FUNCTION Stack_Frames, image_cube, METHOD = METHOD, FRAMES_NO_CR = frames_no_cr, $
            CR_MASKS = cr_masks, subst_value = subst_value, threshold = threshold, min_value=min_value


;Inizia il programma
s = size(image_cube)
n_img = s[1]
lx = s[2]
ly = s[3]

IF NOT KEYWORD_SET(min_value) THEN min_value = min(Image_Cube)-1    ;threshold al di sotto della quale sono considerati bad pixel

IF NOT KEYWORD_SET(subst_value) THEN subst_value = 0

stacked = fltarr(lx,ly)

cr = bytarr(n_img,lx,ly)


CASE METHOD OF
'ADD':    BEGIN
      FOR x = 0, lx-1 DO BEGIN
        FOR y = 0, ly-1 DO BEGIN
          vec = image_cube[*,x,y]
          stacked[x,y] = TOTAL(vec)   ;SOMMA finale
        ENDFOR
      ENDFOR
      END
'AVERAGE':  BEGIN
      FOR x = 0, lx-1 DO BEGIN
        FOR y = 0, ly-1 DO BEGIN
          vec = image_cube[*,x,y]
          stacked[x,y] = MEAN(vec)    ;SOMMA finale
        ENDFOR
      ENDFOR
      END
'MEDIAN': BEGIN
      FOR x = 0, lx-1 DO BEGIN
        FOR y = 0, ly-1 DO BEGIN
          vec = image_cube[*,x,y]
          stacked[x,y] = MEDIAN(vec)    ;SOMMA finale
        ENDFOR
      ENDFOR

      END
'AVERAGE & CR REMOVAL': BEGIN
      FOR x = 0, lx-1 DO BEGIN
        FOR y = 0, ly-1 DO BEGIN
          ;Prima iterazione
          vec = image_cube[*,x,y]
          index_good_pix = where(vec GE min_value, count)       ;good pixels
          IF count GT 0 THEN BEGIN        ;Se ci sono pixel buoni
            dev = vec[index_good_pix] - median(vec[index_good_pix]) ;deviazioni dalla mediana
            sig_frames = SQRT(median(dev*dev))            ;stdev con la mediana
            index_no_cr = where(dev LE threshold*sig_frames, count) ;indici dei pixel senza CR all'interno di index_good_pix
            IF count GT 0 THEN BEGIN      ;Se tra i pixel buoni ci sono pixel senza CR
              ;Seconda iterazione
              indexes = index_good_pix[index_no_cr]
              dev = vec[index_good_pix] - median(vec[indexes])  ;dev dalla nuova mediana
              sig_frames = SQRT(median(dev*dev))          ;nuova stdev con la mediana
              index_no_cr = where(dev LE threshold*sig_frames)  ;indici dei pixels senza CR all'interno di index_good_pix
              indexes = index_good_pix[index_no_cr]       ;indici su vec
              cr[indexes, x,y] = 1                ;0=cr, 1=buono
            ENDIF ELSE cr[index_good_pix, x,y] = 0          ;0=bad pixel
          ENDIF ELSE cr[*, x,y] = 0                 ;0=bad pixel


          CASE n_elements(indexes) OF
            0:  BEGIN
              stacked[x,y] = subst_value
              END
            1:  BEGIN
              stacked[x,y] = vec[indexes]
              END
          ELSE: BEGIN
              stacked[x,y] = mean(vec[indexes])   ;AVERAGE finale
              END
          ENDCASE

        ENDFOR
      ENDFOR
      END
ELSE:   BEGIN
      Message, 'Wrong METHOD keyword in call to Stack_Frames.pro!'
      END
ENDCASE



frames_no_cr = fltarr(n_img, lx, ly)
FOR i = 0, n_img-1 DO frames_no_cr[i,*,*] = image_cube[i,*,*] * cr[i,*,*] + stacked * (1. - cr[i,*,*])  ;sostituzione dei CR con la stacked image


cr_masks = cr


RETURN, stacked

END
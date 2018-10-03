;+
; $Id: statbox.pro,v 1.3 1999/08/13 21:18:23 mccannwj Exp $
;
; NAME:
;     STATBOX
;
; PURPOSE:
;     Compute mean and variance statistics in square boxes over a pair
;     of images.
;
; CATEGORY:
;     ACS/JHU
;
; CALLING SEQUENCE:
;     result = STATBOX( image1, image2, bias [, MASK=, BOXSIZE=, $
;                       SIGMA=, NITER=, REGION=, MAP_MEAN=, MAP_VAR=, $
;                       /NOOVER, /NOCLIP, /USEMEDIAN, /VERBOSE ] )
; 
; INPUTS:
;     image1 - (2D ARRAY) first image to process.
;     image2 - (2D ARRAY) second image to process.
;     bias   - (2D ARRAY) bias frame to process.
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     MASK - (2D ARRAY) pixel mask image.  Pixel set to unity for good
;             pixels and zero for ignored pixels.
;     REGION - (ARRAY) An array of the form [x0,x1,y0,y1] used to
;               specify the region of interest in the images.  The
;               region lying outside is ignored.
;     BOXSIZE - (INTEGER) specify the square box width in
;                pixels. Default is 10 pixels.
;     SIGMA - (INTEGER) specify the number of sigma in a box above
;              which a pixel will be flagged as bad and ignored.
;     NITER - (INTEGER) specify the number of iterations of pixel rejection.
;     MAP_MEAN - (VARIABLE) named variable to receive an 2D image map
;                 of computed mean values.  The "pixellation" of the
;                 image is determined by BOXSIZE. 
;     MAP_VARIANCE - (VARIABLE) named variable to receive an 2D image map
;                 of computed variance values.  The "pixellation" of
;                 the image is determined by BOXSIZE. 
;     USEMEDIAN - (BOOLEAN) set to use median instead of mean in all
;                  calculations.
;     NOCLIP - (BOOLEAN) if set no sigma pixel rejection will be
;               done. Ie. all pixels will be used in the calculations.
;     NOOVER - (BOOLEAN) if set the bias frame level is not scaled by the
;               trailing overscan of the image.
;     VERBOSE - (BOOLEAN) set to show verbose messages.
;
; OUTPUTS:
;     result - (2D ARRAY) [ [mean], [variance] ] The computed mean and
;               variance vectors.  Each element corresponds to one box.
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
;    Mon Nov 16 15:04:56 1998, William Jon McCann <mccannwj@acs10>
;
;		written.
;
;-

FUNCTION statbox, image1, image2, bias1, bias2, MASK=mask, BOXSIZE=box_size, $
                  SIGMA = sigma, USEMEDIAN = usemedian, REGION=region, $
                  VERBOSE = verbose, NITERATIONS = n_iterations, $
                  MAP_VARIANCE=variance_map, MAP_MEAN=mean_map, $
                  NOOVER = no_overscan, NOCLIP = noclip, $
                  CLIP_BEFORE = clip_before

   IF N_PARAMS() LT 3 THEN BEGIN
      MESSAGE, 'result = statbox( image1, image2, bias [,bias2] )', /CONT
      return, -1
   ENDIF 

   IF ( N_ELEMENTS( image1 ) NE N_ELEMENTS( image2 ) ) THEN BEGIN
      MESSAGE, 'image arrays must be same size', /CONT
      return, -1
   ENDIF

   IF N_ELEMENTS( mask ) LT 2 THEN mask = 1b + image1 * 0b
   IF N_ELEMENTS( box_size ) LE 0 THEN box_size = 10
   IF N_ELEMENTS( sigma ) LE 0 THEN sigma = 4
   IF N_ELEMENTS( n_iterations ) LE 0 THEN n_iterations = 2

   image_sz = SIZE( image1 )

   IF N_ELEMENTS( region ) NE 4 THEN $
    region = [0L,image_sz(1)-1,0L,image_sz(2)-2]

;   nxbox = CEIL( (region(1) - region(0) ) / FLOAT( box_size ) )
;   nybox = CEIL( (region(3) - region(2) ) / FLOAT( box_size ) )

   nxbox = FLOOR( (region(1) - region(0) ) / FLOAT( box_size ) ) > 1
   nybox = FLOOR( (region(3) - region(2) ) / FLOAT( box_size ) ) > 1

   variance_array = DBLARR( nxbox * nybox )
   mean_array = DBLARR( nxbox * nybox )
   mean_array = DBLARR( nxbox * nybox )

   variance_map = 0D * image1
   mean_map = 0D * image1

                    ; Use trailing overscan to scale bias frame
   IF NOT KEYWORD_SET( no_overscan ) THEN BEGIN
      
      bias1_over = bias1[ image_sz[1]-17:image_sz[1]-2, * ]
      IF N_ELEMENTS( bias2 ) GT 0 THEN BEGIN
         bias2_over = bias2[ image_sz[1]-17:image_sz[1]-2, * ]
      ENDIF ELSE BEGIN
         bias2_over = bias1[ image_sz[1]-17:image_sz[1]-2, * ]
      ENDELSE

      image1_over = image1[ image_sz[1]-17:image_sz[1]-2, * ]
      image2_over = image2[ image_sz[1]-17:image_sz[1]-2, * ]
      ;;image_over = (  image1_over + image2_over ) / 2d

                    ; Additive offset to bias frame
      bias1_offset = MEDIAN( image1_over - bias1_over )
      bias2_offset = MEDIAN( image2_over - bias2_over )
   ENDIF ELSE BEGIN
      bias1_offset = 0d
      bias2_offset = 0d
   ENDELSE 

   IF KEYWORD_SET( verbose ) THEN BEGIN
      PRINTF, -2, FORMAT='(/,"Bias1 offset: ",d)', bias1_offset
      PRINTF, -2, FORMAT='("Bias2 offset: ",d)', bias2_offset
      
      IF KEYWORD_SET( usemedian ) THEN PRINTF, -2, 'Using MEDIAN statistics' $
      ELSE PRINTF, -2, 'Using MEAN statistics'
      IF NOT KEYWORD_SET( noclip ) THEN BEGIN
         strFormat = '("Rejecting pixels above ",I0," sigma in each box")'
         PRINTF, -2, FORMAT=strFormat, sigma
         IF KEYWORD_SET( clip_before ) THEN $
          PRINTF, -2, '   BEFORE image combination.'
         PRINTF, -2, FORMAT='("Running ",I0," iterations.")', n_iterations
      ENDIF ELSE PRINTF, -2, FORMAT='("No deviant pixel rejection")'

      PRINTF, -2, FORMAT='(" Processing ",A," cols.",/," col ",$)', $
       STRTRIM(nybox,2)
   ENDIF 

   FOR j = 0L, nybox - 1L DO BEGIN

      y0 = region(2) + j * box_size
      y1 = region(2) + ( (j + 1) * box_size - 1 ) < region(3)

      IF KEYWORD_SET( verbose ) THEN PRINTF,-2,FORMAT='(1X,A,$)',STRTRIM(j,2)

      FOR i = 0L, nxbox - 1L DO BEGIN 
         x0 = region(0) + i * box_size
         x1 = region(0) + ( (i + 1) * box_size - 1 ) < region(1)

         maskbox1 = mask( x0:x1, y0:y1 )
         maskbox2 = mask( x0:x1, y0:y1 )
         maskboxb = mask( x0:x1, y0:y1 )
         maskbox_diff = mask( x0:x1, y0:y1 )
         maskbox_avg = mask( x0:x1, y0:y1 )

         IF KEYWORD_SET( clip_before ) THEN BEGIN
           
            FOR reject_iter = 0, n_iterations-1 DO BEGIN

                    ; ____________________

                    ; Do BIAS1
                    ; ____________________

               wpixb = WHERE( maskboxb )

               pixb = ( bias1[ x0:x1, y0:y1 ] )[wpixb]
               imageb_sigma = STDDEV( pixb, /DOUBLE )

               IF KEYWORD_SET( usemedian ) THEN imageb_avg = MEDIAN( pixb ) $
               ELSE imageb_avg = MEAN( pixb, /DOUBLE )

               imageb_dev = bias1[ x0:x1, y0:y1 ] - imageb_avg

               imageb_big_index = WHERE( ABS( imageb_dev ) GT $
                                         sigma*imageb_sigma,imageb_big_count )

               IF imageb_big_count GT 0 THEN BEGIN
                  maskboxb[ imageb_big_index ] = 0b
                  IF KEYWORD_SET( newval ) THEN BEGIN
                     temparr = bias1[ x0:x1, y0:y1 ]
                     temparr[ imageb_big_index ] = imageb_avg
                     bias1[ x0, y0 ] = temparr
                  ENDIF
               ENDIF

                    ; ____________________

                    ; Do BIAS2
                    ; ____________________

               IF N_ELEMENTS( bias2 ) GT 0 THEN begin
                  pixb = ( bias2[ x0:x1, y0:y1 ] )[wpixb]
                  imageb_sigma = STDDEV( pixb, /DOUBLE )
                  
                  IF KEYWORD_SET( usemedian ) THEN imageb_avg = MEDIAN(pixb) $
                  ELSE imageb_avg = MEAN( pixb, /DOUBLE )

                  imageb_dev = bias2[ x0:x1, y0:y1 ] - imageb_avg
                  
                  imageb_big_index = WHERE(ABS(imageb_dev) GT $
                                           sigma*imageb_sigma,imageb_big_count)
                  
                  IF imageb_big_count GT 0 THEN BEGIN
                     maskboxb[ imageb_big_index ] = 0b
                     IF KEYWORD_SET( newval ) THEN BEGIN
                        temparr = bias2[ x0:x1, y0:y1 ]
                        temparr[ imageb_big_index ] = imageb_avg
                        bias2[ x0, y0 ] = temparr
                     ENDIF
                  ENDIF
               ENDIF ELSE BEGIN
               ENDELSE 

                    ; ____________________

                    ; Do IMAGE1 and IMAGE2
                    ; ____________________

               wpix1 = WHERE( maskbox1 )
               wpix2 = WHERE( maskbox2 )

               pix1 = ( image1[x0:x1,y0:y1] )[wpix1]
               pix2 = ( image2[x0:x1,y0:y1] )[wpix2]

               sig1 = STDDEV( pix1, /DOUBLE )
               sig2 = STDDEV( pix2, /DOUBLE )

               IF KEYWORD_SET( usemedian ) THEN BEGIN
                  avval1 = MEDIAN( pix1 )
                  avval2 = MEDIAN( pix2 )
               ENDIF ELSE BEGIN
                  avval1 = MEAN( pix1, /DOUBLE )
                  avval2 = MEAN( pix2, /DOUBLE )
               ENDELSE

                    ; Find deviant points 
                    ; (ie greater than SIGMA stdevs from average )
               wbig1 = WHERE( ABS( image1[ x0:x1, y0:y1 ] - avval1 ) $
                              GT sigma * sig1, cwbig1 )
               wbig2 = WHERE( ABS( image2[ x0:x1, y0:y1 ] - avval2 ) $
                              GT sigma * sig2, cwbig2 )

               IF cwbig1 GT 0 THEN BEGIN            
                    ; If deviant point, set mask to zero
                  maskbox1[ wbig1 ] = 0b

                  IF KEYWORD_SET( newval ) THEN BEGIN
                     temparr = image1[ x0:x1, y0:y1 ]
                     temparr[ wbig1 ] = avval1
                     image1[ x0, y0 ] = temparr
                  ENDIF

               ENDIF

               IF cwbig2 GT 0 THEN BEGIN
                    ; If deviant point, set mask to zero
                  maskbox2[ wbig2 ] = 0b

                  IF KEYWORD_SET( newval ) THEN BEGIN
                     temparr = image2[ x0:x1, y0:y1 ]
                     temparr[ wbig2 ] = avval2
                     image2[ x0, y0 ] = temparr
                  ENDIF

               ENDIF

            ENDFOR

         ENDIF

                    ; ____________________
         
                    ; Combine images
                    ; ____________________

                    ; VAR( DN ) * gain = DN
                    ; ( VAR( IM1 - IM2 ) * gain ) / 2 = DN

         d1 = image1[ x0:x1, y0:y1 ] - bias1[ x0:x1, y0:y1 ] - bias1_offset
         IF N_ELEMENTS( bias2 ) LE 0 THEN BEGIN
            d2 = image2[ x0:x1, y0:y1 ] - bias1[ x0:x1, y0:y1 ] - bias2_offset
         ENDIF ELSE BEGIN 
            d2 = image2[ x0:x1, y0:y1 ] - bias2[ x0:x1, y0:y1 ] - bias2_offset
         ENDELSE 

         image_diff = d1 - d2
         image_avg = (d1 + d2) / 2d

                    ; ____________________
         
                    ; Pixel rejection
                    ; ____________________

         IF (NOT KEYWORD_SET( noclip ) ) AND $
          (NOT KEYWORD_SET( clip_before ) ) THEN BEGIN
           
            FOR reject_iter = 0, n_iterations-1 DO BEGIN
               wpix1 = WHERE( maskbox_diff )
               wpix2 = WHERE( maskbox_avg )

               pix1 = image_diff[wpix1]
               pix2 = image_avg[wpix2]
               
               sig1 = STDDEV( pix1, /DOUBLE )
               sig2 = STDDEV( pix2, /DOUBLE )

               IF KEYWORD_SET( usemedian ) THEN BEGIN
                  avval1 = MEDIAN( pix1 )
                  avval2 = MEDIAN( pix2 )
               ENDIF ELSE BEGIN
                  avval1 = MEAN( pix1, /DOUBLE )
                  avval2 = MEAN( pix2, /DOUBLE )
               ENDELSE

                    ; Find deviant points 
                    ; (ie greater than SIGMA stdevs from average )
               wbig1 = WHERE( ABS( image_diff - avval1 ) GT sigma * sig1, cwbig1 )
               IF cwbig1 GT 0 THEN BEGIN
                    ; If deviant point, set mask to zero
                  maskbox_diff[ wbig1 ] = 0b
               ENDIF
               wbig2 = WHERE( ABS( image_avg - avval2 ) GT sigma * sig2, cwbig2 )
               IF cwbig2 GT 0 THEN BEGIN
                    ; If deviant point, set mask to zero
                  maskbox_diff[ wbig2 ] = 0b
               ENDIF

            ENDFOR

         ENDIF

                    ; ____________________
         
                    ; Compute statistics
                    ; ____________________

         mask( x0, y0 ) = maskbox1 AND maskbox2 AND maskboxb AND $
          maskbox_diff AND maskbox_avg
         good_pix = WHERE( mask[ x0:x1, y0:y1 ], good_pix_count )

         IF good_pix_count GT 0 THEN BEGIN

            IF KEYWORD_SET( usemedian ) THEN BEGIN
               mean = MEDIAN( image_avg[good_pix]  )
            ENDIF ELSE BEGIN
               mean = TOTAL( image_avg[good_pix], /DOUBLE ) / good_pix_count
            ENDELSE

            moments = MOMENT( image_diff[ good_pix ], /DOUBLE )

            variance = moments[1] / 2D

         ENDIF ELSE BEGIN
            mean = -1d
            variance = -1d
         ENDELSE

         mean_array[j*nxbox + i] = mean
         variance_array[j*nxbox + i] = variance
         
         variance_map[ x0:x1, y0:y1 ] = variance
         mean_map[ x0:x1, y0:y1 ] = mean
         
      ENDFOR 

   ENDFOR

   IF KEYWORD_SET( verbose ) THEN PRINTF, -2, ''

   return, [ [mean_array], [variance_array] ]
END

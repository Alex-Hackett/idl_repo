;+
; $Id: azimuthal_avg.pro,v 1.1 2001/11/05 21:28:09 mccannwj Exp $
;
; NAME:
;     AZIMUTHAL_AVG
;
; PURPOSE:
;     Compute the azimuthal average around a specified position
;
; CATEGORY:
;     ACS/JHU
;
; CALLING SEQUENCE:
;     result = AZIMUTHAL_AVG(image, xcenter, ycenter, RADIUS=max_rad, $
;                            BAND=band_size)
; 
; INPUTS:
;     image - 2D array
;     xcenter, ycenter - coordinate of center position
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
;       Thu Jun 15 21:14:25 2000, William Jon McCann
;       <mccannwj@acs13.+ball.com>
;         Pulled out of mview.pro
;-

FUNCTION azimuthal_avg, image, xcenter, ycenter, RADIUS=max_rad, $
                        BAND=band_size
   COMPILE_OPT IDL2

   IF N_ELEMENTS( image ) LE 4 THEN BEGIN
      MESSAGE, 'image not specified', /CONT
      return, [0,0]
   ENDIF
   IF N_ELEMENTS( band_size ) LE 0 THEN band_size = 1

   image_sz = SIZE( image )
   small_axis = ( image_sz[1] - xcenter ) < ( image_sz[2] - ycenter )

   IF N_ELEMENTS( max_rad ) LE 0 THEN max_rad = 50 < small_axis

   x_dist = LINDGEN( image_sz[1] ) # REPLICATE( 1D, image_sz[2] )
   x_dist = ( x_dist - xcenter )
   y_dist = REPLICATE( 1D, image_sz[1] ) # LINDGEN( image_sz[2] )
   y_dist = ( y_dist - ycenter )

   radial_dist = SQRT( x_dist ^ 2 + y_dist ^ 2 )

   num_rings = FLOOR( max_rad / ( band_size > 1 ) )

   azimuth_avg = DBLARR( num_rings )
   encircled_e = DBLARR( num_rings + 1 )

   FOR i = 0L, num_rings - 1 DO BEGIN

      range = WHERE( radial_dist GE (band_size * i) AND $
                     radial_dist LT (band_size * (i + 1)), range_count )

      IF range_count GT 0 THEN BEGIN
         azimuth_avg[ i ] = TOTAL( image[ range ], /DOUBLE ) / range_count
         encircled_e[ i + 1 ] = encircled_e[ i ] + $
          TOTAL( image[ range ], /DOUBLE )
      ENDIF ELSE BEGIN
         encircled_e[ i + 1 ] = encircled_e[ i ]
      ENDELSE 

   ENDFOR 

   return, azimuth_avg
END 

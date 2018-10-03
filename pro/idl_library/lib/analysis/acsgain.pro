;+
; $Id: acsgain.pro,v 1.4 2002/01/14 17:34:31 mccannwj Exp $
;
; NAME:
;     ACSGAIN
;
; PURPOSE:
;     Calculate detector gain using light transfer test data.
;      A wrapper for the statbox.pro and fitgain.pro routines.
;
; CATEGORY:
;     ACS/JHU
;
; CALLING SEQUENCE:
;     result = ACSGAIN( image1, image2 [, bias1, bias2, REGION=, BOXSIZE=, $
;                       SIGMA=, NITER=, MEAN=, VARIANCE=, FIT=, /USEMEDIAN, $
;                       /NOCLIP, /PLOT, /VERBOSE] )
; 
; INPUTS:
;     image1 - (LONG) may be either a scalar or an array of ACS_LOG
;               database entry numbers to be used for the first image.
;     image2 - (LONG) may be either a scalar or an array of ACS_LOG
;               database entry numbers to be used for the second image.
;
; OPTIONAL INPUTS:
;     bias1  - (LONG) may be either a scalar or an array of ACS_LOG
;               database entry numbers to be used for the bias frame.
;               NOTE: if multiple images are specified and only one
;                     bias frame, then the bias will be saved and reused.
;     bias2  - (LONG) may be either a scalar or an array of ACS_LOG
;               database entry numbers to be used for the second bias frame.
;               NOTE: if specified these frames will be applied to the
;                     image2 list and bias1 will be applied to the
;                     image1 list.
;      
; KEYWORD PARAMETERS:
;     REGION    - (ARRAY) An array of the form [x0,x1,y0,y1] used to
;                 specify the region of interest in the images.  The
;                 region lying outside is ignored.
;     BIAS_REGION - (ARRAY) An array of the form [x0,x1,y0,y1] used to
;                 specify the region of the image from which to compute
;                 a bias level.
;     BIAS1_CONSTANT - (FLOAT) A constant value to be used as the bias
;                 for image1.
;     BIAS2_CONSTANT - (FLOAT) A constant value to be used as the bias
;                 for image2.
;     NOOVERSCAN - (BOOLEAN) If specified, no offset is applied to the
;                 bias frame to match the signal level of the bias and
;                 image overscan.
;     BOXSIZE   - (INTEGER) specify the square box width in
;                 pixels. Default is 10 pixels.
;     SIGMA     - (INTEGER) specify the number of sigma in a box above
;                 which a pixel will be flagged as bad and ignored.
;     NITER     - (INTEGER) specify the number of iterations of pixel
;                 rejection. 
;     MEAN      - (VARIABLE) specify a named variable to receive the array
;                 of mean values computed for each box.
;     VARIANCE  - (VARIABLE) specify a named variable to receive the array
;                 of variance values computed for each box.
;     FIT       - (VARIABLE) specify a named variable to receive the array
;                 of y values for the variance vs. mean linear fit.
;     USEMEDIAN - (BOOLEAN) set to use median instead of mean in all
;                 calculations.
;     NOCLIP    - (BOOLEAN) if set no sigma pixel rejection will be
;                 done. Ie. all pixels will be used in the calculations.
;     CLIP_BEFORE - (BOOLEAN) if set pixel rejection will be done
;                 before image combination.  Ie, on each image/bias
;                 individually.
;     PLOT      - (BOOLEAN) set to plot the variance vs. mean photon
;                 transfer curve.
;     VERBOSE   - (BOOLEAN) set to show verbose messages.
;                 NOTE: set to greater than 1 shows a lot of info.
;
; OUTPUTS:
;     result - (DOUBLE) the computed gain.
;
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;     none.
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;     Uses STATBOX.PRO and FITGAIN.PRO
;
; PROCEDURE:
;
; EXAMPLE:
; 
;   image1      = [5345,5346,5347,5348,5349]
;   image2      = [5350,5351,5352,5353,5354]
;   bias1       = [5344]
;   region      = [539,1033,50,512]
;   bias_region = [550,980,5,15]
;
;   ; Use a bias FRAME
;
;   gain = ACSGAIN( image1, image2, bias1, $
;                   REGION=region, BOXSIZE=20, SIGMA=2, $
;                   /USEMEDIAN, /PLOT, /VERBOSE )
;
;   ; Use a bias REGION
;
;   gain = ACSGAIN( image1, image2, BIAS_REGION=bias_region, $
;                   REGION=region, BOXSIZE=20, SIGMA=2, $
;                   /USEMEDIAN, /PLOT, /VERBOSE )
;
;   ; Use a bias CONSTANT
;
;     ; for example we can get the constant this way
;   ACS_READ, image1[0], h1, d1
;   bias1_constant = MEDIAN( d1[ bias_region[0]:bias_region[1], $
;                                bias_region[2]:bias_region[3] ] )
;   ACS_READ, image2[0], h2, d2
;   bias2_constant = MEDIAN( d2[ bias_region[0]:bias_region[1], $
;                                bias_region[2]:bias_region[3] ] )
;   gain = ACSGAIN( image1, image2, $
;                   BIAS1_CONSTANT=bias1_constant, $
;                   BIAS2_CONSTANT=bias2_constant, $
;                   REGION=region, BOXSIZE=20, SIGMA=2, $
;                   /USEMEDIAN, /PLOT, /VERBOSE )
;
; MODIFICATION HISTORY:
;
;    Mon Nov 16 13:27:30 1998, William Jon McCann <mccannwj@acs10>
;
;		written.
;
;-

FUNCTION acsgain, im1list, im2list, bias1list, bias2list, $
                  VARIANCE=variance_array, $
                  MEAN=mean_array, REGION=region, VERBOSE = verbose, $
                  PLOT = plot, FIT=fit, BOXSIZE = box_size, $
                  SIGMA = sigma, NITERATIONS = n_iterations, $
                  USEMEDIAN = usemedian, $
                  NOCLIP = noclip, CLIP_BEFORE = clip_before, $
                  USEVIRTUAL = usevirtual, $
                  BIAS1_CONSTANT = bias1_constant, $
                  BIAS2_CONSTANT = bias2_constant, $
                  BIAS_REGION = bias_region, $
                  NOOVERSCAN = nooverscan

   IF (N_ELEMENTS( usevitual ) LE 0) AND (N_ELEMENTS(bias1_constant) LE 0) $
    AND (N_ELEMENTS( bias_region ) LE 0) THEN BEGIN
      IF N_PARAMS() LT 3 THEN BEGIN
         MESSAGE, 'gain = acsgain( image1_list, image2_list, bias_list )',/CONT
         return, -1
      ENDIF       
   ENDIF ELSE BEGIN
      IF N_PARAMS() LT 2 THEN BEGIN
         MESSAGE, 'gain = acsgain( image1_list, image2_list )', /CONT
         return, -1
      ENDIF 
   ENDELSE

   IF ( N_ELEMENTS( im1list ) NE N_ELEMENTS( im2list ) ) THEN BEGIN
      MESSAGE, 'image lists must be same size', /CONT
      return, -1
   ENDIF

   IF N_ELEMENTS( region ) LT 4 THEN region = [50,1000,50,1000]

   IF KEYWORD_SET( verbose ) THEN PRINTF, -2, $
    FORMAT='("Using REGION : [",I0,":",I0,",",I0,":",I0,"]")', region

   IF N_ELEMENTS( box_size ) LE 0 THEN box_size = 10

   IF KEYWORD_SET( verbose ) THEN PRINTF, -2, $
    FORMAT='("Using BOXSIZE: ",I0)', box_size

   nxbox = CEIL( (region(1) - region(0) ) / FLOAT( box_size ) )
   nybox = CEIL( (region(3) - region(2) ) / FLOAT( box_size ) )

   variance_array = DBLARR( nxbox * nybox * N_ELEMENTS( im1list ) )
   mean_array = DBLARR( nxbox * nybox * N_ELEMENTS( im1list ) )
   num_good_pix = 0L

   IF KEYWORD_SET( verbose ) THEN PRINTF, -2, $
    FORMAT='("Processing ", I0," image pairs.")', N_ELEMENTS( im1list )

   FOR i=0L, N_ELEMENTS( im1list ) - 1L DO BEGIN

      IF KEYWORD_SET( verbose ) THEN BEGIN
         PRINTF, -2, FORMAT='("Processing set ",I0," of ",I0)', i, $
          N_ELEMENTS( im1list ) - 1
         PRINTF, -2, '   Opening files...'
      ENDIF

      acs_read, im1list[i], h, im1
      acs_read, im2list[i], h, im2

      IF N_ELEMENTS( bias1_constant ) GT 0 THEN BEGIN 
                    ; use a constant bias
         nooverscan = 1
         IF N_ELEMENTS( bias1_constant ) GT i THEN BEGIN
            IF KEYWORD_SET( verbose ) THEN PRINTF, -2, $
             FORMAT='("Using BIAS1 CONSTANT : ", d)', bias1_constant[i]
            bias1 = im1 * 0.0d + DOUBLE( bias1_constant[i] )
         ENDIF ELSE BEGIN
         ENDELSE 

         IF N_ELEMENTS( bias2_constant ) GT i THEN BEGIN
            IF KEYWORD_SET( verbose ) THEN PRINTF, -2, $
             FORMAT='("Using BIAS2 CONSTANT : ", d)', bias2_constant[i]
            bias2 = im2 * 0.0d + DOUBLE( bias2_constant[i] )
         ENDIF ELSE BEGIN
         ENDELSE 
         
      ENDIF ELSE IF N_ELEMENTS( bias_region ) GT 0 THEN BEGIN
                    ; get a MEDIAN value constant from bias region
         nooverscan = 1

         IF KEYWORD_SET( verbose ) THEN PRINTF, -2, $
          FORMAT='("Using BIAS REGION : [",I0,":",I0,",",I0,":",I0,"]")', $
          bias_region

         im_sz = SIZE( im1 )
         br_x0 = bias_region[0] > 0 < im_sz[1]
         br_x1 = bias_region[1] > br_x0 < im_sz[1]
         br_y0 = bias_region[2] > 0 < im_sz[2]
         br_y1 = bias_region[3] > br_y0 < im_sz[2]

         region1_bias = MEDIAN( im1[br_x0:br_x1,br_y0:br_y1] )
         region2_bias = MEDIAN( im2[br_x0:br_x1,br_y0:br_y1] )

         bias1 = im1 * 0.0d + region1_bias
         bias2 = im2 * 0.0d + region2_bias

      ENDIF ELSE IF KEYWORD_SET( usevirtual ) THEN BEGIN
                    ; construct a bias from virtual overscan
         nooverscan = 1

      ENDIF ELSE BEGIN
                    ; use a bias frame image

         IF N_ELEMENTS( bias1list ) GT i THEN BEGIN
            IF KEYWORD_SET( verbose ) THEN PRINTF, -2, $
             FORMAT='("Using BIAS1 FRAME : (entry) ", I0)', bias1list[i]
            acs_read, bias1list[i], h, bias1
         ENDIF 

         IF N_ELEMENTS( bias2list ) GT i THEN BEGIN
            IF KEYWORD_SET( verbose ) THEN PRINTF, -2, $
             FORMAT='("Using BIAS2 FRAME : (entry) ", I0)', bias2list[i]
            acs_read, bias1list[i], h, bias2
         ENDIF 
         
      ENDELSE 

      IF KEYWORD_SET( verbose ) THEN PRINTF, -2, $
       FORMAT='("   Computing box stats...",$)'

      IF N_ELEMENTS( bias2 ) GT 0 THEN BEGIN 
         mean_var = statbox( im1,im2,bias1,bias2,BOXSIZE=box_size, MASK=mask, $
                             REGION=region, USEMEDIAN=usemedian, $
                             SIGMA=sigma, NITER=n_iterations, $
                             VERBOSE=verbose, NOCLIP=noclip, $
                             CLIP_BEFORE = clip_before, $
                             NOOVER=nooverscan, MAP_MEAN=mean_map, $
                             MAP_VARIANCE=variance_map )
      ENDIF ELSE BEGIN 
         mean_var = statbox( im1, im2, bias1, BOXSIZE=box_size, MASK=mask, $
                             REGION=region, USEMEDIAN=usemedian, $
                             SIGMA=sigma, NITER=n_iterations, $
                             VERBOSE=verbose, NOCLIP=noclip, $
                             CLIP_BEFORE = clip_before, $
                             NOOVER=nooverscan, MAP_MEAN=mean_map, $
                             MAP_VARIANCE=variance_map )
      ENDELSE 

      IF KEYWORD_SET( verbose ) THEN BEGIN
         junk = WHERE( mask EQ 0, n_rejected )
         PRINTF, -2, FORMAT='("   Rejected ",I0," pixels.")', n_rejected
         IF verbose GT 1 THEN BEGIN
            LOADCT, 1, /SILENT
            ERASE         
            PLOT, mean_var[*,0], PSYM=3, TITLE = 'Mean'
            WAIT, 5
            PLOT, mean_var[*,1], PSYM=3, TITLE = 'Variance'
            WAIT, 5
            PLOT, mean_var[*,0], mean_var[*,1],  PSYM=3, $
             TITLE='Mean vs. Variance'
            WAIT, 5
            ERASE, !D.N_COLORS-1
            spix = WHERE( mean_map GE 1, scount )
            junk = WHERE( mean_map LT 0, bad_count )
            IF bad_count GT 0 THEN BEGIN
               PRINTF, -2, 'HAS NEGATIVE VALUES!' + STRING(7b)
            ENDIF 
            IF scount GT 0 THEN BEGIN
               mm_im = CONGRID(mean_map, 512, 512 )
               TV, BYTSCL( mm_im, MIN=MIN(mean_map[spix]), $
                           MAX=MAX(mean_map[spix])*1.2 )
               XYOUTS, .5, .9, 'Mean Map', /NORMAL
               RDPIX, mm_im
               vm_im = CONGRID(variance_map, 512, 512 )
               TV, BYTSCL( vm_im, MIN=MIN(variance_map[spix]), $
                           MAX=MAX(variance_map[spix])*1.2 )
               XYOUTS, .5, .9, 'Variance Map', /NORMAL
               RDPIX, vm_im
            ENDIF
         ENDIF 
         PRINTF, -2, ' done.'
      ENDIF 

      variance_array[i*nxbox*nybox] = mean_var[*,1]
      mean_array[i*nxbox*nybox] = mean_var[*,0]

      num_good_pix = num_good_pix + TOTAL( mask ) - 1
      mask = 0b

   ENDFOR 

   IF KEYWORD_SET( verbose ) THEN PRINTF, -2, $
    FORMAT='("   Fitting polynomial...",$)'

   Gain = fitgain( mean_array, variance_array, Coeff, PLOT=plot, Y_FIT=fit, $
                   MEDIAN=usemedian )

   IF KEYWORD_SET( verbose ) THEN PRINTF, -2, ' done.'


   IF KEYWORD_SET( verbose ) THEN PRINTF, -2, $
    FORMAT='("Fit Coeff: ",d,d)', Coeff
   
   return, Gain
END


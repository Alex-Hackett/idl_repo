;+
; $Id: fitgain.pro,v 1.3 1999/08/13 21:20:46 mccannwj Exp $
;
; NAME:
;     FITGAIN
;
; PURPOSE:
;     Fit a line to the given mean and variance data and return
;     computed gain.
;
; CATEGORY:
;     ACS/JHU
;
; CALLING SEQUENCE:
;     result = FITGAIN( mean, variance [ Coeff, Y_FIT=, SIGMA_FIT=, $
;                       NDEGREE=, /MEDIAN, /PLOT ]
; 
; INPUTS:
;     mean - (ARRAY) array of independent variable data.
;     variance - (ARRAY) array of dependent variable data.
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     Y_FIT - (VARIABLE) named variable to receive the array of fitted
;              data.
;     SIGMA_FIT - (VARIABLE) named variable to receive the sigma of
;                  the fit.
;     NDEGREE - (INTEGER) specify the degree of the fit.  Default is 1.
;     MEDIAN - (BOOLEAN) set if independent variable data represents
;               median values instead of mean values.  Used to label
;               the plot.
;     PLOT - (BOOLEAN) set to plot the mean vs. variance photon
;             transfer curve.
;
; OUTPUTS:
;     result - (DOUBLE) computed gain.
;
; OPTIONAL OUTPUTS:
;     Coeff - (VARIABLE) named variable to receive the fit coefficients.
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
;    Mon Nov 16 14:13:14 1998, William Jon McCann <mccannwj@acs10>
;
;		written.
;
;-

FUNCTION fitgain, mean, variance, Coeff, Y_FIT = Fity, SIGMA_FIT = FitSigma, $
                  NDEGREE = n_degree, PLOT = plot, MEDIAN = usemedian, $
                  NITERATIONS = n_iterations, SIGMA_REJECT = sigma_reject

   IF N_ELEMENTS( n_degree ) LE 0 THEN n_degree = 1
   IF N_ELEMENTS( sigma_reject ) LE 0 THEN sigma_reject = 4
   IF N_ELEMENTS( n_iterations ) LE 0 THEN n_iterations = 2

   mean_array = mean
   variance_array = variance

                    ; Sort the arrays by the MEAN
   sort_index = SORT( mean_array )
   mean_array = (TEMPORARY( mean_array ))[sort_index]
   variance_array = (TEMPORARY( variance_array ))[sort_index]

                    ; Check for invalid MEAN values
   muse_indices = WHERE( (mean_array GT 0.0) AND $
                         (mean_array LT 65536.0), use_count)
   IF use_count LE 0 THEN BEGIN
      MESSAGE, 'No usable data: zero mean', /CONTINUE
      return, -1
   ENDIF
   
                    ; Check for invalid VARIANCE values
   vuse_indices = WHERE( (variance_array GT 0.0) AND $
                         (variance_array LT 65536.0), $
                         use_count )

                    ; Do a match to find the indices which have a
                    ; valid mean value and variance
   MATCH, muse_indices, vuse_indices, only_good, COUNT=good_count
   IF good_count LE 0 THEN BEGIN
      MESSAGE, 'No usable data.', /CONTINUE
      return, -1      
   ENDIF
   use_indices = muse_indices[only_good]
   
   inspect_bad_values = 0b ; set this greater than zero to inspect
   IF KEYWORD_SET( inspect_bad_values ) THEN BEGIN
      bad_indices = LINDGEN( N_ELEMENTS( mean_array ) )
      REMOVE, use_indices, bad_indices
   
      FOR i=0, N_ELEMENTS( bad_indices )-1 DO $
       PRINTF, -2, FORMAT='(I6,5X,F15.2,5X,F15.2)', bad_indices[i], $
       mean_array[bad_indices[i]], variance_array[bad_indices[i]]
   ENDIF 

   num_rejected = N_ELEMENTS( mean_array ) - N_ELEMENTS( use_indices )
   PRINTF, -2, FORMAT='("Rejected ",I0," points from the fit")', num_rejected

;   FOR fit_iter=0,n_iterations-1 DO BEGIN
      
      Coeff = SVDFIT( mean_array[use_indices], variance_array[use_indices], $
                      2, YFIT=FitY, SIGMA=FitSigma, /DOUBLE )
;   ENDFOR

   Gain = 1D / Coeff[1]

   IF KEYWORD_SET( plot ) THEN BEGIN

      IF KEYWORD_SET( usemedian ) THEN xtitle = 'Median (DN)' $
      ELSE xtitle = 'Mean (DN)'

      IF (!D.FLAGS AND 256) GT 0 THEN BEGIN
         LOADCT, 39, /SILENT
         WINDOW, /FREE, TITLE = 'CCD Photon Transfer Curve'
      ENDIF

      PLOT, mean_array[use_indices], variance_array[use_indices], PSYM = 3, $
       XTITLE = xtitle, YTITLE = 'Variance (DN)', $
       XRANGE=[0,MAX(mean_array[use_indices])];, $
       ;YRANGE=[MIN(FitY)*0.9, MAX(FitY) * 1.1], YSTYLE=3

      OPLOT, mean_array[use_indices], FitY, LINESTYLE = 2, $
       COLOR = !D.N_COLORS / 2

      XYOUTS, .2, .9, /NORMAL, $
       STRING( FORMAT='("Fit Coeff: A0=", F20.5, 2X, "A1=", F20.5)', Coeff )
      XYOUTS, .2, .85, /NORMAL, $
       STRING( FORMAT='("    Gain: ", F20.5)', Gain )
   ENDIF 

   return, Gain
END 

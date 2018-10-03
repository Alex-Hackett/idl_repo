
; ZE_C1D_PARAMS -- Set parameters. not sure I understand what it does....so commenting out

;PRO ZE_C1D_PARAMS,interp, eps
;
;;int interp    ; Interpolation type
;;real  eps   ; Accuracy of centering
;
;int first
;data  first /YES/
;
;common  ze_c1d_common interptype, epsilon
;
;begin
;  if (!IS_INDEFI(interp))
;      interptype = interp
;  else if (first == YES)
;      interptype = INTERPTYPE
;
;  if (!IS_INDEFR(eps))
;      epsilon = eps
;  else if (first == YES)
;      epsilon = EPSILON
;
;  first = NO
;END


; ZE_C1D_CENTER -- One dimensional centering algorithm.
; If the width is <= 1. return the nearest local maximum.

FUNCTION ZE_c1d_center,x, datac, npts, width,interptype,epsilon,iterations,epsilon1,MAX_DXCHECK

;INPUTS
;real  x       ; Starting guess
;int npts        ; Number of points in data vector
;real  data[npts]      ; Data vector
;real  width       ; Centering width

;subroutine variables
;int i, j, iteration, dxcheck
;real  xc, wid, hwidth, dx, dxabs, dxlast
;real  a, b, sum1, sum2, intgrl1, intgrl2
;pointer asi1, asi2, sp, data1



done=99

  ; Find the nearest local maxima as the starting point.
  ; This is required because the threshold limit may have set
  ; large regions of the data to zero and without a gradient
  ; the centering will fail.
print, 'x', x
;doublecheck these for statements because of index 0 or 1 being the first one -- apparently we have to use npts -1 
  for i=x+.5, npts-1  DO IF (datac[i] GE datac[i+1]) THEN BREAK 
  print,'i ',i
  while ((i GT 1) AND (datac[i] LE datac[i-1])) DO i=i-1
  print,'i ',i
  for j=x+.5, 1,-1  DO IF (datac[j] LE datac[j+1]) THEN BREAK 
  print,'j ',j
  while ((j LT npts-1) AND (datac[j] LE datac[j+1])) DO j=j+1  
  print,'j ',j
  if (abs(i-x) LT abs(x-j)) THEN xcen = i ELSE xcen = j
  print,'xcen ini ', xcen

  if (width LE 1.) THEN return,xc

  wid = max(width, MIN_WIDTH)

  ; Check datac range.
  hwidth = wid / 2
  print,xcen - hwidth,1,xcen + hwidth,npts
  if (((xcen - hwidth) LT 1) || ((xcen + hwidth) GT npts)) THEN STOP,'Error: (xcen - hwidth) LT 1) || ((xcen + hwidth) GT npts)'
  
  ;up to here calculations are fine
  
  ; Set interpolation functions.
  ;JHG has to check what these are
  ;  call asifit (asi1, data, npts)
  ZE_ASIFIT,interptype, datac, npts,coeff
 print,'coeff ',coeff

  ; Allocate, compute, and interpolate the x*y values.
  memr=datac
  for i = 0, npts-1 DO Memr[datac+i-1] = datac[i] * i
  ZE_ASIFIT,interptype, memr, npts,coeff2
   ;have to find out what these function calls are
  ;call asifit(asi2, Memr[data1], npts)

  ; Iterate to find center.  This loop exits when 1) the maximum
  ; number of iterations is reached, 2) the delta is less than
  ; the required accuracy (criterion for finding a center), 3)
  ; there is a problem in the computation, 4) successive steps
  ; continue to exceed the minimum delta.

  dxlast = npts
  for iteration = 0, ITERATIONS-1 DO BEGIN
      ; Ramp centering function.
      ; a = xc - hwidth
      ; b = xc + hwidth
      ; intgrl1 = asigrl (asi1, a, b)
      ; intgrl2 = asigrl (asi2, a, b)
      ; sum1 = intgrl2 - xc * intgrl1
      ; sum2 = intgrl1

      ; Triangle centering function.
      a = xcen - hwidth
      b = xcen - hwidth / 2
      print,'xcen ', xcen
      print,'a,b ',a,b
      ;ze_asigrl is not working
      print,interptype
      intgrl1 = ze_asigrl(interptype, a, b,coeff)
      intgrl2 = ze_asigrl(interptype, a, b,coeff2)
      print,'intgrl1,intgrl2 ',intgrl1,intgrl2
      sum1 = (xcen - hwidth) * intgrl1 - intgrl2
      sum2 = -intgrl1
      a = b
      b = xcen + hwidth / 2
      intgrl1 = ze_asigrl(interptype, a, b,coeff)
      intgrl2 = ze_asigrl(interptype, a, b,coeff2)
      sum1 = sum1 - xcen * intgrl1 + intgrl2
      sum2 = sum2 + intgrl1
      a = b
      b = xcen + hwidth
      intgrl1 = ze_asigrl(interptype, a, b,coeff)
      intgrl2 = ze_asigrl(interptype, a, b,coeff2)
      sum1 = sum1 + (xcen + hwidth) * intgrl1 - intgrl2
      sum2 = sum2 - intgrl1

      ; Return no center if sum2 is zero.
      if (sum2 EQ 0.) THEN break

      ; Limit dx change in one iteration to 1 pixel.
      dx = sum1 / abs(sum2)
      dxabs = abs(dx)
      xcen = xcen + max([-1., min([1., dx])])

      ; Check data range.  Return no center if at edge of data.
      if (((xcen - hwidth) LT 1) || ((xcen + hwidth GT npts))) THEN break

      ; Convergence tests.
      if (dxabs LT epsilon) THEN goto,DONECEN
      if (dxabs GT (dxlast + EPSILON1)) THEN BEGIN
          dxcheck = dxcheck + 1
          if (dxcheck GT MAX_DXCHECK) THEN break
      ENDIF else if (dxabs GT (dxlast - EPSILON1)) THEN BEGIN
          xcen = xcen - max([-1., min([1., dx])]) / 2
          dxcheck = 0
      ENDIF else BEGIN
          dxcheck = 0
          dxlast = dxabs
      ENDELSE
  ENDFOR

  ; If we get here then no center was found.
  xcen = -9998.
DONECEN:  return, xcen
END

FUNCTION ZE_CENTER1D,x, data, npts, width, type, radius, threshold,interptype,epsilon,epsilon1,MAX_DXCHECK
;IDL version of IRAF routine center1d.x, used to find line centroids in 1D spectra

;include <math/iminterp.h>
;include <pkg/center1d.h>


IF n_elements(MIN_WIDTH) eq 0 then   MIN_WIDTH=3.    ; Minimum centering width
IF n_elements(EPSILON) eq 0 then     EPSILON=0.001   ; Accuracy of centering
IF n_elements(EPSILON1) eq 0 then    EPSILON1=0.005   ; Tolerance for convergence check
IF n_elements(ITERATIONS) eq 0 then  ITERATIONS=100   ; Maximum number of iterations
IF n_elements(MAX_DXCHECK) eq 0 then MAX_DXCHECK=3   ; Look back for failed convergence
IF n_elements(INTERPTYPE) eq 0 then  INTERPTYPE='II_SPLINE3'  ; Image interpolation type


; CENTER1D -- Locate the center of a one dimensional feature.
; A value of INDEF is returned in the centering fails for any reason.
; This procedure just sets up the data and adjusts for emission or
; absorption features.  The actual centering is done by C1D_CENTER.
; If twidth <= 1 return the nearest minima or maxima.


;INPUT PARAMETERS
;real  x       ; Initial guess
;int npts        ; Number of data points
;real  data[npts]      ; Data points
;real  width       ; Feature width
;int type        ; Feature type
;real  radius        ; Centering radius
;real  threshold     ; Minimum range in feature

;OUTPUT
;real  xc        ; Center
;
;;ROUTine VARIABLES
;int x1, x2, nx
;real  a, b, rad, wid
;pointer sp, data1
;
;real  c1d_center()


  ; Check starting value.
  if ((x LT 1) OR (x GT npts)) THEN STOP,'Error: (x LT 1) OR (x GT npts) '

  ; Set parameters.  The minimum in the error radius
  ; is for defining the data window.  The user error radius is used to
  ; check for an error in the derived center at the end of the centering.

;JHG has to check what is cd1_params OK IT IS A SUBROUTINE FOUND ABOVe, but why do we need that? to set interptype and 
;  ze_c1d_params,INDEFI, INDEFR
  wid = max(width, MIN_WIDTH)
  rad = max(2., radius)

  ; Determine the pixel value range around the initial center, including
  ; the width and error radius buffer.  Check for a minimum range.

  x1 = max([1., x - wid / 2 - rad - wid])
  x2 = min([npts, x + wid / 2 + rad + wid + 1])
  nx = x2 - x1 + 1

  a=MIN(data[x1:x2])
  b=MAX(data[x1:x2])
  print,a,b,x,x1,x2,wid,rad
  if ((b - a) LT threshold) THEN STOP,'Error: (b - a) LT threshold '

  ; Make the centering data positive, subtract the continuum, and
  ; apply a threshold to eliminate noise spikes.

  CASE type OF
    'EMISSION': BEGIN
      a = min(0., a)
      ;JHG has to check what these function calls are
      ;call asubkr (data[x1], a + threshold, Memr[data1], nx)
     ; call amaxkr (Memr[data1], 0., Memr[data1], nx)
    END        
   'ABSORPTION': BEGIN
      ;JHG has to check what these function calls are
      ;call anegr (data[x1], Memr[data1], nx)
      ;call asubkr (Memr[data1], threshold - b, Memr[data1], nx)
      ;call amaxkr (Memr[data1], 0., Memr[data1], nx)
    END
   ELSE: STOP, 'Unknown feature type -- Please choose either EMISSION or ABSORPTION'
  ENDCASE

  ; Determine the center.
  print,'x',x
  print,'x1',x1
  print,'x2',x2
  print,'x-x1',x-x1
  ;up to here calculations are fine
xcen = ze_c1d_center(x - x1-1, data[x1:x2], nx, width,interptype,epsilon,iterations,epsilon1,MAX_DXCHECK)
print,'xcen ',xcen
  ; Check user centering error radius. JHG not sure what it does...so commenting out
  xcen = xcen + x1 - 1
  if (abs(x - xcen) GT radius) THEN xcen = -9999.

  ;return the center position.
  return,xcen
END

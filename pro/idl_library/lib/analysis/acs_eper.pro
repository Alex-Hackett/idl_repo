;+
; $Id: acs_eper.pro,v 1.1 2001/11/05 20:55:49 mccannwj Exp $
;
; NAME:
;     ACS_EPER
;
; PURPOSE:
;     Analyze ACS EPER test
;
; CATEGORY:
;     ACS/JHU
;
; CALLING SEQUENCE:
;     ACS_EPER, entry
; 
; INPUTS:
;     entry - ACS database entry number or filename
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
;     Originally written by David Golimowski
;-
PRO ACS_EPER, entry, PARALLEL=parallel, SERIAL=serial

   direction = 1
   IF KEYWORD_SET(serial) THEN direction=2

   ;;read, 'Enter first column of region of interest: ', x1
   ;;read, 'Enter last  column of region of interest: ', x2
   ;;read, 'Enter system gain (e-/DN): ', gain

   IF direction EQ 2 THEN BEGIN
      x1 = 4118 - 1
      x2 = 4192 - 1
   ENDIF ELSE BEGIN
      
   ENDELSE

   ACS_READ, entry, h, data, CHIP=1

   dataline = TOTAL(data[x1:x2,*],direction)/(x2-x1+1.0)

   x = FINDGEN(1000)
   PLOT, x[701:999], dataline[701:999]

   ;;read, 'Enter first row of bias region: ', y
   y = 80
   y = y - 1

   bias = dataline[y:999]
   ndata  = N_ELEMENTS(bias)
   avgdat = TOTAL(bias)/ndata
   sigdat = SQRT(TOTAL((bias - avgdat)^2.0) / (ndata - 1.0))

   yy = FINDGEN(1000-y)+y
   bf = bias(WHERE(ABS(bias-avgdat) LT (2.0*sigdat)))
   yf = yy(WHERE(ABS(bias-avgdat) LT (2.0*sigdat)))


   ab = LINFIT(yf, bf)
   bfit = ab[0] + ab[1]*x
   OPLOT, x[701:999], bfit[701:999]

   dataline = dataline - bfit

   q0 = dataline[698]
   qd = TOTAL(dataline[700:y-1])
   qz = TOTAL(dataline[y:999])

   cte = (1 - qd/q0)^(1.0/2048.0)

   print, ''
   print, ''
   print, 'Parallel CTE (EPER) measurement'
   print, 'Entry: ', entry
   print, 'Columns', x1+1, ' to ',x2+1
   print, 'Bias begins at row ', y+1
   print, ''
;for i=699,y do print, 'Row ',i,' signal = ',dataline(i-1) * gain
;print, ''
   print, 'Signal at row 699 = ', q0
   print, 'Signal at row 700 = ', dataline[699]*gain
   print, 'Deferred signal   = ', qd
   print, 'Total bias signal = ', qz
   print, ''
   print, format='("Parallel CTE = ",g13.8)',cte

END

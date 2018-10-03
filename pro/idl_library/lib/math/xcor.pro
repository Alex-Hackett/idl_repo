;+
; COMPUTES THE POSITIONS OF FEATURES USING CROSS CORRELATION WITH A
; USER-DEFINED TEMPLATE.
; 
; CALLING SEQUENCE:
;		XCOR,CPOS,FLUX,TEMPLATE,WIDTH,MAXDEV,EXACT
; INPUT :
;       CPOS -APPROXIMATE POSITION (ELEMENT OF FLUX ARRAY) OF CENTER OF TEMPLATE
;             ARRAY WHEN CORRELATION IS MAXIMIZED.
;	FLUX - FLUX VECTOR TO BE SEARCHED
;	TEMPLATE - TEMPLATE VECTOR FOR SEARCH 
;	WIDTH - (FULL) WIDTH OF THE SEARCH AREA
;	MAXDEV - MAXIMUM ALLOWABLE DEVIATION OF EXACT POSITION
;		FROM THE APPROX. POSITION
;
; OUTPUT: EXACT - FOUND POSITION
; VERSION 1  BY D. LINDLER  AUGUST 29,1982
; Modified: J Wheatley 7/85, G. Hartig 10/88 
;-
;------------------------------------------------------------------------------
PRO xcor, cpos, flux, template, width, maxdev, exact, SHOW=show, PFW=pfw

   exact = 0.0

   if N_ELEMENTS(pfw) EQ 0 THEN fw = 3 ELSE fw = 2*(FIX(pfw)/2 > 1)+1
;
; Make FLUX and TEMPLATE floating point
;
   f = FLOAT(flux)
   t = FLOAT(template)
;
; Normalize FLUX and TEMPLATE
; 
   f = f / (MAX(f)>1)
   t = t / (MAX(t)>1)
;
; Get sizes of inputs 
;
   s=SIZE(f) & nf=s(1)
   s=SIZE(t) & nt=s(1)
;
; Determine parameters for search
;
   width  = FIX(width)
   hwidth = width/2
   area   = nt + width - 1
   hfarea = area/2
   halfnt = nt/2.0

   result = FLTARR(width)

   ;;istart = FIX(cpos) - hfarea
   istart = FIX(cpos) - ( (nt+width)/2 + ( (nt+width) MOD 2) )

   IF ( (istart LT 0) OR (istart+area GT nf) ) THEN BEGIN
      PRINT, 'Template array overextends data array'
      GOTO, NOGOOD
   ENDIF

;
; Cross correlate by summing the squares of the differences
;
   FOR j=0,width-1 DO BEGIN
      res=0.0
      FOR k=0,nt-1 DO BEGIN
         diff = f(istart+j+k) - t(k)
         res = res + diff*diff
      END           ; FOR K
      result(j) = res
   END              ; FOR J
;
; Find the MIN of result
;
   rmin = MIN(result)
   pos = WHERE(result EQ rmin) & pos=pos(0)
;
; If pos is on edge of search area then reject it
;
   IF ( pos LE (fw/2)-1 ) OR ( pos GE width-(fw/2) ) THEN BEGIN
      IF !DEBUG GT 0 THEN BEGIN
         HELP, pos, fw, width
      ENDIF 
      PRINT, 'Maximum correlation at edge of search area.'
      GOTO, NOGOOD
   ENDIF
;
; Refine using parabolic fit
;
   IF fw GT 3 THEN BEGIN
      x = LINDGEN(fw) ;+ pos - fw/2
      result_x0 = pos-fw/2
      result_x1 = pos+fw/2
      cf = POLY_FIT( FLOAT(x), result(result_x0:result_x1), 2, yfit )
      pos = -cf(1) / (2*cf(2)) ;+ halfnt - 0.5
   ENDIF ELSE BEGIN
      pos = (result(pos-1)-result(pos)) / $
       (result(pos-1) + result(pos+1) - 2.0*result(pos) ) + pos ;- 1.0  + halfnt
   ENDELSE

   newpos = istart + (nt/2 + (nt MOD 2)) + pos + result_x0

   IF !DEBUG GT 0 THEN BEGIN
      PRINT, 'Template width: ', nt
      PRINT, 'Local position: ', pos
      PRINT, 'Position: ', newpos
   ENDIF
;
; plot the results, if requested
;
   IF KEYWORD_SET(show) OR (!DEBUG GT 0) THEN BEGIN
      x_f = LINDGEN( nf )
      PLOT, x_f, f, TITLE='XCOR debug', PSYM=10, /XSTYLE, YSTYLE=3
      x_t = LINDGEN( nt )
      ;;template_plot_offset = newpos - halfnt + 0.5
      ;;OPLOT, x_t + template_plot_offset, t, THICK=2
      OPLOT, [newpos,newpos], !Y.CRANGE, LINES=1
      ;;keywait
      key = GET_KBRD(1)

      xx = INDGEN( N_ELEMENTS(result) )
      PLOT, xx, result - MIN(result), PSYM=-2, TITLE='XCOR debug', $
       /XSTYLE, YSTYLE=3
      ;;OPLOT, [pos,pos] - halfnt + 0.5, !Y.CRANGE, LINES=1
      fit_plot_offset = result_x0
      OPLOT, [pos,pos] + fit_plot_offset, !Y.CRANGE, LINES=1
      ;;keywait
      key = GET_KBRD(1)
   ENDIF
;
; Is exact position close enough to approx position?
;
   IF (ABS(newpos-cpos) GT maxdev) THEN BEGIN
      PRINT,'MAXDEV exceeded.'
      GOTO, NOGOOD
   ENDIF

   exact = newpos
   !ERR = 0

   RETURN

NOGOOD:

   PRINT, STRING(7B)
   PRINT, 'XCOR cross-correlation failed.'
   !ERR=1
   IF !DEBUG GE 2 THEN stop

   RETURN
END

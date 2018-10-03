;+
; $Id: acs_ps.pro,v 1.1 2001/11/05 21:47:34 mccannwj Exp $
;
; NAME:
;     ACS_PS
;
; PURPOSE:
;     Generate postscript image file of the specified data set
;
; CATEGORY:
;     ACS
;
; CALLING SEQUENCE:
;     ACS_PS, entry
;
; INPUTS:
;     id - filename or database entry number
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;	/log - Use log transformation (default - program decides)
;	/linear - use linear transformation
;	/reverse - use white on black instead for black on white'
;	imin - minimum scale value
;	imax - maximum scale value
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;	postcript file with <filename>.ps 
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;	version 1  D. Lindler
;	Mar 4, 1999, Lindler, Modified to handle images with all zeros
;	Mar 11, 1999, Lindler, added compression type to output image
;                     McCann, added colorbar
;	Apr 23, 2001, Lindler, added MONOHOMS info to plot
;-
FUNCTION make_colorbar, width, HEIGHT=height, MINIMUM=minimum, $
                        MAXIMUM=maximum
   COMPILE_OPT IDL2

   IF N_ELEMENTS( width ) LE 0 THEN BEGIN
      MESSAGE, 'width not specified.', /INFO
      return, [-1]
   ENDIF

   IF N_ELEMENTS( height ) LE 0 THEN height = 5
   IF N_ELEMENTS( minimum ) LE 0 THEN minimum = 0
   IF N_ELEMENTS( maximum ) LE 0 THEN maximum = 100

   value_range = ( maximum - minimum ) > 0
   colorbar = ( minimum + value_range * FINDGEN(width) / FLOAT(width-1) ) # $
    REPLICATE( 1, height )

   return, colorbar
END

pro acs_ps, id, log=log, linear=linear, reverse=reverse, sqroot=sqroot, $
            histeq=histeq, imin=imin, imax=imax, header=header, data=data, $
            color=color, title=title, hudl=hudl

;
; set defaults
;
   IF N_ELEMENTS(title) eq 0 then title=''
   IF N_ELEMENTS(reverse) eq 0 then reverse=0
   trans = 'DEF'
   IF KEYWORD_SET(log) then trans='Log'
   IF KEYWORD_SET(linear) then trans='Linear'
   IF KEYWORD_SET(sqroot) then trans = 'Square Root'
   IF KEYWORD_SET(histeq) then trans = 'Histogram Equalization'
   IF N_ELEMENTS(color) eq 0 then color=0
   IF color LT 0 THEN TVLCT, r, g, b, /GET
;
; read observation
;
   IF N_ELEMENTS(header) gt 0 then begin
      h = header
      d = data
      entry = sxpar(h,'entry')
   end else begin
      acs_read, id, h, d, hudl, /ROTATE
      if datatype(id) ne 'STR' then entry=id else entry=0
   end
   if STRTRIM(sxpar(h,'detector')) eq 'SBC' then $
    mglobal = TOTAL(d)/sxpar(h,'exptime')
;
; Bin to a more reasonable size for printing
;
   s = size(d) & ns = s(1) & nl = s(2)
   nsout = ns
   nlout = nl
   factor = 1
   while ((ns/factor) gt 600) or ((nl/factor) gt 600) do factor=factor+1
   nsout = ns/factor
   nlout = nl/factor
   d = REBIN(d(0:nsout*factor-1,0:nlout*factor-1),nsout,nlout)
;
; Determine transformation (linear/Log)
;
   med = MEDIAN(d)
   if trans eq 'DEF' then begin
      if med lt 10 then trans = 'Log' else trans = 'Linear'
   end
;
; Determine minimum and maximum
;
   if trans eq 'Linear' then begin
      if (n_elements(imin) eq 0) then begin
         good = where(d le med,ngood)
         rms_lo = sqrt(total(d(good)^2)/ngood)
         imin = (med - rms_lo*2)>min(d)>0
      endif
      if (n_elements(imax) eq 0) then begin	
         good = where(d ge med,ngood)
         rms_hi = sqrt(total(d(good)^2)/ngood)
         imax = (med + rms_hi*8)<max(d)
      endif
   end else begin
      IF N_ELEMENTS(imin) eq 0 then imin = 0.0
      IF N_ELEMENTS(imax) eq 0 then imax = max(d)
   end
;
; scale image
;
   color_bar = make_colorbar(256,HEIGHT=10,MIN=imin,MAX=imax)
   if imin ne imax then begin
      case trans of 
         'Log': begin
            d = d-imin
            tmin = imax/10e4
            d = BYTSCL(ALOG(d>tmin<imax))
            scaled_color_bar=BYTSCL(ALOG(color_bar>tmin<imax))
         end
         'Linear': BEGIN
            d = BYTSCL(d,MIN=imin,MAX=imax)
            scaled_color_bar=BYTSCL(color_bar,MIN=imin,MAX=imax)
         END 
         'Square Root': BEGIN
            d = BYTSCL(sqrt( (d-imin)>0<(imax-imin)))
            scaled_color_bar=BYTSCL(sqrt((color_bar-imin)>0<(imax-imin)))
         END
         'Histogram Equalization': BEGIN
            d = BYTSCL(HIST_EQUAL(d,MINV=imin,MAXV=imax))
         END
      end
   end
   IF (reverse eq 0) and (color eq 0) then BEGIN
      d = 255b - TEMPORARY(d)
      IF N_ELEMENTS(scaled_color_bar) GT 0 THEN $
       scaled_color_bar = 255b - TEMPORARY(scaled_color_bar)
   ENDIF 
;
; set up postscript
;
   saved_device = !D.NAME
   SET_PLOT,'ps'
   filename = STRTRIM(sxpar(h,'filename'))
   xsize = 7.4
   ysize = 9.5
   DEVICE, FILE=filename+'.ps', /INCHES, XOFF=0.7, YOFF=0.7, XSIZE=xsize, $
    YSIZE=ysize, BITS=8, /PORTRAIT
   print,'Creating file '+filename+'.ps'
;
; load color table
;
   IF color NE 0 THEN BEGIN
      IF color GT 0 THEN LOADCT,color $
      ELSE TVLCT, CONGRID(r,256), CONGRID(g,256), CONGRID(b,256)
   ENDIF
;
; display image
;
   yoff = ysize - xsize
   ximage = xsize
   yimage = xsize
   if nsout lt nlout then ximage = ximage*(FLOAT(nsout)/nlout)
   if nlout lt nsout then yimage = yimage*(FLOAT(nlout)/nsout)
   x1 = 0
   y1 = yoff/ysize-0.03
   x2 = ximage/xsize
   y2 = (yimage+yoff)/ysize - 0.03
   TV, d, x1, y1, XSIZE=(x2-x1), YSIZE=(y2-y1), /NORM
   PLOTS, [x1,x2,x2,x1,x1], [y1,y1,y2,y2,y1], /NORMAL, THICK=2
;
; print header info
;
   delta = 0.023
   !p.font = 0
   date = STRTRIM(sxpar(h,'date-obs')) + '  ' + STRTRIM(sxpar(h,'time-obs'))
   if entry gt 0 then st = 'Entry '+STRTRIM(entry,2) else st=''

   rootname = STRTRIM( SXPAR( h, 'rootname' ), 2 )
   mebid    = STRTRIM( SXPAR( h, 'mebid' ), 2 )
   IF ( (rootname NE '') AND $
        ( STRUPCASE(rootname) NE 'JAAABBCC' ) AND $
        ( STRUPCASE(rootname) NE 'JAAAAAAA' ) AND $
        ( STRUPCASE(rootname) NE 'JABCDEFG' ) ) THEN BEGIN
      st = st + '      ' + filename + '      ' + rootname + $
       '      Side ' + mebid
   ENDIF ELSE st = st+'      '+filename + '      Side ' + mebid

   XYOUTS,0,0.98,st,/NORM
   XYOUTS,1.0,0.98,date,/NORM,align=1.0
;
; first column
;
   st = STRTRIM(sxpar(h,'STIMULUS')) + '  '+STRTRIM(sxpar(h,'ENVIRON'),2)
   XYOUTS,0,y1-delta,st,/NORM

   detector = STRTRIM(sxpar(h,'detector'))
   st = detector
   if detector ne 'SBC' then st = detector + '  Amp: '+ $
    STRTRIM(sxpar(h,'ccdamp'))
   XYOUTS,0,y1-delta*2,st,/NORM

   obstype = 'Obstype = '+STRTRIM(sxpar(h,'obstype'))	
   XYOUTS,0,y1-delta*3,obstype,/NORM

   exptime = STRTRIM(STRING(sxpar(h,'exptime'),'(F10.1)'),2)+' Sec.'
   XYOUTS,0,y1-delta*4,'Exptime = '+exptime,/NORM
   
   IF detector EQ 'SBC' THEN BEGIN
      fw3off = sxpar(h,'FW3OFF')
      IF ABS(fw3off) GT 0 THEN stroff3=' : '+STRTRIM(fw3off,2) ELSE stroff3=''
      filter3 = STRTRIM(sxpar(h,'filter3'), 2)
      XYOUTS, 0, y1-delta*5, 'Filter3 = '+filter3+stroff3, /NORM
   ENDIF ELSE BEGIN
      fw1off = sxpar(h,'FW1OFF')
      fw2off = sxpar(h,'FW2OFF')
      IF ABS(fw1off) GT 0 THEN stroff1=' : '+STRTRIM(fw1off,2) ELSE stroff1=''
      IF ABS(fw2off) GT 0 THEN stroff2=' : '+STRTRIM(fw2off,2) ELSE stroff2=''
      filter1 = STRTRIM(sxpar(h,'filter1'), 2)
      filter2 = STRTRIM(sxpar(h,'filter2'), 2)
      XYOUTS, 0, y1-delta*5, 'Filter1 = '+filter1+stroff1, /NORM
      XYOUTS, 0, y1-delta*6, 'Filter2 = '+filter2+stroff2, /NORM
   ENDELSE
   IF detector EQ 'WFC' THEN BEGIN
      blocksize = sxpar(hudl,'JQWCOMBS')
      partial_flag = sxpar(hudl,'JQWPOCMP')
      IF blocksize GT 0 THEN BEGIN
         IF partial_flag GT 0 THEN st = 'Partial Compression' $
         ELSE st = 'Full Compression'
         XYOUTS, 0, y1-delta*7, st, /NORM
      ENDIF
   ENDIF
;
; second column
;		
   st = 'Size = '+STRTRIM(ns,2)+' x '+STRTRIM(nl,2)	
   XYOUTS,0.33,y1-delta,st,/NORM

   sclamp = 'Sclamp = '+sxpar(h,'sclamp')
   XYOUTS,0.33,y1-delta*2,sclamp,/NORM	
   
   if detector eq 'SBC' then begin
      st = 'Mglobal = '+ STRTRIM(STRING(mglobal,'(F10.1)'))
      XYOUTS,0.33,y1-delta*3,st,/NORM	
   end else begin
      st = 'CCD gain = '+STRTRIM(sxpar(h,'CCDGAIN'),2)
      XYOUTS,0.33,y1-delta*3,st,/NORM	
      st = 'CCD offset = '+STRTRIM(sxpar(h,'CCDOFF'),2)
      XYOUTS,0.33,y1-delta*4,st,/NORM	
      st = 'CCD corner = '+STRTRIM(sxpar(h,'CCDXCOR'),2)+','+$
       STRTRIM(sxpar(h,'CCDYCOR'),2)
      XYOUTS,0.33,y1-delta*5,st,/NORM
      flash_status = STRUPCASE(STRTRIM(SXPAR(h,'FLSHSTAT'),2))
      IF flash_status EQ 'OKAY' THEN BEGIN
         st = STRING( FORMAT='(A,1X,A,1X,F6.2)', 'Flash = ', $
                      STRTRIM(SXPAR(h,'FLASHCUR'),2), SXPAR(h,'FLASHDUR') )
         XYOUTS, 0.33, y1-delta*6, st, /NORM
      ENDIF
   end
;
; third column
;
   if STRTRIM(sxpar(h,'STIMULUS')) eq 'STUFF' then begin
      st = 'STFTarg = '+STRTRIM(sxpar(h,'stftarg'))
      XYOUTS,0.60,y1-delta,st,/NORM
      st = 'STF LAMP = '+STRTRIM(sxpar(h,'lamp'))
      XYOUTS,0.60,y1-delta*2,st,/NORM
      rad1 = sxpar(h,'RADSGNL1')/(FLOAT(sxpar(h,'radtime1'))>0.001)
      st = 'RADSGNL1 = '+STRTRIM(sxpar(h,'radsgnl1'),2)+ ' / '+ $
       STRTRIM(sxpar(h,'radtime1'),2)+' Sec.'
      XYOUTS,0.60,y1-delta*3,st,/NORM
      rad2 = sxpar(h,'RADSGNL2')/(FLOAT(sxpar(h,'radtime2'))>0.001)
      st = 'RADSGNL2 = '+STRTRIM(sxpar(h,'radsgnl2'),2)+ ' / '+ $
       STRTRIM(sxpar(h,'radtime2'),2)+' Sec.'
      XYOUTS,0.60,y1-delta*4,st,/NORM
      ave = (rad1+rad2)/2.0
      st = 'Average = '+STRTRIM(STRING(ave,'(F10.1)'),2)+ ' / Sec.'
      XYOUTS,0.60,y1-delta*5,st,/NORM
   endif
   
   if STRTRIM(sxpar(h,'STIMULUS')) eq 'MONOHOMS' then begin
      st = 'MonoWave = '+STRTRIM(sxpar(h,'monowave'),2)
      XYOUTS,0.60,y1-delta,st,/NORM
      st = 'MonoGrtg = '+STRTRIM(sxpar(h,'monogrtg'),2)
      XYOUTS,0.60,y1-delta*2,st,/NORM
   endif

   st = trans + ' Display between '+STRING(imin,'(F8.1)')+'  and '+ $
    STRING(imax,'(F8.1)')+'     '+title
   XYOUTS,0,y1-delta*8,st,/NORM

   IF N_ELEMENTS(scaled_color_bar) GT 1 THEN BEGIN
      cb_y0 = -0.01
      cb_y1 = 0
      TV, scaled_color_bar, 0, cb_y0, XSIZE=(x2-x1), YSIZE=ABS(cb_y1-cb_y0), $
       /NORMAL
      PLOTS, [x1,x2,x2,x1,x1], [cb_y0,cb_y0,cb_y1,cb_y1,cb_y0], $
       /NORMAL, THICK=2
   ENDIF
   DEVICE, /CLOSE
   SET_PLOT, saved_device
   return
END

;;; REDSPEC, a GUI software package for reduction of spectrum data.
;;; Sungsoo S. Kim, UCLA Astronomy
;;; version 1.0 -- October, 2000
;;; version 2.0 -- December, 2000
;;; version 2.5 -- February, 2001
;;;
;;; Have the user locate the fringing regime and remove it in the frequency
;;;     domain.


;===============================================================================
PRO drawfringe, ps=ps

;;; Plot power spectra (upper panel) and spectrum intensities (lower panel).
;;; cal1orig, cal2orig	: original spectra
;;; cal1, cal2		: new spectra
;;; lines		: frequency boundaries (user input)

COMPILE_OPT idl2, hidden
COMMON fringecom,thedraw1,thedraw2,cal1,cal2,nline,lines,xdim,xdimfft, $
       cal1orig,cal2orig,rmflag,fringebase,minnow1,maxnow1, $
       minnow2,maxnow2,mintext1,maxtext1,mintext2,maxtext2,first

if keyword_set(ps) then begin
  !p.multi = [0, 1, 2]
endif else begin
  WSET, thedraw1
  RED =   [0, 1, 1, 0, 0, 1, 1, 0];Specify the red component of each color.
  GREEN = [0, 1, 0, 1, 0, 1, 0, 1];Specify the green component of each color.
  BLUE =  [0, 1, 0, 0, 1, 0, 1, 1];Specify the blue component of each color.
  TVLCT, 255 * RED, 255 * GREEN, 255 * BLUE
endelse

;;; Subtract a smooth background and FFT the spectrum.
nfil=xdim/2+1
freq=findgen(nfil)
cal1origmed=median(cal1orig)
cal1smooth=median(cal1orig,30)
cal1fft=fft(cal1orig-cal1smooth)
yp=abs(cal1fft[0:nfil-1])^2
ypmax=max(yp)
yp=yp/ypmax
if (first eq 1) then begin
  maxnow1=max(yp)*1.1
  WIDGET_CONTROL, maxtext1, SET_VALUE = string(maxnow1,format='(g8.2)')
endif
;;; Plot the original power spectrum (upper panel).
plot,freq,yp,xrange=[0,xdimfft],yrange=[minnow1,maxnow1],xstyle=1,ystyle=1, $
    xtitle='Frequency ('+strtrim(string(xdim),2)+' pix)!E-1', $
    ytitle='Power Spectrum',xmargin=[10,3],charsize=1.5
;;; Plot the new power spectrum, if any (upper panel).
if (rmflag eq 1) then begin
  cal1med=median(cal1)
  cal1smooth=median(cal1,30)
  cal1fft=fft(cal1-cal1smooth)
  oplot,freq,(abs(cal1fft[0:nfil-1])^2)/ypmax,color=2
endif
;;; Plot the horizontal boundary lines (upper panel).
for i=0,nline-1 do begin
  vertx=[lines[i],lines[i]]
  verty=[-1.e30,1.e30]
  oplot,vertx,verty,linestyle=2,color=3
endfor

if not(keyword_set(ps)) then WSET, thedraw2
yp1=cal1orig/cal1origmed
if (first eq 1) then begin
  maxnow2=max(yp1)*1.8
  WIDGET_CONTROL, maxtext2, SET_VALUE = string(maxnow2,format='(g8.2)')
  first=0
endif
;;; Plot the original spectrum intensity (lower panel).
plot,indgen(xdim)+1,yp1,xrange=[1,xdim],yrange=[minnow2,maxnow2],xstyle=1, $
    ystyle=1,xtitle='Pixel',ytitle='Normalized Intensity',xmargin=[10,3], $
    charsize=1.5
;;; Plot the new spectrum intensity, if any (lower panel)
if (rmflag eq 1) then begin
  yp2=cal1/cal1med+0.6
  oplot,indgen(xdim)+1,yp2,color=2
  yloc1=yp1[xdim/2*0.8]+0.2
  yloc2=yp2[xdim/2*0.8]+0.2
  xyouts,xdim/2*0.8,yloc1,'Original',charsize=1.4
  xyouts,xdim/2*0.8,yloc2,'Filtered',charsize=1.4,color=2
endif

if keyword_set(ps) then !p.multi=0

END


;===============================================================================
PRO fringe_ev, event

;;; Control widget events.
;;;
;;; Plot power spectra (upper panel) and spectrum intensities (lower panel).
;;; cal1orig, cal2orig	: original spectra
;;; cal1, cal2		: new spectra
;;; lines		: frequency boundaries (user input)

COMPILE_OPT idl2, hidden
COMMON fringecom,thedraw1,thedraw2,cal1,cal2,nline,lines,xdim,xdimfft, $
       cal1orig,cal2orig,rmflag,fringebase,minnow1,maxnow1, $
       minnow2,maxnow2,mintext1,maxtext1,mintext2,maxtext2,first

WIDGET_CONTROL, event.id, GET_UVALUE = eventval

CASE eventval OF

"EXIT": BEGIN
  WIDGET_CONTROL, event.top, /DESTROY
END


;;; Read user input (frequency).
"DISP": BEGIN
  x=event.x
  px=!x.window*!d.x_vsize
  x=fix((x-px[0])/(px[1]-px[0])*xdimfft)
  if event.type eq 0 and x ge 0 and x lt xdimfft then begin
    case nline of
      0: begin
           nline=1
           lines[0]=x
       end
      1: begin
           nline=2
           lines[1]=x
         end
      2: begin
           nline=2
           lines[0]=lines[1]
           lines[1]=x
         end
    endcase
    drawfringe
  endif
END


;;; Remove fringing by using the Finite Impulse Response (FIR) filter based
;;;     on the Hanning window (see IDL Manual).  Save the new spectrum in
;;;     'cal1' and 'cal2'.
"REMOVE": BEGIN
  if nline eq 2 then begin
    if lines[0] eq lines[1] then lines[1]=lines[0]+1

    f_high=min(lines)
    f_low=max(lines)
    nfil=xdim/2+1
    freq=findgen(nfil/2+1)/(nfil/float(xdim))
    fil=(freq gt f_low) or (freq lt f_high)
    fil=float(fil)
    fil=[fil,reverse(fil[1:*])]
    fil=float(fft(fil,/inverse))
    fil=fil/nfil
    fil=shift(fil,nfil/2)
    fil=fil*hanning(nfil)

    cal1smooth=median(cal1,30)
    cal1=convol(cal1-cal1smooth,fil,/edge_wrap)+cal1smooth
    cal2smooth=median(cal2,30)
    cal2=convol(cal2-cal2smooth,fil,/edge_wrap)+cal2smooth

    rmflag=1
    drawfringe
  endif else begin
    message=DIALOG_MESSAGE('Select two boundary points.', $
                           DIALOG_PARENT=fringebase)
  endelse
END


"UNDO": BEGIN
  cal1=cal1orig
  cal2=cal2orig
  nline=0
  rmflag=0
  drawfringe
END

"PS": BEGIN
  devicesave=!D.NAME
  SET_PLOT, 'ps'
  file='fringing.ps'
  DEVICE, FILENAME=file
  drawfringe, /ps
  DEVICE, /CLOSE
  SET_PLOT, devicesave
  message=DIALOG_MESSAGE(dialog_parent=fitdispbase, $
          'The plot has been saved as "'+file+'".',/information)
END

"YMIN1": BEGIN
  WIDGET_CONTROL, mintext1, GET_VALUE = minnow1
  minnow1=float(minnow1)
  WIDGET_CONTROL, mintext1, SET_VALUE = string(minnow1,format='(g8.2)')
  drawfringe
END

"YMAX1": BEGIN
  WIDGET_CONTROL, maxtext1, GET_VALUE = maxnow1
  maxnow1=float(maxnow1)
  WIDGET_CONTROL, maxtext1, SET_VALUE = string(maxnow1,format='(g8.2)')
  drawfringe
END

"YMIN2": BEGIN
  WIDGET_CONTROL, mintext2, GET_VALUE = minnow2
  minnow2=float(minnow2)
  WIDGET_CONTROL, mintext2, SET_VALUE = string(minnow2,format='(g8.2)')
  drawfringe
END

"YMAX2": BEGIN
  WIDGET_CONTROL, maxtext2, GET_VALUE = maxnow2
  maxnow2=float(maxnow2)
  WIDGET_CONTROL, maxtext2, SET_VALUE = string(maxnow2,format='(g8.2)')
  drawfringe
END

ENDCASE

END


;===============================================================================
PRO fringe, cal1in, cal2in

;;; Prepare fringing parameters and widgets.
;;; cal1in	: spectrum 1 (input & output)
;;; cal2in	: spectrum 2 (input & output)

COMPILE_OPT idl2, hidden
COMMON fringecom,thedraw1,thedraw2,cal1,cal2,nline,lines,xdim,xdimfft, $
       cal1orig,cal2orig,rmflag,fringebase,minnow1,maxnow1, $
       minnow2,maxnow2,mintext1,maxtext1,mintext2,maxtext2,first

xdim=n_elements(cal1in)
xdimfft=250
nline=0 & lines=indgen(2)
cal1=cal1in
cal2=cal2in
cal1orig=cal1
cal2orig=cal2
rmflag=0
minnow1=0 & maxnow1=0 & minnow2=0 & maxnow2=0 & first=1

;;; Prepare widgets
fringebase = WIDGET_BASE(TITLE = "REDSPEC - FRINGING", /COLUMN)

msglabel = WIDGET_LABEL(fringebase, /ALIGN_LEFT, $
   VALUE='Locate the fringing regime, if any, in the frequency domain.')

menubase = WIDGET_BASE(fringebase, /ROW)
donebutton = WIDGET_BUTTON(menubase, VALUE=' Done ', UVALUE='EXIT')
msglabel2 = WIDGET_LABEL(menubase, VALUE='        ')
yesbutton = WIDGET_BUTTON(menubase, VALUE=' Remove Fringing ', $
                          UVALUE='REMOVE')
undobutton = WIDGET_BUTTON(menubase, VALUE=' Reset ', UVALUE='UNDO')
msglabel3 = WIDGET_LABEL(menubase, VALUE='        ')
psbutton = WIDGET_BUTTON(menubase, VALUE=' Postscript ', UVALUE='PS')

minmaxbase = WIDGET_BASE(fringebase, /ROW)
msg1 = WIDGET_LABEL(minmaxbase, VALUE='Upper window:')
mintext1 = CW_FIELD(minmaxbase, VALUE=string(minnow1,format='(g8.2)'), $
                        UVALUE='YMIN1', XSIZE=8, /RETURN_EVENTS, TITLE='Min')
maxtext1 = CW_FIELD(minmaxbase, VALUE=string(maxnow1,format='(g8.2)'), $
                        UVALUE='YMAX1', XSIZE=8, /RETURN_EVENTS, TITLE='Max')
msg2 = WIDGET_LABEL(minmaxbase, VALUE='      Lower window:')
mintext2 = CW_FIELD(minmaxbase, VALUE=string(minnow2,format='(g8.2)'), $
                        UVALUE='YMIN2', XSIZE=8, /RETURN_EVENTS, TITLE='Min')
maxtext2 = CW_FIELD(minmaxbase, VALUE=string(maxnow2,format='(g8.2)'), $
                        UVALUE='YMAX2', XSIZE=8, /RETURN_EVENTS, TITLE='Max')

display1 = WIDGET_DRAW(fringebase, RETAIN=2, XSIZE=850, YSIZE=350, $
			  /BUTTON_EVENTS, UVALUE='DISP')
display2 = WIDGET_DRAW(fringebase, RETAIN=2, XSIZE=850, YSIZE=350)

WIDGET_CONTROL, fringebase, /REALIZE
WIDGET_CONTROL, display1, GET_VALUE = thedraw1
WIDGET_CONTROL, display2, GET_VALUE = thedraw2
TVLCT, R_ORIG, G_ORIG, B_ORIG, /GET

drawfringe

XManager, "fringe", fringebase, EVENT_HANDLER = "fringe_ev"

TVLCT, R_ORIG, G_ORIG, B_ORIG

cal1in=float(cal1)
cal2in=float(cal2)

END

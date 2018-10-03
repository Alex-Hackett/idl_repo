;;; REDSPEC, a GUI software package for reduction of spectrum data.
;;; Sungsoo S. Kim, UCLA Astronomy
;;; version 1.0 -- October, 2000
;;; version 2.0 -- December, 2000
;;; version 2.5 -- February, 2001
;;;
;;; Remove intrinsic spectral features of calibrator with interpolation.


;===============================================================================
PRO drawcal

;;; Draw the spectrum and vertical bars.

COMPILE_OPT idl2, hidden
COMMON rmlinecom,thedraw1,caltemp,calold,lambdatemp,nline,lines,xdim, $
       lambdamin,lambdamax,averwidth,rmlinebase,minnow,maxnow,mintext,maxtext

WSET, thedraw1
RED =   [0, 1, 1, 0, 0, 1, 1, 0];Specify the red component of each color.
GREEN = [0, 1, 0, 1, 0, 1, 0, 1];Specify the green component of each color.
BLUE =  [0, 1, 0, 0, 1, 0, 1, 1];Specify the blue component of each color.
TVLCT, 255 * RED, 255 * GREEN, 255 * BLUE

;;; Spectrum
plot,lambdatemp,caltemp,xrange=[lambdamin,lambdamax],yrange=[minnow,maxnow], $
    xstyle=1,ystyle=1,ytitle='Normalized Calibrator Intensity', $
    xtitle='Wavelength',xmargin=[10,3],charsize=1.5
oplot,lambdatemp,caltemp

;;; Vertical bars
for i=0,nline-1 do begin
  vertx=[lines[i],lines[i]]
  verty=[-1.e30,1.e30]
  oplot,vertx,verty,linestyle=2,color=3
endfor

END


;===============================================================================
PRO rmline_ev, event

;;; Control widget events.

COMPILE_OPT idl2, hidden
COMMON rmlinecom,thedraw1,caltemp,calold,lambdatemp,nline,lines,xdim, $
       lambdamin,lambdamax,averwidth,rmlinebase,minnow,maxnow,mintext,maxtext

WIDGET_CONTROL, event.id, GET_UVALUE = eventval

CASE eventval OF

;;; Read the user's input for the interpolation boundary.
"BUTTON": BEGIN
  x=event.x
  px=!x.window*!d.x_vsize
  x=(x-px[0])/(px[1]-px[0])*(lambdamax-lambdamin)+lambdamin
  if event.type eq 0 and x ge lambdamin and x le lambdamax then begin
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
    drawcal
  endif
END

"EXIT": BEGIN
  WIDGET_CONTROL, event.top, /DESTROY
END

;;; Remove the spectrum of the chosen region with interpolation.
;;;
;;; wavea	: lambda of the lower boundary
;;; waveb	: lambda of the upper boundary
;;; wavea1	: lower boundary (for averaging) of the lower boundary
;;; wavea2	: upper boundary (for averaging) of the lower boundary
;;; waveb1	: lower boundary (for averaging) of the upper boundary
;;; waveb2	: upper boundary (for averaging) of the upper boundary
;;; fluxa	: averaged flux at the lower boundary
;;; fluxb	: averaged flux at the upper boundary
"REMOVE": BEGIN
  if nline eq 2 then begin
    calold=caltemp
    if lines[0] eq lines[1] then lines[1]=lines[0]+1
    line1=min(lines)
    line2=max(lines)
    wavea=fix((line1-lambdamin)/(lambdamax-lambdamin)*(xdim-1))
    wavea=(wavea>0)<(xdim-1)
    waveb=fix((line2-lambdamin)/(lambdamax-lambdamin)*(xdim-1))
    waveb=(waveb>0)<(xdim-1)
    wavea1=(wavea-averwidth/2)>0
    wavea2=(wavea+(averwidth-1)/2)<(xdim-1)
    waveb1=(waveb-averwidth/2)>0
    waveb2=(waveb+(averwidth-1)/2)<(xdim-1)
    if (wavea1 ne wavea2) then begin
      result=moment(caltemp[wavea1:wavea2])
      fluxa=result[0]
    endif else begin
      fluxa=caltemp[wavea1]
    endelse
    if (waveb1 ne waveb2) then begin
      result=moment(caltemp[waveb1:waveb2])
      fluxb=result[0]
    endif else begin
      fluxb=caltemp[waveb1]
    endelse
    for i=wavea+1,waveb-1 do caltemp[i]=fluxa+(fluxb-fluxa)*(i-wavea)/ $
					      (waveb-wavea)
    nline=0
    drawcal
  endif else begin
    message=DIALOG_MESSAGE('Select two boundary points.', $
                           DIALOG_PARENT=rmlinebase)
  endelse
END

"UNDO": BEGIN
  caltemp2=caltemp
  caltemp=calold
  calold=caltemp2
  nline=0
  drawcal
END

"SLIDER": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value
  averwidth=value
END

"YMIN": BEGIN
  WIDGET_CONTROL, mintext, GET_VALUE = minnow
  minnow=float(minnow)
  WIDGET_CONTROL, mintext, SET_VALUE = string(minnow,format='(g8.2)')
  drawcal
END

"YMAX": BEGIN
  WIDGET_CONTROL, maxtext, GET_VALUE = maxnow
  maxnow=float(maxnow)
  WIDGET_CONTROL, maxtext, SET_VALUE = string(maxnow,format='(g8.2)')
  drawcal
END

ENDCASE

END


;===============================================================================
PRO rmline, cal, lambda

;;; Prepare parameters and widgets.
;;;
;;; cal		: input spectrum (input & output)
;;; lambda	: wavelength of 'cal' (input)

COMPILE_OPT idl2, hidden
COMMON rmlinecom,thedraw1,caltemp,calold,lambdatemp,nline,lines,xdim, $
       lambdamin,lambdamax,averwidth,rmlinebase,minnow,maxnow,mintext,maxtext

;;; Prepare parameters.
xdim=n_elements(cal)
nline=0 & lines=findgen(2)
calmed=median(cal)
caltemp=cal/calmed
calold=caltemp
minnow=0.
maxnow=max(caltemp)*1.2
lambdatemp=lambda
lambdamin=lambda[0]
lambdamax=lambda[xdim-1]
averwidth=5

;;; Prepare widgets.
rmlinebase = WIDGET_BASE(TITLE="REDSPEC - INTRINSIC CALIBRATOR FEATURES", $
    /COLUMN)

msglabel = WIDGET_LABEL(rmlinebase, /ALIGN_LEFT, $
    VALUE='Calibrator spectrum: Click two boundary points to interpolate over the intrinsic calibrator features.')

menubase = WIDGET_BASE(rmlinebase, /ROW)
menubase1 = WIDGET_BASE(menubase, /ROW)
donebutton = WIDGET_BUTTON(menubase1, VALUE=' Done ', UVALUE='EXIT')
label1 = WIDGET_LABEL(menubase1, VALUE='      ')
yesbutton = WIDGET_BUTTON(menubase1, VALUE=' Remove Calibrator Feature ', $
			  UVALUE='REMOVE')
undobutton = WIDGET_BUTTON(menubase1, VALUE=' Undo ', UVALUE='UNDO')
label1 = WIDGET_LABEL(menubase1, VALUE='      ')
menubase2 = WIDGET_BASE(menubase, /COLUMN)
slider1 = WIDGET_SLIDER(menubase2, MINIMUM=1, MAXIMUM=50, VALUE=averwidth, $
			TITLE='Boundary Width', XSIZE=150, UVALUE='SLIDER')

minmaxbase = WIDGET_BASE(rmlinebase, /ROW)
mintext = CW_FIELD(minmaxbase, VALUE=string(minnow,format='(g8.2)'), $
                        UVALUE='YMIN', XSIZE=8, /RETURN_EVENTS, TITLE='Min')
maxtext = CW_FIELD(minmaxbase, VALUE=string(maxnow,format='(g8.2)'), $
                        UVALUE='YMAX', XSIZE=8, /RETURN_EVENTS, TITLE='Max')
display = WIDGET_DRAW(rmlinebase, RETAIN=2, XSIZE=800, YSIZE=480, $
			  SCR_XSIZE=max([800,xdim]), $
			  /BUTTON_EVENTS, UVALUE='BUTTON' )

ghostbase = WIDGET_BASE(rmlinebase)
ghostdisp = WIDGET_DRAW(ghostbase, RETAIN=2, XSIZE=10, YSIZE=10)
WIDGET_CONTROL, ghostbase, MAP=0

WIDGET_CONTROL, rmlinebase, /REALIZE
WIDGET_CONTROL, display, GET_VALUE = thedraw1
TVLCT, R_ORIG, G_ORIG, B_ORIG, /GET

drawcal

XManager, "rmline", rmlinebase, EVENT_HANDLER = "rmline_ev"

TVLCT, R_ORIG, G_ORIG, B_ORIG

cal=caltemp*calmed

END

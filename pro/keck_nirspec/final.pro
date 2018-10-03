;;; REDSPEC, a GUI software package for reduction of spectrum data.
;;; Sungsoo S. Kim, UCLA Astronomy
;;; version 1.0 -- October, 2000
;;; version 2.0 -- December, 2000
;;; version 2.5 -- February, 2001
;;;
;;; Display images rectified in spatmap.pro and specmap.pro.


;===============================================================================
PRO drawfinal

;;; Display the image.

COMPILE_OPT idl2, hidden
COMMON finalcom,thedraw1,type,finalbase,use_callamp
COMMON bytimage3,image,bytmin,bytmax,xdim,ydim,ctable,nctable
COMMON slidercom3,slider1,slider2,checklog
COMMON rightcom,imagenow,pressed,xstart,ystart,xold,yold,xdimtemp,ydimtemp, $
       thedrawtemp,ydim2temp,imageorig

WSET, thedraw1

if checklog then begin
  colorshift=bytmin-abs(bytmin)
  logbytmax=alog10((bytmax-colorshift)>1.e-20)
  logbytmin=alog10((bytmin-colorshift)>1.e-20)
  imagenow=bytscl(alog10((image-colorshift)>1.e-20),max=logbytmax, $
		  min=logbytmin,top=254)
endif else begin
  imagenow=bytscl(image,max=bytmax,min=bytmin,top=254)
endelse

tv,imagenow,0,0

END


;===============================================================================
PRO final_event, event

;;; Control widget events.

COMPILE_OPT idl2, hidden
COMMON finalcom,thedraw1,type,finalbase,use_callamp
COMMON bytimage3,image,bytmin,bytmax,xdim,ydim,ctable,nctable
COMMON slidercom3,slider1,slider2,checklog

WIDGET_CONTROL, event.id, GET_UVALUE = eventval

CASE eventval OF

"SLIDER1": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value1
  bytmin=ctable[long((nctable-1.)*value1/1000.)]
  drawfinal
END

"SLIDER2": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value2
  bytmax=ctable[long((nctable-1.)*(1.-value2/1000.))]
  drawfinal
END

"LOG": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = checklog
  drawfinal
END

"XLOADCT": BEGIN
  xloadct
END

"EXIT": BEGIN
  if (use_callamp eq 0) then str='' else str='.cal'
  if (type eq 1) then message=DIALOG_MESSAGE(DIALOG_PARENT=finalbase, $
      'Spatial map has been saved as "spat.map'+str+'".', /INFORMATION, $
      TITLE='Done with SPATMAP')
  if (type eq 2) then message=DIALOG_MESSAGE(DIALOG_PARENT=finalbase, $
      'Spectral map has been saved as "spec.map'+str+'".', /INFORMATION, $
      TITLE='Done with SPECMAP')
  WIDGET_CONTROL, event.top, /DESTROY
END

ENDCASE

END


;===============================================================================
PRO final, inimage, type=typein, use_callamp=use_callampin

;;; Display images rectified in spatmap.pro and specmap.pro.
;;;
;;; inimage	: image to be displayed (input)
;;; type	: 1 for spatmap.pro, 2 for specmap.pro.
;;; use_callmap	: flag for the user of callamp instead of tarlamp

COMPILE_OPT idl2, hidden
COMMON finalcom,thedraw1,type,finalbase,use_callamp
COMMON bytimage3,image,bytmin,bytmax,xdim,ydim,ctable,nctable
COMMON slidercom3,slider1,slider2,checklog
COMMON rightcom,imagenow,pressed,xstart,ystart,xold,yold,xdimtemp,ydimtemp, $
       thedrawtemp,ydim2temp,imageorig

; type=1: spatial map
; type=2: spectral map

image=inimage
if (n_elements(typein) eq 0) then begin
  type=0
endif else begin
  type=typein
endelse
if (n_elements(use_callampin) eq 0) then begin
  use_callamp=0
endif else begin
  use_callamp=use_callampin
endelse

checklog=0
imagesize=size(image)
xdim=imagesize[1] & ydim=imagesize[2]
if (imagesize[0] eq 1) then ydim=1

;;; Prepare color table. ('ctable' is used to clip out extreme pixel values
;;;     before assigning colors to each pixel.)
ncol=(20<xdim) & nrow=(20<ydim) & nelem1=ncol*ydim & nelem2=nrow*xdim
colcol=fix((indgen(ncol)+0.5)/ncol*xdim)
colrow=fix((indgen(nrow)+0.5)/nrow*ydim)
ctable1=image[colcol,*]
ctable1=reform(ctable1,nelem1)
ctable2=image[*,colrow]
ctable2=reform(ctable2,nelem2)
ctable=[ctable1,ctable2]
ctable=ctable[sort(ctable)]
cmin=min(ctable)
cmax=max(ctable)
cushion1=reverse(cmin-(findgen(5)+1)*(cmax-cmin)*0.05)
cushion2=cmax+(findgen(5)+1)*(cmax-cmin)*0.05
ctable=[cushion1,ctable,cushion2]
nctable=n_elements(ctable)
bytmin=ctable[0]
bytmax=ctable[nctable-1]

;;; Prepare widgets.
finalbase = WIDGET_BASE(TITLE = 'Rectified Image', /COLUMN)

;msglabel = WIDGET_LABEL(finalbase, /ALIGN_LEFT, YSIZE=30, $
;    VALUE='')

topbase =  WIDGET_BASE(finalbase, /ROW)
if (typein eq 1) then begin
  donebutton = WIDGET_BUTTON(topbase, VALUE=' Done with SPATMAP ',UVALUE='EXIT')
endif else begin
  donebutton = WIDGET_BUTTON(topbase, VALUE=' Done with SPECMAP ',UVALUE='EXIT')
endelse

sliderbase = WIDGET_BASE(finalbase, /ROW)
slider1 = WIDGET_SLIDER(sliderbase, MINIMUM=0, MAXIMUM=100, $
                        XSIZE=200, VALUE=0, UVALUE='SLIDER1', $
			TITLE=' x 0.1% Lower')
slider2 = WIDGET_SLIDER(sliderbase, MINIMUM=100, MAXIMUM=0, $
                        XSIZE=200, VALUE=0, UVALUE='SLIDER2', $
			TITLE=' x 0.1% Upper')
checkbutton = CW_BGROUP(sliderbase, 'Log', UVALUE='LOG', /NONEXCLUSIVE, $
                        XOFFSET=10, FRAME=5)
spacetext = WIDGET_LABEL(sliderbase, VALUE='', XSIZE=50)
xloadctbutton = WIDGET_BUTTON(sliderbase, VALUE=' XLoadCT ', UVALUE='XLOADCT')

device, get_screen_size=screen
if (screen[0] lt 1200) then xscr=800 else xscr=1024
if (screen[1] lt 900)  then yscr=400 else yscr=640
extra=''
if (xdim gt xscr) then extra = {X_SCROLL_SIZE:xscr, Y_SCROLL_SIZE:ydim+2}
if (ydim gt yscr) then extra = {X_SCROLL_SIZE:xdim+2, Y_SCROLL_SIZE:yscr}
if (xdim gt xscr and ydim gt yscr) then extra = {X_SCROLL_SIZE:xscr, $
    Y_SCROLL_SIZE:yscr}
display = WIDGET_DRAW(finalbase, RETAIN=2, XSIZE=xdim, YSIZE=ydim, $
			  _Extra=extra, $
			  /BUTTON_EVENTS, /MOTION_EVENTS, UVALUE='BUTTON', $
			  EVENT_PRO='right' )

ghostbase = WIDGET_BASE(finalbase)
ghostdisp = WIDGET_DRAW(ghostbase, RETAIN=2, XSIZE=10, YSIZE=10)
WIDGET_CONTROL, ghostbase, MAP=0

WIDGET_CONTROL, finalbase, /REALIZE
WIDGET_CONTROL, display, GET_VALUE = thedraw1

;;; Variables for right.pro
xdimtemp=xdim & ydimtemp=ydim & thedrawtemp=thedraw1 & ydim2temp=ydim
imageorig=image

drawfinal

XManager, "final", finalbase

END

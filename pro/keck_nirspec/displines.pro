;;; REDSPEC, a GUI software package for reduction of spectrum data.
;;; Sungsoo S. Kim, UCLA Astronomy
;;; version 1.0 -- October, 2000
;;; version 2.0 -- December, 2000
;;; version 2.5 -- February, 2001
;;;
;;; Show an image and get inputs (y-clips) from the user.
;;; Called from pipe.pro and spatmap.pro.


;===============================================================================
PRO disp_draw

;;; Display the image.

COMPILE_OPT idl2, hidden
COMMON dispcom,thedraw1,thedraw2,bytmin,bytmax,xdim,ydim,smallsize,enlarge, $
       image,sprite,spxa,spxb,spya,spyb,nlinemin,ctable,nctable,dispbase
COMMON buttoncom,nline,lines,valuetext,coordtext,nobutton,width,abort
COMMON slidercom,slider1,slider2,checklog
COMMON rightcom,imagetemp,pressed,xstart,ystart,xold,yold,xdimtemp,ydimtemp, $
       thedrawtemp,ydim2temp,imageorig

; sprite=0 : Whole image drawing.
; sprite=1 : No image drawing.
; sprite=2 : Partial image redrawing.

WSET, thedraw1

if checklog then begin
  colorshift=bytmin-abs(bytmin)
  logbytmax=alog10((bytmax-colorshift)>1.e-20)
  logbytmin=alog10((bytmin-colorshift)>1.e-20)
  imagetemp=bytscl(alog10((image-colorshift)>1.e-20),max=logbytmax, $
		   min=logbytmin,top=254)
endif else begin
  imagetemp=bytscl(image,max=bytmax,min=bytmin,top=254)
endelse

if (sprite eq 0) then tv,imagetemp,0,0
if (sprite eq 2) then tv,imagetemp[spxa:spxb,spya:spyb],spxa,spya
if (n_elements(xstart) ne 0) then right_erase

disp_draw2

sprite=0  

END


;===============================================================================
PRO disp_draw2

;;; Display the location of clips.
;;; 'width' is set to -1 for calls from spatmap.pro since the width of
;;;     the clip is determined by two picks.

COMPILE_OPT idl2, hidden
COMMON dispcom,thedraw1,thedraw2,bytmin,bytmax,xdim,ydim,smallsize,enlarge, $
       image,sprite,spxa,spxb,spya,spyb,nlinemin,ctable,nctable,dispbase
COMMON buttoncom,nline,lines,valuetext,coordtext,nobutton,width,abort

if (nline ge 1) then begin
  spyai=intarr(nline)+ydim-1
  spybi=intarr(nline)
endif

for i=0,nline-1 do begin
  xp=findgen(2)*(xdim-1)
  yp=fltarr(2)+lines[i]
  spyai[i]=yp[0] & spybi[i]=yp[0]
  if (width ne -1) then begin
    ;;; for calls from pipe.pro
    plot,xp,yp,xrange=[0,xdim],yrange=[0,ydim],xstyle=5,ystyle=5,$
        xmargin=[0,0],ymargin=[0,0],color=0,/noerase
    ypa=fltarr(2)+lines[i]-width/2
    ypb=fltarr(2)+lines[i]+(width-1)/2
    plot,xp,ypa,linestyle=2,xrange=[0,xdim],yrange=[0,ydim],xstyle=5,$
        ystyle=5,xmargin=[0,0],ymargin=[0,0],color=0,/noerase
    plot,xp,ypb,linestyle=2,xrange=[0,xdim],yrange=[0,ydim],xstyle=5,$
        ystyle=5,xmargin=[0,0],ymargin=[0,0],color=0,/noerase
    spyai[i]=ypa[0] & spybi[i]=ypb[0]
  endif else begin
    ;;; for calls from spatmap.pro
    plot,xp,yp,xrange=[0,xdim],yrange=[0,ydim],xstyle=5,ystyle=5,linestyle=5,$
        xmargin=[0,0],ymargin=[0,0],color=255,/noerase
  endelse
endfor

;;; spxa, spxb, spya, spyb : vertices of a rectagle to be redrawn later
if (nline ge 1) then begin
  spya=min(spyai)
  spyb=max(spybi)
  spxa=0
  spxb=xdim-1
endif

END


;===============================================================================
PRO disp_ev, event

;;; Control widget events.

COMPILE_OPT idl2, hidden
COMMON dispcom,thedraw1,thedraw2,bytmin,bytmax,xdim,ydim,smallsize,enlarge, $
       image,sprite,spxa,spxb,spya,spyb,nlinemin,ctable,nctable,dispbase
COMMON buttoncom,nline,lines,valuetext,coordtext,nobutton,width,abort
COMMON slidercom,slider1,slider2,checklog

WIDGET_CONTROL, event.id, GET_UVALUE = eventval

CASE eventval OF

;;; Get user's pick, draw mag window, and display coord & pixel info.
"DISP" : BEGIN
  x=event.x
  y=event.y

  right, event, redraw='disp_draw2'

  ;;; Save the user's choice in 'lines(i)'.
  if event.press eq 1 and nobutton eq 0 then begin
    if (width ne -1) then begin
      ya=y-width/2
      yb=y+(width-1)/2
      if (ya lt 0) then y=width/2
      if (yb gt ydim-1) then y=ydim-1-(width-1)/2
    endif else begin
      ;; The else section was added by SZK.
      ;; This else clause only applies to spatmap clipping and  will prevent
      ;; the clipping get too close to the edges. For a better performance
      ;; of fixpix, a cushion of 4 pixels is used. Do not modify the
      ;; size of this cushion without changing the lines below.
      fixpix_cushion = 4
      if (y gt ydim-1-fixpix_cushion) then y = ydim-1-fixpix_cushion
      if (y lt fixpix_cushion) then y = fixpix_cushion
    endelse
    case nline of
      0: begin
	   nline=1
	   lines[0]=y
           sprite=1
         end
      1: begin
	   if (nlinemin eq 2) then begin
	     nline=2
	     lines[1]=y
             sprite=1
	   endif else begin
	     nline=1
	     lines[0]=y
             sprite=2
	   endelse
         end
      2: begin
	   nline=2
	   lines[0]=lines[1]
	   lines[1]=y
           sprite=2
         end
    endcase
    ;;; Redraw the main image.
    disp_draw
  endif

  ;;; Display the magnification window.
  ;;; smallsize	: # of data pixels to be shown in the mag window (1D)
  ;;; enlarge	: magnification factor
  ;;; pixsize	: # of actual pixels of the mag window (1D)
  ;;; cross	: length of cross hair in units of actual pixels
  ;;; xa,xb,ya,yb     : vertices of mag window on the data
  ;;; ixa,ixb,iya,iyb : x,y ranges to be displayed in the mag window (normally
  ;;;                   0 to smallsize-1, except near the image edges)
  half=smallsize/2
  pixsize=smallsize*enlarge
  center=pixsize/2
  cross=fix(enlarge*1.5)+1
  xa=((x-half)>0)<(xdim-1) & xb=((x+half)>0)<(xdim-1)
  ya=((y-half)>0)<(ydim-1) & yb=((y+half)>0)<(ydim-1)
  ixa=((half-x)>0)<(smallsize-1)
  ixb=((smallsize-1-(x+half-(xdim-1)))>0)<(smallsize-1)
  iya=((half-y)>0)<(smallsize-1)
  iyb=((smallsize-1-(y+half-(ydim-1)))>0)<(smallsize-1)
  imagetemp=fltarr(smallsize,smallsize)
  if checklog then begin
    colorshift=bytmin-abs(bytmin)
    logbytmax=alog10((bytmax-colorshift)>1.e-20)
    logbytmin=alog10((bytmin-colorshift)>1.e-20)
    imagetemp[ixa:ixb,iya:iyb]=bytscl(alog10((image[xa:xb,ya:yb]-colorshift) $
				      > 1.e-20), max=logbytmax,min=logbytmin)
  endif else begin
    imagetemp[ixa:ixb,iya:iyb]=bytscl(image[xa:xb,ya:yb],max=bytmax,min=bytmin)
  endelse
  ;;; Enlarge imagetemp by a factor of 'enlarge'.
  imagetemp2=rebin(imagetemp,pixsize,pixsize,sample=1)
  imagetemp2[center-cross:center+cross,center]=0
  imagetemp2[center,center-cross:center+cross]=0
  dashed=[indgen(enlarge),indgen(enlarge)+(smallsize-1)*enlarge]
  for i=0,nline-1 do begin
    ;;; Draw a solid line.
    linesmall=(lines[i]-ya+iya)*enlarge+enlarge/2
    if (linesmall ge 0 and linesmall lt pixsize) then imagetemp2[*,linesmall]=0
    ;;; Draw dashed lines.
    if (width ne -1) then begin
      ypa=(lines[i]-width/2-ya+iya)*enlarge+enlarge/2
      ypb=(lines[i]+(width-1)/2-ya+iya)*enlarge+enlarge/2
      if (ypa ge 0 and ypa lt pixsize) then imagetemp2[dashed,ypa]=0
      if (ypb ge 0 and ypb lt pixsize) then imagetemp2[dashed,ypb]=0
    endif
  endfor
  WSET, thedraw2
  tv,imagetemp2,0,0

  ;;; Display coordinate and pixel values.
  xpix=(x>0)<(xdim-1)
  ypix=(y>0)<(ydim-1)
  coord='('+string(xpix+1,format='(i4)')+','+string(ypix+1,format='(i4)')+')'
  pixvalue=string(image[xpix,ypix],format='(e10.3)')
  WIDGET_CONTROL, valuetext, SET_VALUE = pixvalue
  WIDGET_CONTROL, coordtext, SET_VALUE = coord
END

"NLINE": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value
  nlinemin=2-value
  if (nline eq 2) then begin
    nline=1
    sprite=2
  endif else begin
    sprite=1
  endelse
  disp_draw
END

"SLIDER1": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value1
  bytmin=ctable[long((nctable-1.)*value1/1000.)]
  disp_draw
END

"SLIDER2": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value2
  bytmax=ctable[long((nctable-1.)*(1.-value2/1000.))]
  disp_draw
END

"LOG": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = checklog
  disp_draw
END

"XLOADCT": BEGIN
  xloadct
END

;;; Change the clip height.
"CLIPHEIGHT": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value
  width=value
  ;;; Move the clip center if the clip goes out of bounds.
  ya=lines-width/2
  yb=lines+(width-1)/2
  for i=0,1 do begin
    if (ya[i] lt 0) then lines[i]=width/2
    if (yb[i] gt ydim-1) then lines[i]=ydim-1-(width-1)/2
  endfor
  if (nline ge 1) then begin
    sprite=2
  endif else begin
    sprite=1
  endelse
  disp_draw
END

"EXIT": BEGIN
  if nline eq nlinemin then begin
    WIDGET_CONTROL, event.top, /DESTROY
  endif else begin
    if (nlinemin eq 1) then begin
      message=DIALOG_MESSAGE('Select a row.', DIALOG_PARENT=dispbase)
    endif else begin
      message=DIALOG_MESSAGE('Select two rows.', DIALOG_PARENT=dispbase)
    endelse
  endelse
END

"ABORT": BEGIN
  message=DIALOG_MESSAGE('Are you sure to abort?', DIALOG_PARENT=dispbase, $
			/QUESTION, /DEFAULT_NO)
  if (message eq 'Yes') then begin
    abort=1
    WIDGET_CONTROL, event.top, /DESTROY
  endif
END

ELSE:; MESSAGE, "Event User Value Not Found"

ENDCASE

END



;===============================================================================
PRO displines, imagefile, linesout, outwidth, msg, title, low=low, pipe=pipe

;;; Show an image and get inputs (y-clips) from the user.
;;;
;;; imagefile	: name of input image
;;; linesout	: clip boundary for calls from spatmap.pro; clip center for
;;;		  calls from pipe.pro (output)
;;; outwidth	: width of the clip; -1 for calls from spatmap.pro (output)
;;; msg		: message to be displayed on the window
;;; title	: title of the window
;;; low		: flag for low resolution data
;;; pipe	: flag for calls from pipe.pro

COMPILE_OPT idl2, hidden
COMMON dispcom,thedraw1,thedraw2,bytmin,bytmax,xdim,ydim,smallsize,enlarge, $
       image,sprite,spxa,spxb,spya,spyb,nlinemin,ctable,nctable,dispbase
COMMON buttoncom,nline,lines,valuetext,coordtext,nobutton,width,abort
COMMON slidercom,slider1,slider2,checklog
COMMON rightcom,imagetemp,pressed,xstart,ystart,xold,yold,xdimtemp,ydimtemp, $
       thedrawtemp,ydim2temp,imageorig

smallsize=21  ; should be an odd number
enlarge=5     ; should be an odd number

if (n_elements(low) eq 0) then low=0
if (n_elements(pipe) eq 0) then pipe=0

image=readfits(imagefile)

if (low ne 0) then image=rotate(image,3)
imagesize=size(image)
xdim=imagesize[1] & ydim=imagesize[2]
if (imagesize[0] eq 1) then ydim=1
width=min([15,ydim])
if (n_elements(outwidth) ne 0) then begin
   if (outwidth eq -1) then width=-1
endif
nlinemin=2
sprite=0
nline=0
lines=intarr(2)
nobutton=0 & checklog=0 & abort=0

;;; Prepare color table.  ('ctable' is used to clip out extreme pixel values
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
dispbase = WIDGET_BASE(TITLE = title, /COLUMN)

msgbase = WIDGET_LABEL(dispbase, VALUE=msg, /ALIGN_LEFT, YSIZE=30)
menubase = WIDGET_BASE(dispbase, /ROW)
donebutton = WIDGET_BUTTON(menubase, VALUE=' Done ', UVALUE='EXIT')
msgbase = WIDGET_LABEL(menubase, VALUE=' ')
abortbutton = WIDGET_BUTTON(menubase, VALUE=' Abort ', UVALUE='ABORT')

smallbase = WIDGET_BASE(dispbase, /ROW)
smallbase1 = WIDGET_BASE(smallbase, /COLUMN)
dispsmall = WIDGET_DRAW(smallbase1, XSIZE=smallsize*enlarge, $
			YSIZE=smallsize*enlarge, RETAIN=2)
smallbase2 = WIDGET_BASE(smallbase, /COLUMN)
valuetext = WIDGET_LABEL(smallbase2, VALUE='', XSIZE=120, YSIZE=20, /ALIGN_LEFT)
coordtext = WIDGET_LABEL(smallbase2, VALUE='', XSIZE=120, YSIZE=20, /ALIGN_LEFT)
fitlabel1 = WIDGET_LABEL(smallbase, VALUE='          ')
smallbase3 = WIDGET_BASE(smallbase, /COLUMN)
if (pipe eq 1) then begin
  nlinebutton = CW_BGROUP(smallbase3, ['Nod1-Nod2  ','On-Off  '], $
			UVALUE='NLINE', SET_VALUE=2-nlinemin, /EXCLUSIVE, $
			/NO_RELEASE, /ROW)
endif
fitlabel2 = WIDGET_LABEL(smallbase3, VALUE='          ')
device, get_screen_size=screen
if (screen[0] lt 1200) then xscr=800 else xscr=1024
if (screen[1] lt 900)  then yscr=400 else yscr=640
if (width ne -1) then begin
  xsize=min([yscr*3,xscr-smallsize*enlarge-200])
  widthslider = WIDGET_SLIDER(smallbase3, MINIMUM=1, MAXIMUM=ydim, VALUE=width,$
      TITLE='Clip Height', XSIZE=xsize, UVALUE='CLIPHEIGHT')
endif

sliderbase = WIDGET_BASE(dispbase, /ROW)
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

extra=''
if (xdim gt xscr) then extra = {X_SCROLL_SIZE:xscr, Y_SCROLL_SIZE:ydim+2}
if (ydim gt yscr) then extra = {X_SCROLL_SIZE:xdim+2, Y_SCROLL_SIZE:yscr}
if (xdim gt xscr and ydim gt yscr) then extra = {X_SCROLL_SIZE:xscr, $
    Y_SCROLL_SIZE:yscr}
dispdisplay = WIDGET_DRAW(dispbase, RETAIN=2, $
			  XSIZE=xdim, YSIZE=ydim, $
			  _Extra=extra, $
			  /BUTTON_EVENTS, /MOTION_EVENTS, UVALUE='DISP')

WIDGET_CONTROL, dispbase, /REALIZE			;create the widgets

WIDGET_CONTROL, dispdisplay, GET_VALUE = thedraw1
WIDGET_CONTROL, dispsmall,   GET_VALUE = thedraw2

;;; Variabels for right.pro
xdimtemp=xdim & ydimtemp=ydim & thedrawtemp=thedraw1 & ydim2temp=ydim
imageorig=image

WSET, thedraw1
disp_draw

XManager, "disp", dispbase, EVENT_HANDLER = "disp_ev"

outwidth=width
linesout=lines
if (nlinemin eq 1) then linesout[1]=-1
if (abort eq 1) then linesout[1]=-99   ; Abort

END

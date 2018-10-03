;;; REDSPEC, a GUI software package for reduction of spectrum data.
;;; Sungsoo S. Kim, UCLA Astronomy
;;; version 1.0 -- October, 2000
;;; version 2.0 -- December, 2000
;;; version 2.5 -- February, 2001
;;;
;;; A simple image display routine with a magnification window and
;;;     cross-cut function.


;===============================================================================
PRO imdrawcut, ps=ps

;;; Draw the cross-cut.

COMPILE_OPT idl2, hidden
COMMON imcutcom,xdatax,xdatay,ydatax,ydatay,mininit,maxinit,minnow,maxnow,$
       cuttext1,cuttext2,thedrawcut,sswitch,basemin,basemax,cutbase

if (n_elements(ps) eq 0) then WSET, thedrawcut
xmin=basemin[sswitch]
xmax=basemax[sswitch]

if (sswitch eq 0 ) then begin
  plot,xdatax,xdatay,charsize=1.3,xmargin=[10,3],ymargin=[5,2], $
      xrange=[xmin,xmax],yrange=[minnow,maxnow],xstyle=1,ystyle=1,xtitle='X'
endif else begin
  plot,ydatax,ydatay,charsize=1.3,xmargin=[10,3],ymargin=[5,2], $
      xrange=[xmin,xmax],yrange=[minnow,maxnow],xstyle=1,ystyle=1,xtitle='Y'
endelse

END


;===============================================================================
PRO imcut_event, event

;;; Control the cross-cut widget events.

COMPILE_OPT idl2, hidden
COMMON imcutcom,xdatax,xdatay,ydatax,ydatay,mininit,maxinit,minnow,maxnow,$
       cuttext1,cuttext2,thedrawcut,sswitch,basemin,basemax,cutbase

WIDGET_CONTROL, event.id, GET_UVALUE = eventval

CASE eventval OF

;;; Save a postscript file.
"PS": BEGIN
  devicesave=!D.NAME
  SET_PLOT, 'ps'
  file='cut.ps'
  DEVICE, FILENAME=file
  imdrawcut, /ps
  DEVICE, /CLOSE
  SET_PLOT, devicesave
  message=DIALOG_MESSAGE(dialog_parent=cutbase, $
          'The plot has been saved as "'+file+'".',/information)
END

;;; Switch between x- and y- cross-cut.
"SWITCH": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value
  sswitch=value
  minnow=mininit[sswitch]
  maxnow=maxinit[sswitch]
  WIDGET_CONTROL, cuttext1, SET_VALUE = string(minnow,format='(g8.2)')
  WIDGET_CONTROL, cuttext2, SET_VALUE = string(maxnow,format='(g8.2)')
  sswitch=value
  imdrawcut
END

"YMIN": BEGIN
  WIDGET_CONTROL, cuttext1, GET_VALUE = minnow
  minnow=float(minnow)
  WIDGET_CONTROL, cuttext1, SET_VALUE = string(minnow,format='(g8.2)')
  imdrawcut
END

"YMAX": BEGIN
  WIDGET_CONTROL, cuttext2, GET_VALUE = maxnow
  maxnow=float(maxnow)
  WIDGET_CONTROL, cuttext2, SET_VALUE = string(maxnow,format='(g8.2)')
  imdrawcut
END

"EXIT": BEGIN
  WIDGET_CONTROL, event.top, /DESTROY
END

ENDCASE

END


;===============================================================================
PRO imcut,xdataxin,xdatayin,ydataxin,ydatayin

;;; Prepare cross-cut parameters and widgets.
;;;
;;; xdataxin, xdatayin	: x-cross-cut data (input)
;;; ydataxin, ydatayin	: y-cross-cut data (input)

COMPILE_OPT idl2, hidden
COMMON imcutcom,xdatax,xdatay,ydatax,ydatay,mininit,maxinit,minnow,maxnow,$
       cuttext1,cuttext2,thedrawcut,sswitch,basemin,basemax,cutbase

xdatax=xdataxin
xdatay=xdatayin
ydatax=ydataxin
ydatay=ydatayin

mininit=fltarr(2)
maxinit=fltarr(2)

nxdata=n_elements(xdatay)
;sortx=sort(xdatay)
;xmax=xdatay[sortx[fix(nxdata*0.99)<(nxdata-3)]]
;xmin=xdatay[sortx[fix(nxdata*0.01)>2]]
xmax=max(xdatay)
xmin=min(xdatay)
xrange=(xmax-xmin)
maxinit[0]=xmax+xrange*0.15
mininit[0]=xmin-xrange*0.15
nydata=n_elements(ydatay)
;sorty=sort(ydatay)
;ymax=ydatay[sorty[fix(nydata*0.99)<(nydata-3)]]
;ymin=ydatay[sorty[fix(nydata*0.01)>2]]
ymax=max(ydatay)
ymin=min(ydatay)
yrange=(ymax-ymin)
maxinit[1]=ymax+yrange*0.15
mininit[1]=ymin-yrange*0.15

if (nydata gt nxdata ) then sswitch=1 else sswitch=0
minnow=mininit[sswitch]
maxnow=maxinit[sswitch]

basemin=fltarr(2) & basemax=fltarr(2)
basemin[0]=xdataxin[0]-(xdataxin[nxdata-1]-xdataxin[0])*0.05
basemax[0]=xdataxin[nxdata-1]+(xdataxin[nxdata-1]-xdataxin[0])*0.05
basemin[1]=ydataxin[0]-(ydataxin[nydata-1]-ydataxin[0])*0.05
basemax[1]=ydataxin[nydata-1]+(ydataxin[nydata-1]-ydataxin[0])*0.05

;;; Prepare cross-cut widgets.
cutbase = WIDGET_BASE(TITLE='Image Cut', /COLUMN)
cutbuttonbase1 = WIDGET_BASE(cutbase, /ROW)
cutbutton1a = WIDGET_BUTTON(cutbuttonbase1, VALUE=' Postscript ', UVALUE='PS')
cutbutton1b = WIDGET_BUTTON(cutbuttonbase1, VALUE=' Close ', UVALUE='EXIT')
cutbuttonbase2 = WIDGET_BASE(cutbase, /COLUMN)
cutbutton2 = CW_BGROUP(cutbuttonbase2, ['Horizontal','Vertical'], $
                        /ROW, SET_VALUE=sswitch, UVALUE='SWITCH', /EXCLUSIVE, $
                        /NO_RELEASE)

cuttextbase = WIDGET_BASE(cutbase, /ROW)
cuttext1 = CW_FIELD(cuttextbase, VALUE=string(minnow,format='(g8.2)'), $
                        UVALUE='YMIN', XSIZE=8, /RETURN_EVENTS, TITLE='Min')
cuttext2 = CW_FIELD(cuttextbase, VALUE=string(maxnow,format='(g8.2)'), $
                        UVALUE='YMAX', XSIZE=8, /RETURN_EVENTS, TITLE='Max')
cutdisp = WIDGET_DRAW(cutbase, RETAIN=2, XSIZE=800, YSIZE=500)

WIDGET_CONTROL, cutbase, /REALIZE
WIDGET_CONTROL, cutdisp, GET_VALUE=thedrawcut

WSET, thedrawcut
imdrawcut

XManager, "imcut", cutbase

END


;===============================================================================
PRO imright_erase

;;; Erase the cross-cut rectangle on the image.
;;;
;;; xold, yold		: old position of the pointer
;;; xstart, ystart	: starting position of the right button drag
;;; xa, xb, ya, yb	: vertices of the cut rectagle

COMPILE_OPT idl2, hidden
COMMON imrightcom,imagenow,pressed,xstart,ystart,xold,yold,xdimtemp,ydimtemp, $
       thedrawtemp,ydim2temp,imageorig
COMMON imright_internal,xa,xb,ya,yb

WSET, thedrawtemp
xa=(xstart<xold)<(xdimtemp-1)
xb=(xstart>xold)<(xdimtemp-1)
ya=(ystart<yold)<(ydimtemp-1)
yb=(ystart>yold)<(ydimtemp-1)
tv,imagenow[xa:xb,ya:ya],xa,ya
tv,imagenow[xa:xb,yb:yb],xa,yb
tv,imagenow[xa:xa,ya:yb],xa,ya
tv,imagenow[xb:xb,ya:yb],xb,ya

END


;===============================================================================
PRO imright, event, redraw=redraw

;;; Perform right mouse button activities.
;;;
;;; x, y		: current position of the pointer
;;; xold, yold		: old position of the pointer
;;; xstart, ystart	: starting position of the right button drag
;;; xdataxin, xdatayin	: x-cross-cut data
;;; ydataxin, ydatayin	: y-cross-cut data
;;; xa, xb, ya, yb	: vertices of the cut rectagle

COMPILE_OPT idl2, hidden
COMMON imrightcom,imagenow,pressed,xstart,ystart,xold,yold,xdimtemp,ydimtemp, $
       thedrawtemp,ydim2temp,imageorig
COMMON imright_internal,xa,xb,ya,yb

WSET, thedrawtemp
x=(event.x>0)<(xdimtemp-1)
y=(event.y>0)<(ydimtemp-1)

if (event.type eq 2 and n_elements(pressed) eq 1) then begin
  ;;; Mouse in motion with a right button pressed
  if (pressed eq 1) then begin
    if (x ne xold or y ne yold) then begin
      imright_erase
      if (n_elements(redraw) ne 0) then call_procedure,redraw
      xp=[xstart,x,x,xstart,xstart]
      yp=[ystart,ystart,y,y,ystart]
      plot,xp,yp,xrange=[0,xdimtemp],yrange=[0,ydim2temp],xstyle=5,ystyle=5,$
          xmargin=[0,0],ymargin=[0,0],color=255,/noerase
      xold=x
      yold=y
    endif
  endif
endif else begin
  ;;; Right button press
  if (event.press eq 4) then begin
    if(n_elements(xstart) ne 0) then begin
      imright_erase
    endif
    xstart=x
    ystart=y
    xold=x
    yold=y
    pressed=1
  endif
  ;;; Right button release
  if (event.release eq 4) then begin
    imright_erase
    xp=[xstart,x,x,xstart,xstart]
    yp=[ystart,ystart,y,y,ystart]
    plot,xp,yp,xrange=[0,xdimtemp],yrange=[0,ydim2temp],xstyle=5,ystyle=5,$
        xmargin=[0,0],ymargin=[0,0],color=255,/noerase
    pressed=0
    if (xa ne xb or ya ne yb) then begin
      nx=xb-xa+1
      ny=yb-ya+1
      datanow=reform(imageorig[xa:xb,ya:yb],nx,ny)
      xdatax=indgen(nx)+xa
      xdatay=total(datanow,2)
;      xmed=abs(median(xdatay))>(1./abs(max(xdatay)))
;      xdatay=xdatay/xmed
      ydatax=indgen(ny)+ya
      ydatay=total(datanow,1)
;      ymed=abs(median(ydatay))>(1./abs(max(ydatay)))
;      ydatay=ydatay/ymed
      imcut,xdatax,xdatay,ydatax,ydatay
      WSET, thedrawtemp
      plot,xp,yp,xrange=[0,xdimtemp],yrange=[0,ydim2temp],xstyle=5,ystyle=5,$
          xmargin=[0,0],ymargin=[0,0],color=255,/noerase
    endif
  endif
endelse

END


;===============================================================================
PRO imdisp_draw

;;; Display the main image.

COMPILE_OPT idl2, hidden
COMMON imdispcom,thedraw1,thedraw2,bytmin,bytmax,xdim,ydim,smallsize,enlarge, $
       image,spxa,spxb,spya,spyb,ctable,nctable,dispbase,dispdisplay
COMMON imbuttoncom,valuetext,coordtext
COMMON imslidercom,slider1,slider2,checklog
COMMON imrightcom,imagetemp,pressed,xstart,ystart,xold,yold,xdimtemp,ydimtemp, $
       thedrawtemp,ydim2temp,imageorig

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

tv,imagetemp,0,0
if (n_elements(xstart) ne 0) then imright_erase

END


;===============================================================================
PRO imdisp_draw2

COMPILE_OPT idl2, hidden

; DO NOTHING...

END


;===============================================================================
PRO imdisp_ev, event

;;; Control main widget events.

COMPILE_OPT idl2, hidden
COMMON imdispcom,thedraw1,thedraw2,bytmin,bytmax,xdim,ydim,smallsize,enlarge, $
       image,spxa,spxb,spya,spyb,ctable,nctable,dispbase,dispdisplay
COMMON imbuttoncom,valuetext,coordtext
COMMON imslidercom,slider1,slider2,checklog
COMMON imrightcom,imagenow,pressed,xstart,ystart,xold,yold,xdimtemp,ydimtemp, $
       thedrawtemp,ydim2temp,imageorig

WIDGET_CONTROL, event.id, GET_UVALUE = eventval

CASE eventval OF

;;; Draw mag window, and display coord & pixel info.
"DISP" : BEGIN
  x=event.x
  y=event.y

  imright, event, redraw='imdisp_draw2'

  ;;; Display the magnification window.
  ;;; smallsize : # of data pixels to be shown in the mag window (1D)
  ;;; enlarge   : magnification factor
  ;;; pixsize   : # of actual pixels of the mag window (1D)
  ;;; cross     : length of cross hair in units of actual pixels
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

"SLIDER1": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value1
  bytmin=ctable[long((nctable-1.)*value1/1000.)]
  imdisp_draw
END

"SLIDER2": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value2
  bytmax=ctable[long((nctable-1.)*(1.-value2/1000.))]
  imdisp_draw
END

"LOG": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = checklog
  imdisp_draw
END

"XLOADCT": BEGIN
  xloadct
END

;;; Get a new image file.
"FILE": BEGIN
  inimage = DIALOG_PICKFILE(/READ, FILTER='*.fits', /MUST_EXIST, /NOCONFIRM, $
			    GROUP=dispbase)
  catch,err
  if (err ne 0 or inimage eq '') then begin
      print,!err_string
      return
  endif
  catch,/cancel
  image=readfits(inimage)
  imagetemp=image
  imagesize=size(image)
  xdim=imagesize[1] & ydim=imagesize[2]
  if (imagesize[0] eq 1) then ydim=1

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

  ;;; Draw the main image.
  device, get_screen_size=screen
  if (screen[0] lt 1200) then xscr=800 else xscr=1024
  if (screen[1] lt 900)  then yscr=400 else yscr=640
  extra=''
  if (xdim gt xscr) then extra = {X_SCROLL_SIZE:xscr, Y_SCROLL_SIZE:ydim+2}
  if (ydim gt yscr) then extra = {X_SCROLL_SIZE:xdim+2, Y_SCROLL_SIZE:yscr}
  if (xdim gt xscr and ydim gt yscr) then extra = {X_SCROLL_SIZE:xscr, $
      Y_SCROLL_SIZE:yscr}
  WIDGET_CONTROL, dispdisplay, /DESTROY
  dispdisplay = WIDGET_DRAW(dispbase, RETAIN=2, $
			    XSIZE=xdim, YSIZE=ydim, $
			    _Extra=extra, $
			    /BUTTON_EVENTS, /MOTION_EVENTS, UVALUE='DISP')
  WIDGET_CONTROL, dispdisplay, /REALIZE
  WIDGET_CONTROL, dispdisplay, GET_VALUE = thedraw1
  xdimtemp=xdim & ydimtemp=ydim & thedrawtemp=thedraw1 & ydim2temp=ydim
  imageorig=image
  WSET, thedraw1
  imdisp_draw
END

"EXIT": BEGIN
  WIDGET_CONTROL, event.top, /DESTROY
END

ELSE:; MESSAGE, "Event User Value Not Found"

ENDCASE

END


;===============================================================================
PRO imdisp, inimage

;;; Prepare parameters and main widgets.
;;;
;;; inimage	: input image (IDL 2D array or fits file name)

COMPILE_OPT idl2, hidden
COMMON imdispcom,thedraw1,thedraw2,bytmin,bytmax,xdim,ydim,smallsize,enlarge, $
       image,spxa,spxb,spya,spyb,ctable,nctable,dispbase,dispdisplay
COMMON imbuttoncom,valuetext,coordtext
COMMON imslidercom,slider1,slider2,checklog
COMMON imrightcom,imagetemp,pressed,xstart,ystart,xold,yold,xdimtemp,ydimtemp, $
       thedrawtemp,ydim2temp,imageorig

smallsize=21  ; should be an odd number
enlarge=5     ; should be an odd number

if (XRegistered("imdisp") ne 0) then begin
  print,'Only one imdisp session allowed at a time.'
  return
endif

if (n_elements(inimage) eq 0) then begin
  image=fltarr(600,400)
endif else if (n_elements(inimage) eq 1) then begin
  get_lun,funit
  openr,funit,inimage,ERROR=err
  if (err ne 0) then begin
    print,'Error encountered while opening file "'+inimage+'".'
    free_lun,funit
    return
  endif
  close,funit
  free_lun,funit
  catch,err
  if (err ne 0) then begin
      print,!err_string
      return
  endif
  catch,/cancel
  image=readfits(inimage)
endif else begin
  sizetemp=size(inimage)
  if (sizetemp[0] ne 2) then begin
    print,'Input variable should be an 2-D array.'
    return
  endif
  image=inimage
endelse

!except=0
device,decomposed=0
loadct,39

imagesize=size(image)
xdim=imagesize[1] & ydim=imagesize[2]
if (imagesize[0] eq 1) then ydim=1
checklog=0

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

;;; Prepare main widgets.
dispbase = WIDGET_BASE(TITLE = 'IMDISP', /COLUMN)

menubase = WIDGET_BASE(dispbase, /ROW)
donebutton = WIDGET_BUTTON(menubase, VALUE=' Done ', UVALUE='EXIT')
label = WIDGET_LABEL(menubase, VALUE='    ')
filebutton = WIDGET_BUTTON(menubase, VALUE=' Open... ', UVALUE='FILE')

smallbase = WIDGET_BASE(dispbase, /ROW)
smallbase1 = WIDGET_BASE(smallbase, /COLUMN)
dispsmall = WIDGET_DRAW(smallbase1, XSIZE=smallsize*enlarge, $
			YSIZE=smallsize*enlarge, RETAIN=2)
smallbase2 = WIDGET_BASE(smallbase, /COLUMN)
valuetext = WIDGET_LABEL(smallbase2, VALUE='', XSIZE=120, YSIZE=20, /ALIGN_LEFT)
coordtext = WIDGET_LABEL(smallbase2, VALUE='', XSIZE=120, YSIZE=20, /ALIGN_LEFT)
fitlabel1 = WIDGET_LABEL(smallbase, VALUE='          ')
smallbase3 = WIDGET_BASE(smallbase, /COLUMN)
fitlabel2 = WIDGET_LABEL(smallbase3, VALUE='          ')
device, get_screen_size=screen
if (screen[0] lt 1200) then xscr=800 else xscr=1024
if (screen[1] lt 900)  then yscr=400 else yscr=640

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

;;; Vriables for right.pro
xdimtemp=xdim & ydimtemp=ydim & thedrawtemp=thedraw1 & ydim2temp=ydim
imageorig=image

WSET, thedraw1
imdisp_draw

XManager, "imdisp", dispbase, EVENT_HANDLER = "imdisp_ev", /NO_BLOCK

END

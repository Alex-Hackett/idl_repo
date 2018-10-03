;;; REDSPEC, a GUI software package for reduction of spectrum data.
;;; Sungsoo S. Kim, UCLA Astronomy
;;; version 1.0 -- October, 2000
;;; version 2.0 -- December, 2000
;;; version 2.5 -- February, 2001
;;;
;;; Routines for right mouse button activities (cross-cut plot).


;===============================================================================
PRO drawcut, ps=ps

;;; Draw cross-cut plot.

COMPILE_OPT idl2, hidden
COMMON cutcom,xdatax,xdatay,ydatax,ydatay,mininit,maxinit,minnow,maxnow,$
       cuttext1,cuttext2,thedrawcut,sswitch,basemin,basemax,cutbase,xcutdim,$
       ycutdim

if (n_elements(ps) eq 0) then WSET, thedrawcut
xmin=basemin[sswitch]
xmax=basemax[sswitch]

if (sswitch eq 0 ) then begin
  plot,xdatax,xdatay,charsize=1.3,xmargin=[12,2],ymargin=[5,2], $
      xrange=[xmin,xmax],yrange=[minnow,maxnow],xstyle=1,ystyle=1,xtitle='X',$
      ytitle='Sum of '+strtrim(string(ycutdim),2)+' row(s)'
endif else begin
  plot,ydatax,ydatay,charsize=1.3,xmargin=[12,2],ymargin=[5,2], $
      xrange=[xmin,xmax],yrange=[minnow,maxnow],xstyle=1,ystyle=1,xtitle='Y',$
      ytitle='Sum of '+strtrim(string(xcutdim),2)+' column(s)'
endelse

END


;===============================================================================
PRO cut_event, event

;;; Control widget events.

COMPILE_OPT idl2, hidden
COMMON cutcom,xdatax,xdatay,ydatax,ydatay,mininit,maxinit,minnow,maxnow,$
       cuttext1,cuttext2,thedrawcut,sswitch,basemin,basemax,cutbase,xcutdim,$
       ycutdim

WIDGET_CONTROL, event.id, GET_UVALUE = eventval

CASE eventval OF

;;; Save a postscript file.
"PS": BEGIN
  devicesave=!D.NAME
  SET_PLOT, 'ps'
  file='cut.ps'
  DEVICE, FILENAME=file
  drawcut, /ps
  DEVICE, /CLOSE
  SET_PLOT, devicesave
  message=DIALOG_MESSAGE(dialog_parent=cutbase, $
          'The plot has been saved as "'+file+'".',/information)
END

;;; switch between x- and y- cross-cut.
"SWITCH": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value
  sswitch=value
  minnow=mininit[sswitch]
  maxnow=maxinit[sswitch]
  WIDGET_CONTROL, cuttext1, SET_VALUE = string(minnow,format='(g8.2)')
  WIDGET_CONTROL, cuttext2, SET_VALUE = string(maxnow,format='(g8.2)')
  sswitch=value
  drawcut
END

"YMIN": BEGIN
  WIDGET_CONTROL, cuttext1, GET_VALUE = minnow
  minnow=float(minnow)
  WIDGET_CONTROL, cuttext1, SET_VALUE = string(minnow,format='(g8.2)')
  drawcut
END

"YMAX": BEGIN
  WIDGET_CONTROL, cuttext2, GET_VALUE = maxnow
  maxnow=float(maxnow)
  WIDGET_CONTROL, cuttext2, SET_VALUE = string(maxnow,format='(g8.2)')
  drawcut
END

"EXIT": BEGIN
  WIDGET_CONTROL, event.top, /DESTROY
END

ENDCASE

END


;===============================================================================
PRO cut,xdataxin,xdatayin,ydataxin,ydatayin,xcutdimin,ycutdimin

;;; Prepare parameters and widgets.
;;;
;;; xdataxin, xdatayin   : x-cross-cut data
;;; ydataxin, ydatayin   : y-cross-cut data
;;; xcutdimin, ycutdimin : x and y dimensions

COMPILE_OPT idl2, hidden
COMMON cutcom,xdatax,xdatay,ydatax,ydatay,mininit,maxinit,minnow,maxnow,$
       cuttext1,cuttext2,thedrawcut,sswitch,basemin,basemax,cutbase,xcutdim,$
       ycutdim

;;; mininit	: minimum x(0) y(1) values with a cushion
;;; maxinit	: maximum x(0) y(1) values with a cushion
;;; minnow	: current mininit (depending on sswitch)
;;; maxnow	: current maxinit (depending on sswitch)
;;; cuttext1	: widget variable for minimum field
;;; cuttext2	: widget variable for maximum field
;;; thedrawcut	: widget variable for graphic window
;;; sswitch	: switch flag
;;; basemin	: minimum x(0) y(1) pixels with a cushion
;;; basemax	: maximum x(0) y(1) pixels with a cushion
;;; cutbase	: base widget variable

device,decomposed=0

;;; Prepare parameters.
xdatax=xdataxin
xdatay=xdatayin
ydatax=ydataxin
ydatay=ydatayin
xcutdim=xcutdimin
ycutdim=ycutdimin

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

;;; Prepare widgets.
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

drawcut

XManager, "cut", cutbase

END


;===============================================================================
PRO right_erase_2

;;; Erase the cross-cut rectangle on the arc image 2.
;;;
;;; xold, yold          : old position of the pointer
;;; xstart, ystart      : starting position of the right button drag
;;; xa, xb, ya, yb      : vertices of the cut rectagle

COMPILE_OPT idl2, hidden
COMMON rightcom_2,imagenow,pressed,xstart,ystart,xold,yold,xdimtemp,ydimtemp, $
       thedrawtemp,ydim2temp,imageorig
COMMON right_internal_2,xa,xb,ya,yb

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
PRO right_2, event, redraw=redraw

;;; Perform right mouse button activities for arc image 2.
;;;
;;; x, y                : current position of the pointer
;;; xold, yold          : old position of the pointer
;;; xstart, ystart      : starting position of the right button drag
;;; xdataxin, xdatayin  : x-cross-cut data
;;; ydataxin, ydatayin  : y-cross-cut data
;;; xa, xb, ya, yb      : vertices of the cut rectagle

COMPILE_OPT idl2, hidden
COMMON rightcom_2,imagenow,pressed,xstart,ystart,xold,yold,xdimtemp,ydimtemp, $
       thedrawtemp,ydim2temp,imageorig
COMMON right_internal_2,xa,xb,ya,yb

WSET, thedrawtemp
x=(event.x>0)<(xdimtemp-1)
y=(event.y>0)<(ydimtemp-1)

if (event.type eq 2 and n_elements(pressed) eq 1) then begin
  ;;; Mouse in motion with a right button pressed
  if (pressed eq 1) then begin
    if (x ne xold or y ne yold) then begin
      right_erase_2
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
      right_erase_2
    endif
    xstart=x
    ystart=y
    xold=x
    yold=y
    pressed=1
  endif
  ;;; Right button release
  if (event.release eq 4) then begin
    right_erase_2
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
      cut,xdatax,xdatay,ydatax,ydatay,nx,ny
      WSET, thedrawtemp
      plot,xp,yp,xrange=[0,xdimtemp],yrange=[0,ydim2temp],xstyle=5,ystyle=5,$
          xmargin=[0,0],ymargin=[0,0],color=255,/noerase
    endif
  endif
endelse

END


;===============================================================================
PRO right_erase

;;; Erase the cross-cut rectangle on the arc image 1.
;;;
;;; xold, yold          : old position of the pointer
;;; xstart, ystart      : starting position of the right button drag
;;; xa, xb, ya, yb      : vertices of the cut rectagle

COMPILE_OPT idl2, hidden
COMMON rightcom,imagenow,pressed,xstart,ystart,xold,yold,xdimtemp,ydimtemp, $
       thedrawtemp,ydim2temp,imageorig
COMMON right_internal,xa,xb,ya,yb

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
PRO right, event, redraw=redraw

;;; Perform right mouse button activities for arc image 1.
;;;
;;; x, y                : current position of the pointer
;;; xold, yold          : old position of the pointer
;;; xstart, ystart      : starting position of the right button drag
;;; xdataxin, xdatayin  : x-cross-cut data
;;; ydataxin, ydatayin  : y-cross-cut data
;;; xa, xb, ya, yb      : vertices of the cut rectagle

COMPILE_OPT idl2, hidden
COMMON rightcom,imagenow,pressed,xstart,ystart,xold,yold,xdimtemp,ydimtemp, $
       thedrawtemp,ydim2temp,imageorig
COMMON right_internal,xa,xb,ya,yb

WSET, thedrawtemp
x=(event.x>0)<(xdimtemp-1)
y=(event.y>0)<(ydimtemp-1)

if (event.type eq 2 and n_elements(pressed) eq 1) then begin
  ;;; Mouse in motion with a right button pressed
  if (pressed eq 1) then begin
    if (x ne xold or y ne yold) then begin
      right_erase
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
      right_erase
    endif
    xstart=x
    ystart=y
    xold=x
    yold=y
    pressed=1
  endif
  ;;; Right button release
  if (event.release eq 4) then begin
    right_erase
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
      cut,xdatax,xdatay,ydatax,ydatay,nx,ny
      WSET, thedrawtemp
      plot,xp,yp,xrange=[0,xdimtemp],yrange=[0,ydim2temp],xstyle=5,ystyle=5,$
          xmargin=[0,0],ymargin=[0,0],color=255,/noerase
    endif
  endif
endelse

END

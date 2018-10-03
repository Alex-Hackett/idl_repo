;;; REDSPEC, a GUI software package for reduction of spectrum data.
;;; Sungsoo S. Kim, UCLA Astronomy
;;; version 1.0 -- October, 2000
;;; version 2.0 -- December, 2000
;;; version 2.5 -- February, 2001
;;;
;;; Pick etalon fringes, find centroids, and calculate polynomial fits.
;;; Not for public use.


;===============================================================================
PRO drawetalon

;;; Draw the etalon image.

COMPILE_OPT idl2, hidden
COMMON picketaloncom,thedraw1,coeftemp,obsfit,fitheight,fitwidth,nline, $
       wavetemp,sprite,spxa,spxb,spya,spyb,coordtext
COMMON bytimage4,image,bytmin,bytmax,xdim,ydim,ctable,nctable
COMMON slidercom4,slider1,slider2,checklog,picketalonbase
COMMON rightcom,imagenow,pressed,xstart,ystart,xold,yold,xdimtemp,ydimtemp, $
       thedrawtemp,ydim2temp,imageorig

; sprite=0 : Whole image drawing.
; sprite=1 : No image drawing.
; sprite=2 : Partial image redrawing.

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

if (sprite eq 0) then begin
  tv,imagenow,0,0
  spxa=xdim-1 & spxb=0 & spya=ydim-1 & spyb=0
endif
if (sprite eq 2 and spxa le spxb and spya le spyb) then begin
  tv,imagenow[spxa:spxb,spya:spyb],spxa,spya
endif
if (n_elements(xstart) ne 0) then right_erase

drawetalon2

sprite=0

END


;===============================================================================
PRO drawetalon2,all=all

;;; Mark the fits to etalon fringes.

COMPILE_OPT idl2, hidden
COMMON picketaloncom,thedraw1,coeftemp,obsfit,fitheight,fitwidth,nline, $
       wavetemp,sprite,spxa,spxb,spya,spyb,coordtext
COMMON bytimage4,image,bytmin,bytmax,xdim,ydim,ctable,nctable

if (nline eq 0) then return

if (n_elements(all) eq 0) then all=0
if (all eq 1) then istart=0 else istart=nline-1

color1=0
color2=fix(256./8.)
ydim2=ydim
spxasave=spxa & spxbsave=spxb
spxanow=xdim-1 & spxbnow=0

for iline=istart,nline-1 do begin
  ;;; Use two different colors for better visibility.
  colornow=color1
  for j=10,ydim-1,20 do begin
    fitynow=0.
    for k=0,obsfit do fitynow=fitynow+coeftemp[k,iline]*float(j)^k
    fity=fix(fitynow+0.5)
    if fity ge 0 and fity le xdim-1 then begin
      plot,[fity],[j],psym=1,xrange=[0,xdim],yrange=[0,ydim2],xstyle=5, $
          ystyle=5,xmargin=[0,0],ymargin=[0,0],color=colornow,/noerase
      spxanow=((fity-10)<spxanow)>0
      spxbnow=((fity+10)>spxbnow)<(xdim-1)
    endif
  endfor
  colornow=color2
  for j=20,ydim-1,20 do begin
    fitynow=0.
    for k=0,obsfit do fitynow=fitynow+coeftemp[k,iline]*float(j)^k
    fity=fix(fitynow+0.5)
    if fity ge 0 and fity le xdim-1 then begin
      plot,[fity],[j],psym=1,xrange=[0,xdim],yrange=[0,ydim2],xstyle=5, $
          ystyle=5,xmargin=[0,0],ymargin=[0,0],color=colornow,/noerase
      spxanow=((fity-10)<spxanow)>0
      spxbnow=((fity+10)>spxbnow)<(xdim-1)
    endif
  endfor
endfor

;;; Calculate spxa,spxb,spya,spyb for future redrawing.
;;; spxa,spxb,spya,spyb : vertices of a rectagle to be redrawn when erasing
;;;     the fits
spya=0 & spyb=ydim-1
if (all eq 0) then begin
  spxa=spxanow<spxasave
  spxb=spxbnow>spxbsave
endif

END


;===============================================================================
PRO picketalon_event, event

;;; Control widget events.

COMPILE_OPT idl2, hidden
COMMON picketaloncom,thedraw1,coeftemp,obsfit,fitheight,fitwidth,nline, $
       wavetemp,sprite,spxa,spxb,spya,spyb,coordtext
COMMON bytimage4,image,bytmin,bytmax,xdim,ydim,ctable,nctable
COMMON slidercom4,slider1,slider2,checklog,picketalonbase

WIDGET_CONTROL, event.id, GET_UVALUE = eventval
ydim2=ydim

CASE eventval OF


"BUTTON": BEGIN
  right, event, redraw='drawetalon2'
  if event.press ne 1 then goto, jump1

  ;;; Find centroids at each row and make a polynomial fit to the centroid
  ;;; array.
  WIDGET_CONTROL,/hourglass
  xin=(event.x>0)<(xdim-1)
  yin=(event.y>0)<(ydim-1)
  yfreq=(ydim/50)>1
  nupper=(ydim-1-(fitheight-1)-yin)/yfreq
  nlower=(yin-(fitheight-1))/yfreq
  ntotal=nupper+nlower+1
  ylower=yin-nlower*yfreq
  gaussx=fltarr(ntotal)
  gaussheight=fltarr(ntotal)
  gausswidth=fltarr(ntotal)
  xbefore=xin
  ;;; Iteration from the clicked y position to the upper edge of the image.
  for j=nlower,ntotal-1 do begin
    ;;; Use the previous centroid as an initial guess.
    x=xbefore
    y=yin+(j-nlower)*yfreq
    xa=fix(max([0.,x-fitwidth/2]))
    xb=fix(min([xdim-1,x+(fitwidth-1)/2]))
    ya=fix(max([0.,y-fitheight/2]))
    yb=fix(min([ydim-1,y+(fitheight-1)/2]))
    nx=xb-xa+1
    ny=yb-ya+1
    ;;; Sum over fitheight pixels (vertically) and form a vector with a
    ;;;     length of fitwidth.
    columnx=findgen(fix(xb)-fix(xa)+1)+float(xa)
    columny=total(reform(image[fix(xa):fix(xb),fix(ya):fix(yb)],nx,ny),2)
    ;;; Fit a Gaussian to find each row's centroid.
    temp=gaussfit(columnx,columny,result,nterms=4)
    fitx=result[1]
    height=result[0]
    sigma=result[2]
    ;;; See if the fit is bad.
    if (abs(fitx-x) gt fitwidth/2. or sigma gt 40. or sigma lt 0.25 or $
        height le 0.) then fitx=x $
    else xbefore=fitx
    gaussx[j]=fitx
    gaussheight[j]=height
    gausswidth[j]=sigma
  endfor
  xbefore=xin
  ;;; Iteration from the clicked y position to the lower edge of the image.
  for j=nlower,0,-1 do begin
    ;;; Use the previous centroid as an initial guess.
    x=xbefore
    y=yin+(j-nlower)*yfreq
    xa=fix(max([0.,x-fitwidth/2]))
    xb=fix(min([xdim-1,x+(fitwidth-1)/2]))
    ya=fix(max([0.,y-fitheight/2]))
    yb=fix(min([ydim-1,y+(fitheight-1)/2]))
    nx=xb-xa+1
    ny=yb-ya+1
    ;;; Sum over fitheight pixels (vertically) and form a vector with a
    ;;;     length of fitwidth.
    columnx=findgen(fix(xb)-fix(xa)+1)+float(xa)
    columny=total(reform(image[fix(xa):fix(xb),fix(ya):fix(yb)],nx,ny),2)
    ;;; Fit a Gaussian to find each row's centroid.
    temp=gaussfit(columnx,columny,result,nterms=4)
    fitx=result[1]
    height=result[0]
    sigma=result[2]
    ;;; See if the fit is bad.
    if (abs(fitx-x) gt fitwidth/2. or sigma gt 40. or sigma lt 0.25 or $
        height le 0.) then fitx=x $
    else xbefore=fitx
    gaussx[j]=fitx
    gaussheight[j]=height
    gausswidth[j]=sigma
  endfor
  ;;; Clip out bad centroids.
  clip, gaussx,      clipflag1, 2.5, 0.1, 0.4
  clip, gaussheight, clipflag2, 2.5, 0.1, 0.4
  clip, gausswidth,  clipflag3, 2.5, 0.1, 0.4
  clipflag=clipflag1*clipflag2*clipflag3
  datax=indgen(ntotal)*yfreq+ylower
  datax=datax[where(clipflag)]
  datay=gaussx[where(clipflag)]
  nline=nline+1
  ;;; Fit a polynomial to the whole fringe (array of centroids).
  if (nline eq 1) then begin
    coeftemp=fltarr(obsfit+1,nline)
    coeftemp[*,0]=poly_fit(datax,datay,obsfit,/double)
  endif else begin
    coefsave=coeftemp
    coeftemp=fltarr(obsfit+1,nline)
    coeftemp[*,0:nline-2]=coefsave[*,*]
    coeftemp[*,nline-1]=poly_fit(datax,datay,obsfit,/double)
  endelse
  sprite=1
  drawetalon

  jump1:
  ;;; Display the coordinates.
  x=(event.x>0)<(xdim-1)
  y=(event.y>0)<(ydim-1)
  xpix=(event.x>0)<(xdim-1)
  ypix=(event.y>0)<(ydim-1)
  coord1='('+string(xpix+1,format='(i4)')+','+string(ypix+1,format='(i4)')+')'
  coord2='No. of fits = '+string(nline,format='(i2)')
  coord=coord1+'     '+coord2
  WIDGET_CONTROL, coordtext, SET_VALUE = coord
END

"SLIDER1": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value1
  bytmin=ctable[long((nctable-1.)*value1/1000.)]
  drawetalon
  drawetalon2,/all
END

"SLIDER2": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value2
  bytmax=ctable[long((nctable-1.)*(1.-value2/1000.))]
  drawetalon
  drawetalon2,/all
END

"LOG": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = checklog
  drawetalon
  drawetalon2,/all
END

"XLOADCT": BEGIN
  xloadct
END

"EXIT": BEGIN
  if (nline lt 2) then begin
    message=DIALOG_MESSAGE('At least two etalon fits should be made.'+ $
		'  Etalon will not be used for dispersion solution.', $
		DIALOG_PARENT=picketalonbase)
  endif
  WIDGET_CONTROL, event.top, /DESTROY
END

;;; Undo the latest fit.
"UNDO": BEGIN
  if (nline ge 1) then begin
    nline=nline-1
    if (nline ne 0) then coeftemp=coeftemp[*,0:nline-1]
    sprite=2
    drawetalon
    drawetalon2,/all
  endif
  xpix=0
  ypix=0
  coord1='('+string(xpix+1,format='(i4)')+','+string(ypix+1,format='(i4)')+')'
  coord2='No. of fits = '+string(nline,format='(i2)')
  coord=coord1+'     '+coord2
  WIDGET_CONTROL, coordtext, SET_VALUE = coord
END

;;; Remove the whole fits.
"CLEAR": BEGIN
  nline=0
  sprite=2
  drawetalon
  xpix=0
  ypix=0
  coord1='('+string(xpix+1,format='(i4)')+','+string(ypix+1,format='(i4)')+')'
  coord2='No. of fits = '+string(nline,format='(i2)')
  coord=coord1+'     '+coord2
  WIDGET_CONTROL, coordtext, SET_VALUE = coord
END

;;; Change the order of polynomial fit.
"OBSFITORDER": BEGIN
  obsfit=fix(event.value)+1
  nline=0
  sprite=2
  drawetalon
END

"FITHEIGHT": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value1
  fitheight=value1
END

"FITWIDTH": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value1
  fitwidth=value1
END

ELSE:

ENDCASE

END


;===============================================================================
PRO picketalon, inimage, nout, coef, obsfitorder

;;; Prepare parameters and widgets.
;;;
;;; inimage	: input etalon image (IDL 2D array)
;;; nout	: # of fits made (output)
;;; coef	: coefficients of polynomial fit (output)
;;; obsfitorder	: order of polynomial fit (output)

COMPILE_OPT idl2, hidden
COMMON picketaloncom,thedraw1,coeftemp,obsfit,fitheight,fitwidth,nline, $
       wavetemp,sprite,spxa,spxb,spya,spyb,coordtext
COMMON bytimage4,image,bytmin,bytmax,xdim,ydim,ctable,nctable
COMMON slidercom4,slider1,slider2,checklog,picketalonbase
COMMON rightcom,imagenow,pressed,xstart,ystart,xold,yold,xdimtemp,ydimtemp, $
       thedrawtemp,ydim2temp,imageorig

image=inimage
nline=0
obsfit=1
fitheight=1
fitwidth=25

loadct,39

checklog=0
imagesize=size(image)
xdim=imagesize[1] & ydim=imagesize[2]
if (imagesize[0] eq 1) then ydim=1
ydim2=ydim
sprite=0 & spxa=xdim-1 & spxb=0 & spya=ydim-1 & spyb=0

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
title="ETALON"
picketalonbase = WIDGET_BASE(TITLE = title, /COLUMN)

msglabel = WIDGET_LABEL(picketalonbase, /ALIGN_LEFT, YSIZE=30, $
    VALUE='Fit a polynomial to each etalon line.')

topbase =  WIDGET_BASE(picketalonbase, /ROW)
nobutton = WIDGET_BUTTON(topbase, VALUE=' Done ', UVALUE='EXIT')
spacetext = WIDGET_LABEL(topbase, VALUE='          ')
undobutton = WIDGET_BUTTON(topbase, VALUE=' Undo Last ', UVALUE='UNDO')
clearbutton = WIDGET_BUTTON(topbase, VALUE=' Clear All ', UVALUE='CLEAR')

fitbase = WIDGET_BASE(picketalonbase, /ROW)
obsfitorderbutton = CW_BGROUP(fitbase, ['1','2','3'], /ROW, /EXCLUSIVE, $
    LABEL_TOP='Line Fit Order', FRAME=3, SET_VALUE=obsfit-1, $
    UVALUE='OBSFITORDER', /NO_RELEASE)
fitlabel1 = WIDGET_LABEL(fitbase, VALUE=' ')
fitheightslider = WIDGET_SLIDER(fitbase, MINIMUM=1, MAXIMUM=11, FRAME=3, $
    TITLE='Fit Height', XSIZE=91, VALUE=fitheight, UVALUE='FITHEIGHT')
fitlabel2 = WIDGET_LABEL(fitbase, VALUE=' ')
fitwidthslider = WIDGET_SLIDER(fitbase, MINIMUM=5, MAXIMUM=50, FRAME=3, $
    TITLE='Fit Width', XSIZE=91, VALUE=fitwidth, UVALUE='FITWIDTH')

sliderbase = WIDGET_BASE(picketalonbase, /ROW)
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
spacetext = WIDGET_LABEL(picketalonbase, VALUE='', XSIZE=xscr, YSIZE=10)
coordtext = WIDGET_LABEL(picketalonbase, VALUE='', XSIZE=xscr, YSIZE=20, $
                         /ALIGN_LEFT)

extra=''
if (xdim gt xscr)  then extra = {X_SCROLL_SIZE:xscr, Y_SCROLL_SIZE:ydim2+2}
if (ydim2 gt yscr) then extra = {X_SCROLL_SIZE:xdim+2, Y_SCROLL_SIZE:yscr}
if (xdim gt xscr and ydim2 gt yscr) then extra = {X_SCROLL_SIZE:xscr, $
    Y_SCROLL_SIZE:yscr}
dispbase = WIDGET_BASE(picketalonbase, /ROW)
display = WIDGET_DRAW(dispbase, RETAIN=2, $
                          XSIZE=xdim, YSIZE=ydim2, $
			  _Extra=extra, $
			  /BUTTON_EVENTS, /MOTION_EVENTS, UVALUE='BUTTON' )

ghostbase = WIDGET_BASE(picketalonbase)
ghostdisp = WIDGET_DRAW(ghostbase, RETAIN=2, XSIZE=10, YSIZE=10)
WIDGET_CONTROL, ghostbase, MAP=0

WIDGET_CONTROL, picketalonbase, /REALIZE
WIDGET_CONTROL, display, GET_VALUE = thedraw1

;;; Variables for right.pro 
xdimtemp=xdim & ydimtemp=ydim & thedrawtemp=thedraw1 & ydim2temp=ydim
imageorig=image

resolve_routine,'right'

drawetalon

XManager, "picketalon", picketalonbase

;;; Prepare output variables.
nout=nline
obsfitorder=obsfit

coef=fltarr(obsfit+1,nline)
center=fltarr(nline)
for k=0,obsfit do center=center+coeftemp[k,*]*float((ydim-1.)/2.)^k
sortcenter=sort(center)
for i=0,nline-1 do begin
  coef[*,i]=coeftemp[*,sortcenter[i]]
endfor

END

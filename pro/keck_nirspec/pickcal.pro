;;; REDSPEC, a GUI software package for reduction of spectrum data.
;;; Sungsoo S. Kim, UCLA Astronomy
;;; version 1.0 -- October, 2000
;;; version 2.0 -- December, 2000
;;; version 2.5 -- February, 2001
;;;
;;; Pick calibrator spectra, find centroids, and calculate polynomial fits..


;===============================================================================
PRO fitbutton_ev, event

;;; Control fit window widget events.
;;; Added to this module by SZK. Modified from the version in picklamp.pro

COMPILE_OPT idl2, hidden
COMMON pickcalcom,thedraw1,npoint,pointx,pointy,flagfit,coeftemp,obsfit, $
       fitheight,fitwidth,sprite,spxa,spxb,spya,spyb,nline,abort,check_fit, $
       clip_sigmafactor, clip_trimfrac, clip_minfrac
COMMON bytimage,image,bytmin,bytmax,ctable,nctable,xdim,ydim
COMMON slidercom1,slider1,slider2,checklog,pickcalbase
COMMON rightcom,imagenow,pressed,xstart,ystart,xold,yold,xdimtemp,ydimtemp, $
       thedrawtemp,ydim2temp,imageorig
COMMON displayfitcom1, datax, datay, yfit0, cff, chisq, fitdispbase0

WIDGET_CONTROL, event.id, GET_UVALUE = eventval

CASE eventval OF

"CLOSE": BEGIN
  WIDGET_CONTROL, event.top, /DESTROY
END

;;; Save a postscript file.
"PS": BEGIN
  devicesave=!D.NAME
  SET_PLOT, 'ps'
  file='trace_fit.ps'
  DEVICE, FILENAME=file
  plot, datax, datay, xtitle='X (pixels)', ytitle='Y (pixels)', psym=2, /ynozero, /xstyle
  oplot, datax, yfit0, thick=4
  ; Displaying the coefficients of the fit on the plot
  xyouts, 0.5, 0.90, ('Sum of Squared Errors = ' + string(chisq)), $
          align=0.5, /normal, charsize=1.2, charthick=1.2
  xyouts, 0.5, 0.85, 'Fit Coefficients:  ', align=1.0, /normal, charsize=1.2, charthick=1.2
  for i=0, n_elements(cff)-1 do begin
    tmpTXT = 'a' + string(i, format='(I1)') + ' = ' + string(cff[i])
    xyouts, 0.5, 0.85-(i/30.0), tmpTXT, /normal, charsize=1.2, charthick=1.2
  endfor
  DEVICE, /CLOSE
  SET_PLOT, devicesave
  message=DIALOG_MESSAGE(dialog_parent=fitdispbase0, $
          'The plot has been saved as "'+file+'".',/information)
END

ENDCASE

END

;===============================================================================
PRO display_fit

;;; Display the window widget for the fit.
;;; Added by SZK

COMPILE_OPT idl2, hidden
COMMON pickcalcom,thedraw1,npoint,pointx,pointy,flagfit,coeftemp,obsfit, $
       fitheight,fitwidth,sprite,spxa,spxb,spya,spyb,nline,abort,check_fit, $
       clip_sigmafactor, clip_trimfrac, clip_minfrac
COMMON bytimage,image,bytmin,bytmax,ctable,nctable,xdim,ydim
COMMON slidercom1,slider1,slider2,checklog,pickcalbase
COMMON rightcom,imagenow,pressed,xstart,ystart,xold,yold,xdimtemp,ydimtemp, $
       thedrawtemp,ydim2temp,imageorig
COMMON displayfitcom1, datax, datay, yfit0, cff, chisq, fitdispbase0

fitdispbase0 = WIDGET_BASE(GROUP_LEADER=pickcalbase, TITLE='Line Fit', $
                           /COLUMN, /MODAL)
fitbuttonbase0 = WIDGET_BASE(fitdispbase0, /ROW)

fitbutton0 = WIDGET_BUTTON(fitbuttonbase0, VALUE=' Close ', UVALUE='CLOSE', $
                           EVENT_PRO='fitbutton_ev')
psbutton0 = WIDGET_BUTTON(fitbuttonbase0, VALUE=' Postscript ', UVALUE='PS', $
                          EVENT_PRO='fitbutton_ev')
fitdisp0 = WIDGET_DRAW(fitdispbase0, RETAIN=2, XSIZE=640, YSIZE=480)

WIDGET_CONTROL, fitdispbase0, /REALIZE
WIDGET_CONTROL, fitdisp0, GET_VALUE=thedrawnow

WSET, thedrawnow
plot, datax, datay, xtitle='X (pixels)', ytitle='Y (pixels)', psym=2, /ynozero, /xstyle
oplot, datax, yfit0, thick=4, color=!d.table_size/2.

; Displaying the coefficients of the fit on the plot
xyouts, 0.5, 0.90, ('Sum of Squared Errors = ' + string(chisq)), $
        align=0.5, /normal, charsize=1.2, charthick=1.2
xyouts, 0.5, 0.85, 'Fit Coefficients:  ', align=1.0, /normal, charsize=1.2, charthick=1.2
for i=0, n_elements(cff)-1 do begin
  tmpTXT = 'a' + string(i, format='(I1)') + ' = ' + string(cff[i])
  xyouts, 0.5, 0.85-(i/30.0), tmpTXT, /normal, charsize=1.2, charthick=1.2
endfor

END

;===============================================================================
PRO drawcal

;;; Draw the image.

COMPILE_OPT idl2, hidden
COMMON pickcalcom,thedraw1,npoint,pointx,pointy,flagfit,coeftemp,obsfit, $
       fitheight,fitwidth,sprite,spxa,spxb,spya,spyb,nline,abort,check_fit, $
       clip_sigmafactor, clip_trimfrac, clip_minfrac
COMMON bytimage,image,bytmin,bytmax,ctable,nctable,xdim,ydim
COMMON slidercom1,slider1,slider2,checklog,pickcalbase
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

if (sprite eq 0) then tv,imagenow,0,0
if (sprite eq 2) then tv,imagenow[spxa:spxb,spya:spyb],spxa,spya
if (n_elements(xstart) ne 0) then right_erase

drawcal2

sprite=0

END


;===============================================================================
PRO drawcal2

;;; Plot the polynomial fits.

COMPILE_OPT idl2, hidden
COMMON pickcalcom,thedraw1,npoint,pointx,pointy,flagfit,coeftemp,obsfit, $
       fitheight,fitwidth,sprite,spxa,spxb,spya,spyb,nline,abort,check_fit, $
       clip_sigmafactor, clip_trimfrac, clip_minfrac
COMMON bytimage,image,bytmin,bytmax,ctable,nctable,xdim,ydim

if total(flagfit) ge 1 then begin
  spyai=intarr(2)+ydim-1
  spybi=intarr(2)
endif

for i=0,nline-1 do begin
  if flagfit[i] eq 1 then begin
    fitx=findgen(xdim)
    fity=fltarr(xdim)
    for k=0,obsfit do fity[*]=fity[*]+coeftemp[k,i]*fitx^k
    plot,fitx,fity,xrange=[0,xdim],yrange=[0,ydim],xstyle=5,ystyle=5,$
        xmargin=[0,0],ymargin=[0,0],color=0,/noerase
    spyai[i]=min(fity)
    spybi[i]=max(fity)
  endif
endfor

;;; Calculate spxa, spxb, spya, spyb for future redrawing.
;;; spxa, spxb, spya, spyb : vertices of a rentagle to be redrawn when
;;; erasing the fits.
spxa=0 & spxb=xdim-1
if (total(flagfit) ge 1) then begin
  spya=(fix(min(spyai))-10)>0
  spyb=(fix(max(spybi))+10)<(ydim-1)
endif

if (npoint ge 1) then begin
  px=pointx[0:npoint-1]
  py=pointy[0:npoint-1]
  plot,px,py,psym=1,xrange=[0,xdim],yrange=[0,ydim],xstyle=5,ystyle=5,$
    xmargin=[0,0],ymargin=[0,0],color=0,symsize=1.5,/noerase
  spyap=(min(py)-5)>0
  spybp=(max(py)+5)<(ydim-1)
  if (total(flagfit) ge 1) then begin
    spya=spya<spyap & spyb=spyb>spybp
  endif else begin
    spya=spyap & spyb=spybp
  endelse
endif

END


;===============================================================================
PRO pickcal_ev, event

;;; Control widget events.

COMPILE_OPT idl2, hidden
COMMON pickcalcom,thedraw1,npoint,pointx,pointy,flagfit,coeftemp,obsfit, $
       fitheight,fitwidth,sprite,spxa,spxb,spya,spyb,nline,abort,check_fit, $
       clip_sigmafactor, clip_trimfrac, clip_minfrac
COMMON bytimage,image,bytmin,bytmax,ctable,nctable,xdim,ydim
COMMON slidercom1,slider1,slider2,checklog,pickcalbase
COMMON displayfitcom1, datax, datay, yfit0, cff, chisq, fitdispbase0
COMMON clipcom1,cliptext1, cliptext2, cliptext3

WIDGET_CONTROL, event.id, GET_UVALUE = eventval

CASE eventval OF

"BUTTON": BEGIN
  right, event, redraw='drawcal2'

  ;;; Automatic fit with the left button
  ;;; The whole spectrum will be tried to be fit.
  if event.press eq 1 then begin
    WIDGET_CONTROL,/hourglass
    gaussy=fltarr(xdim)
    gaussheight=fltarr(xdim)
    gausswidth=fltarr(xdim)
    xin=event.x
    yin=event.y
    ybefore=yin
    ;;; Iteration from the clicked x position to the right edge of the image.
    for j=xin,xdim-1-(fitwidth-1) do begin
      x=j
      ;;; Use the previous centroid as an initial guess.
      y=ybefore
      xa=fix((x-fitwidth/2)>0)
      xb=fix((x+(fitwidth-1)/2)<(xdim-1))
      ya=fix((y-fitheight/2)>0)
      yb=fix((y+(fitheight-1)/2)<(ydim-1))
      nx=xb-xa+1
      ny=yb-ya+1
      ;;; Sum over fitwidth pixels (horizontally) and form a vector with a
      ;;; length of fitheight.
      columnx=total(reform(image[fix(xa):fix(xb),fix(ya):fix(yb)],nx,ny),1)
      columny=findgen(fix(yb)-fix(ya)+1)+float(ya)
      ;;; Fit a Gaussian to find each column's centroid.
      temp=gaussfit(columny,columnx,result,nterms=4)
      fity=result[1]
      height=result[0]
      sigma=result[2]
      ;;; See if the fit is bad.
      if (abs(fity-y) gt fitheight/2. or sigma gt 40. or sigma lt 0.25 or $
          height le 0.) then fity=y $
      else ybefore=fity
      gaussy[j]=fity
      gaussheight[j]=height
      gausswidth[j]=sigma
    endfor
    ybefore=yin
    ;;; Iteration from the clicked x position to the left edge of the image.
    for j=xin,(fitwidth-1),-1 do begin
      x=j
      ;;; Use the previous centroid as an initial guess.
      y=ybefore
      xa=fix((x-fitwidth/2)>0)
      xb=fix((x+(fitwidth-1)/2)<(xdim-1))
      ya=fix((y-fitheight/2)>0)
      yb=fix((y+(fitheight-1)/2)<(ydim-1))
      nx=xb-xa+1
      ny=yb-ya+1
      ;;; Sum over fitwidth pixels (horizontally) and form a vector with a
      ;;;     length of fitheight.
      columnx=total(reform(image[fix(xa):fix(xb),fix(ya):fix(yb)],nx,ny),1)
      columny=findgen(fix(yb)-fix(ya)+1)+float(ya)
      ;;; Fit a Gaussian to find each column's centroid.
      temp=gaussfit(columny,columnx,result,nterms=4)
      fity=result[1]
      height=result[0]
      sigma=result[2]
      ;;; See if the fit is bad.
      if (abs(fity-y) gt fitheight/2. or sigma gt 40. or sigma lt 0.25 or $
          height le 0.) then fity=y $
      else ybefore=fity
      gaussy[j]=fity
      gaussheight[j]=height
      gausswidth[j]=sigma
    endfor

    ;;; Clip out bad centroids.
    ;;; Modification of clipping by SZK: The origial version had
    ;;; "2.5, 0.1, 0.4" hard coded as sigmafactor, trimfrac, and minfrac.
    ;;; The new version uses these values as default but allows 
    ;;; modification through the widget.
    clip, gaussy,      clipflag1, clip_sigmafactor, clip_trimfrac, clip_minfrac
    clip, gaussheight, clipflag2, clip_sigmafactor, clip_trimfrac, clip_minfrac
    clip, gausswidth,  clipflag3, clip_sigmafactor, clip_trimfrac, clip_minfrac

    clipflag=clipflag1*clipflag2*clipflag3
    datax=where(clipflag)
    datay=gaussy[where(clipflag)]
    ;;; Fit a polynomial to the whole spectrum (array of centroids).
    CASE total(flagfit) OF
      0: BEGIN
        coeftemp[*,0]=poly_fit(datax,datay,obsfit,chisq=chisq,yfit=yfit0,/double)
        print,'=== SPATMAP:  Sum of squared errors = ',chisq
        flagfit[0]=1
        sprite=1
        ;;; The following 2 lines were added by SZK for displaying the
        ;;; the window for the goodness of fit
        cff = reform(coeftemp[*,0])
        if check_fit then display_fit
      END
      1: BEGIN
        if (nline eq 1) then begin
          iline=0
          sprite=2
        endif else begin
          if (flagfit[0] eq 0) then iline=0 else iline=1
          sprite=1
        endelse
        coeftemp[*,iline]=poly_fit(datax,datay,obsfit,chisq=chisq,yfit=yfit0,/double)
        print,'=== SPATMAP:  Sum of squared errors = ',chisq
        flagfit[iline]=1
        ;;; The following 2 lines were added by SZK for displaying the
        ;;; the window for the goodness of fit
        cff = reform(coeftemp[*,iline])
        if check_fit then display_fit
      END
      2: BEGIN
        coeftemp[*,0]=coeftemp[*,1]
        coeftemp[*,1]=poly_fit(datax,datay,obsfit,chisq=chisq,yfit=yfit0,/double)
        print,'=== SPATMAP:  Sum of squared errors = ',chisq
        flagfit[1]=1
        sprite=2
        ;;; The following 2 lines were added by SZK for displaying the
        ;;; the window for the goodness of fit
        cff = reform(coeftemp[*,1])
        if check_fit then display_fit
      END
    END
    if (npoint gt 0) then sprite=2
    npoint=0
    drawcal
  endif

  ;;; Manual fit with the middle button
  ;;; Fit a Gaussian to find the centroid, and save it for future use.
  if (event.press eq 2 or event.press eq 5) then begin
    x=event.x
    y=event.y
    xa=fix((x-fitwidth/2)>0)
    xb=fix((x+(fitwidth-1)/2)<(xdim-1))
    ya=fix((y-fitheight/2)>0)
    yb=fix((y+(fitheight-1)/2)<(ydim-1))
    ;;; Sum over fitwidth pixels (horizontally) and form a vector with a
    ;;; length of fitheight.
    columnx=findgen(fix(yb)-fix(ya)+1)+float(ya)
    columny=float(total(image[fix(xa):fix(xb),fix(ya):fix(yb)],1))
    ;;; Fit a Gaussian to find a centroid.
    temp=gaussfit(columnx,columny,result,nterms=4)
    fity=result[1]
    height=result[0]
    sigma=result[2]
    ;;; See if the fit is bad.
    if (abs(fity-y) gt fitheight/2. or sigma gt 40. or sigma lt 0.25 or $
        height le 0.) then begin
      message=DIALOG_MESSAGE('Fit Failed.  Clicked position used instead.', $
                             DIALOG_PARENT=pickcalbase)
      fity=y
    endif
    pointx[npoint]=x
    pointy[npoint]=fity
    npoint=npoint+1
    sprite=1
    drawcal
  endif
END

;;; Change the number of spectra to be fit.
"NLINE": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value
  nline=2-value
  flagfit[1]=0
  sprite=2
  drawcal
END

; Added by SZK. Needed for interactively changing the 
; the input parameters for clipping bad data.
"CLIP_SF": BEGIN
  WIDGET_CONTROL, cliptext1, GET_VALUE=clip_sigmafactor
  clip_sigmafactor = float(clip_sigmafactor[0])
END

"CLIP_TF": BEGIN
  WIDGET_CONTROL, cliptext2, GET_VALUE=clip_trimfrac
  clip_trimfrac = float(clip_trimfrac[0])
END

"CLIP_MF": BEGIN
  WIDGET_CONTROL, cliptext3, GET_VALUE=clip_minfrac
  clip_minfrac = float(clip_minfrac[0])
END
; End of section by SZK

"SLIDER1": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value1
  bytmin=ctable[long((nctable-1.)*value1/1000.)]
  drawcal
END

"SLIDER2": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value2
  bytmax=ctable[long((nctable-1.)*(1.-value2/1000.))]
  drawcal
END

"DISP_FIT": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = check_fit
END

"LOG": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = checklog
  drawcal
END

"XLOADCT": BEGIN
  xloadct
END

"EXIT": BEGIN
  if total(flagfit) eq nline then begin
    WIDGET_CONTROL, event.top, /DESTROY
  endif else begin
    if (nline eq 1) then begin
      message=DIALOG_MESSAGE('Fit one spectrum.', DIALOG_PARENT=pickcalbase)
    endif else begin
      message=DIALOG_MESSAGE('Fit two spectra.', DIALOG_PARENT=pickcalbase)
    endelse
  endelse
END

"ABORT": BEGIN
  message=DIALOG_MESSAGE('Are you sure to abort?', DIALOG_PARENT=pickcalbase, $
                        /QUESTION, /DEFAULT_NO)
  if (message eq 'Yes') then begin
    abort=1
    WIDGET_CONTROL, event.top, /DESTROY
  endif
END

;;; Fit a polynomial to an array of saved positions with the middle button.
"MANUALFIT": BEGIN
  if npoint ge obsfit+1 then begin
    fitx=pointx[0:npoint-1]
    fity=pointy[0:npoint-1]
    CASE total(flagfit) OF
      0: BEGIN
        coeftemp[*,0]=poly_fit(fitx,fity,obsfit,chisq=chisq,/double)
        print,'=== SPATMAP:  Sum of squared errors = ',chisq
        flagfit[0]=1
      END
      1: BEGIN
        if flagfit[0] eq 0 then iline=0 else iline=1
        coeftemp[*,iline]=poly_fit(fitx,fity,obsfit,chisq=chisq,/double)
        print,'=== SPATMAP:  Sum of squared errors = ',chisq
        flagfit[iline]=1
      END
      2: BEGIN
        coeftemp[*,0]=coeftemp[*,1]
        coeftemp[*,1]=poly_fit(fitx,fity,obsfit,chisq=chisq,/double)
        print,'=== SPATMAP:  Sum of squared errors = ',chisq
        flagfit[1]=1
      END
    END
    npoint=0
    sprite=2
    drawcal
  endif else begin
    message=DIALOG_MESSAGE('Manual Fit: Click on at least '+string(obsfit+1, $
            format='(i1)')+' points with the middle button.', $
	    DIALOG_PARENT=pickcalbase)
  endelse
END

;;; Change the order of polynomial fit.
"FITORDER": BEGIN
  obsfit=fix(event.value)+1
  coeftemp=fltarr(obsfit+1,2)
  flagfit[0]=0
  flagfit[1]=0
  npoint=0
  sprite=2
  drawcal
END

"FITHEIGHT": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value1
  fitheight=value1
END

"FITWIDTH": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value1
  fitwidth=value1
END

ENDCASE

END


;===============================================================================
PRO pickcal, inimage, obsfitorder, coef

;;; Prepare parameters and widgets.
;;;
;;; inimage	: input image (IDL 2D array)
;;; obsfitorder	: order of polynomial fit (output)
;;; coef	: coefficients of polynomial fit (output)

COMPILE_OPT idl2, hidden
COMMON pickcalcom,thedraw1,npoint,pointx,pointy,flagfit,coeftemp,obsfit, $
       fitheight,fitwidth,sprite,spxa,spxb,spya,spyb,nline,abort,check_fit, $
       clip_sigmafactor, clip_trimfrac, clip_minfrac
COMMON bytimage,image,bytmin,bytmax,ctable,nctable,xdim,ydim
COMMON slidercom1,slider1,slider2,checklog,pickcalbase
COMMON rightcom,imagenow,pressed,xstart,ystart,xold,yold,xdimtemp,ydimtemp, $
       thedrawtemp,ydim2temp,imageorig
COMMON clipcom1,cliptext1, cliptext2, cliptext3

image=inimage
nline=2
obsfit=2
fitheight=20
fitwidth=1
sprite=0 & spxa=0 & spxb=0 & spya=0 & spyb=0
clip_sigmafactor = 2.5 & clip_trimfrac = 0.1 & clip_minfrac = 0.4

flagfit=intarr(2) & coeftemp=fltarr(obsfit+1,2)
pointx=fltarr(100) & pointy=fltarr(100) & npoint=0
checklog=0 & abort=0 & check_fit=0
imagesize=size(image)
xdim=imagesize[1] & ydim=imagesize[2]
if (imagesize[0] eq 1) then ydim=1

;if long(xdim)*long(ydim) lt long(1024)*long(256) then begin
;  imagesort=sort(image)
;  bytmintemp=image[imagesort[long(float(xdim)*ydim*0.001)]]
;  bytmaxtemp=image[imagesort[long(float(xdim)*ydim*0.999)-1]]
;  bytmin=bytmintemp-0.1*(bytmaxtemp-bytmintemp)
;  bytmax=bytmaxtemp+0.1*(bytmaxtemp-bytmintemp)
;endif else begin
;  bytmin=min(image)
;  bytmax=max(image)
;endelse
;bytminorig=bytmin & bytmaxorig=bytmax

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
pickcalbase = WIDGET_BASE(TITLE = "SPATMAP", /COLUMN)

msglabel = WIDGET_LABEL(pickcalbase, /ALIGN_LEFT, YSIZE=30, $
    VALUE='Click on each spectrum to fit a polynomial.')

menubase = WIDGET_BASE(pickcalbase, /ROW)
nobutton = WIDGET_BUTTON(menubase, VALUE=' Done ', UVALUE='EXIT')
msglabel2 = WIDGET_LABEL(menubase, VALUE=' ')
abortbutton = WIDGET_BUTTON(menubase, VALUE=' Abort ', UVALUE='ABORT')
msglabel2 = WIDGET_LABEL(menubase, VALUE='            ')
manfitbutton = WIDGET_BUTTON(menubase, VALUE=' Manual Fit ', $
			  UVALUE='MANUALFIT')

nlinebase = WIDGET_BASE(pickcalbase, /ROW)
nlinebutton = CW_BGROUP(nlinebase, ['Nod1+Nod2 ','On+Off '], /ROW, $
                        UVALUE='NLINE', SET_VALUE=2-nline, /EXCLUSIVE, $
                        /NO_RELEASE, FRAME=3)

; Added by SZK
; These text boxes get the parameters for the clipping function
cliptextbase = WIDGET_BASE(pickcalbase, /ROW)
cliplabel = WIDGET_LABEL(cliptextbase, VALUE='Clipping Parameters: ')
cliptext1 = CW_FIELD(cliptextbase, VALUE=string(clip_sigmafactor,format='(g8.2)'), $
			UVALUE='CLIP_SF', XSIZE=5, /RETURN_EVENTS, TITLE='Sigma Factor')
cliptext2 = CW_FIELD(cliptextbase, VALUE=string(clip_trimfrac,format='(g8.2)'), $
			UVALUE='CLIP_TF', XSIZE=5, /RETURN_EVENTS, TITLE='Trim Fraction')
cliptext3 = CW_FIELD(cliptextbase, VALUE=string(clip_minfrac,format='(g8.2)'), $
			UVALUE='CLIP_MF', XSIZE=5, /RETURN_EVENTS, TITLE='Minimum Fraction')
; End of section by SZK

fitbase = WIDGET_BASE(pickcalbase, /ROW)
fitorderbutton = CW_BGROUP(fitbase, ['1','2','3','4'], /ROW, /EXCLUSIVE, $
    LABEL_TOP='Fit Order', FRAME=3, SET_VALUE=obsfit-1, UVALUE='FITORDER', $
    /NO_RELEASE)
fitlabel1 = WIDGET_LABEL(fitbase, VALUE='    ')
fitheightslider = WIDGET_SLIDER(fitbase, MINIMUM=10, MAXIMUM=40, FRAME=3, $
    TITLE='Fit Height', XSIZE=91, VALUE=fitheight, UVALUE='FITHEIGHT')
fitlabel2 = WIDGET_LABEL(fitbase, VALUE=' ')
fitwidthslider = WIDGET_SLIDER(fitbase, MINIMUM=1, MAXIMUM=11, FRAME=3, $
    TITLE='Fit Width', XSIZE=91, VALUE=fitwidth, UVALUE='FITWIDTH')
; Added by SZK
fitlabel3 = WIDGET_LABEL(fitbase, VALUE='     ')
fitcheckbutton = CW_BGROUP(fitbase, 'Display Fit', UVALUE='DISP_FIT', $
                           LABEL_TOP=' ', /NONEXCLUSIVE, XOFFSET=10, FRAME=3)
; End of section by SZK

sliderbase = WIDGET_BASE(pickcalbase, /ROW)
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
display = WIDGET_DRAW(pickcalbase, RETAIN=2, $
                          XSIZE=xdim, YSIZE=ydim, $
			  _Extra=extra, $
			  /BUTTON_EVENTS, /MOTION_EVENTS, UVALUE='BUTTON' )

ghostbase = WIDGET_BASE(pickcalbase)
ghostdisp = WIDGET_DRAW(ghostbase, RETAIN=2, XSIZE=10, YSIZE=10)
WIDGET_CONTROL, ghostbase, MAP=0

WIDGET_CONTROL, pickcalbase, /REALIZE
WIDGET_CONTROL, display, GET_VALUE = thedraw1

;;; Variables for right.pro
xdimtemp=xdim & ydimtemp=ydim & thedrawtemp=thedraw1 & ydim2temp=ydim
imageorig=image

WSET, thedraw1
drawcal

XManager, "pickcal", pickcalbase, EVENT_HANDLER = "pickcal_ev"

;;; Prepare output variables.
if (nline eq 1) then begin
  coef=coeftemp[*,0]
endif else begin
  coef=coeftemp
  if (coeftemp[0,1] lt coeftemp[0,0]) then begin
    coef[*,0]=coeftemp[*,1]
    coef[*,1]=coeftemp[*,0]
  endif
endelse

obsfitorder=obsfit
if (abort eq 1) then obsfitorder=-99   ; Abort

END


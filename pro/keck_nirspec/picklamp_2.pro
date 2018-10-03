;;; REDSPEC, a GUI software package for reduction of spectrum data.
;;; Sungsoo S. Kim, UCLA Astronomy
;;; version 1.0 -- October, 2000
;;; version 2.0 -- December, 2000
;;; version 2.5 -- February, 2001
;;;
;;; Pick arc lamp lines, find centroids, and calculate polynomial fits, for
;;; arc 2.


;===============================================================================
PRO drawlamp_2

;;; Draw the arc lamp image.

COMPILE_OPT idl2, hidden
COMMON picklampcom_2,thedraw1,npoint,pointx,pointy,flagfit,coeftemp,obsfit, $
       fitheight,fitwidth,nline,iline,flagline,flagflash,recfit,wavetemp, $
       sprite,spxa,spxb,spya,spyb,gaussxsave,infoheight,coordtext,display, $
       recfitorderbutton,etalontext,etaloncheck
COMMON bytimage2_2,image,bytmin,bytmax,xdim,ydim,ctable,nctable
COMMON slidercom2_2,slider1,slider2,checklog,selexcl,selnonexcl,picklampbase
COMMON rightcom_2,imagenow,pressed,xstart,ystart,xold,yold,xdimtemp,ydimtemp, $
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
if (n_elements(xstart) ne 0) then right_erase_2

drawlamp2_2

sprite=0

END


;===============================================================================
PRO drawlamp2_2

;;; Plot the plynomial fits.
;;;
;;; spxa, spxb, spya, spyb : vertices of a rentagle to be redrawn when
;;;     erasing the fits.

COMPILE_OPT idl2, hidden
COMMON picklampcom_2,thedraw1,npoint,pointx,pointy,flagfit,coeftemp,obsfit, $
       fitheight,fitwidth,nline,iline,flagline,flagflash,recfit,wavetemp, $
       sprite,spxa,spxb,spya,spyb,gaussxsave,infoheight,coordtext,display, $
       recfitorderbutton,etalontext,etaloncheck
COMMON bytimage2_2,image,bytmin,bytmax,xdim,ydim,ctable,nctable

color1=0
color2=fix(256./8.)
ydim2=ydim+infoheight

if (iline lt nline) then begin

  if (flagfit[iline] eq 1) then begin
    spxa=xdim-1 & spxb=0
    if (flagflash eq 0) then colornow=color1 else colornow=color2
    for j=10,ydim-1,20 do begin
      fitynow=0.
      for k=0,obsfit do fitynow=fitynow+coeftemp[k,iline]*float(j)^k
      fity=fix(fitynow+0.5)
      if fity ge 0 and fity le xdim-1 then begin
        plot,[fity],[j],psym=1,xrange=[0,xdim],yrange=[0,ydim2],xstyle=5, $
	    ystyle=5,xmargin=[0,0],ymargin=[0,0],color=colornow,/noerase
        spxa=((fity-10)<spxa)>0
        spxb=((fity+10)>spxb)<(xdim-1)
      endif
    endfor
    if (flagflash eq 0) then colornow=color2 else colornow=color1
    for j=20,ydim-1,20 do begin
      fitynow=0.
      for k=0,obsfit do fitynow=fitynow+coeftemp[k,iline]*float(j)^k
      fity=fix(fitynow+0.5)
      if fity ge 0 and fity le xdim-1 then begin
        plot,[fity],[j],psym=1,xrange=[0,xdim],yrange=[0,ydim2],xstyle=5, $
	    ystyle=5,xmargin=[0,0],ymargin=[0,0],color=colornow,/noerase
        spxa=((fity-10)<spxa)>0
        spxb=((fity+10)>spxb)<(xdim-1)
      endif
    endfor
    spya=0 & spyb=ydim-1
  endif

endif

END


;===============================================================================
PRO writeinfo_2

;;; Write numbers on top of each arc lamp line.

COMPILE_OPT idl2, hidden
COMMON picklampcom_2,thedraw1,npoint,pointx,pointy,flagfit,coeftemp,obsfit, $
       fitheight,fitwidth,nline,iline,flagline,flagflash,recfit,wavetemp, $
       sprite,spxa,spxb,spya,spyb,gaussxsave,infoheight,coordtext,display, $
       recfitorderbutton,etalontext,etaloncheck
COMMON bytimage2_2,image,bytmin,bytmax,xdim,ydim,ctable,nctable

WSET, thedraw1

ydim2=ydim+infoheight
rm_info=fltarr(xdim,infoheight)+1
tv,rm_info,0,ydim

;;; Inactive fits
if (total(flagline) ge 1) then begin
  out1=indgen(nline)
  out1=out1[where(flagline)]
  nout1=n_elements(out1)
  xout1=fltarr(nout1)
  strout1=strarr(nout1)
  ;;; Find the x position.
  for j=0,nout1-1 do begin
    for k=0,obsfit do xout1[j]=xout1[j]+coeftemp[k,out1[j]]*float(ydim-1)^k
    if (out1[j]+1 lt 10) then begin
      strout1[j]=string(out1[j]+1,format='(i1)')
    endif else begin
      strout1[j]=string(out1[j]+1,format='(i2)')
    endelse
  endfor
  yout1=intarr(nout1)+ydim+2
  xyouts,xout1,yout1,strout1,color=!d.table_size-1,alignment=0.5,/device
endif

;;; Active fits
if (total(flagfit*(1-flagline)) ge 1) then begin
  out2=indgen(nline)
  out2=out2[where(flagfit*(1-flagline))]
  nout2=n_elements(out2)
  xout2=fltarr(nout2)
  strout2=strarr(nout2)
  ;;; Find the x position.
  for j=0,nout2-1 do begin
    for k=0,obsfit do xout2[j]=xout2[j]+coeftemp[k,out2[j]]*float(ydim-1)^k
    if (out2[j]+1 lt 10) then begin
      strout2[j]=string(out2[j]+1,format='(i1)')
    endif else begin
      strout2[j]=string(out2[j]+1,format='(i2)')
    endelse
  endfor
  yout2=intarr(n_elements(out2))+ydim+2
  xyouts,xout2,yout2,strout2,color=!d.table_size/4.,alignment=0.5,/device
endif

END


;===============================================================================
PRO picklamp_2_event, event

;;; Control the main widget events.

COMPILE_OPT idl2, hidden
COMMON picklampcom_2,thedraw1,npoint,pointx,pointy,flagfit,coeftemp,obsfit, $
       fitheight,fitwidth,nline,iline,flagline,flagflash,recfit,wavetemp, $
       sprite,spxa,spxb,spya,spyb,gaussxsave,infoheight,coordtext,display, $
       recfitorderbutton,etalontext,etaloncheck
COMMON picklampcom,thedraw1_1,npoint_1,pointx_1,pointy_1,flagfit_1, $
       coeftemp_1,obsfit_1,fitheight_1,fitwidth_1,nline_1,iline_1,flagline_1, $
       flagflash_1,recfit_1,wavetemp_1,sprite_1,spxa_1,spxb_1,spya_1,spyb_1, $
       gaussxsave_1,infoheight_1,coordtext_1,nlamp,fake,etalontext_1, $
       etaloncheck_1,abort_1,check_arcfit_1, $
       clip_sigmafactor_1, clip_trimfrac_1, clip_minfrac_1
COMMON bytimage2_2,image,bytmin,bytmax,xdim,ydim,ctable,nctable
COMMON bytimage2,image_1,bytmin_1,bytmax_1,xdim_1,ydim_1,ctable_1,nctable_1
COMMON slidercom2_2,slider1,slider2,checklog,selexcl,selnonexcl,picklampbase
COMMON fitdrawcom,gaussx1,gaussx2,xp,yp,spec1,spec2,wavea,waveb,waveaa,wavebb, $
       fitdispbase,thedrawnow,offset1,offset2,ycut,specmapi,nflag1,nflag2, $
       specmap
COMMON specetacom,n_eta,coef_eta,obsfit_eta
COMMON displayfitcom2, datax, datay, yfit0, cff, fline, chisq, fitdispbase0

WIDGET_CONTROL, event.id, GET_UVALUE = eventval
ydim2=ydim+infoheight

CASE eventval OF

"BUTTON": BEGIN
  WIDGET_CONTROL, selexcl, GET_VALUE = value1

  if (fake eq 0) then right_2, event, redraw='drawlamp2_2'
  if event.press ne 1 then goto, jump1

  if (value1 le nline-1) then begin

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
      xa=fix((x-fitwidth/2)>0.)
      xb=fix((x+(fitwidth-1)/2)<(xdim-1))
      ya=fix((y-fitheight/2)>0.)
      yb=fix((y+(fitheight-1)/2)<(ydim-1))
      nx=xb-xa+1
      ny=yb-ya+1
      ;;; Sum over fitheight pixels (vertically) and form a vector with a
      ;;; length of fitwidth.
      columnx=findgen(fix(xb)-fix(xa)+1)+float(xa)
      columny=total(reform(image[fix(xa):fix(xb),fix(ya):fix(yb)],nx,ny),2)
      ;;; Fit a Gaussian to find each row's centroid.
      if (nx ge 5) then begin
        temp=gaussfit(columnx,columny,result,nterms=4)
        fitx=result[1]
        height=result[0]
        sigma=result[2]
      endif else begin
        fitx=-100.
        height=-100.
        sigma=-100.
      endelse
      ;;; See if the fit is bad.
      if (abs(fitx-x) gt fitwidth/2. or sigma gt 40. or sigma lt 0.25 or $
          height le 0.) then fitx=x $
      else xbefore=fitx
      gaussx[j]=fitx
      gaussheight[j]=height
      gausswidth[j]=sigma
    endfor
    xbefore=xin
    ;;; Iteration from the clicked y position to the upper edge of the image.
    for j=nlower,0,-1 do begin
      ;;; Use the previous centroid as an initial guess.
      x=xbefore
      y=yin+(j-nlower)*yfreq
      xa=fix((x-fitwidth/2)>0.)
      xb=fix((x+(fitwidth-1)/2)<(xdim-1))
      ya=fix((y-fitheight/2)>0.)
      yb=fix((y+(fitheight-1)/2)<(ydim-1))
      nx=xb-xa+1
      ny=yb-ya+1
      ;;; Sum over fitheight pixels (vertically) and form a vector with a
      ;;; length of fitwidth.
      columnx=findgen(fix(xb)-fix(xa)+1)+float(xa)
      columny=total(reform(image[fix(xa):fix(xb),fix(ya):fix(yb)],nx,ny),2)
      ;;; Fit a Gaussian to find each row's centroid.
      if (nx ge 5) then begin
        temp=gaussfit(columnx,columny,result,nterms=4)
        fitx=result[1]
        height=result[0]
        sigma=result[2]
      endif else begin
        fitx=-100.
        height=-100.
        sigma=-100.
      endelse
      ;;; See if the fit is bad.
      if (abs(fitx-x) gt fitwidth/2. or sigma gt 40. or sigma lt 0.25 or $
          height le 0.) then fitx=x $
      else xbefore=fitx
      gaussx[j]=fitx
      gaussheight[j]=height
      gausswidth[j]=sigma
    endfor
;   gaussxsave[iline,*]=gaussx[*]

    ;;; Clip out bad centroids.
    ;;; Modification of clipping by SZK: The origial version had
    ;;; "2.5, 0.1, 0.4" hard coded as sigmafactor, trimfrac, and minfrac.
    ;;; The new version uses these values as default but allows 
    ;;; modification through the widget.
    clip, gaussx,      clipflag1, clip_sigmafactor_1, clip_trimfrac_1, clip_minfrac_1
    clip, gaussheight, clipflag2, clip_sigmafactor_1, clip_trimfrac_1, clip_minfrac_1
    clip, gausswidth,  clipflag3, clip_sigmafactor_1, clip_trimfrac_1, clip_minfrac_1

    clipflag=clipflag1*clipflag2*clipflag3
    datax=indgen(ntotal)*yfreq+ylower
    datax=datax[where(clipflag)]
    datay=gaussx[where(clipflag)]
    ;;; Fit a polynomial to the whole arc lamp line (array of centroids).
    coeftemp[*,iline]=poly_fit(datax,datay,obsfit,yfit=yfit0,chisq=chisq,/double)

    ;This section was added by SZK to bring up a widget displaying the
    ;goodness of the fit for the indvidual arc lamp lines.
    print, ' === SPECMAP:  Line = ', string(iline+1, format='(i3)'), $
           '  -  Sum of squared errors  = ', chisq
    cff = reform(coeftemp[*,iline])
    fline = iline
    if check_arcfit_1 then begin
    ;;; Prepare fit window widgets.
      fitdispbase0 = WIDGET_BASE(GROUP_LEADER=picklampbase, TITLE='Arc Lamp Line Fit', $
                                 /COLUMN, /MODAL)
      fitbuttonbase0 = WIDGET_BASE(fitdispbase0, /ROW)
      psbutton0 = WIDGET_BUTTON(fitbuttonbase0, VALUE=' Postscript ', UVALUE='PSF', $
                                EVENT_PRO='fitbutton_event')
      fitbutton0 = WIDGET_BUTTON(fitbuttonbase0, VALUE=' Close ', UVALUE='CLOSE', $
                                 EVENT_PRO='fitbutton_event')
      fitdisp0 = WIDGET_DRAW(fitdispbase0, RETAIN=2, XSIZE=480, YSIZE=480)

      WIDGET_CONTROL, fitdispbase0, /REALIZE
      WIDGET_CONTROL, fitdisp0, GET_VALUE=thedrawnow
      
      WSET, thedrawnow
      plot, datay, datax, xtitle='X (pixels)', ytitle='Y (pixels)', psym=2, /ynozero
      oplot, yfit0, datax, thick=2, color=!d.table_size/2.
      xyouts, 0.5, 0.90, ('Line ' + string(fline+1, format='(I2)')), $
              align=0.5, /normal, charsize=1.5, charthick=1.5
      xyouts, 0.5, 0.85, ('Sum of Squared Errors = ' + string(chisq)), $
              align=0.5, /normal, charsize=1.2, charthick=1.2
      xyouts, 0.5, 0.80, 'Fit Coefficients:  ', align=1.0, /normal, charsize=1.2, charthick=1.2
      for i=0, n_elements(cff)-1 do begin
        tmpTXT = 'a' + string(i, format='(I1)') + ' = ' + string(cff[i])
        xyouts, 0.5, 0.80-(i/30.0), tmpTXT, /normal, charsize=1.2, charthick=1.2
      endfor
    endif
    ; End section added by SZK

    flagfit[iline]=1
    WIDGET_CONTROL, selnonexcl, GET_VALUE = value1
    value1[iline]=1
    flagline[iline]=1
    WIDGET_CONTROL, selnonexcl, SET_VALUE = value1
    flagflash=1-flagflash
    if (fake eq 0) then begin
      sprite=2
      drawlamp_2
      writeinfo_2
    endif

  endif else begin

    nflag1=total(flagline_1)
    nflag2=total(flagline)
    nflagall=nflag1+nflag2
    flagboth=[flagline_1,flagline]

    if (nflag1+nflag2 le recfit) then begin
      message=DIALOG_MESSAGE('Not enough line fits.',DIALOG_PARENT=picklampbase)
      goto, jump1
    endif

    ;;; Draw a horizontal line on the image to show the location of the
    ;;; selected y-cut.
    y=(event.y>0)<(ydim-1)
    ycut=y
    sprite=2
    drawlamp_2
    WSET, thedraw1
    plot,[0,xdim-1],[y,y],xrange=[0,xdim],yrange=[0,ydim2],xstyle=5,ystyle=5,$
        xmargin=[0,0],ymargin=[0,0],color=!d.table_size/2.,/noerase
    spxa=0 & spxb=xdim-1
    spya=y & spyb=y

    ;;; Fit a polynomial to x-locations of selected arc lamp lines at each row,
    ;;; and save it as specmap.
    specmap=fltarr(recfit+1,ydim)
    fitxsave=fltarr(nflagall,ydim)
    fitysave=fltarr(nflagall,ydim)
    arc_lambda_residual=fltarr(ydim)
    for j=0,ydim-1 do begin
      fitxtemp1=fltarr(nline_1)
      fitxtemp2=fltarr(nline)
      for k=0,obsfit_1 do fitxtemp1=fitxtemp1+coeftemp_1[k,*]*float(j)^k
      for k=0,obsfit do fitxtemp2=fitxtemp2+coeftemp[k,*]*float(j)^k
      fitxtemp=[fitxtemp1,fitxtemp2]
      fitxtemp=fitxtemp[where(flagboth)]
      fitytemp=[wavetemp_1,wavetemp]
      fitytemp=fitytemp[where(flagboth)]
      fitx=fitxtemp[sort(fitxtemp)]
      fity=fitytemp[sort(fitxtemp)]
      if (!version.release ne 5.3) then begin
        specmap[*,j]=poly_fit(fitx,fity,recfit,yfit=yfit,chisq=chisq,/double)
        print,'=== SPECMAP:  Sum of squared errors = ',chisq
      endif else begin
        specmap[*,j]=poly_fit(fitx,fity,recfit,yfit,/double)
      endelse
      arc_lambda_residual[j]=sqrt(total((yfit-fity)^2/(nflagall-1)))
      if (j eq y) then begin
        fitx1i=fitxtemp1
        fitx2i=fitxtemp2
      endif
      fitxsave[*,j]=fitx
      fitysave[*,j]=fity
    endfor

    ;;; Include etalon fringes if chosen.
    ;;; Not for public use.
    if (n_eta ge 2) then begin
      WIDGET_CONTROL, etaloncheck, GET_VALUE=value
    endif else begin
      value=0
    endelse

    if (n_eta ge 2 and value eq 1) then begin
      ;;; Get the etalon info.
      etaloninfo,specmap,etalonx,etalony,deltanu,sigma_deltanu, $
                 etalon_lambda_residual
      ;;; Recalculate specmap with etalon data.
      for j=0,ydim-1 do begin
        fitx=[fitxsave[*,j],etalonx[*,j]]
        fity=[fitysave[*,j],etalony[*,j]]
        weight=[(fltarr(nflagall)+1.)*arc_lambda_residual[j], $
                (fltarr(n_eta)+1.)*etalon_lambda_residual[j]]
        if (!version.release ne 5.3) then begin
          specmap[*,j]=poly_fit(fitx,fity,recfit,measure_errors=weight, $
		chisq=chisq,/double)
          print,'=== SPECMAP:  Sum of squared errors = ',chisq
        endif else begin
          specmap[*,j]=polyfitw(fitx,fity,weight,recfit)
        endelse
      endfor
      xptemp=findgen(2)*(xdim-1.)
      yptemp=fltarr(2)
      for k=0,recfit do yptemp=yptemp+specmap[k,y]*xptemp^k
      lam2pix=(xdim-1.)/(yptemp[1]-yptemp[0])
      ;;; Display etalon information.
      text1='Etalon frequency = '+string(abs(deltanu[y]),format='(e9.3)')+ $
            ' +- '+string(sigma_deltanu[y],format='(e7.1)')+' (mu-1)'
      text2='Etalon lambda residual = '+string(etalon_lambda_residual[y]* $
            lam2pix,format='(e9.3)')+' (pix)'
      WIDGET_CONTROL, etalontext, SET_VALUE=text1+';     '+text2
    endif

    ;;; Save the specmap info for the selected row.
    specmapi=reform(specmap[*,y])

    ;;; Calculate parameters for fit window.
    ;;; yp      : wavelength of each arc lamp line
    ;;; offset1 : offset between the wavelength calculated from obtained
    ;;;               specmap and input wavelength for arc 1.
    ;;; offset2 : offset between the wavelength calculated from obtained
    ;;;               specmap and input wavelength for arc 2.
    ;;; wavea   : minimum yp
    ;;; waveb   : maximum yp
    ;;; waveaa  : wavea-cushion
    ;;; wavebb  : waveb+cushion
    ;;; spec1   : integrated horizontal cut of the arc image 1 over fitheight
    ;;; spec2   : integrated horizontal cut of the arc image 2 over fitheight
;   gaussx1=gaussxsave_1(*,y)
;   gaussx2=gaussxsave(*,y)
    gaussx1=fitx1i
    gaussx2=fitx2i
    xp=findgen(xdim)
    yp=fltarr(xdim)
    wavea=0. & waveb=0.
    offset1=fltarr(nline_1)
    offset2=fltarr(nline)
    for j=0,recfit do begin
      yp[*]=yp[*]+specmapi[j]*xp^j
;     offset1[*]=offset1[*]+specmapi[j]*gaussx1[*]^j
;     offset2[*]=offset2[*]+specmapi[j]*gaussx2[*]^j
      offset1[*]=offset1[*]+specmapi[j]*fitx1i[*]^j
      offset2[*]=offset2[*]+specmapi[j]*fitx2i[*]^j
    endfor
    wavea=min(yp)
    waveb=max(yp)
    wavespanin=waveb-wavea
    waveaa=wavea-wavespanin*0.6
    wavebb=waveb+wavespanin*0.6
    offset1=(offset1-wavetemp_1)/((yp[xdim-1]-yp[0])/xdim)
    offset2=(offset2-wavetemp)/((yp[xdim-1]-yp[0])/xdim)
    ya=(y-fitheight/2)>0
    yb=(y+(fitheight-1)/2)<(ydim-1)
    spec1=total(reform(image_1[*,ya:yb],xdim,(yb-ya+1)),2)
    spec2=total(reform(image[*,ya:yb],xdim,(yb-ya+1)),2)

    ;;; Prepare fit window widgets.
    fitdispbase = WIDGET_BASE(GROUP_LEADER=picklampbase, TITLE='Lambda Fit', $
                              /COLUMN, /MODAL)
    fitbuttonbase = WIDGET_BASE(fitdispbase, /ROW)
    psbutton = WIDGET_BUTTON(fitbuttonbase, VALUE=' Postscript ', UVALUE='PS', $
			      EVENT_PRO='fitbutton_event')
    fitbutton = WIDGET_BUTTON(fitbuttonbase, VALUE=' Close ', UVALUE='CLOSE', $
			      EVENT_PRO='fitbutton_event')
    fitdisp = WIDGET_DRAW(fitdispbase, RETAIN=2, XSIZE=640, YSIZE=640)
    WIDGET_CONTROL, fitdispbase, /REALIZE
    WIDGET_CONTROL, fitdisp, GET_VALUE=thedrawnow

    fitdraw

    WSET, thedraw1
    plot,[0,xdim-1],[y,y],xrange=[0,xdim],yrange=[0,ydim2],xstyle=5,ystyle=5,$
        xmargin=[0,0],ymargin=[0,0],color=!d.table_size/2.,/noerase

  endelse

  jump1:
  ;;; Display coordinates information.
  x=(event.x>0)<(xdim-1)
  y=(event.y>0)<(ydim-1)
  xpix=(event.x>0)<(xdim-1)
  ypix=(event.y>0)<(ydim-1)
  coord1='('+string(xpix+1,format='(i4)')+','+string(ypix+1,format='(i4)')+')'
  coord2=''
  if (n_elements(specmap) gt 0) then begin
    if (total(specmap) ne 0.) then begin
      lambdanow=0.
      for k=0,recfit do lambdanow=lambdanow+specmap[k,ypix]*float(xpix)^k
      coord2='lambda = '+string(lambdanow,format='(f9.7)')
    endif
  endif
  coord=coord1+'   '+coord2
  WIDGET_CONTROL, coordtext, SET_VALUE = coord
END

"SLIDER1": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value1
  bytmin=ctable[long((nctable-1.)*value1/1000.)]
  drawlamp_2
END

"SLIDER2": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value2
  bytmax=ctable[long((nctable-1.)*(1.-value2/1000.))]
  drawlamp_2
END

"LOG": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = checklog
  drawlamp_2
END

"XLOADCT": BEGIN
  xloadct
END

;"EXIT": BEGIN
;  if (total(flagline) le recfit) then begin
;    message=DIALOG_MESSAGE('Not enough line fits.',DIALOG_PARENT=picklampbase)
;  endif else begin
;    WIDGET_CONTROL, event.top, /DESTROY
;  endelse
;END

;;; Change the order of polynomial fit to each arc lamp line.
"OBSFITORDER": BEGIN
  obsfit=fix(event.value)+1
  coeftemp=fltarr(obsfit+1,nline)
  coeftemp_1=fltarr(obsfit+1,nline)   ;;; Added by JRG
  flagfit=fltarr(nline)
  flagline=fltarr(nline)
  WIDGET_CONTROL, selnonexcl, SET_VALUE = flagline
  sprite=2
  drawlamp_2
  writeinfo_2
END

;;; Change the order of polynomial fit for the dispersion solution (lambda fit).
;"RECFITORDER": BEGIN
;  recfit=fix(event.value)+1
;END

"FITHEIGHT": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value1
  fitheight=value1
END

"FITWIDTH": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value1
  fitwidth=value1
END

"SEL_EXCL": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value1
  iline=value1
  sprite=2
  drawlamp_2
END

;;; Activate an arc lamp line that has been fit.
"SEL_NONEXCL": BEGIN
  WIDGET_CONTROL, event.id, GET_VALUE = value1
  flaglineold=flagline
  flagline=value1
  inowtemp=where(flagline ne flaglineold)
  inow=inowtemp[0]
  flaglineold=flagline
  if (flagfit[inow] eq 1) then begin
    iline=inow
    WIDGET_CONTROL, selexcl, SET_VALUE = iline
    sprite=2
    drawlamp_2
    writeinfo_2
  endif else begin
    message=DIALOG_MESSAGE(dialog_parent=picklampbase, $
			   'Fit the lamp line first.')
    value1[inow]=0
    flagline[inow]=0
    flaglineold=flagline
    WIDGET_CONTROL, selnonexcl, SET_VALUE = value1
    iline=inow
    WIDGET_CONTROL, selexcl, SET_VALUE = iline
    sprite=2
    drawlamp_2
  endelse
END

ELSE:

ENDCASE

END


;===============================================================================
PRO picklamp_2, picklampbase_1

;;; Prepare parameters and main widgets.

COMPILE_OPT idl2, hidden
COMMON picklampcom_2,thedraw1,npoint,pointx,pointy,flagfit,coeftemp,obsfit, $
       fitheight,fitwidth,nline,iline,flagline,flagflash,recfit,wavetemp, $
       sprite,spxa,spxb,spya,spyb,gaussxsave,infoheight,coordtext,display, $
       recfitorderbutton,etalontext,etaloncheck
COMMON picklampcom,thedraw1_1,npoint_1,pointx_1,pointy_1,flagfit_1, $
       coeftemp_1,obsfit_1,fitheight_1,fitwidth_1,nline_1,iline_1,flagline_1, $
       flagflash_1,recfit_1,wavetemp_1,sprite_1,spxa_1,spxb_1,spya_1,spyb_1, $
       gaussxsave_1,infoheight_1,coordtext_1,nlamp,fake,etalontext_1, $
       etaloncheck_1,abort_1,check_arcfit_1, $
       clip_sigmafactor_1, clip_trimfrac_1, clip_minfrac_1
COMMON bytimage2_2,image,bytmin,bytmax,xdim,ydim,ctable,nctable
COMMON slidercom2_2,slider1,slider2,checklog,selexcl,selnonexcl,picklampbase
COMMON rightcom_2,imagenow,pressed,xstart,ystart,xold,yold,xdimtemp,ydimtemp, $
       thedrawtemp,ydim2temp,imageorig
COMMON specetacom,n_eta,coef_eta,obsfit_eta

iline=0
flagfit=intarr(nline)
flagline=intarr(nline)
obsfit=1
recfit=recfit_1
fitheight=3
fitwidth=10
flagflash=0
sprite=0 & spxa=0 & spxb=0 & spya=0 & spyb=0
infoheight=15

loadct,39
pointx=fltarr(100) & pointy=fltarr(100) & npoint=0
coeftemp=fltarr(obsfit+1,nline)

checklog=0
imagesize=size(image)
xdim=imagesize[1] & ydim=imagesize[2]
if (imagesize[0] eq 1) then ydim=1
ydim2=ydim+infoheight
gaussxsave=fltarr(nline,ydim)

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
picklampbase = WIDGET_BASE(GROUP_LEADER=picklampbase_1, /FLOATING, $
			   TITLE = "SPECMAP - Arc 2", /COLUMN, YOFFSET=400)

msglabel = WIDGET_LABEL(picklampbase, /ALIGN_LEFT, YSIZE=30, $
    VALUE='Fit a polynomial to each lamp line.')

topbase =  WIDGET_BASE(picklampbase, /ROW)
;nobutton = WIDGET_BUTTON(topbase, VALUE=' Lambda Fit ', UVALUE='EXIT')

fitbase = WIDGET_BASE(picklampbase, /ROW)
obsfitorderbutton = CW_BGROUP(fitbase, ['1','2','3'], /ROW, /EXCLUSIVE, $
    LABEL_TOP='Line Fit Order', FRAME=3, SET_VALUE=obsfit-1, $
    UVALUE='OBSFITORDER', /NO_RELEASE)
fitlabel1 = WIDGET_LABEL(fitbase, VALUE=' ')
fitheightslider = WIDGET_SLIDER(fitbase, MINIMUM=1, MAXIMUM=11, FRAME=3, $
    TITLE='Fit Height', XSIZE=91, VALUE=fitheight, UVALUE='FITHEIGHT')
fitlabel2 = WIDGET_LABEL(fitbase, VALUE=' ')
fitwidthslider = WIDGET_SLIDER(fitbase, MINIMUM=5, MAXIMUM=50, FRAME=3, $
    TITLE='Fit Width', XSIZE=91, VALUE=fitwidth, UVALUE='FITWIDTH')
fitlabel3 = WIDGET_LABEL(fitbase, VALUE='          ')
;recfitorderbutton = CW_BGROUP(fitbase, ['1','2','3','4'], /ROW, /EXCLUSIVE, $
;    LABEL_TOP='Lambda Fit Order', FRAME=3, SET_VALUE=recfit-1, $
;    UVALUE='RECFITORDER', /NO_RELEASE)

sliderbase = WIDGET_BASE(picklampbase, /ROW)
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
spacetext = WIDGET_LABEL(picklampbase, VALUE='', XSIZE=xscr, YSIZE=10)
if (n_eta ge 2) then begin
  etaloncheck = CW_BGROUP(picklampbase, 'Include Etalon in Trial Lambda Fit', $
                          /NONEXCLUSIVE, SET_VALUE=1, UVALUE='ETALON', /COLUMN)
  etalontext = WIDGET_LABEL(picklampbase, VALUE='', XSIZE=xscr, YSIZE=20, $
                           /ALIGN_LEFT)
endif
coordtext = WIDGET_LABEL(picklampbase, VALUE='', XSIZE=xscr, YSIZE=20, $
                         /ALIGN_LEFT)

listexcl=strarr(nline+1)
listexcl[0:nline-1]=string(indgen(nline)+1,format='(i2)')+':  '+ $
    string(wavetemp,format='(f9.7)')
listexcl[nline]='Trial Lambda Fit'
listnonexcl=strarr(nline)+' '

extra=''
if (xdim gt xscr)  then extra = {X_SCROLL_SIZE:xscr, Y_SCROLL_SIZE:ydim2+2}
if (ydim2 gt yscr) then extra = {X_SCROLL_SIZE:xdim+2, Y_SCROLL_SIZE:yscr}
if (xdim gt xscr and ydim2 gt yscr) then extra = {X_SCROLL_SIZE:xscr, $
    Y_SCROLL_SIZE:yscr}
dispbase = WIDGET_BASE(picklampbase, /ROW)
display = WIDGET_DRAW(dispbase, RETAIN=2, $
                          XSIZE=xdim, YSIZE=ydim2, $
			  _Extra=extra, $
			  /BUTTON_EVENTS, /MOTION_EVENTS, UVALUE='BUTTON' )
selectbase = WIDGET_BASE(dispbase, /ROW)
selexcl = CW_BGROUP(selectbase, listexcl, /COLUMN, /EXCLUSIVE, $
    SET_VALUE=0, UVALUE='SEL_EXCL', /NO_RELEASE)
selnonexcl = CW_BGROUP(selectbase, listnonexcl, /COLUMN, /NONEXCLUSIVE, $
    SET_VALUE=flagline, UVALUE='SEL_NONEXCL')

ghostbase = WIDGET_BASE(picklampbase)
ghostdisp = WIDGET_DRAW(ghostbase, RETAIN=2, XSIZE=10, YSIZE=10)
WIDGET_CONTROL, ghostbase, MAP=0

WIDGET_CONTROL, picklampbase, /REALIZE
WIDGET_CONTROL, display, GET_VALUE = thedraw1

;;; Variables for right.pro
xdimtemp=xdim & ydimtemp=ydim & thedrawtemp=thedraw1 & ydim2temp=ydim+infoheight
imageorig=image

XManager, "picklamp_2", picklampbase, /NO_BLOCK

END

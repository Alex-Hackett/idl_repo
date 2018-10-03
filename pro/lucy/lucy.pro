; Blinkim -- Blink the original and resultant images.

pro Blinkim, event

COMMON imageblk,  result, res_hdr, result_true, fname, ORDER, RETAIN, $
		  RAW_WINDOW, PLOT_WINDOW, RESULT_WINDOW, deconstr, dampstr
COMMON display, z1, z2, z1Field, z2Field, autoscale, bdelay, biter, bcount
COMMON param2blk, chimin, speed, noise, adu, niter, B, imscale, $
		  damp, ndamp, threshold, nsigma, oxsize, oysize, $
		  chisq, piter
COMMON imstruct,  raw_image, rname, rxsize, rysize, raw_true, raw_hdr, $
		  psf, pname, pxsize, pysize, psf_true, $
		  model, mname, mxsize, mysize, model_true, $
		  mask, kname, kxsize, kysize, mask_true, $
		  weight, wname, wxsize, wysize, weight_true, $
		  background, bname, bxsize, bysize, background_true

   Widget_Control, event.top, Get_UValue = state

   if bcount ge 0 and bcount le biter-1 then begin
     ltv, raw_image, RESULT_WINDOW, imscale
     wait, bdelay
     ltv, result, RESULT_WINDOW, imscale
     Widget_Control, state.gbase, TIMER = bdelay
     bcount = bcount + 1
   endif else begin
     ltv, result, RESULT_WINDOW, imscale
   endelse
end


;LUCY_EVENT  -  LUCY event handler 
pro LUCY_EVENT, event

COMMON imageblk,  result, res_hdr, result_true, fname, ORDER, RETAIN, $
		  RAW_WINDOW, PLOT_WINDOW, RESULT_WINDOW, deconstr, dampstr
		  
COMMON chars,   log_unit

COMMON display, z1, z2, z1Field, z2Field, autoscale, bdelay, biter, bcount

COMMON param2blk, chimin, speed, noise, adu, niter, B, imscale, $
		  damp, ndamp, threshold, nsigma, oxsize, oysize , $
		  chisq, piter

COMMON imstruct,  raw_image, rname, rxsize, rysize, raw_true, raw_hdr, $
		  psf, pname, pxsize, pysize, psf_true, $
		  model, mname, mxsize, mysize, model_true, $
		  mask, kname, kxsize, kysize, mask_true, $
		  weight, wname, wxsize, wysize, weight_true, $
		  background, bname, bxsize, bysize, background_true

WIDGET_CONTROL, GET_UVALUE=state, event.top

 CASE event.id OF

   state.wload: BEGIN   ; load image(s)
       loadfile 
       if raw_true EQ 1 then begin
	  rtv, raw_image, RAW_WINDOW, imscale
	  setname, rname, dir, fname
	  Widget_Control, state.rlab, Set_Value='Original image: ' + fname
          Widget_Control, state.xsfield, Set_Value=rxsize
	  Widget_Control, state.ysfield, Set_Value=rysize
       endif
     END

   state.printwin: BEGIN  ;  print window 1
       wset, RESULT_WINDOW
       dim = tvrd (0,0,511,511)
       set_plot, 'PS', /COPY
       DEVICE, /LANDSCAPE, /COLOR, bits=8
       tvscl, dim
       siter = string(niter,format='(i6)') + ' iterations' 
       str = 'Richardson-Lucy ' + deconstr(speed) + rname + dampstr(damp) + $
	     ', ' + siter
       xyouts, 0.01, 1.05, str, /normal
       output_plot
       DEVICE,/CLOSE
       file ='idl.' + strlowcase(!D.NAME)
       cmd = 'lpr ' + file
       SPAWN, cmd
       SET_PLOT, 'X'
     END

   state.wsave: BEGIN  ; set up to save result image
       save_results
     END

   state.colorbutton: BEGIN
     XLOADCT, GROUP = event.top  ; activate color table selection
     END

   state.wlinear: BEGIN  ; linearly scale images 
       imscale = 0
       if raw_true EQ 1 then rtv, raw_image, RAW_WINDOW, imscale
       if result_true EQ 1 then ltv, result, RESULT_WINDOW, imscale
       END

   state.wlog10: BEGIN  ; scale images by log base 10, 
       imscale = 1
       if raw_true EQ 1 then rtv, raw_image, RAW_WINDOW, imscale
       if result_true EQ 1 then ltv, result, RESULT_WINDOW, imscale
       END

   state.plotminField: BEGIN   ; set minimum image scale
       Widget_Control, state.plotminField, Get_Value = temp
       z1 = temp
       autoscale = 0
       if raw_true EQ 1 then rtv, raw_image, RAW_WINDOW, imscale
       if result_true EQ 1 then ltv, result, RESULT_WINDOW, imscale
       end

   state.plotmaxField: BEGIN   ; set maximum image scale
       Widget_Control, state.plotmaxField, Get_Value = temp
       z2 = temp
       autoscale = 0
       if raw_true EQ 1 then rtv, raw_image, RAW_WINDOW, imscale
       if result_true EQ 1 then ltv, result, RESULT_WINDOW, imscale
       end

   state.bstartbutton: BEGIN   ; start blinking
       Widget_Control, state.biterField, Get_Value = biter
       Widget_Control, state.bdelayField, Get_Value = bdelay
       if raw_true eq 1 and result_true eq 1 and biter gt 0 then begin
	 bcount = 0
         Widget_Control, state.gbase, TIMER = bdelay
       endif
       end

   state.bstopbutton: BEGIN    ; stop blinking
	bcount = -1
	biter = -1
	if result_true EQ 1 then ltv, result, RESULT_WINDOW, imscale
       end

   state.bdelayField: Begin    ; get blinking delay value
       Widget_Control, state.bdelayField, Get_Value = temp
       bdelay = temp
       end

   state.biterField: Begin     ; get number of blink iterations
       Widget_Control, state.biterField, Get_Value = temp
       biter = temp
       end

   state.richlucy: BEGIN  ; deconvolve using original Richardson-Lucy algorithm
       speed = 0 
       if (raw_true + psf_true EQ 2) then begin 
	str = deconstr(speed) + dampstr(damp) 
	WIDGET_CONTROL, state.rslab, SET_VALUE=str
	printf, log_unit, str
        WIDGET_CONTROL, state.noisefield, GET_VALUE = noise
        WIDGET_CONTROL, state.adufield, GET_VALUE = adu
        WIDGET_CONTROL, state.iterfield, GET_VALUE = niter
        WIDGET_CONTROL, state.chifield, GET_VALUE = chimin
        WIDGET_CONTROL, state.xsfield, GET_VALUE = oxsize
        WIDGET_CONTROL, state.ysfield, GET_VALUE = oysize
	msglab = state.chi2lab
	result=wlucy(RESULT_WINDOW, PLOT_WINDOW, msglab) 
	result_true=1
       endif else WIDGET_CONTROL, state.chi2lab, SET_VALUE = $
	     'Error, incomplete data' 
       END

   state.hooklucy: BEGIN  ; deconvolve using Hook-Lucy acceleration algorithm
       speed = 1 
       if (raw_true + psf_true EQ 2) then begin 
	str = deconstr(speed) + dampstr(damp) 
	WIDGET_CONTROL, state.rslab, SET_VALUE=str
	printf, log_unit, str
        WIDGET_CONTROL, state.noisefield, GET_VALUE = noise
        WIDGET_CONTROL, state.adufield, GET_VALUE = adu
        WIDGET_CONTROL, state.iterfield, GET_VALUE = niter
        WIDGET_CONTROL, state.chifield, GET_VALUE = chimin
        WIDGET_CONTROL, state.xsfield, GET_VALUE = oxsize
        WIDGET_CONTROL, state.ysfield, GET_VALUE = oysize
	msglab = state.chi2lab
	result=wlucy(RESULT_WINDOW, PLOT_WINDOW, msglab) 
	result_true = 1
       endif else WIDGET_CONTROL, state.chi2lab, SET_VALUE = $
	     'Error, incomplete data' 
       END

   state.turbolucy: BEGIN   ; deconvolve using Rick White's turbo acceleration
       speed = 2
       if (raw_true + psf_true EQ 2) then begin 
	str = deconstr(speed) + dampstr(damp)
	WIDGET_CONTROL, state.rslab, SET_VALUE=str
	printf, log_unit, str
        WIDGET_CONTROL, state.noisefield, GET_VALUE = noise
        WIDGET_CONTROL, state.adufield, GET_VALUE = adu
        WIDGET_CONTROL, state.iterfield, GET_VALUE = niter
        WIDGET_CONTROL, state.chifield, GET_VALUE = chimin
        WIDGET_CONTROL, state.xsfield, GET_VALUE = oxsize
        WIDGET_CONTROL, state.ysfield, GET_VALUE = oysize
	msglab = state.chi2lab
	result=wlucy(RESULT_WINDOW, PLOT_WINDOW, msglab) 
	result_true = 1
       endif else WIDGET_CONTROL, state.chi2lab, SET_VALUE = $
	     'Error, incomplete data' 
       END

   state.contubutton:  BEGIN     ; continue deconvolution using previous result 
		      ; as 1st guess
       if (n_elements(result) GT 0) then begin
          model = result
	  rsz = size(result)
          mxsize = rsz(1) 
          mysize = rsz(2)
          model_true = 1
          WIDGET_CONTROL, state.iterfield, GET_VALUE = niter
	  msglab = state.chi2lab
          if (raw_true + psf_true EQ 2) $
	    then result=wlucy(RESULT_WINDOW, PLOT_WINDOW, msglab) $ 
	    else WIDGET_CONTROL, state.chi2lab, $
	       SET_VALUE='Error, incomplete data'
          endif
       END

    state.dampbutton: BEGIN
      WIDGET_CONTROL, state.dampbutton, GET_VALUE=dmp
      if (dmp[0] EQ 0) then begin
	damp = 0
	ndamp = 0
	threshold = 0
      endif else begin
	damp = 1
	ndamp = 10
	threshold = 9
      endelse
      END

   state.noisefield: BEGIN
       WIDGET_CONTROL, state.noisefield, GET_VALUE = noise
       END

   state.adufield: BEGIN
       WIDGET_CONTROL, state.adufield, GET_VALUE = adu
       END

   state.chifield: BEGIN
       WIDGET_CONTROL, state.chifield, GET_VALUE = chimin
       END

   state.iterfield: BEGIN
       WIDGET_CONTROL, state.iterfield, GET_VALUE = niter
       END

   state.xsfield: BEGIN
       WIDGET_CONTROL, state.xsfield, GET_VALUE = oxsize
       END

   state.ysfield: BEGIN
       WIDGET_CONTROL, state.ysfield, GET_VALUE = oysize
       END

   state.helpbutton: BEGIN
	XDISPLAYFILE, GROUP=event.top, TITLE='LUCY Help', $
	   WIDTH=80, HEIGHT=20, 'lucy.hlp'
	  END

   state.donebutton:  BEGIN
	  CLOSE, log_unit
	  FREE_LUN, log_unit
	  WIDGET_CONTROL, event.top, /DESTROY
	  RETURN
	  END

   state.wquit: BEGIN
	  CLOSE, log_unit
	  FREE_LUN, log_unit
	  WIDGET_CONTROL, event.top, /DESTROY
	  RETURN
	  END

   ELSE:  test = WIDGET_MESSAGE('An event occurred for a non-existent widget')

   ENDCASE

 ; Reset the windows user value to the update state structure
  WIDGET_CONTROL, SET_UVALUE = state, event.top

END

pro lucy 

COMMON imageblk,  result, res_hdr, result_true, fname, ORDER, RETAIN, $
		  RAW_WINDOW, PLOT_WINDOW, RESULT_WINDOW, deconstr, dampstr

COMMON chars,   log_unit

COMMON display, z1, z2, z1Field, z2Field, autoscale, bdelay, biter, bcount
		  
COMMON param2blk, chimin, speed, noise, adu, niter, B, imscale, $
		  damp, ndamp, threshold, nsigma, oxsize, oysize, $
		  chidq, piter

COMMON imstruct,  raw_image, rname, rxsize, rysize, raw_true, raw_hdr, $
		  psf, pname, pxsize, pysize, psf_true, $
		  model, mname, mxsize, mysize, model_true, $
		  mask, kname, kxsize, kysize, mask_true, $
		  weight, wname, wxsize, wysize, weight_true, $
		  background, bname, bxsize, bysize, background_true

@VERSION.lucy

      ; initialize window parameters
      rawxwin = 256
      rawywin = 256
      rname = ' '
      rxsize = 0
      rysize = 0
      pxsize = 0
      pysize = 0
      pname = ' '
      mxsize = 0
      mysize = 0
      mname = ' '
      kxsize = 0
      kysize = 0
      kname = ' '
      wxsize = 0
      wysize = 0
      wname = ' '
      bxsize = 0
      bysize = 0
      bname = ' '
      oxsize = 0
      oysize = 0
      resxwin = 512
      resywin = 512
      damp = 0
      ndamp = 0
      threshold = 0
      nsigma = 5 
      B = 1
      noise = 0.0
      adu = 1.0
      chimin = 1.0d0
      chisq = 0.0d0
      niter = 25
      piter = 0
      imscale = 1 
      raw_true = 0
      psf_true = 0
      model_true = 0
      mask_true = 0
      weight_true = 0
      background_true = 0
      result_true = 0
      z1 = 0.
      z2 = 0.
      autoscale = 1
      biter = 0
      bdelay = 1.0

      ORDER = 0
      RETAIN = 2
      deconstr = strarr(3)
      deconstr(0) = 'Deconvolution (No Acceleration) '
      deconstr(1) = 'Deconvolution (Standard Acceleration) '
      deconstr(2) = 'Deconvolution (Turbo Acceleration) '
      dampstr = strarr(2)
      dampstr(0) = ' '
      dampstr(1) = ' with damping '
  
      openw, log_unit, 'lucy.log', /GET_LUN 
      printf, log_unit, 'Richardson-Lucy Deconvolution' 

      ltitle = 'Richardson-Lucy Deconvolution, Version ' + UAVersion
      lucybase = WIDGET_BASE(TITLE=ltitle, Mbar=menubar, /COLUMN) 
     
      filemenu = WIDGET_BUTTON(menubar, VALUE='FILE', /menu)
      scalemenu = WIDGET_BUTTON(menubar, VALUE='SCALE', /menu)
      colormenu = WIDGET_BUTTON(menubar, VALUE = 'Color')
      deconvmenu = WIDGET_BUTTON(menubar, VALUE='DECONVOLVE', /menu)
      contumenu = WIDGET_BUTTON(menubar, VALUE='Continue', /menu)
      helpmenu = WIDGET_BUTTON(menubar, VALUE='Help', /menu)
      donemenu = WIDGET_BUTTON(menubar, VALUE='Done', /menu)

      wload = WIDGET_BUTTON(filemenu, VALUE='Load Images')
      printwin = WIDGET_BUTTON(filemenu, VALUE='Print Result')
      wsave = WIDGET_BUTTON(filemenu, VALUE='Save Result')
      wquit = WIDGET_BUTTON(filemenu, VALUE='Done')
      
      colorbutton = WIDGET_BUTTON(colormenu, VALUE = 'Color')

      wlinear = WIDGET_BUTTON(scalemenu, VALUE='Linear')
      wlog10 = WIDGET_BUTTON(scalemenu, VALUE='Log Base 10')

      richlucy = WIDGET_BUTTON(deconvmenu, VALUE='Original')
      hooklucy = WIDGET_BUTTON(deconvmenu, VALUE='Standard Acceleration')
      turbolucy = WIDGET_BUTTON(deconvmenu, VALUE='Turbo Acceleration')

      contubutton = WIDGET_BUTTON(contumenu, VALUE='Continue')
      helpbutton = WIDGET_BUTTON(helpmenu, VALUE='Help')
      donebutton = WIDGET_BUTTON(donemenu, VALUE='Done')

; set up raw image widget

     ibase = WIDGET_BASE(lucybase, /ROW, XPAD=1, YPAD=1, /FRAME)
     fbase = WIDGET_BASE(ibase, /COLUMN)
     gbase = Widget_Base(lucybase, Event_Pro = 'Blinkim')
     rlab = WIDGET_LABEL(fbase, $
            VALUE='Raw Image                                 ')
     rawwin = widget_draw(fbase,retain=retain,xsize=rawxwin, ysize=rawywin) 

  ; lucy control parameter block
	pbase1 =   WIDGET_BASE(fbase, /ROW)
	noisefield = cw_field(pbase1, value=noise, title='Read Noise(e)', $
		   uvalue='noise', xsize=7, /RETURN_EVENTS, /FLOATING)
	adufield = cw_field(pbase1, value=adu, title='e/DN', $
		   uvalue='adu', xsize=7, /RETURN_EVENTS, /FLOATING)
        pbase2 =  WIDGET_BASE (fbase, /ROW)
	iterfield = cw_field(pbase2, value=niter, title='Iterations', $
		   uvalue='iter', xsize=4, /RETURN_EVENTS, /INTEGER)
	chifield = cw_field(pbase2, value=chimin, title='Limit Chi-Sq', $
		   uvalue='chi', xsize=6, /RETURN_EVENTS, /FLOATING)
        pbase3 =  WIDGET_BASE(fbase, /ROW)
	xsfield = cw_field(pbase3, value=oxsize, title='Output Image Size: X', $
		   uvalue='xs', xsize=4, /RETURN_EVENTS, /INTEGER)
	ysfield = cw_field(pbase3, value=oysize, title='Y', $
		   uvalue='ys', xsize=4, /RETURN_EVENTS, /INTEGER)
        pbase4 =  WIDGET_BASE(fbase, /ROW)
        dampbutton = cw_bgroup(pbase4, ['NO Damping', 'Damping'], row=1, $
		     set=0, /exclusive, /no_release)

  ; set up plot widget for viewing Chi-Squared
      
      plotchi = widget_draw(fbase,retain=retain,xsize=250, ysize=200)
      plab =    WIDGET_LABEL(fbase, VALUE='Chi-Squared Plot')

  ; set up widget for viewing result

      jbase = WIDGET_BASE(ibase, /COLUMN)
      rslab = WIDGET_LABEL(jbase, $
	VALUE='Results                                                 ')
      resultwin = widget_draw(jbase, retain=retain, xsize=resxwin, $
	 ysize=resywin)
      chi2lab = WIDGET_LABEL(jbase, Value = $
      '                                                                       ')
      zBase = Widget_Base(jbase, /Row)
      plotminField = cw_field(zBase,value=z1,title='plot min:', $
		   uvalue='plotmin', xsize=14, /Return_Events, /Floating)
      plotmaxField = cw_field(zBase,value=z2,title='plotmax:', $
		   uvalue='plotmax', xsize=14, /Return_Events, /Floating)
      z1Base = Widget_Base(jbase, /Row)
      zlabel = Widget_Label(z1Base, Value = 'Blink:')
      biterfield = cw_field(z1Base, value=biter, title='Number Iterations', $
		   uvalue='biter', xsize=4, /RETURN_EVENTS, /INTEGER)
      bdelayfield = cw_field(z1Base, value=bdelay, title='Delay', $
		   uvalue='bdelay', xsize=4, /RETURN_EVENTS, /Floating)
      bstartButton = Widget_Button(z1Base, Value = 'Start')
      bstopButton = Widget_Button(z1Base, Value = 'Stop')

   ; define state block
      state = { $
		lucybase     :   lucybase,      $
		gbase        :   gbase,         $
		filemenu     :   filemenu,      $
		wload        :   wload,         $
		printwin     :   printwin,      $
		wsave        :   wsave,         $
		wquit        :   wquit,         $
		scalemenu    :   scalemenu,     $
		wlinear      :   wlinear,       $
		wlog10       :   wlog10,        $
		colormenu    :   colormenu,     $
		colorbutton  :   colorbutton,   $
		deconvmenu   :   deconvmenu,    $
		richlucy     :   richlucy,      $
		hooklucy     :   hooklucy,      $
		turbolucy    :   turbolucy,     $
		contumenu    :   contumenu,     $
		contubutton  :   contubutton,   $
		helpmenu     :   helpmenu,      $
		helpbutton   :   helpbutton,    $
		donemenu     :   donemenu,      $
		donebutton   :   donebutton,    $
		bstartbutton :   bstartbutton,  $
		bstopbutton  :   bstopbutton,   $
		ibase        :   ibase,         $
		fbase        :   fbase,         $
		rlab         :   rlab,          $
		rawwin       :   rawwin,        $
		pbase1       :   pbase1,        $
		noisefield   :   noisefield,    $
		adufield     :   adufield,      $
		pbase2       :   pbase2,        $
		iterfield    :   iterfield,     $
		chifield     :   chifield,      $
		pbase3       :   pbase3,        $
		xsfield      :   xsfield,       $
		ysfield      :   ysfield,       $
		pbase4       :   pbase4,        $
		dampbutton   :   dampbutton,    $
		plotchi      :   plotchi,       $
		plab         :   plab,          $
		jbase        :   jbase,         $
		rslab        :   rslab,         $
		resultwin    :   resultwin,     $
		chi2lab      :   chi2lab,       $
		plotminField :   plotminField,  $
		plotmaxField :   plotmaxField,  $
		biterField   :   biterField,    $
		bdelayField  :   bdelayField    $
						 }

      WIDGET_CONTROL, lucybase, /REALIZE

      z1Field = state.plotminField
      z2Field = state.plotmaxField

  ; get values of all widget windows

      WIDGET_CONTROL, get_value = RAW_WINDOW, rawwin 
      WIDGET_CONTROL, get_value = PLOT_WINDOW, plotchi
      WIDGET_CONTROL, get_value = RESULT_WINDOW, resultwin

      WIDGET_CONTROL, lucybase, SET_UVALUE=state

      XMANAGER, 'LUCY', lucybase, event_handler='LUCY_EVENT', /No_Block, $
       GROUP_LEADER = MAIN_GROUP

end

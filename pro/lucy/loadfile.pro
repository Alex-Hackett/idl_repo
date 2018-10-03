; procedure loadfile_ev 
; This procedure processes the events being sent by the XManager. 

PRO loadfile_ev, event 
 
COMMON lucypicker, here, thefile, separator, dirsave, $
       rawfile, psfile, modelfile, maskfile, wgtfile, bkgfile, $
       raw_cvt, mextn, mval

COMMON imstruct,  raw_image, rname, rxsize, rysize, raw_true, raw_hdr, $
		  psf, pname, pxsize, pysize, psf_true, $
		  model, mname, mxsize, mysize, model_true, $
		  mask, kname, kxsize, kysize, mask_true, $
		  weight, wname, wxsize, wysize, weight_true, $
		  background, bname, bxsize, bysize, background_true

COMMON chars,   log_unit

WIDGET_CONTROL, GET_UVALUE = state, event.top

CASE event.id OF 

  state.done:  begin
      CD, dirsave
      WIDGET_CONTROL, event.top, /DESTROY
      RETURN
      END
 
  state.rawtxt: BEGIN
      raw_true = 0
      WIDGET_CONTROL, state.rawtxt, GET_VALUE = temp
      rawfile = temp[0]
      if strlen(rawfile) gt 0 then begin
	res = findfile(rawfile, Count = fcount)
	if fcount gt 0 then begin
          ua_fits_read, rawfile, image, header
          sz = size(image)
          if sz[0] ne 2 then begin
	    str = rawfile + '  Image must be 2-Dimensional'
            Widget_Control, elab, Value = str
          endif else begin
            if raw_cvt EQ 0 then begin
	      exptime = sxpar(header, 'EXPTIME')
	      if exptime GT 0.0 then begin
	        image = image * exptime
	        print, 'Scaling image by exposure time, ', exptime
              endif else begin
	        print, 'No exposure time in header, cannot convert to counts'
              endelse
            endif else begin
	      units = sxpar(header, 'BUNIT')
	      usz = size(units)
	      if (usz(usz(0)+1) EQ 7) then begin
		if (units NE 'COUNTS') then begin
		  str = 'Image units are counts per second, ' + $
		    'Must convert to counts'
                  print, str
		  Widget_Control, elab, Value = str
                endif
              endif
            endelse
            raw_image = image
            raw_hdr = header
            raw_true = 1
            rname = rawfile
            rxsize=sz(1)
            rysize=sz(2)
          endelse
        endif else begin
	  print, 'File: ', rawfile, ' not found!'
        endelse
      endif else begin
	print, 'No Raw file given!'
      endelse
      END

  state.psftxt: BEGIN
      psf_true = 0
      Widget_Control, state.psftxt, Get_Value = temp
      psfile = temp[0]
      if strlen(psfile) gt 0 then begin
	res = findfile(psfile, Count = fcount)
	if fcount gt 0 then begin
          ua_fits_read, psfile, image, header
          sz = size(image)
          if sz[0] NE 2 then begin
	    str = psfile + '  Image must be 2-Dimensional'
            WIDGET_CONTROL, elab, VALUE = str
          endif else begin
            psf = image
            psf_true = 1
            pname = psfile
            pxsize = sz[1]
            pysize = sz[2]
          endelse
        endif else begin
	  print, 'File: ', psfile, ' not found!'
        endelse
      endif else begin
	print, 'No PSF file given!'
      endelse
      END

  state.modeltxt: BEGIN
      model_true = 0
      Widget_Control, state.modeltxt, Get_Value = temp
      modelfile = temp[0]
      if strlen(modelfile) gt 0 then begin
	res = findfile(modelfile, Count = fcount)
	if fcount gt 0 then begin
          ua_fits_read, modelfile, image, header
          sz = size(image)
          if sz[0] NE 2 then begin
	    str = modelfile + '  Image must be 2-Dimensional'
            Widget_Control, elab, Value = str
          endif else begin
            model = image
            model_true = 1
            mname = modelfile
            mxsize = sz(1)
            mysize = sz(2)
          endelse
        endif else begin
	  print, 'File: ', modelfile, ' not found!'
        endelse
      endif else begin
	print, 'No Model file given!'
      endelse
      END

  state.masktxt: BEGIN
      mask_true = 0
      Widget_Control, state.masktxt, Get_Value = temp 
      maskfile = temp[0]
      Widget_Control, state.efield, Get_Value = temp
      mextn = temp[0]
      Widget_Control, state.maskfield, Get_Value = mval
      if strlen(maskfile) gt 0 then begin
	res = findfile(maskfile, Count = fcount)
	if fcount gt 0 then begin
	  if (mextn NE '' AND mextn NE 'NONE') then begin
	    print, 'Reading extension ', mextn, ' from ', maskfile
	    ua_fits_read, maskfile, image, header, extname=mextn, extver=1
          endif else begin
            ua_fits_read, maskfile, image, header
          endelse
          sz = size(image)
          if sz[0] NE 2 then begin
	    str = maskfile + '  Image must be 2-Dimensional'
            Widget_Control, elab, Value = str
          endif else begin
	    mask = intarr(sz[1],sz[2])
	    mask[*,*] = 0
	    good = where(image EQ mval, count)
            if count gt 0 then begin
	      mask[good] = 1
	      print, 'Good pixels: ', count
              mask_true = 1
	      kname = maskfile
	      kxsize = sz[1]
	      kysize = sz[2]
            endif else begin
	      print, 'No good pixels in mask!'
            endelse
          endelse
        endif else begin
	  print, 'File: ', maskfile, ' not found!'
        endelse
      endif else begin
	print, 'No Mask file given!'
      endelse
      END

  state.wgttxt: BEGIN
      weight_true = 0
      Widget_Control, state.wgttxt, Get_Value = temp
      wgtfile = temp[0]
      if strlen(wgtfile) gt 0 then begin
	res = findfile(wgtfile, Count = fcount)
	if fcount gt 0 then begin
          ua_fits_read, wgtfile, image, header
          sz = size(image)
          if sz[0] ne 2 then begin
	    str = wgtfile + '  Image must be 2-Dimensional'
            Widget_Control, elab, Value = str
          endif else begin
            weight = image
            weight_true = 1
            wname = wgtfile
            wxsize = sz[1]
            wysize = sz[2]
          endelse
        endif else begin
	  print, 'File: ', wgtfile, ' not found!'
        endelse
      endif else begin
	print, 'No Weight file given!'
      endelse
      END

  state.bkgtxt: BEGIN
      background_true = 0
      Widget_Control, state.bkgtxt, Get_Value = temp
      bkgfile = temp[0]
      if strlen(bkgfile) gt 0 then begin
	res = findfile(bkgfile, Count = fcount)
	if fcount gt 0 then begin
          ua_fits_read, bkgfile, image, header
          sz = size(image)
          if sz[0] ne 2 then begin
	    str = bkgfile + '  Image must be 2-Dimensional'
            Widget_Control, elab, VALUE = str
          endif else begin
            background = image
            background_true = 1
            bname = bkgfile
            bxsize = sz[1]
            bysize = sz[2]
          endelse
        endif else begin
	  print, 'File: ', bkgfile, ' not found!'
        endelse
      endif else begin
	print, 'No Background file given!'
      endelse
      END

  state.loadraw: BEGIN
      raw_true = 0
      rawfile = Dialog_Pickfile(/Read, /Must_Exist, Get_Path=outpath, $
		Path=here, Title='Please Select Raw File')
      here = outpath
      dirsave = outpath
      Widget_Control, state.rawtxt, Set_Value= rawfile
      if strlen(rawfile) gt 0 then begin
	res = findfile(rawfile, Count = fcount)
	if fcount gt 0 then begin
          ua_fits_read, rawfile, image, header
          sz = size(image)
          if sz[0] ne 2 then begin
	    str = rawfile + '  Image must be 2-Dimensional'
            Widget_Control, elab, Value = str
          endif else begin
            if raw_cvt EQ 0 then begin
	      exptime = sxpar(header, 'EXPTIME')
	      if exptime GT 0.0 then begin
	        image = image * exptime
	        print, 'Scaling image by exposure time, ', exptime
              endif else begin
	        print, 'No exposure time in header, cannot convert to counts'
              endelse
            endif else begin
	      units = sxpar(header, 'BUNIT')
	      usz = size(units)
	      if (usz(usz(0)+1) EQ 7) then begin
		if (units NE 'COUNTS') then begin
		  str = 'Image units are counts per second, ' + $
		    'Must convert to counts'
                  print, str
		  Widget_Control, elab, Value = str
                endif
              endif
            endelse
            raw_image = image
            raw_hdr = header
            raw_true = 1
            rname = rawfile
            rxsize=sz(1)
            rysize=sz(2)
          endelse
        endif else begin
	  print, 'File: ', rawfile, ' not found!'
        endelse
      endif else begin
	print, 'No Raw file given!'
      endelse
  END
  
  state.loadpsf: BEGIN
      psf_true = 0
      psfile = Dialog_Pickfile(/Read, /Must_Exist, Get_Path=outpath, $
	  Path=here, Title='Please Select PSF File')
      here = outpath
      dirsave = outpath
      Widget_Control, state.psftxt, Set_Value = psfile
      if strlen(psfile) gt 0 then begin
	res = findfile(psfile, Count = fcount)
	if fcount gt 0 then begin
          ua_fits_read, psfile, image, header
          sz = size(image)
          if sz[0] NE 2 then begin
	    str = psfile + '  Image must be 2-Dimensional'
            WIDGET_CONTROL, elab, VALUE = str
          endif else begin
            psf = image
            psf_true = 1
            pname = psfile
            pxsize = sz[1]
            pysize = sz[2]
          endelse
        endif else begin
	  print, 'File: ', psfile, ' not found!'
        endelse
      endif else begin
	print, 'No PSF file given!'
      endelse
  END

  state.loadmodel: BEGIN
      model_true = 0
      modelfile = Dialog_Pickfile(/Read, /Must_Exist, Get_Path=outpath, $
         Path=here, Title='Please Select Model File')
      here = outpath
      dirsave = outpath
      Widget_Control, state.modeltxt, Set_Value = modelfile
      if strlen(modelfile) gt 0 then begin
	res = findfile(modelfile, Count = fcount)
	if fcount gt 0 then begin
          ua_fits_read, modelfile, image, header
          sz = size(image)
          if sz[0] NE 2 then begin
	    str = modelfile + '  Image must be 2-Dimensional'
            Widget_Control, elab, Value = str
          endif else begin
            model = image
            model_true = 1
            mname = modelfile
            mxsize = sz(1)
            mysize = sz(2)
          endelse
        endif else begin
	  print, 'File: ', modelfile, ' not found!'
        endelse
      endif else begin
	print, 'No Model file given!'
      endelse
  END

  state.loadmask: BEGIN
      mask_true = 0
      maskfile = Dialog_Pickfile(/Read, /Must_Exist, Get_Path=outpath, $
         Path=here, Title='Please Select Mask File')
      here = outpath
      dirsave = outpath
      Widget_Control, state.masktxt, Set_Value = maskfile
      Widget_Control, state.efield, Get_Value = temp
      mextn = temp[0]
      Widget_Control, state.maskfield, Get_Value = mval
      if strlen(maskfile) gt 0 then begin
	res = findfile(maskfile, Count = fcount)
	if fcount gt 0 then begin
	  if (mextn NE '' AND mextn NE 'NONE') then begin
	    print, 'Reading extension ', mextn, ' from ', maskfile
	    ua_fits_read, maskfile, image, header, extname=mextn, extver=1
          endif else begin
            ua_fits_read, maskfile, image, header
          endelse
          sz = size(image)
          if sz[0] NE 2 then begin
	    str = maskfile + '  Image must be 2-Dimensional'
            Widget_Control, elab, Value = str
          endif else begin
	    mask = intarr(sz[1],sz[2])
	    mask[*,*] = 0
	    good = where(image EQ mval, count)
            if count gt 0 then begin
	      mask[good] = 1
	      print, 'Good pixels: ', count
              mask_true = 1
	      kname = maskfile
	      kxsize = sz[1]
	      kysize = sz[2]
            endif else begin
	      print, 'No good pixels in mask!'
            endelse
          endelse
        endif else begin
	  print, 'File: ', maskfile, ' not found!'
        endelse
      endif else begin
	print, 'No Mask file given!'
      endelse
  END

  state.loadwgt: BEGIN
      weight_true = 0
      wgtfile = Dialog_Pickfile(/Read, /Must_Exist, Get_Path=outpath, $
         Path=here, Title='Please Select Weight File')
      here = outpath
      dirsave = outpath
      Widget_Control, state.wgttxt, Set_Value = wgtfile
      if strlen(wgtfile) gt 0 then begin
	res = findfile(wgtfile, Count = fcount)
	if fcount gt 0 then begin
          ua_fits_read, wgtfile, image, header
          sz = size(image)
          if sz[0] ne 2 then begin
	    str = wgtfile + '  Image must be 2-Dimensional'
            Widget_Control, elab, Value = str
          endif else begin
            weight = image
            weight_true = 1
            wname = wgtfile
            wxsize = sz[1]
            wysize = sz[2]
          endelse
        endif else begin
	  print, 'File: ', wgtfile, ' not found!'
        endelse
      endif else begin
	print, 'No Weight file given!'
      endelse
  END

  state.loadbkg: BEGIN
      background_true = 0
      bkgfile = Dialog_Pickfile(/Read, /Must_Exist, Get_Path=outpath, $
         Path=here, Title='Please Select Background File')
      here = outpath
      dirsave = outpath
      Widget_Control, state.bkgtxt, Set_Value = bkgfile
      if strlen(bkgfile) gt 0 then begin
	res = findfile(bkgfile, Count = fcount)
	if fcount gt 0 then begin
          ua_fits_read, bkgfile, image, header
          sz = size(image)
          if sz[0] ne 2 then begin
	    str = bkgfile + '  Image must be 2-Dimensional'
            Widget_Control, elab, VALUE = str
          endif else begin
            background = image
            background_true = 1
            bname = bkgfile
            bxsize = sz[1]
            bysize = sz[2]
          endelse
        endif else begin
	  print, 'File: ', bkgfile, ' not found!'
        endelse
      endif else begin
	print, 'No Background file given!'
      endelse
  END

  state.rcvbutton: BEGIN
    Widget_Control, state.rcvbutton, Get_Value = tmp
    if (tmp[0] EQ 0) then raw_cvt = 0 else raw_cvt = 1
  END

  state.efield: BEGIN
    Widget_Control, state.efield, Get_Value = tmp
    if (strlen(tmp[0]) GT 0) then mextn = tmp[0] else mextn = ""
  END

  state.maskfield: BEGIN
    Widget_Control, state.maskfield, Get_Value = mval
  END
 
  ELSE: test = Widget_Message('An event occurred for a non-existent widget')

ENDCASE 

; Reset the windows user value to the update state structure
 Widget_Control, Set_UValue = state, event.top

END

;  procedure loadfile 
;  This is the actual routine that creates the widget and registers it with the 
;  Xmanager.  It also determines the operating system and sets the specific 
;  file designators for that operating system. 

pro loadfile
 
COMMON lucypicker, here, thefile, separator, dirsave, $
       rawfile, psfile, modelfile, maskfile, wgtfile, bkgfile, $
       raw_cvt, mextn, mval

COMMON imstruct,  raw_image, rname, rxsize, rysize, raw_true, raw_hdr, $
		  psf, pname, pxsize, pysize, psf_true, $
		  model, mname, mxsize, mysize, model_true, $
		  mask, kname, kxsize, kysize, mask_true, $
		  weight, wname, wxsize, wysize, weight_true, $
		  background, bname, bxsize, bysize, background_true

COMMON chars, log_unit

IF(XRegistered("loadfile")) THEN BEGIN
  Return 
ENDIF  
 
rawfile = ""
psfile = ""
modelfile = ""
maskfile = ""
wgtfile = ""
bkgfile = ""
mextn = "NONE"
mval = 0
raw_cvt = 0
raw_true = 0
psf_true = 0
model_true = 0
mask_true = 0
weight_true = 0
background_true = 0
 
Case !VERSION.OS of 
'vms':      separator = '' 
'windows':  separator = '' 
'MacOS':    separator = ':' 
else:       separator = '/' 
endcase 
 
  CD, CURRENT =  current
  dirsave = current
  here = dirsave + separator
  Title = 'Load files for lucy deconvolution'
 
     loadbase     =  WIDGET_BASE(TITLE = Title, /COLUMN) 
     wbase =         WIDGET_BASE(loadbase, /ROW)
     done =          WIDGET_BUTTON(wbase, VALUE = ' Done ')
     elab =          WIDGET_LABEL(loadbase,$
      VALUE='                                                             ')
     rlabel =        WIDGET_LABEL(loadbase, VALUE = "Required Images:")
     w1base =        WIDGET_BASE(loadbase, /ROW)
     xlabel =        Widget_Label(w1base, Value=$
       'Verify Data UNITS BEFORE selecting Raw Image!')
     rcvbutton =     CW_BGROUP(w1base, ['Counts/sec', 'Counts'], row=1, $
			set=0, /exclusive, /no_release)
     w2base =        Widget_Base(loadbase, /ROW)
     rlabel =        Widget_Label(w2base, Value = ' Raw Image:')
     loadraw =       WIDGET_BUTTON(w2base, VALUE = 'Browse')
     rawtxt =        WIDGET_TEXT(w2base, VALUE=rawfile, $
                        XS = 60, FRAME = osfrm, /EDIT) 
     w3base =        WIDGET_BASE(loadbase, /ROW)
     plabel =        Widget_Label(w3base, Value = '    PSF:   ')
     loadpsf =       WIDGET_BUTTON(w3base, VALUE = 'Browse')
     psftxt  =       WIDGET_TEXT(w3base, VALUE=psfile, $
			XS = 60, FRAME= osfrm, /EDIT)
     olabel =        WIDGET_LABEL(loadbase, VALUE = "Optional Images:")
     w4base =        WIDGET_BASE(loadbase, /ROW)
     mlabel =        Widget_Label(w4base, Value = '   Model:  ')
     loadmodel =     WIDGET_BUTTON(w4base, VALUE = 'Browse')
     modeltxt =      WIDGET_TEXT(w4base, VALUE=modelfile, $
                        XS = 60, FRAME = osfrm, /EDIT) 
     w6base =        WIDGET_BASE(loadbase, /ROW)
     wlabel =        Widget_Label(w6base, Value='Set BEFORE selecting Mask!')
     efield =        CW_FIELD(w6base, VALUE=mextn, TITLE = $
			'Mask Extname:', uvalue='mg', xsize=6, $
			/RETURN_EVENTS, /STRING)
     maskfield =     CW_FIELD(w6base, VALUE=mval, TITLE = $
			'Mask Good Value:', uvalue='mg', xsize=4, $
			/RETURN_EVENTS, /INTEGER)
     w5base =        WIDGET_BASE(loadbase, /ROW)
     klabel =        Widget_Label(w5base, Value = '   Mask:   ')
     loadmask =      WIDGET_BUTTON(w5base, VALUE = 'Browse')
     masktxt  =      WIDGET_TEXT(w5base, VALUE=maskfile, $
			XS = 60, FRAME= osfrm, /EDIT)
     w7base =        WIDGET_BASE(loadbase, /ROW)
     glabel =        Widget_Label(w7base, Value = '  Weight:  ')
     loadwgt =       WIDGET_BUTTON(w7base, VALUE = 'Browse')
     wgttxt =        WIDGET_TEXT(w7base, VALUE=wgtfile, $
                        XS = 60, FRAME = osfrm, /EDIT) 
     w8base =        WIDGET_BASE(loadbase, /ROW)
     blabel =        Widget_Label(w8base, Value = 'Background:')
     loadbkg =       WIDGET_BUTTON(w8base, VALUE = 'Browse')
     bkgtxt  =       WIDGET_TEXT(w8base, VALUE=bkgfile, $
			XS = 60, FRAME= osfrm, /EDIT)

    ;   define state block

	state = { $
	  loadbase    :   loadbase,    $
	  wbase       :   wbase,       $
	  done        :   done,        $
	  elab        :   elab,        $
	  loadraw     :   loadraw,     $
	  rawtxt      :   rawtxt,      $
	  rcvbutton   :   rcvbutton,   $
	  loadpsf     :   loadpsf,     $
	  psftxt      :   psftxt,      $
	  loadmodel   :   loadmodel,   $
	  modeltxt    :   modeltxt,    $
	  loadmask    :   loadmask,    $
	  masktxt     :   masktxt,     $
	  efield      :   efield,      $
	  maskfield   :   maskfield,   $
	  loadwgt     :   loadwgt,     $
	  wgttxt      :   wgttxt,      $
	  loadbkg     :   loadbkg,     $
	  bkgtxt      :   bkgtxt       $
          }

        WIDGET_CONTROL, loadbase, /REALIZE 

	WIDGET_CONTROL, loadbase, SET_UVALUE = state

        XManager, "loadfile", loadbase, EVENT_HANDLER = "loadfile_ev", $ 
                GROUP_LEADER = GROUP 
                         
END 


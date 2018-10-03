;;; REDSPEC, a GUI software package for reduction of spectrum data.
;;; Sungsoo S. Kim, UCLA Astronomy
;;; version 1.0 -- October, 2000
;;; version 2.0 -- December, 2000
;;; version 2.5 -- February, 2001
;;;
;;; The main reduction routine for the REDSPEC package.
;;; 'redspec.pro' is a graphic interface routine that drives this routine.


;===============================================================================
PRO pipebase_event, event

;;; Controls the widgets for the final spectrum window.

COMPILE_OPT idl2, hidden
COMMON pipecom,tarlambda,final,noddiff,xmin,xmax,ymin,ymax,thedrawnow, $
       pipetext1,pipetext2,pipebase

WIDGET_CONTROL, event.id, GET_UVALUE = eventval

CASE eventval OF

;;; Save a postscript file.
"PS": BEGIN
  devicesave=!D.NAME
  SET_PLOT, 'ps', /copy
  file='tar.ps'
  DEVICE, FILENAME=file
  drawpipe, /ps
  DEVICE, /CLOSE
  SET_PLOT, devicesave, /copy
  message=DIALOG_MESSAGE(dialog_parent=pipebase, $
          'The plot has been saved as "'+file+'".',/information)
END

"YMIN": BEGIN
  WIDGET_CONTROL, pipetext1, GET_VALUE = ymin
  ymin=float(ymin)
  WIDGET_CONTROL, pipetext1, SET_VALUE = string(ymin,format='(g8.2)')
  drawpipe
END

"YMAX": BEGIN
  WIDGET_CONTROL, pipetext2, GET_VALUE = ymax
  ymax=float(ymax)
  WIDGET_CONTROL, pipetext2, SET_VALUE = string(ymax,format='(g8.2)')
  drawpipe
END

"EXIT": BEGIN
  WIDGET_CONTROL, event.top, /DESTROY
END

ENDCASE

END


;===============================================================================
PRO drawpipe, ps=ps

;;; Draw the final spectrum.

COMPILE_OPT idl2, hidden
COMMON pipecom,tarlambda,final,noddiff,xmin,xmax,ymin,ymax,thedrawnow, $
       pipetext1,pipetext2,pipebase

if (n_elements(ps) eq 0) then WSET, thedrawnow

finalmed=median(final)
plot,tarlambda,final/finalmed,charsize=1.3,xmargin=[10,3],ymargin=[5,2], $
    xrange=[xmin,xmax],yrange=[ymin/finalmed,ymax/finalmed],xstyle=1,ystyle=1, $
    xtitle='Wavelength (!4l!3m)',ytitle='Normalized Intensity'

END


;===============================================================================
pro pipe, low=low, vertical=vertical, no_caldata=no_caldata, $
    no_calflat=no_calflat, no_calfixpix, no_calfringe=no_calfringe, $
    no_calrmline=no_calrmline, no_calbb=no_calbb, no_tarflat=no_tarflat, $
    no_tarfixpix, no_tarfringe=no_tarfringe, check_sat=check_sat, $
    save_intermediate=save_intermediate, use_interpol=use_interpol

;;; Read parameters, reduce calibrator, and reduce target.
;;;
;;; low		: flag for low resolution data
;;; vertical	: flag for vertically running spectrum (low resolution for
;;;		      NIRSPEC)
;;; no_caldata	: flag for no calibrator
;;; no_calflat	: flag for no calibrator flat
;;; no_calfixpix: flag for no bad pixel removal for calibrator
;;; no_calfringe: flag for no fringing removal for calibrator
;;; no_calrmline: flag for no calibrator feature removal
;;; no_calbb	: flag for no division by blackbody
;;; no_tarflat	: flag for no target flat
;;; no_tarfixpix: flag for no bad pixel removal for target
;;; no_tarfringe: flag for no fringing removal for target
;;; check_sat	: flag for saturation check
;;; save_intermediate : flag for saving intermediate outputs
;;; use_interpol: flag for using interpolation in rectification instead of
;;;		      using more slow, but more exact mapping method

COMPILE_OPT idl2, hidden
COMMON pipecom,tarlambda,final,noddiff,xmin,xmax,ymin,ymax,thedrawnow, $
       pipetext1,pipetext2,pipebase

!except=0
device,decomposed=0
loadct,39

;;; Initialize flags.
if (n_elements(low) eq 0) then low=0
if (n_elements(vertical) eq 0) then vertical=0
if (n_elements(check_sat) eq 0) then check_sat=1
if (n_elements(no_caldata) eq 0) then no_caldata=0
if (n_elements(no_calflat) eq 0) then no_calflat=0
if (n_elements(no_calfixpix) eq 0) then no_calfixpix=0
if (n_elements(no_calfringe) eq 0) then no_calfringe=0
if (n_elements(no_calrmline) eq 0) then no_calrmline=0
if (n_elements(no_calbb) eq 0) then no_calbb=0
if (n_elements(no_tarflat) eq 0) then no_tarflat=0
if (n_elements(no_tarfixpix) eq 0) then no_tarfixpix=0
if (n_elements(no_tarfringe) eq 0) then no_tarfringe=0
if (n_elements(save_intermediate) eq 0) then save_intermediate=0
if (n_elements(use_interpol) eq 0) then use_interpol=1

get_lun,funit
openr,funit,'files.in',error=err
if (err ne 0) then begin
  free_lun,funit
  errmessage = DIALOG_MESSAGE("Can not find file 'files.in'.",/ERROR)
  return
endif
close,funit
free_lun,funit

;;; Read parameter file.
infile=strarr(14) & err=intarr(14)
infile[0]  = 'target spatial map'
infile[1]  = 'target spectral map' 
infile[2]  = 'target flat'
infile[3]  = 'target dark'
infile[4]  = 'target nod 1'
infile[5]  = 'target nod 2'
infile[6]  = 'calibrator spatial map'
infile[7]  = 'calibrator spectral map' 
infile[8]  = 'calibrator flat'
infile[9]  = 'calibrator dark'
infile[10] = 'calibrator nod 1'
infile[11] = 'calibrator nod 2'
infile[12] = 'calibrator T_eff'
infile[13] = 'user extraction procedure'

readpar, infile[0], tarspatfile, errtemp & err[0]=errtemp
readpar, infile[1], tarspecfile, errtemp & err[1]=errtemp
if (no_tarflat eq 0) then begin
  readpar, infile[2], tarflatfile, errtemp & err[2]=errtemp
  readpar, infile[3], tardarkfile, errtemp & err[3]=errtemp
endif
readpar, infile[4], tarfile1, errtemp & err[4]=errtemp
readpar, infile[5], tarfile2, errtemp & err[5]=errtemp
if (no_caldata eq 0) then begin
  readpar, infile[6], calspatfile, errtemp, /no_field_error & err[6]=errtemp
  readpar, infile[7], calspecfile, errtemp, /no_field_error & err[7]=errtemp
  if (err[6] eq 1) then $
      readpar, infile[0], calspatfile, errtemp & err[6]=errtemp
  if (err[7] eq 1) then $
      readpar, infile[1], calspecfile, errtemp & err[7]=errtemp
  if (no_calflat eq 0) then begin
    readpar, infile[8], calflatfile, errtemp, /no_field_error & err[8]=errtemp
    if (err[8] eq 1) then $
        readpar, infile[2], calflatfile, errtemp & err[8]=errtemp
    readpar, infile[9], caldarkfile, errtemp, /no_field_error & err[9]=errtemp
    if (err[9] eq 1) then $
        readpar, infile[3], caldarkfile, errtemp & err[9]=errtemp
  endif
  readpar, infile[10], calfile1, errtemp & err[10]=errtemp
  readpar, infile[11], calfile2, errtemp & err[11]=errtemp
  readpar, infile[12], tstar, errtemp, /no_file_check & err[12]=errtemp
  tstar=float(tstar)
  if (err[12] eq 0 and tstar le 0.) then begin
    errmessage = DIALOG_MESSAGE("Incorrect T_eff input in file 'files.in'", $
				/ERROR)
    err[12]=4
  endif
endif

readpar, infile[13], user_extraction, errtemp, /no_field_error, /no_file_check
if (errtemp ne 0) then user_extraction=''

if (no_caldata eq 0) then begin
  if (total(err) ne 0) then return
endif else begin
  if (total(err[0:7]) ne 0) then return
endelse

if (vertical eq 1) then low=1
field1 = '' & field2 = 0.
field1 = SXPAR(HEADFITS(tarfile1), 'CURRINST', count=count1)
field2 = SXPAR(HEADFITS(tarfile1), 'ECHLPOS',  count=count2)
if ( (strtrim(field1) eq 'NIRSPEC' or strtrim(field1) eq 'NIRSPAO') and $
    (count2 gt 0)) then begin
  if (field2 gt 100.) then low=1 else low=0
endif


;;;
;;; Spectral Information
;;;

tarrecfitorder=0 & tarxdim=0 & tarclip_ya=0 & tarclip_yb=0
tarwavecntr=0. & tarwavedelta=0. & idummy=0
get_lun,funit
openr,funit,tarspecfile
readf,funit,tarrecfitorder,tarxdim,tarclip_ya,tarclip_yb,tarwavecntr, $
    tarwavedelta
tarydim=tarclip_yb-tarclip_ya+1
tarwavemin=tarwavecntr-(tarxdim/2.)*tarwavedelta
tarspecmap=fltarr(tarrecfitorder+1,tarydim)
readtemp=fltarr(tarrecfitorder+1)
for i=0,tarydim-1 do begin
  readf,funit,idummy,readtemp
  tarspecmap[*,i]=readtemp[*]
endfor
close,funit
free_lun,funit
tarlambda=tarwavemin+(indgen(tarxdim)+0.5)*tarwavedelta
old2new=fltarr(tarxdim) & tarorigpix=fltarr(tarxdim)
for j=0,tarrecfitorder do old2new=old2new+tarspecmap[j,tarydim/2]* $
    findgen(tarxdim)^j
old2new=(old2new-tarwavemin)/tarwavedelta-0.5
for i=0,tarxdim-1 do begin
  temp=min(abs(old2new-i),minold)
  tarorigpix[i]=minold
endfor

if (no_caldata eq 0) then begin
  calrecfitorder=0 & calxdim=0 & calclip_ya=0 & calclip_yb=0
  calwavecntr=0. & calwavedelta=0. & idummy=0
  get_lun,funit
  openr,funit,calspecfile
  readf,funit,recfitorder,calxdim,calclip_ya,calclip_yb,calwavecntr,calwavedelta
  calydim=calclip_yb-calclip_ya+1
  calwavemin=calwavecntr-(calxdim/2.)*calwavedelta
  calspecmap=fltarr(calrecfitorder+1,calydim)
  readtemp=fltarr(calrecfitorder+1)
  for i=0,calydim-1 do begin
    readf,funit,idummy,readtemp
    calspecmap[*,i]=readtemp[*]
  endfor
  close,funit
  free_lun,funit
  callambda=calwavemin+(indgen(calxdim)+0.5)*calwavedelta
  old2new=fltarr(calxdim) & calorigpix=fltarr(calxdim)
  for j=0,calrecfitorder do old2new=old2new+calspecmap[j,calydim/2]* $
      findgen(calxdim)^j
  old2new=(old2new-calwavemin)/calwavedelta-0.5
  for i=0,calxdim-1 do begin
    temp=min(abs(old2new-i),minold)
    calorigpix[i]=minold
  endfor
endif

;;;
;;; Flat
;;;

cushion=4      ; For better performance of fixpix at the edges.
               ; Do not modify without changing the fixpix_cushion
               ; in displines.pro

if (no_tarflat eq 0) then begin
  tarflat=readfits(tarflatfile,/silent)
  if (low ne 0) then tarflat=rotate(tarflat,3)
  tardark=readfits(tardarkfile,/silent)
  if (low ne 0) then tardark=rotate(tardark,3)
  sizetemp=size(tarflat) & tarydim_orig=sizetemp[2]
  tarcusha=cushion<tarclip_ya
  tarcushb=cushion<(tarydim_orig-1-tarclip_yb)
  tarflat=tarflat[*,tarclip_ya-tarcusha:tarclip_yb+tarcusha]
  tardark=tardark[*,tarclip_ya-tarcushb:tarclip_yb+tarcushb]
  if (check_sat eq 1) then begin
    checksat, tarflat, tarflatfile, 'target flat', abort
    if (abort eq 1) then return
    checksat, tardark, tardarkfile, 'target dark', abort
    if (abort eq 1) then return
  endif
  tarflat=tarflat-tardark
  tarflatmed=median(tarflat)
  tarflat=tarflat/tarflatmed
  tarflatnozero=where(tarflat gt 0)
  tarflatzero=where(tarflat le 0)
endif else begin
  tarflatmed=0.
endelse

if (no_caldata eq 0 and no_calflat eq 0) then begin
; The following four lines were added by SZK as per recommendation 
; of David Lafreniere
  if (no_tarflat eq 1) then begin
    tarflatfile = 'none'
    tardarkfile = 'none'
  endif 
;
  if (calflatfile eq tarflatfile and caldarkfile eq tardarkfile) then begin
    calflat=tarflat
    calflatmed=tarflatmed
    calflatnozero=tarflatnozero
    calflatzero=tarflatzero
  endif else begin
    calflat=readfits(calflatfile,/silent)
    if (low ne 0) then calflat=rotate(calflat,3)
    caldark=readfits(caldarkfile,/silent)
    if (low ne 0) then caldark=rotate(caldark,3)
    sizetemp=size(calflat) & calydim_orig=sizetemp[2]
    calcusha=cushion<calclip_ya
    calcushb=cushion<(calydim_orig-1-calclip_yb)
    calflat=calflat[*,calclip_ya-calcusha:calclip_yb+calcusha]
    caldark=caldark[*,calclip_ya-calcushb:calclip_yb+calcushb]
    if (check_sat eq 1) then begin
      if (calflatfile ne tarflatfile) then  begin
        checksat, calflat, calflatfile, 'calibrator flat', abort
        if (abort eq 1) then return
      endif
      if (caldarkfile ne tardarkfile) then  begin
        checksat, caldark, caldarkfile, 'calibrator dark', abort
        if (abort eq 1) then return
      endif
    endif
    calflat=calflat-caldark
    calflatmed=median(calflat)
    calflat=calflat/calflatmed
    calflatnozero=where(calflat gt 0)
    calflatzero=where(calflat le 0)
  endelse
endif else begin
  calflatmed=0.
endelse

;;;
;;; Calibrator
;;;

if (no_caldata eq 0) then begin
  ;;; Read data.
  cal1=float(readfits(calfile1,/silent))
  if (low ne 0) then cal1=rotate(cal1,3)
  cal2=float(readfits(calfile2,/silent))
  if (low ne 0) then cal2=rotate(cal2,3)
  sizetemp=size(cal1) & calydim_orig=sizetemp[2]
  calcusha=cushion<calclip_ya
  calcushb=cushion<(calydim_orig-1-calclip_yb)
  cal1=cal1[*,calclip_ya-calcusha:calclip_yb+calcusha]
  cal2=cal2[*,calclip_ya-calcushb:calclip_yb+calcushb]
  ;;; Check saturation.
  if (check_sat eq 1) then begin
    checksat, cal1, calfile1, 'calibrator nod 1', abort
    if (abort eq 1) then return
    checksat, cal2, calfile2, 'calibrator nod 2', abort
    if (abort eq 1) then return
  endif
  ;;; Subtract one from the other.
  calraw=cal1-cal2
  ;;; Divide by flat.
  if (no_calflat eq 0) then begin
    calraw[calflatnozero]=calraw[calflatnozero]/calflat[calflatnozero]
    if (calflatzero[0] ne -1) then calraw[calflatzero]=0.
  endif
  ;;; Remove bad pixels.
  if (no_calfixpix eq 0) then begin
    print,"=== REDSPEC:  Cleaning the calibrator with `fixpix'..."
    calraw=fixpix_rs(calraw,maskarr,/quiet)
    print,"=== REDSPEC:  Done with cleaning..."
  endif
  calraw=calraw[*,calcusha:calydim-1+calcushb]

  ;;; Rectify the image.
  print,"=== REDSPEC:  Rectifying the spatial dimension of the calibrator..."
  spatrect,calraw,caltemp,calspatfile,use_interpol=use_interpol
  print,"=== REDSPEC:  Done with spatial rectification..."
  print,"=== REDSPEC:  Rectifying the spectral dimension of the calibrator..."
  specrect,caltemp,cal,calspecfile,0.,use_interpol=use_interpol
  print,"=== REDSPEC:  Done with spectral rectification..."
  writefits,'cal.fits',cal

  ;;; Identify calibrators and set the clip width.
  displines,'cal.fits',lines,outwidth, $
      'Set the clip height and click on each nod position.', $
      'REDSPEC - Calibrator',/pipe
  if (lines[1] eq -99) then begin
    print,"==="
    print,"=== REDSPEC:  Mission aborted."
    print,"==="
    return
  endif
  ;;; Extract one dimensional spectra.
  if (lines[1] ne -1) then begin
    ical1=min(lines)
    ical2=max(lines)
    ical1a=(ical1-(outwidth)/2)>0
    ical1b=(ical1+(outwidth-1)/2)<(calydim-1)
    ical2a=(ical2-(outwidth)/2)>0
    ical2b=(ical2+(outwidth-1)/2)<(calydim-1)
    if (user_extraction eq '') then begin
      calline1=total(cal[*,ical1a:ical1b],2)
      calline2=total(cal[*,ical2a:ical2b],2)
    endif else begin
      call_procedure, user_extraction, cal, ical1a, ical1b, calline1
      call_procedure, user_extraction, cal, ical2a, ical2b, calline2
    endelse
    ;;; Remove fringing.
    if (no_calfringe eq 0) then fringe,calline1,calline2
    cal=calline1-calline2
    if (median(cal) lt 0.) then cal=cal*(-1.)
  endif else begin
    ical1=lines[0]
    ical1a=(ical1-(outwidth)/2)>0
    ical1b=(ical1+(outwidth-1)/2)<(calydim-1)
    if (user_extraction eq '') then begin
      cal=total(cal[*,ical1a:ical1b],2)
    endif else begin
      call_procedure, user_extraction, cal, ical1a, ical1b, cal
    endelse
    cal2temp=cal
    ;;; Remove fringing.
    if (no_calfringe eq 0) then fringe,cal,cal2temp
  endelse

  ;;; Remove features intrinsic to the calibrator.
  if (no_calrmline eq 0) then rmline,cal,callambda

  ;;; Divide by blackbody.
  if (no_calbb eq 0) then begin
    bb=1./(exp(1.438e4/callambda/tstar)-1.)/callambda^5
    cal=cal/bb
  endif

  ;;; Normalize it.
  calmed=median(cal)
  cal=cal/calmed

  ;;; Save the spectra.
  get_lun,funit
  openw,funit,'cal.dat'
  printf,funit,'Normalization constants for calibrator and its flat'
  printf,funit,calmed,calflatmed,format='(e13.5)'
  printf,funit,'pixel    lambda         flux'
  for i=0,tarxdim-1 do printf,funit,i+1,callambda[i],cal[i], $
      format='(i4,e15.7,e13.5)'
  close,funit
  free_lun,funit
endif

;;;
;;; Target
;;;

;;; Read data.
tar1=float(readfits(tarfile1,/silent))
if (low ne 0) then tar1=rotate(tar1,3)
tar2=float(readfits(tarfile2,/silent))
if (low ne 0) then tar2=rotate(tar2,3)
sizetemp=size(tar1) & tarydim_orig=sizetemp[2]
tarcusha=cushion<tarclip_ya
tarcushb=cushion<(tarydim_orig-1-tarclip_yb)
tar1=tar1[*,tarclip_ya-tarcusha:tarclip_yb+tarcusha]
tar2=tar2[*,tarclip_ya-tarcushb:tarclip_yb+tarcushb]
;;; Check saturation.
if (check_sat eq 1) then begin
  checksat, tar1, tarfile1, 'target nod 1', abort
  if (abort eq 1) then return
  checksat, tar2, tarfile1, 'target nod 2', abort
  if (abort eq 1) then return
endif
;;; Subtract one from the other.
tarraw=tar1-tar2
;;; Divide by flat.
if (no_tarflat eq 0) then begin
  tarraw[tarflatnozero]=tarraw[tarflatnozero]/tarflat[tarflatnozero]
  if (tarflatzero[0] ne -1) then tarraw[tarflatzero]=0.
endif
;;; Remove bad pixels.
if (no_tarfixpix eq 0) then begin
  print,"=== REDSPEC:  Cleaning the target with `fixpix'..."
  tarraw=fixpix_rs(tarraw,maskarr,/quiet)
  print,"=== REDSPEC:  Done with cleaning..."
endif
tarraw=tarraw[*,tarcusha:tarydim-1+tarcushb]

;;; Rectify the image.
print,"=== REDSPEC:  Rectifying the spatial dimension of the target..."
spatrect,tarraw,tartemp,tarspatfile,use_interpol=use_interpol
print,"=== REDSPEC:  Done with spatial rectification..."
print,"=== REDSPEC:  Rectifying the spectral dimension of the target..."
specrect,tartemp,tar,tarspecfile,0.,use_interpol=use_interpol
print,"=== REDSPEC:  Done with spectral rectification..."
writefits,'tar.fits',tar

;;; Divide by calibrator
if (no_caldata eq 0) then begin
  if (tarspecfile ne calspecfile) then begin
    calnow=fltarr(tarxdim)
    for j=0,calxdim-1 do begin
      calwavebot=callambda[j]-0.5*calwavedelta
      calwavetop=callambda[j]+0.5*calwavedelta
      tarwaveboti=fix((calwavebot-tarwavemin)/tarwavedelta)>0
      tarwavetopi=fix((calwavetop-tarwavemin)/tarwavedelta)<(tarxdim-1)
      for k=tarwaveboti,tarwavetopi do begin
        tarwavenow=tarwavemin+tarwavedelta*k
        botnow=calwavebot>tarwavenow
        topnow=calwavetop<(tarwavenow+tarwavedelta)
        calnow[k]=calnow[k]+cal[j]*(topnow-botnow)/(calwavetop-calwavebot)
      endfor
    endfor
  endif else begin
    calnow=cal
  endelse
  for i=0,tarydim-1 do tar[*,i]=tar[*,i]/calnow[*]
endif

;;; Identify targets and set the clip width.
displines,'tar.fits',lines,outwidth, $
    'Set the clip height and click on each nod position.','REDSPECE - Target', $
    /pipe
if (lines[1] eq -99) then begin
  print,"==="
  print,"=== REDSPEC:  Mission aborted."
  print,"==="
  return
endif

;;; Extract one dimensional spectra.
if (lines[1] ne -1) then begin
  itar1=min(lines)
  itar2=max(lines)
  itar1a=(itar1-(outwidth)/2)>0
  itar1b=(itar1+(outwidth-1)/2)<(tarydim-1)
  itar2a=(itar2-(outwidth)/2)>0
  itar2b=(itar2+(outwidth-1)/2)<(tarydim-1)
  if (user_extraction eq '') then begin
    tarline1=total(tar[*,itar1a:itar1b],2)
    tarline2=total(tar[*,itar2a:itar2b],2)
  endif else begin
    call_procedure, user_extraction, tar, itar1a, itar1b, tarline1
    call_procedure, user_extraction, tar, itar2a, itar2b, tarline2
  endelse
  ;;; Remove fringing.
  if (no_tarfringe eq 0) then fringe,tarline1,tarline2
  final=tarline1-tarline2
  if (median(final) lt 0.) then final=final*(-1.)
  ;;; Normalize it.
  finalmed=median(final)
  final=final/finalmed
  noddiff=abs(tarline1/median(tarline1)-tarline2/median(tarline2))
  if (median(tarline1) lt 0.) then tarline1=tarline1*(-1.)
  if (median(tarline2) lt 0.) then tarline2=tarline2*(-1.)
endif else begin
  itar1=lines[0]
  itar1a=(itar1-(outwidth)/2)>0
  itar1b=(itar1+(outwidth-1)/2)<(tarydim-1)
  if (user_extraction eq '') then begin
    final=total(tar[*,itar1a:itar1b],2)
  endif else begin
    call_procedure, user_extraction, tar, itar1a, itar1b, final
  endelse
  final2temp=final
  ;;; Remove fringing.
  if (no_tarfringe eq 0) then fringe,final,final2temp
  ;;; Normalize it.
  finalmed=median(final)
  final=final/finalmed
endelse

;;; Save the spectra.
get_lun,funit
openw,funit,'tar.dat'
if (lines[1] ne -1) then begin
  printf,funit,'Normalization constants for target and its flat'
  printf,funit,finalmed,tarflatmed,format='(2e13.5)'
  printf,funit,'pixel    lambda         flux         nod1         nod2    ', $
      '  |nod2-nod1|'
  for i=0,tarxdim-1 do printf,funit,i+1,tarlambda[i],final[i],tarline1[i], $
      tarline2[i],noddiff[i],format='(i4,e15.7,4e13.5)'
endif else begin
  printf,funit,'Normalization constant'
  printf,funit,finalmed,format='(e13.5)'
  printf,funit,'pixel    lambda         flux'
  for i=0,tarxdim-1 do printf,funit,i+1,tarlambda[i],final[i], $
      format='(i4,e15.7,e13.5)'
endelse
close,funit
free_lun,funit

xmin=tarlambda[0]-(tarlambda[tarxdim-1]-tarlambda[0])*0.05
xmax=tarlambda[tarxdim-1]+(tarlambda[tarxdim-1]-tarlambda[0])*0.05
ymin=0.
sortfinal=sort(final)
ymax=final[sortfinal[fix(n_elements(final)*0.95)]]*1.5
;ymax=max(final)*1.15
thedrawsave = !D.WINDOW

;;; Prepare widgets.
pipebase = WIDGET_BASE(TITLE='Extracted Spectrum', /COLUMN)
pipebuttonbase1 = WIDGET_BASE(pipebase, /ROW)
pipebutton1a = WIDGET_BUTTON(pipebuttonbase1, VALUE=' Postscript ', UVALUE='PS')
pipebutton1b = WIDGET_BUTTON(pipebuttonbase1, VALUE=' Close ', UVALUE='EXIT')
pipetextbase = WIDGET_BASE(pipebase, /ROW)
pipetext1 = CW_FIELD(pipetextbase, VALUE=string(ymin,format='(g8.2)'), $
			UVALUE='YMIN', XSIZE=8, /RETURN_EVENTS, TITLE='Y Min')
pipetext2 = CW_FIELD(pipetextbase, VALUE=string(ymax,format='(g8.2)'), $
			UVALUE='YMAX', XSIZE=8, /RETURN_EVENTS, TITLE='Y Max')
pipedisp = WIDGET_DRAW(pipebase, RETAIN=2, XSIZE=800, YSIZE=500)

ghostbase = WIDGET_BASE(pipebase)
ghostdisp = WIDGET_DRAW(ghostbase, RETAIN=2, XSIZE=10, YSIZE=10)
WIDGET_CONTROL, ghostbase, MAP=0

WIDGET_CONTROL, pipebase, /REALIZE
WIDGET_CONTROL, pipedisp, GET_VALUE=thedrawnow
TVLCT, R_ORIG, G_ORIG, B_ORIG, /GET
RED =   [0, 1, 1, 0, 0, 1, 1, 0];Specify the red component of each color.
GREEN = [0, 1, 0, 1, 0, 1, 0, 1];Specify the green component of each color.
BLUE =  [0, 1, 0, 0, 1, 0, 1, 1];Specify the blue component of each color.
TVLCT, 255 * RED, 255 * GREEN, 255 * BLUE

drawpipe

XManager, "pipebase", pipebase

TVLCT, R_ORIG, G_ORIG, B_ORIG

WSET, thedrawsave

END

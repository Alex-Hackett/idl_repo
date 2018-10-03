;;; REDSPEC, a GUI software package for reduction of spectrum data.
;;; Sungsoo S. Kim, UCLA Astronomy
;;; version 1.0 -- October, 2000
;;; version 2.0 -- December, 2000
;;; version 2.5 -- February, 2001
;;;
;;; Edit a parameter file.


;===============================================================================
PRO help_parfile, event

;;; Control help widgets.

COMPILE_OPT idl2, hidden

WIDGET_CONTROL, event.id, GET_UVALUE = eventval

CASE eventval OF

"DONE": BEGIN
  WIDGET_CONTROL, event.top, /DESTROY
END

ENDCASE

END


;===============================================================================
PRO parfile_event, event

;;; Control main widgets.

COMPILE_OPT idl2, hidden
COMMON parfilecom,npar,ntarpar,objname,par,field,pathnow,parbase,no_browser,$
       resize,size

WIDGET_CONTROL, event.id, GET_UVALUE = eventval

CASE eventval OF

"DONE": BEGIN
  WIDGET_CONTROL, event.top, /DESTROY
END

"HELP": BEGIN
;; Replaces by SZK. The text changed as edited by LAP
;; and all the WIDGET_LABEL commands were replaced by
;; XDISPLAYFILE command.
  helpfile = " "
  helptext = [ $
    "Input fields required for SPATMAP:", $
    "   (A) If NIRSPEC settings have NOT changed between TARGET and", $
    "	CALIBRATOR observations:", $
    "	need to run SPATMAP using", $
    "	   TARGET arc 1", $
    "	   CALIBRATOR nod 1 AND nod 2  *", $
    "   (B) If NIRSPEC settings HAVE changed between TARGET and", $
    "	CALIBRATOR observations:", $
    "	need to run SPATMAP and SPATMAP,/cal using, respectively", $
    "	   TARGET arc 1", $
    "	   TARGET nod 1 AND nod 2", $
    "	and", $
    "	   CALIBRATOR arc 1", $
    "	   CALIBRATOR nod 1 AND nod 2", $
    " ", $
    "Input fields required for SPECMAP:", $
    "   (A) As defined above:", $
    "	   TARGET arc 1", $
    "	   [TARGET arc 2]", $
    "	   [TARGET reference arc]", $
    "	   [TARGET ref. spec map]", $
    "   (B) As defined above:", $
    "	need to run SPECMAP and SPECMAP,/cal using, respectively", $
    "	   TARGET arc 1", $
    "	   [TARGET arc 2]", $
    "	   [TARGET reference arc]", $
    "	   [TARGET ref. spec map]", $
    "	and", $
    "	   CALIBRATOR arc 1", $
    "	   [CALIBRATOR arc 2]", $
    "	   [CALIBRATOR reference arc]", $
    "	   [CALIBRATOR ref. spec map]", $
    " ", $
    "Input fields required for REDSPEC:", $
    "   (A) As defined above:", $
    "	  TARGET spatial map (spat.map)", $
    "	  TARGET spectral map (spec.map)", $
    "	  TARGET dark (when flat fielding is selected)", $
    "	  TARGET flat (when flat fielding is selected)", $
    "	  TARGET nod 1", $
    "	  TARGET nod 2", $
    "	  CALIBRATOR nod 1 (when division by CALIBRATOR is selected)", $
    "	  CALIBRATOR nod 2 (when division by CALIBRATOR is selected)", $
    "	  CALIBRATOR effective temperature (T_eff) (when division ", $
    "		     by CALIBRATOR is selected)", $
    "   (B) As defined above:", $
    "	All of those in case (A) plus:", $
    "	  CALIBRATOR spatial map (spat.map.cal)", $
    "	  CALIBRATOR spectral map (spec.map.cal)", $
    "	  CALIBRATOR dark (when flat-fielding is selected)", $
    "	  CALIBRATOR flat (when flat-fielding is selected)", $
    " ", $
    " ", $
    "*:  Since the CALIBRATOR star is presumably bright, this ensures", $
    "    a high quality spatial map", $
    "[]: Optional"]
  
  XDISPLAYFILE, helpfile, GROUP=parbase, /MODAL, text=helptext, TITLE="PARFILE -- HELP"
  ;; End of section by SZK
END

"RESIZE": BEGIN
  WIDGET_CONTROL, event.top, /DESTROY
  resize=1
  size=1-size
END

ELSE:

ENDCASE

;;; Read input and save.
for i=0,npar-1 do begin
  if (eventval eq objname[i]) then begin
    WIDGET_CONTROL, event.id, GET_VALUE = partemp
    par[i] = partemp
;   if (i le 5) then begin
;     WIDGET_CONTROL, field[i+ntarpar], SET_VALUE = par[i+ntarpar]
;     par[i+ntarpar] = partemp
;   endif
  endif
endfor

;;; Spawn a file browser, get file name and save it.
for i=0,npar-1 do begin
  if (eventval eq 'B'+objname[i] and no_browser[i] eq 0) then begin
    parold = par[i]
    browse = DIALOG_PICKFILE(PATH=pathnow, GET_PATH=pathtemp, /MUST_EXIST, $
			     /NOCONFIRM)
    if (browse eq '') then browse = parold
    WIDGET_CONTROL, field[i], SET_VALUE = browse
    par[i] = browse
;   if (i le 5) then begin
;     WIDGET_CONTROL, field[i+ntarpar], SET_VALUE = browse
;     par[i+ntarpar] = browse
;   endif
    pathnow = pathtemp
  endif
endfor

END


;===============================================================================
PRO parfile

;;; Prepare parameters and main widgets.

COMPILE_OPT idl2, hidden
COMMON parfilecom,npar,ntarpar,objname,par,field,pathnow,parbase,no_browser,$
       resize,size

ntarpar=10
ncalpar=11
npar=ntarpar+ncalpar
size=1
obj=strarr(npar) & name=strarr(npar) & name2=strarr(npar) & par=strarr(npar)
no_browser=intarr(npar)

;;; field names
name[0]  = 'spatial map'
name[1]  = 'spectral map'
name[2]  = 'flat'
name[3]  = 'dark'
name[4]  = 'arc 1'
name[5]  = 'arc 2'
name[6]  = 'reference arc'
name[7]  = 'ref. spec map'
name[8]  = 'nod 1'
name[9]  = 'nod 2'
name[10] = 'spatial map'
name[11] = 'spectral map'
name[12] = 'flat'
name[13] = 'dark'
name[14] = 'arc 1'
name[15] = 'arc 2'
name[16] = 'reference arc'
name[17] = 'ref. spec map'
name[18] = 'nod 1'
name[19] = 'nod 2'
name[20] = 'T_eff'
no_browser[20] = 1
par[0]  = 'spat.map'
par[1]  = 'spec.map'
par[10]  = 'spat.map.cal'
par[11] = 'spec.map.cal'

for i=0,ntarpar do obj[i]='target'
for i=ntarpar,npar-1 do obj[i]='calibrator'
objname=obj+' '+name

maxlength1=max(strlen(name[0:ntarpar-1]))
maxlength2=max(strlen(name[ntarpar:npar-1]))
for i=0,npar-1 do begin
  if (i lt ntarpar) then maxlength=maxlength1 else maxlength=maxlength2
  strspace=''
  for j=0,maxlength-strlen(name[i])-1 do strspace=strspace+' '
  name2[i]=strspace+name[i]+" :"
endfor

;;; Read an existing parameter file, if any.
pathnow='' & partemp=''
get_lun,funit
openr,funit,'files.in',error=err
if (err eq 0) then begin
  close,funit
  for i=0,npar-1 do begin
    readpar, objname[i], partemp, /no_file_check, /no_field_error
    par[i]=partemp
  endfor
endif
free_lun,funit

jump1:
resize=0
if (size eq 1) then xsize=50 else xsize=25
if (size eq 1) then resizetext=' Make window narrower ' else $
    resizetext=' Make window wider '

;;; Prepare main widgets.
parbase = WIDGET_BASE(TITLE = 'PARFILE', /COLUMN)

donebase = WIDGET_BASE(parbase, /ROW)
donebutton = WIDGET_BUTTON(donebase, VALUE=' Done ', UVALUE='DONE')
label0 = WIDGET_LABEL(donebase, VALUE='    ')
helpbutton = WIDGET_BUTTON(donebase, VALUE=' Help ', UVALUE='HELP')
resizebutton = WIDGET_BUTTON(donebase, VALUE=resizetext, UVALUE='RESIZE')

inputbase = WIDGET_BASE(parbase, /ROW)
base=lonarr(npar) & field=lonarr(npar) & button=lonarr(npar)

inputbase1 = WIDGET_BASE(inputbase, /COLUMN, /BASE_ALIGN_RIGHT)
label1 = WIDGET_LABEL(inputbase1, VALUE=' T A R G E T ', /ALIGN_CENTER, FRAME=5)
for i=0,ntarpar-1 do begin
  base[i] = WIDGET_BASE(inputbase1, /ROW)
  field[i] = CW_FIELD(base[i], XSIZE=xsize, /ALL_EVENTS, $
		TITLE=name2[i], VALUE=par[i], UVALUE=objname[i])
;  if (no_browser[i] eq 0) then begin
    button[i] = WIDGET_BUTTON(base[i], VALUE=' Browse ', UVALUE='B'+objname[i])
;  endif
endfor

inputbase2 = WIDGET_BASE(inputbase, /COLUMN, /BASE_ALIGN_RIGHT)
label2 = WIDGET_LABEL(inputbase2, VALUE=' C A L I B R A T O R ', /ALIGN_CENTER,$
			FRAME=5)
for i=ntarpar,npar-1 do begin
  base[i] = WIDGET_BASE(inputbase2, /ROW)
  field[i] = CW_FIELD(base[i], XSIZE=xsize, /ALL_EVENTS, $
		TITLE=name2[i], VALUE=par[i], UVALUE=objname[i])
;  if (no_browser[i] eq 0) then begin
    button[i] = WIDGET_BUTTON(base[i], VALUE=' Browse ', UVALUE='B'+objname[i])
;  endif
endfor

WIDGET_CONTROL, parbase, /REALIZE

XManager, "parfile", parbase

if (resize eq 1) then goto, jump1

;;; Save the parameter file.
get_lun,funit
openw,funit,'files.in'
maxlength=max(strlen(par))
for i=0,npar-1 do begin
  if (i eq ntarpar) then printf,funit
  strspace=''
  for j=0,maxlength-strlen(par[i])-1 do strspace=strspace+' '
  printf,funit,par[i]+strspace+" : "+objname[i]
endfor
close,funit
free_lun,funit

END

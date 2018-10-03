;;; REDSPEC, a GUI software package for reduction of spectrum data.
;;; Sungsoo S. Kim, UCLA Astronomy
;;; version 1.0 -- October, 2000
;;; version 2.0 -- December, 2000
;;; version 2.5 -- February, 2001
;;;
;;; Show saturated pixels with red color.


;===============================================================================
PRO sat_event, event

;;; Control events for routine checksat.

COMPILE_OPT idl2, hidden
COMMON satcom,thedraw1,thedraw2,aborttemp,valuetext,coordtext,smallsize, $
       enlarge,xdim,ydim,coadd,mindata,satlimit,imageorig2,ncolor

WIDGET_CONTROL, event.id, GET_UVALUE = eventval

CASE eventval OF

;;; Display magnification window and coordinate information.
"DISP" : BEGIN
  x=event.x
  y=event.y

  right, event, redraw='disp_checksat2'

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
  imagetemp[ixa:ixb,iya:iyb]=bytscl(imageorig2[xa:xb,ya:yb],min=mindata, $
      max=satlimit,top=ncolor-2)
  imagetemp2=rebin(imagetemp,pixsize,pixsize,sample=1)
  imagetemp2[center-cross:center+cross,center]=0
  imagetemp2[center,center-cross:center+cross]=0
  WSET, thedraw2
  tv,imagetemp2,0,0

  xpix=(x>0)<(xdim-1)
  ypix=(y>0)<(ydim-1)
  pixvalue=string(imageorig2[xpix,ypix],format='(e10.3)')+' DN/COADD'
  coord='('+string(xpix+1,format='(i4)')+','+string(ypix+1,format='(i4)')+')'
  WIDGET_CONTROL, valuetext, SET_VALUE = pixvalue
  WIDGET_CONTROL, coordtext, SET_VALUE = coord
END

;;; Accept the image.
"EXIT": BEGIN
  aborttemp = 0
  WIDGET_CONTROL, event.top, /DESTROY
END

;;; Abort the mission.
"ABORT": BEGIN
  aborttemp = 1
  WIDGET_CONTROL, event.top, /DESTROY
END

ENDCASE

END


;===============================================================================
PRO disp_checksat2

COMPILE_OPT idl2, hidden

; Do nothing.

END


;===============================================================================
PRO checksat, image, filename, file, abort

;;; Show saturated pixles with red color.  Give the user options to continue
;;;     or abort.  If no saturation, do nothing.
;;;
;;; image	: image to be checked (IDL variable)
;;; filename	: file name of the image
;;; file	: content of the image (e.g., 'target flat')
;;; abort	: flag for abortion

COMPILE_OPT idl2, hidden
COMMON satcom,thedraw1,thedraw2,aborttemp,valuetext,coordtext,smallsize, $
       enlarge,xdim,ydim,coadd,mindata,satlimit,imageorig2,ncolor
COMMON rightcom,imagetemp,pressed,xstart,ystart,xold,yold,xdimtemp,ydimtemp, $
       thedrawtemp,ydim2temp,imageorig

device,decomposed=0

instrument  = 'NIRSPEC'
instrument2 = 'NIRSPAO'
fieldinst   = 'CURRINST' ;  NIRSPEC header for current instrument
fieldcoadd  = 'COADDS'   ;  NIRSPEC header for # of coadds
satlimit    = 18000.     ;  NIRSPEC saturation limit (conservative)
mindata     = 0.         ;  Minimum data value for display

abort=0

;;; Check header information.
instnow = '' & coadd = 1.
instnow = SXPAR(HEADFITS(filename), fieldinst,  count=count1)
coadd   = SXPAR(HEADFITS(filename), fieldcoadd, count=count2)

if (count1*count2 eq 0) then begin
  message=DIALOG_MESSAGE('Saturation Check:  '+ $
	'Can not find necessary header information in file '+filename+'.')
  return
end

if (instnow eq instrument or instnow eq instrument2) then begin
  message=DIALOG_MESSAGE('Saturation Check:  '+ $
	'Current instrument is not '+instrument+'.')
  return
endif

if (max(image)/float(coadd) lt satlimit) then return

;;; See if saturation pixels are consecutive over at least 3 adjacent pixels.
sizetemp=size(image)
xdim=sizetemp[1] & ydim=sizetemp[2]
overlimit=where(image gt satlimit)
if (n_elements(overlimit) gt (xdim*ydim*0.1)) then goto, jump1

sat = intarr(xdim,ydim)
sat[overlimit] = 1
for i=0,xdim-1 do begin
  satrow=reform(sat[i,*])
  if (total(satrow) gt 3) then begin
    for j=1,ydim-2 do if (total(satrow[j-1:j+1]) eq 3) then goto, jump1
  endif
endfor
for j=0,ydim-1 do begin
  satcol=sat[*,j]
  if (total(satcol) gt 3) then begin
    for i=1,xdim-2 do if (total(satcol[i-1:i+1]) eq 3) then goto, jump1
  endif
endfor

return

;
; Show the image.
;

jump1:

smallsize=21  ; should be an odd number
enlarge=5     ; should be an odd number

;;; Prepare widgets.
satbase = WIDGET_BASE(TITLE = 'Saturation Check', /COLUMN)

msglabel = WIDGET_LABEL(satbase, VALUE="Check for saturation in '"+file+"'.", $
			/ALIGN_LEFT)
msglabel = WIDGET_LABEL(satbase, VALUE='Saturation limit = '+string(satlimit, $
			format='(e8.2)')+' DN/COADD', /ALIGN_LEFT)

buttonbase = WIDGET_BASE(satbase, /ROW)
donebutton = WIDGET_BUTTON(buttonbase, VALUE=' Continue ',UVALUE='EXIT')
msglabel = WIDGET_LABEL(buttonbase, VALUE='', YSIZE='20', /ALIGN_LEFT)
abortbutton = WIDGET_BUTTON(buttonbase, VALUE=' Abort ',UVALUE='ABORT')

smallbase = WIDGET_BASE(satbase, /ROW)
smallbase1 = WIDGET_BASE(smallbase, /COLUMN)
dispsmall = WIDGET_DRAW(smallbase1, XSIZE=smallsize*enlarge, $
                        YSIZE=smallsize*enlarge, RETAIN=2)
smallbase2 = WIDGET_BASE(smallbase, /COLUMN)
valuetext = WIDGET_LABEL(smallbase2, VALUE='', XSIZE=150, YSIZE=20, /ALIGN_LEFT)
coordtext = WIDGET_LABEL(smallbase2, VALUE='', XSIZE=150, YSIZE=20, /ALIGN_LEFT)

device, get_screen_size=screen
if (screen[0] lt 1200) then xscr=800 else xscr=1024
if (screen[1] lt 900)  then yscr=400 else yscr=640
extra=''
if (xdim gt xscr) then extra = {X_SCROLL_SIZE:xscr, Y_SCROLL_SIZE:ydim+2}
if (ydim gt yscr) then extra = {X_SCROLL_SIZE:xdim+2, Y_SCROLL_SIZE:yscr}
if (xdim gt xscr and ydim gt yscr) then extra = {X_SCROLL_SIZE:xscr, $
    Y_SCROLL_SIZE:yscr}
display = WIDGET_DRAW(satbase, RETAIN=2, XSIZE=xdim, YSIZE=ydim, $
                          _Extra=extra, $
                          /BUTTON_EVENTS, /MOTION_EVENTS, UVALUE='DISP')

WIDGET_CONTROL, satbase, /REALIZE
WIDGET_CONTROL, display,   GET_VALUE = thedraw1
WIDGET_CONTROL, dispsmall, GET_VALUE = thedraw2

;;; Variables for right.pro
xdimtemp=xdim & ydimtemp=ydim & thedrawtemp=thedraw1 & ydim2temp=ydim
imageorig=image/coadd
imageorig2=imageorig

TVLCT, R_ORIG, G_ORIG, B_ORIG, /GET
WSET, thedraw1

LOADCT, 0, /silent
TVLCT, R_TEMP, G_TEMP, B_TEMP, /GET
sizetemp=size(R_TEMP)
ncolor=sizetemp[1]
R_TEMP[ncolor-2]=255
G_TEMP[ncolor-2]=0
B_TEMP[ncolor-2]=0
R_TEMP[ncolor-1]=255
G_TEMP[ncolor-1]=255
B_TEMP[ncolor-1]=255
TVLCT, R_TEMP, G_TEMP, B_TEMP

;;; Main image
imagetemp=bytscl(imageorig,min=mindata,max=satlimit,top=ncolor-2)
tv, imagetemp

XManager, "sat", satbase

abort=aborttemp

TVLCT, R_ORIG, G_ORIG, B_ORIG

END

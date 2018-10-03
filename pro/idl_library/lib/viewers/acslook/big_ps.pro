;+
;NAME:
;       BIG_PS
;
;PURPOSE:
;       Converts an IDL (image) array to a postscript file.
;
;CATEGORY:
;	input/output
;
;CALLING SEQUENCE:
;       big_ps, image, immin=immin, immax=immax, title=title,$
;       	filename=filename, log=log, colortable=colortable, rev=rev,$
;		scaletitle=scaletitle, nobar=nobar
;
;INPUTS:
;       Image: IDL image array to be printed (need not be square)
;
;OPTIONAL KEYWORDS:
;       LOG: if set, scales image logarithmically.
;               WARNING: image will be returned as a log. Make a copy
;                        if you want to save original image!
;       IMMIN: minimum data value to use in scaling [default = image min]
;       IMMAX: maximum data value to use in scaling [default = image max]
;       FILENAME: name of postscript file written to disk [def= 'idl.ps']
;       TITLE: title of image (written above image when printed)
;       COLORTABLE: color look-up table to use when printing [def = greyscale]
;	REV: if set, white-on-black is reversed to black-on-white (saves toner)
;	SCALETITLE: title for colorbar scaling (i.e., 'LOG SCALING')
;	NOBAR: if set, scalebar is suppressed (NOTE: scaletitle still 
;                appears unless you set scaletitle = '')
;
;OUTPUTS:
;       none, postscript file written to disk
;
;COMMENTS:
;	It is highly recommended to use the IMMIN keyword when using
;		the log scale. The default is 10^(-5), which
;		may stretch color scale too far.
;	You can use a personal colortable by first loading that table
;		at the IDL prompt (use tvlct) and then running BIG_PS
;		with colortable set equal to -1. You can do this for a 
;		preset table as well; for example, type "LOADCT,1" and
;		then run BIG_PS with colortable = -1.
;	To get JUST the image with no annotation, set:
;               title = ''
;               scaletitle = ''
;               nobar = 1
;
;HISTORY:
;       Written by:	PP/ACC  5/11/95 (from DL/ACC)
;       8/31/95         PP/ACC  Version 1.2   Changed keyword set, now allows
;                                  keywords to be set to 0.
;       9/25/95         PP/ACC  Version 1.3   Fixed a bug in logarithmic scaling,
;                                  image now scaled correctly.
;	9/26/95		PP/ACC  Version 1.4   Added scaling type under colorbar.
;				   Added reverse option. Also, input image
;				   is no longer changed; a temp image is 
;				   created for log scaling and reversal.
;	9/29/95		PP & DJL /ACC Fixed bug in color table
;	10/16/95	PP/ACC	Added scaletitle keyword
;	6/6/96		PP/ACC fixed bug in log scaling and immin setting
;	8/30/96		PP/ACC Loadct now runs silently
;	4/16/97		PP/ACC added NOBAR keyword, changed default title to '',
;                                   now returns user to original device type
;       5/22/97         PP/ACC changed immin and immax to imin and imax to 
;                               prevent them being overwritten on multiple calls
;	10/27/97        PP/ACC fixed bug which changed colortable every time
;			       routine called with colortable=-1. Now resets
;			       colortable to orig. value before exiting
;-

pro big_ps, image, $
        immin = immin, immax = immax, title = title,$
	filename = filename, log = log, colortable = colortable, rev = rev,$
	scaletitle = scaletitle, nobar = nobar

if n_params(0) eq 0 then begin
        print,'CALLING SEQUENCE:'
        print,'big_ps, image, immin=immin, immax=immax, title=title,$'
        print,'		filename=filename,log=log,colortable=colortable,rev=rev'
	print,'		scaletitle=scaletitle, nobar = nobar'
        return
endif

;get device type so BIG_PS can return user to original device

dev_type = !d.name

;Make temporary image so original image is left intact
tempim=image

;set up defaults for keywords, allow for keyword being set to 0
;reasoning: if keyword is set (including = to 0), n_elements(keyword)=1,else=0

if not n_elements(immin) then immin=min(tempim)
if not n_elements(immax) then immax=max(tempim)
if not n_elements(title) then title=''
if not n_elements(filename) then filename='idl.ps'
if not n_elements(colortable) then colortable=0 ;greyscale

;change variable names for immin,immax to prvent them getting output incorrectly
imin = immin
imax = immax

;LOAD PERSONAL COLOR TABLE if not black & white
if (colortable lt 0) then begin

	tvlct,r,g,b,/get
        ;save original colortable values to be reloaded upon exiting
        rback = r
        gback = g
        bback = b
	nr=n_elements(r)

	if nr ne 256 then begin
		;rr=interpol(r,findgen(nr),(nr-1)*indgen(256)/255.)
		rr=lindgen(256)*(nr-1)/255
		r = r(rr)
		g = g(rr)
		b = b(rr)
	endif

endif

set_plot,'ps'

device,/color,/portrait,xoffset=0.50,yoffset=1.25,xsize=7.5,ysize=8,$ 
		/inches,bits=8,filename=filename

if (colortable lt 0) then begin ;personal table
	tvlct,r,g,b
   endif else begin	        ;preset table
	loadct,colortable,/silent
endelse

imsize = size(tempim)
nx = imsize(1) & ny = imsize(2)

xoff = 0
yoff = 0
xsize = 7.5
ysize = 7.5

if nx lt ny then begin
	xsize = 7.5*nx/ny
	xoff = (7.5 - xsize)/2 
   end else begin
	ysize = 7.5*ny/nx
	yoff = (7.5-ysize)/2
end		    

;SCALING LOGARITHMICALLY?

if keyword_set(log) then begin

	if (imax le 0) then begin
		print,'**************'
		print,'ERROR: Image max less than 0''
		print,'Returning.'
		print,'**************'
		return
	endif

	if (imin le 0) then begin
		print,'WARNING:
		print,'Image min set to < 0. Resetting to max * 1.e-8'
                imin = imax/1.e8     ;set range of 8 dex
	endif

	tempim=alog10(tempim>imin<imax)
	imin = alog10(imin)
	imax = alog10(imax)

endif

;get sign of min, max for later use in colorbar
if imin lt 0 then minneg='-' else minneg=''
if imax lt 0 then maxneg='-' else maxneg=''

;SET UP REVERSE IMAGE

if keyword_set(rev) then begin
	tempim=(-1.0)*temporary(tempim)
	tempmax=(-1.0) * imax
	imax=(-1.0) * imin
	imin=tempmax
endif

;SET UP COLORBAR

if not keyword_set(nobar) then begin
   buff=bindgen(256,20) ;actual colorbar
   bar=intarr(258,22) ;frame for colorbar
   bar(*,0)=0 & bar(*,21)=0 & bar(0,*)=0 & bar(257,*)=0 ;black border
   bar(1:256,1:20)=buff ;put colorbar in frame
   tvscl,bar,1.75,7.9,xsize=4.0,ysize=0.25,/inches

   ;LABEL MAX AND MIN FOR COLORBAR
   
   ;turn imin and imax into strings for colorbar
   minstr=strtrim(abs(imin),2)
   maxstr=strtrim(abs(imax),2)

   ;note that imin and imax were switched for negative image!
   ;if not keyword_set(nobar) then begin
   if keyword_set(rev) then begin
      xyouts,0.22,0.997,maxneg+minstr,/normal,align=1.0,font=0
      xyouts,0.78,0.997,minneg+maxstr,/normal,font=0
   endif else begin
      xyouts,0.22,0.997,minneg+minstr,/normal,align=1.0,font=0
      xyouts,0.78,0.997,maxneg+maxstr,/normal,font=0
   endelse

endif

   ;LABEL SCALING FOR COLORBAR 

   if not n_elements(scaletitle) then begin
      if keyword_set(log) then scaletitle='Logarithmic Scaling' else $
      scaletitle='Linear Scaling'
   if keyword_set(rev) then scaletitle=scaletitle + ', reversed'
   endif

   xyouts,0.50,0.965,scaletitle,/normal,font=0,align=0.5


;DISPLAY SCALED IMAGE

tv,bytscl(tempim,imin,imax),xoff,yoff,xsize=xsize,ysize=ysize,/inches

;TITLE OF PLOT
xyouts,0.5,1.04,title,font=0,/normal,align=0.5

;All finished. Clean up, return user to original device type (usually 'x')
device,/close
set_plot, dev_type
;reload original colors
if (colortable lt 0) then tvlct, rback, gback, bback
return
end

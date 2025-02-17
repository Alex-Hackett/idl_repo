;-------------------------------------------------------------
;+
; NAME:
;       PLOTSHAPE
; PURPOSE:
;       Plot given shape file on current map.
; CATEGORY:
; CALLING SEQUENCE:
;       plotshape, file
; INPUTS:
;       file = name of shape file.   in
; KEYWORD PARAMETERS:
;       Keywords:
;         NUMBER=num Returned number of entities in file.
;         COLOR=clr  Plot color.  May be an array with a color
;           for each entity.
;         OCOLOR=oclr  Outline color if needed.  Def=none.
;         THICK=thk Line thickness.
;         LINESTYLE=lsty Line style.
;         /NOPLOT means do not plot data.
;         ERROR=err Error flag: 0=ok.
;         /QUIET fewer messages.
;         /DEVFILL before plotting polygons first convert from
;           data to device coordinates, then fill.  polyfill
;           sometimes fails, this might work.
; OUTPUTS:
; COMMON BLOCKS:
; NOTES:
;       Note: shape file is the standard GIS shape file.
; MODIFICATION HISTORY:
;       R. Sterner, 2003 Mar 24
;       R. Sterner, 2003 Sep 08 --- Added keyword /DEVFILL.
;       R. Sterner, 2003 Sep 09 --- Added polyline, thick=thk.
;       R. Sterner, 2004 Apr 05 --- Fixed loop limit.
;       R. Sterner, 2004 Apr 15 --- Added noclip=0 to outlines.
;       R. Sterner, 2004 Apr 19 --- Added noclip=0 to polylines.
;       R. Sterner, 2004 Apr 19 --- Added noclip=0 to polyfill.
;       R. Sterner, 2004 Aug 02 --- New keyword /QUIET.
;
; Copyright (C) 2003, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
	pro plotshape, file, number=num, noplot=noplot, error=err, $
	  type=typ, color=clr, ocolor=oclr, devfill=devfill, $
	  thick=thk, linestyle=lsty, quiet=quiet, help=hlp
 
	if (n_params(0) lt 1) or keyword_set(hlp) then begin
	  print,' Plot given shape file on current map.'
	  print,' plotshape, file'
	  print,'   file = name of shape file.   in'
	  print,' Keywords:'
	  print,'   NUMBER=num Returned number of entities in file.'
	  print,'   COLOR=clr  Plot color.  May be an array with a color'
	  print,'     for each entity.'
	  print,'   OCOLOR=oclr  Outline color if needed.  Def=none.'
	  print,'   THICK=thk Line thickness.'
	  print,'   LINESTYLE=lsty Line style.'
	  print,'   /NOPLOT means do not plot data.'
	  print,'   ERROR=err Error flag: 0=ok.'
	  print,'   /QUIET fewer messages.'
	  print,'   /DEVFILL before plotting polygons first convert from'
	  print,'     data to device coordinates, then fill.  polyfill'
	  print,'     sometimes fails, this might work.'
	  print,' Note: shape file is the standard GIS shape file.'
	  return
	endif
 
	;-----  Open shape file and get properties  --------
	shape = obj_new('idlffshape',file)
 
	err = 1 - obj_valid(shape)
	if err ne 0 then return
 
	shape->idlffshape::getproperty, n_entities=num, entity_type=typ
 
	if keyword_set(noplot) then begin
	  obj_destroy, shape
	  return
	endif
 
	;------  Set defaults  ------------------
	if n_elements(clr) gt 0 then begin	; Main plot color.
	  lst_clr = n_elements(clr)-1
	  cflag = 1
	endif else cflag=0
	if n_elements(oclr) gt 0 then begin	; Outline plot color.
	  ocflag = 1
	endif else ocflag=0
	if n_elements(thk) eq 0 then thk=!p.thick
	if n_elements(lstyl) eq 0 then lstyl=!p.linestyle
 
 
	;-----  Loop through entities and plot  ------------
	case typ of
 
3:	begin
	  if not keyword_set(quiet) then print,' Polyline plot.'
	  if cflag eq 0 then begin		; Do polyline.
	    clr = !p.color			; Use default color.
	  endif
	  for i=0L,num-1 do begin		; Loop through ent.
	    ent = shape->idlffshape::getentity(i) ; Grab i'th.
	    xy = *ent.vertices			; Get vertices.
	    dim = size(xy,/dim)			; Dimensions.
	    lst = dim(1)			; Last index.
	    np = ent.n_parts			; # parts.
	    parts = [*ent.parts,lst]		; Get index table.
	    for j=0L,np-1 do begin		; Loop through parts.
	      lo = parts(j)			; Start index.
	      hi = parts(j+1)-1			; End index.
	      plots, xy(0,lo:hi),xy(1,lo:hi),col=clr,thick=thk, $
		linestyle=lstyl, noclip=0
	    endfor  ; j
	  endfor  ; i
	end
 
5:	begin
	  if not keyword_set(quiet) then print,' Polygon plot.'
	  ;-----  Fill polygons  -----------
	  if cflag then begin				; Do polyfill.
	    for i=0L,num-1 do begin			; Loop through ent.
	      ent = shape->idlffshape::getentity(i)	; Grab i'th.
	      xy = *ent.vertices			; Get vertices.
	      if keyword_set(devfill) then begin
		xy = convert_coord(xy,/data,/to_dev)
		dflag = 1
	      endif else dflag=0
	      dim = size(xy,/dim)			; Dimensions.
	      lst = dim(1)				; Last index.
	      np = ent.n_parts				; # parts.
	      parts = [*ent.parts,lst]			; Get index table.
	      c = clr(i<lst_clr)			; Plot color.
	      for j=0L,np-1 do begin			; Loop through parts.
	        lo = parts(j)				; Start index.
	        hi = parts(j+1)-1			; End index.
	        polyfill, xy(0,lo:hi),xy(1,lo:hi),col=c, $
		  dev=dflag, noclip=0			; Plot.
	      endfor  ; j
	    endfor
	  endif
	  ;-----  Outlines  -----------
	  if ocflag then begin				; Do polyfill.
	    for i=0L,num-1 do begin			; Loop through ent.
	      ent = shape->idlffshape::getentity(i)	; Grab i'th.
	      xy = *ent.vertices			; Get vertices.
	      dim = size(xy,/dim)			; Dimensions.
	      lst = dim(1)				; Last index.
	      np = ent.n_parts				; # parts.
	      parts = [*ent.parts,lst]			; Get index table.
	      for j=0L,np-1 do begin			; Loop through parts.
	        lo = parts(j)				; Start index.
	        hi = parts(j+1)-1			; End index.
	        plots, xy(0,lo:hi),xy(1,lo:hi),col=oclr,thick=thk, $
		  linestyl=lstyl, noclip=0
	      endfor  ; j
	    endfor
	  endif
	end
else:	begin
	  print,' Entities of type '+strtrim(typ,2)+' not yet handled.'
	  err = 2
	end
	endcase
 
	obj_destroy, shape
 
	end

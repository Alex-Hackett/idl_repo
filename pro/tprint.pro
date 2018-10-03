;-------------------------------------------------------------
;+
; NAME:
;       TPRINT
; PURPOSE:
;       Turn print statements into a text array.
; CATEGORY:
; CALLING SEQUENCE:
;       tprint,a1,a2,a3,...
; INPUTS:
;       a1,a2,a3,... = args to tprint.  in
;         May have up to 15.
; KEYWORD PARAMETERS:
;       Keywords:
;         /INIT Clear internal text array.
;           May also give an initial text array: INIT=txt.
;         ADD=txt Add given text array to internal text.
;         OUT=txt Return internal text array.
;         /PRINT print internal text array.
;         SAVE=file  Save internal text array in a text file.
;         /REVERSE reverse text array order (for /PRINT, OUT=, or SAVE=).
;         ERROR=err 0=ok, 1=error if OUT or /PRINT used with no text.
; OUTPUTS:
; COMMON BLOCKS:
;       tprint_com
; NOTES:
;       Notes: Intended to make it easy to take a set of print
;         statements in a program and change them to build up
;         a text array.  Uses the IDL string function in place
;         of the print statement to handle the arguments.  Can
;         then return the text array built up from multiple
;         tprint calls and use it elsewhere.
; MODIFICATION HISTORY:
;       R. Sterner, 2000 Aug 17
;       R. Sterner, 2001 Mar 21 --- Added /REVERSE flag.
;       R. Sterner, 2001 May 25 --- Allowed INIT=txt to start with text.
;       R. Sterner, 2001 May 25 --- Added new keyword: ADD=txt to add text.
;       R. Sterner, 2001 May 30 --- Added new keyword: SAVE=file to save text.
;       R. Sterner, 2004 May 20 --- Dropped execute to allow in IDL VM.
;
; Copyright (C) 2000, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
	pro tprint, p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15, $
	  init=init,out=out, print=print, error=err, reverse=rev, $
	  add=add, save=save, help=hlp
 
	common tprint_com, txt, flag
 
	if keyword_set(hlp) then begin
	  print,' Turn print statements into a text array.'
	  print,' tprint,a1,a2,a3,...'
	  print,'   a1,a2,a3,... = args to tprint.  in'
	  print,'     May have up to 15.'
	  print,' Keywords:'
	  print,'   /INIT Clear internal text array.'
	  print,'     May also give an initial text array: INIT=txt.'
	  print,'   ADD=txt Add given text array to internal text.'
	  print,'   OUT=txt Return internal text array.'
	  print,'   /PRINT print internal text array.'
	  print,'   SAVE=file  Save internal text array in a text file.'
	  print,'   /REVERSE reverse text array order (for /PRINT, OUT=, or SAVE=).'
	  print,'   ERROR=err 0=ok, 1=error if OUT or /PRINT used with no text.'
	  print,' Notes: Intended to make it easy to take a set of print'
	  print,'   statements in a program and change them to build up'
	  print,'   a text array.  Uses the IDL string function in place'
	  print,'   of the print statement to handle the arguments.  Can'
	  print,'   then return the text array built up from multiple'
	  print,'   tprint calls and use it elsewhere.'
	  return
	endif
 
	if n_elements(flag) eq 0 then flag=0	; No text yet flag.
 
	;--------  Init internal text array  --------------
	if n_elements(init) gt 0 then begin	; Anything in INIT?
	  if (n_elements(init) eq 1) and (init(0) eq '1') then begin
	    flag = 0				; Set no text flag.
	  endif else begin
	    txt = init				; Start with given text.
	    flag = 1				; Set have text flag.
	  endelse
	endif
 
	;--------  Save internal text array  -------------
	if n_elements(save) ne 0 then begin	; Have a file name for save.
	  if flag eq 0 then begin		; If no text return error.
	    err = 1
	    return
	  endif
	  if keyword_set(rev) then tt=reverse(txt) else tt=txt
	  openw,lun,save,/get_lun		; Open save file.
	  for i=0,n_elements(tt)-1 do printf,lun,tt(i)	; Print text.
	  free_lun,lun
	  print,' Text saved to '+save
	  err = 0				; OK.
	endif
 
	;--------  Print internal text array  -------------
	if keyword_set(print) then begin
	  if flag eq 0 then begin		; If no text return error.
	    err = 1
	    return
	  endif
	  if keyword_set(rev) then tt=reverse(txt) else tt=txt
	  for i=0,n_elements(tt)-1 do print,tt(i)	; Print text.
	  err = 0				; OK.
	endif
 
	;--------  Return internal text array  ------------
	if arg_present(out) then begin		; Return text requested.
	  if flag eq 0 then begin
	    err = 1
	    return
	  endif
	  err = 0
	  if keyword_set(rev) then tt=reverse(txt) else tt=txt
	  out = tt
	  return
	endif
 
	;--------  Add given text array to internal text  ------
	if n_elements(add) ne 0 then begin
	  if flag eq 0 then txt=add else txt=[txt,add]	; Add it to array.
	  flag = 1			; Flag array as existing.
	  return
	endif
	  
	;--------  Add to internal text array  -------------
	n = n_params(0)			; How many args?
	if n eq 0 then return		; None, nothing to do.
 
	case n of
1:	p = string(p1)
2:	p = string(p1,p2)
3:	p = string(p1,p2,p3)
4:	p = string(p1,p2,p3,p4)
5:	p = string(p1,p2,p3,p4,p5)
6:	p = string(p1,p2,p3,p4,p5,p6)
7:	p = string(p1,p2,p3,p4,p5,p6,p7)
8:	p = string(p1,p2,p3,p4,p5,p6,p7,p8)
9:	p = string(p1,p2,p3,p4,p5,p6,p7,p8,p9)
10:	p = string(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10)
11:	p = string(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11)
12:	p = string(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12)
13:	p = string(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13)
14:	p = string(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14)
15:	p = string(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15)
	endcase
 
;	cmd = 'p = string('		; Build up command string.
;	s = ''
;	for i=1,n do begin		; Tack on each arg.
;	  t = 'p'+strtrim(i,2)
;	  if i lt n then t=t+',' else t=t+')'
;	  s = s + t
;	endfor
;	cmd = cmd + s			; Complete command.
;print,'n = ',n
;print,'cmd = ',cmd 
;	err = execute(cmd)		; Build print string.
 
	if flag eq 0 then txt=p else txt=[txt,p]	; Add it to array.
	flag = 1			; Flag array as existing.
 
	end

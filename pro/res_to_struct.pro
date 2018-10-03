;-------------------------------------------------------------
;+
; NAME:
;       RES_TO_STRUCT
; PURPOSE:
;       Read a RES file into a structure.
; CATEGORY:
; CALLING SEQUENCE:
;       res_to_struct, resfile, struct
; INPUTS:
;       resfile = name of RES file.  in
; KEYWORD PARAMETERS:
;       Keywords:
;         ERROR=err error flag: 0=ok.
;         /NOCOMMENTS means do not incude RES file comments in
;           returned structure.
; OUTPUTS:
;       struct = returned structure. out
; COMMON BLOCKS:
; NOTES:
;       Notes: Comments are included in tags named
;         _comm001, _comm002, ... where number of digits
;         depends on length res file header.
; MODIFICATION HISTORY:
;       R. Sterner, 2003 Aug 20
;       R. Sterner, 2004 Jun 28 --- Fixed ndig calculation.
;       R. Sterner, 2004 Jun 28 --- Fixed to allow overwrite if 0.
;
; Copyright (C) 2003, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
	pro res_to_struct, resfile, s, error=err, $
	  nocomments=nocom, help=hlp
 
	if (n_params(0) lt 2) or keyword_set(hlp) then begin
	  print,' Read a RES file into a structure.'
	  print,' res_to_struct, resfile, struct'
	  print,'   resfile = name of RES file.  in'
	  print,'   struct = returned structure. out'
	  print,' Keywords:'
	  print,'   ERROR=err error flag: 0=ok.'
	  print,'   /NOCOMMENTS means do not incude RES file comments in'
	  print,'     returned structure.'
	  print,' Notes: Comments are included in tags named'
	  print,'   _comm001, _comm002, ... where number of digits'
	  print,'   depends on length res file header.'
	  return
	endif
 
	;-----  Check incoming structure  ------
	if n_elements(s) ne 0 then begin
	  if datatype(s) eq 'STC' then begin
	    print,' Error in res_to_struct: Structure already exists,'
	    print,'   cannot overwrite.  Set structure to 0 to overwrite.'
	    err = -1
	    return
	  endif
	endif
 
	;-----  Open RES file  -----------
	resopen,resfile,err=err,header=h
	if err ne 0 then return
 
	;-----  Set up to deal with any RES file comments  ----
	c1 = strmid(h,0,1)				; Grab first char.
	w = where(c1 eq '*',cnt)			; Get # comments.
	ndig = strtrim(ceil(alog10(1+cnt)),2)		; Digits in comments.
	fmt = '(I'+ndig+'.'+ndig+')'			; Format for digits.
	ccnt = -1					; Comments counter.
	cmt = '_COMM'					; Comment front.
 
	;-----  Loop through header entries  --------
	new_flag = 1					; Structure starts new.
	n = n_elements(h)-1
	for i=0,n-1 do begin
	  resget,tag,val,number=i			; Grab i'th file item.
	  if strmid(tag,0,1) eq '*' then cflag=1 $	; Check if comment.
	    else cflag=0
	  ;----  Comment  ------
	  if cflag then begin				; Deal with a comment.
	    if keyword_set(nocom) then continue		; Ignore.
	    ccnt = ccnt + 1				; Comment counter.
	    val = strmid(tag,1,999)			; Drop leading *.
	    tag = cmt+string(ccnt,form=fmt)		; Make structure tag.
	  endif
	  if new_flag then begin			; Create structure.
	    s = create_struct(tag,val)			;   First time only.
	    new_flag = 0				; No longer new.
	  endif else begin
	    s = create_struct(s,tag,val)		; Add new item.
	  endelse
	endfor
 
	end

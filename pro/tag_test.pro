;-------------------------------------------------------------
;+
; NAME:
;       TAG_TEST
; PURPOSE:
;       Test if given tag is in given structure.
; CATEGORY:
; CALLING SEQUENCE:
;       flag = tag_test(ss, tag)
; INPUTS:
;       ss = given structure.       in
;       tag = given tag.            in
; KEYWORD PARAMETERS:
; OUTPUTS:
;       flag = test result:         out
;          0=tag not found, 1=tag found.
; COMMON BLOCKS:
; NOTES:
;       Note: useful for testing if tag occurs. Example:
;         if tag_test(ss,'cmd') then call_procedure,ss.cmd
; MODIFICATION HISTORY:
;       R. Sterner, 1998 Jun 30
;
; Copyright (C) 1998, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
	function tag_test, ss, tag, help=hlp
 
	if (n_params(0) lt 2) or keyword_set(hlp) then begin
	  print,' Test if given tag is in given structure.'
	  print,' flag = tag_test(ss, tag)'
	  print,'   ss = given structure.       in'
	  print,'   tag = given tag.            in'
	  print,'   flag = test result:         out'
	  print,'      0=tag not found, 1=tag found.'
	  print,' Note: useful for testing if tag occurs. Example:'
	  print,"   if tag_test(ss,'cmd') then call_procedure,ss.cmd"
	  return,''
	endif
 
	return, max(tag_names(ss) eq strupcase(tag))
 
	end

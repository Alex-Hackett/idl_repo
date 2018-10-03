;-------------------------------------------------------------
;+
; NAME:
;       TYP2NUM
; PURPOSE:
;       Convert a datatype description to equivalent numeric item.
; CATEGORY:
; CALLING SEQUENCE:
;       num = typ2num(txt)
; INPUTS:
;       txt = datatype description in a text string.   in
; KEYWORD PARAMETERS:
;       Keywords:
;         BITS=bits Total number of bits in given item.
;         ERROR=err  Error flag: 0=ok, else error.
;         /QUIET  Do not print error message.
; OUTPUTS:
;       num = equivalent numeric item.                 out
; COMMON BLOCKS:
; NOTES:
;       Note: datatypes are: BYT, INT, LON, FLT, DBL, COMPLEX,
;         DCOMPLEX, UINT, ULON, LON64, ULON64.
;         Any array dimensions follow the data type in parantheses.
;         Examples: "UINT","FLT","BYT(3,4)","LON(100)".
;         Roughly the inverse of datatype.  Note array syntax is
;         not quite like the IDL array functions, use byt(3,4)
;         for this routine instead of bytarr(3,4).
;         Data type STR is also allowed.  Data types may be
;         abbreviated: B, I, L, F, D, C, DC, UI, UL, L64, UL64, S.
; MODIFICATION HISTORY:
;       R. Sterner, 2002 Oct 10
;       R. Sterner, 2003 Aug 26 --- Allowed abbreviations, added STR,
;       also fixed (u)long60 -> (u)lon64.
;
; Copyright (C) 2002, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
	function typ2num, input, bits=bits, error=err, quiet=quiet, help=hlp
 
	if (n_params(0) lt 1) or keyword_set(hlp) then begin
	  print,' Convert a datatype description to equivalent numeric item.'
	  print,' num = typ2num(txt)'
	  print,'   txt = datatype description in a text string.   in'
	  print,'   num = equivalent numeric item.                 out'
	  print,' Keywords:'
	  print,'   BITS=bits Total number of bits in given item.'
	  print,'   ERROR=err  Error flag: 0=ok, else error.'
	  print,'   /QUIET  Do not print error message.'
	  print,' Note: datatypes are: BYT, INT, LON, FLT, DBL, COMPLEX,'
	  print,'   DCOMPLEX, UINT, ULON, LON64, ULON64.'
	  print,'   Any array dimensions follow the data type in parantheses.'
	  print,'   Examples: "UINT","FLT","BYT(3,4)","LON(100)".'
	  print,'   Roughly the inverse of datatype.  Note array syntax is'
	  print,'   not quite like the IDL array functions, use byt(3,4)'
	  print,'   for this routine instead of bytarr(3,4).'
	  print,'   Data type STR is also allowed.  Data types may be'
	  print,'   abbreviated: B, I, L, F, D, C, DC, UI, UL, L64, UL64, S.'
	  return,''
	endif
 
	;----------------------------------------------------------
	;  Get datatype and any dimensions
	;----------------------------------------------------------
	p = strpos(input,'(')		; Position of opening paren if any.
	;---  Array  ----------
	if p ge 0 then begin			; Dimension was given.
	  typ = strupcase(strmid(input,0,p))	; Datatype.
	  dim = 'ARR'+strmid(input,p,99)	; Dimensions.
	;---  Scalar  ----------
	endif else begin			; No dimension given.
	  typ = strupcase(input)		; Datatype.
	  dim = ''				; Null dimension.
	endelse
	typ = strtrim(typ,2)			; Drop any excess whitespace.
 
	;----------------------------------------------------------
	;  Deal with abbreviations
	;----------------------------------------------------------
	case typ of
'B':	typ = 'BYT'
'I':	typ = 'INT'
'L':	typ = 'LON'
'F':	typ = 'FLT'
'D':	typ = 'DBL'
'C':	typ = 'COMPLEX'
'DC':	typ = 'DCOMPLEX'
'UI':	typ = 'UINT'
'UL':	typ = 'ULON'
'L64':	typ = 'LON64'
'UL64':	typ = 'ULON64'
'S':	typ = 'STR'
else:
	endcase
	  
	;----------------------------------------------------------
	;  Find bits and set scalar value
	;----------------------------------------------------------
	case typ of
'BYT':	   begin
	     num2 = 0B
	     nbits = 8
	   end
'INT':	   begin
	     num2 = 0
	     nbits = 16
	   end
'LON':     begin
	     num2 = 0L
	     nbits = 32
	   end
'FLT':     begin
	     num2 = 0.0
	     nbits = 32
	   end
'DBL':     begin
	     num2 = 0D0
	     nbits = 64
	   end
'COMPLEX': begin
	     num2 = complex(0.,0.)
	     nbits = 64
	   end
'DCOMPLEX':begin
	     num2 = dcomplex(0D0,0D0)
	     nbits = 128
	   end
'UINT':	   begin
	     num2 = 0U
	     nbits = 16
	     end
'ULON':    begin
	     num2 = 0UL
	     nbits = 32
	   end
'LON64':  begin
	     num2 = 0LL
	     nbits = 64
	   end
'ULON64': begin
	     num2 = 0ULL
	     nbits = 64
	   end
'STR':	   begin
	     num2 = ''
	     nbits = 0
	   end
else:	   begin
	     if not keyword_set(quiet) then $
	       print,' Unknown numeric datatype: ',typ
	     err = 1
	     return,''
	   end
	endcase
 
	;----------------------------------------------------------
	;  Create numeric item and compute total bits
	;----------------------------------------------------------
	;---------  Scalar item  ----------------
	if dim eq '' then begin
	  err = 0
	  bits = nbits				; Copy # bits.
	  return, num2				; Return scalar number.
	;--------  Array  ------------------------
	endif else begin
	  err = 1 - execute('num='+typ+dim)	; Create array.
	  if err ne 0 then return, 0		; Error.
	  bits = nbits*n_elements(num)		; Total # bits.
	  return, num				; Return array.
	endelse
 
	end

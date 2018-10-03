;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+
;
;*NAME:
;	XBITS
;
;*PURPOSE:
; ROUTINE TO EXTRACT BITS AND OPTIONALLY RETURN THEM AS A STRING
;
;*CALLING SEQUENCE:
;	FUNCTION XBITS,P,WORD,BIT1,BIT2,FORMAT
;
;*MODIFICATION HISTORY:
;    Mar 3 1991 	JKF/ACC         moved to GHRS DAF (version 2 IDL)
;-
;-------------------------------------------------------------------------------
FUNCTION XBITS,P,WORD,BIT1,BIT2,FORMAT

;
X = LONG(P(WORD))
;
; shift right and zero upper order bits
;
x = ishft(x,bit1) and 65535L
;
; shift left into correct position
;
x = ishft(x,bit2-bit1-15) and 65535L
if n_params(0) lt 5 then return,x else return,string(x,'('+format+')')
end

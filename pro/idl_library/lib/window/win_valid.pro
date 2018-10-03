;+
; $Id: win_valid.pro,v 1.1 2001/11/05 22:16:03 mccannwj Exp $
;
; NAME:
;     WIN_VALID
;
; PURPOSE:
;     Determine if a particular window is open.
;
; CATEGORY:
;     ACS/Windows
;
; CALLING SEQUENCE:
;     result = WIN_VALID(index)
; 
; INPUTS:
;     index - window index
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;     result - returns 1 if open, 0 otherwise.
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;       Thu Jun 15 21:31:16 2000, William Jon McCann
;       <mccannwj@acs13.+ball.com>
;-
FUNCTION win_valid, windex
   COMPILE_OPT IDL2
   
   saved_device = !D.NAME
   CASE STRUPCASE(!VERSION.OS_FAMILY) OF
      'WINDOWS': SET_PLOT, 'WIN'
      'MACOS': SET_PLOT, 'MAC'
      ELSE: SET_PLOT, 'X'
   ENDCASE
   DEVICE, WINDOW_STATE=windows
   SET_PLOT, saved_device

   IF N_ELEMENTS( windex ) LE 0 THEN return, 0
   IF windex LT 0 THEN return, 0
   IF N_ELEMENTS( windows ) LE windex THEN return, 0

   return, windows[ windex ]
END 

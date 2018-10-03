;+
; $Id: random_subscripts.pro,v 1.1 2001/11/05 21:39:01 mccannwj Exp $
;
; NAME:
;     RANDOM_SUBSCRIPTS
;
; PURPOSE:
;     Produce uniformly distributed random image subscripts.
;
; CATEGORY:
;     ACS/Misc
;
; CALLING SEQUENCE:
;     result = RANDOM_SUBSCRIPTS(n_pixels, n_subscripts)
;
; INPUTS:
;     n_pixels     - (INTEGER) set the maximum allowed subscript value
;     n_subscripts - (INTEGER) set the number of desired subscripts
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;     result - list of computed random subscripts
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
;       Thu Jun 15 21:30:24 2000, William Jon McCann
;       <mccannwj@acs13.+ball.com>
;-

FUNCTION random_subscripts, n_pixels, n_subscripts
   COMPILE_OPT IDL2

   IF N_PARAMS() NE 2 THEN PRINT, 'usage: subs=random_subscripts(n_pix, n_subs)'
   n_subscripts = n_subscripts < n_pixels
   rand_index = LONG( RANDOMU( seed, n_subscripts ) * n_pixels )
   subscripts = rand_index[ UNIQ( rand_index ) ]

   return, subscripts
END

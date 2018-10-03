;+
; $Id: win_hilight_region.pro,v 1.1 2001/11/05 22:16:03 mccannwj Exp $
;
; NAME:
;     WIN_HILIGHT_REGION
;
; PURPOSE:
;
; CATEGORY:
;     ACS/JHU
;
; CALLING SEQUENCE:
; 
; INPUTS:
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;
; OUTPUTS:
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
;       Thu Jun 15 21:29:26 2000, William Jon McCann
;       <mccannwj@acs13.+ball.com>
;-

PRO win_hilight_region, xscripts, yscripts
   COMPILE_OPT IDL2, HIDDEN

   saved_device = !D.NAME
   CASE STRUPCASE(!VERSION.OS_FAMILY) OF
      'WINDOWS': SET_PLOT, 'WIN'
      'MACOS': SET_PLOT, 'MAC'
      ELSE: SET_PLOT, 'X'
   ENDCASE
   DEVICE, GET_GRAPHICS=oldg, SET_GRAPHICS=6

   edge_image = MAKE_ARRAY( MAX(xscripts), MAX(yscripts), /BYTE )

   edge_image[ xscripts, yscripts ] = 1b

   edges = WHERE( SOBEL( edge_image ) GT 0, ecount )

   image_sz = SIZE( edge_image )
   xscripts = edges MOD image_sz[1]
   yscripts = edges / LONG(image_sz[1] )
   
   PLOTS, xscripts, yscripts, /DEVICE

   DEVICE, SET_GRAPHICS=oldg
   SET_PLOT, saved_device
END

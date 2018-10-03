;+
; $Id: acs_unscramble.pro,v 1.2 2000/09/26 19:53:03 mccannwj Exp $
;
; NAME:
;     ACS_UNSCRAMBLE
;
; PURPOSE:
;     This function unscrambles the pixel data to be from one orientation
;     and positions the amplifier data into a matrix format as though one
;     was looking at the detector.
;
; CATEGORY:
;     ACS/Acquisition
;
; CALLING SEQUENCE:
;     ACS_UNSCAMBLE, amp_select, image
; 
; INPUTS:
;     amp_select - string amp selection (e.g. 'ABCD')
;     image - image to be unscambled
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;     image - unscambled image
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
;     Data is read from amplifiers in the following pixel orders:
;          A  starts with pixel (0,0) runs increasing Y then increasing X
;          B  starts with pixel (0,N) runs decreasing Y then increasing X
;          C  starts with pixel (N,0) runs increasing Y then decreasing X
;          D  starts with pixel (N,N) runs decreasing Y then decreasing X
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;	version 1  By D. Lindler from algorithm in routine unscramble.pro
;		by S.E.ROSS
;
;-
PRO acs_unscramble, amp_select, image

                    ; Define Amp rotations (as per IDL function
                    ; 'rotate') to convert to detector coordinates
   A_ROT = 0
   B_ROT = 5        ; flip x axis
   C_ROT = 7        ; flip y axis
   D_ROT = 2        ; flip x & Y axes

                    ; get sizes
   s = SIZE(image)
   nx = s[1]
   ny = s[2]
   n = nx*ny
   n2 = n/2
   n4 = n/4
   nx2 = nx/2
   ny2 = ny/2

                    ; unscamble based on amp selection
   CASE STRTRIM(amp_select) OF
      'ABCD' : BEGIN
         out = FLTARR(nx,ny,/NOZERO)
         out(0,0)     = ROTATE(image(0:nx2-1,0:ny2-1), A_ROT)
         out(nx2,0)   = ROTATE(image(nx2:*,0:ny2-1),   B_ROT)
         out(0,ny2)   = ROTATE(image(0:nx2-1,ny2:*),   C_ROT)
         out(nx2,ny2) = ROTATE(image(nx2:*,ny2:*),     D_ROT)
      end
      'AB' : begin
         out = FLTARR(nx,ny,/NOZERO)
         out(0,0)     = ROTATE(image(0:nx2-1,*), A_ROT)
         out(nx2,0)   = ROTATE(image(nx2:*,*),   B_ROT)
      end
      'AC' : begin
         out = FLTARR(nx,ny,/NOZERO)
         out(0,0)     = ROTATE(image(*,0:ny2-1), A_ROT)
         out(0,ny2)   = ROTATE(image(*,ny2:*),   C_ROT)
      end
      'AD' : begin
         out = FLTARR(nx,ny,/NOZERO)
         out(0,0)     = ROTATE(image(*,0:ny2-1), A_ROT)
         out(0,ny2)   = ROTATE(image(*,ny2:*),   D_ROT)
      end
      'BC' : begin
         out = FLTARR(nx,ny,/NOZERO)
         out(0,0)     = ROTATE(image(*,0:ny2-1), B_ROT)
         out(0,ny2)   = ROTATE(image(*,ny2:*),   C_ROT)
      end
      'BD' : begin
         out = FLTARR(nx,ny,/NOZERO)
         out(0,0)     = ROTATE(image(*,0:ny2-1), B_ROT)
         out(0,ny2)   = ROTATE(image(*,ny2:*),   D_ROT)
      end
      'CD' : begin
         out = FLTARR(nx,ny,/NOZERO)
         out(0,0)     = ROTATE(image(0:nx2-1,*), C_ROT)
         out(nx2,0)   = ROTATE(image(nx2:*,*),   D_ROT)
      end
      'A' : out = ROTATE(TEMPORARY(image),A_ROT)
      'B' : out = ROTATE(TEMPORARY(image),B_ROT)
      'C' : out = ROTATE(TEMPORARY(image),C_ROT)
      'D' : out = ROTATE(TEMPORARY(image),D_ROT)
      ELSE: BEGIN
         PRINT, 'ACS_UNSCRAMBLE: Illegal amp selection'
         PRINT, '                No unscrambling done'
         out = TEMPORARY(image)
      END
   ENDCASE

   image = TEMPORARY(out)
   return
END

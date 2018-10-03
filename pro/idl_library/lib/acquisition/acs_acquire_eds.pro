;+
; $Id: acs_acquire_eds.pro,v 1.3 2000/09/26 15:35:37 mccannwj Exp $
;
; NAME:
;     ACS_ACQUIRE_EDS
;
; PURPOSE:
;     Subroutine of ACS_ACQUIRE to populate engineering data snapshot
;     headers.
;
; CATEGORY:
;     ACS/Acquisition
;
; CALLING SEQUENCE:
;     ACS_ACQUIRE_EDS, eds, header
;
; INPUTS:
;     eds - 350 word engineering snapshot
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;     header - FITS header
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
;	version 1: D. Lindler  June, 1998
;
;-
PRO acs_acquire_eds, eds, h

                    ; common block data set up by ACS_ACQUIRE_SETUP
@acs_acquire_common.pro

                    ; create blank header
   h = [ename(0:N_ELEMENTS(ename)-6),'END']+'        '

; extract each parameter for snapshot and pull out correct bits which
; may cross word boundaries
   FOR i=0,N_ELEMENTS(ename)-6 do begin
      if position(i) lt 0 then goto,nexti ;shp item?
      ipos = position(i) ;word position
      b1 = bit1(i)  ;first bit
      nb = nbits(i) ;nbits
      val = 0L      ;output value
;
; loop on 16 bit telemetry values until all bits are extracted
;
      WHILE nb GT 0 DO BEGIN
         b2 = (b1+nb-1)<15 ;last bit to get from this word
         nbx = (b2-b1+1) ;bits to extract from this word
         x = LONG( eds( LONG(ipos) ) ) ;value of word to extract from
         x = ishft(x,b1) and 65535L ; shift right and zero upper bits
         x = ishft(x,b2-b1-15) ;shift back into position
         val = ishft(val,nbx) + x
         nb = nb-nbx ;number of bits left
         b1 = 0     ;starting bit in next word
         ipos = ipos + 1 ;move to next word
      ENDWHILE
;
; apply telemetry conversion to real units
;
      pos = convpos(i) ;position in conversion table
      CASE conversion(pos) OF
         'P' : BEGIN ;polynomial
            IF (val ne 0.0) THEN BEGIN
               n = fix(conversion(pos+1))
               coef = double(conversion(pos+2:pos+n+1))
;;;			    val = (double(val)-128)
               val = double(val)
               sval = coef(0)
               for j=1,n-1 do sval = sval + coef(j)*val^j
               val = float(sval)
            ENDIF 
         END
         'L' : BEGIN ;line segments
            n = fix(conversion(pos+1))
            telem = float(conversion(pos+2:pos+1+n))
            physical = float(conversion(pos+2+n:pos+1+2*n))
            if (val ne 0.0) or (val ge telem(0)) then begin
               val = interpol(physical,telem,val)
               val = val(0)
            ENDIF
         END
         'R' : BEGIN ;range lookup
            n = fix(conversion(pos+1))
            mins = fix(conversion(pos+2:pos+1+n))
            maxs = fix(conversion(pos+2+n:pos+1+2*n))
            physical = conversion(pos+2+2*n:pos+1+3*n)
            good = where((val ge mins) and (val le maxs),ngood)
            if ngood gt 0 then val = physical(good(0)) $
            else val = 'UNDEFINED'
         END
         ELSE:
      ENDCASE
      sxaddpar,h,ename(i),val,ecomments(i)
nexti:
   ENDFOR

   return
END

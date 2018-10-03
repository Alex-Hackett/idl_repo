;+
; $Id: acs_acquire_shp.pro,v 1.3 2000/09/26 15:00:04 mccannwj Exp $
;
; NAME:
;     ACS_ACQUIRE_SHP
;
; PURPOSE:
;     Subroutine of ACS_ACQUIRE to get detector temperatures from the
;     standard header packets.
;
; CATEGORY:
;     ACS/Acquisition
;
; CALLING SEQUENCE:
;     ACS_ACQUIRE_SHP, packet_header, data
; 
; INPUTS:
;     packet_header - Raw packet header words
;     data          - packet data without header or sync words
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
;     Those defined in ACS_ACQUIRE_COMMON
;
; SIDE EFFECTS:
;     Modifies shpvals in ACS_ACQUIRE common block
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;	12/15/98 - modified locations of shp words to one less.
;
;-
PRO acs_acquire_shp, packet_header, data

@acs_acquire_common
;
; extract raw data values
;
   words = [21,41,61,81,101]-1 ;shp word locations
   names = ['JHDETMP1','JHDETMP2','JWDETMP1','JWDETMP2','JMTUBET']
   vals = data(words)
   shpvals = FLTARR(5)
;
; determine dump time
;
   shptime = jul_date(acs_time(packet_header(8:10),0,0,zero_time))+0.5
;
; convert to physical units
;
   PRINT, vals
   FOR i=0,N_ELEMENTS(names)-1 DO BEGIN
      val = vals(i)
      ipos = WHERE(ename eq names(i)) & ipos = ipos(0)
                    ;
; apply telemetry conversion to real units
;
      pos = convpos(ipos) ;position in conversion table
      CASE conversion(pos) OF
         'P' : BEGIN ; polynomial
            IF (val NE 0.0) THEN BEGIN
               n = FIX(conversion(pos+1))
               coef = DOUBLE(conversion(pos+2:pos+n+1))
               val = DOUBLE(val)
               sval = coef(0)
               FOR j=1,n-1 DO sval = sval + coef(j)*val^j
               val = FLOAT(sval)
            ENDIF
         END
         'L' : BEGIN ; line segments
            n = FIX(conversion(pos+1))
            telem = FLOAT(conversion(pos+2:pos+1+n))
            physical = FLOAT(conversion(pos+2+n:pos+1+2*n))
            if (val ne 0.0) or (val ge telem(0)) then begin
               val = INTERPOL(physical,telem,val)
               val = val(0)
            ENDIF
         END
         'R' : BEGIN ; range lookup
            n = FIX(conversion(pos+1))
            mins = FIX(conversion(pos+2:pos+1+n))
            maxs = FIX(conversion(pos+2+n:pos+1+2*n))
            physical = conversion(pos+2+2*n:pos+1+3*n)
            good = WHERE((val ge mins) and (val le maxs),ngood)
            IF ngood GT 0 THEN val = physical(good(0)) $
            ELSE val = 'UNDEFINED'
         END
         ELSE:
      ENDCASE
      shpvals[i] = val
   ENDFOR

   PRINT, shpvals
   return
END

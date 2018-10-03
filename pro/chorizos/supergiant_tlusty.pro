FUNCTION SUPERGIANT_TLUSTY, t
;
; This function provides an approximate value for the gravity (in cgs units)
;  of a supergiant star as a function of temperature (in K) based on the
;  Martins et al. (2005) calibration. Results are modified in order to let 
;  them be covered by the TLUSTY OSTAR2002+BSTAR2006 grids and to let g(T) be a 
;  continuous function in that grid so THEY SHOULD NOT be taken to be 
;  completely accurate (i.e. differences of the order of hundredths of cgs 
;  units with Martins et al. 2005 should be expected, especially at the high
;  temperature end).
;
IF MIN(t) LT 15000. OR MAX(t) GT 55000. THEN BEGIN
 PRINT, 'Incorrect value of the temperature found in SUPERGIANT_TLUSTY'
 RETURN, 0*t
ENDIF
g = (2.00+1.25*(t-15000.)/15000.)*(t LT 30000.                ) + $
    (3.25+0.50*(t-30000.)/10000.)*(t GE 30000. AND t LT 40000.) + $
    (3.75+0.25*(t-40000.)/ 5000.)*(t GE 40000. AND t LT 45000.) + $
     4.00                        *(t GE 45000.                )
RETURN, g
END

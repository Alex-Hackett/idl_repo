FUNCTION MAIN_SEQUENCE_TLUSTY, t
;
; This function provides an approximate value for the gravity (in cgs units)
;  of a main sequence star as a function of temperature (in K) based on the
;  Martins et al. (2005) calibration. Results are modified in order to let 
;  them be covered by the TLUSTY OSTAR2002+BSTAR2006 grids and to let g(T) be a 
;  continuous function in that grid so THEY SHOULD NOT be taken to be 
;  completely accurate (i.e. differences of the order of hundredths of cgs 
;  units with Martins et al. 2005 should be expected, especially at the high
;  temperature end).
;
IF MIN(t) LT 15000. OR MAX(t) GT 55000. THEN BEGIN
 PRINT, 'Incorrect value of the temperature found in MAIN_SEQUENCE_TLUSTY'
 RETURN, 0*t
ENDIF
g =  3.92                        *(t LT 42500.                ) + $
    (3.92+0.08*(t-42500.)/ 2500.)*(t GE 42500. AND t LT 45000.) + $
     4.00                        *(t GE 45000.                )
RETURN, g
END

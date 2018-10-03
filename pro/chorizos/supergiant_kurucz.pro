FUNCTION SUPERGIANT_KURUCZ, t
;
; This function provides an approximate value for the gravity (in cgs units)
;  of a supergiant star as a function of temperature (in K) for Kurucz
;  models. The value selected is the lowest possible gravity for that 
;  temperature with the conditions that g(T) is a continuous function 
;  and is independent of metallicity. Note that the Kurucz mesh is 
;  incomplete at high temperatures and, as a consequence, the values 
;  provided by this function are overestimates of the real gravities in that 
;  range (to the point that for T > 34 000 K we have to use the same gravity 
;  as for main sequence stars, which is already too high for that luminosity 
;  type).
;
IF MIN(t) LT 3500. OR MAX(t) GT 50000. THEN BEGIN
 PRINT, 'Incorrect value of the temperature found in SUPERGIANT_KURUCZ'
 RETURN, 0*t
ENDIF
g =  0.00                        *(t LT  5500.                ) + $
    (0.00+0.50*(t- 5500.)/  500.)*(t GE  5500. AND t LT  6000.) + $
    (0.50                       )*(t GE  6000. AND t LT  7000.) + $
    (0.50+1.00*(t- 7000.)/ 1000.)*(t GE  7000. AND t LT  8000.) + $
    (1.50+0.50*(t- 8000.)/  500.)*(t GE  8000. AND t LT  8500.) + $
    (2.00                       )*(t GE  8500. AND t LT  9500.) + $
    (2.00+0.50*(t- 9500.)/ 1000.)*(t GE  9500. AND t LT 10500.) + $
    (2.50                       )*(t GE 10500. AND t LT 16000.) + $
    (2.50+0.50*(t-16000.)/ 3000.)*(t GE 16000. AND t LT 19000.) + $
    (3.00                       )*(t GE 19000. AND t LT 24000.) + $
    (3.00+0.50*(t-24000.)/ 3000.)*(t GE 24000. AND t LT 27000.) + $
    (3.50                       )*(t GE 27000. AND t LT 30000.) + $
    (3.50+0.50*(t-30000.)/ 2000.)*(t GE 30000. AND t LT 32000.) + $
    (4.00                       )*(t GE 32000. AND t LT 33000.) + $
    (4.00+0.50*(t-33000.)/ 2000.)*(t GE 33000. AND t LT 35000.) + $
    (4.50+0.50*(t-35000.)/ 5000.)*(t GE 35000. AND t LT 40000.) + $
     5.00                        *(t GE 40000.                )
RETURN, g
END
;g =  0.00                        *(t LT  5750.                ) + $
;    (0.00+0.50*(t- 5750.)/  250.)*(t GE  5750. AND t LT  6000.) + $
;    (0.50                       )*(t GE  6000. AND t LT  7500.) + $
;    (0.50+1.00*(t- 7500.)/  500.)*(t GE  7500. AND t LT  8000.) + $
;    (1.50                       )*(t GE  8000. AND t LT  8250.) + $
;    (1.50+0.50*(t- 8250.)/  250.)*(t GE  8250. AND t LT  8500.) + $
;    (2.00                       )*(t GE  8500. AND t LT 10000.) + $
;    (2.00+0.50*(t-10000.)/  500.)*(t GE 10000. AND t LT 10500.) + $
;    (2.50                       )*(t GE 10500. AND t LT 18000.) + $
;    (2.50+0.50*(t-18000.)/ 1000.)*(t GE 18000. AND t LT 19000.) + $
;    (3.00                       )*(t GE 19000. AND t LT 26000.) + $
;    (3.00+0.50*(t-26000.)/ 1000.)*(t GE 26000. AND t LT 27000.) + $
;    (3.50                       )*(t GE 27000. AND t LT 31000.) + $
;    (3.50+0.50*(t-31000.)/ 1000.)*(t GE 31000. AND t LT 32000.) + $
;    (4.00                       )*(t GE 32000. AND t LT 34000.) + $
;    (4.00+0.50*(t-34000.)/ 1000.)*(t GE 34000. AND t LT 35000.) + $
;    (4.50                       )*(t GE 35000. AND t LT 37500.) + $
;    (4.50+0.50*(t-37500.)/ 2500.)*(t GE 37500. AND t LT 40000.) + $
;     5.00                        *(t GE 40000.                )

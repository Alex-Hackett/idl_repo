FUNCTION MAIN_SEQUENCE_KURUCZ, t
;
; This function provides an approximate value for the gravity (in cgs units)
;  of a main sequence star as a function of temperature (in K) for Kurucz
;  models. Note that the Kurucz is incomplete at high temperatures and, as a
;  consequence, the values provided by this function are overestimates of
;  the gravities for real stars in that range (especially for T > 33 000 K).
;
IF MIN(t) LT 3500. OR MAX(t) GT 50000. THEN BEGIN
 PRINT, 'Incorrect value of the temperature found in MAIN_SEQUENCE_KURUCZ'
 RETURN, 0*t
ENDIF
g =  4.55                        *(t LT  4750.                ) + $
    (4.55-0.55*(t- 4750.)/ 5250.)*(t GE  4750. AND t LT 10000.) + $
    (4.00                       )*(t GE 10000. AND t LT 33000.) + $
    (4.00+0.50*(t-33000.)/ 2000.)*(t GE 33000. AND t LT 35000.) + $
    (4.50+0.50*(t-35000.)/ 5000.)*(t GE 35000. AND t LT 40000.) + $
     5.00                        *(t GE 40000.                )
RETURN, g
END
;g =  4.55                        *(t LT  4750.                ) + $
;    (4.55-0.55*(t- 4750.)/ 5250.)*(t GE  4750. AND t LT 10000.) + $
;    (4.00                       )*(t GE 10000. AND t LT 34000.) + $
;    (4.00+0.50*(t-34000.)/ 1000.)*(t GE 34000. AND t LT 35000.) + $
;    (4.50                       )*(t GE 35000. AND t LT 37500.) + $
;    (4.50+0.50*(t-37500.)/ 2500.)*(t GE 37500. AND t LT 40000.) + $
;     5.00                        *(t GE 40000.                )


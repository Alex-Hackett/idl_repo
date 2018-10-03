FUNCTION ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED,apparent_mag,d,ebv,a_band=a_band,errcalc=errcalc,error_absmag=error_absmag,error_apparent_mag=error_apparent_mag,error_d=error_d,error_aband=error_aband
;d in kpc
;if keyword A_band is set, then A_band is provided instead of ebv (i.e. A in a given band, e.g. A_V) 
rv=3.1
IF KEYWORD_SET(A_BAND) THEN BEGIN 
  a_band=ebv
  print,'A_band=',a_band 
 ENDIF ELSE BEGIN
  a_band=rv*ebv
  print,'A_V=',a_band
ENDELSE  
  
absolute_mag=apparent_mag-5.*alog10(d/0.01)-A_band


IF KEYWORD_SET(errcalc) THEN BEGIN
;error calculation is OK, cross-checked against 2003gd in Smartt 2004, 2009
 error_absmag=SQRT(error_apparent_mag^2+error_aband^2+(5.0*error_d/(alog(10.)*d))^2)
 print,'error_absmag ',error_absmag
ENDIF

return,absolute_mag

END
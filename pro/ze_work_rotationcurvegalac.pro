r=indgen(1000)/50.

;clemens 1985
   tetarcl=350*exp(-r/20-1.9/r)+770*exp(-r/0.88-0.3/r)
  
;Fich et al. 1989 valid only for R0=8kpc and teta0=220 km/s */
  tetarf8=109.813+109.90*(r^0.029419)
 
; Fich et al. 1989 valid only for R0=8.5kpc and teta0=220 km/s */
  tetarf85=109.190+108.201*(r^0.0042069)

plot,r,tetarcl
plots,r,tetarf85,color=fsc_color('blue')
plots,r,tetarf8,color=fsc_color('red')

END
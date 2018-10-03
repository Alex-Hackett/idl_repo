; ASIFIT -- Fit the interpolant to the data.

PRO ZE_ASIFIT,interptype, datain, npix,coeff

;pointer asi   ; interpolant descriptor
;real  datain[ARB] ; data array
;int npix    ; nunber of data points
;
;int i
;pointer c0ptr, cdataptr, cnptr, temp

coeff=dblarr(npix+5) ;I don't know what should be the size of coeff array!

  ; Check the data array for size

  CASE interptype OF

    'II_SPLINE3': BEGIN
      if (npix LT 4) THEN STOP,'ZE_ASIFIT: too few points for SPLINE3' else BEGIN 
        ASI_NCOEFF = npix + 3
        ASI_OFFSET = 1
      ENDELSE
    END
    
   'II_POLY5':   BEGIN
      if (npix LT 6) THEN STOP, 'ZE_ASIFIT: too few points for POLY5'  else BEGIN
        ASI_NCOEFF = npix + 5
        ASI_OFFSET = 2
      ENDELSE
    END
    
   'II_POLY3': BEGIN
      if (npix LT 4) THEN STOP,'ZE_ASIFIT: too few points for POLY3'   else BEGIN
        ASI_NCOEFF = npix + 3
        ASI_OFFSET = 1
      ENDELSE
    END
    
   'II_DRIZZLE': BEGIN
      if (npix LT 2) THEN STOP,'ZE_ASIFIT: too few points for LINEAR'  else BEGIN
        ASI_NCOEFF = npix + 1
        ASI_OFFSET = 0
      ENDeLSE
    END
    
    'II_LINEAR': BEGIN
      if (npix LT 2) THEN STOP,'ZE_ASIFIT: too few points for LINEAR'  else BEGIN
        ASI_NCOEFF = npix + 1
        ASI_OFFSET = 0
      ENDeLSE
    END     

    ELSE: BEGIN
      if (npix LT 1) THEN STOP,' ZE_ASIFIT: too few points for NEAREST' else BEGIN
        ASI_NCOEFF = npix
        ASI_OFFSET = 0
      ENDELSE
    END
  ENDCASE


  ; Define the pointers.
  ; (c0ptr + 1) points to first element in the coefficient array.
  ; (cdataptr + 1) points to first data element in the coefficient array.
  ; (cnptr + 1) points to the first element after the last data point in
  ; coefficient array.

  c0ptr = -1
  cdataptr = ASI_OFFSET
  cnptr = cdataptr + npix

  ; Put data into the interpolant structure.
  for i = 0, npix-1 DO  COEFF(cdataptr + i) = datain[i]

  ; Specify the end conditions.
  CASE interptype OF

  'II_SPLINE3': BEGIN
      ; Natural end conditions - second deriv. zero
      COEFF(c0ptr + 1) = 0.
      COEFF(cnptr + 1) = 0.
      COEFF(cnptr + 2) = 0. ; if x = npts

      ; Fit spline - generate b-spline coefficients.
 ;     call ii_spline (COEFF(ASI_COEFF(asi)), TEMP(temp), npix)
    END

  'II_NEAREST': 
      ; No end conditions required.

  'II_LINEAR': BEGIN
     help,coeff
     print,cnptr+1,cdataptr + npix,cdataptr + npix-1
      COEFF(cnptr + 1) = 2. * COEFF(cdataptr + npix) - $ ; if x = npts
                 COEFF(cdataptr + npix - 1)
    END

  'II_DRIZZLE': BEGIN
      COEFF(cnptr + 1) = 2. * COEFF(cdataptr + npix) - $ ; if x = npts
                 COEFF(cdataptr + npix - 1)
    END    
    
    
    
  'II_POLY3':  BEGIN
      COEFF(c0ptr + 1) = 2. * COEFF(cdataptr + 1) - COEFF(cdataptr + 2) 
      COEFF(cnptr + 1) = 2. * COEFF(cdataptr + npix) -$
                 COEFF(cdataptr + npix - 1)
      COEFF(cnptr + 2) = 2. * COEFF(cdataptr + npix) -$
                 COEFF(cdataptr + npix - 2) 
    END
  'II_POLY5':  BEGIN
      COEFF(c0ptr + 1) = 2. * COEFF(cdataptr + 1) - COEFF(cdataptr + 3)
      COEFF(c0ptr + 2) = 2. * COEFF(cdataptr + 1) - COEFF(cdataptr + 2)
      COEFF(cnptr + 1) = 2. * COEFF(cdataptr + npix) - $
                 COEFF(cdataptr + npix - 1)
      COEFF(cnptr + 2) = 2. * COEFF(cdataptr + npix) - $
                 COEFF(cdataptr + npix - 2)
      COEFF(cnptr + 3) = 2. * COEFF(cdataptr + npix) - $
                 COEFF(cdataptr + npix - 3)
     END
  ENDCASE
end
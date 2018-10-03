PRO ZE_IIGETPC,itypei,n0,coeff,pc  ; generates polynomial coefficients
          ; if spline or poly3 or poly5

;INPUTS
;int n0      ; coefficients wanted for n0 < x < n0 + 1
; real coeff[ARB]

d=dblarr(6)


  ; generate polynomial coefficients, first for spline.
  if (ITYPEI EQ 'II_SPLINE3') THEN BEGIN
      pc[1] = coeff[n0-1] + 4. * coeff[n0] + coeff[n0+1]
      pc[2] = 3. * (coeff[n0+1] - coeff[n0-1])
      pc[3] = 3. * (coeff[n0-1] - 2. * coeff[n0] + coeff[n0+1])
      pc[4] = -coeff[n0-1] + 3. * coeff[n0] - 3. * coeff[n0+1] +$
            coeff[n0+2]
    
  ENDIF else BEGIN
      if (ITYPEI EQ 'II_POLY5') THEN nt = 6  else  nt = 4 ; must be POLY3 then
 

      ; Newton's form written in line to get polynomial from data

      ; load data
      for i = 0,nt-1 do d[i] = coeff[n0 - nt/2 + i]

      ; generate difference table
      for k = 1, nt-1 DO BEGIN
        for i = 0,nt-k-1 DO  d[i] = (d[i+1] - d[i]) / k
      endfor
      ; shift to generate polynomial coefficients of (x - n0)
      for k = nt,2,-1 DO BEGIN
        for i = 1,k -1 DO  d[i] = d[i] + d[i-1] * (k - i - 2)
      endfor
      for i = 0,nt-1 do pc[i] = d[nt + 1 - i]
  ENDELSE

END


FUNCTION ZE_ASIGRL,itypei,a,b,coeff    ; returns value of integral

;     This procedure finds the integral of the interpolant from a to b
;assuming both a and b land in the array.

COFF=0.


pc=dblarr(6)

  xa = a
  xb = b
  if ( a GT b ) THEN BEGIN    ; flip order and sign at end
      xa = b
      xb = a
  ENDIF

  na = xa
  nb = xb
  ac = 0.   ; zero accumulator

  ; set number of terms
  CASE ITYPEI OF   ; switch on interpolator type
  'II_NEAREST' : nt = 0
  'II_LINEAR' :  nt = 1
  'II_POLY3' :   nt = 4
  'II_POLY5' :   nt = 6
  'II_SPLINE3' : nt = 4
  ENDCASE
  print,'nt ', nt
  ; NEAREST_NEIGHBOR and LINEAR are handled differently because of
  ; storage.  Also probably good for speed.

  if (nt EQ 0) THEN BEGIN    ; NEAREST_NEIGHBOR
      ; reset segment to center values
      na = xa + 0.5
      nb = xb + 0.5

      ; set up for first segment
      s = xa - na

      ; for clarity one segment case is handled separately
      if ( nb EQ na ) THEN BEGIN ; only one segment involved
        t = xb - nb
        n0 = COFF + na
        ac = ac + (t - s) * coeff[n0]
      ENDIF else BEGIN  ; more than one segment

        ; first segment
        n0 = COFF + na
        ac = ac + (0.5 - s) * coeff[n0]

        ; middle segments
        FOR j = na+1, nb-1 DO BEGIN ;check this for statatment for 0 point error
        n0 = COFF + j
        ac = ac + coeff[n0]
        ENDFOR

        ; last segment
        n0 = COFF + nb
        t = xb - nb
        ac = ac + (t + 0.5) * coeff[n0]
      ENDELSE

  ENDIF else if (nt EQ 1) THEN BEGIN ; LINEAR
      ; set up for first segment
      print,'entered linear loop'
      s = xa - na

      ; for clarity one segment case is handled separately
      if ( nb EQ na ) THEN BEGIN ; only one segment involved
        t = xb - nb
        n0 = COFF + na
        ac = ac + (t - s) * coeff[n0] + $
        0.5 * (coeff[n0+1] - coeff[n0]) * (t*t - s*s)
        print,'debug ac',ac
      ENDIF else BEGIN  ; more than one segment

        ; first segment
        n0 = COFF + na
        ac = ac + (1. - s) * coeff[n0] + $
        0.5 * (coeff[n0+1] - coeff[n0]) * (1. - s*s)
        print,'debug2 ac',ac
        ; middle segments
        FOR j = na+1, nb-1 DO BEGIN
        n0 = COFF + j
        ac = ac + 0.5 * (coeff[n0+1] + coeff[n0])
        ENDFOR
        print,'debug3 ac',ac
        ; last segment
        n0 = COFF + nb
        t = xb - nb
        ac = ac + coeff[n0] * t + 0.5 * $
        (coeff[n0+1] - coeff[n0]) * t * t
        print,'debug4 ac',ac
      ENDELSE

  ENDIF else BEGIN   ; A higher order interpolant

      ; set up for first segment
      s = xa - na

      ; for clarity one segment case is handled separately
      if ( nb EQ na ) THEN BEGIN ; only one segment involved
        t = xb - nb
        n0 = COFF + na
        ze_iigetpc,itypei,n0,coeff,pc
        for i = 0, nt-1 do  ac = ac + (1./i) * pc[i] * (t - s)
      ENDIF else BEGIN  ; more than one segment

        ; first segment
        n0 = COFF + na
        ze_iigetpc,itypei,n0,coeff,pc
        for i = 0,nt-1 do   ac = ac + (1./i) * pc[i] * (1. - s)

    ; middle segments
        FOR j = na+1, nb-1 DO BEGIN
          n0 = COFF + j
          ze_iigetpc,itypei,n0,coeff,pc
          for i = 0,nt-1 DO ac = ac + (1./i) * pc[i]
        endfor

    ; last segment
       n0 = COFF + nb
       t = xb - nb
       ze_iigetpc,itypei,n0,coeff,pc
       for i = 0, nt-1 do ac = ac + (1./i) * pc[i] * t
      ENDELSE
  ENDELSE

  if ( a LT b ) THEN return,ac else return,-ac
END



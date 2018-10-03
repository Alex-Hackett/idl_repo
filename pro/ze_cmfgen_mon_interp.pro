PRO ZE_CMFGEN_MON_INTERP,QZ,NQ,LIN_END,QZR,NX,VARRAY,NV,R,ND
;John Hillier's CMFGEN routine subs/mon_interp.f
;converted to IDL by Jose Groh

; Subroutine to interpolate an array onto a new grid. The grid vector must be 
; either a monotonically decreasing or increasing function. A modified cubic
; polynomial is used to do the interpolation. Instead of using
; the excact cubic estiamtes for the first derivative at the two nodes,
; we use revised estimates which insure that the interpolating function
; is mononotonic in the interpolating interval.
;
; The techniques is somewhat similar to that suggested by Nordulund.
;
; Disadvantages: The interpolating weights can only be defined when the
;                function is known. In principal could use these modified
;                first derivatives to compute an accurate integration
;                formulae. However, the integration weights cannot be defined
;                independently of the function values, as desired in many
;                situations.
;
; Ref: Steffen. M, 1990, A/&A, 239, 443-450
;
;
; Altered 24-May-1996 : ERROR_LU installed
; Created 01-Apr-1992 : Code may need recoding for optimal speed, and for
;                         vectorization.
;

  ;QZ=dblarr(NQ,LIN_END) & QZR=dblarr(NX)
  ;VARRAY=dblarr(NV,LIN_END) & R=dblarr(ND)

  ONE=1.0D0
;
; The array R may be either monotonically increasing, or decreasing.
;
  SGN=ZE_FORTRAN_SIGN(ONE,R[ND-1]-R[0])
  IF( (SGN*QZR[0] LT SGN*R[0]) OR (SGN*QZR[NX-1] GT SGN*R[ND-1]) ) THEN BEGIN
;    LUER=ERROR_LU()
    PRINT,'Error in MON_INTERP - values outside range'
    PRINT,FORMAT='(X,2(A,E16.6),A,I4)', 'R[0]=',R[0],'  R[ND]= ',R[ND-1],'ND=',ND
    PRINT,FORMAT='(X,2(A,E16.6),A,I4)', 'QZR[0]=',QZR[0],'QZR[NX]=',QZR[NX-1],'NX=',NX
    STOP
  ENDIF
  I=0
;
; M is the Index in new interpolated array
;
  FOR M=0,NX-1 DO BEGIN
    label_goto_500: IF (SGN*QZR[M] LE SGN*R[I+1]) THEN BEGIN
      IF (I EQ 0) THEN BEGIN
        HI=R[1]-R[0]
        HIP1=R[2]-R[1]
        FOR J=0,LIN_END - 1 DO BEGIN
          SI=(VARRAY[1,J]-VARRAY[0,J])/HI
          SIP1=(VARRAY[2,J]-VARRAY[1,J])/HIP1
          DYI=SI +(SI-SIP1)*HI/(HI+HIP1)
          DYIP1=(SI*HIP1+SIP1*HI)/(HI+HIP1)
          DYI=( ZE_FORTRAN_SIGN(ONE,SI)+ZE_FORTRAN_SIGN(ONE,DYI) )* MIN([ABS(SI),0.5*ABS(DYI)])
          DYIP1=( ZE_FORTRAN_SIGN(ONE,SI)+ZE_FORTRAN_SIGN(ONE,SIP1) )* MIN([ABS(SI),ABS(SIP1),0.5*ABS(DYIP1)])
          T1=(QZR[M]-R[I])
          A=(DYI+DYIP1-2.0*SI)/HI/HI
          B=(3.0*SI-2.0*DYI-DYIP1)/HI
          C=DYI
          D=VARRAY[I,J]
          QZ[M,J]=((A*T1+B)*T1+C)*T1+D
        ENDFOR
      ENDIF ELSE IF(I EQ ND-2) THEN BEGIN
        HI=R[ND-1]-R[ND-2]
        HIM1=R[ND-2]-R[ND-3]
        FOR J=0,LIN_END -1 DO BEGIN
          SIM1=(VARRAY[ND-2,J]-VARRAY[ND-3,J])/HIM1
          SI=(VARRAY[ND-1,J]-VARRAY[ND-2,J])/HI
          DYI=(SIM1*HI+SI*HIM1)/(HIM1+HI)
          DYIP1=SI+(SI-SIM1)*HI/(HIM1+HI)
          DYI=( ZE_FORTRAN_SIGN(ONE,SIM1)+ZE_FORTRAN_SIGN(ONE,SI) )* MIN([ABS(SIM1),ABS(SI),0.5*ABS(DYI)])
          DYIP1=( ZE_FORTRAN_SIGN(ONE,SI)+ZE_FORTRAN_SIGN(ONE,DYIP1) )* MIN([ABS(SI),0.5*ABS(DYIP1)])
          T1=(QZR[M]-R[I])
          A=(DYI+DYIP1-2.0*SI)/HI/HI
          B=(3.0*SI-2.0*DYI-DYIP1)/HI
          C=DYI
          D=VARRAY[I,J]
          QZ[M,J]=((A*T1+B)*T1+C)*T1+D
        ENDFOR
      ENDIF ELSE BEGIN
        HI=R[I+1]-R[I]
        HIM1=R[I]-R[I-1]
        HIP1=R[I+2]-R[I+1]
        FOR J=0,LIN_END -1 DO BEGIN
          SIM1=(VARRAY[I,J]-VARRAY[I-1,J])/HIM1
          SI=(VARRAY[I+1,J]-VARRAY[I,J])/HI
          SIP1=(VARRAY[I+2,J]-VARRAY[I+1,J])/HIP1
          DYI=(SIM1*HI+SI*HIM1)/(HIM1+HI)
          DYIP1=(SI*HIP1+SIP1*HI)/(HI+HIP1)
          DYI=( ZE_FORTRAN_SIGN(ONE,SIM1)+ZE_FORTRAN_SIGN(ONE,SI) )* MIN([ABS(SIM1),ABS(SI),0.5*ABS(DYI)])
          DYIP1=( ZE_FORTRAN_SIGN(ONE,SI)+ZE_FORTRAN_SIGN(ONE,SIP1) )* MIN([ABS(SI),ABS(SIP1),0.5*ABS(DYIP1)])
          T1=(QZR[M]-R[I])
          A=(DYI+DYIP1-2.0*SI)/HI/HI
          B=(3.0*SI-2.0*DYI-DYIP1)/HI
          C=DYI
          D=VARRAY[I,J]
          QZ[M,J]=((A*T1+B)*T1+C)*T1+D
        ENDFOR
      ENDELSE
     ENDIF ELSE BEGIN 
      I=I+1
      GOTO, label_goto_500
     ENDELSE
  ENDFOR
END
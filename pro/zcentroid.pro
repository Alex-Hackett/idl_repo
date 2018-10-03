;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+
;
;*NAME: ZCENTROID
;
;*CLASS:
;
;*CATEGORY:
;
;*PURPOSE: Does Gaussian fit on a spectral line using limits defined by cursor.
;
;*CALLING SEQUENCE:
; ZCENTROID, w, f, index, WL, WR, XC
;
;*PARAMETERS:
;    INPUT:
; w - (REQ) - (1) - (I,R,L,D) - Wavelength vector.
; f - (REQ) - (1) - (I,R,L,D) - Flux vector.
; index - (REQ) - (0) - (I,L)     - 0 = Interactive fitting.
;                                         - 1 = Automatic fitting (must give
;                                               wavelength limits for the fit).
; OUTPUT:
; WL  - (REQ) - (0) - (I,R,L,D) - Left wavelength limit.
; WR  - (REQ) - (0) - (I,R,L,D) - Right wavelength limit.
; XC(0) - (REQ) - (1) - (I,L)     - Vector position of centroid.
;
;*SUBROUTINES CALLED:
; GAUSSFIT
; PLOT_RESET
;
;*NOTES:
; Primary use is with FP_MERGE (CENTROID_MERGE).
;
;*PROCEDURE:
; Program allows interactive use of the cursor to determine x(max), x(min)
; limits on a spectral line and does a gaussian fit using the IDL
; function GAUSSFIT.  The fitting is done in velocity space by using
; wavelength midway between the chosen fit limits.  Fitting in
; wavelength space is done because it is preferable in some instances
; since weak, narrow lines are not always fitted well in lambda space
; due to small interval values between points
;
;*MODIFICATION HISTORY:
; Ver 1.0 - 11/29/90 - Jason Cardelli
;         - 12/16/90 - Jim Blackwell - Modified to conform with GHRS
;                                            DAF standards.
; 23-may-1991 jkf/acc - moved to GHRS DAF (IDL version 2)
; 26-mar-2009 jhg  -Modified by Jose H. Groh; returns also the centroid value WC 
;-
;-------------------------------------------------------------------------------
PRO ZCENTROID,w,f,index,WL,WR,XC,WC
if n_params(0) eq 0 then $
  message,' Calling Sequence:  ZCENTROID, w, f, index, WL, WR, XC, WC'

zparcheck,'ZCENTROID',w,1,[2,3,4,5],1,"w not valid"
zparcheck,'ZCENTROID',f,2,[2,3,4,5],1,"f not valid"
zparcheck,'ZCENTROID',index,3,[2,3],0,"index not valid"
;
c=299792.0 ; speed of light km/sec
if index gt 0 then begin
;
; THIS IS USED TO INCREASE THE VALUE OF THE INDIVIDUAL FLUX POINTS SUCH THAT
; DELTA (F) IS NOT SMALL (WITHOUT THIS, FITTING IN ABSOLUTE FLUX SPACE IS
; A problem).
;
  FSCALE=MAX(F)
;
  xl=where(w ge wl)
  xr=where(w ge wr)
  W0=(WR+WL)/2.            ;'central' wavelength
  v=((w-w0)/w0)*c          ;velocity vector 
  yfit=gaussfit(v(xl(0):xr(0)),10*(f(xl(0):xr(0))/FSCALE),AA)  ;do fit
;
  XC=INTARR(1) ;CENTROID VECTOR POSITION
;
  WLOW=MAX(W(WHERE(W LE ((AA(1)/c)+1)*(w0))))  ;WAVE IMMEDIATE LEFT OF CENTROID
  XLOW=MAX((WHERE(W LE ((AA(1)/c)+1)*(w0))))  ;VECTOR POSITION TO LEFT
  WHIGH=MIN(W(WHERE(W GE ((AA(1)/c)+1)*(w0)))) ;WAVE IMMEDIATE RIGHT OF CENTROID
  XHIGH=MIN((WHERE(W GE ((AA(1)/c)+1)*(w0)))) ;VECTOR POSITION TO RIGHT
;
  IF ((AA(1)/c)+1)*(w0) LE (WLOW+WHIGH)/2. THEN XC(0)=XLOW  ;FIND CLOSEST VECTOR
  IF ((AA(1)/c)+1)*(w0) GE (WLOW+WHIGH)/2. THEN XC(0)=XHIGH ;POINT TO CENTROID 
;                                                            WAVELENGTH
;
  return   ;skip cursor section if this is not the first spectrum
end
;
XVECT=FLTARR(4)
YVECT=FLTARR(4)
;
START:
;
; THIS IS USED TO INCREASE THE VALUE OF THE INDIVIDUAL FLUX POINTS SUCH THAT
; DELTA (F) IS NOT SMALL (WITHOUT THIS, FITTING IN ABSOLUTE FLUX SPACE IS A
; problem)
;
FSCALE=MAX(F)
;
PLOT,W,10*(F/FSCALE),xstyle=1, $
    xmargin=[12,6],ymargin=[4,15],psym=0,xtitle='Wavelength(A)', $
  title='FP_MERGE ( using CENTROID option)'
w0=0.

if !d.name eq 'TEK' or !d.name eq 'VGA' then begin
   device,gin_char=6

  ;
  ;  output measuring instructions
  ;
  hpos = 2 * !d.x_ch_size 
  vpos = !d.y_vsize - !d.y_ch_size
  vspace = 1.1 * !d.y_ch_size
  ;
  xyouts,hpos,vpos,font=0,charsize=.8,/device, $
          ' Use vertical cursor to select LEFT then RIGHT limit'
        vpos = vpos - vspace
  xyouts,hpos,vpos,font=0,charsize=.8,/device, $
      ' Enter S to QUIT'
        vpos = vpos - vspace
        flush = get_kbrd(0)                 ;flush type buffer
      CURSOR,A,B,1,/data
        IF (!ERR EQ 83) or (!err eq 115) THEN retall ; !ERR=83 EQUALS 'S'

    XVECT(0:1)=A
    YVECT(0:1)=B
  OPLOT,XVECT(0:1),!y.crange,linestyle=1
        flush = get_kbrd(0)                 ;flush type buffer
      CURSOR,A,B,1,/data
        IF (!ERR EQ 83) or (!err eq 115) THEN retall ; !ERR=83 EQUALS 'S'

    XVECT(2:3)=A
    YVECT(2:3)=B
  OPLOT,XVECT(2:3),!y.crange,linestyle=1

end else begin


    PRINT,'  Choose <---- LEFT  limit for FITTING'
    PRINT,'  Choose RIGHT ----> limit for FITTING'
    PRINT,'  Hit right mouse button ABORT
    PRINT,' '
    CURSOR,A,B,/data,/down
    IF !ERR EQ 4 THEN retall

    XVECT(0:1)=A
    YVECT(0:1)=B
    OPLOT,XVECT(0:1),!y.crange,linestyle=1
    CURSOR,A,B,/data,/down
    IF !ERR EQ 4 THEN retall

    XVECT(2:3)=A
    YVECT(2:3)=B
    OPLOT,XVECT(2:3),!y.crange,linestyle=1

end ;  tek/dos vs sun/X

  XL=WHERE(W GE xvect(0))  ;left vector position
  XR=WHERE(W GE xvect(2))  ;right vector position
  wl=xvect(0)              ;left wavelength
  wr=xvect(2)              ;right wavelength
  W0=(WR+WL)/2.            ;'central' wavelength
  v=((w-w0)/w0)*c          ; velocity vector

;
  yfit=gaussfit(v(xl(0):xr(0)),10*(f(xl(0):xr(0))/FSCALE),AA)  ;do fit
  oplot,w(xl(0):xr(0)),yfit,psym=0,thick=2
;
    XC=INTARR(1) ;CENTROID VECTOR POSITION
;
    WLOW=MAX(W(WHERE(W LE ((AA(1)/c)+1)*(w0))))  ;WAVE IMMEDIATE LEFT OF CENTROID
    XLOW=MAX((WHERE(W LE ((AA(1)/c)+1)*(w0))))  ;VECTOR POSITION TO LEFT
    WHIGH=MIN(W(WHERE(W GE ((AA(1)/c)+1)*(w0)))) ;WAVE IMMEDIATE RIGHT OF CENTROID
    XHIGH=MIN((WHERE(W GE ((AA(1)/c)+1)*(w0)))) ;VECTOR POSITION TO RIGHT
;
    IF ((AA(1)/c)+1)*(w0) LE (WLOW+WHIGH)/2. THEN XC(0)=XLOW  ;FIND CLOSEST VECTOR
    IF ((AA(1)/c)+1)*(w0) GE (WLOW+WHIGH)/2. THEN XC(0)=XHIGH ;POINT TO CENTROID 
                                                            ;WAVELENGTH
    wc=((AA(1)/c)+1)*(w0)  ;actual derived centroid wavelength
;
    info = strarr(8)
  info(0)='  X-Vector positions...FIT limits'
      info(1)='  X-LEFT  = '+strtrim(string(XL(0)),2)+'    Wave-Left  = '+strtrim(string(w(XL(0))),2)
        info(2)='  X-RIGHT = '+strtrim(string(XR(0)),2)+'    Wave-Right = '+strtrim(string(w(XR(0))),2)
        info(3)= ' '
        info(4)= ' Centroid nearest neighbors and ASSIGNED CENTROID'
  info(5)='  X-LEFT  = '+strtrim(string(xlow),2)+'    Wave-Left  = '+strtrim(string(wlow),2)
        info(6)='  X-Cen   = '+strtrim(string(XC(0)),2)+'    Wave-Cen   = '+strtrim(string(wc),2)
        info(7)='  X-RIGHT = '+strtrim(string(Xhigh),2)+'    Wave-Right = '+strtrim(string(whigh),2)

if !d.name eq 'TEK' or !d.name eq 'VGA' then begin
    for i =0, 7 do begin
       xyouts,hpos,vpos,font=0,charsize=.8,/device, $
    info(i)
        vpos = vpos - vspace
    end
    CH=''
       xyouts,hpos,vpos,font=0,charsize=.8,/device, $
    ' '
        vpos = vpos - vspace
  xyreads,/dev,hpos,vpos,ch, $
        '  C)ontinue   R)edo ? '
        vpos = vpos - vspace

    if strupcase(ch) eq 'R' then GOTO,START

end else begin    ; sun/X

    for i =0, 7 do print,info(i)
    CH=''
    print,' '
    read,CH,PROMPT='  C)ontinue   R)edo'
    print,' '
    if strupcase(ch) eq 'R' then GOTO,START
end
;
;RETURN ; ZCENTROID
END ; ZCENTROID
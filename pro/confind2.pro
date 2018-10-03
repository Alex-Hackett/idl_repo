;************************************************************************
;+
;*NAME:
;     CONFIND2   (General IDL Library 01) 
;  
;*CLASS:
;     User i/o; curve fitting
;  
;*CATEGORY:
;  
;*PURPOSE:
;     procedure to select continuum points in a spectrum. CONFIND is a
;     modified version of the front end of NORM which uses the interactive
;     graphics cursor to pick out points for later continuum fitting.
;  
;*CALLING SEQUENCE:
;     CONFIND2,WAVE,FLUX,WCONT,FCONT
;  
;*PARAMETERS:
;     WAVE   (REQ) (I) (1) (F D)
;            Required input vector containing the wavelength data for the
;            spectrum of interest.
;     FLUX   (REQ) (I) (1) (F D)
;            Required input vector containing the flux data.
;     WCONT  (REQ) (O) (1) (F D)
;            Required output vector containing the wavelengths of the
;            selected points.
;     FCONT  (REQ) (O) (1) (F D)
;            Required output vector containing the fluxes of the selected
;            points.
;
;*EXAMPLES:
;     To pick central wavelengths for continuum bandpasses:
;     CONFIND2,WAVE,FLUX,WCONT,FCONT
;     then specify widths of bandpasses in vector WIDTHS
;     BINS,WAVE,FLUX,WCONT,WIDTHS,WMEAN,WSIG,WGT
;
;     To select continuum points for normalization:
;     CONFIND2,WAVE,FLUX,WCONT,FCONT
;
;*SYSTEM VARIABLES USED:
;     !ERR
;     !CXMIN
;     !CXMAX
;     !CYMIN
;     !CYMAX
;     !ILAS
;     !XMIN
;     !XMAX
;     !YMIN
;     !YMAX
;  
;*INTERACTIVE INPUT:
;     User is prompted for rescaling plot of wave vs flux
;     The user also selects the continuum points via the graphics cursor.
;
;*FILES USED:
;     None  
;  
;*SUBROUTINES CALLED:
;     PARCHECK
;     SCTODC
;
;*SIDE EFFECTS:
;     If aborted, some system variables may be reset.
;  
;*RESTRICTIONS:
;     Device Dependent - This procedure requires a graphics cursor.
;  
;*NOTES:
;     !FANCY should be =0 before beginning this procedure, as the
;     fancy graphics conflict with cursor commands.
;
;*PROCEDURE:
;     The user views the spectrum, and is given the opportunity to
;     rescale the plot. This is done iteratively until the user indicates
;     satisfaction by typing 0 (no more rescaling).
;
;     Next, while viewing the spectrum, the users marks points corresponding
;     to the continuum with the graphics cursor. Points can be added until
;     the user types 0. The data x and y coordinates of the points are 
;     calculated from the screen locations of the cursor.
;  
;*INF_1:
;  
;*MODIFICATION HISTORY:
;     May    1985  CAG GSFC wrote procedure based on NORM
;     Jun  6 1985  RWT GSFC allowed exit from CONFIND
;     Jun 11 1985  RWT GSFC modified user prompt for continuum points
;     Apr 13 1987  RWT GSFC use vector assignment statements, remove
;                           INSERT and EXTRACT commands, and use XYOUTS
;                           for XYOUT.
;     May 22 1987  RWT GSFC improve sorting 
;     Mar  1 1988  RWT GSFC make CONFIND a separate procedure
;     Mar  8 1988  CAG GSFC added VAX RDAF-style prolog, printing calling
;                           sequence if no parameters are specified, and
;                           check for minimum number of parameters.
;     1/08/90 RWT UNIX mods: convert to lower-case,
;     Mar 4 1991      JKF/ACC    - moved to GHRS DAF (IDL Version 2)
;     Aug 31 1993     JKF/ACC  - remove /DATA keyword from OPLOT command.
;
;-
;************************************************************************
pro confind2,wave,flux,wcont,fcont
;
; ck. parameters and initialize variables
;
if n_params(0) eq 0 then begin
    print,' confind2,wave,flux,wcont,fcont'
    retall & end
n  = 0 
ix = fltarr(1)
iy = ix
tx = (total(!x.crange))/2
ty = (total(!y.crange))/2
yn=' '
!err="61
vpos = !d.y_size - !d.y_ch_size
vspace = 1.1 * !d.y_ch_size
hpos = !d.x_ch_size 
isym=[1,7,2]    ; symbols used for keys

;
; plot rescaling section (useful in emission line spectra)
;
plot,wave,flux,ymargin=[4,8]
read,' Are you satisfied with plot scale (y or n)?',yn
yesno,yn
while (not yn) do begin
     read,' enter xmin and max:',xmin,xmax
     read,' enter ymin and max:',ymin,ymax
     plot,wave,flux,XRANGE=[xmin,xmax],YRANGE=[ymin,ymax],ymargin=[4,8]
     yn=''
     read,' Are you satisfied with plot scale now (y or n)?',yn
     yesno,yn
     end
;
; plot wave vs flux with directions for user to define continuum
; Let user set cross hairs to define continuum
; For SUN monitors, select pt = 1, replot = 2, finished = 4
;
if !d.name eq 'TEK' then begin
       xyouts,hpos,vpos-2.2*vspace,' '
       print,'  to select point, move cursor and press space bar'
       print,'  to abort,              type 2 '
       print,'  to replot last point,  type 1 '
       print,'  if finished,           type 0 '

  vpos = !d.y_size - ( 3 * !d.y_ch_size)
  vspace = 1.1 * !d.y_ch_size
  hpos = .45 * !d.x_vsize
      xyouts,hpos,vpos,' Meas. Flux   ENTER %    ADJ. Flux',/dev,font=0
        vpos = vpos - vspace

  while (!err ne "60) and (!err ne 4) do begin   ;(note: "60=asci 0 & "61=asci 1)
     ;
     ; REDO
     ;
     if (!err eq "61) then $
       if n ge 2 then oplot,ix,iy
               
     flush = get_kbrd(0)
     cursor,tx,ty,/down,/DATA  ;read cursor
;
;   "60 = octal 60 = decimal 0
;   "61 = octal 61 = decimal 1
;   "62 = octal 62 = decimal 2
;
     if !err eq "62 then retall
     if (!err ne "61) and (!err ne 2) then begin
         if (!err ne "60) and (!err ne 4) then begin ; get point
;
;        code added for Leckrone/Adelman 9/85
;        allows user to examine flux value and adjust by multiplying it by
;        a percentage to better reflect S/N
;
;
     
           xyouts,hpos,vpos,'+ ' + string(ty,'(e10.3)'),/dev,font=0
           PCNT = 1.0
     xyreads,hpos+(15*!d.x_ch_size),vpos,pcnt,'% ',/dev
           ty   = ty * pcnt
           oplot,[tx],[ty],psym=isym(2)
;           oplot,[tx],[ty],psym=isym(2),/DATA ; removed 8/93(JKF)
           xyouts,hpos+(25*!d.x_ch_size),vpos, string(ty,'(e10.3)'),/dev,font=0
           vpos = vpos - vspace

           ; sort values into ascending order
           n=n+1            ;# of points 
           x=fltarr(n)
           x(0) = ix
           x(n-1) = tx
           ind = sort(x)
           ix = x(ind)
           x(0) = iy
           x(n-1) = ty
           iy = x(ind)
           last = ind
           if n ge 2 then oplot,ix,iy,psym=0    ;plot continuum

           !err=0   ;force one more point
           end   ;got point
       end   ;!err ne "61 or 2
     end   ;!err ne "60 or 4
;
; SUN View style
;
end else begin
  print,' '
  print,'  to select point, move cursor to point and press left button'
  print,'  to replot last point,  press middle mouse button'
  print,'  if finished,           press right mouse button'
  print,' '

  vpos = !d.y_size - ( 3 * !d.y_ch_size)
  vspace = .7 * !d.y_ch_size
  hpos = .70 * !d.x_vsize
      xyouts,hpos,vpos,' Meas. Flux   ADJ. Flux',/dev,font=0
        vpos = vpos - vspace

  cr = string("15b)     ; special <cr> to avoid LF
  form="($,' wavelength= ',f7.2,'  yval= ',e10.3,'  flux= ',e10.3,a)"
  form1="(f8.3,2X,e10.3)"
  i=0
  c_err = 0
  vpos = vpos - vspace
  ;
  ; while loop for cursor position
  ;
  while c_err ne 4 do begin
    cursor,tx,ty,2,/data
    c_err = !err           ;preserve !err value from cursor call
         ;
             ; Are we still in the plot in the window?
         ;
         if ( tx ge !x.crange(0) and tx le !x.crange(1) and $
              ty ge !y.crange(0) and ty le !y.crange(1) ) then begin
           tabinv,wave,tx,ind
           indx = fix(ind+0.5)
     ; 
     ; Poll the cursor and display current position
     ;
           print,form=form,tx,ty,flux(indx),cr
           ;
     ; Did the user push any of the buttons
     ;
           if (c_err and 3) ne 0 then begin
                   c_err=0
                   oplot,[tx],[ty],psym=isym(i)
;                  oplot,[tx],[ty],psym=isym(i),/DATA ; removed 8/93(JKF)
                   vpos = vpos - vspace
    ;
    ;        code added for Leckrone/Adelman 9/85
    ;        allows user to examine flux value and adjust by multiplying it by
    ;        a percentage to better reflect S/N
    ;
      xyouts,hpos,vpos,'+ ' + string(ty,'(e10.3)'),/dev,font=0
      PCNT = 1.0
      print,' '
      read,' Enter % ',pcnt
      ty   = ty * pcnt
      oplot,[tx],[ty],psym=isym(i)
      xyouts,hpos+(15*!d.x_ch_size),vpos, $
        string(ty,'(e10.3)'),/dev,font=0
      vpos = vpos - vspace

                     i = (i+1) mod 3
               n=n+1    ;# of points 
               x=fltarr(n)
         x(0) = ix
               x(n-1) = tx
               ind = sort(x)
               ix = x(ind)
               x(0) = iy
               x(n-1) = ty
               iy = x(ind)
               if n ge 2 then oplot,ix,iy,psym=0    ;plot continuum
               !err=0   ;force one more point
               endif    ;c_err
           endif  ; crange
         endwhile
end

; define output variables and return
;
wcont  = ix
fcont  = iy
return
end   ; confind2
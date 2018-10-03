;+
; $Id: acs_detalign_hrc.pro,v 1.1 2001/11/05 20:51:12 mccannwj Exp $
;
; NAME:
;     ACS_DETALIGN_HRC
;
; PURPOSE:
;     Compute detector alignment from corrector mechanism focus sweep
;     data on HRC.
;
; CATEGORY:
;     ACS/Analysis
;
; CALLING SEQUENCE:
;     ACS_DETALIGN, first_entry[, /HARDCOPY]
; 
; INPUTS:
;     first_entry - first entry number of CMF data set
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     HARDCOPY - Send ouput to printer
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;-
PRO ACS_DETALIGN_HRC_PRINT, lun, ofn, p, ds, dsi, theta, $
                            fpid, ee, eemax, f, fmax
   hs='     '
   PRINTF, lun,' '
   PRINTF, lun,hs+'Focal Plane Fit   ',STRMID(!STIME,0,20),'   detalign_hrc using ',ofn
   PRINTF, lun,' '
   PRINTF, lun,hs+'Shim correction (inches)    1 (aft,E)   2 (right,SW)   3 (left,NW)'
   PRINTF, lun,hs+'Focus correction only:',REPLICATE(-p(0),3)/25.4,FORMAT='(a,3f13.3)'
   PRINTF, lun,hs+'Tilt correction only: ',(ds+p(0))/25.4,format='(a,3f13.3)'
   PRINTF, lun,hs+'Combined correction:  ',ds/25.4,format='(a,3f13.3)'
   PRINTF, lun,' '
   PRINTF, lun,hs+'    Required shim changes (inches):'
   PRINTF, lun,' '
   PRINTF, lun, '                   E (aft)'
   PRINTF, lun, '                   ',dsi(0)
   PRINTF, lun, '                      __'
   PRINTF, lun, '                     \  \'
   PRINTF, lun, '                    /    \'
   PRINTF, lun, '                   /      \'
   PRINTF, lun, '                  |        \'
   PRINTF, lun, '                 /         ,'
   PRINTF, lun, '                /          \'
   PRINTF, lun, '                \           \,'
   PRINTF, lun, '               /              \'
   PRINTF, lun, '              \                \  SW (inbd)'
   PRINTF, lun, ' NW (outbd)  /  /\_____/----\__/  ',dsi(1)
   PRINTF, lun,  '  ',dsi(2),'    |__/'
   PRINTF, lun, ' '
   PRINTF, lun, '       Looking DOWN on HRC detector'
   PRINTF, lun, ' '

   PRINTF, lun,hs+' FP-   Encircled Energy       Focus Position (mm)'
   PRINTF, lun,hs+' ID    Fit EE    Max EE         Fit Z     Best Z'
   
   FOR i=0,N_ELEMENTS(fpid)-1 DO $
    PRINTF, lun, fpid(i), ee(i), eemax(i), f(i), fmax(i), $
    FORMAT='(5X,A3,2F10.4,4X,2F10.3)'
END 

PRO ACS_DETALIGN_HRC_PLOT, x, y, ofn, ee, eemax, f, fmax, fpid
   dx=0.5
   dy=0.5
   PLOT, x, y, PSYM=3, XRANGE=[-12,12], $
    YRANGE=[-12,12], TITLE='HRC alignment optimization', $
    XSTYLE=1, YSTYLE=1, SUBTITLE=ofn+'   '+STRMID(!STIME,0,20)
   FOR i=0,N_ELEMENTS(fpid)-1 DO BEGIN
      xyouts,x(i)+dx,y(i)+dy,' '+string(ee(i),'(f5.3)')
      xyouts,x(i)+dx,y(i)-dy,'<'+string(eemax(i),'(f5.3)')
      xyouts, x(i)-0.3, y(i)-0.15, fpid(i)
      xyouts,x(i)-5*dx,y(i)+dy,string(f(i),'(f7.3)')
      xyouts,x(i)-5*dx,y(i)-dy,string(fmax(i),'(f7.3)')
   ENDFOR
END 

PRO ACS_DETALIGN_HRC, fns, fpid, HARDCOPY=hardcopy

   ;;fns=[24357,24375,24392,24409,24426] ; 9 Dec 00, HRC b1, RAS/HOMS
   ;;fpid=['HC','H2','H3','H6','H7']
   fnt='cmfscan_ind_'

   nfp=n_elements(fns)
   titl=''
   s=''
   a=fltarr(nfp)
   b=fltarr(nfp)
   c=fltarr(nfp)
   x=fltarr(nfp)
   y=fltarr(nfp)
   w=fltarr(nfp)+1. ; weights for field points for EE optimization fit

; get coeffs of parabolic fit of EE vs focus posn (mm) for each field point
; and their x,y locations (mm)
   
   for i=0,nfp-1 do begin
      openr,lun,fnt+strtrim(fns(i),2)+'.dat',/get_lun
      readf,lun,titl
      readf,lun,s,xp,yp,format='(a27,2f13.4)'
      x(i)=xp & y(i)=yp
      readf,lun,s,ca,cb,cc,format='(a29,3f13.6)'
      a(i)=ca & b(i)=cb & c(i)=cc
      free_lun,lun
   endfor

; fit optimal focal plane, maximizing total weighted EE over field using
; Don Lindler's single most expensive line of IDL code ever!:

   p=invert([[2*total(w*c),   total(2*w*c*x),   total(2*w*c*y)], $
             [total(2*w*c*x), 2*total(w*c*x*x), total(2*w*c*x*y)], $
             [total(2*w*c*y), total(2*w*c*x*y), 2*total(w*c*y*y)]]) $
    # [- total(w*b), -total(w*b*x), -total(w*b*y)]

;print,'Focal plane fit coefficients: ',p

; compute shim offsets required to optimize focus over the field

;theta=30.83  ; angle of shim plane wrt detector plane (degrees)
;ct=cos(theta/!radeg)
; pivot point projections to detector plane (mm)
   sx=-[4.1076,-1.1277,-2.1407]*25.4  
   sy=-[.6497,4.0496,-3.6446]*25.4
   ds=-(p(0)+p(1)*sx+p(2)*sy)
   dsi=string(ds/25.4,'(f6.3)')

; compute EE values at each field point after adjustment...
   f=p(0)+p(1)*x+p(2)*y ; fit focus position
   ee=a+b*f+c*f*f   ; EE at each field position

; ...and compare against independently fit max EE
   eemax=a-b*b/(4.*c) ; peak of EE fit at each field point
   fmax=-b/(2*c)    ; best (independent) focus position at each field point

; print results
   ofn=fnt+strtrim(fns(0),2)
   ACS_DETALIGN_HRC_PRINT, -1, ofn, p, ds, dsi, theta, $
    fpid, ee, eemax, f, fmax

   ACS_DETALIGN_HRC_PLOT, x, y, ofn, ee, eemax, f, fmax, fpid

   IF KEYWORD_SET(hardcopy) THEN BEGIN
      ofnh='detalign_hrc_'+ofn
      OPENW, lun, ofnh+'.txt', /GET_LUN
      ACS_DETALIGN_HRC_PRINT, lun, ofn, p, ds, dsi, theta, $
       fpid, ee, eemax, f, fmax
      FREE_LUN, lun
      SPAWN, 'lp '+ofn+'.txt'
      
      saved_device = !D.NAME
      SET_PLOT, 'PS'
      DEVICE, FILENAME=ofnh+'.ps'
      ACS_DETALIGN_HRC_PLOT, x, y, ofn, ee, eemax, f, fmax, fpid
      DEVICE, /CLOSE
      SET_PLOT, saved_device
      SPAWN, 'lp '+ofnh+'.ps'
   ENDIF
END

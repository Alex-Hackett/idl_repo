;+
; $Id: acs_detalign_wfc.pro,v 1.1 2001/11/05 20:52:08 mccannwj Exp $
;
; NAME:
;     ACS_DETALIGN_WFC
;
; PURPOSE:
;     Compute detector alignment from corrector mechanism focus sweep
;     data on WFC.
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
PRO ACS_DETALIGN_WFC_PRINT, lun, fnt, p, ds, dsi, theta, $
                            fpid, ee, eemax, f, fmax
   hs='     '
   PRINTF, lun,' '
   PRINTF, lun,hs+'Focal Plane Fit   ',STRMID(!STIME,0,20),'   detalign_wfc using ',fnt+'*'
   PRINTF, lun,' '
   PRINTF, lun,hs+'Shim correction (inches)    1 (aft,E)   2 (right,SW)   3 (left,NW)'
   PRINTF, lun,hs+'Focus correction only:',REPLICATE(-p(0),3)/25.4,FORMAT='(a,3f13.3)'
   PRINTF, lun,hs+'Tilt correction only: ',(ds+p(0))/25.4,format='(a,3f13.3)'
   PRINTF, lun,hs+'Combined correction:  ',ds/25.4,format='(a,3f13.3)'
   PRINTF, lun,' '
   PRINTF, lun,hs+'    Required shim changes (inches):'
   PRINTF, lun,' '
   PRINTF, lun,hs+'                E (aft)'
   PRINTF, lun,hs+'                ',dsi(0)
   PRINTF, lun, hs+'                  __'
   PRINTF, lun, hs+'                 |  |'
   PRINTF, lun, hs+'             ____|  |____'
   PRINTF, lun, hs+'            /            \'
   PRINTF, lun, hs+'           /              \'
   PRINTF, lun, hs+'          |                |'
   PRINTF, lun, hs+'          |                |'
   PRINTF, lun, hs+'          |                |'
   PRINTF, lun, hs+'         /                  \'
   PRINTF, lun, hs+'   NW   |                    |  SW'
   PRINTF, lun,hs+dsi(2),'  \_/\              /\_/ ',dsi(1)
   PRINTF, lun, hs+'            \____    ____/'
   PRINTF, lun, hs+'                 |__|'
   PRINTF, lun, hs+'                 cube'
   PRINTF, lun,' '
   PRINTF, lun, hs+'     Looking DOWN on WFC detector'
   PRINTF, lun,' '
   PRINTF, lun, hs+'Roll correction (CCW, degrees): ',string(theta,'(f5.2)')
   PRINTF, lun,' '

   PRINTF, lun,hs+' FP-   Encircled Energy       Focus Position (mm)'
   PRINTF, lun,hs+' ID    Fit EE    Max EE         Fit Z     Best Z'
   
   FOR i=0,N_ELEMENTS(fpid)-1 DO $
    PRINTF, lun, fpid(i), ee(i), eemax(i), f(i), fmax(i), $
    FORMAT='(5X,A3,2F10.4,4X,2F10.3)'
END 

PRO ACS_DETALIGN_WFC_PLOT, x, y, fnt, ee, eemax, f, fmax, fpid
   dx=1
   dy=1
   PLOT, x, y, PSYM=3, XRANGE=[-35,35], $
    YRANGE=[-35,35], TITLE='WFC alignment optimization', $
    XSTYLE=1, YSTYLE=1, SUBTITLE=fnt+'*   '+STRMID(!STIME,0,20)
   FOR i=0,N_ELEMENTS(fpid)-1 DO BEGIN
      xyouts,x(i)+dx,y(i)+dy,' '+string(ee(i),'(f5.3)')
      xyouts,x(i)+dx,y(i)-dy,'<'+string(eemax(i),'(f5.3)')
      xyouts,x(i)-1.2,y(i)-.3,fpid(i)
      xyouts,x(i)-8*dx,y(i)+dy,string(f(i),'(f7.3)')
      xyouts,x(i)-8*dx,y(i)-dy,string(fmax(i),'(f7.3)')
   ENDFOR
END 

PRO ACS_DETALIGN_WFC, first_entry, HARDCOPY=hardcopy
   
   fnt='cmfscan_mp_'+STRTRIM(first_entry,2)+'_'
   found=FINDFILE(fnt+'*.dat',COUNT=fcount)

   fpid = STRUPCASE(STRMID(found,STRLEN(fnt),2))
   
   ;;fpid=strupcase(['a1','n6','n2','n5','n9','a3','a4','a7','a8'])

   nfp=N_ELEMENTS(fpid)
   titl=''
   s=''
   a=fltarr(nfp)
   b=fltarr(nfp)
   c=fltarr(nfp)
   x=fltarr(nfp)
   y=fltarr(nfp)
   w=fltarr(nfp)+1.0 ; weights for field points for EE optimization fit

; get coeffs of parabolic fit of EE vs focus posn (mm) for each field point
; and their x,y locations (mm)
   
   FOR i=0,nfp-1 DO BEGIN
      OPENR, lun, fnt+fpid[i]+'.dat', /GET_LUN
      READF, lun, titl
      READF, lun, s,xp,yp,FORMAT='(a27,2f13.4)'
      x[i]=xp & y[i]=yp
      READF,lun,s,ca,cb,cc,FORMAT='(a29,3f13.6)'
      a[i]=ca & b[i]=cb & c[i]=cc
      FREE_LUN, lun
   ENDFOR

; determine mean roll of detector from angle of lines through the images
; which nominally lie on the detector diagonals

   ;;fpid=strupcase(['a1','n6','n2','n5','n9','a3','a4','a7','a8'])
   line1 = ['N6','A7','A1','A8','N9']
   line2 = ['N2','A3','A1','A4','N5']
   n_line = N_ELEMENTS(line1)
   l1 = MAKE_ARRAY(n_line,/INT)
   l2 = l1
   FOR i=0,n_line-1 DO BEGIN
      w1 = WHERE(fpid EQ line1[i],w1count)
      l1[i] = w1[0]
      w2 = WHERE(fpid EQ line2[i],w2count)
      l2[i] = w2[0]
   ENDFOR 
   
   ;;l1=[1,7,0,8,4]
   ;;l2=[2,5,0,6,3]
   cf1 = POLY_FIT(x[l1],y[l1],1,fit1)
   cf2 = POLY_FIT(x[l2],y[l2],1,fit2)
   PLOT, x[l1], y[l1], PSYM=4
   oplot, x(l1),fit1
   oplot, x(l2),y(l2),PSYM=4
   oplot, x(l2),fit2
   t1=ATAN(cf1(1))*!radeg
   t2=ATAN(cf2(1))*!radeg+90.0
   theta=(t1+t2)/2.0-45.0

; fit optimal focal plane, maximizing total weighted EE over field using
; Don Lindler's single most expensive line of IDL code ever!:

   p=invert([[2*total(w*c),   total(2*w*c*x),   total(2*w*c*y)], $
             [total(2*w*c*x), 2*total(w*c*x*x), total(2*w*c*x*y)], $
             [total(2*w*c*y), total(2*w*c*x*y), 2*total(w*c*y*y)]]) $
    # [- total(w*b), -total(w*b*x), -total(w*b*y)]

;print,'Focal plane fit coefficients: ',p

; compute shim offsets required to optimize focus over the field

; pivot point projections to detector plane (mm)
   sx=[-4.3039,-1.5754,5.8796]*25.4  
   sy=[-4.3039,5.8796,-1.5754]*25.4
   ds=-(p(0)+p(1)*sx+p(2)*sy)
   dsi = STRING(ds/25.4,'(f6.3)')

; compute EE values at each field point after adjustment...
   f=p(0)+p(1)*x+p(2)*y ; fit focus position
   ee=a+b*f+c*f*f   ; EE at each field position

; ...and compare against independently fit max EE
   eemax=a-b*b/(4.*c) ; peak of EE fit at each field point
   fmax=-b/(2*c)    ; best (independent) focus position at each field point

   ACS_DETALIGN_WFC_PRINT, -1, fnt, p, ds, dsi, theta, $
    fpid, ee, eemax, f, fmax

   ACS_DETALIGN_WFC_PLOT, x, y, fnt, ee, eemax, f, fmax, fpid

   IF KEYWORD_SET(hardcopy) THEN BEGIN
      ofn='detalign_wfc_'+fnt
      OPENW, lun, ofn+'.txt', /GET_LUN
      ACS_DETALIGN_WFC_PRINT, lun, fnt, p, ds, dsi, theta, $
       fpid, ee, eemax, f, fmax
      FREE_LUN, lun
      SPAWN, 'lp '+ofn+'.txt'
      
      saved_device = !D.NAME
      SET_PLOT, 'PS'
      DEVICE, FILENAME=ofn+'.ps'
      ACS_DETALIGN_WFC_PLOT, x, y, fnt, ee, eemax, f, fmax, fpid
      DEVICE, /CLOSE
      SET_PLOT, saved_device
      SPAWN, 'lp '+ofn+'.ps'
   ENDIF
END

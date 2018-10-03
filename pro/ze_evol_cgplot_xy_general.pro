PRO ZE_EVOL_CGPLOT_XY_GENERAL,x,y,xtitle,ytitle,label,$
                                z=z,labelz=labelz,ct=ct,minz=minz,maxz=maxz,$
                                x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
                                rebin=rebin,xreverse=xreverse,yreverse=yreverse,_EXTRA=extra
;working on supporting multiple vectors on the same plot. right now for vector with the same number of points.
;working OK for x2,y2

print,n_elements(x2),n_elements(y2)      
close,/all
!P.MULTI=0

IF n_elements(ct) lt 1 THEN ct=33

IF KEYWORD_SET(REBIN) THEN BEGIN
    ZE_EVOL_REBIN_XYZ,x,y,xr,yr,z=z,rebin_z=rebin_z
    IF ((N_elements(x2) GT 1) AND (N_elements(y2) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x2,y2,x2r,y2r
    IF ((N_elements(x3) GT 1) AND (N_elements(y3) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x3,y3,x3r,y3r
    IF ((N_elements(x4) gt 1) AND (N_elements(y4) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x4,y4,x4r,y4r
    IF ((N_elements(x5) GT 1) AND (N_elements(y5) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x5,y5,x5r,y5r
ENDIF ELSE BEGIN 
    xr=x
    yr=y
    IF N_elements(z) GT 1 THEN rebin_z=z
ENDELSE
posminx=0.12
posmaxx=0.87
posminy=0.1
posmaxy=0.95

ZE_FIND_OPTIMAL_XYPLOT_RANGE,x,y,position,xrange,yrange

IF ((N_elements(x2) GT 1) AND (N_elements(y2) GT 1)) THEN BEGIN 
  ZE_FIND_OPTIMAL_XYPLOT_RANGE,x2,y2,position,xrange2,yrange2
  xrange=[min([xrange[0],xrange2[0]]),max([xrange[1],xrange2[1]])]
  yrange=[min([yrange[0],yrange2[0]]),max([yrange[1],yrange2[1]])]
ENDIF

IF ((N_elements(x3) GT 1) AND (N_elements(y3) GT 1)) THEN BEGIN 
  ZE_FIND_OPTIMAL_XYPLOT_RANGE,x3,y3,position,xrange3,yrange3
  xrange=[min([xrange[0],xrange3[0]]),max([xrange[1],xrange3[1]])]
  yrange=[min([yrange[0],yrange3[0]]),max([yrange[1],yrange3[1]])]
ENDIF

IF ((N_elements(x4) GT 1) AND (N_elements(y4) GT 1)) THEN BEGIN 
  ZE_FIND_OPTIMAL_XYPLOT_RANGE,x4,y4,position,xrange4,yrange4
  xrange=[min([xrange[0],xrange4[0]]),max([xrange[1],xrange4[1]])]
  yrange=[min([yrange[0],yrange4[0]]),max([yrange[1],yrange4[1]])]
ENDIF

IF ((N_elements(x5) GT 1) AND (N_elements(y5) GT 1)) THEN BEGIN 
  ZE_FIND_OPTIMAL_XYPLOT_RANGE,x5,y5,position,xrange5,yrange5
  xrange=[min([xrange[0],xrange5[0]]),max([xrange[1],xrange5[1]])]
  yrange=[min([yrange[0],yrange5[0]]),max([yrange[1],yrange5[1]])]
ENDIF


if N_elements(rebin_z) lt 1  THEN BEGIN
      psfilename='/Users/jgroh/temp/output_evol_'+xtitle+'_'+ytitle+'_'+label+'.eps'
ENDIF ELSE BEGIN 
     IF n_elements(labelz) LT 1 THEN labelz=''
      psfilename='/Users/jgroh/temp/output_evol_'+xtitle+'_'+ytitle+'_'+label+'_colorcoded_'+labelz+'.eps'
ENDELSE

!X.thick=8
!Y.thick=8
!P.THICK=12
!X.THICK=12
!Y.THICK=12
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=2
!P.CHARTHICK=12
ticklen = 25.
!x.ticklen = ticklen/bb
!y.ticklen = ticklen/aa
LOADCT,0,/SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
a=2.0 ;line thick obs
b=3.5 ;line thick model
lm=2
lm2=1
coloro=fsc_color('black')
colorm=fsc_color('red')
colorm2=fsc_color('blue')
colorm3=fsc_color('green')

IF KEYWORD_SET(XREVERSE) THEN XRANGE=REVERSE(XRANGE)
IF KEYWORD_SET(YREVERSE) THEN YRANGE=REVERSE(YRANGE)

loadct,ct,/silent
if N_elements(rebin_z) lt 1  THEN BEGIN
  cgplot,x,y,xstyle=1,ystyle=1,XRANGE=xrange,YRANGE=yrange, xtitle=xtitle,ytitle=ytitle,$
/nodata,_STRICT_EXTRA=extra
  cgplots,x,y,color='black',noclip=0
  IF ((N_elements(x2) GT 1) AND (N_elements(y2) GT 1)) THEN cgplots,x2,y2,color='red',noclip=0
ENDIF ELSE BEGIN
  if n_elements(minz) lt 1 THEN minz=min(rebin_z)
  if n_elements(maxz) lt 1 THEN maxz=max(rebin_z)
  cgplot,x,y,xstyle=1,ystyle=1,XRANGE=xrange,YRANGE=yrange, xtitle=xtitle,ytitle=ytitle,$
/nodata,POSITION=[0.12,0.1,0.87,0.95],_STRICT_EXTRA=extra
  cgplots,xr,yr,noclip=0,color=bytscl(rebin_z,MIN=minz,MAX=maxz)
  IF ((N_elements(x2) GT 1) AND (N_elements(y2) GT 1)) THEN cgplots,x2r,y2r,noclip=0,color=bytscl(rebin_z,MIN=minz,MAX=maxz)
  cgcolorbar,/vertical,/right,POSITION=[0.89,0.1,0.93,0.95],RANGE=[minz,maxz]
  xyouts,0.89,0.96,labelz,/NORMAL,color=fsc_color('black')
ENDELSE
;oploterror,pa1,vis1,errorvis1,psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('dark grey'),symsize=2
;plots,pa1,vis1,color=c1,noclip=0,linestyle=0
;plots,pa2,vis2,color=c2,noclip=0,linestyle=2,thick=25
xyouts,0.17,0.15,label,/NORMAL,color=fsc_color('black')


!X.THICK=0
!Y.THICK=0
!P.CHARTHICK=0
!P.CHARSIZE=0
!Y.charsize=0
!X.charsize=0
!P.THICK=0
!X.THiCK=0
!Y.THICK=0
!P.CHARTHICK=0
!P.MULTI=0
!X.THICK=0
!Y.THICK=0
!P.CHARTHICK=0
!P.CHARSIZE=0
!P.Background = fsc_color('white')
!Y.Type = 0
!X.Type = 0

END
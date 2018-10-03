PRO ZE_EVOL_PLOT_XY_GENERAL_V2,x,y,xtitle=xtitle,ytitle=ytitle,plotlabel=plotlabel,$
                                z1=z1,labelz=labelz,ct=ct,minz=minz,maxz=maxz,$
                                x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
                                x6=x6,y6=y6,x7=x7,y7=y7,x8=x8,y8=y8,x9=x9,y9=y9,x10=x10,y10=y10,$
                                z2=z2, z3=z3, z4=z4, z5=z5, z6=z6, z7=z7, z8=z8, z9=z9,z_10=z_10,$
                                rebin=rebin,factor=factor,xreverse=xreverse,yreverse=yreverse,_EXTRA=extra,timesteps=timesteps,$
                                pointsx2=pointsx2,pointsy2=pointsy2,psym1=psym1,symsize1=symsize1,symcolor1=symcolor1,$
                                psym2=psym2,symsize2=symsize2,symcolor2=symcolor2,psym3=psym3,symsize3=symsize3,symcolor3=symcolor3,$
                                info=info
;working on supporting multiple vectors on the same plot. right now for vector with the same number of points.
;working OK for x2,y2


!P.MULTI=0

IF n_elements(ct) lt 1 THEN ct=33

IF KEYWORD_SET(REBIN) THEN BEGIN
    ZE_EVOL_REBIN_XYZ,x,y,xr,yr,z=z1,rebin_z=rebin_z,factor=factor
    IF ((N_elements(x2) GT 1) AND (N_elements(y2) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x2,y2,x2r,y2r,z=z2,rebin_z=rebin_z2,factor=factor
    IF ((N_elements(x3) GT 1) AND (N_elements(y3) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x3,y3,x3r,y3r,z=z3,rebin_z=rebin_z3,factor=factor
    IF ((N_elements(x4) gt 1) AND (N_elements(y4) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x4,y4,x4r,y4r,z=z4,rebin_z=rebin_z4,factor=factor
    IF ((N_elements(x5) GT 1) AND (N_elements(y5) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x5,y5,x5r,y5r,z=z5,rebin_z=rebin_z5,factor=factor
    IF ((N_elements(x6) GT 1) AND (N_elements(y6) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x6,y6,x6r,y6r,z=z6,rebin_z=rebin_z6,factor=factor
    IF ((N_elements(x7) GT 1) AND (N_elements(y7) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x7,y7,x7r,y7r,z=z7,rebin_z=rebin_z7,factor=factor
    IF ((N_elements(x8) gt 1) AND (N_elements(y8) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x8,y8,x8r,y8r,z=z8,rebin_z=rebin_z8,factor=factor
    IF ((N_elements(x9) GT 1) AND (N_elements(y9) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x9,y9,x9r,y9r,z=z9,rebin_z=rebin_z9,factor=factor
    IF ((N_elements(x10) GT 1) AND (N_elements(y10) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x10,y10,x10r,y10r,z=z_10,rebin_z=rebin_z10,factor=factor
ENDIF ELSE BEGIN 
    xr=x
    yr=y
    IF N_elements(z1) GT 1 THEN rebin_z=z1
ENDELSE
posminx=0.12
posmaxx=0.87
posminy=0.1
posmaxy=0.95

IF (n_elements(xrange) LT 1) OR (n_elements(yrange) LT 1) THEN BEGIN 
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

  IF ((N_elements(x6) GT 1) AND (N_elements(y6) GT 1)) THEN BEGIN 
    ZE_FIND_OPTIMAL_XYPLOT_RANGE,x6,y6,position,xrange6,yrange6
    xrange=[min([xrange[0],xrange6[0]]),max([xrange[1],xrange6[1]])]
    yrange=[min([yrange[0],yrange6[0]]),max([yrange[1],yrange6[1]])]
    ENDIF

  IF ((N_elements(x7) GT 1) AND (N_elements(y7) GT 1)) THEN BEGIN 
    ZE_FIND_OPTIMAL_XYPLOT_RANGE,x7,y7,position,xrange7,yrange7
    xrange=[min([xrange[0],xrange7[0]]),max([xrange[1],xrange7[1]])]
    yrange=[min([yrange[0],yrange7[0]]),max([yrange[1],yrange7[1]])]
    ENDIF

  IF ((N_elements(x8) GT 1) AND (N_elements(y8) GT 1)) THEN BEGIN 
    ZE_FIND_OPTIMAL_XYPLOT_RANGE,x8,y8,position,xrange8,yrange8
    xrange=[min([xrange[0],xrange8[0]]),max([xrange[1],xrange8[1]])]
    yrange=[min([yrange[0],yrange8[0]]),max([yrange[1],yrange8[1]])]
    ENDIF

  IF ((N_elements(x9) GT 1) AND (N_elements(y9) GT 1)) THEN BEGIN 
    ZE_FIND_OPTIMAL_XYPLOT_RANGE,x9,y9,position,xrange9,yrange9
    xrange=[min([xrange[0],xrange9[0]]),max([xrange[1],xrange9[1]])]
    yrange=[min([yrange[0],yrange9[0]]),max([yrange[1],yrange9[1]])]
    ENDIF

  IF ((N_elements(x10) GT 1) AND (N_elements(y10) GT 1)) THEN BEGIN 
    ZE_FIND_OPTIMAL_XYPLOT_RANGE,x10,y10,position,xrange10,yrange10
    xrange=[min([xrange[0],xrange10[0]]),max([xrange[1],xrange10[1]])]
    yrange=[min([yrange[0],yrange10[0]]),max([yrange[1],yrange10[1]])]
    ENDIF

ENDIF

if n_elements(info) GT 0 then xreverse=info.xreverse
if n_elements(info) GT 0 then yreverse=info.yreverse
IF KEYWORD_SET(XREVERSE) THEN XRANGE=REVERSE(XRANGE)
IF KEYWORD_SET(YREVERSE) THEN YRANGE=REVERSE(YRANGE)

!X.thick=2
!Y.thick=2
!P.THICK=3
!X.THICK=3
!Y.THICK=3
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=2
!P.CHARTHICK=2
;ticklen = 25.
;!x.ticklen = ticklen/bb
;!y.ticklen = ticklen/aa
LOADCT,0,/SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

loadct,ct,/silent

if N_elements(rebin_z) lt 1  THEN BEGIN ;no Z values to do color-coding
   if keyword_set(rebin) THEN BEGIN;datah as been rebinned
       cgplot,xr,yr,xstyle=1,ystyle=1,XRANGE=xrange,YRANGE=yrange, xtitle=xtitle,ytitle=ytitle,$
       /nodata,POSITION=[0.12,0.12,0.97,0.97],_STRICT_EXTRA=extra
       cgplots,xr,yr,color='black',noclip=0,psym=psym1,symsize=symsize1,symcolor=symcolor1
       IF ((N_elements(x2r) GT 1) AND (N_elements(y2r) GT 1)) THEN cgplots,x2r,y2r,color='green',noclip=0,psym=psym2,symsize=symsize2,symcolor=symcolor2
       IF ((N_elements(x3r) GT 1) AND (N_elements(y3r) GT 1)) THEN cgplots,x3r,y3r,color='red',noclip=0,psym=psym3,symsize=symsize3,symcolor=symcolor3
       IF ((N_elements(x4r) GT 1) AND (N_elements(y4r) GT 1)) THEN cgplots,x4r,y4r,color='pink',noclip=0
       IF ((N_elements(x5r) GT 1) AND (N_elements(y5r) GT 1)) THEN cgplots,x5r,y5r,color='blue',noclip=0
       IF ((N_elements(x6r) GT 1) AND (N_elements(y6r) GT 1)) THEN cgplots,x6r,y6r,color='cyan',noclip=0
       IF ((N_elements(x7r) GT 1) AND (N_elements(y7r) GT 1)) THEN cgplots,x7r,y7r,color='orange',noclip=0
       IF ((N_elements(x8r) GT 1) AND (N_elements(y8r) GT 1)) THEN cgplots,x8r,y8r,color='purple',noclip=0    
       IF ((N_elements(x9r) GT 1) AND (N_elements(y9r) GT 1)) THEN cgplots,x9r,y9r,color='purple',noclip=0
       IF ((N_elements(x10r) GT 1) AND (N_elements(y10r) GT 1)) THEN cgplots,x10r,y10r,color='purple',noclip=0 
   ENDIF ELSE BEGIN; data has not been rebinned
       cgplot,x,y,xstyle=1,ystyle=1,XRANGE=xrange,YRANGE=yrange, xtitle=xtitle,ytitle=ytitle,$
       /nodata,POSITION=[0.12,0.12,0.97,0.97],_STRICT_EXTRA=extra
       cgplots,x,y,color='black',noclip=0,psym=psym1,symsize=symsize1,symcolor=symcolor1
       IF ((N_elements(x2) GT 1) AND (N_elements(y2) GT 1)) THEN cgplots,x2,y2,color='red',noclip=0,psym=psym2,symsize=symsize2,symcolor=symcolor2
       IF ((N_elements(x3) GT 1) AND (N_elements(y3) GT 1)) THEN cgplots,x3,y3,color='blue',noclip=0,psym=psym3,symsize=symsize3,symcolor=symcolor3
       IF ((N_elements(x4) GT 1) AND (N_elements(y4) GT 1)) THEN cgplots,x4,y4,color='dark green',noclip=0
       IF ((N_elements(x5) GT 1) AND (N_elements(y5) GT 1)) THEN cgplots,x5,y5,color='orange',noclip=0
       IF ((N_elements(x6) GT 1) AND (N_elements(y6) GT 1)) THEN cgplots,x6,y6,color='cyan',noclip=0
       IF ((N_elements(x7) GT 1) AND (N_elements(y7) GT 1)) THEN cgplots,x7,y7,color='purple',noclip=0
       IF ((N_elements(x8) GT 1) AND (N_elements(y8) GT 1)) THEN cgplots,x8,y8,color='purple',noclip=0    
       IF ((N_elements(x9) GT 1) AND (N_elements(y9) GT 1)) THEN cgplots,x9,y9,color='purple',noclip=0
       IF ((N_elements(x10) GT 1) AND (N_elements(y10) GT 1)) THEN cgplots,x10,y10,color='purple',noclip=0 
   ENDELSE           
ENDIF ELSE BEGIN ;always plot rebinned data
  if n_elements(minz) lt 1 THEN minz=min(rebin_z)
  if n_elements(maxz) lt 1 THEN maxz=max(rebin_z)
  cgplot,x,y,xstyle=1,ystyle=1,XRANGE=xrange,YRANGE=yrange, xtitle=xtitle,ytitle=ytitle,$
/nodata,POSITION=[0.12,0.1,0.87,0.95],_STRICT_EXTRA=extra
  cgplots,xr,yr,noclip=0,color=bytscl(rebin_z,MIN=minz,MAX=maxz)
  IF ((N_elements(x2) GT 1) AND (N_elements(y2) GT 1)) THEN cgplots,x2r,y2r,noclip=0,color=bytscl(rebin_z2,MIN=minz,MAX=maxz)
  IF ((N_elements(x3) GT 1) AND (N_elements(y3) GT 1)) THEN cgplots,x3r,y3r,noclip=0,color=bytscl(rebin_z3,MIN=minz,MAX=maxz),linestyle=2
  IF ((N_elements(x4) GT 1) AND (N_elements(y4) GT 1)) THEN cgplots,x4r,y4r,noclip=0,color=bytscl(rebin_z4,MIN=minz,MAX=maxz),linestyle=2
  IF ((N_elements(x5) GT 1) AND (N_elements(y5) GT 1)) THEN cgplots,x5r,y5r,noclip=0,color=bytscl(rebin_z5,MIN=minz,MAX=maxz)
  IF ((N_elements(x6) GT 1) AND (N_elements(y6) GT 1)) THEN cgplots,x6r,y6r,noclip=0,color=bytscl(rebin_z6,MIN=minz,MAX=maxz)  
  IF ((N_elements(x7) GT 1) AND (N_elements(y7) GT 1)) THEN cgplots,x7r,y7r,noclip=0,color=bytscl(rebin_z7,MIN=minz,MAX=maxz)  
  IF ((N_elements(x8) GT 1) AND (N_elements(y8) GT 1)) THEN cgplots,x8r,y8r,noclip=0,color=bytscl(rebin_z8,MIN=minz,MAX=maxz) 
  IF ((N_elements(x9) GT 1) AND (N_elements(y9) GT 1)) THEN cgplots,x9r,y9r,noclip=0,color=bytscl(rebin_z9,MIN=minz,MAX=maxz)
  IF ((N_elements(x10) GT 1) AND (N_elements(y10) GT 1)) THEN cgplots,x10r,y10r,noclip=0,color=bytscl(rebin_z10,MIN=minz,MAX=maxz)   

  cgcolorbar,/vertical,/right,POSITION=[0.89,0.1,0.93,0.95],RANGE=[minz,maxz]
  xyouts,0.89,0.96,labelz,/NORMAL,color=fsc_color('black')
ENDELSE
;tmodel=[48386.4 ,  47031.9   ,  45796.1 , 39375.6  , 31088.6   ,  27864.3 ,   30783.7, 45243.1 , 56420.0  ,63351.2, 69550.6, 92369. ,140543.,136008.,133655. ,126228. ]
;
;lmodel=[507016. ,  528381.   ,  555083. , 645563.  , 719179.   ,  743098. ,   941860., 916947. , 897212.  ,883519.,  870531.,791920.,  350244., 434538.,507200.,545449.]
;timesteps=[56,500,1000,2500,3500,3800,5500,5820,6250,6551,6851,7201,11201,12551,14951,18950.]
if n_elements(timesteps) GT 0 THEN BEGIN
  cgplots,x[timesteps],y[timesteps],psym=4,symsize=3.
  for i=0, n_elements(timesteps) -1 DO xyouts,x[timesteps[i]],y[timesteps[i]],string(timesteps[i],format='(I5)'),/DATA,color=fsc_color('black'),charsize=1.5
endif

IF ((N_elements(x2points) GT 1) AND (N_elements(y2points) GT 1)) THEN cgplots,x2points,y2points,color='green',psym=4,symsize=3. 
;IF ((N_elements(x2points) GT 1) AND (N_elements(y2points) GT 1)) THEN cgplots,x2points,y2points,color='green',linestyle=2
;oploterror,pa1,vis1,errorvis1,psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('dark grey'),symsize=2
;plots,pa1,vis1,color=c1,noclip=0,linestyle=0
;plots,pa2,vis2,color=c2,noclip=0,linestyle=2,thick=25
IF N_elements(label) GT 0 THEN xyouts,0.17,0.15,label,/NORMAL,color=fsc_color('black')
;plots,lambdamod2,fluxmod2d23r/s/scale_full,color=colorm2,linestyle=lm2, noclip=0,clip=[x1l,0,x1u,1.9e-11/s],thick=b+1.5
;plots,lmcav,fmcavd23r/s/scale,color=colorm,linestyle=lm,noclip=0,clip=[1270.0,0,x1u,1.9e-11/s],thick=b+1.5

;putting labels on the first panel
;plots, [1270,1275],[0.41e-11/s,0.41e-11/s],color=coloro,thick=b+1.5
;xyouts,1277,0.40e-11/s,TEXTOIDL('obs \phi_{orb}=10.410 '),alignment=0,orientation=0,charsize=0.8
;plots, [1270,1275],[0.33e-11/s,0.33e-11/s],color=colorm2,thick=b+1.5,linestyle=lm
;xyouts,1277,0.32e-11/s,TEXTOIDL('1D CMFGEN model'),alignment=0,orientation=0,color=colorm2,charsize=0.8
;plots, [1270,1275],[0.25e-11/s,0.25e-11/s],color=colorm,thick=b+1.5
;xyouts,1277,0.24e-11/s,TEXTOIDL('2D cavity model'),alignment=0,orientation=0,color=colorm,charsize=0.8


;xyouts,400,2000,'Flux [10!E-12!N erg/s/cm!E2!N/'+Angstrom+' ]',charthick=3.5,orientation=90,/DEVICE

!p.multi=[0, 0, 0, 0, 0]
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
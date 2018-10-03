PRO ZE_EVOL_PLOT_XY_GENERAL_EPS,x,y,xtitle,ytitle,label,$
                                z=z,labelz=labelz,ct=ct,minz=minz,maxz=maxz,rebin=rebin,xreverse=xreverse,yreverse=yreverse,_EXTRA=extra

IF n_elements(ct) lt 1 THEN ct=33

IF KEYWORD_SET(REBIN) THEN BEGIN
   factor=10.0
   print,'Rebinning data with factor= ',1D0/factor
   xr=congrid(x,FLOOR(n_elements(x)/factor))
   yr=congrid(y,FLOOR(n_elements(y)/factor))
   IF N_elements(z) GT 0 THEN zr=congrid(z,FLOOR(n_elements(z)/factor))
ENDIF 
   
close,/all
!P.MULTI=0

posminx=0.12
posmaxx=0.87
posminy=0.1
posmaxy=0.95

ZE_FIND_OPTIMAL_XYPLOT_RANGE,x,y,position,xrange,yrange

;making psplots
set_plot,'ps'

device,/close

aa=800
bb=600
ps_ysize=10.
ps_xsize=ps_ysize*aa/bb

print,label
if N_elements(zr) lt 1 THEN BEGIN
      psfilename='/Users/jgroh/temp/output_evol_'+xtitle+'_'+ytitle+'_'+label+'.eps'
ENDIF ELSE BEGIN 
     IF n_elements(labelz) LT 1 THEN labelz=''
      psfilename='/Users/jgroh/temp/output_evol_'+xtitle+'_'+ytitle+'_'+label+'_colorcoded_'+labelz+'.eps'
ENDELSE

device,filename=psfilename,/encapsulated,/color,bit=8,xsize=ps_xsize,ysize=ps_ysize,/inches

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
if N_elements(zr) lt 1 THEN BEGIN
  cgplot,x,y,xstyle=1,ystyle=1,XRANGE=[xmin,xmax],YRANGE=[min(y)*0.93,max(y)*1.07], xtitle=xtitle,ytitle=ytitle,$
/nodata,_STRICT_EXTRA=extra
  cgplots,x,y,color='black',noclip=0
ENDIF ELSE BEGIN
  if n_elements(minz) lt 1 THEN minz=min(zr)
  if n_elements(maxz) lt 1 THEN maxz=max(zr)
  cgplot,x,y,xstyle=1,ystyle=1,XRANGE=xrange,YRANGE=yrange, xtitle=xtitle,ytitle=ytitle,$
/nodata,POSITION=[0.12,0.1,0.87,0.95],_STRICT_EXTRA=extra
  cgplots,xr,yr,noclip=0,color=bytscl(zr,MIN=minz,MAX=maxz)
  cgcolorbar,/vertical,/right,POSITION=[0.89,0.1,0.93,0.95],RANGE=[minz,maxz]
  xyouts,0.89,0.96,labelz,/NORMAL,color=fsc_color('black')
ENDELSE
;oploterror,pa1,vis1,errorvis1,psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('dark grey'),symsize=2
;plots,pa1,vis1,color=c1,noclip=0,linestyle=0
;plots,pa2,vis2,color=c2,noclip=0,linestyle=2,thick=25
xyouts,0.15,0.15,label,/NORMAL,color=fsc_color('black')
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
device,/close
set_plot,'x'
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
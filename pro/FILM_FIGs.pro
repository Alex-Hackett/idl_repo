PRO FILM_FIGs
RESTORE,filename="FILM.dat"
print,phase0
print,phase1
print,phase2
print,phase3
print,phase4
print,phase5
print,phase6
print,phase7
print,phase8
print,phase9
print,NBnom
Nbok=2*NBnom+1
print,Nbok

velocityM=-250. ; ATTENTION verifier la compatibilite avec lambda1 & lambda2
velocityP=250. 
V1=235.
V2=250.
!P.CHARSIZE=1.2
;!P.CHARTHICK=0.8

;------------------------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------FIGURE RT ---------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------------

image1=imageRT_Halpha
xvector1=xvectorRT_Halpha
yvector1=yvectorRT_Halpha

p1=[0.1, 0.12, 0.90, 0.92]
pBar1=[0.92,0.12,0.94,0.92]
denconbetatrunc = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0]
new=FORMAT_AXIS_VALUES(denconbetatrunc)
window,0
device,retain=2

colors = GetColor(/Load)
!P.Background = colors.white
!P.Color = colors.black
LOADCT,13

tvlaser,BARPOS='no',/noPrint,/COLORPS,/INTERP,NCOLORSDW=512.,/PORTRAIT,FILENAME='/.aux_mnt/pc20074a/undomiel/HARPSinter/reductionHARPS/EX_FILM/idl.ps'
set_plot,'ps'
DEVICE,filename='/.aux_mnt/pc20074a/undomiel/HARPSinter/reductionHARPS/EX_FILM/Ha_RT.ps'
FORMAT='(F3.1)'


PLOT, xvector1,yvector1, xrange=[velocityM,velocityP], yrange=[0,2],xtitle='velocity (km/s)', ytitle='phase' ,position=p1,/NODATA
TVscale,image1,position=p1,minvalue=0.0,maxvalue=1.0,Bottom=0.
AXIS,XAXIS=0,xrange=[velocityM,velocityP],yrange=[min(yvector1),max(yvector1)]
AXIS,YAXIS=0
FOR i=0,Nbok(0)-3 DO BEGIN
PLOTS,V1,phase0(i)
PLOTS,V2,phase0(i),/CONTINU;,THICK=2.0
ENDFOR

Colorbar, FORMAT='(F3.1)',position=pBar1,/VERTICAL,/RIGHT,TICKNAMES=new, RANGE=[0.1,1.0], DIVISIONS=9,XTITLE='Flux',CHARSIZE=1.2,Bottom=0.
XYOUTS, 0.50,0.94, 'R TrA  P=3.4d',/NORMAL,CHARSIZE=2.0


!P.Multi=0

DEVICE,/CLOSE
;set_plot,'x'

tvlaser,BARPOS='no',/noPrint,/COLORPS,/INTERP,NCOLORSDW=512.,/PORTRAIT,FILENAME='/.aux_mnt/pc20074a/undomiel/HARPSinter/reductionHARPS/EX_FILM/idl.ps'

;------------------------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------FIGURE SC ---------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------------

image1=imageSC_Halpha
xvector1=xvectorSC_Halpha
yvector1=yvectorSC_Halpha

p1=[0.1, 0.12, 0.90, 0.92]
pBar1=[0.92,0.12,0.94,0.92]
denconbetatrunc = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0]
new=FORMAT_AXIS_VALUES(denconbetatrunc)

;set_plot,'ps'
DEVICE,filename='/.aux_mnt/pc20074a/undomiel/HARPSinter/reductionHARPS/EX_FILM/Ha_SC.ps'
FORMAT='(F3.1)'

PLOT, xvector1,yvector1, xrange=[velocityM,velocityP], yrange=[0,2],xtitle='velocity (km/s)', ytitle='phase' ,position=p1,/NODATA
TVscale,image1,position=p1,minvalue=0.1,maxvalue=1.0,Bottom=0.
AXIS,XAXIS=0,xrange=[velocityM,velocityP],yrange=[min(yvector1),max(yvector1)]
AXIS,YAXIS=0
FOR i=0,Nbok(1)-3 DO BEGIN
PLOTS,V1,phase1(i)
PLOTS,V2,phase1(i),/CONTINU;,THICK=2.0
ENDFOR

Colorbar, FORMAT='(F3.1)',position=pBar1,/VERTICAL,/RIGHT,TICKNAMES=new, RANGE=[0.1,1.0], DIVISIONS=9,XTITLE='Flux',CHARSIZE=1.2,Bottom=0
XYOUTS, 0.50,0.94, 'S Cru  P=4.7d',/NORMAL,CHARSIZE=2.0

!P.Multi=0
DEVICE,/CLOSE
;set_plot,'x'

;------------------------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------FIGURE Y Sgr---------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------------

image1=imageYS_Halpha
xvector1=xvectorYS_Halpha
yvector1=yvectorYS_Halpha

p1=[0.1, 0.12, 0.90, 0.92]
pBar1=[0.92,0.12,0.94,0.92]
denconbetatrunc = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0]
new=FORMAT_AXIS_VALUES(denconbetatrunc)

;set_plot,'ps'
DEVICE,filename='/.aux_mnt/pc20074a/undomiel/HARPSinter/reductionHARPS/EX_FILM/Ha_YS.ps';COLORS=256
FORMAT='(F3.1)'


PLOT, xvector1,yvector1, xrange=[velocityM,velocityP], yrange=[0,2],xtitle='velocity (km/s)', ytitle='phase' ,position=p1,/NODATA
TVscale,image1,position=p1,minvalue=0.1,maxvalue=1.0,Bottom=0.
AXIS,XAXIS=0,xrange=[velocityM,velocityP],yrange=[min(yvector1),max(yvector1)]
AXIS,YAXIS=0
FOR i=0,Nbok(2)-3 DO BEGIN
PLOTS,V1,phase2(i)
PLOTS,V2,phase2(i),/CONTINU;,THICK=2.0
ENDFOR

Colorbar, FORMAT='(F3.1)',position=pBar1,/VERTICAL,/RIGHT,TICKNAMES=new, RANGE=[0.1,1.0], DIVISIONS=9,XTITLE='Flux',CHARSIZE=1.2,Bottom=0.
XYOUTS, 0.50,0.94, 'Y Sgr  P=5.8d',/NORMAL,CHARSIZE=2.0

!P.Multi=0
DEVICE,/CLOSE
;set_plot,'x'

;------------------------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------FIGURE BD---------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------------

image1=imageBD_Halpha
xvector1=xvectorBD_Halpha
yvector1=yvectorBD_Halpha

p1=[0.1, 0.12, 0.90, 0.92]
pBar1=[0.92,0.12,0.94,0.92]
denconbetatrunc = [0.2, 0.4,0.6, 0.8,1.0]
new=FORMAT_AXIS_VALUES(denconbetatrunc)
; window,3



;set_plot,'x'
; colors = GetColor(/Load)
; !P.Background = colors.white
; !P.Color = colors.black

set_plot,'ps'
DEVICE,filename='/.aux_mnt/pc20074a/undomiel/HARPSinter/reductionHARPS/EX_FILM/Ha_BD.ps';,COLORS=256
FORMAT='(F3.1)'


PLOT, xvector1,yvector1, xrange=[velocityM,velocityP], yrange=[0,2],xtitle='velocity (km/s)', ytitle='phase' ,position=p1,/NODATA
TVscale,image1,position=p1,minvalue=0.2,maxvalue=1.0,Bottom=0.
AXIS,XAXIS=0,xrange=[velocityM,velocityP],yrange=[min(yvector1),max(yvector1)]
AXIS,YAXIS=0
FOR i=0,Nbok(4)-3 DO BEGIN
PLOTS,V1,phase4(i)
PLOTS,V2,phase4(i),/CONTINU;,THICK=2.0
ENDFOR
!P.Multi=0
Colorbar, FORMAT='(F3.1)',position=pBar1,/VERTICAL,/RIGHT,TICKNAMES=new, RANGE=[0.2,1.0], DIVISIONS=4,XTITLE='Flux',CHARSIZE=1.2,Bottom=0.
XYOUTS, 0.50,0.94, ' !4b!X Dor  P=9.8d',/NORMAL, CHARSIZE=2.0
;XYOUTS, 0.50,0.60, ' !4b!X Dor  P=9.8d',/NORMAL,CHARSIZE=1.5

DEVICE,/CLOSE
;set_plot,'x'
;set_plot,'ps'

;------------------------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------FIGURE ZG---------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------------

image1=imageZG_Halpha
xvector1=xvectorZG_Halpha
yvector1=yvectorZG_Halpha

p1=[0.1, 0.12, 0.90, 0.92]
pBar1=[0.92,0.12,0.94,0.92]
denconbetatrunc = [0.2, 0.4,0.6, 0.8,1.0]
new=FORMAT_AXIS_VALUES(denconbetatrunc)
; window,4
; device,retain=2

;tvlaser,BARPOS='no',/noPrint,/COLORPS;,/INTERP,NCOLORSDW=512.,/PORTRAIT,FILENAME='/.aux_mnt/pc20074a/undomiel/HARPSinter/reductionHARPS/EX_FILM/FIG2D/idl.ps'

;set_plot,'ps'
DEVICE,filename='/.aux_mnt/pc20074a/undomiel/HARPSinter/reductionHARPS/EX_FILM/Ha_ZG.ps'
FORMAT='(F3.1)'

PLOT, xvector1,yvector1, xrange=[velocityM,velocityP], yrange=[0,2],xtitle='velocity (km/s)', ytitle='phase' ,position=p1,/NODATA
TVscale,image1,position=p1,minvalue=0.2,maxvalue=1.0,Bottom=0.
AXIS,XAXIS=0,xrange=[velocityM,velocityP],yrange=[min(yvector1),max(yvector1)]
AXIS,YAXIS=0
FOR i=0,Nbok(5)-3 DO BEGIN
PLOTS,V1,phase5(i)
PLOTS,V2,phase5(i),/CONTINU;,THICK=2.0
ENDFOR

Colorbar, FORMAT='(F3.1)',position=pBar1,/VERTICAL,/RIGHT,TICKNAMES=new, RANGE=[0.2,1.0], DIVISIONS=4,XTITLE='Flux',CHARSIZE=1.2,Bottom=0.
XYOUTS, 0.50,0.94, '!4f!X Gem  P=10.1d',/NORMAL,CHARSIZE=2.0

;!P.Multi=0
DEVICE,/CLOSE
;set_plot,'x'
;tvlaser,BARPOS='no',/noPrint,/COLORPS;,/INTERP,NCOLORSDW=512.,/PORTRAIT,FILENAME='/.aux_mnt/pc20074a/undomiel/HARPSinter/reductionHARPS/EX_FILM/FIG2D/idl.ps'
;------------------------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------FIGURE RZV---------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------------

image1=imageRZV_Halpha
xvector1=xvectorRZV_Halpha
yvector1=yvectorRZV_Halpha

p1=[0.1, 0.12, 0.90, 0.92]
pBar1=[0.92,0.12,0.94,0.92]
denconbetatrunc = [0.2,0.4, 0.6, 0.8,1.0,1.2]
new=FORMAT_AXIS_VALUES(denconbetatrunc)
; window,5
; device,retain=2
;colors = GetColor(/Load)
;!P.Background = colors.white
;!P.Color = colors.black

;set_plot,'ps'
DEVICE,filename='/.aux_mnt/pc20074a/undomiel/HARPSinter/reductionHARPS/EX_FILM/Ha_RZV.ps'
FORMAT='(F3.1)'


PLOT, xvector1,yvector1, xrange=[velocityM,velocityP], yrange=[0,2],xtitle='velocity (km/s)', ytitle='phase' ,position=p1,/NODATA
TVscale,image1,position=p1,minvalue=0.2,maxvalue=1.2,Bottom=0.
PRINT,'RZV',MAX(image1)
AXIS,XAXIS=0,xrange=[velocityM,velocityP],yrange=[min(yvector1),max(yvector1)]
AXIS,YAXIS=0
FOR i=0,Nbok(7)-3 DO BEGIN
PLOTS,V1,phase7(i)
PLOTS,V2,phase7(i),/CONTINU;,THICK=2.0
ENDFOR

Colorbar, FORMAT='(F3.1)',position=pBar1,/VERTICAL,/RIGHT,TICKNAMES=new, RANGE=[0.2,1.2], DIVISIONS=5,XTITLE='Flux',CHARSIZE=1.2,Bottom=0.
XYOUTS, 0.50,0.94, 'RZ Vel  P=20.4d',/NORMAL,CHARSIZE=2.0

; !P.Multi=0
DEVICE,/CLOSE
;set_plot,'x'

;------------------------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------FIGURE LC---------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------------

image1=imageLC_Halpha
xvector1=xvectorLC_Halpha
yvector1=yvectorLC_Halpha


p1=[0.1, 0.12, 0.90, 0.92]
pBar1=[0.92,0.12,0.94,0.92]
denconbetatrunc = [0.2,0.4, 0.6, 0.8,1.0,1.2]
new=FORMAT_AXIS_VALUES(denconbetatrunc)

; colors = GetColor(/Load)
; !P.Background = colors.white
;!P.Color = colors.black
LOADCT,13

;set_plot,'ps'
DEVICE,filename='/.aux_mnt/pc20074a/undomiel/HARPSinter/reductionHARPS/EX_FILM/Ha_LC.ps'
FORMAT='(F3.1)'

PLOT, xvector1,yvector1, xrange=[velocityM,velocityP], yrange=[0,2],xtitle='velocity (km/s)', ytitle='phase' ,position=p1,/NODATA
TVscale,image1,position=p1,minvalue=0.2,maxvalue=1.2,Bottom=0
AXIS,XAXIS=0,xrange=[velocityM,velocityP],yrange=[min(yvector1),max(yvector1)]
AXIS,YAXIS=0
FOR i=0,Nbok(8)-3 DO BEGIN
PLOTS,V1,phase8(i)
PLOTS,V2,phase8(i),/CONTINU;,THICK=2.0
ENDFOR

Colorbar, FORMAT='(F3.1)',position=pBar1,/VERTICAL,/RIGHT,TICKNAMES=new, RANGE=[0.2,1.2], DIVISIONS=5,XTITLE='Flux',CHARSIZE=1.2,Bottom=0
XYOUTS, 0.50,0.94, 'l Car  P=35.6d',/NORMAL,CHARSIZE=2.0

; !P.Multi=0
DEVICE,/CLOSE
;set_plot,'x'

;------------------------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------FIGURE RSP---------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------------

image1=imageRSP_Halpha
xvector1=xvectorRSP_Halpha
yvector1=yvectorRSP_Halpha

p1=[0.1, 0.12, 0.90, 0.92]
pBar1=[0.92,0.12,0.94,0.92]
denconbetatrunc = [0.2,0.4, 0.6, 0.8,1.0,1.2]
new=FORMAT_AXIS_VALUES(denconbetatrunc)
; window,7

;set_plot,'ps'
DEVICE,filename='/.aux_mnt/pc20074a/undomiel/HARPSinter/reductionHARPS/EX_FILM/Ha_RSP.ps'
FORMAT='(F3.1)'

PLOT, xvector1,yvector1, xrange=[velocityM,velocityP], yrange=[0,2],xtitle='velocity (km/s)', ytitle='phase' ,position=p1,/NODATA
TVscale,image1,Bottom=0.,position=p1,minvalue=0.2,maxvalue=1.2
PRINT,'R',MAX(image1)
AXIS,XAXIS=0,xrange=[velocityM,velocityP],yrange=[min(yvector1),max(yvector1)]
AXIS,YAXIS=0
FOR i=0,Nbok(9)-3 DO BEGIN
PLOTS,V1,phase9(i)
PLOTS,V2,phase9(i),/CONTINU;,THICK=2.0
ENDFOR

Colorbar, FORMAT='(F3.1)',position=pBar1,/VERTICAL,/RIGHT,TICKNAMES=new, RANGE=[0.2,1.2], DIVISIONS=5,XTITLE='Flux',CHARSIZE=1.2,BOTTOM=0.
XYOUTS, 0.50,0.94, 'RS Pup  P=41.5d',/NORMAL,CHARSIZE=2.0

; !P.Multi=0
DEVICE,/CLOSE
;set_plot,'x'

;------------------------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------FIGURE LC H Beta---------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------------

image1=imageLC_Hbeta
xvector1=xvectorLC_Hbeta
yvector1=yvectorLC_Hbeta

p1=[0.1, 0.12, 0.90, 0.92]
pBar1=[0.92,0.12,0.94,0.92]
denconbetatrunc = [0.0,0.2, 0.4,0.6, 0.8,1.0]
new=FORMAT_AXIS_VALUES(denconbetatrunc)
; window,6
; device,retain=2
;colors = GetColor(/Load)
;!P.Background = colors.white
;!P.Color = colors.black

;set_plot,'ps'
DEVICE,filename='/.aux_mnt/pc20074a/undomiel/HARPSinter/reductionHARPS/EX_FILM/Hb_LC.ps'
FORMAT='(F3.1)'

PLOT, xvector1,yvector1, xrange=[velocityM,velocityP], yrange=[0,2],xtitle='velocity (km/s)', ytitle='phase' ,position=p1,/NODATA
print,MIN(image1)
TVscale,image1,Bottom=0.,position=p1,minvalue=0.0,maxvalue=1.0
AXIS,XAXIS=0,xrange=[velocityM,velocityP],yrange=[min(yvector1),max(yvector1)]
AXIS,YAXIS=0
FOR i=0,Nbok(8)-3 DO BEGIN
PLOTS,V1,phase8(i)
PLOTS,V2,phase8(i),/CONTINU;,THICK=2.0
ENDFOR

Colorbar, FORMAT='(F3.1)',position=pBar1,/VERTICAL,/RIGHT,TICKNAMES=new, RANGE=[0.0,1.0], DIVISIONS=5,XTITLE='Flux',CHARSIZE=1.2,Bottom=0.
XYOUTS, 0.50,0.94, 'l Car  P=35.6d',/NORMAL,CHARSIZE=2.0



;------------------------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------FIGURE RZV    REF TOP = MAX flux---------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------------

image1=imageRZV_Halpha
xvector1=xvectorRZV_Halpha
yvector1=yvectorRZV_Halpha

p1=[0.1, 0.12, 0.90, 0.92]
pBar1=[0.92,0.12,0.94,0.92]
denconbetatrunc = [0.2,0.4, 0.6, 0.8,1.0]
;denconbetatrunc=denconbetatrunc/MAX(image1)
new=FORMAT_AXIS_VALUES(denconbetatrunc)
; window,5
; device,retain=2
;colors = GetColor(/Load)
;!P.Background = colors.white
;!P.Color = colors.black

;set_plot,'ps'
DEVICE,filename='/.aux_mnt/pc20074a/undomiel/HARPSinter/reductionHARPS/EX_FILM/Ha_RZV_maxflux.ps'
FORMAT='(F3.1)'

!P.CHARSIZE=1.5
PLOT, xvector1,yvector1, xrange=[velocityM,velocityP], yrange=[0,2],xtitle='velocity (km/s)', ytitle='phase' ,position=p1,/NODATA
TVscale,image1/MAX(image1),position=p1,minvalue=0.2,maxvalue=1.0
; imageTRONC=image1
; imageTRONC(0:2500,*)=0.
; imageTRONC(7500:10000,*)=0.
; CONTOUR, imageTRONC,xvector1,yvector1,LEVELS=0.95,C_THICK=1.5, /overplot,min_value=0.2,max_value=MAX(image1)
; SAVE,image1,xvector1,yvector1,velocityM,velocityP,p1
; SAVE,filename='test_contour'
AXIS,XAXIS=0,xrange=[velocityM,velocityP],yrange=[min(yvector1),max(yvector1)]
AXIS,YAXIS=0
FOR i=0,Nbok(7)-3 DO BEGIN
PLOTS,V1,phase7(i)
PLOTS,V2,phase7(i),/CONTINU;,THICK=2.0
ENDFOR

Colorbar, FORMAT='(F3.1)',position=pBar1,/VERTICAL,/RIGHT,TICKNAMES=new, RANGE=[0.2,max(image1)], DIVISIONS=4,XTITLE='F/Fmax',CHARSIZE=1.5
XYOUTS, 0.40,0.94, 'RZ Vel  P=20.4d',/NORMAL,CHARSIZE=2.5

; !P.Multi=0
DEVICE,/CLOSE
;set_plot,'x'

;------------------------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------FIGURE LC REF TOP = MAX flux---------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------------

image1=imageLC_Halpha
xvector1=xvectorLC_Halpha
yvector1=yvectorLC_Halpha


p1=[0.1, 0.12, 0.90, 0.92]
pBar1=[0.92,0.12,0.94,0.92]
denconbetatrunc = [0.2,0.4, 0.6, 0.8,1.0]
; denconbetatrunc=denconbetatrunc/MAX(image1)
new=FORMAT_AXIS_VALUES(denconbetatrunc)
; window,6
; device,retain=2
;colors = GetColor(/Load)
;!P.Background = colors.white
;!P.Color = colors.black

;set_plot,'ps'
DEVICE,filename='/.aux_mnt/pc20074a/undomiel/HARPSinter/reductionHARPS/EX_FILM/Ha_LC_maxflux.ps'
FORMAT='(F3.1)'
!P.CHARSIZE=1.5
PLOT, xvector1,yvector1, xrange=[velocityM,velocityP], yrange=[0,2],xtitle='velocity (km/s)', ytitle='phase' ,position=p1,/NODATA
TVscale,image1/MAX(image1),position=p1,minvalue=0.2,maxvalue=1.0
; imageTRONC=image1
; imageTRONC(0:2500,*)=0.
; imageTRONC(7900:10000,*)=0.
; CONTOUR, imageTRONC,xvector1,yvector1,LEVELS=0.95,C_THICK=1.5, /overplot,min_value=0.2,max_value=MAX(image1)
AXIS,XAXIS=0,xrange=[velocityM,velocityP],yrange=[min(yvector1),max(yvector1)]
AXIS,YAXIS=0
FOR i=0,Nbok(8)-3 DO BEGIN
PLOTS,V1,phase8(i)
PLOTS,V2,phase8(i),/CONTINU;,THICK=2.0
ENDFOR

Colorbar, FORMAT='(F3.1)',position=pBar1,/VERTICAL,/RIGHT,TICKNAMES=new, RANGE=[0.2,max(image1)], DIVISIONS=4,XTITLE='F/Fmax',CHARSIZE=1.5
XYOUTS, 0.40,0.94, 'l Car  P=35.6d',/NORMAL,CHARSIZE=2.5

; !P.Multi=0
DEVICE,/CLOSE
;set_plot,'x'

;------------------------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------FIGURE RSP REF TOP = MAX flux---------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------------

image1=imageRSP_Halpha
xvector1=xvectorRSP_Halpha
yvector1=yvectorRSP_Halpha

p1=[0.1, 0.12, 0.90, 0.92]
pBar1=[0.92,0.12,0.94,0.92]
denconbetatrunc = [0.2,0.4, 0.6, 0.8,1.0]
; denconbetatrunc=denconbetatrunc/MAX(image1)
new=FORMAT_AXIS_VALUES(denconbetatrunc)
; window,7

;set_plot,'ps'
DEVICE,filename='/.aux_mnt/pc20074a/undomiel/HARPSinter/reductionHARPS/EX_FILM/Ha_RSP_maxflux.ps'
FORMAT='(F3.1)'
!P.CHARSIZE=1.5
PLOT, xvector1,yvector1, xrange=[velocityM,velocityP], yrange=[0,2],xtitle='velocity (km/s)', ytitle='phase' ,position=p1,/NODATA
TVscale,image1/MAX(image1),position=p1,minvalue=0.2,maxvalue=1.0
; imageTRONC=image1
; imageTRONC(0:2500,*)=0.
; imageTRONC(7500:10000,*)=0.
; CONTOUR, imageTRONC,xvector1,yvector1,LEVELS=0.95,C_THICK=1.5, /overplot,min_value=0.2,max_value=MAX(image1)
AXIS,XAXIS=0,xrange=[velocityM,velocityP],yrange=[min(yvector1),max(yvector1)]
AXIS,YAXIS=0
FOR i=0,Nbok(9)-3 DO BEGIN
PLOTS,V1,phase9(i)
PLOTS,V2,phase9(i),/CONTINU;,THICK=2.0
ENDFOR

Colorbar, FORMAT='(F3.1)',position=pBar1,/VERTICAL,/RIGHT,TICKNAMES=new, RANGE=[0.2,max(image1)], DIVISIONS=4,XTITLE='F/Fmax',CHARSIZE=1.5
XYOUTS, 0.50,0.94, 'RS Pup  P=41.5d',/NORMAL,CHARSIZE=2.5

; !P.Multi=0
DEVICE,/CLOSE
;set_plot,'x'






; !P.Multi=0
DEVICE,/CLOSE
set_plot,'x'

RV=DBLARR(101)
TEST=griddedDataLC_Halpha
TVSCL,TEST
help, griddedDataLC_Halpha
FOR y=0,100 DO BEGIN
PLOT,xvector1,griddedDataLC_Halpha(*,y)

pipo=MIN(griddedDataLC_Halpha(*,y),indice)
PLOTS,xvector1(indice),0
PLOTS,xvector1(indice),1,/CONTINU
RV(y)=xvector1(indice)
;WAIT,0.2
ENDFOR
PLOT,yvector1,RV

PRINT,'moyenne',MEAN(RV),SQRT(VARIANCE(RV))



END
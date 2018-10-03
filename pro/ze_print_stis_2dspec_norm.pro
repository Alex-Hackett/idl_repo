PRO ZE_PRINT_STIS_2DSPEC_NORM,fluxcr,lambda,vel,offset_arc,star_off,platesc,lambda0,pa,file,line,index,index2,index3,index4,colorbar_min,colorbar_max,midticks

aa=600.
bb=600.
ticklen = 15.
!x.ticklen = ticklen/bb
!y.ticklen = ticklen/aa
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
plot, vel, [-512*0.05,512*0.05], XTICKFORMAT='(I6)',xstyle=1,ystyle=1, xtitle='Velocity (km/s)', ytitle='offset (arcsec)',$
/NODATA, Position=[0.17, 0.12, 0.92, 0.90],charthick=1.2,XRANGE=[vel[index],vel[index2]] ,YRANGE=[offset_arc(index3)+star_off*platesc,offset_arc(index4)+star_off*platesc],$
title=file+' PA='+number_formatter(pa,decimals=1)+' '+line+' '+number_formatter(lambda0,decimals=2),charsize=2
;cropping image to the specified XRANGE and YRANGE

a=colorbar_min
;setting a to zero if less than a given threshold minimum, in order to avoid very low values as the minimum value
if ABS(a) lt 1e-10 THEN a=0.   
b=colorbar_max
img=bytscl(fluxcr,MIN=a,MAX=b); byte scaling the image for display purposes with tvimage
imginv=255b-img ;invert img
imginv=img
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
LOADCT, 13
;LOADCT,0
tvimage,imginv, /Overplot
;linear colorbar
div=midticks+1  ;number of divisions =number of middle tick values + 1 
yfin=dblarr(div+1)
FOR i=0, div DO yfin[i]=[a + i*(b-a)/div]
;colorbarv=[number_formatter(yfin[0],decimals=2),number_formatter(yfin[1],decimals=2),number_formatter(yfin[2],decimals=2),number_formatter(yfin[3],decimals=2),$
;number_formatter(yfin[4],decimals=2),number_formatter(yfin[5],decimals=2)]
colorbarv=strarr(div+1)
FOR i=0, div DO colorbarv[i]=number_formatter(yfin[i],decimals=2)

colorbar, COLOR=fsc_color('black'),TICKNAMES=colorbarv,DIVISIONS=div, xminor=0, /VERTICAL, /RIGHT,POSITION=[0.93, 0.12, 0.95, 0.90]
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[vel[index],vel[index2]] ,xcharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[vel[index],vel[index2]],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=0,YRANGE=[offset_arc(index3)+star_off*platesc,offset_arc(index4)+star_off*platesc],YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=2,YRANGE=[offset_arc(index3)+star_off*platesc,offset_arc(index4)+star_off*platesc],YTICKFORMAT='(A2)'

END
PRO ZE_PRINT_STIS_2DSPEC_NORM_VEL,pic2,fluxcr,lambda,vel,offset_arc,star_off,platesc,lambda0,pa,file,line,index1,index2,index3,index4,colorbar_min,colorbar_max,midticks

aa=900.
bb=760.
ticklen = 15.
!x.ticklen = ticklen/bb
!y.ticklen = ticklen/aa
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
plot, vel, [-512*0.05,512*0.05], XTICKFORMAT='(I6)',xstyle=1,ystyle=1, xtitle='Velocity (km/s)', ytitle='Offset (arcsec)',$
/NODATA,  Position=[0.16, 0.105, 0.85, 0.795*aa/bb],XRANGE=[vel[index1],vel[index2]] ,YRANGE=[offset_arc(index3)+star_off*platesc,offset_arc(index4)+star_off*platesc],$
title=file+' PA='+number_formatter(pa,decimals=1)+' '+line+' '+number_formatter(lambda0,decimals=2)

xyouts,620,1.08,'Sqrt(flux)',charthick=9,orientation=0,/DATA
xyouts,620,0.97,TEXTOIDL('[\times 10^{-7}]'),charthick=9,orientation=0,/DATA
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
LOADCT, 3
;tvimage,imginv, /Overplot ; original
tvimage,pic2,/Overplot
;linear colorbar
div=midticks+1  ;number of divisions =number of middle tick values + 1 
yfin=dblarr(div+1)
FOR i=0, div DO yfin[i]=[a + i*(b-a)/div]
colorbarv=strarr(div+1)
FOR i=0, div DO colorbarv[i]=number_formatter(yfin[i]/1e-7,decimals=1)
LOADCT,3
colorbar, COLOR=fsc_color('black'),TICKNAMES=colorbarv,DIVISIONS=div, xminor=0, /VERTICAL, /RIGHT,POSITION=[0.87, 0.105, 0.90, 0.90],charsize=1.5,charthick=9
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[vel[index1],vel[index2]] ,xcharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[vel[index1],vel[index2]]
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=0,YRANGE=[offset_arc(index3)+star_off*platesc,offset_arc(index4)+star_off*platesc],YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[offset_arc(index3)+star_off*platesc,offset_arc(index4)+star_off*platesc],YTICKFORMAT='(A2)'

END
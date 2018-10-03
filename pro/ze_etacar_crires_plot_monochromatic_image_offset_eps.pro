PRO ZE_ETACAR_CRIRES_PLOT_MONOCHROMATIC_IMAGE_OFFSET_EPS,img,a,b,imgname,cmi,cma,star,sub,row,offset_vector,aa,bb,lambda_val,lambda0

;for lambda0 in angstroms
vel_Val=ZE_LAMBDA_TO_VEL(lambda_val,lambda0*10^4)

set_plot,'x'

;capturing TRUE COLOR image of the 2D spectrum to pic2
window,retain=2,xsize=aa,ysize=bb
LOADCT,13 
tvimage,img,POSITION=[0,0,0.95,0.95]
pic2=tvrd(0,0,0.95*aa,0.95*bb,/true)
wdelete,!d.window

;plotting to PS file

ps_ysize=10.
ps_xsize=ps_ysize*aa/bb
ps_filename='/Users/jgroh/temp/'+imgname+'.eps'
set_plot,'ps'
device,filename=ps_filename,/encapsulated,/color,bit=8,xsize=ps_xsize,ysize=ps_ysize,/inches

!X.THICK=5.5
!Y.THICK=5.5
!X.CHARSIZE=2
!Y.CHARSIZE=2
!P.CHARSIZE=2
!P.CHARTHICK=5.5
ticklen = 15.
!x.ticklen = ticklen/bb
!y.ticklen = ticklen/aa
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
print,[min(offset_vector),max(offset_vector)]
plot, [(cmi-star-sub)*0.086,(cma-star-sub)*0.086], [min(offset_vector),max(offset_vector)],XTICKFORMAT='(F5.2)',xstyle=1,ystyle=1, xtitle='Spatial offset along slit (arcsec)', ytitle='Spatial offset perpendicular to slit (arcsec)',$
/NODATA, Position=[0.08, 0.18, 0.945, 0.86],XRANGE=[(cmi-star-sub)*0.086,(cma-star-sub)*0.086], YRANGE=[min(offset_vector),max(offset_vector)]
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
LOADCT, 13
;LOADCT,0
tvimage,pic2, /Overplot
nd=1
colorbar_ticknames_str = [number_formatter((b-a)*.0+a ,decimals=nd), number_formatter((b-a)*.2+a ,decimals=nd), number_formatter((b-a)*.4+a ,decimals=nd),$
number_formatter((b-a)*.6+a ,decimals=nd), number_formatter((b-a)*.8+a ,decimals=nd),number_formatter((b-a) +a ,decimals=nd)]
LOADCT,13
colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, /VERTICAL, /RIGHT,CHARSIZE=1.3,$
POSITION=[0.95, 0.18, 0.97, 0.86]

LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='Spatial offset along slit (arcsec)',XRANGE=[(cmi-star-sub)*0.086,(cma-star-sub)*0.086],ytickv=4
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[(cmi-star-sub)*0.086,(cma-star-sub)*0.086],ytickv=4,YTICKFORMAT='(A2)',xcharsize=0

AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[(cmi-star-sub)*0.086,(cma-star-sub)*0.086],ytickv=4,YTICKFORMAT='(A2)'
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=0,YRANGE=[min(offset_vector),max(offset_vector)],YTICKFORMAT='(A2)'
;AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=2,YRANGE=[(cmi-star-sub),(cma-star-sub)],ytickv=4,YTICKFORMAT='(I7.0)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=2,YRANGE=[min(offset_vector),max(offset_vector)],ytickv=4,YTICKFORMAT='(A2)'
xyouts,0.95,0.90,TEXTOIDL('F/Fmax'),/NORMAL,color=fsc_color('black')
xyouts,0.25,0.75,'v='+number_formatter(vel_val,decimals=0),/NORMAL,color=fsc_color('white'),charsize=4.5,charthick=11



device,/close_file
set_plot,'x'
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
!X.THICK=0
!Y.THICK=0
!X.CHARSIZE=0
!Y.CHARSIZE=0
!P.CHARSIZE=0
!P.CHARTHICK=0
END
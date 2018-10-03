PRO ZE_HRCAR_PLOT_LIGHTCURVE,hjd,yr_frac,mag,hjd_av
print,max(hjd),max(hjd_av)
t=n_elements(hjd_av)
xsize=900.*1  ;window size in x
ysize=460.*1  ; window size in y
PositionPlot=[0.13, 0.18, 0.91, 0.92]

set_plot,'ps'
!X.THICK=3.5
!Y.THICK=3.5
!P.CHARTHICK=3.5
!P.CHARSIZE=2.7
!Y.charsize=1.4
!X.charsize=1.4
!P.THICK=6
!X.THiCK=6
!Y.THICK=6
!P.CHARTHICK=6.5
!P.FONT=-1
device,/close


;******************************************************
;     SPHERICAL MODELS (DIFF MDOT) X OBS
;******************************************************
plotsym,1,3
device,filename='/Users/jgroh/temp/hrcar_lightcurve.eps',/encapsulated,/color,bit=8,xsize=10*xsize/ysize,ysize=10,/inches
plot,hjd,mag,yrange=[max(mag)*1.01,min(mag)*0.99],XTITLE='Heliocentric Julian Date - 50,000', YTITLE='V mag',$
/nodata,XTICKFORMAT='(I6)',xstyle=9,ystyle=1,Position=PositionPlot,XTICKINTERVAL=1000
plots,hjd,mag,color=FSC_COLOR('black'),noclip=0,psym=2
for i=0, t-1 DO BEGIN 
;xyouts,hjd_av[i],7.5,'!3'+string(45B),alignment=0.5,orientation=90,charthick=3.5
plots,hjd_av[i],7.5,psym=8,symsize=3
ENDFOR
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='',XRANGE=[min(yr_frac),max(yr_frac)]
device,/close

set_plot,'ps'

END
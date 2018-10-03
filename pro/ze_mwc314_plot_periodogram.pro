PRO ZE_MWC314_PLOT_PERIODOGRAM,power
xsize=900.*1  ;window size in x
ysize=460.*1  ; window size in y
PositionPlot=[0.12, 0.18, 0.91, 0.94]

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



plotsym,1,3
device,filename='/Users/jgroh/temp/mwc314_periodogram.eps',/encapsulated,/color,bit=8,xsize=10*xsize/ysize,ysize=10,/inches
plot,power(0,*),power(1,*),XRANGE=[0,200],XTITLE='days', YTITLE='Power',$
/nodata,xstyle=1,ystyle=1,Position=PositionPlot
plots,power(0,*),power(1,*),noclip=0
  
 
device,/close

END
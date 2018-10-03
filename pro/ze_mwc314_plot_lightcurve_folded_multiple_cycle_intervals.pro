PRO ZE_MWC314_PLOT_LIGHTCURVE_FOLDED_MULTIPLE_CYCLE_INTERVALS,hjd1,mag1,hjd2,mag2,hjd3,mag3,hjd4,mag4
xsize=900.*1  ;window size in x
ysize=460.*1  ; window size in y
PositionPlot=[0.15, 0.18, 0.91, 0.94]

set_plot,'ps'
!X.THICK=3.5
!Y.THICK=3.5
!P.CHARTHICK=3.5
!P.CHARSIZE=2.7
!Y.charsize=1.4
!X.charsize=1.4
!P.THICK=12
!X.THiCK=12
!Y.THICK=12
!P.CHARTHICK=12.5
!P.FONT=-1


;plotsym,1,3
device,filename='/Users/jgroh/temp/mwc314_lightcurve_folded_cycle_intervals_max_superimposed.eps',/encapsulated,/color,bit=8,xsize=10*xsize/ysize,ysize=10,/inches
plot,hjd1,mag1,yrange=[10.02,9.76],XRANGE=[0,2],XTITLE='Phase (assuming P=60.7 days)', YTITLE='V mag',$
/nodata,xstyle=1,ystyle=1,Position=PositionPlot
plots,hjd1,mag1,color=FSC_COLOR('black'),noclip=0,psym=2
plots,hjd1+1.0,mag1,color=FSC_COLOR('black'),noclip=0,psym=2 ;duplicate around phi=1
plots,hjd2,mag2,color=FSC_COLOR('blue'),noclip=0,psym=6
plots,hjd2+1.0,mag2,color=FSC_COLOR('blue'),noclip=0,psym=6 ;duplicate around phi=1
plots,hjd3,mag3,color=FSC_COLOR('red'),noclip=0,psym=4
plots,hjd3+1.0,mag3,color=FSC_COLOR('red'),noclip=0,psym=4 ;duplicate around phi=1
;plots,hjd4,mag4,color=FSC_COLOR('orange'),noclip=0,psym=5
;plots,hjd4+1.0,mag4,color=FSC_COLOR('orange'),noclip=0,psym=5 ;duplicate around phi=1
 
device,/close


offset=0.2

xsize=800.*1  ;window size in x
ysize=860.*1  ; window size in y
PositionPlot=[0.25, 0.28, 0.91, 0.94]

device,filename='/Users/jgroh/temp/mwc314_lightcurve_folded_cycle_intervals_max_offset.eps',/encapsulated,/color,bit=8,xsize=10*xsize/ysize,ysize=10,/inches
plot,hjd1,mag1,yrange=[10.02,9.16],XRANGE=[0,2],XTITLE='Phase', YTITLE='V mag',$
/nodata,xstyle=1,ystyle=1,Position=PositionPlot
plots,hjd1,mag1,color=FSC_COLOR('black'),noclip=0,psym=2
plots,hjd1+1.0,mag1,color=FSC_COLOR('black'),noclip=0,psym=2 ;duplicate around phi=1
plots,hjd2,mag2-offset,color=FSC_COLOR('blue'),noclip=0,psym=6
plots,hjd2+1.0,mag2-offset,color=FSC_COLOR('blue'),noclip=0,psym=6 ;duplicate around phi=1
plots,hjd3,mag3-2*offset,color=FSC_COLOR('red'),noclip=0,psym=4
plots,hjd3+1.0,mag3-2*offset,color=FSC_COLOR('red'),noclip=0,psym=4 ;duplicate around phi=1
;plots,hjd4,mag4-3*offset,color=FSC_COLOR('orange'),noclip=0,psym=5
;plots,hjd4+1.0,mag4-3*offset,color=FSC_COLOR('orange'),noclip=0,psym=5 ;duplicate around phi=1
 
device,/close



END
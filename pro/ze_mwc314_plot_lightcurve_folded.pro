PRO ZE_MWC314_PLOT_LIGHTCURVE_FOLDED,hjd,mag,magerr,phase2=phase2,mag2=mag2
xsize=900.*1  ;window size in x
ysize=460.*1  ; window size in y
PositionPlot=[0.15, 0.18, 0.91, 0.94]

set_plot,'ps'
!X.THICK=6.5
!Y.THICK=6.5
!P.CHARTHICK=6.5
!P.CHARSIZE=2.7
!Y.charsize=1.4
!X.charsize=1.4
!P.THICK=12
!X.THiCK=12
!Y.THICK=12
!P.CHARTHICK=12.5
!P.FONT=-1



plotsym,1,3
device,filename='/Users/jgroh/temp/mwc314_lightcurve_folded.eps',/encapsulated,/color,bit=8,xsize=10*xsize/ysize,ysize=10,/inches
plot,hjd,mag,yrange=[10.02,9.76],XRANGE=[0,2],XTITLE='Phase (assuming P=60.7 days)', YTITLE='V mag',$
/nodata,xstyle=1,ystyle=1,Position=PositionPlot
plots,hjd,mag,color=FSC_COLOR('black'),noclip=0,psym=2
plots,hjd+1.0,mag,color=FSC_COLOR('black'),noclip=0,psym=2 ;duplicate around phi=1
if n_elements(mag2) GT 0 THEN BEGIN
  plots,phase2,mag2,color=FSC_COLOR('red'),noclip=0,linestyle=0
plots,phase2+1.0,mag2,color=FSC_COLOR('red'),noclip=0,linestyle=0 ;duplicate around phi=1
endif

if n_elements(magerr) GT 0 THEN BEGIN
  oploterror,hjd,mag,magerr,psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('black')
  oploterror,hjd+1.0,mag,magerr,psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('black')
ENDIF ELSE BEGIN ;plotting sample errorbar in this case, assuming a typical error of 0.035 mag and that we are plotting in phase
  oploterror, 0.15,9.98,0.035,psym=0,color=fsc_color('red'),ERRCOLOR=fsc_color('red')
ENDELSE
  
 
device,/close

END
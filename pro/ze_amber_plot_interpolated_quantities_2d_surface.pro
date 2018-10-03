PRO ZE_AMBER_PLOT_INTERPOLATED_QUANTITIES_2D_SURFACE,x_vector,y_vector,quantity,data_spec,x1,x2,y1,y2,surface,a,b,xtitle,ytitle,lambda0,nd,line_epoch

xsize=900.*1  ;window size in x
ysize=560.*1  ; window size in y
width=20
PositionPlot=[0.12, 0.16, 0.91, 0.90]

set_plot,'ps'
;making psplots
!p.multi=[0, 1, 2]

!X.THICK=3.5
!Y.THICK=3.5
!P.CHARTHICK=3.5
!P.CHARSIZE=1.4
!Y.charsize=2.0
!X.charsize=2.0
!P.THICK=6
!X.THiCK=6
!Y.THICK=6
!P.CHARTHICK=6.5
!P.FONT=-1
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
Axis_color=fsc_color('black')
Axis_label_color=fsc_color('black')

device,filename='/Users/jgroh/temp/etacar_amber_'+quantity+'_lambda_pa_2D_'+line_epoch+'_2009.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
plot, x_Vector, y_vector, YTICKFORMAT='(F9.2)',XTICKFORMAT='(F9.2)',/NODATA , $
xrange=[x1,x2], $
yrange=[y1,y2],xstyle=1,ystyle=1,  xtitle=xtitle, ytitle=ytitle, Position=PositionPlot

LOADCT, 13
tvimage,surface, /Overplot
LOADCT,0,/SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
FOR I=0, n_elements(y_vector )-1 DO BEGIN
plots,[x2-(x2-x1)*0.95,x2-(x2-x1)*0.925],[y_vector[i],y_vector[i]],color=FSC_COLOR('black')
ENDFOR

zero_scale_spec=(y2-y1-data_spec.field1[6,0])
factor_scale_spec=3
plots,REFORM(data_spec.field1[0,*])*1e4,(REFORM(data_spec.field1[6,*]-data_spec.field1[6,0]) * factor_scale_spec) + zero_scale_spec, color=FSC_COLOR('white'),noclip=0

AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=Axis_label_color,XTITLE='Heliocentric velocity (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(x1,lambda0),ZE_LAMBDA_TO_VEL(x2,lambda0)]
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=Axis_color,XTITLE='',XRANGE=[ZE_LAMBDA_TO_VEL(x1,lambda0),ZE_LAMBDA_TO_VEL(x2,lambda0)],xcharsize=0
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=Axis_color,XTITLE='',XRANGE=[x1,x2]
AXIS,YAXIS=0,YSTYLE=1,COLOR=Axis_label_color,ycharsize=0,YRANGE=[y1,y2],YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=Axis_color,YRANGE=[y1,y2],YTICKFORMAT='(A2)'

LOADCT, 13,/SILENT
colorbar_ticknames_str = [number_formatter((b-a)*.0+a ,decimals=nd), number_formatter((b-a)*.2+a ,decimals=nd), number_formatter((b-a)*.4+a ,decimals=nd),$
number_formatter((b-a)*.6+a ,decimals=nd), number_formatter((b-a)*.8+a ,decimals=nd),number_formatter((b-a) +a ,decimals=nd)]
colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, /VERTICAL, /RIGHT,$
POSITION=[0.92, 0.16, 0.94, 0.90]

CASE line_epoch of
 'brg_pre': line_epoch_title=TEXTOIDL('Br \gamma')+' Pre 2009 event'
 'brg_dur': line_epoch_title=TEXTOIDL('Br \gamma')+' During 2009 event'
 'brg_pos': line_epoch_title=TEXTOIDL('Br \gamma')+' Post 2009 event'
 'hei_pre': line_epoch_title=TEXTOIDL('He I 2.06 \mu')+'m Pre 2009 event'
 'hei_dur': line_epoch_title=TEXTOIDL('He I 2.06 \mu')+'m During 2009 event'
 'hei_pos': line_epoch_title=TEXTOIDL('He I 2.06 \mu')+'m Post 2009 event'
ENDCASE

CASE quantity of
 'CP'     : quantity_title=TEXTOIDL('CP (^{\circ})')
 'DP12'   : quantity_title=TEXTOIDL('DP12 (^{\circ})')
 'DP23'   : quantity_title=TEXTOIDL('DP23 (^{\circ})')
 'DP13'   : quantity_title=TEXTOIDL('DP13 (^{\circ})')
 'Vis12'   : quantity_title=TEXTOIDL('Vis12 ')
 'Vis23'   : quantity_title=TEXTOIDL('Vis23 ')
 'Vis13'   : quantity_title=TEXTOIDL('Vis13 ')  
 'dVis12'   : quantity_title=TEXTOIDL('dVis12 ')
 'dVis23'   : quantity_title=TEXTOIDL('dVis23 ')
 'dVis13'   : quantity_title=TEXTOIDL('dVis13 ')    
  
ENDCASE

xyouts,0.93,0.92,quantity_title,/NORMAL,color=fsc_color('black'),charsize=2.
xyouts,0.5,0.2,line_epoch_title,/NORMAL,charsize=3.

device,/close

set_plot,'x'
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
!P.THICK=0
!X.THICK=0
!Y.THICK=0
!X.CHARSIZE=0
!Y.CHARSIZE=0
!P.CHARSIZE=0
!P.CHARTHICK=0


END